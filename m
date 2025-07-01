Return-Path: <kvm+bounces-51212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6840AF0415
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B103A4A730C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 19:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FD1284695;
	Tue,  1 Jul 2025 19:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2O5GWZvY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DD027815E
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 19:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751399335; cv=none; b=rB1Tacm+Z7PUdcyvv9wpZKejRjFMKGA8O8TrZ9pOk7B9g3ai4P/0AKJETKimr9gMKNMZqXgnbfYsPpOScHoCP/wjesq32j1gdeVzs03GNpxA9cP5wlTS8dxA2F5ur5ejVTTnCvdPawVEJ9nKG2GXVMtjG1iOCpbvxfRBhqsG/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751399335; c=relaxed/simple;
	bh=mj0LuMEIHkeDqISX83LZ/MGBi2QrnJld9gtywbIifJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLdALoeCOI7STdhXx0T+EeILWyl7ZKhSl2wdezY2T6xHTwJjcLSFKKZb6cHTobWRhFVe0GTSqbAQunTsdYOecAZlac1K02P6mPrQkFrhm+yPkAAWWgOFlCB+ebLb8BrxuP+pVMWbAUqdXpskXe9O0dyCny7AxQry/8ybwZz1x6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2O5GWZvY; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235e389599fso313525ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 12:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751399332; x=1752004132; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9C1A9ZtlfkyrWjrc9HRSFIAILIDx8xEDJtLSogn8us=;
        b=2O5GWZvYALJqvqrmRSiFyf73FcGyzwHXGUMm7sGUojrRpLBo/JUyTnWkYxelHCGKVU
         KBsQc1FolcOlO/WcpcbSKIC4TrsZY6N/mt5wrwkt5OGCtSvGGMLZM3hJV7Qy0vcGsfa8
         TldP0RKRnW3e8ee12y79Iy+7uFdPnp3t17OashmjQeqbp1cnV0IIIkEHteTFdlkc4Fft
         /Q/u72z2iSmUKPyUdWvtv535M7CjiQn9I300m48Ct2+NNrFr9gEyr6ML9Jt0AVcTMK3A
         tJ8/5MX7uI5OBl766s1N+I3BeviBbNyvIh7J/Q92tY6zw2tudz32Sd55FdWAjCVD2Pcw
         uiSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751399332; x=1752004132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9C1A9ZtlfkyrWjrc9HRSFIAILIDx8xEDJtLSogn8us=;
        b=qNaxG7b3yc3wLk9kN32pW6OvGmno1h0HBoZTLaLYn2VYwuZVMGuqjn4REnPFspjT7O
         ZTgZtF8Iu7r7ibFDQMRZmQUCU0kmHQhZ1xlL0nMcdHi/wbOHJt5HDkNnN/1zXIqRT/SV
         K2D0L2FjRY1+PU6VMbHmboR20BWJ/54zSHdQ4TpbPH0qeBIN7AsZL3NqBYlmEY+bui6L
         ARw/59vzcn9lqoZUGsGsAIUOjwtQ9Ezdg+iMXZ89w+1QXW4RENkmhLda/kc8X3QFEHFD
         cEZxQ6MgCqUG13MeFX5AbzzN+HM0/nr7dmxzYhoY8mi+E4m0PveCAtxnd7sUtzCv9z2W
         LRew==
X-Forwarded-Encrypted: i=1; AJvYcCUVA5YwPcXAYmfeTBN1aOLll/Pja/gtJ/KUEMgMPCDSrJuuLj3aIasMyj/TvKxKp5i3Qxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMP95eB+G19aVQ71+q4q4CMi2YwT1lPwl2cph/atT/3PY0MiqA
	mlC0FfMKNzPYdBK7jmaFTwRzy1g1LKy8KmqnRcQcn42VUWcmnUBmY3jHI78k1NU/agB1FXYMxbC
	ZTSrgvwSEz2vw9DZrjq/XjP8lon0oVwdaUvPFgw7w
