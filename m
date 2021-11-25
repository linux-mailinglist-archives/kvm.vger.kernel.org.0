Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879F245D2BE
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353548AbhKYCDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348224AbhKYCBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:09 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC447C0619DE
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:37 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z4-20020a656104000000b00321790921fbso1451004pgu.4
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IAf626fpBKMToVwu2/R653BhTvHl9nhvfypxHgob3xI=;
        b=EjCZcbZzFtOyczbEmyCNxHJJPeZygKPeb2MEVo6ESU7pW2jr8uMP5tFDzBTOX3DqmG
         FU33VREKtcU0XYmZZpB9NyrYIt7HLECLXgruIouEZ/Kv/vpX+d5w68V7iPxwkz6HKoV0
         oRMEhToxfWEoidn2UtGy8yhB1jpGASBuJIGdcifjtIyXj+h/6fidXun/kkgZNvySpCwk
         NzqAFJNFqB2zXLpnWPdQSeM756ZRCpMaIMuE/TJVOdCzO+k/91bEZvVsPVqNMOcRKHIG
         3REGPiw5ccKmeUlP4pQTCXtkpBdnt7XqYcSHS+ljzSoPxaiTYyBwfwGOBAeh8GkBEKYy
         TJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IAf626fpBKMToVwu2/R653BhTvHl9nhvfypxHgob3xI=;
        b=zHGPuwiRRGaveh3gc9eXyotyxta+yuqJ+ppqMN53h9ek6ZvdkVuAWfL+pMpR0D1Im7
         Ee39wZ4cZg8PEr2qA+mW22TAuCGKuD98J6YtdeN5Oa7uzc57tKIxzmxlcGIUKmmCqZbs
         x3obE9TF3sSFe+TfwFiepCyNji19vbxS02bzlnmBeRn7YIa7ypeSa9emzBcaewBtJ3T2
         TZd1s9KuJ6sw5T4y/2lZNgdfKZ8w82pXI23ZlfQ3U5YJUEJcLxx3kvvwhthdCn0W5Ep/
         jOrLM79EbLYp+ELGI9P9KkM8DRwTcL9mh0muBDGqXdZCpZacrak93hR955+xB4Z1uh38
         N/rQ==
X-Gm-Message-State: AOAM530rmU7o68tvrJbuCDs4EIBUYgjjaEJ6o0/pXdEcme6lBmE0xjS6
        MNIPTINxtjRVd8auEVJb2VmtHijIyZw=
X-Google-Smtp-Source: ABdhPJzYAfeJcmAPBr0cSFufUYvyppWRDZGtkDEPsCLsjucoH57WSgH/7OaVGIVJRUxDa7KeNtqDAi/SsBk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ad47:: with SMTP id
 w7mr2269465pjv.16.1637803777482; Wed, 24 Nov 2021 17:29:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:41 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 23/39] nVMX: Add a non-reporting assertion macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a version of VMX's TEST_ASSERT that doesn't report.  The output of
basic assertions is annoying, and other than inflating the number of
tests to make KUT look good, there's no value in reporting that KUT is
working as intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index c1a8f6a..47b0461 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -9,7 +9,7 @@
 
 void __abort_test(void);
 
-#define TEST_ASSERT(cond)					\
+#define __TEST_ASSERT(cond)					\
 do {								\
 	if (!(cond)) {						\
 		report_fail("%s:%d: Assertion failed: %s",	\
@@ -17,6 +17,11 @@ do {								\
 		dump_stack();					\
 		__abort_test();					\
 	}							\
+} while (0)
+
+#define TEST_ASSERT(cond)					\
+do {								\
+	__TEST_ASSERT(cond);					\
 	report_passed();					\
 } while (0)
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

