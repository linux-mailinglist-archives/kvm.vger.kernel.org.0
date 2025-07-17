Return-Path: <kvm+bounces-52719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5355FB08870
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 10:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D7714A92E6
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FD4288CA1;
	Thu, 17 Jul 2025 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpLa3o+4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B626A286D79
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752742236; cv=none; b=eiYvAS97+vhNSILf7nLkev8eJaTQlbWeRu+zkCpFuVpogqmcDCaKGzOTbuDyV6/cygfwMnN8RjUFIs+aBgLJ9EqZ/5lCcUVLiBevUG99joRHwi2zX1liwrUpBAeH6mnZCy0snZqLkuigODH12TuBVfmhjNtJQVbM1szKsNOjz/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752742236; c=relaxed/simple;
	bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khiasI0hKYoQcmrkeIYI0qDgqEcuDt5+qPLnUC+QyJj4wEwH5lvPcJo2gI1yGfIdkguEc3cyDYA40GPr1kh366Te/PLpwp1ZGcQr32reMHpOTg09lcLw/q+Ck2Nb/Z9DOJn0S8+IFne2Y/81lPfpR/TWzhl0FHbh47MxsHGGeEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpLa3o+4; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso102701cf.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 01:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752742234; x=1753347034; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
        b=vpLa3o+4lrK8Pq97imlhP8LBg8wwowk/eSFt2Vp5PcFpB0wNUPXaFvlHxn8aT/nggE
         u9pRXaGRrjfEOEtEa7te5dZA82bdZ0yuHs9AzQQU3DXu6a4tlrdCo4O6FexIxw+zU7tL
         vZGu18gPV/EvrVnZYP2BG1tQXnen2dI9brxnPK7Lq8yKjn9XrgpJrVGEJbWZnxRmgmDO
         87M/Dw7bpS6qRNCLS4nCzC3ro9LBiLbQMMPqNRnmH6aL9GUVLF7iH9KMMYDMJlfj1wzn
         /K1L0s4f0RujlA1C0TDSVjCP013mHORXXh3/bkE1jnffYToKUGzHU2cWy7l/s+28duWW
         nuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752742234; x=1753347034;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx1JuSGB5ku3XgYVMYRTc/eMvpZ5Y30SL8s3qhNbUrI=;
        b=u2mrAQr1MPJshzvYm1sBsx6ML+7k1mzQY6lPnZ72/vQtjIMPREnon5Ua126qPQ7VGH
         TxwDJGOknb5XvLH5NXlVqVVLZFO3cbqjBI4Hw+hWeZPAIqhovYRt37DoIgiWgnpoQ9yS
         ymbYK0g4wiPGejabFMXJTpfEYImp0KOPAcW57BJsJIPUehLrLVZvE9553kRgNWE9Pzzu
         9JKStsEv8v3R2e5/AU8BXLid3w2Mxu4KZgY/qaBT7qaRVSrs80upn42khIhCa53Zrgx+
         RyBNa6UsCPCZGJLIwwzXODz0k8OFe533cqlMK2SQOTJ0mMXQ8WfvhNMT6KcoWLAuCYZl
         tqeA==
X-Forwarded-Encrypted: i=1; AJvYcCWA4OJClBVuFbXpP/bpwqjSlP4pibLDD7erGFL8z5ZpGXV1OaVdCDyiPLi4pt3jn/Zt/SY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yycj30Jobw5gI6M8jAJ+v3iSpemIQnTov/w/YvOGnh4SFakeTtk
	k+G1XZ6YdaH1Qm6ERYkYiDRVhvdR5DcMu3wKgPEL+5Dwn3VXpC49evmXWCB+H+ovl5tCKHU/6xS
	x6RJeznomMD0mZeOs9NecKlIXgCmnXehjCpuW/D7C
X-Gm-Gg: ASbGncu9bVA49TXy1eA2ehUIHrmvrkSOr2sI6mGieol+297HrEwPmqIMos5GoFb51Vx
	8/7IS9fJFv/phmG246hU5YHB3E3kMuYt8GHivjXIhcN39dR1q3i0kSnxtaqduWQ9tMuMelC3XOm
	v8liYknF791u3yS0UtOHrPKy7LICS9HumnyQl6tF1Dvx8Qjgbj2nh4RK24J+jk4CZR7ed2jNsin
	G4tYB8=
