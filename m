Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C245D2B7
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353228AbhKYCBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhKYB7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:18 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DF8C061191
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id m16-20020a628c10000000b004a282d715b2so2543139pfd.11
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1xAVDlHQKzkM70YKCpZg/NA4ILHPMzItk81iCtJ9oUY=;
        b=jRSj3dOTg7ibZaKnNap9/nuXfrU1FNeW8W5m2ekZ+uQFNaVW2Zz20kwJ9ASTKE7MAA
         d9hOc95cgM5rFNeDqE/PmaJHnDv8OPsNe/TzBvu6htMd/gbIHO5hpw9Ovx3sik1m8p2N
         /3eemmE9s5HltdOmec7SDCtMY/X+BV8aXQAc3reVRS+9e3ih4t1hwkGcKHvrXZLsJir6
         U7jQn7DRWlvIqX0oHOr8e/eojwUgyqGOn0+QYdE2K9EgzVvpm7FTsifqSNst84mnsUCD
         pjLC/SdXxhMRoej7a8GWFFEVuoZelnGOj3n4LLbj9QwrISaoWkfqn4uAoAo8m0VqWjR5
         XROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1xAVDlHQKzkM70YKCpZg/NA4ILHPMzItk81iCtJ9oUY=;
        b=BrncJfiQjIBh7mcHWyCwRnrT8Sl2Lrmv9sU5bxYU2BfbzUfIbqJihRNs+mJV2X2X6e
         qNzj4M22oUKC7/7c783CCv4ML38mT2UsF3CpzhIJahq7fQ5l6neV5+7FRlfyKfSr7FOD
         9erj/7Io8XAYAVZ6Pzopgb4YJBe3M/9ipJh58ly/aOU/NkEnAjR9ZF7NK+DhbUEJipoU
         hGkZe4ZQOzHODCekX9Lua/JE5jktzl0nVThJtP9nypzo3NXFQjXabyVUdKm+NIDpQM0u
         FhzaFZluvSrWDdjuUIIa20yIvnbHWpDTsJPwX/HebaHixXOiXUCg4blojmi6taVbo0n8
         5RJA==
X-Gm-Message-State: AOAM531GI/LFHo84HHbvLLK4YZjt/OAsPGZJ6t0hjuRIYeIvjCsnXxCX
        Smdmo5uVwdDGBmetBCHzVbcuZO4L1Ho=
X-Google-Smtp-Source: ABdhPJxse+1o3kKO0U2lh/rTp3faQ5qNFAIxemcqX7T6zlleejC/u3tu1KJTXWozPTyGZ1EnZuA4d+wvSUY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bb97:b0:144:d5cb:969f with SMTP id
 m23-20020a170902bb9700b00144d5cb969fmr25118167pls.36.1637803763417; Wed, 24
 Nov 2021 17:29:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:32 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 14/39] x86/access: Don't write page tables if
 desired PTE is same as current PTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid spurious PTE writes, KVM doesn't check if old==new when handling
write-protected SPTEs and triggers an MMU sync when using shadow paging
even if the SPTE is unchanged.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/access.c b/x86/access.c
index abc6590..53b1221 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -704,7 +704,8 @@ static void __ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
 			assert(0);
 		}
 
-		*ptep = pte;
+		if (pte != *ptep)
+			*ptep = pte;
 
 		parent_pte = pte;
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog

