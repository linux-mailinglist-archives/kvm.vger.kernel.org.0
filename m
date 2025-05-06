Return-Path: <kvm+bounces-45664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7C2AACEDD
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 22:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23EAE7B6051
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 20:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D5915573A;
	Tue,  6 May 2025 20:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4FJeR4WO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AA522F01
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 20:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746564422; cv=none; b=F/rkS9B1hwZzcAAEk2+MndGPVRglw5WmCGqk/+pEyCwZZIM00IcTfGlqp5KxfGXNmP7q53HXkflVNSaJtFBk7I0ntzQRTlrnjI35sJrZ0zJ5ozUuwZwXWDeE6fwhhY32WZvZusdtNP+23uvP/yCHchVyimEUOs1sw4Ei+9HwIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746564422; c=relaxed/simple;
	bh=u/O8q2sevigdN4ig818/u3tAXLuUQrGCknUWeKdBp7o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VbeSYzRBDoRe9XlBFQof3vL6DN/broNX7k7KxegmQKbBMTRmJIXv1PG+ud1CeFxyrcM80B19ohUX7QdStPwtivlpGNH5CIQIxYiyDk4fNY/5VTmheHxn/uoIYdWd5ouOJutFrqT11hVozYMhlLni07l/etmtOLs93REv2ivs1l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4FJeR4WO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so3378549a12.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746564420; x=1747169220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DCzobWbLqzYgZ0RtPdZiSF2En8bMULz9xtc7ptlaLyg=;
        b=4FJeR4WOcZKqndYho3fTJX+z6jqdlmBMMF9qFhV/5uv8Yh5fcqWdCE8zqWEzkr8bcm
         vL58yUAgm1iS9KgMryINxP3wOny36OG29Msnb/WZzCMhZaoKDxRBqMpglPqNGuA1LOiC
         EWcCYCdBv76BWZBi8VFAQ5P7sM6FwZZhG2w2XDAWJi946AR5AIlRze2HOe7eCsZmiYgb
         yyoOTIOzLdbdmUIZ71RZ9EmUYdCd+6b/I30kfINxvST1oNAd0tGCynwXwa99mvMlqUqk
         Csklj8taFtmP0f83+1/RoMk1Xe0ZsXBy05XL9UQLXOvun3BU5j7EmixGgXsvdT6O4e4c
         sdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746564420; x=1747169220;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DCzobWbLqzYgZ0RtPdZiSF2En8bMULz9xtc7ptlaLyg=;
        b=hO5pdAhhNWncV1ii8WFtuSpB0/yS9iXbYM33XCk/lGIImoYlsKjkvMxn90yejkFTwE
         cP+UD2M7Paf6xE7QhDoLsaeUeLcaEI00r02qWfLm956DLiMbhSe6/jz9m7tmFlA4et9R
         0Xoc6kJ5XhnQpWZtnAYRdzkNmsqY6tsCcN20jwl7iagZ50WzMTcbWSXgah49qadulDij
         WBSUIXmbEJMSZ3oJI2ECLB/t1xzlLLwFRaW83Kcm9MLfHj8IGYSWNf+obeTMtvDLzEII
         CdOnUgpE42108th9GxGckaCN86LPI4ahOFYqdrOFtPOhMmlQvegInXC4GUAWMe2MQZ+2
         4S0g==
X-Forwarded-Encrypted: i=1; AJvYcCU76xAGCcgTeBwXw+LkDnr+QSuwiBJVI1Ff4jebQl38MBSOqPU6w46mDcgKiBRkhi6R8ts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqpFONVk/9DfBN+idPOpwwRrk4XEXWPf/Gg41cjhgwy+H/a8wF
	HYwefXkClBTwBsMOkZuB4qFrfhsry9rDgP7stAj+s3VTcxsOesx7KUrOtAvo6zrznozZY6HHxbc
	ldSNxXr/zkP+AcKaFC755ng==
X-Google-Smtp-Source: AGHT+IHuf4HiiM5l7QrOtvUrpzBKa8NR8v2a6GaWbIwD5Bf0Sh8JWbcl8IXLPMkv3T1UFmq2oEYM6jTxGiIuLrPMRg==
X-Received: from pfjg15.prod.google.com ([2002:a05:6a00:b8f:b0:740:6f6:7346])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d8f:b0:1f5:902e:1e97 with SMTP id adf61e73a8af0-2148d53bad9mr825091637.41.1746564420272;
 Tue, 06 May 2025 13:47:00 -0700 (PDT)
Date: Tue, 06 May 2025 13:46:58 -0700
In-Reply-To: <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com> <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
 <aBoVbJZEcQ2OeXhG@google.com> <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
Message-ID: <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vishal Annapurve <vannapurve@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

David Hildenbrand <david@redhat.com> writes:

> On 06.05.25 15:58, Sean Christopherson wrote:
>> On Mon, May 05, 2025, Vishal Annapurve wrote:
>>> On Mon, May 5, 2025 at 10:17=E2=80=AFPM Vishal Annapurve <vannapurve@go=
ogle.com> wrote:
>>>>
>>>> On Mon, May 5, 2025 at 3:57=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>>>>>> ...
>>>>>> And not worry about lpage_infor for the time being, until we actuall=
y do
>>>>>> support larger pages.
>>>>>
>>>>> I don't want to completely punt on this, because if it gets messy, th=
en I want
>>>>> to know now and have a solution in hand, not find out N months from n=
ow.
>>>>>
>>>>> That said, I don't expect it to be difficult.  What we could punt on =
is
>>>>> performance of the lookups, which is the real reason KVM maintains th=
e rather
>>>>> expensive disallow_lpage array.
>>>>>
>>>>> And that said, memslots can only bind to one guest_memfd instance, so=
 I don't
