Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4911245D2B6
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353225AbhKYCBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FC5C06137C
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:20 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso2542411pfu.7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4e8FTbUg169+HBk1dZxTf5xj16wJP/zwohoMOpVfn5c=;
        b=iRkujejpZw8YLK4diRPFT4duMuw6hAkmpKGb0gz30mo0lyioiIASeMXii2NU74fwg9
         px6k89R8zT4CNmh84uAbQDo8BQSR0CN86q6XpfiXl/EQtEm1rCnQHazq2YTRtKuxHXK0
         Tl3iR4JLxjpnVk09raz/utCrYXHvbNJZnpvc937z2dk12LbmbW2B0cSR1ACcpzZ9lQoo
         yP8uZ6iSG0qJSodellx0s/X8smSeijNJap0P0LFnb2Mmuhy/WTahCBwW2/XZsjsG+F1M
         k4/L4iVzRXUPOgUGYORRlt/RnEvwpOVi/mVsMFWV1FFmfdWNwbfTz3TzWexxAx4r63tF
         +N4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4e8FTbUg169+HBk1dZxTf5xj16wJP/zwohoMOpVfn5c=;
        b=WhNCpmlt/WjyzlK74ILR/WCtNV63q5IKorOsZaWHc3AIxeOn94CEXpOhtHMrNOY1UP
         bcqNO2XosOaFlQdDAgGlhfTnyp8R+SfOG3zej9R2MiZDPq2xtimMgfMGAN/lrujxflqv
         MJnFDrnS+nG66he3wEHmTX5jsGPJYFDL7iaNrO8KRzUGcqE3Ed9h4sgXV1pf0NPcUDNd
         zjCyiC0SqoMXTsyQKlKdUDtuWMof0yoc07ODD6N60l0Yi7zlnYo9msPZ5TsySy8bRvhl
         PErwTGQbVzVd9d85O9KaVNta3xwUEXg1hP9IkCbScQvBRYY2iSOQP4FGAE79pguXb6L4
         u6KQ==
X-Gm-Message-State: AOAM530AU1R/paI/zd2nLlC2U5EIciqJhM2Oy52ttpMlQE2A4O1sWItx
        TxEWdIeEB54UqUis8DvFHOze9KbnRC0=
X-Google-Smtp-Source: ABdhPJy+WHvm0ZgYU32e9Bho5jGG61UdflYsWrVa6LIB6srJTet9NUGXl7DO+cfda7iKMKFFXm3PRSDBGVc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr626041pjb.0.1637803760041; Wed, 24 Nov 2021 17:29:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:30 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 12/39] x86/access: Print the index when dumping PTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print the index of a PTE in addition to its level.  If there's a test bug
that causes an unwanted collision, the index is critical information to
understanding what has gone wrong.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/access.c b/x86/access.c
index 6ccdb76..6c1e20e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -690,7 +690,7 @@ static void ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env,
 
 static void __dump_pte(pt_element_t *ptep, int level, unsigned long virt)
 {
-	printf("------L%d: %lx\n", level, *ptep);
+	printf("------L%d I%lu: %lx\n", level, PT_INDEX(virt, level), *ptep);
 }
 
 static void dump_mapping(ac_test_t *at)
-- 
2.34.0.rc2.393.gf8c9666880-goog

