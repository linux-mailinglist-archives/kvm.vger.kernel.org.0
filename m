Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1B733D6D
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjFQBca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjFQBc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:32:29 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47E3AAE
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:28 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3422aacdcceso233675ab.2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965547; x=1689557547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCFh45Qsuxbnb3g0rM8fH1ZiENcg3IHzIVBkkFabZuA=;
        b=lKUS3XrMHKO/IAyQlaR+bTGozWS2E4YkTio25buE4PJ7GoQu54ndBzxCOhqaQWJhs/
         IhG5XchDDSey75xzX1nEPYPt16nlpugDzrINTybuA1+myv/QX1WNrVqMyLYg1wPf/b1G
         bgO0Q9QPU8wrOJeV2yVyT1w3VuJdgWZr+3sZ3hkV7wW0pIScymwToVWDrni21g4B6Tyj
         ReS9bWaYwwoaoMDV4nO7OpZcvXTJkVDddWNqyivQeRNp0A0k72SiwZP1//TKG276/BIE
         fgoLGAD/45RJrkdn6CLIr6eIakoAnkDET8WK89M47ArTydu+csJHlIoFMX8nD8dyuNRn
         T5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965547; x=1689557547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCFh45Qsuxbnb3g0rM8fH1ZiENcg3IHzIVBkkFabZuA=;
        b=N4J9RnHG12auXJxEFi4i2SFj4BzUSJXMZ9tVV/uJo763iL87FzKaB2CgrbsjNueeyp
         AlMvUk7PBeFjlUKH4cYf17VZGI0a6n1ZljQvpxDlIwwojikz798KmUZwpoyIZRRUuPbO
         Uih6Fu5BT6EjYudgofpxgzd/OGzWjfSBY6fFvMqaJocDMg2cFARuOVtfRfyc/VoRjN1o
         rZ8/cZ9RRJWkHplhE4ddmodNXR+A+tsrfvD+5qBkabBEICoYIxpAJZ8M+V1ihUOw4hPO
         fDK5uq0rKI7dro4SrIj4UkFl/JNsrFwTOaywWrxNkBamkRnTYdNjPb7NXYyFLp5mYpUU
         NUUA==
X-Gm-Message-State: AC+VfDzRerJczRb+rDLyC1W5C0Zz9sYgCOAx3IDlVagO7e7nhYfxvYoL
        f1tC+f+ar0SdotvB0+kqJck=
X-Google-Smtp-Source: ACHHUZ56q6e08Ddrinzp/hEGan9to7/X04Bp38cROLMLVviVEnxslB11hbwWIsOrFwxuJUdAUL7KZw==
X-Received: by 2002:a92:d1d2:0:b0:331:9a82:33f6 with SMTP id u18-20020a92d1d2000000b003319a8233f6mr1020746ilg.5.1686965547172;
        Fri, 16 Jun 2023 18:32:27 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:26 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Date:   Sat, 17 Jun 2023 01:31:38 +0000
Message-Id: <20230617013138.1823-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617013138.1823-1-namit@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

While no real problem was encountered, having an inline assembly without
volatile keyword and output can allow the compiler to ignore it. And
without a memory clobber, potentially reorder it.

Add volatile and memory clobber.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/arm64/asm/mmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 5c27edb..cf94403 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -14,7 +14,7 @@
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	asm("tlbi	vmalle1is");
+	asm volatile("tlbi	vmalle1is" ::: "memory");
 	dsb(ish);
 	isb();
 }
@@ -23,7 +23,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 {
 	unsigned long page = vaddr >> 12;
 	dsb(ishst);
-	asm("tlbi	vaae1is, %0" :: "r" (page));
+	asm volatile("tlbi	vaae1is, %0" :: "r" (page) : "memory");
 	dsb(ish);
 	isb();
 }
-- 
2.34.1

