Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88B81D48A0
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgEOIg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 04:36:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49134 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726730AbgEOIgZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 04:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589531784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rnCzWC+hepdVJSXgaCkvxN/iLlC4gaqxnaWCmO0365Y=;
        b=ewvuW+p5/0H3LvYLVeKhoLQrY/oTtqexLMSHCkAeKLYCKQesltMyW0l/cha7mzzbNkQ2yM
        MkY4g8s/Ul+5tUV4m5hHd0zC0pDZuKwORziYUTIFLOnW3/mDd41JSmr4Qm8xi+3/Uf4tc2
        Cp5SF/PXCVWIhSuDxZgLmC0u49eg1ec=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-gpeydxCsNDyHYmb7zbBEIQ-1; Fri, 15 May 2020 04:36:23 -0400
X-MC-Unique: gpeydxCsNDyHYmb7zbBEIQ-1
Received: by mail-wr1-f71.google.com with SMTP id z16so810609wrq.21
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 01:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rnCzWC+hepdVJSXgaCkvxN/iLlC4gaqxnaWCmO0365Y=;
        b=mLSZpi2VjPjf1Es506DeR21BdLz2diZXHmmM1t4a2LS3+hvn16hB2HKrSBsicqTq6B
         STt6zAcbeipoG4/jxEXDmnB1d/jqsrtgDhe2NQ3WkbhrDlNyI3rKNZNsLCeilxT7I1sp
         r5gYV/mhp2CHRHixFw8qKME1rvpjAz2u+3b1L1ulT5D46Wdj8oojBjSAjihr7/VZI2g3
         p9VjoaezODaSMTiKwY7lbn92i+ovqt6V1t6PNlOzos+u19tK+vGzMTWaXnUbywCJqeSx
         PphtoKMps40jCfTIdhFsvsR4025C+aZFEGvlmybKY6VGyjdZ1gb7uUIWJd8a08T1F0Th
         ICAw==
X-Gm-Message-State: AOAM532wQ7OUXJpS4tVF3jlY94RjXGcbJDsGuxaUzij3z0opI8B3PzBe
        nJRvwf2T+3+B+pQCe/yeXRWkwxnU8Q+T48oE3i9WJuYMrWfTE8lfDnDAnqw+xn6fAKzcAgEvM58
        pKsgbQ9O4pRC+
X-Received: by 2002:adf:94c2:: with SMTP id 60mr2956823wrr.366.1589531781835;
        Fri, 15 May 2020 01:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwliq3q2MSh4hgu9dzVJHOMoWpDZHdQyryAZ8K6gfNKKYlAhOV2RGpxC9VHi80inuvkjj1wgA==
X-Received: by 2002:adf:94c2:: with SMTP id 60mr2956801wrr.366.1589531781585;
        Fri, 15 May 2020 01:36:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b145sm2650206wme.41.2020.05.15.01.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 01:36:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 4/5] KVM: x86: aggressively map PTEs in KVM_MEM_ALLONES slots
In-Reply-To: <20200514194624.GB15847@linux.intel.com>
References: <20200514180540.52407-1-vkuznets@redhat.com> <20200514180540.52407-5-vkuznets@redhat.com> <20200514194624.GB15847@linux.intel.com>
Date:   Fri, 15 May 2020 10:36:19 +0200
Message-ID: <87ftc1wq64.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, May 14, 2020 at 08:05:39PM +0200, Vitaly Kuznetsov wrote:
>> All PTEs in KVM_MEM_ALLONES slots point to the same read-only page
>> in KVM so instead of mapping each page upon first access we can map
>> everything aggressively.
>> 
>> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c         | 20 ++++++++++++++++++--
>>  arch/x86/kvm/mmu/paging_tmpl.h | 23 +++++++++++++++++++++--
>>  2 files changed, 39 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 3db499df2dfc..e92ca9ed3ff5 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4154,8 +4154,24 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>>  		goto out_unlock;
>>  	if (make_mmu_pages_available(vcpu) < 0)
>>  		goto out_unlock;
>> -	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
>> -			 prefault, is_tdp && lpage_disallowed);
>> +
>> +	if (likely(!(slot->flags & KVM_MEM_ALLONES) || write)) {
>
> The 'write' check is wrong.  More specifically, patch 2/5 is missing code
> to add KVM_MEM_ALLONES to memslot_is_readonly().  If we end up going with
> an actual kvm_allones_pg backing, writes to an ALLONES memslots should be
> handled same as writes to RO memslots; MMIO occurs but no MMIO spte is
> created.
>

Missed that, thanks!

>> +		r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
>> +				 prefault, is_tdp && lpage_disallowed);
>> +	} else {
>> +		/*
>> +		 * KVM_MEM_ALLONES are 4k only slots fully mapped to the same
>> +		 * readonly 'allones' page, map all PTEs aggressively here.
>> +		 */
>> +		for (gfn = slot->base_gfn; gfn < slot->base_gfn + slot->npages;
>> +		     gfn++) {
>> +			r = __direct_map(vcpu, gfn << PAGE_SHIFT, write,
>> +					 map_writable, max_level, pfn, prefault,
>> +					 is_tdp && lpage_disallowed);
>
> IMO this is a waste of memory and TLB entries.  Why not treat the access as
> the MMIO it is and emulate the access with a 0xff return value?  I think
> it'd be a simple change to have __kvm_read_guest_page() stuff 0xff, i.e. a
> kvm_allones_pg wouldn't be needed.  I would even vote to never create an
> MMIO SPTE.  The guest has bigger issues if reading from a PCI hole is
> performance sensitive.

You're trying to defeat the sole purpose of the feature :-) I also saw
the option you suggest but Michael convinced me we should go further.

The idea (besides memory waste) was that the time we spend on PCI scan
during boot is significant. Unfortunatelly, I don't have any numbers but
we can certainly try to get them. With this feature (AFAIU) we're not
aiming at 'classic' long-living VMs but rather at something like Kata
containers/FaaS/... where boot time is crucial.

>
> Regarding memory, looping wantonly on __direct_map() will eventually trigger
> the BUG_ON() in mmu_memory_cache_alloc().  mmu_topup_memory_caches() only
> ensures there are enough objects available to map a single translation, i.e.
> one entry per level, sans the root[*].
>
> [*] The gorilla math in mmu_topup_memory_caches() is horrendously misleading,
>     e.g. the '8' pages is really 2*(ROOT_LEVEL - 1), but the 2x part has been
>     obsolete for the better part of a decade, and the '- 1' wasn't actually
>     originally intended or needed, but is now required because of 5-level
>     paging.  I have the beginning of a series to clean up that mess; it was
>     low on my todo list because I didn't expect anyone to be mucking with
>     related code :-)

I missed that too but oh well, this is famous KVM MMU, I should't feel
that bad about it :-) Thanks for your review!

>
>> +			if (r)
>> +				break;
>> +		}
>> +	}
>

-- 
Vitaly

