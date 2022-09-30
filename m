Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD055F16A0
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiI3XZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiI3XZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:25:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBB9A7AA8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pf10-20020a17090b1d8a00b002037c2aad2bso6522894pjb.0
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=mSnHxxlxtHo6KvIN5t/qvi7UQX4NADLYciTfA4XVgqE=;
        b=joareyNgmX5+rQs5fq6zLBGVniGVsSPpmbHyYIzOA8YlGnavPrOTEjJMqzVSXfppqU
         8za85cH9rOCq/vcl9bFZXxRDJ9GJ+tt98NZSTQqkX6xoXjagd62B8lX8ssKwEKq5IPEY
         xOVR95AAVAGLrvoJBKzvy/IaHhYIDRxBqNPszy1pAXrlsrRcC8CS6m2j9MtAPaFT4c7z
         M2OQlUxaiZDUYK3uxIqphSOAqKzeKl+y1+2g4Fb2lu04fCzIdyuddK6gHuoQVraJTVPO
         L0F7nqpL55qi9dd33EdXES84PVypTIzhh1ffRKLvEAjCZ/m/rOXZSjPJt2ydsn6EmIwr
         TilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=mSnHxxlxtHo6KvIN5t/qvi7UQX4NADLYciTfA4XVgqE=;
        b=eL/aFLvgzDOU1bkykL48zf+JDMgWAF1BNc6T1+w+wY7q2h+f0Ivj9LeEa2F0jlp1Dg
         ResxVjlazlKZkhD3yW9Q61qPxWQUB+g060ms32E8KB7l5/iZQgDJ03jH4vYUOu05k2CQ
         fbjCwTF4fwoXDIzwbE4rtSptUn+CnSJ3NJsFEcxNnEATzOdzankxkPtrT8LKqJdNnrSX
         xLGifVwBjbw1m1PLmsEur0WSrIgzQPM9rkmUsgZEjZ5ZptcyZsp5nFIURKz7ml/iVai5
         gjdsz/nNTFJ91faqBe/1st3Hvh8neuWWVviD0nc5ReavZjuC9NLaZrL9sMibdjb83Dx9
         6vlg==
X-Gm-Message-State: ACrzQf02l9BZdSz4MDy521K0y6CzvYzpFVaVtlBazHE8KAiiOXwPIeWK
        KcVobTJLePdQA3U+e4NrAv8NYdcovR4=
X-Google-Smtp-Source: AMsMyM6lEVRQflIcEvtVUpLQe1g2hRIuoprTJNhan+3lTIOsMPyfIv56UP+5joYOkfs1cemfqkkTq9ZEeuM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3852:b0:202:f891:9ed5 with SMTP id
 nl18-20020a17090b385200b00202f8919ed5mr644594pjb.239.1664580293676; Fri, 30
 Sep 2022 16:24:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:24:48 +0000
In-Reply-To: <20220930232450.1677811-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220930232450.1677811-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930232450.1677811-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Handle all known exceptions with ASM_TRY()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Install the ASM_TRY() exception handler for all known exception vectors
so that ASM_TRY() can be used for other exceptions, e.g. #PF.  ASM_TRY()
might not Just Work in all cases, but there's no good reason to limit
usage to just #DE, #UD, and #GP.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index a20be92..b293ae4 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -301,12 +301,12 @@ void setup_idt(void)
 
 	idt_initialized = true;
 	for (i = 0; i < 32; i++) {
-		if (idt_handlers[i])
-			set_idt_entry(i, idt_handlers[i], 0);
+		if (!idt_handlers[i])
+			continue;
+
+                set_idt_entry(i, idt_handlers[i], 0);
+                handle_exception(i, check_exception_table);
 	}
-	handle_exception(0, check_exception_table);
-	handle_exception(6, check_exception_table);
-	handle_exception(13, check_exception_table);
 }
 
 void load_idt(void)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

