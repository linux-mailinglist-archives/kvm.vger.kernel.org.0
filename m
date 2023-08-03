Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5106076EF8E
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbjHCQda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbjHCQd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:27 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE98C30E2
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:25 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1bbb4bddd5bso813247fac.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080404; x=1691685204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mu19x8hfUH10MYfTjpP1RF1Ut52SK1pMVXhmwflqSgo=;
        b=TpvWicxWFYBiktBxgQXprDfHQhi710ZNwh4iGPKDpbCU/Bvhfjek9JiF1dQ2N3M/fS
         Ph39nnqBvjqk+T1167JKk+ymWTagirpcR2W3t9daD/GyK/yB5qEDfw0L7YEg1AzITc4H
         Q3okzjb0hoB55w56MJp7/rUu9OMylkceruThMCRTUQw5doWxdoeOOh8CX5bHRipt0pjq
         +ecomc3SRll5frP13G8eqWLz6x/Ln1sDXaIMCP7UXAZgIKkYxre/m3CqJCFAmgmxyUVd
         s9U2tYKlZozhRjwUXaFzen8vTx3VI+Z3Hq1X3dP4pO7my5+oU0awjlkxQHx1BNofnJrS
         svHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080404; x=1691685204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mu19x8hfUH10MYfTjpP1RF1Ut52SK1pMVXhmwflqSgo=;
        b=lCVKGVQtm/rSIM4iUn5Fj0WrwAVV6LPTf4DNqT1fB1ydSRQFQKSiEoiPQ/D/lee2CO
         XgOK6rm66pBKJH3+bAZ2DkAsgj5RTtF1jKIV7LkwdBfpxxfqamOFe+TPiF6cyASPPgIE
         Cc7NJNvKhTwbKaAscueqKIquglzO/Qd2mOpYIt1/fh/v+IjLSkSv1KNmvi6AayM49lDo
         y6SwprMXHY9sBA4hmYQZ3oOPIyAphkNBTW1+2S8r3o2N0vWFZv+Gpa422aS0oLYwXXo6
         D5Azpfm+X0oVl/zTOm7X7+x/aj9FnvbwkWG8Mc+QKUjmHwhCl1ONuaYJjk1QIMxTqNQG
         jS2A==
X-Gm-Message-State: ABy/qLbq4bUIf0a0/NEaYuNtga2bpEtRo7h3ly46eT/8kGz3/3tfU347
        xgqkTw6mbhPGUfK6tYW2AGhcIA==
X-Google-Smtp-Source: APBJJlG263MxMOlhWr+lUKGc/wweZv2EVJn1qhDZ7kk7BlzsBVSKt9RLtfuD9s11IUfZLBrI6BZ4Pg==
X-Received: by 2002:a05:6870:970f:b0:1b7:1904:1ad9 with SMTP id n15-20020a056870970f00b001b719041ad9mr22111121oaq.53.1691080404645;
        Thu, 03 Aug 2023 09:33:24 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:24 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 06/10] RISC-V: KVM: avoid EBUSY when writing same ISA val
Date:   Thu,  3 Aug 2023 13:32:58 -0300
Message-ID: <20230803163302.445167-7-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_riscv_vcpu_set_reg_config() will return -EBUSY if the ISA config reg
is being written after the VCPU ran at least once.

The same restriction isn't placed in kvm_riscv_vcpu_get_reg_config(), so
there's a chance that we'll -EBUSY out on an ISA config reg write even
if the userspace intended no changes to it.

We'll allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace made
no changes to the ISA config reg.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 971a2eb83180..a0b0364b038f 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -190,6 +190,13 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
 			return -EINVAL;
 
+		/*
+		 * Return early (i.e. do nothing) if reg_val is the same
+		 * value retrievable via kvm_riscv_vcpu_get_reg_config().
+		 */
+		if (reg_val == (vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK))
+			break;
+
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the enable/disable request for certain extensions */
 			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-- 
2.41.0

