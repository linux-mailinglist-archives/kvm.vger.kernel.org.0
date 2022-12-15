Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0754264DF2F
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 18:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiLORBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 12:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiLORBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 12:01:18 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528E0264A9
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:01:16 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so3278550pjm.2
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmOKelhxXQczHTID3SM97kUHKPqlhsoeVDKTVsi4pDE=;
        b=M/x6Webfdw2/xEVgUjm/3euBweIF6ONa/tPWCh85rYYCknuNs2Zud5/f8I3G/wZU5b
         rrrNYegH6IFVTS4KlbBgDjZgb+iuoJwEWJLqoKvZxFEsIOb52j4dO9L0o1AGK8fb7O81
         BI2fI848yBcMDT1j0MPDQaKV/1/PBvWFrsQ/L4wDih29c1+VHAfsfSAqGJ9fO/pVZcmj
         mHbTjQjK0medb6WIp2rZ9joI3XtSc5NJvFlRKREO2F/6e/kQx21y933t1IJtMEkSdW+l
         Np3flGCnWtOpAO8HZbH34eX36OLMgW8MmER1SLfSfqID6dgu/xV/SA4vGF4yTHmHPuVZ
         3+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GmOKelhxXQczHTID3SM97kUHKPqlhsoeVDKTVsi4pDE=;
        b=LDwVY3YpvcagvQQ3QUDR4crXz1/X4Kixf18t6rSlExgUncjT2tg1eMN4+3CD65fEWh
         mgJnZ6NdqE7jC2BBupWvhm9pczlmLE8V96liCgoTI1RB3rPplQfSu2KNblW0kmxuRv6b
         2VnklUPiTIlGbzot2i7Xk0UddeMB2byQbYHVzCXJY7hT9rLbE1B6oeflMoN9SMRFhkcQ
         7FTMF+RiPIT/y+hhk3HpUsvM/d1xYwR9PRc3T1Z1xUHy/+KDsdMvIFGMP/YjBcd+kpP8
         BdVPSmv4WUZKEZBiPF4QioPjkS024+L+Mq/IVBA6Jg9pyeRzdOd1leFV3b92T5cEireF
         QZww==
X-Gm-Message-State: ANoB5plqX7r0BVEgD7idiOqufHZr+5oq6WP4WOdwr3FlX03/OUor0QMs
        LhQrtbywxsnZwiqLgGhqYNEHrw==
X-Google-Smtp-Source: AA0mqf4TLCt2teX6XTB8t7vev1QAhHcvWBHIfgCgZ8onADiiluFB6jj7/tzzvBe40YjGUu2C1tDaRg==
X-Received: by 2002:a17:902:7005:b0:189:dc47:fe40 with SMTP id y5-20020a170902700500b00189dc47fe40mr28685531plk.15.1671123675948;
        Thu, 15 Dec 2022 09:01:15 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b001897bfc9800sm4067449pll.53.2022.12.15.09.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:01:15 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v2 03/11] RISC-V: KVM: Return correct code for hsm stop function
Date:   Thu, 15 Dec 2022 09:00:38 -0800
Message-Id: <20221215170046.2010255-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221215170046.2010255-1-atishp@rivosinc.com>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
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

According to the SBI specification, the stop function can only
return error code SBI_ERR_FAILED. However, currently it returns
-EINVAL which will be mapped SBI_ERR_INVALID_PARAM.

Return the appropriate linux error code.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 2e915ca..0f8d9fe 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.power_off)
-		return -EINVAL;
+		return -EPERM;
 
 	kvm_riscv_vcpu_power_off(vcpu);
 
-- 
2.25.1

