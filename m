Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849B13B0F19
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFVVDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVVDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:09 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7F0C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:53 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 44-20020aed30af0000b029024e8ccfcd07so516793qtf.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8yKH6rVnVFgj2jFWvX66nVJHYzWTfB4k9pf2/C93MtE=;
        b=DDFs1peMNW1wuVIiHhmna2BbrolwZ/I9Y/XZaHgZJH/Qal368vHng2oUuI6oVEo+SJ
         VksCCq99IAmBc7YAsAlRhVPXLwJinUupKPLBJhuj7gnO+AOjdTBNwT8OF2/9y9rnk3xS
         zKbwLVxw5xbiCxc1pBgieroEGpAreaPNK4RNqtrq/GJxJrTakhxqAyjWez+d/aDesD7r
         QySAmM6THYn2tQjRXdwF3ux5yZMFRu21EaVwkhGJugiZ44vjeNf+L7t3NXCqFnQ7661W
         /ilC2sk4bgrdheiieNi+cpqx9O6ai+h5059aMpcAwM5SGVbU0Uzr7UCHYQfGEAU6jQUE
         k+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8yKH6rVnVFgj2jFWvX66nVJHYzWTfB4k9pf2/C93MtE=;
        b=gaWs7b/qGulK7GsZ1oUik+GU2kQoqt+FWWz02KWufbJ7NYh9zpq1gmAaxIG0hhQj92
         CkdXoO6EeAvitqlo7WhyFI/drzKs+Qq6WY/629IqfpZ1GWkeXpQBbjADgplxl4o3UNIJ
         FnH4wbEI+LrJMFwE+Llms5nqzVesyg7brEzvQksk/ADd4vbQvLM+7KFfTqghj22Cp6G+
         7yS1VE7yahQLMWzZeMivEJ4xflqPAmzNPDygiQMcAIgf1smxonCFWCfDNmA1AIG63Fl8
         +8pBSImJTh3F7YIx3clvQazxMpry9wi9WXnEdfi16DRETEXo+g7OZ7HrjZCj1T2HKEzh
         7ZZw==
X-Gm-Message-State: AOAM532zYS7p0eHcn6BcfFR7CxaYbxZ/x47o5okB7ixIG3hPHoFC3jic
        hTBCQKE6xs+MXYahphfRgDqPl5WJ/Ls=
X-Google-Smtp-Source: ABdhPJwxIW7OCjoi38/03I7tBOKd3y/ABkvDHzYa0XmllIzeE0GK45/h9U6hb1ElYSBgb1srFrOKTijuMpg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:cc8b:: with SMTP id l133mr7666074ybf.518.1624395652220;
 Tue, 22 Jun 2021 14:00:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:36 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 01/12] nSVM: Provide expected and actual exit
 codes on VMRUN test failure
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Be kind to debuggers and include the expected and actual exit codes if
VMRUN doesn't yield the expected exit reason.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2c85a30..df4c60a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2186,6 +2186,7 @@ static void basic_guest_main(struct svm_test *test)
 				  exit_code, test_name)			\
 {									\
 	u64 tmp, mask;							\
+	u32 r;								\
 	int i;								\
 									\
 	for (i = start; i <= end; i = i + inc) {			\
@@ -2203,8 +2204,9 @@ static void basic_guest_main(struct svm_test *test)
 		case 4:							\
 			vmcb->save.cr4 = tmp;				\
 		}							\
-		report(svm_vmrun() == exit_code, "Test CR%d " test_name "%d:%d: %lx",\
-		    cr, end, start, tmp);				\
+		r = svm_vmrun();					\
+		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x",\
+		       cr, test_name, end, start, tmp, exit_code, r);	\
 	}								\
 }
 
-- 
2.32.0.288.g62a8d224e6-goog

