Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD31B162EF3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgBRSsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 13:48:06 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37998 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRSsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 13:48:05 -0500
Received: by mail-pg1-f202.google.com with SMTP id x16so13910255pgg.5
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 10:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mUCg79WyMDbLxcG7uSEM7XFzy4Eo8iAxs3oCavIjWFs=;
        b=pziMD2Jsu2b0vq9lw2bBmxIrkSUC8VKVp/8B4Pw7kAdkCfYavMg8imPAlC9/8VuRrm
         NPmdmDGRkk4fWlUBsM5KeJPrpxYrCH9N50jlSPcxwEvSq6akDdnw0vKVRmYoz9lP4W5w
         ngOcUKBRmQ7djFvnnoLaa9uEAtd4VBp4jJ8MfthW5Pua2dHBgNLkSs5pzZk8HmcoCzu6
         Pg7oU+k/9koDkl0a0mmI92DAHI7KpuKoSTkge/ufq2GVjEZXbYA3nFqyAz1w5eODnmAo
         VnSVNybD7CQWJJY5dGAlZUU6dSGR1e+u+W/WFMu0/EVhIC/gjr+P/iNg/S4bebRZMFep
         UKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mUCg79WyMDbLxcG7uSEM7XFzy4Eo8iAxs3oCavIjWFs=;
        b=iFT9vd+MEOWJIaECOHgtWwI0EnFm4ZMp+jeSqLtezRdC3uWqnOzO63HoSR76O/xeSm
         cd2015ggFJHN3N4EgRneZ8M80kAT0giQ1l/QKP3YCCJrdvGYwNi8c0OmVJNqOPAjE4wR
         HkkwKc26ZlzneqzTxImRDGqvuOnp6PI0+5w04SUeY5YdEky08IvOwJ5dVWiydqZ+PChD
         Q7Hkmlc1dWpKSFR1ni25Tpj0kExVOU9jnb4W6770jgx3GKMZKNCwkp1970cyjefL0Qjm
         QTB7rtUzOQvlUOPquPIApAyYzTF/tGnC5gghOU2ae4GUO9mt/KXoCJhRCToGAIIe3qM0
         oPwA==
X-Gm-Message-State: APjAAAUzlR4mJgyr4cqHS7Y4dS/SzPZAgCwfntzQ91T/tZm9pqpVlgEj
        HtzfmKtreV9YzFpm2ZAHgXfIdMgORMDbBLpX3uKqqqB2hbS9WuR0vRP+3fYhdwYYNNlAORcj1sE
        nvFOTi6x02eNs0jLL49Oaqu2UPZpKTqlBDjMVjveOoUWgO0BTBDgYls+VUg==
X-Google-Smtp-Source: APXvYqx3zhzxSNKOn5ldYpofPbZr1gJcux2SG8syIhC/e+izLZEQHemLW8fagUtzeQZA3Q9d2crvbdfTVb4=
X-Received: by 2002:a63:5826:: with SMTP id m38mr24858005pgb.191.1582051683115;
 Tue, 18 Feb 2020 10:48:03 -0800 (PST)
Date:   Tue, 18 Feb 2020 10:47:56 -0800
Message-Id: <20200218184756.242904-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Particularly draconian compilers warn of a possible uninitialized use of
the nr_pages_avail variable. Silence this warning by initializing it to
zero.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..dc8a67ad082d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2219,7 +2219,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	gfn_t start_gfn = gpa >> PAGE_SHIFT;
 	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
 	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
-	gfn_t nr_pages_avail;
+	gfn_t nr_pages_avail = 0;
 
 	/* Update ghc->generation before performing any error checks. */
 	ghc->generation = slots->generation;
-- 
2.25.0.265.gbab2e86ba0-goog

