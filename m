Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1713E4F89
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 00:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhHIWx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 18:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhHIWxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 18:53:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78E8C0613D3;
        Mon,  9 Aug 2021 15:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JyJ5X/zIVvUaHKHLTr1RSzm14FwgxMoXR2aQx+rj2lM=; b=ip6fHkA6nYgf1O0oDkmv/N+zFM
        ejIOmIgJxrAsLAwqK0PN1apifHvOcnA5BtGDJJlyYj8ibialXcQTvG1Gqe5qkC5l+e+8Yp4t8BRww
        A06LGLE9MtI2A8cexKCBtzOJr5G5mfQUYI9RqGmhKt19aDeRerkplAI93ory9lF9P4e2qilCi7HKc
        qHbPOqX4qpcQZEvoW0M9h+SCTkX8rSwcNQu2I67lbreHDmy5kvkk7hBcGQoRc6tOLMPuA4sPd33y5
        2LjZgHdrPEFkUq7MtRrKnTlnULUp4HvyH0Iv210+V6+Ljeietd3I5+v2+xcTEEt2/s4hsh//F1DRu
        tQsDGY/A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDE6H-00BV4B-IC; Mon, 09 Aug 2021 22:50:38 +0000
Date:   Mon, 9 Aug 2021 23:50:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, bp@alien8.de, frederic@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mark.rutland@arm.com, masahiroy@kernel.org,
        mingo@redhat.com, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, sedat.dilek@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] kernel BUG in find_lock_entries
Message-ID: <YRGxNaVc1cGsyd0Y@casper.infradead.org>
References: <0000000000009cfcda05c926b34b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009cfcda05c926b34b@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 02:02:22PM -0700, syzbot wrote:
> The issue was bisected to:
> 
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
> 
>     lockdep: report broken irq restoration

That's just a bogus bisection.  The correct bad commit is 5c211ba29deb.

> kernel BUG at mm/filemap.c:2041!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 24786 Comm: syz-executor626 Not tainted 5.14.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:find_lock_entries+0x10d5/0x1110 mm/filemap.c:2041

This patch should fix it.  It's not just removing the warning; this
warning duplicates the warning a few lines down (after taking the
lock).  It's not safe to make this assertion without holding the page
lock as the page can move between the page cache and the swap cache.

#syz test

diff --git a/mm/filemap.c b/mm/filemap.c
index d1458ecf2f51..34de0b14aaa9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2038,7 +2038,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))
