Return-Path: <kvm+bounces-51193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CA6AEFBA5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 764471C05C1A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA03275AFC;
	Tue,  1 Jul 2025 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQgA6uEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81522275AF5
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751378589; cv=none; b=hSkuTueqQfzd+qviK6r+CK7d4gvsBkqrQmiHWS9mOh/imYOjCuSXFLP7Mh0Zt5946Z7LxNTDeQcYlZ9hiesV9quYCCL8bQ9Ilp9UXp4PGcclXi+Ocn/zBNIbi6LQoqyPCLcaTu+4L1jFYk6VoPfyLlPSuKD8FHjOjZFSOxN5/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751378589; c=relaxed/simple;
	bh=5WYg2d/Rob7yBYCn1RGW5LTwmcKdVGpURzqVWpoSMMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mkJWWzWOuMJQKEK1VurXVSuhw6hTwQfosvgLmqjH642bK1ONM1wk35Xo5bSPd4ZSiGrFEXV63cmRaAyf5kZODhPxnv63bTPuUdTlJ7S3CGsdmt/o1oWrixsCGIYC8JdSjz/OJlvNbO4XST51RDpbvjRSjqqwc4IOb9cL5vDKHI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQgA6uEU; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-237f270513bso153745ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 07:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751378587; x=1751983387; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WYg2d/Rob7yBYCn1RGW5LTwmcKdVGpURzqVWpoSMMQ=;
        b=kQgA6uEUaQHnEj38Xcxrf523AT1P769SHpdPF1Qjup3vWY+dqGyUC9OREnvpsyu7T5
         qxpPo/GyUdV0j8NwsMz5OPSoF0GzGfOWP50yKSomFmipHf+TBLiL827SbII2uleVZt69
         G9ydtCjZ0MYdmg50NudMHzoaXhjqrBMtJPXP+UtNvch1Undsef0bdaEVwwjVE3o+abw/
         BJDux/ZsvtBFWvzEP4yFFudKXripFBqWqDPwFTTViUg6uFb9BL3HisTtrY7jZ4Ti7rIv
         6mHa22f/4Z523M00MrbK4qPLegG4dpuxDC3Rp9xpu39T6QgLDienA/Y/uhcPHmofKpun
         eCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751378587; x=1751983387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5WYg2d/Rob7yBYCn1RGW5LTwmcKdVGpURzqVWpoSMMQ=;
        b=dK2TYOhSi4heSQyLki4KDyoNqi3tbJNbhtXq1ThfU195/u7btDc+zIYgSb+B+SNLss
         hrnWRxZUTIWOmqo1msbmZkfVJqTFwh4EorR8/9ORktANFuqsZK2JdyzJqsk0YKbXQK2T
         S91HNuJ65Hc/zMpYTAXS/tx3Vfrf7fMQ4m6oac3UAOC93T8fk+0M8OPO3/HS3a4dptsW
         4v8dvvtCcvctW9dQREzOLSYJt++H6GZM/qKRHp9Fiq9DviHDlZi5iw+jwsWLvkSjdOAQ
         NMJW7BgOJROtAQ8ZgbvwKKwoT4P/488fVr6/QpCCeE27QbXyxZkdNDVYHWJFPccfbjjJ
         O3iw==
X-Forwarded-Encrypted: i=1; AJvYcCUy924vVaVt1zPl1lPjE2Ui78ZPM5I9fr28EsgqS+Y+CVx7O2pUkf3xuRjOVRSm6ABvqXk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx89Ezk+hzG+cwa+c7s7f8SmiWhA4FD0ycjBe+03+aUTmFSo+Mp
	3e2iCLNDlodrTS7doqsNr3ne14nwW8RQXBaXFkPInxtiHcWc94wSCX9/raF8ZbQXabarqX/j4Sc
	2qT3cJtin5kQcVnc+Mj/8atG2+eS+16ityUEMduZC1HsG1YuzlMh4G7biO9Q=
X-Gm-Gg: ASbGncvqb0qT/WX9Vrg9t8jBdrB/UT3/uCaeF5jcRqHBDHF9lsKHderckKYt+Mqe1ku
	VaPVj5UWpu3CffmNCkiF+sWGYrm8SBVK1qU340prj7rhbS1bUyOIK0u1lt+DSFgNBR/CL950NW2
	4yXvp2AQFVXD4F67M9sdXK7izG6nUawlsruW4Ikhvafjsp3uC6vmZYwsuxd5trmmdJtg2G4vZmV
	Bjn
