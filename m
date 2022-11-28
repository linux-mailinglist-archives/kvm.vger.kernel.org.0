Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB063AD6F
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiK1QPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiK1QPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:15:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122BC24BE3
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:00 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jn7so10608054plb.13
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hv1OFha79GkiviE0uDMGNS7exO8nWxI6HdONFPzodJA=;
        b=lqSNnSKbWlZ374V5w1PVkdsGEI3ifekQqCTHz1J8U2HZjC+qA2twMy4VL0AEBUMCZq
         YlVw/udi8rz6lWI6K5sg5aKFW4rmOunzSL+MhQFVRuwhVeQzSAhebIAU14uB4oVjvCqq
         D8KstXofbeugtPgqSLS1GOjivEnhF0SXoDoEXhZm6ka44+q9OOxiuFEh3aInV5zPuw/W
         DBhuvqTxSIIcygMAKPvxVkBC2KcF9udOi+NUfmXJZY0RgndFe+I3sBv2esLSSM0n3ERr
         w8WAggDnqRUs4gOPYWhALfXR6aReh98SeHWE3VFdVmOIUCvnVbRhjDcUn479ZGbIAbz9
         Tm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hv1OFha79GkiviE0uDMGNS7exO8nWxI6HdONFPzodJA=;
        b=OvJjoFMCh/pTufunxPfRAhPGX3LkhS1HjpLbVkIlTg+2TtaEELXBXWXcPoQqHfnLqo
         PWEsmW8jq5jdDzW6aYZhGYUme8ve20uCSYl4rSa5eDMwY3JIdg+EB8NDHvDvemPes4ES
         YuBItX1NMrffpS+w+Qsbjz7Z4YY0IxFGNawIK77U9fJjSi7K/kGM+g4DjES81KS3kQqr
         bEjaA5DhuTO8kEwiRqsMS/4bfyV0qj+w70MjiE3S0YsKHeT2KZSzUHpRWbh6QpkdYHUI
         4m+/X8tXG3KFzrBmYUyqycDjJ2TZKu0Jp4UyxWx1U17BJkdUQPZgk21vcuTMuDX2z+vT
         LXtQ==
X-Gm-Message-State: ANoB5plg3JbEpqxVeof94lrRaMgqiZft+grI9xCrgzP9Uq5klPTgaAkg
        4FuwytIvR1CSE3mAzAdAGhFZmQ==
X-Google-Smtp-Source: AA0mqf6XVMcPFzw8jclMeBq51f+TGiw5TkI7SlXYuc+xtAmSnBI3XLt+ndtlCp6fYKA2CDEFePuEjg==
X-Received: by 2002:a17:902:d893:b0:188:542a:68d8 with SMTP id b19-20020a170902d89300b00188542a68d8mr34593125plz.126.1669652099425;
        Mon, 28 Nov 2022 08:14:59 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:14:59 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 6/9] RISC-V: Export sbi_get_mvendorid() and friends
Date:   Mon, 28 Nov 2022 21:44:21 +0530
Message-Id: <20221128161424.608889-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sbi_get_mvendorid(), sbi_get_marchid(), and sbi_get_mimpid()
can be used by KVM module so let us export these functions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kernel/sbi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 775d3322b422..5c87db8fdff2 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -627,16 +627,19 @@ long sbi_get_mvendorid(void)
 {
 	return __sbi_base_ecall(SBI_EXT_BASE_GET_MVENDORID);
 }
+EXPORT_SYMBOL_GPL(sbi_get_mvendorid);
 
 long sbi_get_marchid(void)
 {
 	return __sbi_base_ecall(SBI_EXT_BASE_GET_MARCHID);
 }
+EXPORT_SYMBOL_GPL(sbi_get_marchid);
 
 long sbi_get_mimpid(void)
 {
 	return __sbi_base_ecall(SBI_EXT_BASE_GET_MIMPID);
 }
+EXPORT_SYMBOL_GPL(sbi_get_mimpid);
 
 static void sbi_send_cpumask_ipi(const struct cpumask *target)
 {
-- 
2.34.1

