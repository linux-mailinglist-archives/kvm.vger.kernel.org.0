Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72BA7B65
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 08:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfIDGP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 02:15:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:60359 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfIDGP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 02:15:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 23:15:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="173462883"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by orsmga007.jf.intel.com with ESMTP; 03 Sep 2019 23:15:53 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] doc: kvm: Fix return description of KVM_SET_MSRS
Date:   Wed,  4 Sep 2019 14:01:18 +0800
Message-Id: <20190904060118.43851-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can use ioctl KVM_SET_MSRS to update a set of MSRs of guest.
This ioctl sets specified MSRs one by one. Once it fails to set an MSR
due to setting reserved bits, the MSR is not supported/emulated by kvm,
or violating other restrictions, it stops further processing and returns
the number of MSRs have been set successfully.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v2:
  elaborate the changelog and description of ioctl KVM_SET_MSRS based on
  Sean's comments.

---
 Documentation/virt/kvm/api.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..4638e893dec0 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -586,7 +586,7 @@ Capability: basic
 Architectures: x86
 Type: vcpu ioctl
 Parameters: struct kvm_msrs (in)
-Returns: 0 on success, -1 on error
+Returns: number of msrs successfully set (see below), -1 on error
 
 Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
 data structures.
@@ -595,6 +595,11 @@ Application code should set the 'nmsrs' member (which indicates the
 size of the entries array), and the 'index' and 'data' members of each
 array entry.
 
+It tries to set the MSRs in array entries[] one by one. Once failing to
+set an MSR (due to setting reserved bits, the MSR is not supported/emulated
+by kvm, or violating other restrctions), it stops setting following MSRs
+and returns the number of MSRs have been set successfully.
+
 
 4.20 KVM_SET_CPUID
 
-- 
2.19.1

