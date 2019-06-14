Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E445BAA
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfFNLrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:47:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37920 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfFNLrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h/RkmMY6lU3xp3EMTfM5htXXlyGM/FqAFdB3EA1Y/ks=; b=Yz3VHco4uNAMcgPZbDG6qh7er
        eyVNjQVW5bYjEJukcYBJwivb4xqu5hgxItRTEdKs4buH3AXHlovCUsFgM4epbNxV0iY5ba0uMHMZ8
        CWCiINOZTNYV1VwpSzAcQDDfhTRSGKCFsJEhqtW97Rtrkv8ZjURnPLimYnmBvbqSPmHCgJ1bTkjjR
        hbIq33RYkrsI5a/5ZgK75sZ9yi5LdcQI1hG6R04omFQLTtocKREkBmYuc2ZRr/ixVqQkcqsXUwbTS
        KI8WzFSOe2tswjzNVG9vd58kOfnWxDuMA8G+6hbedadtDIlIEo/qgiEU3fgjKgKRxFfoCdLXeH/Dj
        LrbNR3Ebg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkg9-0007LF-S6; Fri, 14 Jun 2019 11:47:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9FD0E2013F74A; Fri, 14 Jun 2019 13:47:32 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:47:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
Message-ID: <20190614114732.GE3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:05PM +0300, Kirill A. Shutemov wrote:
> diff --git a/fs/exec.c b/fs/exec.c
> index 2e0033348d8e..695c121b34b3 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -755,8 +755,8 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  	vm_flags |= mm->def_flags;
>  	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
>  
> -	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end,
> -			vm_flags);
> +	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end, vm_flags,
> +			     -1);

You added a nice NO_KEY helper a few patches back, maybe use it?

>  	if (ret)
>  		goto out_unlock;
>  	BUG_ON(prev != vma);
