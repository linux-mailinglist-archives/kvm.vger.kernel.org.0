Return-Path: <kvm+bounces-25394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23592964E2F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD269287452
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0001BA87E;
	Thu, 29 Aug 2024 18:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elyTv0ib"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D771B5EA3
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724957372; cv=none; b=nevJ/mOW0PepfNQxvYnXhrA+hYgjpoA6QSr/H8UOUSHlLr/TmFjCkmZkSWa9oXnR1Hts40N1k43yJYzvVxplqBaA3c9hUmXXPvYCD1RhWKt2RaZuxZ74kdrXoUEeeWuuedsXGo6AldGHHi+WGcLIRi7mHESXvG8fjJRe5RHIxE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724957372; c=relaxed/simple;
	bh=wT49Q51icBQNAgHkE8tdnmowefi2sa8snP89t3EIxIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZX42dhMBEPaQJ0R3ChWOgw6/nitEn7BGKzJhKCjrLQpdEoy94ab5TkZGZzyKAZ5qY8aejjb9wFuMh5IhqRYDgHNG3W3dDDAbYo16AsaGRHMRMxlgcFBxirAXzGrB8a3J+PnATb2D4IZ9K9/CtPnklyceRg8LnfG480j0s9/80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elyTv0ib; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724957368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFCmp1yoRO+i1Fo2RkC+TtCKMiDRvz30b3MajzW3nrI=;
	b=elyTv0ibn0UW4h8tlJ5uwGUEp26BFdq+bbhmBPK666MmP+oga9p3fYnMxA/6CVsjCpDo3A
	oGB2BZn7+Ce5O4FivDkO78GTS361S9OlN0ZjJTMGdwVQHfxUmjuSuQ6jwUaWtTY1LurBXw
	z8Sf5buNcj1JbCy4x6f1RAJwzI6lsIc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-8K-7xQIzPq-6MGx7MdXujg-1; Thu, 29 Aug 2024 14:49:27 -0400
X-MC-Unique: 8K-7xQIzPq-6MGx7MdXujg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a6497b1e88so105706485a.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 11:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724957367; x=1725562167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFCmp1yoRO+i1Fo2RkC+TtCKMiDRvz30b3MajzW3nrI=;
        b=aKCmWZopOwjMXkDlJKI3uwC6en0fMEf/JYhB1ZlMgolxf1cg99LONABxA7wDvlwHBE
         T7UJa4flvr5wtUsEZXcd7lbPU65y8W8eZvxLOv3SWWRkkHeCnhuqeY1KvoVCgeykGTGf
         /EQPPtwG3OyD5RVr0NhQASdRwS2j9qdgFlhHCvVq5yxrvDfJu1+ul4ajIgKVyRuX79et
         3Xz07dmB4B2jrBDU9hlwEgvS6EKjGT+VGqymLjUi8697QXWDhe5fuWFy8Oy2kV7QNwEn
         XY+tL5mH/Fir3AQ9UdV0esS07O5ljaThDg6EDPpz+vD9RjRDrExJZB+XTllE7yXOUFP+
         1K8w==
X-Forwarded-Encrypted: i=1; AJvYcCUgQGXj8ss/ek6zplUn8K0+dD7Qy5yFPxM/M/vFmOs6MWGbato7rm/ZnfOJtih4Ibu42UU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdUmPE0ER1285HpdR0jzjGeHv95ENKqLYI0p0d/pkkQOQ5jFEU
	i4qelHVWcqddnV1D4MUs+j1zWaO8ET8rhg9IxsJK7wwWU6yFjmiX2nw2o62r6NHqq35AcMAOj8F
	z7Aq7/dcVYWuAzm7GYIk3OzkNaw9uQ7Nr0LnIl8fGcVrV/SScWQ==
X-Received: by 2002:a05:620a:2698:b0:79f:8f3:6ad4 with SMTP id af79cd13be357-7a804189d7emr400079585a.1.1724957366855;
        Thu, 29 Aug 2024 11:49:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCqY9sQY/plh+UMSdlovT6VfMPD3RnFHECf4IOnU0YGP0F/YZ2eWEcEkgRO7YJ9NGFLEjd+Q==
X-Received: by 2002:a05:620a:2698:b0:79f:8f3:6ad4 with SMTP id af79cd13be357-7a804189d7emr400076685a.1.1724957366521;
        Thu, 29 Aug 2024 11:49:26 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806bfb8a1sm75924485a.5.2024.08.29.11.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 11:49:26 -0700 (PDT)
Date: Thu, 29 Aug 2024 14:49:23 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Message-ID: <ZtDCs3rJz9OXzFkm@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
 <Zs8zBT1aDh1v9Eje@x1n>
 <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com>
 <Zs9-beA-eTuXTfN6@x1n>
 <d25912b5-cda0-4173-befe-8a16209b1c66@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d25912b5-cda0-4173-befe-8a16209b1c66@redhat.com>

On Thu, Aug 29, 2024 at 05:10:15PM +0200, David Hildenbrand wrote:
> > > > 
> > > > If you prefer vm_normal_page_pud() to be defined and check pud_special()
> > > > there, I can do that.  But again, I don't yet see how that can make a
> > > > functional difference considering the so far very limited usage of the
> > > > special bit, and wonder whether we can do that on top when it became
> > > > necessary (and when we start to have functional requirement of such).
> > > 
> > > I hope my explanation why pte_special() even exists and how it is used makes
> > > it clearer.
> > > 
> > > It's not that much code to handle it like pte_special(), really. I don't
> > > expect you to teach GUP-slow about vm_normal_page() etc.
> > 
> > One thing I can do here is I move the pmd_special() check into the existing
> > vm_normal_page_pmd(), then it'll be a fixup on top of this patch:
> > 
> > ===8<===
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 288f81a8698e..42674c0748cb 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -672,11 +672,10 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> >   {
> >   	unsigned long pfn = pmd_pfn(pmd);
> > -	/*
> > -	 * There is no pmd_special() but there may be special pmds, e.g.
> > -	 * in a direct-access (dax) mapping, so let's just replicate the
> > -	 * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
> > -	 */
> > +	/* Currently it's only used for huge pfnmaps */
> > +	if (unlikely(pmd_special(pmd)))
> > +		return NULL;
> 
> 
> Better.
> 
> I'd appreciate a vm_normal_page_pud(), but I guess I have to be the one
> cleaning up the mess after you.

I'll prepare either a fixup patch for above, or repost if there're more
changes.

Again, please leave explicit comment please.

As I mentioned, to me vm_normal_page_pud() currently should only contain
pud_special() check, as most of the things in pmd/pte don't seem to apply.

I don't feel strongly to add that wrapper yet in this case, but if you can
elaborate what you're suggesting otherwise, it may help me to understand
what you're looking for, then I can try to address them.

Or if you prefer some cleanup patch by yourself, please go ahead.

-- 
Peter Xu


