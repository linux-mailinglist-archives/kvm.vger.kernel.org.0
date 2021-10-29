Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F9B440593
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 00:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhJ2Wuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 18:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2Wuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 18:50:46 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5333C061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 15:48:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t7so11155110pgl.9
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 15:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4YNswZByf3gfeBSeFm2grms/tKfCn1RQ5gv/gS+xnhg=;
        b=ZNDTcwZKtFGpyWlRKTdz15qkh4hUd/GtwMeklt6kdtYcF3nJHZyAocA5v8LtTZbulv
         REdYVbDZ1yJ0xg3TLce9UCQ1hVHi0XZUn15mYGYe2Ok1Lzx+f7X5qKYoXj/56HNqImug
         8L5cR+E2JKmN2RR9smzMaaeDsFb2UQisXuORhSLxlDjH9D/un6u6iSovELPnaaBaNjp0
         IDf6V4AtcC/6zceqs/vl/jeuKqOjdRZyIJWd4R7C369fWxcWwtaN9YdOv5RiwQ86LDj3
         bJSVPeRXXvqPrtV6qJfjZoZJsjUJ+ze80me16xkroA2QDpbOpySgmOGsevvRGmImnlUW
         xRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4YNswZByf3gfeBSeFm2grms/tKfCn1RQ5gv/gS+xnhg=;
        b=iFVkC8ht4/eYGeWlqb8ZB0xiRvYMitNneyECK4kwF+h+U5cpcWIgWHCl/4t8pK6yhv
         lVJwwWjMo3BjvdPgGYHTnF8k1iOx2vnqlLjszKBOTgHWS5gMw7siOX8/51a7DerevOiI
         UXH02N2/iN7gGTti8B/tSuhLjoi/BDnB2r8b6yVUvBXswHHcyGtraBlYuxmyeKKIBGq7
         XbEb9QSY+nGgz6jcx/q5fJkD9tUje0YaojY509q7+6jw6x80QBKkLPUqGgDLOl7Sex5x
         ZIl1pzjujG482jbH9q2F4ltgEJobGGQXQ3XxkYL036eWdXNMcGgJPBcm/8igEEO+6YGN
         A1OQ==
X-Gm-Message-State: AOAM533K2+fkpMRC3Lwbf/1kaxxBTcNpFQtVug/4Uow0lfwhxW4+9eBd
        vAIkvDFrdN8gSC9EtZMi4V8lIw==
X-Google-Smtp-Source: ABdhPJxqMOqyfKp16tSKUfG1j0ZGdQ23vd9vI9oC6gd8/MEETG/JeAFPmzvGQGvsoD4IjLAQgmziZA==
X-Received: by 2002:a63:6b82:: with SMTP id g124mr10322625pgc.20.1635547696085;
        Fri, 29 Oct 2021 15:48:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f7sm9018460pfc.21.2021.10.29.15.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 15:48:15 -0700 (PDT)
Date:   Fri, 29 Oct 2021 22:48:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH] x86: Look up the PTE rather than assuming
 it
Message-ID: <YXx6K9l2QTwbLYng@google.com>
References: <20211029214759.1541992-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029214759.1541992-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Aaron Lewis wrote:
> Rather than assuming which PTE the SMEP test is running on, look it up
> to ensure we have the correct entry.  If this test were to run on a
> different page table (ie: run in an L2 test) the wrong PTE would be set.
> Switch to looking up the PTE to avoid this from happening.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/access.c   | 9 ++++++---
>  x86/cstart64.S | 1 -
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 4725bbd..a4d72d9 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -204,7 +204,7 @@ static void set_cr0_wp(int wp)
>  static unsigned set_cr4_smep(int smep)
>  {
>      unsigned long cr4 = shadow_cr4;
> -    extern u64 ptl2[];
> +    pteval_t *pte;
>      unsigned r;
>  
>      cr4 &= ~CR4_SMEP_MASK;
> @@ -213,11 +213,14 @@ static unsigned set_cr4_smep(int smep)
>      if (cr4 == shadow_cr4)
>          return 0;
>  
> +    pte = get_pte(phys_to_virt(read_cr3()), set_cr4_smep);

What guarantees are there that set_cr4_smep() and the rest of the test are mapped
by the same PTE?  I 100% agree the current code is ugly, e.g. I can't remember how
ptl2[2] is guaranteed to be used, but if we're going to fix it then we should aim
for a more robust solution.

> +    assert(pte);
> +
>      if (smep)
> -        ptl2[2] &= ~PT_USER_MASK;
> +        *pte &= ~PT_USER_MASK;
>      r = write_cr4_checking(cr4);
>      if (r || !smep) {
> -        ptl2[2] |= PT_USER_MASK;
> +        *pte |= PT_USER_MASK;
>  
>  	/* Flush to avoid spurious #PF */
>  	invlpg((void *)(2 << 21));

This invlpg() should be updated as well.

> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 5c6ad38..4ba9943 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -26,7 +26,6 @@ ring0stacktop:
>  .data
>  
>  .align 4096
> -.globl ptl2
>  ptl2:
>  i = 0
>  	.rept 512 * 4
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
