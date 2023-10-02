Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0BC7B5650
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbjJBPMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbjJBPMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:12:44 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E376BE9
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 08:12:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4060b623e64so19761345e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 08:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1696259560; x=1696864360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAROWeuegt9axYlR2gFhUBC1uOuBg0VWiNfGep/WqRA=;
        b=aBt1BOFYLz2ZaBfzM6ZWaQOKieiR7xa/dQgV8zhD2OMupWx3kSjuovSNU3T7pR7P8h
         UUry+gkB1953S526Mq406JtxnbvTVM0ZmnoSecbdAIoSGzn5LYSTOVz/UCIyHWRlXClv
         EkkJp6733k9etHyRXeA81fWz72ktgNXOBEqtbSiz+uS+RkfiL2jxHUv393LYNmfYeepz
         x1rJ4y8O6J3qZDMjNEoLLAb3mbxESR4iIiELmOfe8fju27VeV4pIUuOmxf0tVWQrG4AS
         IROkos672qQpO2gKzCId7eC63UeVTQ8OzIsK9yNUFdspgreX8G94B1lb+VF/SybJ0lsO
         PFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696259560; x=1696864360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAROWeuegt9axYlR2gFhUBC1uOuBg0VWiNfGep/WqRA=;
        b=E11jGj4x6v303Wyi4iNZPMbtblHawXqOjhqYIBDY/GLLP8+ie5z/Pj+MlOGFH4X2B7
         5reGYyPsNSWzkV+8fLHCB1VNHSb1bR7DgkNrQhS9zqGI3KBpGSIKk7bBB+EosjHktBuH
         VJt7xJbk3Yy+aOB9Q5Z56gY1AZ5FpPniE8avlwn2wRXHBOYLpgAvdpGcFe8xCUfCo3aH
         3MDFwIaL3iRQo24HjEqiafW+9Qv6WHbkp6Lab7K118BlNZ8q0gLxEAGyDPnHYDOUPdot
         Hd8ISYCbbBjwHaJunxwrYR99FGxURb3mKo+rO7rhgpy+la8GUDtsmADvD/HR742+mnWh
         JIdA==
X-Gm-Message-State: AOJu0Ywc3sRc+/pByt57JnLahVwZD1YtvtskRP/e1fzXg5/11UnFdDk5
        Aedy9mOs9l4XlH5L1k+o02qPCw==
X-Google-Smtp-Source: AGHT+IEp4TyiMTncEFWIJawksGoamhltIe4ZJc8GCSTvwz3nHyivxU99XVIdB916hW0jM9qw6ka5vg==
X-Received: by 2002:a05:600c:5022:b0:405:3f06:d2ef with SMTP id n34-20020a05600c502200b004053f06d2efmr9800701wmr.4.1696259560252;
        Mon, 02 Oct 2023 08:12:40 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id l5-20020a7bc445000000b003fbe791a0e8sm7507939wmi.0.2023.10.02.08.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 08:12:39 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Ryan Roberts <ryan.roberts@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 2/5] mm: Introduce pudp/p4dp/pgdp_get() functions
Date:   Mon,  2 Oct 2023 17:10:28 +0200
Message-Id: <20231002151031.110551-3-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231002151031.110551-1-alexghiti@rivosinc.com>
References: <20231002151031.110551-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of directly dereferencing page tables entries, which can cause
issues (see commit 20a004e7b017 ("arm64: mm: Use READ_ONCE/WRITE_ONCE when
accessing page tables"), let's introduce new functions to get the
pud/p4d/pgd entries (the pte and pmd versions already exist).

Those new functions will be used in subsequent commits by the riscv
architecture.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 include/linux/pgtable.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1fba072b3dac..4ce68bcc201d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -284,6 +284,27 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
 }
 #endif
 
+#ifndef pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return READ_ONCE(*pudp);
+}
+#endif
+
+#ifndef p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+#endif
+
+#ifndef pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return READ_ONCE(*pgdp);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
-- 
2.39.2

