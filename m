Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9784594C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfFNJvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 05:51:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNJvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eyC03vikXiwWfawO7Qlmx4pYoHpj/VV0tTc9G1eO/2M=; b=W4N6jtac4NDjjqmz5HnAxAouh
        InHuflpblor7GHBWlLRdnNuT+ez7uTV5koHf3E14IuTEfmEj/L809EEQc/yLOHQhar2VHzWpgkzh3
        Buzls+HHqkjXm+FiA2UAibkmrYNt/auf+rnYm7aG+UhusetsJSmeKWZPpMQsrISdsaQzoYGHdoOpM
        qOjcb8wb2uhGYCWSjf/EFgVFzgUH3MUxM2i/Z9TcGfc/a1WdFwvDL8Ouem6Ou5YMjsU3X2yaVOmOL
        /cSIaAAlXxDZz1t8vlgF14JmpQeGTd/ZoREYDN4MZvmXwoqSU/OoAxEiQdENGWRIwoEawlIZ0ZyLK
        ItPRrqLYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbirt-0000GE-T3; Fri, 14 Jun 2019 09:51:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1254E20A26CE6; Fri, 14 Jun 2019 11:51:32 +0200 (CEST)
Date:   Fri, 14 Jun 2019 11:51:32 +0200
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
Subject: Re: [PATCH, RFC 18/62] x86/mm: Implement syncing per-KeyID direct
 mappings
Message-ID: <20190614095131.GY3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:38PM +0300, Kirill A. Shutemov wrote:
> For MKTME we use per-KeyID direct mappings. This allows kernel to have
> access to encrypted memory.
> 
> sync_direct_mapping() sync per-KeyID direct mappings with a canonical
> one -- KeyID-0.
> 
> The function tracks changes in the canonical mapping:
>  - creating or removing chunks of the translation tree;
>  - changes in mapping flags (i.e. protection bits);
>  - splitting huge page mapping into a page table;
>  - replacing page table with a huge page mapping;
> 
> The function need to be called on every change to the direct mapping:
> hotplug, hotremove, changes in permissions bits, etc.

And yet I don't see anything in pageattr.c.

Also, this seems like an expensive scheme; if you know where the changes
where, a more fine-grained update would be faster.

> The function is nop until MKTME is enabled.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/mktme.h |   6 +
>  arch/x86/mm/init_64.c        |  10 +
>  arch/x86/mm/mktme.c          | 441 +++++++++++++++++++++++++++++++++++
>  3 files changed, 457 insertions(+)


> @@ -1247,6 +1254,7 @@ void mark_rodata_ro(void)
>  	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
>  	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
>  	unsigned long all_end;
> +	int ret;
>  
>  	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
>  	       (end - start) >> 10);
> @@ -1280,6 +1288,8 @@ void mark_rodata_ro(void)
>  	free_kernel_image_pages((void *)text_end, (void *)rodata_start);
>  	free_kernel_image_pages((void *)rodata_end, (void *)_sdata);
>  
> +	ret = sync_direct_mapping();
> +	WARN_ON(ret);
>  	debug_checkwx();
>  }
>  

If you'd done pageattr, the above would not be needed.
