Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6E66E84AE
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjDSWUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjDSWUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:20:04 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFC4A5DC
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:54 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2466f65d7e0so177971a91.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942705; x=1684534705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJcz91lEoSJqtalpSfBSHZNF30nj7YibjBRer+eosEg=;
        b=qMbw2bfkgktxDwIJo8enIEL5pLtnbolY3+JaaISTkIKsa3/Pbsco4zcJlI15aLKelR
         WFKrKF2Hz7v5krpEvYpYwDTqJPbGu3BuJcQtCe9xizDdAggE5jW1G4X8qqMenNOBqXz9
         5gqd6GiYE1ZkgW2qNIjSboTRdUgFAKPx3ibrEbYtA8McCRZRHbdZdMvH67xn6xctz3io
         Yx4YAKRBSdhdHTVV7HAXUHddiREJjeIsjlNB/MFPQtt0zqpmQorHvJ8xpPjM9lkMYa3A
         PJWfAzX50ZJIGmvwtxGZ3PpJ/kZeMQBLQ0BYf7N4KMtYq6ZlC++uPwgnbCGRBd8idM/u
         /cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942705; x=1684534705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJcz91lEoSJqtalpSfBSHZNF30nj7YibjBRer+eosEg=;
        b=aC331Glw7BW95Gbxaiu0VXbPC8Ae2lRECFGVIRis5yG2SStD73WD0Ur/vR/MRikt8k
         mygJ86czwWu9GKgALdQjwYgY6fhvcZx3ZfcmtYBBlndDfJwh4rNSl0IEHgY3i8CpEzAX
         1IrOyEGLVC7WWF7B3ZIAHL89DAHE5v+VqWHfrDsd1gqbHs0LfjaTn7UHKj3w8GkMe5Na
         ytmAPE7jIhfeNa50AIEkxFlKuIm8Hf/T2giRxEdHMJY4ZlUIFUpi+do7FSRCFQUJwMQz
         2BFCF7KjcEKHQRHC1at9V5lbh/C2Vbs01DC7ZQCCR7Y2xPkp1MhY2iwJWXBJOKufALsL
         3RGw==
X-Gm-Message-State: AAQBX9fzw9u99W/a3f15eSBs7/D0dWHWxFzsfHNSVSee9CInCr4XApG7
        6MHxLWd49ZH9bUA/KpoG1AGVIw==
X-Google-Smtp-Source: AKy350Z8cKy3RK/3X5ej3IZFoGxmT2xiFm/BExphbF3ahTLRykDnPstTsJrfduCst6vY0llDQCAqqw==
X-Received: by 2002:a17:90b:890:b0:23a:333c:6bab with SMTP id bj16-20020a17090b089000b0023a333c6babmr4018734pjb.23.1681942704931;
        Wed, 19 Apr 2023 15:18:24 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:24 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 25/48] RISC-V: KVM: Skip HVIP update for TVMs
Date:   Wed, 19 Apr 2023 15:16:53 -0700
Message-Id: <20230419221716.3603068-26-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip HVIP update as the Host shouldn't be able to inject
interrupt directly to a TVM.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 43a0b8c..20d4800 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -822,7 +822,10 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 	/* Read current HVIP and VSIE CSRs */
 	csr->vsie = nacl_csr_read(CSR_VSIE);
 
-	/* Sync-up HVIP.VSSIP bit changes does by Guest */
+	/*
+	 * Sync-up HVIP.VSSIP bit changes does by Guest. For TVMs,
+	 * the HVIP is not updated by the TSM. Expect it to be zero.
+	 */
 	hvip = nacl_csr_read(CSR_HVIP);
 	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
 		if (hvip & (1UL << IRQ_VS_SOFT)) {
@@ -1305,8 +1308,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
 
-		/* Update HVIP CSR for current CPU */
-		kvm_riscv_update_hvip(vcpu);
+		/* Update HVIP CSR for current CPU only for non TVMs */
+		if (!is_cove_vcpu(vcpu))
+			kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
 		    kvm_riscv_gstage_vmid_ver_changed(vcpu->kvm) ||
-- 
2.25.1

