Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2ED45BE2
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfFNLyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:54:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfFNLyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V9MxUDuNmfO4r0z06SPalcFOxnjAwgY7mVSx/TAv4CA=; b=M7O9zXWbjnUSmnDAOEmTK7Md1
        Z232umC/Ih4w0N8OJkMIQxcnrGvrzB8H/aYEJh2NILrV6grz+ZS4iMVMPIljrdAZzeSQl32EoqVmc
        j9dPtuTqOLDXMls53IKjGHjUpO6mg61K24O95pcgqQDd1mWbASyhdbtqNRtmFf4tWCGOhyPlyJCiY
        ZDgjGaiymge3jtRgtsGSf4cgMUsVeTBqlSeI08iRRUyXxzHYKrr1kkOTU+kESF5T+cSeUNPSLeSBF
        cFezL2X72sFAc99UeeE4ZVIdO12z7QcyfpUqx61BiAewhS9S5JkG8drNIEvQRD6wZWwOGyebGriLr
        T3LxQ3aCw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkmn-0002Jj-Qb; Fri, 14 Jun 2019 11:54:25 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4E56A20A26CE7; Fri, 14 Jun 2019 13:54:24 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:54:24 +0200
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
Subject: Re: [PATCH, RFC 46/62] x86/mm: Keep reference counts on encrypted
 VMAs for MKTME
Message-ID: <20190614115424.GG3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-47-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-47-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:06PM +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The MKTME (Multi-Key Total Memory Encryption) Key Service needs
> a reference count on encrypted VMAs. This reference count is used
> to determine when a hardware encryption KeyID is no longer in use
> and can be freed and reassigned to another Userspace Key.
> 
> The MKTME Key service does the percpu_ref_init and _kill, so
> these gets/puts on encrypted VMA's can be considered the
> intermediaries in the lifetime of the key.
> 
> Increment/decrement the reference count during encrypt_mprotect()
> system call for initial or updated encryption on a VMA.
> 
> Piggy back on the vm_area_dup/free() helpers. If the VMAs being
> duplicated, or freed are encrypted, adjust the reference count.

That all talks about VMAs, but...

> @@ -102,6 +115,22 @@ void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
>  
>  		page++;
>  	}
> +
> +	/*
> +	 * Make sure the KeyID cannot be freed until the last page that
> +	 * uses the KeyID is gone.
> +	 *
> +	 * This is required because the page may live longer than VMA it
> +	 * is mapped into (i.e. in get_user_pages() case) and having
> +	 * refcounting per-VMA is not enough.
> +	 *
> +	 * Taking a reference per-4K helps in case if the page will be
> +	 * split after the allocation. free_encrypted_page() will balance
> +	 * out the refcount even if the page was split and freed as bunch
> +	 * of 4K pages.
> +	 */
> +
> +	percpu_ref_get_many(&encrypt_count[keyid], 1 << order);
>  }
>  
>  /*
> @@ -110,7 +139,9 @@ void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
>   */
>  void free_encrypted_page(struct page *page, int order)
>  {
> -	int i;
> +	int i, keyid;
> +
> +	keyid = page_keyid(page);
>  
>  	/*
>  	 * The hardware/CPU does not enforce coherency between mappings
> @@ -125,6 +156,8 @@ void free_encrypted_page(struct page *page, int order)
>  		lookup_page_ext(page)->keyid = 0;
>  		page++;
>  	}
> +
> +	percpu_ref_put_many(&encrypt_count[keyid], 1 << order);
>  }

counts pages, what gives?
