Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247AAD3076
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfJJSfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 14:35:44 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:56927 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJSfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 14:35:43 -0400
Received: by mail-pl1-f202.google.com with SMTP id x8so4371069plr.23
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 11:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=kKdN3OX3CtBaAFl02mXXGN9Uw9dpGcwGpg9dBRYNrYe+L/yTf7H2ZLZJZK2knPepwa
         vtBZYFcyb3823+jWUniHF+ovklg4cHR2CBJfkXCDjshpGhSBhiJu8S8GD1OErEsr2JvN
         Uml0+MFhqs0Ium2VRXFp9k7RE9Xl5XBRbmn5a7f9AGxS5oaDXK60PowXAILjTwM5Oopm
         +B4GqcXZv7sEth/Ua24ySRWpbRxXDB8pngGF4dzalrsSWROXSglxtog6gTlGS93vyrPI
         ngK2v2GbXlm+bcn9/WGl5IrpaO2sjzv3PDRj5D7MH55T3Lh65HRW7FiRFQnmusHLQhlq
         tiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=P1g40f5LmZ1ZSSLL+BkxBrelPR71kfsURUqD2h3IRVvC15VIwyqRXitW6QjWhArnHP
         3OgnyjOeETD20hCUME/svvfVuWwyy2+hfi+keIE5R0agAFi66Ov9GaVYj87BXPimgGUu
         xKFVguOoD43E+zCaxSW+7ZTj6IoK6vQ7YbOKTYRWQELoxicj8pIIkYMZISNEkqnoOsUC
         yFtpuAi+Tx7GJJpHf9q7kBCn+jDL3mD+0+cXAAAAv6Hx2wOlFTxapMDza9ZveiIuCX0t
         gyno80RlOs95I0QWMsqegkG6soAj1VWDjEzgXmFc5NJkqU5yjFjfTWq8MwG19dldd29k
         bqrA==
X-Gm-Message-State: APjAAAVJki3iGVs9QMw9rxHXJONqNG704fLSIfux5f2N4mv8CiC2x8v+
        LwGWqQTRDlOCRyCFiMhN49v1odyNRgrHEVil1vsB7TWfW65Ew/ymKdDDDvFTxLAERDlf18MI7o0
        ZFuXXJR6A/fQYvARajCDqdf3/NuAT35EgfcEOWu5cE1PzJG5ljBljnA==
X-Google-Smtp-Source: APXvYqxaFHpZyRfjoYxSLO8vh1f5AyAY5wQ6uNQfo+9W+NQpK40h4qWKe74eEGWtwF+3QqinDw94Z3UU9w==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr12828634pgj.91.1570732541309;
 Thu, 10 Oct 2019 11:35:41 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:35:04 -0700
In-Reply-To: <20191010183506.129921-1-morbo@google.com>
Message-Id: <20191010183506.129921-2-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/3] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The movdqu and movapd instructions are SSE2 instructions. Clang
interprets the __attribute__((target("sse"))) as allowing SSE only
instructions. Using SSE2 instructions cause an error.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 621caf9..bec0154 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -657,7 +657,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
     return ok;
 }
 
-static __attribute__((target("sse"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
     sse_union v;
 
-- 
2.23.0.700.g56cf767bdb-goog

