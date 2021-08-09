Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9016A3E4F8E
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 00:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhHIWzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 18:55:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54997 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhHIWzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 18:55:01 -0400
Received: by mail-io1-f71.google.com with SMTP id 81-20020a6b02540000b02905824a68848bso12629835ioc.21
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 15:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=0GEr0YUZkyRAP1wDiFKJUOaJlg7EZ2L8Am1PwhFfBiI=;
        b=gE04oqGnavzOaBSQtUADtyZ6mVNxppzKehtHkY08DhC7A5scbJEuVE1XaiBT/u68Bj
         JGxWR4Lu7j7iaVkGO84RkNPMFFPD2JbaWtTgMxKLNZjFYAgFHP5RuwSPnDlW5oSbmGMy
         J2y11GDuGsrnma24d+J+zbfKT50+LWuc4pHmbD5y9GOh883B9tqgmXcy5pt1ITSDNW39
         cJyS9eRMKD4FelatrkpuEAWokYxQd+VF6sMTLMboAmRK/HTiomVUzGkjWeDgQFq3TLFj
         xT42/xCYJi4ySC9obkyzqs/3I0RifyfKIc5hNVCKZ+oza8zrYjF/iieMm31kaapDJjMM
         Sbpg==
X-Gm-Message-State: AOAM531CClozTRtjPnXoyh3PMF5KPbSMfaG5nXzcjSmkGdJdSdWRUZET
        n7lSVWZCNeDGbV2Jmc32O7J9kykEVmH8F1MFo/v6Ge6RSDo8
X-Google-Smtp-Source: ABdhPJwk0q1pYnZGZs4kh572MkPxHqbPaEAtwhr92LekdjMLybPHJTxNw3B6UeE7+39DTbR9YWviD15VoC2pUv0OCqZf7aJiMbhY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:618:: with SMTP id g24mr24712725jar.94.1628549680460;
 Mon, 09 Aug 2021 15:54:40 -0700 (PDT)
Date:   Mon, 09 Aug 2021 15:54:40 -0700
In-Reply-To: <YRGxNaVc1cGsyd0Y@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033f7f705c9284592@google.com>
Subject: Re: [syzbot] kernel BUG in find_lock_entries
From:   syzbot <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, bp@alien8.de, frederic@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mark.rutland@arm.com, masahiroy@kernel.org,
        mingo@redhat.com, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, sedat.dilek@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, willy@infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mon, Aug 09, 2021 at 02:02:22PM -0700, syzbot wrote:
>> The issue was bisected to:
>> 
>> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
>> Author: Mark Rutland <mark.rutland@arm.com>
>> Date:   Mon Jan 11 15:37:07 2021 +0000
>> 
>>     lockdep: report broken irq restoration
>
> That's just a bogus bisection.  The correct bad commit is 5c211ba29deb.
>
>> kernel BUG at mm/filemap.c:2041!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 24786 Comm: syz-executor626 Not tainted 5.14.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:find_lock_entries+0x10d5/0x1110 mm/filemap.c:2041
>
> This patch should fix it.  It's not just removing the warning; this
> warning duplicates the warning a few lines down (after taking the
> lock).  It's not safe to make this assertion without holding the page
> lock as the page can move between the page cache and the swap cache.
>
> #syz test

want 2 args (repo, branch), got 4

>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d1458ecf2f51..34de0b14aaa9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2038,7 +2038,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  		if (!xa_is_value(page)) {
>  			if (page->index < start)
>  				goto put;
> -			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
>  			if (page->index + thp_nr_pages(page) - 1 > end)
>  				goto put;
>  			if (!trylock_page(page))
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/YRGxNaVc1cGsyd0Y%40casper.infradead.org.
