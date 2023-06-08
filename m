Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF614727959
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjFHH7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjFHH67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:59 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F702139
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:56 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6af81142b6dso203015a34.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211135; x=1688803135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVxObp0zmyu3ssFErjXY9Z5Q7INa146bcXIjtH2cVKQ=;
        b=OZ4NWay5hQG0dD6Z07qscHOwNT8tDgOt5plB8HxBeowkPQexlqPsyC2D8BQTKLw6JS
         TAYdOv4M1sWInpQkcO74NYZEw7UnbzjgFmqeej6x2fK8/srNgultVD+PgdgAzNis+J5L
         JLWREvYMhAQLLV/CUokuusVPsLhJxAGvxCdUCu1EMdlplfmrOOVEqHAQ/nmjc1sM772u
         IkTdjRsR9BOf1Fm4wRFzihc/Y5BTclbcXl/I+SbDvZxWF+dOmy4J1xuH2iVwy2dFh3NC
         NoeZgvVE2R9VOBQds3JWzCzWBaFKJcxoxu3zsXhDQeWM6lztLSzzRDt6q6AbmipKa5ET
         QtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211135; x=1688803135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVxObp0zmyu3ssFErjXY9Z5Q7INa146bcXIjtH2cVKQ=;
        b=LYUuBs7IAx8wCPxy2C09Xi+PgS+8cyFs7KRnK46zX+XXTkVvq3DH9PJudZFH10hTYk
         KuPLP5jcx2gcBqSfntokqTRZsa1lApDD2/s99HWWoNdSi3xhDRl5M5y98DAdd2vL8u+c
         oW1k0sJ3KlM4RWUiHMa6SN/2UW1g/esZ6JD0rGsTIUXSMe34GCHTf4kjIhB+cUchHgl6
         sa8jvKRw+ZpsMk0NkgPH7Beb0rs/3bbx/c7n7OtYELOyFdk2wOUp2CLPzuGRDKBHJbnh
         Uge2xeF4whmUmfWOyV3NkT9l4SYu7MNIYhjCVnKL2Zs8lvAMAMP7M7+e78WEQ4sw9RdU
         P6ew==
X-Gm-Message-State: AC+VfDwKZ6n5xhFrA8/ofUUiLBC5+KucHhxuBVTjl72oOt2BpjWy5Un3
        bofF6NFfGu8SfeqgDG6Wo1q2F8RDCUQ=
X-Google-Smtp-Source: ACHHUZ70nNbp10LOImOn6G69MXJk5Q7oJsNMbOBFBAsZ1ykU4/Xuk6Iiu1vra8opQV+j3AEGl1U9pg==
X-Received: by 2002:a05:6358:9f91:b0:125:506d:36db with SMTP id fy17-20020a0563589f9100b00125506d36dbmr5668272rwb.14.1686211135442;
        Thu, 08 Jun 2023 00:58:55 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 05/12] powerpc: Extract some common helpers and defines to headers
Date:   Thu,  8 Jun 2023 17:58:19 +1000
Message-Id: <20230608075826.86217-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move some common helpers and defines to processor.h.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h | 38 +++++++++++++++++++++++++++++++++----
 powerpc/spapr_hcall.c       |  9 +--------
 powerpc/sprs.c              |  9 ---------
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index ebfeff2b..4ad6612b 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -9,13 +9,43 @@ void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
 void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
-static inline uint64_t get_tb(void)
+#define SPR_TB		0x10c
+#define SPR_SPRG0	0x110
+#define SPR_SPRG1	0x111
+#define SPR_SPRG2	0x112
+#define SPR_SPRG3	0x113
+
+static inline uint64_t mfspr(int nr)
 {
-	uint64_t tb;
+	uint64_t ret;
+
+	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr) : "memory");
+
+	return ret;
+}
 
-	asm volatile ("mfspr %[tb],268" : [tb] "=r" (tb));
+static inline void mtspr(int nr, uint64_t val)
+{
+	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val) : "memory");
+}
+
+static inline uint64_t mfmsr(void)
+{
+	uint64_t msr;
 
-	return tb;
+	asm volatile ("mfmsr %[msr]" : [msr] "=r" (msr) :: "memory");
+
+	return msr;
+}
+
+static inline void mtmsr(uint64_t msr)
+{
+	asm volatile ("mtmsrd %[msr]" :: [msr] "r" (msr) : "memory");
+}
+
+static inline uint64_t get_tb(void)
+{
+	return mfspr(SPR_TB);
 }
 
 extern void delay(uint64_t cycles);
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index 823a574a..0d0f25af 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -9,20 +9,13 @@
 #include <util.h>
 #include <alloc.h>
 #include <asm/hcall.h>
+#include <asm/processor.h>
 
 #define PAGE_SIZE 4096
 
 #define H_ZERO_PAGE	(1UL << (63-48))
 #define H_COPY_PAGE	(1UL << (63-49))
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
-
-#define SPR_SPRG0	0x110
-
 /**
  * Test the H_SET_SPRG0 h-call by setting some values and checking whether
  * the SPRG0 register contains the correct values afterwards
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 6ee6dba6..57e487ce 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -28,15 +28,6 @@
 #include <asm/processor.h>
 #include <asm/barrier.h>
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
-
-#define mtspr(nr, val) \
-	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val))
-
 uint64_t before[1024], after[1024];
 
 /* Common SPRs for all PowerPC CPUs */
-- 
2.40.1

