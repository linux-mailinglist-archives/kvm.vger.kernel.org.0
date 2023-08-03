Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCC076EBB2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbjHCOCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbjHCOB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:29 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B15211F
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:57 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6b9e478e122so871590a34.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071253; x=1691676053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UgQi9LDUX4k3lR2Q2FdA6BSSL1gShj19us97XhXguU=;
        b=ICE7tPcGWwrSBFFCkEwRFCKGrJiitZ33RQSEP5SXsq0rz8HNeps+M1nXALn5mGkx3l
         /UY9H1rMQnfL7Oc5HKzi3UzSHuecUctTdD/ZSj+yVL5Kk/zozy8v7AXHFDe788wB2tUz
         py0+oElvUGjWFK3eTk35tQ/Vb2cyINuCsbUhFPEzNNKZ8QQXuSnljxngNwzPqc3rNBy/
         udiBb7jEkf3cFj8/N7LPZ1G0huwxtfAazsq2f/PbTJmRNbtPhK61Z/iygXBpthX7idAu
         aHj2l//XFR59okmzmOZDQxvhJZK6aa4HjH/kS5AYfOfT+SSoMJi+9Hs9vUynsJ8dXjuf
         JGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071253; x=1691676053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UgQi9LDUX4k3lR2Q2FdA6BSSL1gShj19us97XhXguU=;
        b=AlsT0vFW91GmR1RqBy9zLDwfZ8sH8xSc8JA83kKoZP0WDgbZuazFwICvTLMr/CJlSL
         P4YA+2BNstX7tltfn5vQscSOvXkHOXGSaAuii1dJfBzXHgGq2NnGcMcPvHaZ0jfccjfI
         90Y/HGjBvg+M+miJEzU8njIgO/a1nehvzdVX5+6t/zkNrKq9Qxvolr8538hToAR4xErN
         C9Ev5VjVVib56SWT0+b5egjJiap15FcRopGSojztw6KVoBYIGALDdaiMwKRen/8s6obU
         F/mX/eRyH7Rpklj3DXd68ztHdINw4QXXF/ZEZA1WN4KOb1rR3TS3PnLIdavFKgCUdJmj
         Viug==
X-Gm-Message-State: ABy/qLay8Wj6k8Ldm+gVXS6FqWiwk3iOZqxOXpmx0b/H0c3XALm0noVJ
        7RwqboW0BbKKDxnPZNzwf7W5rQ==
X-Google-Smtp-Source: APBJJlEJ7XVge9+sqybuLluuJAUuShjWkmg3bWllK2pZ8dTvF2tT43lRWqnDUx8VRtN4MazF30GSvA==
X-Received: by 2002:a05:6830:12c1:b0:6b8:6a83:2b17 with SMTP id a1-20020a05683012c100b006b86a832b17mr18904714otq.33.1691071253133;
        Thu, 03 Aug 2023 07:00:53 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:52 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 08/10] RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
Date:   Thu,  3 Aug 2023 11:00:20 -0300
Message-ID: <20230803140022.399333-9-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
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

riscv_vcpu_set_isa_ext_single() will prevent any write of isa_ext regs
if the vcpu already started spinning.

But if there's no extension state (enabled/disabled) made by the
userspace, there's no need to -EBUSY out - we can treat the operation as
a no-op.

zicbom/zicboz_block_size, ISA config reg and mvendorid/march/mimpid
already works in a more permissive manner w.r.t userspace writes being a
no-op, so let's do the same with isa_ext writes.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 818900f30859..fcfe2049effd 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -482,6 +482,9 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
 		return -ENOENT;
 
+	if (reg_val == test_bit(host_isa_ext, vcpu->arch.isa))
+		return 0;
+
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
 		 * All multi-letter extension and a few single letter
-- 
2.41.0

