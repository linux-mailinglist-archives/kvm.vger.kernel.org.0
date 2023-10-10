Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E787C0227
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjJJRFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjJJRFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:05:31 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C75D8
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c7373cff01so251065ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696957525; x=1697562325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3lhlJZP7U6sfVX0rlDY0S8d2x8DhhVnWXy5WEJL0wg=;
        b=Q1nvnrQhx6Vs8g9wOc7yiACALxYiSSrf2LksIxSwvXbWbC6UNECEQcClYhPtrb2p4D
         zMhL03nuhtA+w/QwK0+6WWFgwJJTeDB5VQ5Z1DRG78TEEd+dPGo196k6nZVzUAE9igOU
         RGaJDl9jfGZVKlZ5BJMl2E8ViLpZmMrFKKantddS21R5VNXvSHxuGPHNpa6iW7ICODA+
         ZM0YEFQS/+M3tWpHZ1RKnQxpmHF6ICK8mkm3vPzR8aQiFT+ZXnEz7G+q3KZxoaVRlkRi
         wGS16TLD+YV6fZmrGM+HGbZC1GFivZ90lyTo5977Gdwvr4ESBvxvgf9mgoSHxTujZIp4
         0fTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957525; x=1697562325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3lhlJZP7U6sfVX0rlDY0S8d2x8DhhVnWXy5WEJL0wg=;
        b=Vh05sw9V5Cg6zYV96CeOy7hHfjFjUon7GLfFeybJOgLNqs07ZowTzc/TvervSlSLeL
         /9gnZFsd/h98R5QvjybBnuGJ+HuZUu0oCcshQyqDV/9JaoDsfaa6ZxXP72pPUn6MoJqu
         437Rh3OHjhhu+3QFE5+ReAejdwGvmRKi0EOVhhcQHdIwH4sL+xWzIoB1zGGekYTEhR3C
         tm/JuuZC8WHaFNz2TQf38T7MscQvX8DwjfhaN2KHmEtmfOjTcWKqsQ746e/6vmvY/8pT
         X6GfBv7rhnwR5hFF2tj9KirIGUEm2+fRYDUXYkaEDi8RytY9S4BTm2JlQn4oHbaiLe54
         nXJQ==
X-Gm-Message-State: AOJu0YyUM2OCeV+GCn9ayZ3zV8vkfq0x8cUtkivnp18+UyUPqBfDtzoW
        /YeQZJMfM0bQmgT8AB/Fxwt0Zw==
X-Google-Smtp-Source: AGHT+IG+mbNrQmt2GEYzZRkORnAD/EBo6KEPWJykcTVHm9mjjc11kbkmKKhIYwMGoWp8ra4yRmdzoQ==
X-Received: by 2002:a17:902:d352:b0:1c6:de6:5eb4 with SMTP id l18-20020a170902d35200b001c60de65eb4mr18397397plk.13.1696957524587;
        Tue, 10 Oct 2023 10:05:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001b89536974bsm11979868pll.202.2023.10.10.10.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 10:05:24 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/6] RISC-V: KVM: Change the SBI specification version to v2.0
Date:   Tue, 10 Oct 2023 22:34:59 +0530
Message-Id: <20231010170503.657189-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010170503.657189-1-apatel@ventanamicro.com>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be implementing SBI DBCN extension for KVM RISC-V so let
us change the KVM RISC-V SBI specification version to v2.0.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index cdcf0ff07be7..8d6d4dce8a5e 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,7 +11,7 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 1
+#define KVM_SBI_VERSION_MAJOR 2
 #define KVM_SBI_VERSION_MINOR 0
 
 enum kvm_riscv_sbi_ext_status {
-- 
2.34.1

