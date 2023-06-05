Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5355722B88
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjFEPm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjFEPmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:12 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A13910E7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-650bacd6250so2632991b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979691; x=1688571691;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=iCFGyw/jcSbZ7dkgZNFFY73VpPKL7Q1jzPShY52xxnw02H0ROZZFhfGGq3FqayLf/9
         ly/kcUznEUd13mFhS/4fFO0qsVJw0y7zessKqUQZU5NYl6XJcbETE9k3+VI3bfzauzN7
         KOEhJZQBlfqFkkj7kiD5/x7M9Zp7OcrRMiOPXiOKMidQEl0myq3nIzfLZJE265Cwp48D
         DDq5QMhhZdBRrQS9dtk77EVtO4TVDZnUl5Qad7SUHDInY2r3au1wJLjBQilARUexc6fi
         kIVKgoAMwyvK5anHoyXJrR4fWgwo9fP3Yc4FflfywJfMtK2rosH5S/oUSimheAPTH8mQ
         SzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979691; x=1688571691;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=TROFcGJfZXpIxR4q6y4DOFKnx+RdPKJaShkKPmiv+Pj3Mjew7oMuY8TLC9oZoXZSgL
         OqLykP9XsP2rtzbKyaHIJaZaCuNJ2pFQqpry69j7FlnqVm/4CVeEoYR1ARjI1eIv8Zb4
         fRF7tBbMNb19oVykYs2OJfkOzLqBk7/r5tBTUksQLc68+wbHl692tp+Crb9qPkPck4H3
         T/nUeJQqMHDdiUEov8qodbtu7+t6zhei+e0+Lp3uaDkTXKwPNuEAst/sL4aB8bPhSKDw
         2cete2A3ke6VwHp0es1aJBc8xSx1nRW0/hDkCPXQvCozjD0o4yeGItoTYp1PGwK3wLre
         V9gg==
X-Gm-Message-State: AC+VfDwTlEy1VnVIX4w3FaFbzZwpW2HR1crHUFcgR5ShOyiQNChIrqXs
        Y7wJV/iDqhuO+SaojHZBJZ3BRA==
X-Google-Smtp-Source: ACHHUZ4zcDskmXzgjybyy5dRFrqQcD6alz9N7UbXNzqeE3JhCcVu+yZ7RCDNiKVpRYqrwdECITUOcQ==
X-Received: by 2002:a17:902:7045:b0:1ae:8b4b:327d with SMTP id h5-20020a170902704500b001ae8b4b327dmr3443354plt.42.1685979691044;
        Mon, 05 Jun 2023 08:41:31 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:30 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v21 18/27] riscv: kvm: Add V extension to KVM ISA
Date:   Mon,  5 Jun 2023 11:07:15 +0000
Message-Id: <20230605110724.21391-19-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

Add V extension to KVM isa extension list to enable supporting of V
extension on VCPUs.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f92790c9481a..8feb57c4c2e8 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -121,6 +121,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8bd9f2a8a0b9..f3282ff371ca 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
-- 
2.17.1

