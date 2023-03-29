Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737836CCEB2
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 02:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjC2AWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 20:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC2AWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 20:22:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00651737
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g187-20020a2520c4000000b00b74680a7904so13654975ybg.15
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M9VEYqg/OD1okwRTmN4uX/z0exuBfdAWAGm4G9tIIbA=;
        b=cogAFos4A80Hq8+t7GQy2mKfxVx3APH3a1KXMCXu7X/Ftmir6SwV/tqrbmvoyJV6/G
         2Ln6du+IarOLF0lqN4pFV71t1o3gztK8xBtNYgxZEc+rO8yCGMELfozjOMMWvnWq6Ie6
         lw+XRBp+AUzc2OfkHb0EEqO6gGrCdqfI0U8b8Mg5GwGINrpd9B+/YmRxAixj7MdKPoe1
         lySTkVLKGijW9ROYl46XIe+OR0Ao4qRHlfp/mq8zcTLuvsXKLceeDDVuhiXFh5GIQwOe
         97BbRju/HlGwDxqp+BaFRCg+z7D74wMA4nXoK5NY8BFHqXjum7uu0MPk0UANnwwS/sPp
         sLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9VEYqg/OD1okwRTmN4uX/z0exuBfdAWAGm4G9tIIbA=;
        b=hCRlWog88fZ6XTuMMrn6qhaeBrZBAy4R+BMP3e6YzTsnFKf8Hd66fe+DKQ7PDCJCji
         dTOwCYRmC0oWoPpZH0QZckoiF+EE0QNxhECkAGTU4S5M2Dl1UFv12MHu80Jqavh83pl3
         F5z1u17sSUyyASMojURWEQESukaWDhnTyQav8mCrt86HNTt5Gcz2Jl9VVDaT3gaqcmZX
         EhV75dprnEpffj4h+NcWscvUu/V6/saWsEnXDc3ehJpuLYav8iXHS/5HWmPdW3fwLZzW
         +1cz0uiu272CTN2HnwsRs6j88VtCoD408hoiZ9PMjomSWAfHjhSdQYV58RVS8AK44iD9
         4dMQ==
X-Gm-Message-State: AAQBX9ceIHH/meqETLchwEQ3RPbo6N83s6V/a1/Do9TgBYT4yJWHuDRj
        WJtI7GjvurPOQKiGwuiy1dvNooWHnjg=
X-Google-Smtp-Source: AKy350b63N/z5xs9NWQe+Xzd9HYhlJjhHJ9wsmtc2tjjz7mh4ninFi18LOOb1YEpPeCHA5TDzNeRfFgcGVw=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:168d:b0:b26:47f3:6cb with SMTP id
 bx13-20020a056902168d00b00b2647f306cbmr8882729ybb.4.1680049312210; Tue, 28
 Mar 2023 17:21:52 -0700 (PDT)
Date:   Tue, 28 Mar 2023 17:21:35 -0700
In-Reply-To: <20230329002136.2463442-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230329002136.2463442-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329002136.2463442-2-reijiw@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the host's PMUSERENR_EL0 value instead of clearing it,
before returning back to userspace, as the host's EL0 might have
a direct access to PMU registers (some bits of PMUSERENR_EL0
might not be zero).

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..82220ecec10e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -544,6 +544,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu CCSIDR override or NULL */
 	u32 *ccsidr;
+
+	/* the value of host's pmuserenr_el0 before guest entry */
+	u64	host_pmuserenr_el0;
 };
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..44b84fbdde0d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -82,6 +82,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arm_support_pmu_v3()) {
 		write_sysreg(0, pmselr_el0);
+		vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
@@ -106,7 +107,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
-		write_sysreg(0, pmuserenr_el0);
+		write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-- 
2.40.0.348.gf938b09366-goog

