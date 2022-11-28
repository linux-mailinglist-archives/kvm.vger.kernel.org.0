Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7E63AD66
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiK1QOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiK1QOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:14:44 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D775F76
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso6631950pjb.1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7x0oTKpsWp1eBMVcd2HvR7GLV5FrDh1MXNEuBtWibU=;
        b=GdZOldmSeoejY/4MEdz+TDxR+dEPbxAHB2nFoU0GWyxVoxQhUERCL+ZxaQCp1JkRK0
         KhzMcM1nrUYd9KYVlLYnbC17ODw/dUbnRoGsYGB7y8iw08CP2OMlbZ3Tdu9Ag7j8rSoN
         QOUXNtJ7qcbTfXaMrwQ05eXW3JnpLDLGReoYynXAGlFdrLOjgPNGnBBxxoLDR2kwPy2B
         vD+qzpsMtpHy8F1xF7IG3RsR+xK1Ofxq2aXVIUqCjhZC8W0HpDEbv39lHq38zVTbxttZ
         rDWQtzL4WRfsED+a1UfPwP1DqwSyIvz7n72G4HGVBcspcAQCONIAtb+597M9SqvswxVw
         GmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7x0oTKpsWp1eBMVcd2HvR7GLV5FrDh1MXNEuBtWibU=;
        b=znyMOmI4iY+ZLyXum+hZwkSlTRjeqzR0l3B6dguif1T0YzLJ6CEy02dy/02K8M7CgG
         6VQZ5th9PNb3Abb0ME4oEHB8h3kN+nZ6C8C7LoixYPql+hQZjWcXp1cW42j6vmfxuLr9
         EwcDwRLIwUlAAG8aOCBvgf+yLK/zPbUxhp2uZb3ZeSC7XI33DsKd/jKGE5BBA0OozAwp
         js6P6tbVNVEYCNoVGGc29173nuEiZVPTnIjvUXH+HpaXSsjUEh4ICpGxwTyy9xaXRJ25
         KivG44XODqMYZBD5HgL+vOkUu3YOIXlURGbVvPH0Hmy8v7YNkPTX0BVm8ymLJNI4F63G
         YfUg==
X-Gm-Message-State: ANoB5pmRmoHkSpI9ULqJ+lXedbTV6y4hyBiBO9gGnYHKcBm1uHJnog4x
        xCvf7jOCEuYulx7L4tA6MR0+hg==
X-Google-Smtp-Source: AA0mqf6a4nNMoI9Pp6ntgyunakgkDq9LNUMsEe3B51BBv8WT18Ot9XuFrO2+cmOg/sKUyAgU98S8SQ==
X-Received: by 2002:a17:902:e886:b0:188:fb19:5f39 with SMTP id w6-20020a170902e88600b00188fb195f39mr36071752plg.21.1669652083071;
        Mon, 28 Nov 2022 08:14:43 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:14:42 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/9] RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
Date:   Mon, 28 Nov 2022 21:44:17 +0530
Message-Id: <20221128161424.608889-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The asm/kvm_vcpu_timer.h is redundantly included in vcpu_sbi_base.c
so let us remove it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 48f431091cdb..22b9126e2872 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -12,7 +12,6 @@
 #include <linux/version.h>
 #include <asm/csr.h>
 #include <asm/sbi.h>
-#include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-- 
2.34.1

