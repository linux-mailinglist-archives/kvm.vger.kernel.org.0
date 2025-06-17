Return-Path: <kvm+bounces-49653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 800D4ADC005
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 05:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679AF3AA0C5
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 03:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F412264A5;
	Tue, 17 Jun 2025 03:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RswjPOxW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6E1E48A
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 03:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750132316; cv=none; b=iwDrMbJOuPdyhMFjoK3R2uxIJtThRrTuFTyp4Eb55q0C9fb/7wFZLEXKdyHelLtEbBLiiCh7mGjV4b49gU0lsjT0i0/Ds7LJhGXSbWT5o+SXmAup4DtxrsUDi79+muLszPrWrs+HWDGkfbiGDgvD/KI62vJXjqCQS/MkHWs9Ulk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750132316; c=relaxed/simple;
	bh=It5Jkl2DhkLk9e4Z14wkJwLNyTY7WsnFJ8NGb+MdGXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e53Usabx9PV2xYz8YUIb6tEdZvQftLY2DaSxvEBCRhMb6FM6cXszSXwxFJQZdygzXFclutqfkbpHS/vOpRp8XU5e8zWEn/e574P36IYVtzCHwx8iYXIyK2J0ffQ4M46EkVuCVPPSFQEsCaEJBkoxPbbamnQ35rDmDpSVEJLsmcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RswjPOxW; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235e389599fso114735ad.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 20:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750132314; x=1750737114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJ3iqzQFJlROLguI4Y4SVFz3OWKkrwlPkiBQnhxgF7c=;
        b=RswjPOxW6VqH4nGHDB6YV66zqNgeCqH2rZv97OVbluy6FrAHuTu+7+5Z+eoJRKZ2BP
         +5rnKT+fe8tMKyShnHWUj8Hr3FNqhnw8hfrB2HhL1faWe/E1dp4VkWmX3EkCwncoCgCP
         0v/Ihc+HrWATrj5vc48vHwYTuq5C7XDT80GWBlHBSSQEawwatyQPAeYZBDr5IMR8oCRC
         NJ/bV7R8XS2Ko+X8NUH8M2bVClCcSnsbygi94thA08/6b3x5alIpopJ/J0JUKraLmWO0
         YBQWwehdSwYiFhUt6lGwST1Qkfs4aYok70APLXzg4PgjUtV3A5HxucwQxoZtRHl16jR4
         hk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750132314; x=1750737114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJ3iqzQFJlROLguI4Y4SVFz3OWKkrwlPkiBQnhxgF7c=;
        b=Sk0yrIiyRrpQdhzLuZxon3vY4feQiU26M1Ep4aJLX4hFa3ukwgAhOCz6zXeVs02DTA
         SX2E5OrRscXpNCOvPW449FLiQItQgYSQZCUiltKkyt+IXV+219zm31zWVC33OGBcX3eB
         Xg52DNc98wPuv7HpuDEo77aMUK1gPmYkV6C5/POkIjwaU1wkh9pcu3iA5qc3sN0aLh92
         EsqRSjvtntYBIBnBTr42FtEW3w/5KqHQOgRue6dHKfx+ZXW8ZjgjTm+zLU5tWfwoGp/p
         u1rOLhBl92WCvSfzlCO8asosYhZFsa58mMSWn4wnk/LouNSR2hjLTfT5dvhekfHWhOWH
         Hrig==
X-Forwarded-Encrypted: i=1; AJvYcCV5N8d/6RX4bccQqI7WXME7VfSck/iIGaOr8BEWArrTbt2QX1X4aGbFU5FttKnMvQYhVg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ5tpeVBF8GhLHFSteOcN21Iu2YC4Zidf40ozGmHrWelnHH4A1
	FeM0Al4xs4RN98jd5DzVFq4SRZHpLX/21ySyN+U9/9aYs7CrsYmBrUnHbKk5TDSSG+akxeAcSyV
	koGyT1xQxn69uNnZ46ShSfQ2TIhe+GHrAoScb5Ttn
X-Gm-Gg: ASbGnct6gshHuXNVXSm7/ueKLIwg99XKwkA2Rl4WRDhz50zOBI7hFQR+mzfLQBJdsS1
	/EweRJnbbLOvMwONFofuU2JcYnw/K+poHaGmT06LS/D0mQ4rGZrGANG36IzSzsiyjv0uaA8Mfng
	S3YJA+Panot9Awi/MkdwHXaDXPkdwg43EchHoMBo6N0A==
