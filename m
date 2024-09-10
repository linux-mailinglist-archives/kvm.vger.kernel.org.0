Return-Path: <kvm+bounces-26259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B047C9736F4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCB6B1C21847
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A913318FDDC;
	Tue, 10 Sep 2024 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwmy469Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5588F18A6AA
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725970579; cv=none; b=XZMYJi15Yt6tG1aOohQwA6sO4JC//bXpuwCoT/jL3la95ImSnjKw4hhxU57+H6L0QhdBmXY7yTksiFn4DF1qJpLNhTAMEiXwrWs2ez0ASEgYJ2xLaekkvbubMlIQn+QZ9Ff41l+UfynrgmZtxFGtktoZbxqsh1zIQYGU/lMBTe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725970579; c=relaxed/simple;
	bh=UEfWeuvm0Ydu8ziZV3f9vRnj+VSGpjuHDKnB6BVHGBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ak8xd0l+Uwvi2RITU1Bj1B/xP/F44oC5OW05jEcKPiGdwbQ60BlCjEvBn9JF9qcxj8NfckEpx6iwTg29fwYfrEVMFpFnK+WPyBEug3E/m+KRPJh7er5GdhPVYtxm715fJ/HCEc8sdtoFu1CeIBcmJfTwYc+fRTLMgJkMUQWD4EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwmy469Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725970577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TqNTsGxo7KShGTs/iiAEuAgoPybBC8iCW7tKXvfqSTE=;
	b=fwmy469Znubw9uqU/lVnt0prsnNShV5HAWs78pWERWYtfEEVxuafgoAgLZ1Y4rusQD5901
	fYBJEya6EmzqjsZtBP5CZCZXJ3EWrp6ERrNbNYvMqavXYYr/+CfehbC88NNUN+Hkidpent
	m7XB5ldAw4ekdpC/N1lyK2+2WXarPNo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-egKrHm18Nv2zb0M-RLFluA-1; Tue, 10 Sep 2024 08:16:16 -0400
X-MC-Unique: egKrHm18Nv2zb0M-RLFluA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-458373c736fso15607621cf.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 05:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725970575; x=1726575375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqNTsGxo7KShGTs/iiAEuAgoPybBC8iCW7tKXvfqSTE=;
        b=ihNOBQtdBoqGskD4rLyjQ4hQhacrdmkKNoIxmQBxwNBauENhfY/sa1OKJlCgrnywVz
         CWFIGAWgyb6g8I7DBBqYfurfjNyPWV9/gBYYwcq46FjHKaV+dkrrUquh5NlFOK69Ko1c
         17GQqHRxlH34EQ8foNQtN9R7VqqIq2ZAAxnEzefCyZ1OE0kLLgWpVs+x49i2VLN9yoeO
         j4NCN/vz3adsAQwafUDE96Z2X6rR5hHG+ztbZKUF+GXuAI3epq9uV24YOZvdApqIIBDX
         qiHPLFq/KPM4VB/Befm4eGg5ilg0I+oT4aAMIyPyGZgbGySIUzmfKCpSR5CuXVun15EX
         dc5g==
X-Forwarded-Encrypted: i=1; AJvYcCWLRNok8A4ldhJiNC/379hn7atbz3lH8vEPyvQ6tkdTEZZ/d6NcsHOUPYwyBjIC4IMTyMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAtaPWP+By0hbsl5pY+zByigybF+TnEq/T9JgmBo02aaIZA2+g
	E/Jnb6PUzUI7EeISdcnaAlqj0hnmZKuxrMXlta8IgCLM1Oma/ZcJYQoQ7FlAswWm327OF4Txpxh
	DlQlLDXKeDsucWur5QTmIU9GHpUQ0iR/+izY7Evf4LvW8cpzxBw==
