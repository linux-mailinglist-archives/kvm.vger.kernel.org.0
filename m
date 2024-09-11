Return-Path: <kvm+bounces-26538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1784C975592
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B7F28837A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C20919FA86;
	Wed, 11 Sep 2024 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmcuRJcN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FAF1E480
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065304; cv=none; b=U/Lp5UnpvNfh5BRJPzhYDJJ9fd8AePUKv44WEY2WOAkxEdlySdqOxagg7r8RG75O9E3PyfuuDsI1bc0O+QZpz4v7lK7XzyagM4slJ7fxUNvZ3D5tm4sreKqHTZGptHHDH7cP3sr3XbZKGE6L+dnPJ3mpwv6gkArL0znGDNDoB+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065304; c=relaxed/simple;
	bh=v9fVORhT6WEBOV50bgrsA/Vtx4HPmTUbPL0CYJSZVgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBvMalp1NDAP13sw/AJQ1kShcL9+3AGhSkOlkTHg1LnCAYQ34ivWrjl+xcFvx9KlEsLp3KRnHjrWcu3c7rtyJxG7O701Rffgi1nftTyjgQPWnwhOQHvVrvbBRdWYr1TPFVP2aZS0wq0OgqitjzRlSS805I0CVIYw014p16/l9r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmcuRJcN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726065301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PF/0q5orqycLDyFBmSuytp8djSJ4rgjRkbyNMLkxAWQ=;
	b=XmcuRJcNHJfvuCE37YDFhNG59x4hRuyPGIP4MdQ8zvDM5jX89IL/Uo/4utjp/4pvDyuUTK
	im2EUDC9MiWmwHBkZY+etI6ZyqaQm1eKvuq6JV7z6/Fi+xmyumNzQbxyPtKgTB10FModpM
	h9QxOXGLXvKIETE0JxLdl0nj+TA71V8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-9GLUVgEZO8GEErI7VzwXpw-1; Wed, 11 Sep 2024 10:35:00 -0400
X-MC-Unique: 9GLUVgEZO8GEErI7VzwXpw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4581b5172a6so100330571cf.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 07:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726065300; x=1726670100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PF/0q5orqycLDyFBmSuytp8djSJ4rgjRkbyNMLkxAWQ=;
        b=Rekg80ovjkMiFCwETRnzyBlAIcrEbZBOHJilZFJA3Z5xLaew9uWMxDTbtjl+yGbY9g
         hdXQAVs9Cc8rIlzXyexHqbqalwMZkmjq7BzNA+vxlIBHbIH7BvCY3whYOhdmq9h5F8zh
         s9kPjD7HCJZF87YxiKWgbgpuR6pEJ6eXCY0J8hkYf2vKnCiNf6UBYxRcDqi1dOiMTcJD
         n/KveLoiTTCoHFOe9j+/bbDG84NSyx51qjYQVfB44w5QIZRUcDIjH458MseASy2N/Cc0
         UcbJ5pXSM2C1Qp0BmhpZpX+SEdiVY5S3ZYrin/fM0TP4R4YSy0A6mOzqmV5Eh2aGk8DE
         Soeg==
X-Forwarded-Encrypted: i=1; AJvYcCWjZoga5sm/hEH8pGPwrXym2CroDnWPtVu+Ne2z43UCtE2bouzcLYYa6b3QwqvlxkiNCCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi1XP8oSxsws27qOoomCeQe/RZptmY41vQH+l5798n1efHVeQX
	3eFb/kxsRDRel/a4BEIY6bJRVtv/MEd2DUqeDz56pOl6CUJs3f5jgQqqtw8N7Rrp7XhcZoK/DvI
	Jb3fqmh0jbCsckBV+1Z3MxWsU0xo9V5DscSgLW9j/Gko1c4ZSnA==
X-Received: by 2002:a05:622a:651:b0:458:4323:d7b3 with SMTP id d75a77b69052e-4584323d91emr68257411cf.34.1726065300145;
        Wed, 11 Sep 2024 07:35:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFngkfkq1nQs7Kv0mNC7ulS6e7nNeL51I8RbbZOuMP/jFQHPk0ALPxgHZnZfq+Gumf6CJkjkA==
