Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD41176EB86
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbjHCOBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjHCOBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:01 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854E8171D
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:35 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-55b8f1c930eso644947eaf.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071235; x=1691676035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuntyFMMxpMt9nVYv2KUnVvoZk1tiTsim5h+Q7JzZX8=;
        b=KUQRcqqCueLtkJkANl19wC4Ex0o/jB54dilgf2d02Q32lrdsx++M+hB39W/CXU3YyK
         bo+Loa/oW6hV9AOQ+GIlJVcT9NOrm69AaFSDgYWu4FS6/v0BmL8adcbrVUJkgJuSWw6u
         AVfNmwTVBr2IeSVFRQKcvEfgw0qhm2V3+ak3vcyBc5MsI/xR30Cg+k94AZERuNNHmC4u
         Dl6c00qwNTSm9q0xQG0lTt+MtUQnVKXeswRiJiLKVuk+Ws/LX4SVL5uvmOXA4Yo8EUVE
         1klTiBzn1l5kQDmOHjGIxb6KrVcByUtIgPICSovlNvYip8cGd0IG74rX4f8Mxw+IpyXv
         hydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071235; x=1691676035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EuntyFMMxpMt9nVYv2KUnVvoZk1tiTsim5h+Q7JzZX8=;
        b=U/8Lx4jPnQ+dAY9lSlCReEKRYbgoxEZkQFV28B8rdJ5jrZ0sm0QaKsUBOdxt7OZpsS
         4tlOOqZSe3bDLCgyaMWcYSQn5XXkeJgLn8NWgpVhx5xfVaPNQUgmCbphtLfi87hzSYkm
         vpdjUI8ZcVK8+ng67M44cQDBLMv1FxD6pGUSTy8Nx79CJhK6Z4d4UpYabG1YMzLGIeQF
         TVo9NSCsFb06sCeY7RghM5sjXEmG+wRFOosuUmuj8yLq+iT9uWp3O5Jj49Q9P/bJuMuO
         gyZ5LWJGIe5uZqe6mdSBb4vJ4uI0KFDeTD/UBZQwFbp/TxWzMBa/cNcmbb96kTZL6CCx
         rjkQ==
X-Gm-Message-State: ABy/qLZxeC5fgGnVe8UV2sEv8PAYSyBh1lVHILNACHhErbnjSdY31VQA
        0r/K0hPn3cwveiXKTNyKiaF8dQ==
X-Google-Smtp-Source: APBJJlElQYAvKgaEkiCseTai7Ue5DF/IRbGwTrYye5MVdAFIKDUk1Iv8VYnMebTd0sXI3edCmkyW9A==
X-Received: by 2002:a05:6870:818a:b0:1bb:6133:fb07 with SMTP id k10-20020a056870818a00b001bb6133fb07mr22300012oae.3.1691071234813;
        Thu, 03 Aug 2023 07:00:34 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:34 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 02/10] RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
Date:   Thu,  3 Aug 2023 11:00:14 -0300
Message-ID: <20230803140022.399333-3-dbarboza@ventanamicro.com>
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

Following a similar logic as the previous patch let's minimize the EINVAL
usage in *_one_reg() APIs by using ENOENT when an extension that
implements the reg is not available.

For consistency we're also replacing an EOPNOTSUPP instance that should
be an ENOENT since it's an "extension is not available" error.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 65607f80f8db..546f75930d63 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -135,12 +135,12 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
 		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
-			return -EINVAL;
+			return -ENOENT;
 		reg_val = riscv_cbom_block_size;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
 		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
-			return -EINVAL;
+			return -ENOENT;
 		reg_val = riscv_cboz_block_size;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
@@ -459,7 +459,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return	-EOPNOTSUPP;
+		return -ENOENT;
 
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
-- 
2.41.0

