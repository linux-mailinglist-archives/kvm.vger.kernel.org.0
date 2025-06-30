Return-Path: <kvm+bounces-51099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0808AEE062
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 16:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35E743AA2B4
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6095128C2CE;
	Mon, 30 Jun 2025 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p01AERoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B7B246788
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751292864; cv=none; b=Ydy86iQ042CHrZIQgm5kaAw5SLN43yvI/dMTQCqB0F8elH+rILEguDrXUhX/KSNComiCjIPYy3JwJbbNQLhYrQ7qBLHpfAuulof7xOtF2XS5OpicwVGYjzen0aNU/sXeHuFHAgHfas+tsBlePqqLaVfm5bLCigF+WuNwRo0KH/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751292864; c=relaxed/simple;
	bh=CUZcr6fVm4NlZL0RgjFMsxmp/DZt3WRGfu37PHYhU24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewiCuhzwbB+6SV+Co9udmQLOab8c/hdVHB2TP2JMj5VuVmUoEK1RKb9mGis+N6yjmjeCDV9MAGxgw9ciIbTTmZ3OaK01ZmZ59qhrOfphFgvxEGnClHqEk5fZ5+Z5HKRkjDIDfgsPrdpxMl5T06mL1P+/ZmuU0WbythiXnPwhsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p01AERoO; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-237f270513bso296575ad.1
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751292861; x=1751897661; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3YhyQhhzhBw+UKvE/Ww6oXAxKgXpPIyifb0WjxIRJY=;
        b=p01AERoOQk2PaSDNPZDw+z/nGILvCwHtMdVoNvhjQMkyho/75b2kHoi5CDFMJz/zo6
         V8vzzCeSlyj/Gze63nKihXnoe5ZJpYqNdSaB6TXlEjSC4E725eDkZ1p1mspKj+SXC8RP
         4e2fToV8QJUy5kqP30kIicbOCu1KNKWYQXSJ2IqtS6uJ1wj/Yvf/yNVNX5Ogz7spgvU/
         68F5TzIW31nU3SDWe01J3yB4iFOn/xZdWQgfBs94j7exS0ZjQA4iPgFYziqeMpKGTmaL
         yL0OuRa3zgsNtc0XYA1qy7rDgFYZTdunn8sKHqxLd/IB/B0jMhEW5u5kkjYwPqsjb6Bd
         fTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751292861; x=1751897661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3YhyQhhzhBw+UKvE/Ww6oXAxKgXpPIyifb0WjxIRJY=;
        b=dVLUO3xI4gN7jOAZn4IE4Bgez3AZF9GFopzhpW+mULJvEaRxNEr23S39ONrxcRiAtt
         /9JyoUm4mzRdY46VnRH8AwL+TxdmS2o4tJdLD4SDZaGqHFJ7AnjO15Ev3cTrEPAY2xBH
         fH2wXXQIQ5IXZ+5E5Ft8EbISv4GtUnwEJmHTomevo/0au4qLLpqePL+88D+kYqRCDe3i
         j1GHUZHYhn4bTL2EqZA/n8T3QzljW/+NEFZptX/jYZO/jvrvHglq5ovA+CQr28DUZPMZ
         jMjNCAEoPKyuBJvvPfWvrlT2djAsqzGk2uiaw+kWHM8uo4+MKgbg3zUJpuGUafqCvUTZ
         YXWw==
X-Forwarded-Encrypted: i=1; AJvYcCXNPUvyyG6pLNq4IreUYwO3dirOie57qKxTkj8MVt8Ljm1i9u9JRjdymS3OWG7e2NKJJuU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzef4idcqGxICPUpE8yRTUqQD+tDt3BIiEliwlSEb2ssIf1vSzE
	wwAOl3zfr8Wdqc+RKrFfej2y7NrBezUQNh8uLrqZEsHfEZqVHulGBa8h7l73xqmtKzNlMaVrdhD
	bi8hZSVNyu/zXqj/c7/2f9NRJczfu+lyI23VyB0G3
X-Gm-Gg: ASbGncsLwETtfL9CsBjS9Y44Mvmpho55wJpwaJjis/9iutsqfBejMn+5eQZYmWA9KCX
	BGSU9ELMw0/9gMyrQoYmHreCXNrpEepRtzSR2Z4zFsia+Bd6u5s+8/zuKJKWrO8yWMU6NEyNf4p
	Zr1n0ziJpPca5qbTobcBF82Cy7c47O13zOehdnau/JtPzO9cf9vuHLFFRglvAPqk/NU+BIULP+e
	Sw0
X-Google-Smtp-Source: AGHT+IEG+yYQRShX2eCBsh+gkX2OuX0sYXUf8ANfIRJdlFT/hUpfbXpiEF5PxwlidvJtH87uoHpmmSkgeA4elew1Y58=
X-Received: by 2002:a17:902:d588:b0:234:afcf:d9de with SMTP id
 d9443c01a7336-23ae9f7b05bmr4120325ad.29.1751292860689; Mon, 30 Jun 2025
 07:14:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <aFPGlAGEPzxlxM5g@yzhao56-desk.sh.intel.com>
 <d15bfdc8-e309-4041-b4c7-e8c3cdf78b26@intel.com> <CAGtprH-Kzn2kOGZ4JuNtUT53Hugw64M-_XMmhz_gCiDS6BAFtQ@mail.gmail.com>
 <aGIBGR8tLNYtbeWC@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGIBGR8tLNYtbeWC@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 30 Jun 2025 07:14:07 -0700
