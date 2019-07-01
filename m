Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E91C124E2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEBXCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 19:02:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40321 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfEBXCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 19:02:35 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so1711596plr.7
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 16:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hyV56YFPKawQh6EgxkiUwSvaXAvXFYuAQxlLcgZ22T4=;
        b=OADfvpzp+pvUlB2fzJwg4F/lhT17bTKFz/dvC26TiD86Tm7+itUyaM+9GvcuFeeJYb
         3bE5qUU+5KGJe0ES7OSeffhbFneBd5tSJKuA5QfNglRPNIRenPFO0D5sO+Gt+HJSDpTg
         jdBxEXbxgQ2bCmZIAskn/7ca0abnvVmUDc8cTTAVNeBdqBlfPWzB862mqA7Z0R0f/Mad
         77CTGzrwtaDiDygrRPVD4sA7ERw590+VjhqflIfgUgRKCNyBYm2BwKPO7e6IupQ5tqdD
         HmfanvlFPg0NrLWn+MnrloH1HXrnUgD+K7JGU7OIhmnAUBwOtzSwr9IQpASElt5TVsmY
         ycWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hyV56YFPKawQh6EgxkiUwSvaXAvXFYuAQxlLcgZ22T4=;
        b=gCrWpwdg5gXLnpYvIscxOygfhA/vPbAYFS5gLLtufTuNDUacxMQg6Btp72ROve2ZtU
         Zgi0mwH1xC80HDgdhFm9Dco7p/63sAb0Hpz/BK5soJbQhvMzuBHUvRTF6D4iccQylVnk
         fMXPTOTTxXT5wdjzn2xdizTroFuFhtxWwTpAooRIgoXyepDjTWGU3YAt4xoqH+T6kgaU
         6lZgIrsLlybIlqNEUChSrx1GTSdot6uIrDnhWjqtiTS51ok0uQWTlNQyEaslWQw7tA5Z
         mGpuovne5vntTlItiQEBb/3a1wBdYfW8VgGRPjh08RqokDv2bNoIxkCCmXNT0NV2q3j5
         E5iw==
X-Gm-Message-State: APjAAAWgCmWNy8UEob71PJTNvzceEumdf7M3Thm+GNqouOWshQ3jywAs
        LV8Rh66dHGDSVK0NhKgt/Ws=
X-Google-Smtp-Source: APXvYqx9f+2+HsgRbXi78DrGElVGuZrN2ufa7IwwrYm8YTe1FKj5kB3LTy0KIWMjWbZnOMMVpRM0Sw==
X-Received: by 2002:a17:902:7c01:: with SMTP id x1mr6368915pll.299.1556838154648;
        Thu, 02 May 2019 16:02:34 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id d5sm377182pgb.33.2019.05.02.16.02.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 16:02:33 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] lib/alloc_page: Zero allocated pages
Date:   Thu,  2 May 2019 08:40:38 -0700
Message-Id: <20190502154038.8267-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
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
that memory is zeroed, which apparently is the case after seabios runs.
However, failures might not be reproducible if this assumption is
broken.

As an example, consider x86 do_iret(), which mistakenly does not push
SS:RSP onto the stack on 64-bit mode, although they are popped
unconditionally.

Do not assume that memory is zeroed. Clear it once it is allocated to
allow tests to easily be reproducible.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/alloc_page.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 730f2b5..b0f4515 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -65,6 +65,7 @@ void *alloc_page()
 	freelist = *(void **)freelist;
 	spin_unlock(&lock);
 
+	memset(p, 0, PAGE_SIZE);
 	return p;
 }
 
-- 
2.17.1