X-Received: by 2002:a05:622a:651:b0:458:4323:d7b3 with SMTP id d75a77b69052e-4584323d91emr68257071cf.34.1726065299714;
        Wed, 11 Sep 2024 07:34:59 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45822e61a77sm41722191cf.20.2024.09.11.07.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 07:34:58 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:34:54 -0400
From: Peter Xu <peterx@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZuGqjiYZA33lUS5z@x1n>
References: <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
 <Zt96CoGoMsq7icy7@x1n>
 <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
 <Zt-N8MB93XSqFZO_@x1n>
 <Zt+0UTTEkkRQQza0@yzhao56-desk.sh.intel.com>
 <ZuA4ivNcz0NwOAh5@x1n>
 <ZuD9l6D6XuAUb4tP@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuD9l6D6XuAUb4tP@yzhao56-desk.sh.intel.com>

On Wed, Sep 11, 2024 at 10:16:55AM +0800, Yan Zhao wrote:
> On Tue, Sep 10, 2024 at 08:16:10AM -0400, Peter Xu wrote:
> > On Tue, Sep 10, 2024 at 10:52:01AM +0800, Yan Zhao wrote:
> > > Hi Peter,
> > 
> > Hi, Yan,
> > 
> > > 
> > > Not sure if I missed anything.
> > > 
> > > It looks that before this patch, pmd/pud are alawys write protected without
> > > checking "is_cow_mapping(vma->vm_flags) && pud_write(pud)". pud_wrprotect()
> > > clears dirty bit by moving the dirty value to the software bit.
> > > 
> > > And I have a question that why previously pmd/pud are always write protected.
> > 
> > IIUC this is a separate question - the move of dirty bit in pud_wrprotect()
> > is to avoid wrongly creating shadow stack mappings.  In our discussion I
> > think that's an extra complexity and can be put aside; the dirty bit will
> > get recovered in pud_clear_saveddirty() later, so it's not the same as
> > pud_mkclean().
> But pud_clear_saveddirty() will only set dirty bit when write bit is 1.

Yes, it's because x86 wants to avoid unexpected write=0 && dirty=1 entries,
because it can wrongly reflect a shadow stack mapping.  Here we cannot
recover the dirty bit if set only if write bit is 1 first.

> 
> > 
> > AFAIU pmd/pud paths don't consider is_cow_mapping() because normally we
> > will not duplicate pgtables in fork() for most of shared file mappings
> > (!CoW).  Please refer to vma_needs_copy(), and the comment before returning
> > false at last.  I think it's not strictly is_cow_mapping(), as we're
> > checking anon_vma there, however it's mostly it, just to also cover
> > MAP_PRIVATE on file mappings too when there's no CoW happened (as if CoW
> > happened then anon_vma will appear already).
> > 
> > There're some outliers, e.g. userfault protected, or pfnmaps/mixedmaps.
> > Userfault & mixedmap are not involved in this series at all, so let's
> > discuss pfnmaps.
> > 
> > It means, fork() can still copy pgtable for pfnmap vmas, and it's relevant
> > to this series, because before this series pfnmap only exists in pte level,
> > hence IMO the is_cow_mapping() must exist for pte level as you described,
> > because it needs to properly take care of those.  Note that in the pte
> > processing it also checks pte_write() to make sure it's a COWed page, not a
> > RO page cache / pfnmap / ..., for example.
> > 
> > Meanwhile, since pfnmap won't appear in pmd/pud, I think it's fair that
> > pmd/pud assumes when seeing a huge mapping it must be MAP_PRIVATE otherwise
> > the whole copy_page_range() could be already skipped.  IOW I think they
> > only need to process COWed pages here, and those pages require write bit
> > removed in both parent and child when fork().
> Is it also based on that there's no MAP_SHARED huge DEVMAP pages up to now?

Correct.

Thanks,

-- 
Peter Xu


