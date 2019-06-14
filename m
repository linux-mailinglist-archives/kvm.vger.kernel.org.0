Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD30F45B28
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfFNLKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:10:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37582 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfFNLKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k3YqewRln6/e39DRE9WtzDLs69QdBQzUJmMwD/K+784=; b=JeHvFDZ1XZKf46UtJbklNv329
        zxPeWCBBT5gHiRXg0qHfYMSShJ50q81UGDkAeJE9FcWdO/SCjEYz3JU8UXpLuU6uc6PFP2XpRNvK+
        nNlwp9bUo/kdsuC6AFfbgd7HXZDFHpn1xHrafeJJR6SixQoH6Nv/Wtx4oVvAw3fTufghLgtkrBv9j
        an8WKxT5Gswm8hfhSGYfbnRS0eDamGKTp/8YlAej/fobLDGjuVhLGjjzF9kfoI0Mgn60AM8/k+9Lk
        sCp4omDUt0XNmJ7wkPr4sjPSGb6D1rRg8Rh2ep/EJpIlClSa65BB1JGUsIn20Gch0banuMTPifR/I
        sDKPR1LCQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbk62-00073a-5e; Fri, 14 Jun 2019 11:10:14 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E916520A28B1F; Fri, 14 Jun 2019 13:10:12 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:10:12 +0200
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
Subject: Re: [PATCH, RFC 19/62] x86/mm: Handle encrypted memory in
 page_to_virt() and __pa()
Message-ID: <20190614111012.GZ3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-20-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-20-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:39PM +0300, Kirill A. Shutemov wrote:
> Per-KeyID direct mappings require changes into how we find the right
> virtual address for a page and virt-to-phys address translations.
> 
> page_to_virt() definition overwrites default macros provided by
> <linux/mm.h>.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/page.h    | 3 +++
>  arch/x86/include/asm/page_64.h | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 39af59487d5f..aff30554f38e 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -72,6 +72,9 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>  extern bool __virt_addr_valid(unsigned long kaddr);
>  #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
>  
> +#define page_to_virt(x) \
> +	(__va(PFN_PHYS(page_to_pfn(x))) + page_keyid(x) * direct_mapping_size)
> +
>  #endif	/* __ASSEMBLY__ */

So this is the bit that makes patch 13 make sense. It would've been nice
to have that called out in the Changelog or something.