X-Gm-Gg: ASbGncuAQy0aKO27P0CnXgfqoFePwAvdnu+91SDlYb7b3obH8TuSKkuk1aHYzmwGKDD
	gwcGg16rEY8z9rbrsc8gpD8QaeWeZ32Kr7Z9wS47ihEedoYMorMU2MCRO/X+MoQu/Ztv+JgPuK6
	jZjD/9mOdm/6s5yTwuqyThQLNg7i0ek5N2nMngzXKKLh3uFkJoRv1j7VeeUyOno8gdPEqmlo+MV
	w==
X-Google-Smtp-Source: AGHT+IENvYXPgDpUe+vzQE5KuUHBhTP80X2A30Z/Ya++kiVZW1d4u/JfEmH54FnMc8zPFv+a5qX8wSTbmwJULaQEjiE=
X-Received: by 2002:a17:903:22c9:b0:235:e8da:8e1 with SMTP id
 d9443c01a7336-23c60129194mr3562225ad.18.1751399331772; Tue, 01 Jul 2025
 12:48:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <aFPGlAGEPzxlxM5g@yzhao56-desk.sh.intel.com>
 <d15bfdc8-e309-4041-b4c7-e8c3cdf78b26@intel.com> <CAGtprH-Kzn2kOGZ4JuNtUT53Hugw64M-_XMmhz_gCiDS6BAFtQ@mail.gmail.com>
 <aGIBGR8tLNYtbeWC@yzhao56-desk.sh.intel.com> <CAGtprH-83EOz8rrUjE+O8m7nUDjt=THyXx=kfft1xQry65mtQg@mail.gmail.com>
 <aGNw4ZJwlClvqezR@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGNw4ZJwlClvqezR@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 1 Jul 2025 12:48:39 -0700
X-Gm-Features: Ac12FXxoJDvGZ3lWm10aNZICDIFBf9oAjAloEEDJd5krCXcYZQlXLEUbQye3aB0
Message-ID: <CAGtprH-Je5OL-djtsZ9nLbruuOqAJb0RCPAnPipC1CXr2XeTzQ@mail.gmail.com>
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

On Mon, Jun 30, 2025 at 10:26=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> On Mon, Jun 30, 2025 at 07:14:07AM -0700, Vishal Annapurve wrote:
> > On Sun, Jun 29, 2025 at 8:17=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Sun, Jun 29, 2025 at 11:28:22AM -0700, Vishal Annapurve wrote:
> > > > On Thu, Jun 19, 2025 at 1:59=E2=80=AFAM Xiaoyao Li <xiaoyao.li@inte=
l.com> wrote:
> > > > >
> > > > > On 6/19/2025 4:13 PM, Yan Zhao wrote:
> > > > > > On Wed, May 14, 2025 at 04:41:39PM -0700, Ackerley Tng wrote:
> > > > > >> Hello,
> > > > > >>
> > > > > >> This patchset builds upon discussion at LPC 2024 and many gues=
t_memfd
> > > > > >> upstream calls to provide 1G page support for guest_memfd by t=
aking
> > > > > >> pages from HugeTLB.
> > > > > >>
> > > > > >> This patchset is based on Linux v6.15-rc6, and requires the mm=
ap support
> > > > > >> for guest_memfd patchset (Thanks Fuad!) [1].
> > > > > >>
> > > > > >> For ease of testing, this series is also available, stitched t=
ogether,
> > > > > >> at https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-p=
age-support-rfc-v2
> > > > > >
> > > > > > Just to record a found issue -- not one that must be fixed.
> > > > > >
> > > > > > In TDX, the initial memory region is added as private memory du=
ring TD's build
> > > > > > time, with its initial content copied from source pages in shar=
ed memory.
> > > > > > The copy operation requires simultaneous access to both shared =
source memory
> > > > > > and private target memory.
> > > > > >
> > > > > > Therefore, userspace cannot store the initial content in shared=
 memory at the
