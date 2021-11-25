Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63C745D2B9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353457AbhKYCDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347838AbhKYCBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0969C0619D3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:25 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id gf15-20020a17090ac7cf00b001a9a31687d0so1686964pjb.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mG4tTmZbNfMkFhX/kGghJiq2Lg/0cH2cQ6d2SWnPmE8=;
        b=fKq8UWC/t1FV0TEgkkuDWQaXkqvNZK/XS7KB72OivsnqPLDunf463/TIxQzqYeQ9YT
         WgyYZGSqw8IuRTBW0YJaVqbGD31iJgb9y+3DQ63anRvAhuNutSqcVAc0qL+VSYTR0DoP
         euHxx1dZLPGxMle73Ac/Nxt4fbrZ49c480rh0uFi3ghSlaQGleTBBgeqf16v+/USOZrV
         uObvi0hGB5pLWUtl/r6kwSlR8w13t6H1fr46fL2ECAwhup6vsiGjaftcg+ArH5fpC9WH
         17iEjvRzHdwOwMO67H2FaWZWffOtFXkImfYv50dDw3kMCROzinUrUjO+v4Dpr6Eh70n2
         1sTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mG4tTmZbNfMkFhX/kGghJiq2Lg/0cH2cQ6d2SWnPmE8=;
        b=BseR51xNsrqCM4GJkZifLZYkj0qlP1eC96Q0LniJRkI1BlKmYtkDbA/jr30nwdW6nG
         KW0hGfFaYYDtW00NqubAhDaeJMfT+iu3PEMHOK0FgAeLUmcARsAbu7irw0cAUfwH0MQ8
         NmdpKh0ZpuZUZG/6XEi43itM0rIZ+pP8m8za9FVbZ1TC2B9a+x4D8rPwrP+L9Lxa5bNn
         36jkyYFZBNW25hg2iSIvP2vZ8eiyRb3AyZlRz5IHi9jGmj42E4AfhrL+wTBMJTG74gqT
         uVd4WSBRbW585puV4X5qZNywkJl+whdmqelsdpYfLD+1RjvqWzaDV8CSggnIi3e9d1lL
         NTNg==
X-Gm-Message-State: AOAM532qdGhOn/Oosy8WoHOQQ1p9gXdFVcaOvmzj0PBgPYTBL5q8powR
        sexMQgRGQzGgW4HhjNrmZBpQ4nFWNdo=
X-Google-Smtp-Source: ABdhPJysq8qMgB8Z2DLK037BiQvKI5pqr7TV4rb8SVfV59oInw+/bHqr740ca5TW6MEtdI4V9ivI/3j68aQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr626090pjb.0.1637803765056; Wed, 24 Nov 2021 17:29:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:33 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-16-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 15/39] x86/access: Preserve A/D bits when
 writing paging structure entries
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Preserve A/D bits for paging structure entries to avoid pointless writes
to PTEs between test iterations, and more importantly to avoid triggering
MMU syncs due to writing upper-level PTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/access.c b/x86/access.c
index 53b1221..c4db368 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -609,7 +609,11 @@ static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
 		abort();
 	}
 
-	pte = at->page_tables[i];
+	/*
+	 * Preserve A/D bits to avoid writing upper level PTEs,
+	 * which cannot be unsyc'd when KVM uses shadow paging.
+	 */
+	pte = at->page_tables[i] | (pte & (PT_DIRTY_MASK | PT_ACCESSED_MASK));
 	return pte;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

