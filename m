Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84C4C0AF1
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiBWETw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237797AbiBWETu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:50 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B27B3BA72
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:22 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id i17-20020a925411000000b002bf4c9c4142so11818521ilb.6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FNS4PyjEGxuJSaCVEOu72QQrSSYAZtKW2QUnGIVfau0=;
        b=e49Ue+JZMKJTF4FKVvs05LKdC7XnGotaG6I7g92j1SjIIS1FDLH1cN/N1EgS1P5ER+
         gah/IkXs0/E7eMhyaJG1u5bystIS2zgyEXKjvahD5csHmw6iNiaPVCNsuCKAujpio2x4
         x5h2Y66ca5V8RAvVKUdeUFdil43Yb/urcWb4FnhtRnCXPgeJLE2YgySa6eQJxpuDJeub
         LVjCsoTUqgB8NNAVskSi+oM+Jb0ENgqa5jZI21tOSFGXaYCGAhkduH5IHnjn+25Jhx+1
         zK5j2ka7vSR2+bvhw5Z9Ql0PqR2fqoidoh4i9qnIHMVtxgpRkiuQ5XWuf3uMkjt8aeqD
         XYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FNS4PyjEGxuJSaCVEOu72QQrSSYAZtKW2QUnGIVfau0=;
        b=DS+G0JMrTqdH811zM2op6LWlTnpWO7JjvJWwgoGy6Cn/5+co74zQCJ83LolzxWpJEd
         Ao8FFcv93a/PjUFFRUF/kGrPGWrUhpkZ67GL1Eq4dZfmP7GouxX0+FFLBIXYq9NTGOVz
         MGxOK8mGZVPn95uTn1qMP9bCnEElhlgA7jIzm3VPx+Sa9Grh5f51xaNc4l1qKC4N2aqF
         MwYh9+tz0a9J5dneEGabMFjubR9RbVXafKe/tFR6niR5tg7ozxPr9feXgMBqerdtWjc2
         Qfp8WQuyhlpUSSaYFprysjpXgFOouR863z1O6D8RMEz3zjNYfBzI5yShnm0iFrlLy/Hx
         OcXg==
X-Gm-Message-State: AOAM532Oo2ZaH6FRlFc9MKgkLw15BbLF1UDrDSbyyWu7RLyletojZxFA
        uKjm498zeon6TW0h8wRd6RIe7MOkxdM=
X-Google-Smtp-Source: ABdhPJzk4sIaIqCtMwTE2XY7UxiYHAN+OIvodZsnh0NYxLMGJieovAoGPOgba0C6vnJ4V/BJcawGQCT4v2w=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:26d3:b0:63d:aa17:8742 with SMTP id
 g19-20020a05660226d300b0063daa178742mr21631674ioo.198.1645589961514; Tue, 22
 Feb 2022 20:19:21 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:34 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-10-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 09/19] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
software to request that a system be placed in the deepest possible
low-power state. Effectively, software can use this to suspend itself to
RAM. Note that the semantics of this PSCI call are very similar to
CPU_SUSPEND, which is already implemented in KVM.

Implement the SYSTEM_SUSPEND in KVM. Similar to CPU_SUSPEND, the
low-power state is implemented as a guest WFI. Synchronously reset the
calling CPU before entering the WFI, such that the vCPU may immediately
resume execution when a wakeup event is recognized.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c  | 51 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c |  3 ++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 77a00913cdfd..41adaaf2234a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,6 +208,50 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
 }
 
+static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_reset_state reset_state;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu *tmp;
+	bool denied = false;
+	unsigned long i;
+
+	reset_state.pc = smccc_get_arg1(vcpu);
+	if (!kvm_ipa_valid(kvm, reset_state.pc)) {
+		smccc_set_retval(vcpu, PSCI_RET_INVALID_ADDRESS, 0, 0, 0);
+		return 1;
+	}
+
+	reset_state.r0 = smccc_get_arg2(vcpu);
+	reset_state.be = kvm_vcpu_is_be(vcpu);
+	reset_state.reset = true;
+
+	/*
+	 * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
+	 * calling vCPU) be in an OFF state, as determined by the
+	 * implementation.
+	 *
+	 * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
+	 */
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, tmp, kvm) {
+		if (tmp != vcpu && !kvm_arm_vcpu_powered_off(tmp)) {
+			denied = true;
+			break;
+		}
+	}
+	mutex_unlock(&kvm->lock);
+
+	if (denied) {
+		smccc_set_retval(vcpu, PSCI_RET_DENIED, 0, 0, 0);
+		return 1;
+	}
+
+	__kvm_reset_vcpu(vcpu, &reset_state);
+	kvm_vcpu_wfi(vcpu);
+	return 1;
+}
+
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -343,6 +387,8 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
 		case PSCI_1_0_FN_PSCI_FEATURES:
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
@@ -352,6 +398,11 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 			break;
 		}
 		break;
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		return kvm_psci_system_suspend(vcpu);
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f879a8f6a99c..006e7a75ceba 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -215,7 +215,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  *
  * Note: This function can be called from two paths:
  *  - The KVM_ARM_VCPU_INIT ioctl
- *  - handling a request issued by another VCPU in the PSCI handling code
+ *  - handling a request issued by possibly another VCPU in the PSCI handling
+ *    code
  *
  * In the first case, the VCPU will not be loaded, and in the second case the
  * VCPU will be loaded.  Because this function operates purely on the
-- 
2.35.1.473.g83b2b277ed-goog