X-Google-Smtp-Source: AGHT+IF6I4f5iiQ5fzVQ6StksAGey3pqHY9hgP6QpR2QVCZzkDbuFzrhUQc/6q20pbd2fp1FTi8gG11ObTJAiAbppPY=
X-Received: by 2002:a17:902:f545:b0:234:13ad:7f9f with SMTP id
 d9443c01a7336-2366c814c14mr6424845ad.22.1750132313728; Mon, 16 Jun 2025
 20:51:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
In-Reply-To: <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 16 Jun 2025 20:51:41 -0700
X-Gm-Features: AX0GCFvGoTkM9C7sT81A1eZyHy9h_SBPfr2pduLFizuDQpAMotZ_R-0H2nFKxa0
Message-ID: <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 3:02=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> > On Wed, Jun 4, 2025 at 7:45=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > We need to restore to the previous status (which includes the host pa=
ge table)
> > > if conversion can't be done.
> > > That said, in my view, a better flow would be:
> > >
> > > 1. guest_memfd sends a pre-invalidation request to users (users here =
means the
> > >    consumers in kernel of memory allocated from guest_memfd).
> > >
> > > 2. Users (A, B, ..., X) perform pre-checks to determine if invalidati=
on can
> > >    proceed. For example, in the case of TDX, this might involve memor=
y
> > >    allocation and page splitting.
> > >
> > > 3. Based on the pre-check results, guest_memfd either aborts the inva=
lidation or
> > >    proceeds by sending the actual invalidation request.
> > >
> > > 4. Users (A-X) perform the actual unmap operation, ensuring it cannot=
 fail. For
> > >    TDX, the unmap must succeed unless there are bugs in the KVM or TD=
X module.
> > >    In such cases, TDX can callback guest_memfd to inform the poison-s=
tatus of
> > >    the page or elevate the page reference count.
> >
> > Few questions here:
> > 1) It sounds like the failure to remove entries from SEPT could only
> > be due to bugs in the KVM/TDX module,
> Yes.
>
> > how reliable would it be to
> > continue executing TDX VMs on the host once such bugs are hit?
> The TDX VMs will be killed. However, the private pages are still mapped i=
n the
> SEPT (after the unmapping failure).
> The teardown flow for TDX VM is:
>
> do_exit
>   |->exit_files
>      |->kvm_gmem_release =3D=3D> (1) Unmap guest pages
>      |->release kvmfd
>         |->kvm_destroy_vm  (2) Reclaiming resources
>            |->kvm_arch_pre_destroy_vm  =3D=3D> Release hkid
>            |->kvm_arch_destroy_vm  =3D=3D> Reclaim SEPT page table pages
>
> Without holding page reference after (1) fails, the guest pages may have =
been
> re-assigned by the host OS while they are still still tracked in the TDX =
module.

What happens to the pagetable memory holding the SEPT entry? Is that
also supposed to be leaked?

>
>
> > 2) Is it reliable to continue executing the host kernel and other
> > normal VMs once such bugs are hit?
> If with TDX holding the page ref count, the impact of unmapping failure o=
f guest
> pages is just to leak those pages.
>
> > 3) Can the memory be reclaimed reliably if the VM is marked as dead
> > and cleaned up right away?
> As in the above flow, TDX needs to hold the page reference on unmapping f=
ailure
> until after reclaiming is successful. Well, reclaiming itself is possible=
 to
> fail either.
>
> So, below is my proposal. Showed in the simple POC code based on
> https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-convers=
ions-hugetlb-2mept-v2.
>
> Patch 1: TDX increases page ref count on unmap failure.

This will not work as Ackerley pointed out earlier [1], it will be
impossible to differentiate between transient refcounts on private
pages and extra refcounts of private memory due to TDX unmap failure.

[1] https://lore.kernel.org/lkml/diqzfrgfp95d.fsf@ackerleytng-ctop.c.google=
rs.com/

> Patch 2: Bail out private-to-shared conversion if splitting fails.
> Patch 3: Make kvm_gmem_zap() return void.
>
> ...
>         /*
>
>
> If the above changes are agreeable, we could consider a more ambitious ap=
proach:
> introducing an interface like:
>
> int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);

I don't see any reason to introduce full tracking of gfn mapping
status in SEPTs just to handle very rare scenarios which KVM/TDX are
taking utmost care to avoid.

That being said, I see value in letting guest_memfd know exact ranges
still being under use by the TDX module due to unmapping failures.
guest_memfd can take the right action instead of relying on refcounts.

Does KVM continue unmapping the full range even after TDX SEPT
management fails to unmap a subrange?

