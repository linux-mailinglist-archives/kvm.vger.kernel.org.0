Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F51E81BB
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgE2PYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2PYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:24:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072CC03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 08:24:14 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n15so1520672pfd.0
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 08:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3qfv4Y4PkjJEv7bG2fRuJoW0d/ix4Crcs/JJo3CxTpE=;
        b=cxxJkSGUH/75rwZte/yl5nsogU3Io2X7B5Ceghm+YvVBTEthbLL/BTrq7PzpquaxPc
         QAkpHnqU7YpJytQmKVELXJTs8FlRwqkNz8NUDqNhO9mJOgLXMt+jSFjRyNnDnutPAHmc
         /mrmK3l+gFurvxd2kQOtCCz7slTaPyaMpYTfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3qfv4Y4PkjJEv7bG2fRuJoW0d/ix4Crcs/JJo3CxTpE=;
        b=YZBaEBrdCoWzaAI+rBvgjZpXhtF5kJDtE8L2rr3TCu2HBhEoJcd/Q5LdeLTYQMejm7
         FqLJyu13UGfEg9bJODmZnadsA7e5a/uNlLUCLkQnN/tlptsALfKYJCauJVptwU3BQ3rF
         Az6e6zeT3qMO5KDXjLHOR//QAnwmTrLFIcWTybbvLNzqaPUwM16irGbN9vzPs70PPagi
         yUgU7dUm1MLBK0fZYjRBEQUEwIV9cNLFclgCIRx/2APCyd2JEnD+JWm1lS/RkQRs5u4Y
         ammS/wb0NQkJPrVIN/MCvHQWXA/EJz5mjNgJeggRSIlhIw9O9jZndpqDlfWBWuRrDK7J
         PWdg==
X-Gm-Message-State: AOAM531ykurUe+fFnZyg8cIBXdE19MxXuXkBVGG4vx4id5YSuEXc978Y
        U87nGmBgva9jgeePrm5madBAhQ==
X-Google-Smtp-Source: ABdhPJw9Vm+OKtbf8TSG39uU5ZeGM2/j91AXK4EGxqkr5hCiiGU7wluib2DWEf6SIxfxmAf0np70PQ==
X-Received: by 2002:a62:4dc3:: with SMTP id a186mr8879636pfb.269.1590765854190;
        Fri, 29 May 2020 08:24:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 192sm7177979pfz.198.2020.05.29.08.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:24:13 -0700 (PDT)
Date:   Fri, 29 May 2020 08:24:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <202005290815.9ABDE475@keescook>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 03:52:04PM +0300, Kirill A. Shutemov wrote:
> +int copy_from_guest(void *data, unsigned long hva, int len)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> +		if (npages != 1)
> +			return -EFAULT;
> +		memcpy(data, page_address(page) + offset, seg);
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +int copy_to_guest(unsigned long hva, const void *data, int len)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
> +		if (npages != 1)
> +			return -EFAULT;
> +		memcpy(page_address(page) + offset, data, seg);
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;
> +	}
> +	return 0;
> +}
> +
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +				 void *data, int offset, int len,
> +				 bool protected)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2257,7 +2297,10 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> +	if (protected)
> +		r = copy_from_guest(data, addr + offset, len);
> +	else
> +		r = __copy_from_user(data, (void __user *)addr + offset, len);
>  	if (r)
>  		return -EFAULT;
>  	return 0;

This ends up removing KASAN and object size tests. Compare to:

__copy_from_user(void *to, const void __user *from, unsigned long n)
{
        might_fault();
        kasan_check_write(to, n);
        check_object_size(to, n, false);
        return raw_copy_from_user(to, from, n);
}

Those will need to get added back. :)

Additionally, I see that copy_from_guest() neither clears the
destination memory on a short read, nor does KVM actually handle the
short read case correctly now. See the notes in uaccess.h:

 * NOTE: only copy_from_user() zero-pads the destination in case of short copy.
 * Neither __copy_from_user() nor __copy_from_user_inatomic() zero anything
 * at all; their callers absolutely must check the return value.

It's not clear to me how the destination buffers get reused, but the has
the potential to leak kernel memory contents. This needs separate
fixing, I think.

-Kees

-- 
Kees Cook
