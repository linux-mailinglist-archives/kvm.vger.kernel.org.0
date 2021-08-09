Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20CE3E4F83
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 00:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhHIWvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 18:51:45 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42516 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbhHIWvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 18:51:43 -0400
Received: by mail-il1-f198.google.com with SMTP id z14-20020a92d18e0000b029022418b34bc9so1147287ilz.9
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 15:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=ar7510uPsZS2CDiJZAUudQtRn9csYi/4vAIPTZ+i4Us=;
        b=gR4WoqE01iw8tMUuZkDRPAPBrZomlzEQmAvKwE/WJvN68NAe5my+DyLat2Teri49uW
         cEWvHsscO/ruxr8OXQmph6LWPVhl0PlFrdinkola3k3OkA0sYzKt4sv4sa+xAd7T9E/U
         82x3e7j2Xn9AwDLy+c0h0RmhXaF1j6sE40yYimoJ+aB42qo08qKDWqhYvpSU438hzR8T
         E8LoqTp71svErsFo7eqvja9BKoJ/e+rGakua66VBEK3G7/u7/ZNQ47dkF+85r0jc2Oe3
         QDV0J5Lwl9UbEtW3AF7jm4JM+CriSx0a+1hc3tT6jn9TGTWvZom9e7MIzQ/+hDMxR4hE
         73sA==
X-Gm-Message-State: AOAM532YyDvkGrRIzgC+O3C91MygGVuNrOoVPeiP4PiqDAmM858pEuif
        Xla+JKQabHQkSY9SwG8vnIxcgFq/4mwc/q0uKXGNapZllOGt
X-Google-Smtp-Source: ABdhPJyWwg+XodjDCutfk8UULLv3kKlpbBwiMBoGdg54lYYRl5oHV1U1ybvHFx8fU08YtLmrSlffKjJIMM0khfAjLer/mhqw+sMi
MIME-Version: 1.0
X-Received: by 2002:a6b:8ec6:: with SMTP id q189mr79318iod.169.1628549482694;
 Mon, 09 Aug 2021 15:51:22 -0700 (PDT)
Date:   Mon, 09 Aug 2021 15:51:22 -0700
In-Reply-To: <YRGxNaVc1cGsyd0Y@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a51e205c928399f@google.com>
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
