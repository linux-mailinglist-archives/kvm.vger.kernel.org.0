Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED75E545B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiIUUQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiIUUQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 16:16:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CECA78BC4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:16:14 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g24-20020a056a00079800b0054b1a110543so4091295pfu.2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=gADxGD3M+iWlkeq6JJoA+zipD9oPqMfH/FDJZbo9W8k=;
        b=dYJhkoXFX6b09AesK77GzgwjsJP150V80OHAJ8ei1sYqvUFapGXol5fi5V/hKIqMr6
         PYlucJZqSS18InQIlMZUVDAxyNhdjgumX6DUM5daD6mxqxi4exTGVvx+5s55YmzDYwl9
         XPZC3EvSQzavcTt9UWfqD3Q+c28BXoXfPvCps2kSTH/5cq6e7A5OMu3TFI9mkBwQF6Wh
         Vhw8nmDaijp1zPmYgm81t5/kZ28+8JXhxCvQGAGId/3F5hgALR+fvCT5ARGp2rY4rO4r
         XkhmTLbeT/P5Sey2XIrHiMf8EUAUOmhKeUPS7ke+5RoKPcoUGhv54GBPNXDUj2BCvpf5
         PbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=gADxGD3M+iWlkeq6JJoA+zipD9oPqMfH/FDJZbo9W8k=;
        b=KK6ujHzs49Gwf5vaQc4U1ZNwrd2xJhswpMZwj2djp0umTJhLLAq5CYV+wjwUC268XB
         6f0zVbcvdAT3+IOynzQqgrE5aXPvOdbYsZBacdimhcbL/BF2gHJE4Zg837iciB+oacLv
         +T2a0lwuxN4gIxmORZllYRlDL8vWh2nt7+eP5R7wtVL70LNnpGuQUr7XJNBKFJywwe29
         wy5jbmZgS5FZz3lzKVce98u1BFbB+M9mqbsPslg2Btg8TOvwRO32NzVVFYxfyZ/yAQvR
         k5FQJK0mugJKC5Ht0OzRCdBXSntoCVmfJqdF5O9fkUBNV7XgXx8rYpnOxOcgoVbYS8fe
         Gbjg==
X-Gm-Message-State: ACrzQf06zbo5nmb+ILAR5T8VUacyIFBoq8akTnnziY+ddzrXPihrjCvX
        lWgy5TmjEQY3DZHrDCE43BcaXKWwpbU=
X-Google-Smtp-Source: AMsMyM7F3SVf5CZTUMNETS+vKu7ldPw6wGwZamZOlHlXMP4FGTeESf4cAMADtfuimHIlsvqvdbg+qJqH/cY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2187:b0:541:ca61:48b7 with SMTP id
 h7-20020a056a00218700b00541ca6148b7mr30562304pfi.83.1663791374328; Wed, 21
 Sep 2022 13:16:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 20:16:06 +0000
In-Reply-To: <20220921201607.3156750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921201607.3156750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921201607.3156750-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments
From:   Sean Christopherson <seanjc@google.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a union to provide hv_enlightenments side-by-side with the sw_reserved
bytes that Hyper-V's enlightenments overlay.  Casting sw_reserved
everywhere is messy, confusing, and unnecessarily unsafe.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h                        |  7 ++++++-
 arch/x86/kvm/svm/nested.c                         |  9 ++++-----
 arch/x86/kvm/svm/svm.h                            |  5 ++++-
 arch/x86/kvm/svm/svm_onhyperv.c                   |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                   | 15 +++++++--------
 tools/testing/selftests/kvm/include/x86_64/svm.h  |  5 ++++-
 .../selftests/kvm/x86_64/hyperv_svm_test.c        |  3 +--
 7 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..6befed2b30a6 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -5,6 +5,8 @@
 #include <uapi/asm/svm.h>
 #include <uapi/asm/kvm.h>
 
+#include <asm/hyperv-tlfs.h>
+
 /*
  * 32-bit intercept words in the VMCB Control Area, starting
  * at Byte offset 000h.
@@ -161,7 +163,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 76dcc8a3e849..a6a87d9743ce 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -201,8 +201,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct hv_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
@@ -391,8 +390,8 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
 		to->clean = from->clean;
-		memcpy(to->reserved_sw, from->reserved_sw,
-		       sizeof(struct hv_enlightenments));
+		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
+		       sizeof(to->hv_enlightenments));
 	}
 }
 
@@ -1485,7 +1484,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
-	/* 'clean' and 'reserved_sw' are not changed by KVM */
+	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
 }
 
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..9eb2fc76732f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -151,7 +151,10 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 struct svm_nested_state {
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 8cdc62c74a96..5d4036611a37 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -26,7 +26,7 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;
 
-	hve = (struct hv_enlightenments *)to_svm(vcpu)->vmcb->control.reserved_sw;
+	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
 
 	hve->partition_assist_page = __pa(*p_hv_pa_pg);
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 8d02654ad6f8..c8f8045305be 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -18,8 +18,10 @@ int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
+
+	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
+		     sizeof(vmcb->control.reserved_sw));
 
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
@@ -61,18 +63,15 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	if (hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
 }
 
-static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
-		struct kvm_vcpu *vcpu)
+static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 {
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 	u32 vp_index = kvm_hv_get_vpindex(vcpu);
 
 	if (hve->hv_vp_id != vp_index) {
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 10b9d0d4e0ec..0c32549c6b64 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -123,7 +123,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
 	 */
-	u8 reserved_sw[32];
+	union {
+		struct hv_enlightenments hv_enlightenments;
+		u8 reserved_sw[32];
+	};
 };
 
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index b366b197759f..81b204ee509a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -46,8 +46,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-	struct hv_enlightenments *hve =
-		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+	struct hv_enlightenments *hve = &vmcb->control.hv_enlightenments;
 
 	GUEST_SYNC(1);
 
-- 
2.37.3.968.ga6b4b080e4-goog

