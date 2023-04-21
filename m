Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA86EAF92
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbjDUQve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbjDUQvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A5415621;
        Fri, 21 Apr 2023 09:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095854; x=1713631854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ShCn5EdxlHC9p8Zub2u6/B6bWzPI1MqNtjLonRx9vjY=;
  b=itN/oTXcJD1sQStLqiU5/aIQpQkCT2KptDvWKQ61PXau/dD4ZYkv5wuA
   3QQ0xBUFyrX4FnosWQE5HX0b3seFThWnoDrYQBiFcSJiWxYKup+OzB4+j
   5Z6swcIyIVSXrjO6bk4v55FKrZ/MgKGqgUrIIZvI3Yse3sdBM3tYtzRyo
   uIN9n4bY2JbLjIhS8D5JxZ3tlW1/qugmRXfF/EqBGnHSmpZbCCzDCNDBs
   bMXkWWi0m71uKUY6Mv5X6d4YDxSQ8BTPeFKH8TvAmCH0r/rQTTVVK7t7x
   wov43euKqzT2WGzykRpipUI3xkqNesto+Q/Kvsv7BUh6kc0XAO8YhVPam
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787010"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787010"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817389"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817389"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:43 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 09/21] KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs
Date:   Fri, 21 Apr 2023 09:46:03 -0400
Message-Id: <20230421134615.62539-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Load the guest's FPU state if userspace is accessing MSRs whose values are
managed by XSAVES so that the MSR helpers, e.g. kvm_{get,set}_xsave_msr(),
can simply do {RD,WR}MSR to access the guest's value.

If new feature MSRs supported in XSS are passed through to the guest they
are saved and restored by XSAVES/XRSTORS, i.e. in the guest's FPU state.

Because is also used for the KVM_GET_MSRS device ioctl(), explicitly check
@vcpu is non-null before attempting to load guest state. The XSS supporting
MSRs cannot be retrieved via the device ioctl() without loading guest FPU
state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed
to access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2975ca96ac5..7788646bbf1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -130,6 +130,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -4336,6 +4339,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+static const u32 xsave_msrs[] = {
+	MSR_IA32_U_CET, MSR_IA32_PL3_SSP,
+};
+
+static bool is_xsaves_msr(u32 index)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xsave_msrs); i++) {
+		if (index == xsave_msrs[i])
+			return true;
+	}
+	return false;
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -4346,11 +4364,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
+		    is_xsaves_msr(entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
-- 
2.27.0

