Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E726DB8A4
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjDHDuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 23:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHDuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 23:50:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45692CC13
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 20:50:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c193-20020a25c0ca000000b00b868826cdfeso18830709ybf.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 20:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680925801; x=1683517801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eQXKVk5bYBI9kU8FS6e9Eu8uo6AIYsLflVePzrnFLQ=;
        b=SvK9ArDgnmx3fnPqMxJtEL2EA8PQv5DaUsFb6ZhMPOQepiwwC73rxTSDunhfEkk/hU
         lIrPhL/eSC9EoyNsh2z9zTlSbXOc8aC1/gI0pXPrSjcY/WGhzGHiOZVJXXMH0Ne4Zm3Q
         woXlPoIZ/UBXaFlpUwYfR2e16fwzEEUkotPHhtuzo6vYP7RviWYk1/hG+eBoul5Cvqiw
         uw4a0Jx5+5Uzsbt2ouA3tcov2AMkRU42V3r4BS4uKeoppaj3o8Kh0J8mEY+kWv7f7a26
         R0PWrAw6cB0T32t0JvK7/BT50X9Yzgu6qCZ7KGQ+eiL0FwPr39lUs0epEeITVdvkS8Th
         69ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680925801; x=1683517801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eQXKVk5bYBI9kU8FS6e9Eu8uo6AIYsLflVePzrnFLQ=;
        b=iFlwd2R41Mr5j1M+K2CMk64431xM/O8rtTQzZGF1yAwBVHwMtB0Q7QBDy8UcFs30SF
         nn/yFQh2JsLtvcrxOZrcVeQtD7ZennXI5icqR9SddtvGOztdKXqMyDUP4LsZ1AWLIBaZ
         0hp5JF6a9agCetJmT/uUSD1NkPvfpGmeEn3OvkxZE3pM/aQ1Olse2P3ezlni6NY06uPT
         ymbZ4g+ckx/cfGc5+N/183BvsKkWI9tuFvLkQP1tHKOx20Gu8vLZeMkXOf8vN4Ao+BjX
         C+es0Ere/8zvv9/UmM6JN/vsNs/rOmVKCZC+1YQ1/neth/xg56fi0yNXRvteYhou58XU
         JWCA==
X-Gm-Message-State: AAQBX9cRgYXV7JKj4BAkyxAyLauT0Hhrs9ovcViQb3jbaPAO6MmS13jQ
        oJpsghgIzfOnGtUSo738zrGjVuyHKPc=
X-Google-Smtp-Source: AKy350aQRt6i1U1RtZLFdPCYuwN2ajZD+RcM1fazysdk8uRYX0B7k4CJYjFtfCXeA2/8+WqTdrbecudjLxI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:cfcf:0:b0:b8b:f1ac:9c6c with SMTP id
 f198-20020a25cfcf000000b00b8bf1ac9c6cmr3106735ybg.3.1680925801503; Fri, 07
 Apr 2023 20:50:01 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:47:58 -0700
In-Reply-To: <20230408034759.2369068-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230408034759.2369068-2-reijiw@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
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
a direct access to PMU registers (some bits of PMUSERENR_EL0 for
might not be zero for the host EL0).

Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..6718731729fd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -81,7 +81,12 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * EL1 instead of being trapped to EL2.
 	 */
 	if (kvm_arm_support_pmu_v3()) {
+		struct kvm_cpu_context *hctxt;
+
 		write_sysreg(0, pmselr_el0);
+
+		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
@@ -105,8 +110,12 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
-	if (kvm_arm_support_pmu_v3())
-		write_sysreg(0, pmuserenr_el0);
+	if (kvm_arm_support_pmu_v3()) {
+		struct kvm_cpu_context *hctxt;
+
+		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
+	}
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-- 
2.40.0.577.gac1e443424-goog

