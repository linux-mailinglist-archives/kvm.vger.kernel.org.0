Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5376EF90
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbjHCQdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbjHCQdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:35 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50833C28
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:30 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1bb7297c505so824565fac.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080410; x=1691685210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu7FCUVMhVtaI44cD7BULzw6bJMgB622Gr+5DTVj+Bo=;
        b=e12fuyl/YeJW953kPJERxGswpaMryJfjjQq5sl9Yem3wu5CKheDWM4PHRd9wrva1/v
         4sYjysYxyTzeleQoRLmGAoIrz6i53KB+5pN6QEBvd8YGCnmqAOwXRvk5TL1Fzvrad8NZ
         ztbHG14xtJX9GlwW/5i12PKzkbjbEq6nfInqEgx6E5fd48liIlI8S4OdfhvWCBR67rYq
         MWhWNtPXtZXtA/bHvzvlxSHgdSLNJZvV2LUCzFG+I+clFEb0kwbpKgzJN/DPJDsR77G9
         b5Yhc+yuvmgyx8fhHM1LNsOkHTADyBKnOe0cxx1yCnmadGe/wMkfpiLrk4uVmD2WGAQh
         vwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080410; x=1691685210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uu7FCUVMhVtaI44cD7BULzw6bJMgB622Gr+5DTVj+Bo=;
        b=jLGVY7H9XL9EuiT1987sDjlDPyEEnK88NVLbxyhmOvPyWVFn+cDC6rvEUzYPAAayAP
         FafYm2S4ir7otjO4UC1BwPgEZN15PPNRgJmdbUvrN81Sl9pWx9LlEramo3MPg7n+9i3x
         C89ZG07MEiNFakoL/qsuRi7newjb4nVkPBAtDG8TAj4KaAHOx/jsWYeK2+G8mNaUMXV0
         H1YWSpT4kStWDjxYgfK7wmzuO22L0nsQCR4Rv5i2U49Uhds2khV0bG5iPWkCcVFK/rdc
         a2BFZD1mmQPFOM7ciI7aSPN+KQb0AoYDq96j2qmY3+vmMwrcwBVqt6g5WJFo4KJgrmYn
         DXzQ==
X-Gm-Message-State: ABy/qLYRfdNGe/+S4uc8ww8lMtdPOeN0AIaL/ZGncRefaNS5ONSNKHA6
        5mTLeZN5xPFa64/Jo1579ZRMhg==
X-Google-Smtp-Source: APBJJlGwoCOFRPCchOHL4r61LhHvmGfZ6gIxkUR9qlClLMHYy95T1Eeoqxo6LJktGRsLHTWo1iCCLg==
X-Received: by 2002:a05:6871:283:b0:1bb:5af8:701f with SMTP id i3-20020a056871028300b001bb5af8701fmr17924948oae.23.1691080409822;
        Thu, 03 Aug 2023 09:33:29 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:29 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 08/10] RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
Date:   Thu,  3 Aug 2023 13:33:00 -0300
Message-ID: <20230803163302.445167-9-dbarboza@ventanamicro.com>
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
index 81cb6b2784db..989ea32dbcbe 100644
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