X-Google-Smtp-Source: AGHT+IH77wLMkIJG2GhwBQq6SijmzRz8oWkXPewQMD4twhGCGw0STRER4GN8G5BudlzOjktWBK9HI5JZrEqv4LxVUr8=
X-Received: by 2002:a17:903:1207:b0:237:e45b:4f45 with SMTP id
 d9443c01a7336-23c5fedc406mr2334445ad.1.1751378586208; Tue, 01 Jul 2025
 07:03:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com> <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
In-Reply-To: <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 1 Jul 2025 07:02:52 -0700
X-Gm-Features: Ac12FXzMpiCi2jcBFPGTVhv3KCVhzRRQZPEPOJXk0dx6V9jeUU3nUxROty-k2Dk
Message-ID: <CAGtprH92EddcAi6YgfT+Z0LjduRm7=sG-xWwdSudUCt18i=VSw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 6:32=E2=80=AFAM Vishal Annapurve <vannapurve@google.=
com> wrote:
>
> On Tue, Jul 1, 2025 at 2:38=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
> >
> > On Tue, Jul 01, 2025 at 01:55:43AM +0800, Edgecombe, Rick P wrote:
> > > So for this we can do something similar. Have the arch/x86 side of TD=
X grow a
> > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out =
of
> > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCA=
LLs after
> > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in t=
he system
> > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > All TDs in the system die could be too severe for unmap errors due to K=
VM bugs.
>
> At this point, I don't see a way to quantify how bad a KVM bug can get
> unless you have explicit ideas about the severity. We should work on
> minimizing KVM side bugs too and assuming it would be a rare
> occurrence I think it's ok to take this intrusive measure.
>
> >
> > > Does it fit? Or, can you guys argue that the failures here are actual=
ly non-
> > > special cases that are worth more complex recovery? I remember we tal=
ked about
> > > IOMMU patterns that are similar, but it seems like the remaining case=
s under
> > > discussion are about TDX bugs.
> > I didn't mention TDX connect previously to avoid introducing unnecessar=
y
> > complexity.
> >
> > For TDX connect, S-EPT is used for private mappings in IOMMU. Unmap cou=
ld
> > therefore fail due to pages being pinned for DMA.
>
> We are discussing this scenario already[1], where the host will not
> pin the pages used by secure DMA for the same reasons why we can't
> have KVM pin the guest_memfd pages mapped in SEPT. Is there some other
> kind of pinning you are referring to?
>
> If there is an ordering in which pages should be unmapped e.g. first
> in secure IOMMU and then KVM SEPT, then we can ensure the right
> ordering between invalidation callbacks from guest_memfd.
>
> [1] https://lore.kernel.org/lkml/CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5=
HzPf0HV2=3Dpg@mail.gmail.com/#t
>
> >
> > So, my thinking was that if that happens, KVM could set a special flag =
to folios
> > pinned for private DMA.
> >
> > Then guest_memfd could check the special flag before allowing private-t=
o-shared
> > conversion, or punch hole.
> > guest_memfd could check this special flag and choose to poison or leak =
the
> > folio.
> >
> > Otherwise, if we choose tdx_buggy_shutdown() to "do an all-cpu IPI to k=
ick CPUs
> > out of SEAMMODE, wbivnd, and set a "no more seamcalls" bool", DMAs may =
still
> > have access to the private pages mapped in S-EPT.
>
> guest_memfd will have to ensure that pages are unmapped from secure
> IOMMU pagetables before allowing them to be used by the host.
>
> If secure IOMMU pagetables unmapping fails, I would assume it fails in
> the similar category of rare "KVM/TDX module/IOMMUFD" bug and I think
> it makes sense to do the same tdx_buggy_shutdown() with such failures
> as well.

In addition we will need a way to fail all further Secure IOMMU table
walks or some way to stop the active secure DMA by unbinding all the
TDIs. Maybe such scenarios warrant a BUG_ON() if recovery is not
possible as possibly any or all of the KVM/IOMMUFD/TDX module can't be
trusted for reliable functionality anymore.

