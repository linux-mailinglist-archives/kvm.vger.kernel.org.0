Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45731E1B13
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgEZGPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgEZGPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:15:10 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486852087D;
        Tue, 26 May 2020 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473709;
        bh=Ur2xk8PlFAdp1SqkrrLV/Z2pOfVx2LArPwI0PTzFmSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x53IR6Jdx8v+FrtVJ0pEbhAPnAPzTg32Pwto6iDx+Ywedcvs89VietzhFi20djMuN
         ej5tZ8gwm15PMi3B93btNoJ557MZ0g0SkVLmdgW4rddWFSquUFwjDQixRHA4VIeQJm
         UePksupJX9ie1uyLj4nEt1GIV8f1CBnRdXwGjwUw=
Date:   Tue, 26 May 2020 09:14:59 +0300
From:   Mike Rapoport <rppt@kernel.org>
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
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20200526061459.GC13247@kernel.org>
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
> New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> protection feature is enabled.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/kvm_host.h |  4 +++
>  virt/kvm/kvm_main.c      | 78 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 72 insertions(+), 10 deletions(-)
> 
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

Maybe always use copy_{from,to}_guest() and move the 'if (protected)'
there?
If kvm is added to memory slot, it cab be the passed to copy_{to,from}_guest.

>  	if (r)
>  		return -EFAULT;
>  	return 0;
> @@ -2268,7 +2311,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>  
> @@ -2277,7 +2321,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     vcpu->kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>  

-- 
Sincerely yours,
Mike.