> > > > > > mmap-ed VA of a guest_memfd that performs in-place conversion b=
etween shared and
> > > > > > private memory. This is because the guest_memfd will first unma=
p a PFN in shared
> > > > > > page tables and then check for any extra refcount held for the =
shared PFN before
> > > > > > converting it to private.
> > > > >
> > > > > I have an idea.
> > > > >
> > > > > If I understand correctly, the KVM_GMEM_CONVERT_PRIVATE of in-pla=
ce
> > > > > conversion unmap the PFN in shared page tables while keeping the =
content
> > > > > of the page unchanged, right?
> > > >
> > > > That's correct.
> > > >
> > > > >
> > > > > So KVM_GMEM_CONVERT_PRIVATE can be used to initialize the private=
 memory
> > > > > actually for non-CoCo case actually, that userspace first mmap() =
it and
> > > > > ensure it's shared and writes the initial content to it, after it
> > > > > userspace convert it to private with KVM_GMEM_CONVERT_PRIVATE.
> > > >
> > > > I think you mean pKVM by non-coco VMs that care about private memor=
y.
> > > > Yes, initial memory regions can start as shared which userspace can
> > > > populate and then convert the ranges to private.
> > > >
> > > > >
> > > > > For CoCo case, like TDX, it can hook to KVM_GMEM_CONVERT_PRIVATE =
if it
> > > > > wants the private memory to be initialized with initial content, =
and
> > > > > just do in-place TDH.PAGE.ADD in the hook.
> > > >
> > > > I think this scheme will be cleaner:
> > > > 1) Userspace marks the guest_memfd ranges corresponding to initial
> > > > payload as shared.
> > > > 2) Userspace mmaps and populates the ranges.
> > > > 3) Userspace converts those guest_memfd ranges to private.
> > > > 4) For both SNP and TDX, userspace continues to invoke correspondin=
g
> > > > initial payload preparation operations via existing KVM ioctls e.g.
> > > > KVM_SEV_SNP_LAUNCH_UPDATE/KVM_TDX_INIT_MEM_REGION.
> > > >    - SNP/TDX KVM logic fetches the right pfns for the target gfns
> > > > using the normal paths supported by KVM and passes those pfns direc=
tly
> > > > to the right trusted module to initialize the "encrypted" memory
> > > > contents.
> > > >        - Avoiding any GUP or memcpy from source addresses.
> > > One caveat:
> > >
> > > when TDX populates the mirror root, kvm_gmem_get_pfn() is invoked.
> > > Then kvm_gmem_prepare_folio() is further invoked to zero the folio.
> >
> > Given that confidential VMs have their own way of initializing private
> > memory, I think zeroing makes sense for only shared memory ranges.
> > i.e. something like below:
> > 1) Don't zero at allocation time.
> > 2) If faulting in a shared page and its not uptodate, then zero the
> > page and set the page as uptodate.
> > 3) Clear uptodate flag on private to shared conversion.
> > 4) For faults on private ranges, don't zero the memory.
> >
> > There might be some other considerations here e.g. pKVM needs
> > non-destructive conversion operation, which might need a way to enable
> > zeroing at allocation time only.
> >
> > On a TDX specific note, IIUC, KVM TDX logic doesn't need to clear
> > pages on future platforms [1].
> Yes, TDX does not need to clear pages on private page allocation.
> But current kvm_gmem_prepare_folio() clears private pages in the common p=
ath
> for both TDX and SEV-SNP.
>
> I just wanted to point out that it's a kind of obstacle that need to be r=
emoved
> to implement the proposed approach.
>

Proposed approach will work with 4K pages without any additional
changes. For huge pages it's easy to prototype this approach by just
disabling zeroing logic in guest mem on faulting and instead always
doing zeroing on allocation.

I would be curious to understand if we need zeroing on conversion for
Confidential VMs. If not, then the simple rule of zeroing on
allocation only will work for all usecases.