>>>>> immediately see any reason why the guest_memfd ioctl() couldn't proce=
ss the
>>>>> slots that are bound to it.  I.e. why not update KVM_LPAGE_MIXED_FLAG=
 from the
>>>>> guest_memfd ioctl() instead of from KVM_SET_MEMORY_ATTRIBUTES?
>>>>
>>>> I am missing the point here to update KVM_LPAGE_MIXED_FLAG for the
>>>> scenarios where in-place memory conversion will be supported with
>>>> guest_memfd. As guest_memfd support for hugepages comes with the
>>>> design that hugepages can't have mixed attributes. i.e. max_order
>>>> returned by get_pfn will always have the same attributes for the folio
>>>> range.
>>=20
>> Oh, if this will naturally be handled by guest_memfd, then do that.  I w=
as purely
>> reacting to David's suggestion to "not worry about lpage_infor for the t=
ime being,
>> until we actually do support larger pages".
>>=20
>>>> Is your suggestion around using guest_memfd ioctl() to also toggle
>>>> memory attributes for the scenarios where guest_memfd instance doesn't
>>>> have in-place memory conversion feature enabled?
>>>
>>> Reading more into your response, I guess your suggestion is about
>>> covering different usecases present today and new usecases which may
>>> land in future, that rely on kvm_lpage_info for faster lookup. If so,
>>> then it should be easy to modify guest_memfd ioctl to update
>>> kvm_lpage_info as you suggested.
>>=20
>> Nah, I just missed/forgot that using a single guest_memfd for private an=
d shared
>> would naturally need to split the folio and thus this would Just Work.

Sean, David, I'm circling back to make sure I'm following the discussion
correctly before Fuad sends out the next revision of this series.

>
> Yeah, I ignored that fact as well. So essentially, this patch should be=
=20
> mostly good for now.
>

From here [1], these changes will make it to v9

+ kvm_max_private_mapping_level renaming to kvm_max_gmem_mapping_level
+ kvm_mmu_faultin_pfn_private renaming to kvm_mmu_faultin_pfn_gmem

> Only kvm_mmu_hugepage_adjust() must be taught to not rely on=20
> fault->is_private.
>

I think fault->is_private should contribute to determining the max
mapping level.

By the time kvm_mmu_hugepage_adjust() is called,

* For Coco VMs using guest_memfd only for private memory,
  * fault->is_private would have been checked to align with
    kvm->mem_attr_array, so=20
* For Coco VMs using guest_memfd for both private/shared memory,
  * fault->is_private would have been checked to align with
    guest_memfd's shareability
* For non-Coco VMs using guest_memfd
  * fault->is_private would be false

Hence fault->is_private can be relied on when calling
kvm_mmu_hugepage_adjust().

If fault->is_private, there will be no host userspace mapping to check,
hence in __kvm_mmu_max_mapping_level(), we should skip querying host
page tables.

If !fault->is_private, for shared memory ranges, if the VM uses
guest_memfd only for shared memory, we should query host page tables.

If !fault->is_private, for shared memory ranges, if the VM uses
guest_memfd for both shared/private memory, we should not query host
page tables.

If !fault->is_private, for non-Coco VMs, we should not query host page
tables.

I propose to rename the parameter is_private to skip_host_page_tables,
so

- if (is_private)
+ if (skip_host_page_tables)
	return max_level;

and pass

skip_host_page_tables =3D fault->is_private ||
			kvm_gmem_memslot_supports_shared(fault->slot);

where kvm_gmem_memslot_supports_shared() checks the inode in the memslot
for GUEST_MEMFD_FLAG_SUPPORT_SHARED.

For recover_huge_pages_range(), the other user of
__kvm_mmu_max_mapping_level(), currently there's no prior call to
kvm_gmem_get_pfn() to get max_order or max_level, so I propose to call
__kvm_mmu_max_mapping_level() with

if (kvm_gmem_memslot_supports_shared(slot)) {
	max_level =3D kvm_gmem_max_mapping_level(slot, gfn);
	skip_host_page_tables =3D true;
} else {
	max_level =3D PG_LEVEL_NUM;
        skip_host_page_tables =3D kvm_slot_has_gmem(slot) &&
				kvm_mem_is_private(kvm, gfn);
}

Without 1G support, kvm_gmem_max_mapping_level(slot, gfn) would always
return 4K.

With 1G support, kvm_gmem_max_mapping_level(slot, gfn) would return the
level for the page's order, at the offset corresponding to the gfn.

> Once we support large folios in guest_memfd, only the "alignment"=20
> consideration might have to be taken into account.
>

I'll be handling this alignment as part of the 1G page support series
(won't be part of Fuad's first stage series) [2]

> Anything else?
>
> --=20
> Cheers,
>
> David / dhildenb


[1] https://lore.kernel.org/all/20250430165655.605595-7-tabba@google.com/
[2] https://lore.kernel.org/all/diqz1pt1sfw8.fsf@ackerleytng-ctop.c.googler=
s.com/

