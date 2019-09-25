Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8737BE221
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501928AbfIYQOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:14:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37591 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501893AbfIYQOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so7653719wro.4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ejqQNMoRRAMOPTMnBY73/g20YxH+Gw85E8gBw9N3Y/k=;
        b=Qdf8fwgkYSPaShtkJqD6ILUQxwqOpCYK4A2U8aOftt9Ih9SkTbAU9D8kLgZoxHlL/0
         uk38TiQbn7RFI2gjb3Ifjy7gSZWjLDOyhaMCCUei1AlG0zmiQ6s/grhngk+C0QL21nHc
         lxSKZZeIMrafx3jW80uHYjXpS/769AsIDiMiKz5fycVGM4W4x6M70fnW5MH3ZIHjjwDO
         TcGk4+FDQa3ugJTy4eY3p6WXCRFbIBZ7UQW3/zPw3E+s1FjT04Dx91MOIqLN31xYcHIS
         +EmRp889M9008Y6UpL2HLJszpo88fWsTY9Ymk8IFLUR6O9rMJ7kGqz3MiO1a39A8DyTu
         h3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ejqQNMoRRAMOPTMnBY73/g20YxH+Gw85E8gBw9N3Y/k=;
        b=MWWl3bzAd2k6XZVynG3372h9EElxpY8cBqlhrjlrQRzKbJ6V4fjzV9Hhbh3kPoVq+S
         BS4HSmIq8G5hEUYoZtdsJzd6XFlB1nuBoA5ZJWXw3wGpLJjb8oB9h9fptTNXAo5h2dL/
         Z+SoFNXpE4d6fKB3vBs6/bkwxtgjDbMl93YjQBZVCc+2PHZ7GORZSKfScOiin5m/y2j+
         tE1jxtR/coMYcTwmd6Jb2ep96zpvqFvZCCbcVrC0BmC+VOBYurwdDUfvBJZa93Uw1j80
         AnqtZR/9A42NimmKxuuyvBsfNn/8TTomONKqSG9X8k2TkblkkGL2mgCAjGGouSLez48+
         6X9A==
X-Gm-Message-State: APjAAAXwnoH/D8gYWD5y8qlYzHqLnn6SUOFsuJXkyIdOqL5XHJzyJtbG
        BndD2hL4Sy2NAy5wsR9bkHmAziqb
X-Google-Smtp-Source: APXvYqxGj5IuJFuiyT6keGWjixZfn2OZQZkQWiK5IokWpuBRZoGCMvd26pnI7BaZNF8Os5avfyf9Jg==
X-Received: by 2002:a05:6000:10c2:: with SMTP id b2mr9765331wrx.45.1569428069719;
        Wed, 25 Sep 2019 09:14:29 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a71sm4055293wme.11.2019.09.25.09.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:14:28 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 1/4] x86: vmx_tests: gate load guest PAT tests on the correct bit
Date:   Wed, 25 Sep 2019 18:14:23 +0200
Message-Id: <1569428066-27894-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tests should check the "load PAT" entry control,
not the exit control.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a447d39..b404219 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7203,7 +7203,7 @@ static void test_load_guest_pat(void)
 	/*
 	 * "load IA32_PAT" VM-entry control
 	 */
-	if (!(ctrl_exit_rev.clr & ENT_LOAD_PAT)) {
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
 		printf("\"Load-IA32-PAT\" entry control not supported\n");
 		return;
 	}
-- 
1.8.3.1


