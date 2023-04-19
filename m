Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58846E84F7
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDSWaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbjDSW3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:29:30 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135A455A5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:28:15 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-771d9ec5aa5so159292241.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943247; x=1684535247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecSGlantlLzvA0G9VPQY9TXgG8EZEn7xksLEzRIVmIY=;
        b=JivewOmrlAr1ZbnurDAaNTRphsPccGwoF6k/PNgJ7KGJwRx0uCfoWYGFR/bEfixo0e
         r5w+kgN9iHlKiZYstptLVFIoVAAQVnMcChho91eAwSnCVF0OnxMe4as8+J6SQVPzvkii
         7GnTcY5w+wG9L8xFddRsQYGt/lZH9/7Hm8ZgBfAVuKvKY70Ax/Nz3ySftgNaMpABgvCF
         eqb9Ca+MkmM5QX1vMUNqRohYkTP5kIVrd0HLdlx66cTP6tY0LPFGZUI+CKHvudqcJRuQ
         hHUPmD5b/KDOW7sIfM4jqLnBhE8T3Cr38+IOroeT8X8Orv/Rf60MeRqEvU6HoedzvDUl
         OPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943247; x=1684535247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecSGlantlLzvA0G9VPQY9TXgG8EZEn7xksLEzRIVmIY=;
        b=SdDVa5i0ZoolGbIF7kMYb/Zt7FycTuoaRwbBrgMuVxbQEMgWZyJjmFvVcyzdxnenp2
         2bUVmoEhYZcw28P4rKZgTG/ir5j0FGyXkuwMpZtkexourJ4nvZ5zzqnR5IHLg1d/RWRV
         yUUjHgVuhFuep3glhENXPMLD9O13ahU3TgrUKumhJOLD8mjgaNLcZ37O2zrGdcuqTiII
         T7Qe7dj7xd6NxeTWvN4nEKHCOZ0eYr7PAwLNGhwu9ullkXOpmnVACV+47pgoXKFL5OzU
         aiw9Z8n7sCF68x6U/oV9lgzwiwzsWnAPBFgNxYl+r020x6zgK8VMPdrpiBQwoaMwnAMD
         u7wg==
X-Gm-Message-State: AAQBX9coFbs1ulmaYIYKgIXNsP90r8AWlersVPJ3Ximg/DQWFdufWTbf
        mfEm6hedb4rJ/vNZ3n0TKCmogTuZDOONbklr1IY=
X-Google-Smtp-Source: AKy350YKfPHbIymM6qmHQFNTIkUnRhQSV2hEDBlfRu6z0TKA3ibQ947LdlZE55huq5S43nAipp/NMA==
X-Received: by 2002:a17:903:22c7:b0:1a6:3737:750c with SMTP id y7-20020a17090322c700b001a63737750cmr4095049plg.21.1681942751934;
        Wed, 19 Apr 2023 15:19:11 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:11 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
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
Subject: [RFC 46/48] riscv/virtio: Have CoVE guests enforce restricted virtio memory access.
Date:   Wed, 19 Apr 2023 15:17:14 -0700
Message-Id: <20230419221716.3603068-47-atishp@rivosinc.com>
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

CoVE guest requires that virtio devices use the DMA API to allow the
hypervisor to successfully access guest memory as needed.

The VIRTIO_F_VERSION_1 and VIRTIO_F_ACCESS_PLATFORM features tell virtio
to use the DMA API. Force to check for these features to fail the device
probe if these features have not been set when running as an TEE guest.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 arch/riscv/mm/mem_encrypt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/mm/mem_encrypt.c b/arch/riscv/mm/mem_encrypt.c
index 8207a5c..8523c50 100644
--- a/arch/riscv/mm/mem_encrypt.c
+++ b/arch/riscv/mm/mem_encrypt.c
@@ -10,6 +10,7 @@
 #include <linux/swiotlb.h>
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
+#include <linux/virtio_anchor.h>
 #include <asm/covg_sbi.h>
 
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
@@ -54,4 +55,7 @@ void __init mem_encrypt_init(void)
 
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
+
+	/* Set restricted memory access for virtio. */
+	virtio_set_mem_acc_cb(virtio_require_restricted_mem_acc);
 }
-- 
2.25.1

