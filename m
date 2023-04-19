Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319926E8476
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjDSWRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDSWRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:33 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4181BCC
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a66888cb89so4499245ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942652; x=1684534652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mljZsiO5QRb1GQDkLUDPFjVfkuRVaSDyhp9y+byMdss=;
        b=rSiuLSw6DyvgYFbph9bmFmqDG3DBHXwiC4IjLHTdoeoNqI3Zj5mvjcgftruD3sRQcL
         WxDYcG6ScHPYH/tsYrRzbCoTKzHkW8KNXh7K15sX/3vd0JxNdmgwDLmJ5Gbl1ptnc8kV
         B413qUWKvROFulz1VG3quMom7gr4KDz5SG6hA7i1NB7suVliV8jg80Ei4eKibGK25dVw
         IUKYu3sVmnUrAoFcDhoqyEJFPDZqPR+RsU7ZbMNTfRONc8CY2sotnhibyQDIiJL6WP4d
         uPsZMJmzwj1MOrHzXnjW7uCJa6/KKt6iVnYO2QkJX8Ox8I1aJyUyI4qshbT0yxib1Rsh
         ovBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942652; x=1684534652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mljZsiO5QRb1GQDkLUDPFjVfkuRVaSDyhp9y+byMdss=;
        b=db1adVsNhXVJ7IZ6N5+YPMsuJWP9Ge0/tuRmEHKJmsuCZUmKQKWfixN/5lbcDBKtQp
         d2SPRpUyZkgF6yVtjYlWAJ3zPc7oOrZcOEKlwnMuy1XMbXmmoC9eOgVLJShZ1m7YEZSY
         nKjfZiR5pQ6rrg1GyK+9ITxAv1QjUDCwcXaaq/jVJzLtqnkhL0E0LHoQ9Rd+9WoMT2g4
         iyVLnrxsFG8xMxHpoXZRdQu6EaFKSdGPo6RFGhTd74iUFVoUcW9eqhET0frDX0s9Le0G
         wrHH3OOnUzzIO+l4kZTwg0noY6X9pqzTOU7ibvoD05twag4X9WmQS+KYipij91FAm1at
         PJgw==
X-Gm-Message-State: AAQBX9fbB0zDi88djW+wWMdw914Y5wn+QVxTtI2q02lN9MIUmYd/4vLJ
        G0+MI7S7oaipFArzxSHpdkeLnA==
X-Google-Smtp-Source: AKy350YAUHKVoqLB+lNg1GyvGR/YhY1dexLjtDy2z84R1FBjB72vycA1EeypPas5l/++BhN5lcYzyg==
X-Received: by 2002:a17:902:e74c:b0:1a6:4200:bef4 with SMTP id p12-20020a170902e74c00b001a64200bef4mr7961111plf.56.1681942651818;
        Wed, 19 Apr 2023 15:17:31 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:31 -0700 (PDT)
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
Subject: [RFC 01/48] mm/vmalloc: Introduce arch hooks to notify ioremap/unmap changes
Date:   Wed, 19 Apr 2023 15:16:29 -0700
Message-Id: <20230419221716.3603068-2-atishp@rivosinc.com>
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

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

In virtualization, the guest may need notify the host about the ioremap
regions. This is a common usecase in confidential computing where the
host only provides MMIO emulation for the regions specified by the guest.

Add a pair if arch specific callbacks to track the ioremapped regions.

This patch is based on pkvm patches. A generic arch config can be added
similar to pkvm if this is going to be the final solution. The device
authorization/filtering approach is very different from this and we
may prefer that one as it provides more flexibility in terms of which
devices are allowed for the confidential guests.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 mm/vmalloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bef6cf2..023630e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -304,6 +304,14 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	return err;
 }
 
+__weak void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
+{
+}
+
+__weak void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
+{
+}
+
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		phys_addr_t phys_addr, pgprot_t prot)
 {
@@ -315,6 +323,10 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 	if (!err)
 		kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					 ioremap_max_page_shift);
+
+	if (!err)
+		ioremap_phys_range_hook(phys_addr, end - addr, prot);
+
 	return err;
 }
 
@@ -2772,6 +2784,10 @@ void vunmap(const void *addr)
 				addr);
 		return;
 	}
+
+	if (vm->flags & VM_IOREMAP)
+		iounmap_phys_range_hook(vm->phys_addr, get_vm_area_size(vm));
+
 	kfree(vm);
 }
 EXPORT_SYMBOL(vunmap);
-- 
2.25.1