X-Received: by 2002:ac8:5f47:0:b0:458:1578:56a6 with SMTP id d75a77b69052e-4581f480530mr147993521cf.24.1725970575407;
        Tue, 10 Sep 2024 05:16:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFv3wgyd3Hg6lqpOUUjpJkTGHHsYgJs2xr7aDITSvRwlUJdHVQc4gd4/fSmPETPVJLM55vBA==
X-Received: by 2002:ac8:5f47:0:b0:458:1578:56a6 with SMTP id d75a77b69052e-4581f480530mr147993141cf.24.1725970574851;
        Tue, 10 Sep 2024 05:16:14 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45822eb001bsm29057461cf.54.2024.09.10.05.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 05:16:14 -0700 (PDT)
Date: Tue, 10 Sep 2024 08:16:10 -0400
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
Message-ID: <ZuA4ivNcz0NwOAh5@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
 <Zt96CoGoMsq7icy7@x1n>
 <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
 <Zt-N8MB93XSqFZO_@x1n>
 <Zt+0UTTEkkRQQza0@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zt+0UTTEkkRQQza0@yzhao56-desk.sh.intel.com>

On Tue, Sep 10, 2024 at 10:52:01AM +0800, Yan Zhao wrote:
> Hi Peter,

Hi, Yan,

> 
> Not sure if I missed anything.
> 
> It looks that before this patch, pmd/pud are alawys write protected without
> checking "is_cow_mapping(vma->vm_flags) && pud_write(pud)". pud_wrprotect()
> clears dirty bit by moving the dirty value to the software bit.
> 
> And I have a question that why previously pmd/pud are always write protected.

IIUC this is a separate question - the move of dirty bit in pud_wrprotect()
is to avoid wrongly creating shadow stack mappings.  In our discussion I
think that's an extra complexity and can be put aside; the dirty bit will
get recovered in pud_clear_saveddirty() later, so it's not the same as
pud_mkclean().

AFAIU pmd/pud paths don't consider is_cow_mapping() because normally we
will not duplicate pgtables in fork() for most of shared file mappings
(!CoW).  Please refer to vma_needs_copy(), and the comment before returning
false at last.  I think it's not strictly is_cow_mapping(), as we're
checking anon_vma there, however it's mostly it, just to also cover
MAP_PRIVATE on file mappings too when there's no CoW happened (as if CoW
happened then anon_vma will appear already).

There're some outliers, e.g. userfault protected, or pfnmaps/mixedmaps.
Userfault & mixedmap are not involved in this series at all, so let's
discuss pfnmaps.

It means, fork() can still copy pgtable for pfnmap vmas, and it's relevant
to this series, because before this series pfnmap only exists in pte level,
hence IMO the is_cow_mapping() must exist for pte level as you described,
because it needs to properly take care of those.  Note that in the pte
processing it also checks pte_write() to make sure it's a COWed page, not a
RO page cache / pfnmap / ..., for example.

Meanwhile, since pfnmap won't appear in pmd/pud, I think it's fair that
pmd/pud assumes when seeing a huge mapping it must be MAP_PRIVATE otherwise
the whole copy_page_range() could be already skipped.  IOW I think they
only need to process COWed pages here, and those pages require write bit
removed in both parent and child when fork().

After this series, pfnmaps can appear in the form of pmd/pud, then the
previous assumption will stop holding true, as we'll still copy pfnmaps
during fork() always. My guessing of the reason is because most of the
drivers map pfnmap vmas only during mmap(), it means there can normally
have no fault() handler at all for those pfns.

In this case, we'll need to also identify whether the page is COWed, using
the newly added "is_cow_mapping() && pxx_write()" in this series (added
to pud path, while for pmd path I used a WARN_ON_ONCE instead).

If we don't do that, it means e.g. for a VM_SHARED pfnmap vma, after fork()
we'll wrongly observe write protected entries.  Here the change will make
sure VM_SHARED can properly persist the write bits on pmds/puds.

Hope that explains.

Thanks,

-- 
Peter Xu


