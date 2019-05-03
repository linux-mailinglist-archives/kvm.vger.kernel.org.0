Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21A13365
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfECRyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:54:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46904 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfECRyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:54:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id j11so3217303pff.13
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YpwcJhC+aRde9DQlu4qky8jgwkS9GBatmOhNjkN4cD8=;
        b=LoW24bqchOPdHaW/ZcyABCuO5jUh63XHskisHJIEZT8Epg4EC3BwXDQWHSnafdaon0
         U2K8Z035+2buzezqZFRViXQZZSg+BtpfJv/5RMI/WFcjnjlKW4Dt+pYiHpeEcOqbBaAe
         wNG9ewzViDx3f4wmzQXs+YomQT4+BlpyrLdyTy26EfUTGpAvp0g66ip7v/Y0bycdl85Q
         /GrCh2nMQy35znRMyTEMVkMrUDDa/3zvK/BAR0WxGgJ1l0/XpXiaYrLWsIZX7/VGNkPR
         PxVE9o5HJ7fnEhZw8PVAiWRsjeNRJZ+E891vP7n+mdkVw6r/bQ8fHJKvJFh4PnXz2Y5g
         w3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YpwcJhC+aRde9DQlu4qky8jgwkS9GBatmOhNjkN4cD8=;
        b=h/6C3YjG8LlJlS/CQMjPZg1QN+7pe8/p5M0KTK+BWtCczjP+RjBLXLyerA7YuH9alI
         xP+CYdhBM3p/IXKJywO3pVJtdXW2abe5P8x/94kplvDt5bQ6LXAZEDZGo+dNNNm4Y6p0
         MEsWNgVnhWIIxWhC8yn3wYe0ti7Yi1Dp26gA2OZEeW4iOSjgH8uylZU9V9wcA8P/xaTD
         hg8OICzUvHIypdgGqGOIMbRBihvoLJoAK6bMWusR7wApNPvKEXZ79zxCMdZobmTLwAJO
         9rNw8t+sxMSIQcro+z/tpMJU3sksi0cxaJCGDgb63nnMVQkuz0yyNtLt/Y8l565jWpqn
         vA9w==
X-Gm-Message-State: APjAAAXYHwFj/AmeKNqsVr0xRLPEoqOFJHboKzPwJUimWIlsrT5s1jNf
        WjC/bI3FFjOT4jjQB6bzKQg=
X-Google-Smtp-Source: APXvYqwdAQQDDaXkmHNiMumIavT4E4QZeTfiFzSHEaB6pdK09GIY5B3J7lDDdTtUCtOg1tWeNWjZ8w==
X-Received: by 2002:a63:8a4a:: with SMTP id y71mr12220822pgd.270.1556906076200;
        Fri, 03 May 2019 10:54:36 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p20sm3717311pgj.86.2019.05.03.10.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:54:34 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v2 1/4] lib/alloc_page: Zero allocated pages
Date:   Fri,  3 May 2019 03:32:04 -0700
Message-Id: <20190503103207.9021-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503103207.9021-1-nadav.amit@gmail.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

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

