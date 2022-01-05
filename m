Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7036F484E6C
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 07:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiAEGmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 01:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiAEGl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 01:41:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3DFC061761;
        Tue,  4 Jan 2022 22:41:59 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so2538897pjd.1;
        Tue, 04 Jan 2022 22:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=80WJqN+L9qqK1VevraDHrAQhOn8fFgJ49Yyqba/kVgE=;
        b=mLoTP6tD2vbWZRzney5iVFMHPgQX971dvi8PX3x/1spC+nn65T4R/f0p0YtICJMAQF
         cJXyzL0rsGQA8NHCY9cwA9gmnVQg90koakFiTA3k8FPrbJA0j7UM9hIYKcuhlJN726qN
         w1+tMGN/lHW9kwkLJT16vJdLl6eiD68nt1vw2MuQgldBbOBd/E45fciYOnwQcNLcF/Md
         +1Vl0Cog1XEFP2JO0iKY32BNRo7sj/f+FVYSmrwoDwxU2VgIv7a058MWsKjp13kQRCAC
         NMiDWjUb0vIxavIvQ5MB1NsOhBC3NV1ERRWjkHwl9wGX0idZ5k/iG/Aiy4rrsC4YHmyl
         LzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=80WJqN+L9qqK1VevraDHrAQhOn8fFgJ49Yyqba/kVgE=;
        b=LM/ZBXWT88aC5m+OCrc/i1WrbnspwSXXdnqKGE3wP6ygujLnaejhld0jPQoWKxHX7G
         2mrRsth6YgMIY2yN3+8dqmFneroollQ5OhrbT54w3OqsB6L/AzQdBAFr1aOkXjLgYML3
         ZSbGD0tNyyUHnxho1tEjjKaVoc/CIQ/HT+i/WduXrIb6q6BXA+pPEluXSqZwuNDnhgMs
         pBEIu5m1raW2zAaNxnjGYZsG9V3y5ZjUWCswSPnrueKNlzV96BSkeGwdiadh/uY2hX9g
         S3upt5xy41nPd4wDxvAXMBE6Aj+3kJwRY3Z0orhLRZuGk53K9bAFGcyc564kJwwvLTTT
         Y1+A==
X-Gm-Message-State: AOAM531SD45BwMf4O+cFgAfenULWPN1+6e/TbC0k7Z6o2GCOd0+MP/p1
        i6ZpCz0vXtjRsLTv0TD1v1rAqT3zzHSgAg==
X-Google-Smtp-Source: ABdhPJw9Bg52wHvEKY5b/P79AOJK5xD3jfuvEjIcDXNssNx1K91iEpKUCh/kkBKo2TnKciBgpceaTg==
X-Received: by 2002:a17:903:2343:b0:149:3d87:c792 with SMTP id c3-20020a170903234300b001493d87c792mr52557130plh.72.1641364918776;
        Tue, 04 Jan 2022 22:41:58 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.googlemail.com with ESMTPSA id gf4sm1259413pjb.56.2022.01.04.22.41.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jan 2022 22:41:58 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: SEV: Add lock subtyping in sev_lock_two_vms so lockdep doesn't report false dependencies
Date:   Tue,  4 Jan 2022 22:41:03 -0800
Message-Id: <1641364863-26331-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Both source and dest vms' kvm->locks are held in sev_lock_two_vms, 
we should mark one with different subtype to avoid false positives 
from lockdep.

Fixes: c9d61dcb0bc26 (KVM: SEV: accept signals in sev_lock_two_vms)
Reported-by: Yiru Xu <xyru1999@gmail.com>
Tested-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7656a2c..be28831 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1565,7 +1565,7 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	r = -EINTR;
 	if (mutex_lock_killable(&dst_kvm->lock))
 		goto release_src;
-	if (mutex_lock_killable(&src_kvm->lock))
+	if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTING))
 		goto unlock_dst;
 	return 0;
 
-- 
2.7.4

