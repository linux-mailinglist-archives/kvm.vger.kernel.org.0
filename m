Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DB1970D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfEJD0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:26:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35446 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJD0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:26:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id h1so2279250pgs.2
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kzx7YrBzs7ftXeZ/NY4Tra2B+q74lGAghkq7vLf8vvo=;
        b=oRAxgTCw2qiLTOEf7hRiu+o6Sr7D7S7L0nuCQ2YwxSZGzO1uDFIq+ydYp0ckL/K+6L
         fqX8I0lIDtKy2vB7VOeCgWqLfuI1F/yCw9O1MWQ+ZTzNTUTgOBPC5LVVgFGGRb4bVEZZ
         +ahfqFMNCOFJ6ktFD5FG0QWw15D3sGU74zKCXSAvHoy4gRP1l2uZKs1ppOHSd/UmzxXm
         oky0BmZVvGC/6TPo4K+8Ft37DHYC9utVahrSnAK1og56Hm0fCjz1N+FuA/YA/OmJutwL
         w8VP3eXHCNWlbAPuPLXlpISXGsTEb3YVZonBkd/qT+dJwerWgbPHx4YHiqGyp4LhnQSn
         kGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kzx7YrBzs7ftXeZ/NY4Tra2B+q74lGAghkq7vLf8vvo=;
        b=WcbMbMjs7TwyljgJeXA0Cb5sNksc0GLn6vflDB3hIZIECKIpO8ThttWDUXrlKB2YGM
         FMIZd7+8vlOzcwEP7Uu30K/JWLfKeeCyYfVRNHBc2QJ+1WKRfWLD6332xm5QD7XjQqCG
         JfUe4H/RLBibgP4IrxMpP2thyIyKMzmn7LPyaPZxgiWGBVpJWWjfyzRah6gm5Xq6w2AF
         0shtqMYvHDe3ngm8Q5H4dAuchBKO11jdKZTGr1a9vz5ZcxDsMSjY8fXnkDJM7V4Bnfc6
         tGCpwqcew7GGFzpO9V9jhewCHXyUCRiaBFl+M50KnQSOnbWQb0UMl1zkCi+d8HPto9tD
         Hg0w==
X-Gm-Message-State: APjAAAUUsHyFwoDrBtGLM4eMTq+zv5J5w7mUXVhXcy5uX1+gutikMxU0
        qU2O2oXYtJdRgWAXdSno8A0=
X-Google-Smtp-Source: APXvYqwYCzHzT+XnyCsv1kLacuUIgayHEB+R93LIoc3LlB+KUQ1YKJrokZ76/PMMuWmNkxitPvNt0A==
X-Received: by 2002:a63:560d:: with SMTP id k13mr10726794pgb.124.1557458768180;
        Thu, 09 May 2019 20:26:08 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id z66sm5225592pfz.83.2019.05.09.20.26.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:26:06 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v3 1/4] lib/alloc_page: Zero allocated pages
Date:   Thu,  9 May 2019 13:05:55 -0700
Message-Id: <20190509200558.12347-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509200558.12347-1-nadav.amit@gmail.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One of the most important properties of tests is reproducibility. For
tests to be reproducible, the same environment should be set on each
test invocation.

When it comes to memory content, this is not exactly the case in
kvm-unit-tests. The tests might, mistakenly or intentionally, assume
that memory is zeroed (by the BIOS or KVM).  However, failures might not
be reproducible if this assumption is broken.

As an example, consider x86 do_iret(), which mistakenly does not push
SS:RSP onto the stack on 64-bit mode, although they are popped
unconditionally on iret.

Do not assume that memory is zeroed. Clear it once it is allocated to
allow tests to easily be reproduced.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/alloc_page.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 730f2b5..97d1339 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -65,6 +65,8 @@ void *alloc_page()
 	freelist = *(void **)freelist;
 	spin_unlock(&lock);
 
+	if (p)
+		memset(p, 0, PAGE_SIZE);
 	return p;
 }
 
@@ -126,6 +128,8 @@ void *alloc_pages(unsigned long order)
 		}
 	}
 	spin_unlock(&lock);
+	if (run_start)
+		memset(run_start, 0, n * PAGE_SIZE);
 	return run_start;
 }
 
-- 
2.17.1

