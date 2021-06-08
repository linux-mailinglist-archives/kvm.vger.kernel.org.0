Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B739F8AE
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhFHOOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:53 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:57142 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhFHOOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:53 -0400
Received: by mail-qt1-f201.google.com with SMTP id i24-20020ac876580000b02902458afcb6faso5242468qtr.23
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B0iSDc0/tfWTjM0OiK/d0I79Av2Tsf7eBHAfhQ1/w18=;
        b=qZLlP031k4bAxuV3xFN0znqp9f45FgJRklrHgZ65e3zrJ4iLgv7UpIhS/BxGRmUlvZ
         W8YOje7/QZd/aKd482Qo26LuzScXPYsr6deeIMM5nHwol8M1CR/knY+mNYcAmqXxoA13
         ByT9S00WgviUIMhMnjOxh99XER6Nt8uclt3xzms0NPIqTuk3e0DHhGJgDoFqlBjYrY9u
         vti0G+jeskHwqPptf9WhoHD4Eb2+OKxYQPCqW3jitebR1O4rm6eD7uy5QOdqilzklNZ5
         9s5eej8SeYigZQSYp6NZbe/h7ijD0bqMoIqt0yA3V/bUWMhjMenHusy0MHbc3b8PL0up
         wjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B0iSDc0/tfWTjM0OiK/d0I79Av2Tsf7eBHAfhQ1/w18=;
        b=BZ/52bOUY2QF0AQ/a7nc3OF1Ilp/UAYo7kj2mUZVUmJWPSBEvMse+UXnZNg1HZU/kX
         OdtKcuafiqD/UtopK+okc41tUPYtzWUIL69KjfP2dFINH1JoX3/KKTguZ6q+XcPWRdLf
         SqIcIMqdBNOxnhmsJ/DSsgN9r1SJqV4aGvDcNZUdUPzltfX3dtzbM4ZkejZkj+meP5Fj
         3tNHfBWH6rVKCH/5JMUojxcQgWZhsJZIUViz9wmBSSycpMa3C94fHb02C+3kPi2X0xmR
         NXZCf/m0Wy0ghZdPWBnYTkKkEpTxaYXKeWTCDqQ+dITOrm400vq77fIsQDxc3tOapuLM
         TLVw==
X-Gm-Message-State: AOAM532DlFef2fj9gZtZS6gWZLVwu6O5B4MnIkXl2dCIZddTbOgqJM75
        z/Xj3JxvecvERgtL3hFY/9N1Pnx6vw==
X-Google-Smtp-Source: ABdhPJy50ae7MBl1TZMdXHIJsYZ+eEpkC//wo2fuZnsGPUYbZ9gs5lWxYjfTVx35+m/lQNpYnvyKL0W1Iw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:258b:: with SMTP id
 fq11mr192225qvb.1.1623161519488; Tue, 08 Jun 2021 07:11:59 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:36 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-9-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an array of pointers to handlers for various trap reasons in
nVHE code.

The current code selects how to fixup a guest on exit based on a
series of if/else statements. Future patches will also require
different handling for guest exists. Create an array of handlers
to consolidate them.

No functional change intended as the array isn't populated yet.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..f5d3d1da0aec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	if (is_nvhe_hyp_code())
+		return kvm_get_nvhe_exit_handler(vcpu);
+	else
+		return NULL;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -412,6 +424,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	exit_handle_fn exit_handler;
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -492,6 +506,11 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	exit_handler = kvm_get_hyp_exit_handler(vcpu);
+	if (exit_handler && exit_handler(vcpu))
+		goto guest;
+
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 430b5bae8761..967a3ad74fbd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -165,6 +165,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+static exit_handle_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= NULL,
+	[ESR_ELx_EC_CP15_64]		= NULL,
+	[ESR_ELx_EC_CP14_MR]		= NULL,
+	[ESR_ELx_EC_CP14_LS]		= NULL,
+	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_HVC32]		= NULL,
+	[ESR_ELx_EC_SMC32]		= NULL,
+	[ESR_ELx_EC_HVC64]		= NULL,
+	[ESR_ELx_EC_SMC64]		= NULL,
+	[ESR_ELx_EC_SYS64]		= NULL,
+	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_IABT_LOW]		= NULL,
+	[ESR_ELx_EC_DABT_LOW]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
+	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
+	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
+	[ESR_ELx_EC_BKPT32]		= NULL,
+	[ESR_ELx_EC_BRK64]		= NULL,
+	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_PAC]		= NULL,
+};
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	return hyp_exit_handlers[esr_ec];
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

