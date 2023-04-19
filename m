Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1E6E84E2
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbjDSW10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjDSW1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:27:01 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7089C158
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a9253d4551so4804085ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943053; x=1684535053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2k6fZhtBjuovD0xJN9/3Mss7sJpSj6M+Lhg1puIM9yQ=;
        b=frHFpOgJMj3IyT+0l6lF4ggQqLWSqJ+R5Lwl83JFjnZ1FgOj+RCeflj5OiteP2veXj
         hs8UabqlFhDeAfeVOqN8nsOlJjF/2yPcJvsYdreBOn4W0VsT07xnNPxxC9wRqCbEDrEI
         ZWpU6jo5/ivGxGl/5WlSrPuw4s+yWAlTdUEKKQGRxh6JkIhcKHr1ykdZxEako+r8BVLI
         Iia+UAGrprs58WkfVvjD7u2w/7WcLDjo2lLLRaRlMw3OivWlNDMPp50fyu9RdhML7Hv4
         wHYTWA+nkcv0sFjdO1RQEsLbEgouvwKngVct5OCtGdc8SgVKzfHhIkTKi03d/OSMpN46
         dypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943053; x=1684535053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2k6fZhtBjuovD0xJN9/3Mss7sJpSj6M+Lhg1puIM9yQ=;
        b=Z0i7tJjWh/NHjBLpHlr9FAAX6ZlFJSdbKzrHVYXNZAkwjMTQUTvQD3XCaJo/ZjUjm+
         cfoOIcgSmqfFDPhxpibbxiER8tzXmRTaZ4V+DVE7FfbQgw9uj1iaV/uWcYHzoAkEs5yC
         ZsYp87XtVu7y4E17HC5vahb5+Bj8nvhfsSxCffK61YK/MzNCEcGMJdKKP7O5Bc92ZSDW
         QG8mXbUp+I0UTTr49EJgJVmTH83TDebC0TzCpqEbZnKdYRbzX3Gjv3O9dWu8AedxPA3n
         +KUhkNFwBItltzFSJhCxeHguGyjNRuqYfKD6d/inxRUmlgT5Ydg6fQWieoWqaV6crLjP
         3LnA==
X-Gm-Message-State: AAQBX9etDHpRHcDH0OnOFSP2BhSjUP3jiIrwnuXnrpSYy8KO0dB5k9Ua
        S1xXExevngbUdsuCyjJVdPZv1A==
X-Google-Smtp-Source: AKy350a+wtlv0SH4nHUTs3X+REynERjZtWfA6CRUt3D8Ejpa/aSb6HljJIxaa3PlyPoDKWKx8hTZ+g==
X-Received: by 2002:a17:903:8c6:b0:1a0:42d4:e38a with SMTP id lk6-20020a17090308c600b001a042d4e38amr7048884plb.11.1681943053760;
        Wed, 19 Apr 2023 15:24:13 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001a681fb3e77sm11867810plt.44.2023.04.19.15.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:24:13 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC kvmtool 06/10] riscv: Change initrd alignment to a page size
Date:   Wed, 19 Apr 2023 15:23:46 -0700
Message-Id: <20230419222350.3604274-7-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419222350.3604274-1-atishp@rivosinc.com>
References: <20230419222350.3604274-1-atishp@rivosinc.com>
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

Currently, the initrd image is aligned to 8. This is problematic for
CoVE where the image is expected to be aligned at page granularity level.

Thus, align it to 4k. This can be done only if user requested a TVM.
However, initrd usually much bigger (in MBs at least). Thus, aligning
to a page for everything should not matter much.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 riscv/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/kvm.c b/riscv/kvm.c
index d59e8bc..5f9b0d5 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -113,7 +113,7 @@ void kvm__arch_init(struct kvm *kvm)
 }
 
 #define FDT_ALIGN	SZ_4M
-#define INITRD_ALIGN	8
+#define INITRD_ALIGN	SZ_4K
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline)
 {
-- 
2.25.1

