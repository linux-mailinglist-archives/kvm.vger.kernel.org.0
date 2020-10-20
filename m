Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFE29359D
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 09:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404926AbgJTHRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 03:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404918AbgJTHRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 03:17:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF25EC061755;
        Tue, 20 Oct 2020 00:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KH+Wc+ZSZBRXANth+UedKqqJT2BNiT7bzC2sGu6QJ4k=; b=SuptBZhIOFnIn4Qgl/o3eWLNPl
        DZG970jCNvRXV8TYuPW8QiHdgmt3jNZcAUc+7rsy1pvdug//5g9pI5tTyeeah9R2qo1Vl9qc0YG1L
        UC1rEUx1A5mbJG4VUmwOd4NGhXJVaCzp8aXCmGtDMP7/G8/FEvlPTac2gfU94hYEpclltA+k8Byf7
        GDs1h7tbastBWW+DH78OcJG9nE62DHy5m3Tt0/b0nSr0NOFKcJJN9rWgvuJ3cdcSn51xQJgw9dzIW
        q3AcAXwQFkZ83Wtg9g3HZ2ApNhoccKFA/ffNSNGFcsmNaASxCq8HNLh5EyK7ri9ZI5xm0q0Abdl2j
        yjgcZm0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUltF-0002gW-QN; Tue, 20 Oct 2020 07:17:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3DF74304D2B;
        Tue, 20 Oct 2020 09:17:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2BDFD2038FA06; Tue, 20 Oct 2020 09:17:01 +0200 (CEST)
Date:   Tue, 20 Oct 2020 09:17:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 11/16] KVM: Protected memory extension
Message-ID: <20201020071701.GV2611@hirez.programming.kicks-ass.net>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-12-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020061859.18385-12-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:18:54AM +0300, Kirill A. Shutemov wrote:
> +int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma, *prev;
> +	int ret;
> +
> +	if (mmap_write_lock_killable(mm))
> +		return -EINTR;
> +
> +	ret = -ENOMEM;
> +	vma = find_vma(current->mm, start);
> +	if (!vma)
> +		goto out;
> +
> +	ret = -EINVAL;
> +	if (vma->vm_start > start)
> +		goto out;
> +
> +	if (start > vma->vm_start)
> +		prev = vma;
> +	else
> +		prev = vma->vm_prev;
> +
> +	ret = 0;
> +	while (true) {
> +		unsigned long newflags, tmp;
> +
> +		tmp = vma->vm_end;
> +		if (tmp > end)
> +			tmp = end;
> +
> +		newflags = vma->vm_flags;
> +		if (protect)
> +			newflags |= VM_KVM_PROTECTED;
> +		else
> +			newflags &= ~VM_KVM_PROTECTED;
> +
> +		/* The VMA has been handled as part of other memslot */
> +		if (newflags == vma->vm_flags)
> +			goto next;
> +
> +		ret = mprotect_fixup(vma, &prev, start, tmp, newflags);
> +		if (ret)
> +			goto out;
> +
> +next:
> +		start = tmp;
> +		if (start < prev->vm_end)
> +			start = prev->vm_end;
> +
> +		if (start >= end)
> +			goto out;
> +
> +		vma = prev->vm_next;
> +		if (!vma || vma->vm_start != start) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +	}
> +out:
> +	mmap_write_unlock(mm);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__kvm_protect_memory);

Since migration will be disabled after this; should the above not (at
the very least) force compaction before proceeding to lock the pages in?
