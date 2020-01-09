Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82A8136177
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgAIT7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:59:03 -0500
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55829 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732883AbgAIT7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 14:59:03 -0500
Received: by mail-qk1-f201.google.com with SMTP id f124so4885543qkb.22
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Jf5B4EbQ+30kjad3rYjf3nQGksGo1BPEiNIOzLgULXA=;
        b=S0pffzvIDcM3Erqu+B6kTPNDcpFqNGr5Lgn1Fru3tO/n7DHI2gxYrjybPEJWWCh8qJ
         Pq0rgh1x4T67aJo9Y/zOOMYHmaBy/jb6Su0M5dUAAiR9WjHyU+YkuKRtnzHYWGCyWKyE
         MqwTw1DzPgVrFVIXrMNlxC3ecz6b3un5RTrwDgI00pOnvxkf6Wy1J5pEUYd0lVc4izWr
         VWOj3Nyud4Ev6G1bkQDxfDiynv0ORLWJeBXNAAy1Xa4s5vRAYDSYRYx6SXZbxDu/s+fy
         17QqQeerEc+n7g0sUmMtpqMYLtTi71Zc7Mkp0zM6VJIhpvpLIV8t7L68BkFDNQTCyWfp
         85Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Jf5B4EbQ+30kjad3rYjf3nQGksGo1BPEiNIOzLgULXA=;
        b=tsAgOBDpUTn3/vo0zxewHV5UmBYLRR2/dATR9qTcd2WzfseN0JrFIOkZLG+4xm0Vru
         /hRaW21Ur6KDyo5s/mZWOAx2eT0iC4NqOcPexOXxw0at2SVmXImxbU/HP8qug9xQdSxQ
         tlehjaJZ7mON7rv7CUAmG3cR9nSU5M6O+OtjoRysIZ0ZgG+R63fsbUoM94ZooXXjX5WK
         UtMrk0aL2FbekTLTnaw8gWAIDbHQfHcVsT6UqRz3su/dhAlcIGneS1vnmESE+8E/WNGc
         BQk3zWjCnn42XtXjv/qZFsydgVPHNgt63qkbowcSLFUob54JE/ScyoEwnVz9PyzATvTz
         H+TA==
X-Gm-Message-State: APjAAAVcwb8aGCbQduqYOhqEJF2Lmiv0VuLR7O7DTLg02JqKqV/lk1Os
        InfVj88LGLF9GyCnZSmxCrGFtLHD
X-Google-Smtp-Source: APXvYqyFkOSjGrU2IETPDfcC3pAk3kZTILvTb6+kfTasc242E8aC+Ee9MsLPq6k3SOTw1KCiopXNnjnf
X-Received: by 2002:a37:e507:: with SMTP id e7mr11506262qkg.358.1578599942496;
 Thu, 09 Jan 2020 11:59:02 -0800 (PST)
Date:   Thu,  9 Jan 2020 14:58:55 -0500
Message-Id: <20200109195855.17353-1-brho@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH] KVM: squelch uninitialized variable warning
From:   Barret Rhoden <brho@google.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If gfn_to_hva_many() fails, __kvm_gfn_to_hva_cache_init() will return an
error.  Before it does, it might use nr_pages_avail, which my compiler
complained about:

	virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
	used uninitialized in this function [-Wmaybe-uninitialized]

	   start_gfn += nr_pages_avail;

Signed-off-by: Barret Rhoden <brho@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9aced677ddd..f8249b153d33 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2172,7 +2172,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	gfn_t start_gfn = gpa >> PAGE_SHIFT;
 	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
 	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
-	gfn_t nr_pages_avail;
+	gfn_t nr_pages_avail = 0;
 	int r = start_gfn <= end_gfn ? 0 : -EINVAL;
 
 	ghc->gpa = gpa;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

