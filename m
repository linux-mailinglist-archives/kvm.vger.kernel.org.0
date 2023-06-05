Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1465872281C
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbjFEOCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjFEOCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:02:46 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E1CE6
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:40 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-557d4a08bbaso2891540eaf.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973759; x=1688565759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=fP+SisgpNt7Lh2fyGzljyBPtkLHWkFIAndtkm4QK8WSMK5dd3PIzlHilLytjCnJQt3
         hbhXX0Jo1AoUKol7laQN+rOSWj8qkmI2vzLqDs1nS3tWN6xkTaTaXRskb9sDKOQREovN
         JuMP5z7OwmjOW2+4x715Yd6eCxofwo0l9jyByNUGtgUgWjI8DpeN71V5h6uFLhhjcQqX
         zQ7BjUWaOe9X4a/cwRaAt5wFAXli1fw6eXlU3MVpagEHDIVMuzkCkWxsPW0ifjXCTFKj
         NR+mzGlDBa5oKS8r/fBxSpX4FONPylwWuo8osR1OiJEad4XNBlD2AxJ/vaN+EEYhrnFn
         l+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973759; x=1688565759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=BHJZsSmzZf2Bz4qlo7nTsJP6fONT8oKB8po24r+2PPKtNIgCbraypASO6BFh5HP6Yy
         y4WhwX08gyilRv8zQbDBO4xkdeyA7DYXb4kvO2peLrMq/VI06+MV4aOBNKtgDG/M+naZ
         pj3w7B2/7dxaGAvrHkg3jjJPM1lEiOLQSXHFDo3kp6CV4dbIwpYe5gcE2PPSNGfbJmMe
         wOFOr90ytOZHNApGPPcFOzMC89GQ5Y5UtWOAjuubPChVPlN9n0yrj9KxmXYSphIPInZF
         Ozpy6Jo03n8kh9hU3nnJ/pRnRpB1dpBIwFUQ51Yq7FAu+lcBqfkimU/Ad36RT8oqaYJe
         StKQ==
X-Gm-Message-State: AC+VfDyPF4RerS9z0dXajMADlAFdS1DE5qmMylywdyZm1dfc0rfi0N1e
        lT6d/6jVu+vzIHnINLl2fFFlVg==
X-Google-Smtp-Source: ACHHUZ7JHPcqP/KJZW5Gtw/RbrqWj/PsANmRbOGLyQKnlFtu6R3GuOvRZADl3r3k58Lv26G1MJnkOQ==
X-Received: by 2002:a4a:bd98:0:b0:558:aa98:df34 with SMTP id k24-20020a4abd98000000b00558aa98df34mr2872760oop.9.1685973758908;
        Mon, 05 Jun 2023 07:02:38 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:38 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 4/8] riscv: Sort the ISA extension array alphabetically
Date:   Mon,  5 Jun 2023 19:32:04 +0530
Message-Id: <20230605140208.272027-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605140208.272027-1-apatel@ventanamicro.com>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us follow alphabetical order for listing ISA extensions in
the isa_info_arr[] array.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3cdb95c..977e962 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -15,11 +15,12 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	/* sorted alphabetically */
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

