Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4756E27DE
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjDNQA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjDNQA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:00:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816CABB8A
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so7560069pla.3
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681488037; x=1684080037;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Odmz0JG+bEL0mEy4+sqiyjpf0XMQ6vVYrEOWb5kBhbI=;
        b=FOctlegUDtDv3ZHjXnrQJCTB/Q6yyurIgcxUtsUoFzS7dn8jftYmLbD+75EhDZA2Cr
         zRVATn8/u7h4RXGHOq10e69KRyHc/0+D/hBly1p5VO/Y1tdMTqJaNtb7RYGA/nhmWAf3
         08pNFxl+FwPz9dxOalOIoXewTsF8wfk9yyojXsNQOUEFPUe2AB/bSHL2WyxhicJcsa5i
         0nU6KQQTrq7QW8967WdAfAJ6sVx/21Z1pTNb/OINlieAIVJVwXtmwsASd+1L+42QsLIg
         fCWGcV29bYX2+zTqwJe446i9FzP9Dm83skLE4j0C2s1H+FWSddrMeia1ROtHi4sZWwCw
         3h4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488037; x=1684080037;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Odmz0JG+bEL0mEy4+sqiyjpf0XMQ6vVYrEOWb5kBhbI=;
        b=HFwqPbmTi3eR0zI1ga5kx0W2cJO8SGob49Hcwlae0hQEoBUtzkm6Yea7TfjLAJ5slc
         LqWvdJyE2CYHdFVeu4lQa1Txa97wqAofNHpEmtRPkHhmjHxs78V0Zs5S6WHAwQCUlFZu
         HkeiVe3y2yZNJGJhxDT6OsY07A6BZUZZukKl/5HFL+q9tVutv6vJd2hXaTgcmZRDWv/T
         PAwa4bk+JnFAfTYXd9sbYmEzi24Cq6kRSp/3RZxj6SA+RnuPE/vrdFvDxNpL6QE733JU
         RoDPUYYFPnC9D1w5HQR/5oNYa+fnhb7yDaJEMVJ6C8eQH/uqIsBZVGlunjZsNUe8AGGe
         oewg==
X-Gm-Message-State: AAQBX9f99wOXf19CapeYvEsTyCHzk+RL9l07+zCKWGvvRAnVMwW9VncL
        8O35gWor5pyB/h80S7VonSuoAw==
X-Google-Smtp-Source: AKy350bD7mze/O0+fYsB9lpeXlbduhlDKv44rIlF3vXS+82oFbA62wV5LVEzKRe2kkBUE5wMisk7Nw==
X-Received: by 2002:a17:90a:a091:b0:247:4538:a62e with SMTP id r17-20020a17090aa09100b002474538a62emr1878454pjp.27.1681488036960;
        Fri, 14 Apr 2023 09:00:36 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.09.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:00:36 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v18 17/20] riscv: kvm: Add V extension to KVM ISA
Date:   Fri, 14 Apr 2023 15:58:40 +0000
Message-Id: <20230414155843.12963-18-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index e44c1e90eaa7..d562dcb929ea 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -107,6 +107,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
 	KVM_RISCV_ISA_EXT_ZICBOZ,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6adb1b6112a1..bfdd5b73d462 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
-- 
2.17.1

