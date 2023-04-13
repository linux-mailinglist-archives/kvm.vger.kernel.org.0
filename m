Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4C6E146B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjDMSn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5F08A4F
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:48 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s2so11890329wra.7
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411366; x=1684003366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbNSmdopHWdD2/8eXrDn8O1lhc85x+0fvqbJjVSSLV0=;
        b=ns64lkz7Ny1HglhPxc3dH14AI5Aam0j7OYOcbfzAu2TA0lkaupMWeIzw0Ypz7ftSsk
         w5BUPEG/WU73TLVPc6JK1F062VWqg6j+x1q3fUKoL/psQPRIgsfWpfHqdaQLMuET3YoK
         w64nSat0SVT5kufRgxtUO5dtTPbKKbg2JDx9DoOB5EYWK73uD1DxSy22dnv7PqFOvRUv
         lrxLCpNYrdxzSAxa1vpRDmHJp+PdYIZe0y+ZDs7E99IOdObMFJjaAXIb9nXt8Dp5mLQO
         Gkqit3pdBeWNbATqiWP30LQssppNEbvAedmRJUnxaQXpAOPuB3vKTr1WW8wrc0HW843A
         JHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411366; x=1684003366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbNSmdopHWdD2/8eXrDn8O1lhc85x+0fvqbJjVSSLV0=;
        b=ATwV6KznP6zXGFXsqClHgfEBfI83MTKiMXHdnU+1FiV/YHCiP1aG4KCSCYYLwBEVb1
         aE2XC6jbTQ0YkZbwW2bljG3AXtZsGY8veuEe9puAzGZnkRxFNa90l3Fm/l+/+NtfEhUS
         izMxKlfb16Lcud+Rr3QiIdH7iBYBpcWmGL/NJ2uqdPJaE2WwlN0EOkTkrS2Cea/qBY8P
         YuUmI1k9aBWdX+usB2yJF8r08imsaDsgZDN/GZTxgbpeGFaepar/K+6OAXUFero42OJu
         TxaP1K1auCVG5YKvtQnc8780p58jPv8wxMA8QAKQq0NZzc7wGGBB55ARO5Y0eRdOTEUZ
         1dKw==
X-Gm-Message-State: AAQBX9ckR0MAz3BY9JKX7Lh+jg7om+fPek/aAeKhA3JK0JmjqkZ6+dwc
        4ZKkVTAv1vxxUtypcogy56VqIQ==
X-Google-Smtp-Source: AKy350bmLTfWaYtUsqiZEdIAj4IrVQm2K11sMKwsFwOyYYSMDyRJXdUyZ0dWbjYBiz5qAmCAYWuljA==
X-Received: by 2002:adf:edce:0:b0:2ee:e456:5347 with SMTP id v14-20020adfedce000000b002eee4565347mr2313939wro.13.1681411366762;
        Thu, 13 Apr 2023 11:42:46 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:46 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 14/16] x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
Date:   Thu, 13 Apr 2023 20:42:17 +0200
Message-Id: <20230413184219.36404-15-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of registering a one-off exception handler, make use of
ASM_TRY() to catch the exception. Also make use of the 'NONCANONICAL'
define to refer to a non-canonical address.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 492e8a292839..50a02bca6ac8 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -334,17 +334,10 @@ static void test_mmx_movq_mf(uint64_t *mem)
 
 static void test_jmp_noncanonical(uint64_t *mem)
 {
-	extern char nc_jmp_start, nc_jmp_end;
-	handler old;
-
-	*mem = 0x1111111111111111ul;
-
-	exceptions = 0;
-	rip_advance = &nc_jmp_end - &nc_jmp_start;
-	old = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
-	asm volatile ("nc_jmp_start: jmp *%0; nc_jmp_end:" : : "m"(*mem));
-	report(exceptions == 1, "jump to non-canonical address");
-	handle_exception(GP_VECTOR, old);
+	*mem = NONCANONICAL;
+	asm volatile (ASM_TRY("1f") "jmp *%0; 1:" : : "m"(*mem));
+	report(exception_vector() == GP_VECTOR,
+	       "jump to non-canonical address");
 }
 
 static void test_movabs(uint64_t *mem)
-- 
2.39.2

