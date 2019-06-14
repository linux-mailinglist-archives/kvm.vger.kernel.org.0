Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0145C0E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 14:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfFNMEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 08:04:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbfFNMEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 08:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=alVHZlU/yeIna7DaDwxabV9QPdfrwUg7lNOiHL0K7hc=; b=jQiHhG3v7EnRCAKQJ2BUOiOxw
        BldbzF3Z7igBVgDE13rSdJP5Xm+EPAMWgYZ7B948eJIxJR26at4A0gEjvCsyqG4jhIoSTRQTHy66F
        q1Lp5wYqW5JnFDHmW9wfQvUH2yXpgHlV+3pK6H5xe+rfQxW6fSzVKBMZLKc2ykaJlJ5m30So5TAVR
        s78XezV2gDn8USUKISzydWIp5yu23olD9M4tPQF/yw8sqkbQFdQ1mcpjttqeXZMNdqQDDP0SMA6ko
        ZLAb6gdVgKb/pkijrewfJeEBT6079GT5Q4uuE2BiL2XhqJMetnqruL8j2dVPJTtj2Pm4gScClcHcm
        iDydIt+cQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkwT-0006qX-QL; Fri, 14 Jun 2019 12:04:25 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4BD1920A29B58; Fri, 14 Jun 2019 14:04:24 +0200 (CEST)
Date:   Fri, 14 Jun 2019 14:04:24 +0200
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
Subject: Re: [PATCH, RFC 51/62] iommu/vt-d: Support MKTME in DMA remapping
Message-ID: <20190614120424.GJ3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-52-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-52-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:11PM +0300, Kirill A. Shutemov wrote:
> @@ -603,7 +605,12 @@ static inline void dma_clear_pte(struct dma_pte *pte)
>  static inline u64 dma_pte_addr(struct dma_pte *pte)
>  {
>  #ifdef CONFIG_64BIT
> -	return pte->val & VTD_PAGE_MASK;

I don't know this code, but going by the below cmpxchg64, this wants to
be READ_ONCE().

> +	u64 addr = pte->val;
> +	addr &= VTD_PAGE_MASK;
> +#ifdef CONFIG_X86_INTEL_MKTME
> +	addr &= ~mktme_keyid_mask;
> +#endif
> +	return addr;
>  #else
>  	/* Must have a full atomic 64-bit read */
>  	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
> -- 
> 2.20.1
> 
