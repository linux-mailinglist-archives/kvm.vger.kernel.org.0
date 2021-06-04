Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAC39B078
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 04:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFDCgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 22:36:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:4758 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDCgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 22:36:46 -0400
IronPort-SDR: oabwGXq+UXKCSZApwd0+pBJdcmYLrgRpfg4IjCCR773u3Q995/BUMrfiZSlM++Rhfz5kkr4p32
 Bnbi0AuDUHqw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="204234224"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="204234224"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 19:34:58 -0700
IronPort-SDR: rjdrSJ+ijvQo4PQRqGmNYcrcCTslDGd3BQJSFWhy4TIn8oU2kEnwMt8cVOD3xoVHpozYrEwddw
 Z2fHJZADylmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="636444354"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2021 19:34:57 -0700
From:   Yi Sun <yi.sun@intel.com>
To:     yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to unittests.cfg
Date:   Fri,  4 Jun 2021 10:34:53 +0800
Message-Id: <20210604023453.905512-2-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210604023453.905512-1-yi.sun@intel.com>
References: <20210604023453.905512-1-yi.sun@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create ISO image according to the configure file unittests.cfg,
where describes the parameters of each test case.

Signed-off-by: Yi Sun <yi.sun@intel.com>

diff --git a/x86/create_iso.sh b/x86/create_iso.sh
new file mode 100755
index 0000000..8486be7
--- /dev/null
+++ b/x86/create_iso.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+set -e
+config_file=$1
+
+opts=
+extra_params=
+kernel=
+smp=
+testname=
+
+
+grub_cfg() {
+
+	kernel_elf=$1
+	kernel_para=$2
+
+	cat << EOF
+set timeout=0
+set default=0
+
+
+menuentry "${kernel_elf}" {
+    multiboot /boot/${kernel_elf} ${kernel_para}
+    boot
+}
+EOF
+
+}
+
+create_iso() {
+	case_name=$1
+	kernel_elf=$2
+	kernel_params=$3
+	if [ -f $kernel_elf ]; then
+		rm -rf build/isofiles
+		mkdir -p build/isofiles/boot/grub
+
+		cp $kernel_elf build/isofiles/boot/
+		grub_cfg ${kernel_elf##*/} $kernel_params> build/isofiles/boot/grub/grub.cfg
+
+		rm -rf ${testname}.iso
+		grub-mkrescue -o ${case_name}.iso build/isofiles 2> /dev/null
+		[ $? == 0 ] && echo "Creating ISO for case: ${case_name}"
+	fi
+}
+
+nline=`wc $config_file | cut -d' ' -f 2`
+
+while read -r line; do
+	if [[ "$line" =~ ^\[(.*)\]$ || $nline == 1 ]]; then
+		rematch=${BASH_REMATCH[1]}
+		if [[ "${testname}" != "" ]]; then
+			create_iso $testname ${kernel}.elf $extra_params
+		fi
+		testname=$rematch
+
+	elif [[ $line =~ ^file\ *=\ *(.*)\.flat$ ]]; then
+		kernel=${BASH_REMATCH[1]}
+	elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
+		smp=${BASH_REMATCH[1]}
+	elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
+		opts=${BASH_REMATCH[1]}
+		if [[ "$opts" =~ .*append\ (.*)$ ]]; then
+			extra_params=${BASH_REMATCH[1]}
+		fi
+	elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
+		groups=${BASH_REMATCH[1]}
+	fi
+	(( nline -= 1))
+
+done < $config_file
-- 
2.27.0

