Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE357880B
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiGRRFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbiGRRFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7A2BB03
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so13234173pjl.4
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yTc6DPtRL3G/t0xkTGIGozwG47F+csFvT/B18Fnd6bA=;
        b=FzhoHCa1YsaXYQ8x7nWgTmqf0KgVR4ynTwb6sSm5eIdHHC8iMhZW6RP3czhrR5n8g/
         X2JKnvYBb1H58qTMZKXWi9CM1ZQO1mXLe07lVJd/+LwRh8tfBcmzbSFcotIZJhPLOUWu
         aehAPylHZQU7yz4IYfdL02Wz2JwbZBANg72NQqo5gHm2pA6TKHd81Ze1FoShkQs4WMAt
         J+F55ANKBQ+2NGW0+hnosnafLochQp/Rt3MrI+yMQtV7Uur5M1fuFzysZl9w/7EcuczN
         G2ZkIM824pXrYATCqnGXtVd4QVts+VWdN9ZLCDXaCjhqlcydUTORkG9xZukPNK7yHSzu
         CVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yTc6DPtRL3G/t0xkTGIGozwG47F+csFvT/B18Fnd6bA=;
        b=YGNUWCXNFdoQ7OYWq2rgEifT/pDb3pVM2BGEd1e2rwtw0CVyQTgb7UPwY4XsVg3wmA
         OYDbTRYqU+oFxEd06IJ8QWCvsyh25E7YTT7WzTSZWW4qHFhc+JVtLgA5CAgwn0xtKVJ/
         Z6Eh9LP/afHoMO63Af61mB7nTtupThx8aa6ONh98QPtfhJcUHEsbcpXYAX8eTdeVz94W
         6Zvx1W/RbHctaI/h8FZ/2YfCc0u3KLnjuuZ8oNBzfhYS0DSJz9iFuy5GakesnsbED0AE
         pC59CcRCX2FLLiUfq8NY4zr2Qc3CIJskXYF9nbQm5+2INLrn0R8UmmFgQGRWe/Fg3M/P
         l82g==
X-Gm-Message-State: AJIora8UEicb5pcbV5h6Zh5jNwFmgeJCcYs7FXOYAz7b2zB97F6X4u1j
        b69B7iw2AzWYQ6iAdtJpjPoLmg==
X-Google-Smtp-Source: AGRyM1vW5t5W2twVvakvKZTko7lrN5ufYsRsPOvNvHFZUUuebHERK+y/x9Mil/Ly2FlTRRbMLZDwYg==
X-Received: by 2002:a17:90a:ca14:b0:1f1:664a:241 with SMTP id x20-20020a17090aca1400b001f1664a0241mr17356543pjt.184.1658163947139;
        Mon, 18 Jul 2022 10:05:47 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:46 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC  3/9] RISC-V: KVM: Define a probe function for SBI extension data structures
Date:   Mon, 18 Jul 2022 10:01:59 -0700
Message-Id: <20220718170205.2972215-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718170205.2972215-1-atishp@rivosinc.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

c,urrently the probe function just check if an SBI extension is
registered or not. However, the extension may not want to advertise
itself depending on some other condition.
An additional extension specific probe function will allow
extensions to decide if they want to be advertised to the caller or
not. Any extension that do not require additional dependency check
does not required to implement this function.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
 arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 83d6d4d2b1df..5853a1ef71ea 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -25,6 +25,9 @@ struct kvm_vcpu_sbi_extension {
 	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
 		       bool *exit);
+
+	/* Extension specific probe function */
+	unsigned long (*probe)(unsigned long extid);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 48f431091cdb..14be1a819588 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -22,6 +22,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	struct sbiret ecall_ret;
+	const struct kvm_vcpu_sbi_extension *sbi_ext;
 
 	switch (cp->a6) {
 	case SBI_EXT_BASE_GET_SPEC_VERSION:
@@ -46,8 +47,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			 */
 			kvm_riscv_vcpu_sbi_forward(vcpu, run);
 			*exit = true;
-		} else
-			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
+		} else {
+			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
+			if (sbi_ext) {
+				if (sbi_ext->probe)
+					*out_val = sbi_ext->probe(cp->a0);
+				else
+					*out_val = 1;
+			} else
+				*out_val = 0;
+		}
 		break;
 	case SBI_EXT_BASE_GET_MVENDORID:
 	case SBI_EXT_BASE_GET_MARCHID:
-- 
2.25.1

