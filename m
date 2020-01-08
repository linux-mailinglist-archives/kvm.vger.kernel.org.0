Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B626134921
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgAHRUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:20:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728234AbgAHRUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 12:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578504017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Haib25FzW/d5cNo326IMvfMzkBnJAFdXTg38osZZ9z4=;
        b=PFyV3NaCRLrMzKK1QvB24ZSYDlK998ilh+K5QgD9K2p6BlOy+MAeuUH9wYkW7t0sQPNvmi
        JVtMwGZdb8YxLe+Zt/KNHcroxo/4U5pENM5FkeU3ZxV4VYaUf4CIjRkGCSxe05Jox1Tylg
        QYkuGIKY8ukV1yLbo6yXHO28C/VbPTc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-0bnYCv7yPhKeQU2sogfcRQ-1; Wed, 08 Jan 2020 12:20:14 -0500
X-MC-Unique: 0bnYCv7yPhKeQU2sogfcRQ-1
Received: by mail-qk1-f197.google.com with SMTP id 194so2346093qkh.18
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:20:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Haib25FzW/d5cNo326IMvfMzkBnJAFdXTg38osZZ9z4=;
        b=XVmS0aHmZHAPSXz1mbZ+4UQz4hIMwAnfgrHvIT8/Q6KSEFpV3KieRuM5xVoQIZkv8V
         qDMNM2MaXx8E75IZBCKhkuG/Vo738CPIwRR58OPsoKYmO0ogbCUUN8qAqsV0Ueoo7hcD
         ud9rW7nkN93u0HPsFsKbmVciHfUngMg9GzJ9b9DPF5YeMkoVIFCxwop+p4k2UZf0KDO/
         FrieXq8XU3ZKauD/mpeHtvrC0ykEIJVo9ve4cT4eucqVZnw2Yed5oiRLKteWnpuO/QNv
         72MR9xbefdy3DtKAnpklgIDzej2oPatJFGEXTh+XRZtAW9im71u4VAWf+MkdD4AKCyWm
         z94w==
X-Gm-Message-State: APjAAAUewXaXihxNIjZuDoUwp6I/PKru5aTcTD2yiH+XAlPR0dZCsQLN
        ZphvL3ofwwIHEiG8n+MDckQPSMNx0DeD4s/L0XYJGQzeAvOVRW5Bl+wZ2JX/dpWjWVlUuctgOTQ
        5Dj7VPClZw/vZ
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4610238qtp.350.1578504013992;
        Wed, 08 Jan 2020 09:20:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqx4HEQn28Jhy0IHzYEPaUM/06VEe3ETQAmn5BjZY/AF0r0Y9E6aOJomV65HT59SyU+zOwe5vw==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4610215qtp.350.1578504013667;
        Wed, 08 Jan 2020 09:20:13 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b24sm1845763qtp.82.2020.01.08.09.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 09:20:12 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:20:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 16/28] kvm: mmu: Add direct MMU page fault handler
Message-ID: <20200108172011.GB7096@xz-x1>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-17-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-17-bgardon@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:12PM -0700, Ben Gardon wrote:

[...]

> +static int handle_direct_page_fault(struct kvm_vcpu *vcpu,
> +		unsigned long mmu_seq, int write, int map_writable, int level,
> +		gpa_t gpa, gfn_t gfn, kvm_pfn_t pfn, bool prefault)
> +{
> +	struct direct_walk_iterator iter;
> +	struct kvm_mmu_memory_cache *pf_pt_cache = &vcpu->arch.mmu_page_cache;
> +	u64 *child_pt;
> +	u64 new_pte;
> +	int ret = RET_PF_RETRY;
> +
> +	direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
> +			kvm_arch_vcpu_memslots_id(vcpu), gpa >> PAGE_SHIFT,
> +			(gpa >> PAGE_SHIFT) + 1, MMU_READ_LOCK);
> +	while (direct_walk_iterator_next_pte(&iter)) {
> +		if (iter.level == level) {
> +			ret = direct_page_fault_handle_target_level(vcpu,
> +					write, map_writable, &iter, pfn,
> +					prefault);
> +
> +			break;
> +		} else if (!is_present_direct_pte(iter.old_pte) ||
> +			   is_large_pte(iter.old_pte)) {
> +			/*
> +			 * The leaf PTE for this fault must be mapped at a
> +			 * lower level, so a non-leaf PTE must be inserted into
> +			 * the paging structure. If the assignment below
> +			 * succeeds, it will add the non-leaf PTE and a new
> +			 * page of page table memory. Then the iterator can
> +			 * traverse into that new page. If the atomic compare/
> +			 * exchange fails, the iterator will repeat the current
> +			 * PTE, so the only thing this function must do
> +			 * differently is return the page table memory to the
> +			 * vCPU's fault cache.
> +			 */
> +			child_pt = mmu_memory_cache_alloc(pf_pt_cache);
> +			new_pte = generate_nonleaf_pte(child_pt, false);
> +
> +			if (!direct_walk_iterator_set_pte(&iter, new_pte))
> +				mmu_memory_cache_return(pf_pt_cache, child_pt);
> +		}
> +	}

I have a question on how this will guarantee safe concurrency...

As you mentioned previously somewhere, the design somehow mimics how
the core mm works with process page tables, and IIUC here the rwlock
works really like the mmap_sem that we have for the process mm.  So
with the series now we can have multiple page fault happening with
read lock held of the mmu_lock to reach here.

Then I'm imagining a case where both vcpu threads faulted on the same
address range while when they wanted to do different things, like: (1)
vcpu1 thread wanted to map this as a 2M huge page, while (2) vcpu2
thread wanted to map this as a 4K page.  Then is it possible that
vcpu2 is faster so it firstly setup the pmd as a page table page (via
direct_walk_iterator_set_pte above), then vcpu1 quickly overwrite it
as a huge page (via direct_page_fault_handle_target_level, level=2),
then I feel like the previous page table page that setup by vcpu2 can
be lost unnoticed.

I think general process page table does not have this issue is because
it has per pmd lock so anyone who changes the pmd or beneath it will
need to take that.  However here we don't have it, instead we only
depend on the atomic ops, which seems to be not enough for this?

Thanks,

> +	direct_walk_iterator_end_traversal(&iter);
> +
> +	/* If emulating, flush this vcpu's TLB. */
> +	if (ret == RET_PF_EMULATE)
> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +
> +	return ret;
> +}

-- 
Peter Xu

