Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868E76E84C5
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjDSWWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjDSWVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09137D93
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a6817adde4so5433275ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942732; x=1684534732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wZ38NgXR92ZnL3KCz4X1T1orXD86k7gku+jH9LYvlc=;
        b=QmuuVYt46KpS/zYYMAaGwSu/4ogHzgebSuHz2Y3KqaXaWYNGDgVkh+TM+9F0z1UKqq
         yLwfXsEjIj5AyyA1hGl2bhxYnaVMKxeSrJ8kwz/jbSGPSXzXJrYc1cZLmnuKcOHvK/NO
         W+UYzU5cNYXd7iKLqbolbPZxHkvQvk9pg5qltXG2gdevWPNka1SD3vMUG51IVWwpm1Is
         pQl00SUeHSzQxwfQfWPPzCjONURk75DuuPNE8FRa7jDR7RGmxRIpfU2bo0VrGWZ8ZwD3
         0HsjPnYDT4F6NmAip4Qb5wSlSawzKk38AMTj8xzmlCbhjRiSI7AJ2N04QWgrNDK8/C2A
         ee7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942732; x=1684534732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3wZ38NgXR92ZnL3KCz4X1T1orXD86k7gku+jH9LYvlc=;
        b=jD7XVs12KHaHLVJ1F1ghRrfkgk5PrSLNZlmLHissWyxI0LQMeWkC3/ZoXcp1+hs6JA
         rsWyWBSpb3kUTw/r10WSBZbQEjoYxAoeER9sxikw1VQRsbV8SD8bo3/9H7KR/wBzEi7R
         EPv21YwPNGqPqC2FyfPAwFCpLl7ZRJjXE5faY420fKIaljzPYzMI7BZPUfbchG9nJoRY
         OHgsZBqRFGdXi1WsU4x5doY4K5gPpkfYXPDIQXnxW21QqcW6Sn1FMRYQ9gEva5maUtuS
         uSt0ejnNmQbrygwDzRGLVlT/CY7Dv3tDT4RLuDCkyhiLKNPHWZ5HCEdYsKF/eqy57KQg
         O0HA==
X-Gm-Message-State: AAQBX9cfdrLCMVXjntKgmf+asYx8/ERXgACxBT8Br0c4C9R0vE9O6T5e
        DRwcl1yAp9HO7z/AZfr77JWYgw==
X-Google-Smtp-Source: AKy350YlbYAHX3czmRaEVnTcNdf891KQxoyoTa0cHJBez0RPMbydsH+Ponf0TcKud2fsWou26F4oLw==
X-Received: by 2002:a17:903:2281:b0:1a6:3737:750d with SMTP id b1-20020a170903228100b001a63737750dmr7538499plh.17.1681942731698;
        Wed, 19 Apr 2023 15:18:51 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:51 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
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
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 37/48] RISC-V: Add COVG SBI extension definitions
Date:   Wed, 19 Apr 2023 15:17:05 -0700
Message-Id: <20230419221716.3603068-38-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

CoVE specification defines a separate SBI extension known as CoVG
for the guest side interface. Add the definitions for that extension.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index bbea922..e02ee75 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -34,6 +34,7 @@ enum sbi_ext_id {
 	SBI_EXT_NACL = 0x4E41434C,
 	SBI_EXT_COVH = 0x434F5648,
 	SBI_EXT_COVI = 0x434F5649,
+	SBI_EXT_COVG = 0x434F5647,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -439,6 +440,16 @@ struct sbi_cove_tvm_aia_params {
 	uint32_t guests_per_hart;
 };
 
+/* SBI COVG extension data structures */
+enum sbi_ext_covg_fid {
+	SBI_EXT_COVG_ADD_MMIO_REGION,
+	SBI_EXT_COVG_REMOVE_MMIO_REGION,
+	SBI_EXT_COVG_SHARE_MEMORY,
+	SBI_EXT_COVG_UNSHARE_MEMORY,
+	SBI_EXT_COVG_ALLOW_EXT_INTERRUPT,
+	SBI_EXT_COVG_DENY_EXT_INTERRUPT,
+};
+
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
-- 
2.25.1

