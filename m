Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FFE293C49
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 14:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406765AbgJTMzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 08:55:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:61136 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406738AbgJTMzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 08:55:11 -0400
IronPort-SDR: w+m/A2IeWqp688OOwvjSQlOtEB7rj1cLQ5ibziZfDWkRZjQo4RMyjriw24GJXVANHAiRuOqsJK
 eL2kKpwFk+bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="163710334"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="163710334"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 05:55:10 -0700
IronPort-SDR: +Rp7LwkLyTNLzcyhE2PJNGsy/abJyagxG3IK4vs2o5FUnk/MOk9aslHpAM01l3mg4LXtKhsFZU
 oWAEHocBHarQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="301719903"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 20 Oct 2020 05:55:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id B87B6377; Tue, 20 Oct 2020 15:55:04 +0300 (EEST)
Date:   Tue, 20 Oct 2020 15:55:04 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 11/16] KVM: Protected memory extension
Message-ID: <20201020125504.xadmnhpf3pu4uva7@black.fi.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-12-kirill.shutemov@linux.intel.com>
 <20201020071701.GV2611@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020071701.GV2611@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:17:01AM +0200, Peter Zijlstra wrote:
> On Tue, Oct 20, 2020 at 09:18:54AM +0300, Kirill A. Shutemov wrote:
> > +int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma, *prev;
> > +	int ret;
> > +
> > +	if (mmap_write_lock_killable(mm))
> > +		return -EINTR;
> > +
> > +	ret = -ENOMEM;
> > +	vma = find_vma(current->mm, start);
> > +	if (!vma)
> > +		goto out;
> > +
> > +	ret = -EINVAL;
> > +	if (vma->vm_start > start)
> > +		goto out;
> > +
> > +	if (start > vma->vm_start)
> > +		prev = vma;
> > +	else
> > +		prev = vma->vm_prev;
> > +
> > +	ret = 0;
> > +	while (true) {
> > +		unsigned long newflags, tmp;
> > +
> > +		tmp = vma->vm_end;
> > +		if (tmp > end)
> > +			tmp = end;
> > +
> > +		newflags = vma->vm_flags;
> > +		if (protect)
> > +			newflags |= VM_KVM_PROTECTED;
> > +		else
> > +			newflags &= ~VM_KVM_PROTECTED;
> > +
> > +		/* The VMA has been handled as part of other memslot */
> > +		if (newflags == vma->vm_flags)
> > +			goto next;
> > +
> > +		ret = mprotect_fixup(vma, &prev, start, tmp, newflags);
> > +		if (ret)
> > +			goto out;
> > +
> > +next:
> > +		start = tmp;
> > +		if (start < prev->vm_end)
> > +			start = prev->vm_end;
> > +
> > +		if (start >= end)
> > +			goto out;
> > +
> > +		vma = prev->vm_next;
> > +		if (!vma || vma->vm_start != start) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> > +	}
> > +out:
> > +	mmap_write_unlock(mm);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(__kvm_protect_memory);
> 
> Since migration will be disabled after this; should the above not (at
> the very least) force compaction before proceeding to lock the pages in?

Migration has to be implemented instead, before we hit upstream.

BTW, VMs with direct device assignment pins all guest memory today. So
it's not something new in the virtualization world.

-- 
 Kirill A. Shutemov
