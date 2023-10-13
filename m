Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B17B7C7E4E
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 09:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjJMHAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 03:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjJMHAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 03:00:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05998BC;
        Fri, 13 Oct 2023 00:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697180448; x=1728716448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jng7bfQEwvP3gJa6uLB/Fj7/UznUBVzpNHYATvjIsQE=;
  b=V6x2iAGi0Bzr57grEwjXsCjioSePjfQMF6TOFdMH/rgHDswLJ1C3SR6L
   ghHVoAQw03mA9OpJ4lYAF734GtUHl+1C5VI0n2ZqtobV2QFPYSobgoTLv
   TLTutDrH4tzBXO50/vW+CtGjEe9KQ0u+BLitqUr+/bcMvHbJYhMIihBOQ
   8ncClYSFf0JlnElLypwKHF7fbthT3YquCf6KHN4rUSU9XTJDF62X1Wrvg
   fw9ju4RzETowC0mQ35tR5z95G/5FaNp9lrwELpHsT9bnA8+vFRVdW0l8O
   bQqft2KjsJWTWsdnhZ0emWl/IVtOuxD+nYJv3BDn4cpkDnU65HP537qV/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="384954907"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="384954907"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 00:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="731244246"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="731244246"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga006.jf.intel.com with ESMTP; 13 Oct 2023 00:00:39 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: x86: Use the correct size of struct kvm_vcpu_pv_apf_data and fix the documentation
Date:   Fri, 13 Oct 2023 03:00:37 -0400
Message-Id: <20231013070037.512051-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The size of struct kvm_vcpu_pv_apf_data is 68 bytes, not 64 bytes.
Fix the kvm_gfn_to_hva_cache_init() to use the correct size though KVM
only touches fist 8 bytes.

Fix the documentation and opportunistically refine the documentation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/x86/msr.rst | 22 +++++++++++-----------
 arch/x86/kvm/x86.c                 |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 9315fc385fb0..27bcd49e46b9 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -192,9 +192,9 @@ MSR_KVM_ASYNC_PF_EN:
 data:
 	Asynchronous page fault (APF) control MSR.
 
-	Bits 63-6 hold 64-byte aligned physical address of a 64 byte memory area
-	which must be in guest RAM and must be zeroed. This memory is expected
-	to hold a copy of the following structure::
+	Bits 63-6 hold 64-byte aligned physical address of a 68 bytes memory
+	area which must be in guest RAM. This memory is expected to hold a copy
+	of the following structure::
 
 	  struct kvm_vcpu_pv_apf_data {
 		/* Used for 'page not present' events delivered via #PF */
@@ -220,7 +220,7 @@ data:
 	#PF exception. During delivery of these events APF CR2 register contains
 	a token that will be used to notify the guest when missing page becomes
 	available. Also, to make it possible to distinguish between real #PF and
-	APF, first 4 bytes of 64 byte memory location ('flags') will be written
+	APF, first 4 bytes of 68 byte memory location ('flags') will be written
 	to by the hypervisor at the time of injection. Only first bit of 'flags'
 	is currently supported, when set, it indicates that the guest is dealing
 	with asynchronous 'page not present' event. If during a page fault APF
@@ -232,14 +232,14 @@ data:
 	as regular page fault, guest must reset 'flags' to '0' before it does
 	something that can generate normal page fault.
 
-	Bytes 5-7 of 64 byte memory location ('token') will be written to by the
+	Bytes 4-7 of 68 byte memory location ('token') will be written to by the
 	hypervisor at the time of APF 'page ready' event injection. The content
-	of these bytes is a token which was previously delivered as 'page not
-	present' event. The event indicates the page in now available. Guest is
-	supposed to write '0' to 'token' when it is done handling 'page ready'
-	event and to write 1' to MSR_KVM_ASYNC_PF_ACK after clearing the location;
-	writing to the MSR forces KVM to re-scan its queue and deliver the next
-	pending notification.
+	of these bytes is a token which was previously delivered in CR2 as
+	'page not present' event. The event indicates the page is now available.
+	Guest is supposed to write '0' to 'token' when it is done handling
+	'page ready' event and to write '1' to MSR_KVM_ASYNC_PF_ACK after
+	clearing the location; writing to the MSR forces KVM to re-scan its
+	queue and deliver the next pending notification.
 
 	Note, MSR_KVM_ASYNC_PF_INT MSR specifying the interrupt vector for 'page
 	ready' APF delivery needs to be written to before enabling APF mechanism
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..fc253d54cbd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3427,7 +3427,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u64)))
+					sizeof(struct kvm_vcpu_pv_apf_data)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);

base-commit: 5804c19b80bf625c6a9925317f845e497434d6d3
-- 
2.34.1

