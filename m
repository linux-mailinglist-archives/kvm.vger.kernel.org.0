Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5586B2EFC5E
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhAIAtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbhAIAtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69709C0617A2
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d187so17449877ybc.6
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wNuz2MXteWLoYNC08f6B+I2//IVLsJEJ/GyZH+0v0jU=;
        b=OPcuUIG+0PBDu5E5I2V6/6DWcHof9ko8dH84q87ij20/D1XroEw7Epfd4H+uCKnPta
         PfzhoikXGyMmVPx0RGK5bgaClU7qR8xW5bLHuu68SOkeGw26rkfS4S9i+SIIqK660zQq
         m/dsPJqxWSCAVb6SyyysLorqWdOu9ZlZHXwXFtm6RDX25cSf0UmQG7+WzEu6lgLlGZvf
         ewOAr2Xlb++ezYaVmhXyVi3bOqQHrqXZFomrlW3UCOMJKMeavyedMk95nPKPR3j2EVzN
         eDrfAk6eIhBUX5Njn61PiL99MCr38RlX2A8azdvg9Y1ezpyIH9uwRLMBrma/YutwaH3i
         AzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wNuz2MXteWLoYNC08f6B+I2//IVLsJEJ/GyZH+0v0jU=;
        b=HfWIQx/CxWWtz2dUNcaq1JzEOcCn/4xZCZi7KFcbw4PoUISJ3vzrURIJXP+F4fCnf3
         PD/o5sLiKB7iNLc6g9qZ+luUBJSKFH1YwnDp9VVClR+2oWxzxlf0i6UNvcqzgpCu2ePg
         EXz/H/crfQBgxNNmGAjunWvrLRY3yhXK1+Gw9TGhc7n6VcO870fu30gfKz0QkiZefnPS
         lQygLVNkJgTb0ttwuzzG/66dD4On9u1N/Gip9PrRYmCEJCUtIiXV0XommYcWw2nf7ufb
         as6XJSDfxuNMMtWRd4UIfWGmmy/wEPn8aA29yn0FzjzjOQttUjidOgYauBaYm7funfL8
         QZng==
X-Gm-Message-State: AOAM532DkeZJE8X+hd5QiT9QiZigjxqAJA30tBsQbhR3QGz194IK3hj8
        4avjnaMy/6E5GQKrZozHaKghRkOEKA4=
X-Google-Smtp-Source: ABdhPJwLb6+N1nSXsCxoI5Fb6X4bdbTQ5A7peRNyMkYnd5Ubl1hltrhpMuXjprYk22tnvJ2xiSOJ80a8U6U=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:5582:: with SMTP id j124mr9345524ybb.309.1610153277629;
 Fri, 08 Jan 2021 16:47:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:10 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 09/13] KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query max_sev_asid directly after setting it instead of bouncing through
its wrapper, svm_sev_enabled().  Using the wrapper is unnecessary
obfuscation.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a024edabaca5..3d25d24bcb48 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1272,8 +1272,7 @@ void __init sev_hardware_setup(void)
 
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
-
-	if (!svm_sev_enabled())
+	if (!max_sev_asid)
 		goto out;
 
 	/* Minimum ASID value that should be used for SEV guest */
-- 
2.30.0.284.gd98b1dd5eaa7-goog