X-Google-Smtp-Source: AGHT+IFJBjuZkaiMWobXRfRh9pmhDTYS+xIxMCNkviUrQydZTRd7jIJNkT2lW8gpa/i0jfk07s7YUC00WwCYYsXC4qM=
X-Received: by 2002:a05:622a:1f85:b0:4a9:d3e7:56bf with SMTP id
 d75a77b69052e-4aba4adbb61mr2533831cf.27.1752742233129; Thu, 17 Jul 2025
 01:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com> <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
 <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
In-Reply-To: <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Jul 2025 09:49:56 +0100
X-Gm-Features: Ac12FXxkRhY2UmJu3hO9xLioH89YY6t8CrSg4iy4xmUp0dV0rsQQHNL4_tw_xsk
Message-ID: <CA+EHjTzZH2NN31ZfTg0NX_o3dryqbkmR4s8Y47eFJ1TcO1kiDA@mail.gmail.com>
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Xiaoyao,

On Thu, 17 Jul 2025 at 02:48, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/17/2025 8:12 AM, Ackerley Tng wrote:
> > Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >
> >> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>> Introduce a new boolean member, supports_gmem, to kvm->arch.
> >>>
> >>> Previously, the has_private_mem boolean within kvm->arch was implicitly
> >>> used to indicate whether guest_memfd was supported for a KVM instance.
> >>> However, with the broader support for guest_memfd, it's not exclusively
> >>> for private or confidential memory. Therefore, it's necessary to
> >>> distinguish between a VM's general guest_memfd capabilities and its
> >>> support for private memory.
> >>>
> >>> This new supports_gmem member will now explicitly indicate guest_memfd
> >>> support for a given VM, allowing has_private_mem to represent only
> >>> support for private memory.
> >>>
> >>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >>> Reviewed-by: Shivank Garg <shivankg@amd.com>
> >>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >>> Co-developed-by: David Hildenbrand <david@redhat.com>
> >>> Signed-off-by: David Hildenbrand <david@redhat.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>
> >> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >>
> >> Btw, it seems that supports_gmem can be enabled for all the types of VM?
> >>
> >
> > For now, not really, because supports_gmem allows mmap support, and mmap
> > support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
> > mean that shared faults also get faulted from guest_memfd.
>
> No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is
> independent to whether gmem is supported.

It is dependent on gmem support:

kvm_arch_supports_gmem_mmap(kvm) depends on
CONFIG_KVM_GMEM_SUPPORTS_MMAP, which in turn selects KVM_GMEM.


> > A TDX VM that wants to use guest_memfd for private memory and some other
> > backing memory for shared memory (let's call this use case "legacy CoCo
> > VMs") will not work if supports_gmem is just enabled for all types of
> > VMs, because then shared faults will also go to kvm_gmem_get_pfn().
>
> This is not what this patch does. Please go back read this patch.
>
> This patch sets kvm->arch.supports_gmem to true for
> KVM_X86_SNP_VM/tdx/KVM_X86_SW_PROTECTED_VM.
>
> Further in patch 14, it sets kvm->arch.supports_gmem for KVM_X86_DEFAULT_VM.
>
> After this series, supports_gmem remains false only for KVM_X86_SEV_VM
> and KVM_X86_SEV_ES_VM. And I don't see why cannot enable supports_gmem
> for them.

It's not that we can't, it's just that we had no reason to enable it.
When the time comes, it's just a matter of setting a boolean.

Thanks,
/fuad

> > This will be cleaned up when guest_memfd supports conversion
> > (guest_memfd stage 2). There, a TDX VM will have .supports_gmem = true.
> >
> > With guest_memfd stage-2 there will also be a
> > KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING.
> > KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaults to false, so for legacy
> > CoCo VMs, shared faults will go to the other non-guest_memfd memory
> > source that is configured in userspace_addr as before.
> >
> > With guest_memfd stage-2, KVM_MEMSLOT_GMEM_ONLY will direct all EPT
> > faults to kvm_gmem_get_pfn(), but KVM_MEMSLOT_GMEM_ONLY will only be
> > allowed if KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is true. TDX VMs
> > wishing to use guest_memfd as the only source of memory for the guest
> > should set KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING to true before
> > creating the guest_memfd.
> >
> >> Even without mmap support, allow all the types of VM to create
> >> guest_memfd seems not something wrong. It's just that the guest_memfd
> >> allocated might not be used, e.g., for KVM_X86_DEFAULT_VM.
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > p
>

