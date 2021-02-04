Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F8430F96B
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhBDRSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbhBDRRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 12:17:08 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D4C061788
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 09:16:27 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id p185so3252843qkc.9
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 09:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=CWs5UE8Kdmh+MQd8bFvaWH6vN8MkKdop27j3PZaaEEk=;
        b=RvmiSNnpq5dIjK/KsaaPz8Tfp6HEdpvhnnQHoDk1y6rJOw7daASh69I/9qr3eTxurJ
         QxdhYhSdCRC08n+OT+0GZ83cLaNqw8d0GXASpB0CVFn8RkwilEwy/NfTqX22URgGRg64
         h3KIvUZs4chncId+curUsRE0pLO7Qk31y2+vE78sNziBdjWR1qR6PCBZC9QgvrfJjL0A
         uhQD3QJlhZNqHAcsVO+a9GjOG0v0uV3LSt6omfqA4hkO95jxobHq2J6wIj53soo6ksOO
         3HxqpLQd7qeK8fsN1id0eKJkt82pcGtts9Ly+gZIAo4N4PApGtoJrlf0vBO+AA+KiQ5z
         iICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=CWs5UE8Kdmh+MQd8bFvaWH6vN8MkKdop27j3PZaaEEk=;
        b=f1CTBStVZiS+YdDyiUF8vnXOKJunUEgokQZm21JixiHGWaagPTv6RVNxJdEN9aZR3M
         Pgy0fGKfP5bihbC/a31Hmn/CnQ8ItxkhlmYzQCvykF4zJjXmf/UY++wDNwOJVou2vsgg
         xveUhjICDizqFHgfZ/yGI8Rgb05CvIVa9tyrE/PFWQ9XcYdbc28P00KBxBCFnhh+fiIf
         +pzhQNRya9tWbH6VPXANDIiKfBjh2QNkKIQSS/2o6Qn6mJE84YymrdkUHXXdtDRfw2AU
         O6vsvJzPbTBohf42gvyzIEoAZj4IgA+rGqz2aXKkIPr7i4qOnZRzQ1Jtdal45YLia8Z0
         dSPw==
X-Gm-Message-State: AOAM5335BaYPRCapFL2OWi64pMN623dkeXzaKqzy8K2ivPvFv5vG/XlY
        8J5vv4xSRGarvae2j8VelF1KSx0acyA=
X-Google-Smtp-Source: ABdhPJwNFc/pfbYrCPQH1RwiV0zjReAT9g+Rvj4tY5TqJz3Zs1352G0A33nGNamEpCBSQz/ihOce7ZsjK2o=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a05:6214:592:: with SMTP id
 bx18mr236964qvb.32.1612458986469; Thu, 04 Feb 2021 09:16:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 09:16:19 -0800
Message-Id: <20210204171619.3640084-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] mm: Export follow_pte() for KVM so that KVM can stop using follow_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@google.com>,
        Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export follow_pte() to fix build breakage when KVM is built as a module.
An in-flight KVM fix switches from follow_pfn() to follow_pte() in order
to grab the page protections along with the PFN.

Fixes: bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
Cc: David Stevens <stevensd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Paolo, maybe you can squash this with the appropriate acks?

 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..15cbd10afd59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4775,6 +4775,7 @@ int follow_pte(struct mm_struct *mm, unsigned long address,
 out:
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(follow_pte);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
-- 
2.30.0.365.g02bc693789-goog