X-Gm-Features: Ac12FXwfnKqMFtjiZJXXQ5NYPM9dcCUmxbZVI12HM5E-BFhANicX2DD6O3kaYs8
Message-ID: <CAGtprH-83EOz8rrUjE+O8m7nUDjt=THyXx=kfft1xQry65mtQg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-fsdevel@vger.kernel.org, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vbabka@suse.cz, 
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2025 at 8:17=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Sun, Jun 29, 2025 at 11:28:22AM -0700, Vishal Annapurve wrote:
> > On Thu, Jun 19, 2025 at 1:59=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.co=
m> wrote:
> > >
> > > On 6/19/2025 4:13 PM, Yan Zhao wrote:
> > > > On Wed, May 14, 2025 at 04:41:39PM -0700, Ackerley Tng wrote:
> > > >> Hello,
> > > >>
> > > >> This patchset builds upon discussion at LPC 2024 and many guest_me=
mfd
> > > >> upstream calls to provide 1G page support for guest_memfd by takin=
g
> > > >> pages from HugeTLB.
> > > >>
> > > >> This patchset is based on Linux v6.15-rc6, and requires the mmap s=
upport
> > > >> for guest_memfd patchset (Thanks Fuad!) [1].
> > > >>
> > > >> For ease of testing, this series is also available, stitched toget=
her,
> > > >> at https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-=
support-rfc-v2
> > > >
> > > > Just to record a found issue -- not one that must be fixed.
> > > >
> > > > In TDX, the initial memory region is added as private memory during=
 TD's build
> > > > time, with its initial content copied from source pages in shared m=
emory.
> > > > The copy operation requires simultaneous access to both shared sour=
ce memory
> > > > and private target memory.
> > > >
> > > > Therefore, userspace cannot store the initial content in shared mem=
ory at the
> > > > mmap-ed VA of a guest_memfd that performs in-place conversion betwe=
en shared and
> > > > private memory. This is because the guest_memfd will first unmap a =
PFN in shared
> > > > page tables and then check for any extra refcount held for the shar=
ed PFN before
> > > > converting it to private.
> > >
> > > I have an idea.
> > >
> > > If I understand correctly, the KVM_GMEM_CONVERT_PRIVATE of in-place
> > > conversion unmap the PFN in shared page tables while keeping the cont=
ent
> > > of the page unchanged, right?
> >
> > That's correct.
> >
> > >
> > > So KVM_GMEM_CONVERT_PRIVATE can be used to initialize the private mem=
ory
> > > actually for non-CoCo case actually, that userspace first mmap() it a=
nd
> > > ensure it's shared and writes the initial content to it, after it
> > > userspace convert it to private with KVM_GMEM_CONVERT_PRIVATE.
> >
> > I think you mean pKVM by non-coco VMs that care about private memory.
> > Yes, initial memory regions can start as shared which userspace can
> > populate and then convert the ranges to private.
> >
> > >
> > > For CoCo case, like TDX, it can hook to KVM_GMEM_CONVERT_PRIVATE if i=
t
> > > wants the private memory to be initialized with initial content, and
> > > just do in-place TDH.PAGE.ADD in the hook.
> >
> > I think this scheme will be cleaner:
> > 1) Userspace marks the guest_memfd ranges corresponding to initial
> > payload as shared.
> > 2) Userspace mmaps and populates the ranges.
> > 3) Userspace converts those guest_memfd ranges to private.
> > 4) For both SNP and TDX, userspace continues to invoke corresponding
> > initial payload preparation operations via existing KVM ioctls e.g.
> > KVM_SEV_SNP_LAUNCH_UPDATE/KVM_TDX_INIT_MEM_REGION.
> >    - SNP/TDX KVM logic fetches the right pfns for the target gfns
> > using the normal paths supported by KVM and passes those pfns directly
> > to the right trusted module to initialize the "encrypted" memory
> > contents.
> >        - Avoiding any GUP or memcpy from source addresses.
> One caveat:
>
> when TDX populates the mirror root, kvm_gmem_get_pfn() is invoked.
> Then kvm_gmem_prepare_folio() is further invoked to zero the folio.

Given that confidential VMs have their own way of initializing private
memory, I think zeroing makes sense for only shared memory ranges.
i.e. something like below:
1) Don't zero at allocation time.
2) If faulting in a shared page and its not uptodate, then zero the
page and set the page as uptodate.
3) Clear uptodate flag on private to shared conversion.
4) For faults on private ranges, don't zero the memory.

There might be some other considerations here e.g. pKVM needs
non-destructive conversion operation, which might need a way to enable
zeroing at allocation time only.

On a TDX specific note, IIUC, KVM TDX logic doesn't need to clear
pages on future platforms [1].

[1] https://lore.kernel.org/lkml/6de76911-5007-4170-bf74-e1d045c68465@intel=
.com/

>
> > i.e. for TDX VMs, KVM_TDX_INIT_MEM_REGION still does the in-place TDH.P=
AGE.ADD.
> So, upon here, the pages should not contain the original content?
>

Pages should contain the original content. Michael is already
experimenting with similar logic [2] for SNP.

[2] https://lore.kernel.org/lkml/20250613005400.3694904-6-michael.roth@amd.=
com/

