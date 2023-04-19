Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A98F6E847D
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjDSWRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDSWRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:37 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC051BCC
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a92513abebso5352805ad.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942656; x=1684534656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQ+Q1EB8U9VN9DkQE/7ZRwGYKH2CHxTB2A2ZNISqIdY=;
        b=M7pMYKMh2fzPlQxiN+Er+1mRXb5xsvVBR/kCf0Xc6I4eRmeu17ZWxN3F+8Uh4bOfYt
         pLsryNkeitFt3/g2LwdIO4gRgf1eK0d0zd3qJJmJH0/Ytd9PXb2f4ZIv2vw9qF7rcmT+
         +/5fNVmr7py0CepFxvid91vQee8LTDJ1trxwVh1r+SZa6D1ybCiNK5WtQpwcXBYzwzon
         14Dk5NjS3zvhDHWUiYkgfDVG/0CawxYwCekaOcRjbz+KKATicit8f2wKNBE+FUv2M2pL
         VFRS7BwOkXZ7Z6aFPV2U5r0uWlcE+ptOAW8XtsMKVeJj+vK+/KtMoB1U0hUKE2I995ZX
         1ZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942656; x=1684534656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQ+Q1EB8U9VN9DkQE/7ZRwGYKH2CHxTB2A2ZNISqIdY=;
        b=VXvgJztprCJo6Yap/UoiffrOa94GIWhxBPzfUkY+Xzmz0p/DKEZlqlXdcFNvzzT61Q
         3b3Tp86DL/HRaMCzNciEvXN93dZr4Nb5ZxDYQ1OyeYO1ar+vwrn8vjfvBywxu1wp7uoV
         cPnghpsGIj5KW2yrVA+D4yXdD+hlB0YAlc+wECIAbqztgkWm3KmL6KpNTCelwpg91fx1
         2haYUXGRje/QHBN4pFYUNz7IK9ybJS33ShgLx0N4DgdiVJgYCpNRr32+7hV1aL6m/o3r
         u0phl/GcFUm647Nq/GfZvz8Ro9LsVTDvyOD22R3E4jD1v71Ej0c3OwJzQ0Z7t7l44O+g
         TKlg==
X-Gm-Message-State: AAQBX9dWpYTEA0QTS+sEdzFyoS+y1NFM2VS2KsuSoN/UHqMqj7JpTMyV
        Y1LyOshV0+7WLAksnqQEKumf6g==
X-Google-Smtp-Source: AKy350ZJUiSSYrDjl7yi3RGe7KkMi+TjKSL1H9rjEJIsWoSyzpH0Qljb3g4DlHLMrKbT1BFQ8UiTyA==
X-Received: by 2002:a17:902:6bc1:b0:1a6:81fc:b585 with SMTP id m1-20020a1709026bc100b001a681fcb585mr6201339plt.41.1681942656169;
        Wed, 19 Apr 2023 15:17:36 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:35 -0700 (PDT)
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
Subject: [RFC 03/48] RISC-V: KVM: Invoke aia_update with preempt disabled/irq enabled
Date:   Wed, 19 Apr 2023 15:16:31 -0700
Message-Id: <20230419221716.3603068-4-atishp@rivosinc.com>
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

Some of the aia_update operations required to invoke IPIs that
needs interrupts to be enabled. Currently, entire aia_update
is being called from irqs disabled context while only preemption
disable is necessary.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e65852d..c53bf98 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -1247,15 +1247,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_riscv_check_vcpu_requests(vcpu);
 
-		local_irq_disable();
-
 		/* Update AIA HW state before entering guest */
+		preempt_disable();
 		ret = kvm_riscv_vcpu_aia_update(vcpu);
 		if (ret <= 0) {
-			local_irq_enable();
+			preempt_enable();
 			continue;
 		}
+		preempt_enable();
 
+		local_irq_disable();
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
-- 
2.25.1

