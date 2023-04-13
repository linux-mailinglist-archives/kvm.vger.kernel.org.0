Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B026E1466
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDMSnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB5583FA
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g5so18542078wrb.5
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411364; x=1684003364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wviqyZ85KGfFUzxOBpv3myd0D/M0XiS1I9CvoQwMgnY=;
        b=f5kq15Nrt9zSQ+lV03e5MG+DAm1TrRRdVx03AbbuvcEfN4nEYpU2yoL4rzYNU2TITJ
         Hsw3c8Cr3JW+grExeVccD/S3I84Oq+X8sA1zATGZNRDn8PpB6NvDNuEcOW2tF71Nu7IM
         uYeqgEpOrCf79aXCxZFpIoiD/HAWywkg6GTspXKrotuxg1dwBuZQix0DY3IgA/Ljq+/W
         1GrxriLpxbCykH4nXZycFMS5h3exbtHx+MBj16E7stqeNw6aAIsec0f9JXaFlXlxPH2l
         4ObmijpOlkRPrZR5TE5cRttgot6p22mKyekzbwElujvVTdOL8Zm+nBXUTJ2wORvaAQqL
         twDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411364; x=1684003364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wviqyZ85KGfFUzxOBpv3myd0D/M0XiS1I9CvoQwMgnY=;
        b=R4LBsHlqSb1rCLqoVMDp5c+QMibb7O1Mp5UvCB6Ci/y8xGQrbG1E8PGsm5xTV74MI8
         YD/ULAHYz5vAnLKcbAM6RSQrWD0kcenFZzl+Soh09CN6D+dRYR0d0NJ1hXy92egn4vqF
         bsDVH+zNYtya+pA+m8K98v+rW3WZeME3cHD1I0dtm6KP+DrMiZZtgDphLmZeOPpUjfZ8
         lZSVZoqSH3iECzgKqpgshdmLAsov8b8YmRYTbvfiYWoynUb0T53kMnG8eqpaKMYzjhmI
         9ZVImqOpsDhhqstQTYcb5FKhjWvTCMnEIZYfZNoibXMAuCriAbnyUl9btlqORvu2j+8C
         WVXw==
X-Gm-Message-State: AAQBX9fj60gWKpXqEJFkpKgxaYiwJebPg8bGGTM3wLHbHuLuJ9+YfqrW
        DSQhPp3cAvmr7FTFJ8DWcgHR5xNX3hy/wFEXkgw=
X-Google-Smtp-Source: AKy350YfgrH8WBJgrERCwwfu4RcquC5uYCsGZIJ6i8Kaaa03zpX4/v18xqtV8hjnfKI9uT4Q4ec1+Q==
X-Received: by 2002:a5d:6a82:0:b0:2d3:33d4:1cfb with SMTP id s2-20020a5d6a82000000b002d333d41cfbmr2172302wru.36.1681411364609;
        Thu, 13 Apr 2023 11:42:44 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:44 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 11/16] x86/emulator64: Relax register constraints for usr_gs_mov()
Date:   Thu, 13 Apr 2023 20:42:14 +0200
Message-Id: <20230413184219.36404-12-minipli@grsecurity.net>
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

There's no need to hard-code the registers, allow the compiler to choose
ones that fit.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index c58441ca798c..4138eaae00c9 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -421,7 +421,7 @@ static uint64_t usr_gs_mov(void)
 	uint64_t ret;
 
 	dummy_ptr -= GS_BASE;
-	asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
+	asm volatile("mov %%gs:(%1), %0" : "=r"(ret) : "r"(dummy_ptr));
 
 	return ret;
 }
-- 
2.39.2

