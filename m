Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2245BC1
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfFNLvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:51:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfFNLvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6uPpBmRMCo+tgIg2r1zxKrPWw32mDCaK9zcJcUBOcWo=; b=jmYBMKhAa1UffRPdkK9RLJLOS
        QdmfuTjDZ8NB4GXF/zHW3rz6cJWu+XpCEA1hAu19diiDUBsEXDoK+kKbI8a9yiKOyZQ3CF3PInIUQ
        bKOZuduix2OL2GFE+f3y35ts/hSbBLpgUqg8O3tCDH3RTiaBrjM4qXKlUTnCQJVFClCitsescAugU
        AbgEZ8MbL93i/TM4f15wK06QGyzT+L4W7JN9QCBJV7RMSy3QGXdpqnFVW5nBAktHuID4zk4rprhMt
        eEEuT0d5NdtDREXGLMrP4AslnTeHOVmVmg5XQAU13Avb22U+SuiQ3YAgNOOKPZXwGMgaFoYBwddgg
        aXV0xJdHA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkk6-0001vf-Lz; Fri, 14 Jun 2019 11:51:38 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2E5292013F74A; Fri, 14 Jun 2019 13:51:37 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:51:37 +0200
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
Message-ID: <20190614115137.GF3436@hirez.programming.kicks-ass.net>
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

> @@ -347,7 +348,8 @@ static int prot_none_walk(struct vm_area_struct *vma, unsigned long start,
>  
>  int
>  mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
> -	unsigned long start, unsigned long end, unsigned long newflags)
> +	       unsigned long start, unsigned long end, unsigned long newflags,
> +	       int newkeyid)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long oldflags = vma->vm_flags;
> @@ -357,7 +359,14 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	int error;
>  	int dirty_accountable = 0;
>  
> -	if (newflags == oldflags) {
> +	/*
> +	 * Flags match and Keyids match or we have NO_KEY.
> +	 * This _fixup is usually called from do_mprotect_ext() except
> +	 * for one special case: caller fs/exec.c/setup_arg_pages()
> +	 * In that case, newkeyid is passed as -1 (NO_KEY).
> +	 */
> +	if (newflags == oldflags &&
> +	    (newkeyid == vma_keyid(vma) || newkeyid == NO_KEY)) {
>  		*pprev = vma;
>  		return 0;
>  	}
> @@ -423,6 +432,8 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	}
>  
>  success:
> +	if (newkeyid != NO_KEY)
> +		mprotect_set_encrypt(vma, newkeyid, start, end);
>  	/*
>  	 * vm_flags and vm_page_prot are protected by the mmap_sem
>  	 * held in write mode.
> @@ -454,10 +465,15 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  }
>  
>  /*
> - * When pkey==NO_KEY we get legacy mprotect behavior here.
> + * do_mprotect_ext() supports the legacy mprotect behavior plus extensions
> + * for Protection Keys and Memory Encryption Keys. These extensions are
> + * mutually exclusive and the behavior is:
> + *	(pkey==NO_KEY && keyid==NO_KEY) ==> legacy mprotect
> + *	(pkey is valid)  ==> legacy mprotect plus Protection Key extensions
> + *	(keyid is valid) ==> legacy mprotect plus Encryption Key extensions
>   */
>  static int do_mprotect_ext(unsigned long start, size_t len,
> -		unsigned long prot, int pkey)
> +			   unsigned long prot, int pkey, int keyid)
>  {
>  	unsigned long nstart, end, tmp, reqprot;
>  	struct vm_area_struct *vma, *prev;
> @@ -555,7 +571,8 @@ static int do_mprotect_ext(unsigned long start, size_t len,
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> -		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> +		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags,
> +				       keyid);
>  		if (error)
>  			goto out;
>  		nstart = tmp;

I've missed the part where pkey && keyid results in a WARN or error or
whatever.

