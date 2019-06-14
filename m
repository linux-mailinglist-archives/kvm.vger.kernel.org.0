Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C123445860
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFNJPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 05:15:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52570 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFNJPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bjuICrJxhqbVE3btlCQ3iZkvBOpZmXqWH1hsHhR0vEs=; b=plUvNd2hsauOJNdMcJW7PtfGU
        ToeAUBkrbzKvJm2BUG/yf8dWjbaAvX7Q4lidDs0ithX9OI2WVuXyjfjTLnReR0Y0BKcgCuAYiXgBC
        OYMfDsUCaba/eGhvG5pmOg+CVacs6ilSRsk2Vm9Q+cjRnTCoZahKJFZHX8emllCfCdfoOQyfYYpgd
        8P3NvVIEryL7h01oXhpMERwBy1+5j/J65bjKgYr8HqalG4n/8K5kG47A0w9CyIaEfbCm+XdyPqqR2
        +SODATdKf9VGfFZV7w3Vcr9SwOJUqEoqFkjC3/4Q1Bw12ultXg+EeVpqKI0Vp+ZCPmsLTqaO2Mazw
        5m/hAaOGg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbiIm-0004MH-MW; Fri, 14 Jun 2019 09:15:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0E80820245BD7; Fri, 14 Jun 2019 11:15:14 +0200 (CEST)
Date:   Fri, 14 Jun 2019 11:15:14 +0200
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
Subject: Re: [PATCH, RFC 09/62] x86/mm: Preserve KeyID on pte_modify() and
 pgprot_modify()
Message-ID: <20190614091513.GW3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-10-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-10-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:29PM +0300, Kirill A. Shutemov wrote:
> + * Cast PAGE_MASK to a signed type so that it is sign-extended if
> + * virtual addresses are 32-bits but physical addresses are larger
> + * (ie, 32-bit PAE).

On 32bit, 'long' is still 32bit, did you want to cast to 'long long'
instead? Ideally we'd use pteval_t here, but I see that is unsigned.

>   */
> -#define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
> +#define PTE_PFN_MASK_MAX \
> +	(((signed long)PAGE_MASK) & ((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
> +#define _PAGE_CHG_MASK	(PTE_PFN_MASK_MAX | _PAGE_PCD | _PAGE_PWT |		\
>  			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |	\
>  			 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP)
>  #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
