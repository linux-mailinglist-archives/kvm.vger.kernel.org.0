Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050B73BA5D4
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhGBWKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:10:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:15304 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234181AbhGBWJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:09:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168428"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168428"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:33 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814908"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:32 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v2 68/69] KVM: TDX: add document on TDX MODULE
Date:   Fri,  2 Jul 2021 15:05:14 -0700
Message-Id: <b5d0446fedfe5d47a8aa5e623f39cb04d62837ce.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a document on how to integrate TDX MODULE into initrd so that
TDX MODULE can be updated on kernel startup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/tdx-module.rst | 48 +++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/virt/kvm/tdx-module.rst

diff --git a/Documentation/virt/kvm/tdx-module.rst b/Documentation/virt/kvm/tdx-module.rst
new file mode 100644
index 000000000000..8beea8302f94
--- /dev/null
+++ b/Documentation/virt/kvm/tdx-module.rst
@@ -0,0 +1,48 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========
+TDX MODULE
+==========
+
+Integrating TDX MODULE into initrd
+==================================
+If TDX is enabled in KVM(CONFIG_KVM_INTEL_TDX=y), kernel is able to load
+tdx seam module from initrd.
+The related modules (seamldr.ac, libtdx.so and libtdx.so.sigstruct) need to be
+stored in initrd.
+
+tdx-seam is a sample hook script for initramfs-tools.
+TDXSEAM_SRCDIR are the directory in the host file system to store files related
+to TDX MODULE.
+
+Since it heavily depends on distro how to prepare initrd, here's a example how
+to prepare an initrd.
+(Actually this is taken from Documentation/x86/microcode.rst)
+::
+  #!/bin/bash
+
+  if [ -z "$1" ]; then
+      echo "You need to supply an initrd file"
+      exit 1
+  fi
+
+  INITRD="$1"
+
+  DSTDIR=lib/firmware/intel-seam
+  TMPDIR=/tmp/initrd
+  LIBTDX="/lib/firmware/intel-seam/seamldr.acm /lib/firmware/intel-seam/libtdx.so /lib/firmware/intel-seam/libtdx.so.sigstruct"
+
+  rm -rf $TMPDIR
+
+  mkdir $TMPDIR
+  cd $TMPDIR
+  mkdir -p $DSTDIR
+
+  cp ${LIBTDX} ${DSTDIR}
+
+  find . | cpio -o -H newc > ../tdx-seam.cpio
+  cd ..
+  mv $INITRD $INITRD.orig
+  cat tdx-seam.cpio $INITRD.orig > $INITRD
+
+  rm -rf $TMPDIR
-- 
2.25.1

