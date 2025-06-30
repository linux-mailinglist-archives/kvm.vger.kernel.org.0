Return-Path: <kvm+bounces-51115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEFEAEE997
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 23:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5127317FC6B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 21:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E4223E340;
	Mon, 30 Jun 2025 21:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyBJpy54"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AD01F2BB8
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751320064; cv=none; b=F38b4zOU4Et9dybS8rZCaLaqvbCLa7vSsJt9YAexmJ92WsSqdY5lTz9YBvaMZ3A5lNjQJ3f3B4vMGvwiUJHpg8APaCvbcKNSovM6xetFmgxpRenZaxZmvlBRHXf+63pVjB/Fw9LXV8RM4dzQimT3Chf6QN32wHk2SHkB0Xu0FgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751320064; c=relaxed/simple;
	bh=njp18cMH7lr4zfBcTGbAllVh9FmkFpTqoiFl+vPks8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l/dF7s7AZDs9Iz7yl1wjbTmJZXEAMF9kKMiQUH+/LYYsij/6NTUX6lgLvrYGbdCeYMv63+dNPPB04grAaBOEHIZBTIJD2nrG+oVqd+X/FQ2xgoPuRkQRxEt4mMu1EW/OqQ1LTPISrJAdmDZhEbLj8nqSv9HKPj4GJvVzPgr/lsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyBJpy54; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-237f18108d2so64335ad.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 14:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751320062; x=1751924862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njp18cMH7lr4zfBcTGbAllVh9FmkFpTqoiFl+vPks8o=;
        b=CyBJpy54HrdgrAdmcXj5TbVqL39fJny9fkO7ZYzz6okcCPm/kBoMEPsZsDYys8qI2y
         xx4bt+UBpiBVXTNJcOvCEnEda82tLn1YneBuphHKl0gqukL2YYLqjIiXOjvCxfaDBaTv
         XWvygiI4PNW6a++Si2CS0zJlX3UrdKyZdHYLISq/P9utqfPqtcbC1BOrhIbwPA1KSndf
         I4CxaCfFgfAhzOoe7ato6PRx/Q0KKj5fpYbB5xJkCIPG6frDtywvJR/joQvvZm/nkh2S
         94CkHZDc4Qi/pbzoiioolaPX2OvCHs4Ul8whv+yRwg/s3pultrkezNs3qZpT6DHPmvJ1
         5pGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751320062; x=1751924862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njp18cMH7lr4zfBcTGbAllVh9FmkFpTqoiFl+vPks8o=;
        b=mF7SQog+6ppi1xOB16H2xH9fyuUJrUtR2PjhKkdjUOQJb7plr0aPjY64MxVding/WU
         ISMAuUlPh7kaqwICD89WRBaruxCDB4U9g/Iqa3tspcwggLnCmJrwH7F6VymnR/N/syR5
         0c0cAxTyfrfRFlYM9Wln3WVlNjhS6Te6lquhypBIkuopR3+pj8jj2xXXq6sC6mIlp8TP
         wT+VkaFot2YEQpmR2L6gO4rwx+sKuRVwwjKdiwSlXttdqWOeEnUzNg/YYeqT4MG+hKDe
         KNIKQKIP44jmPPAJMYcD/AJAG63bEO4R0c91oEHOPgbx1CuKYJEBiNPhF+kd09l5SS5M
         AaVg==
X-Forwarded-Encrypted: i=1; AJvYcCWaA8lnMIRQARrv+zSk+nlOLw8971CMjJP2Au8kQVRVV45a2DTSLrcD+AU7ErnJdRkN/QM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6auNiOGddzfqH4xZDaIlw8gmedDzQcLPkfCojILO0z7XTFoSh
	TfBvcDZdJ0HVnBzKJw+jrxC1f6x4MbJjT5aPCPZ7yR/Wr5quSvC6YsWJqTkq8+2QQwgv4XghSBD
	69jMsolM7JVoUt3jmqVUG3Ouknp6CHJiOcDeL1KLw
X-Gm-Gg: ASbGncuDJ/M1jVBOnrwimsB36Gews7KbkSQjERYHYmeT1tG/MKUj+JOKoGhwn0z9Lr1
	n8Beo8/vmE80WCK+e3ydZT9d6uU1L/qhzMzLpvfFn8zZ6g6srghIvI0LHqjvc4uwF5jHFciYh4v
	35GZKHOotr+dyfJYHhOO6bHlcQtaiaitzMc52lpL6TdktioVafDRRfMi9SOd4c263AKSaWXyIZs
	Q==
X-Google-Smtp-Source: AGHT+IHsWoC5sk+fyO84erG9pnGz0dVeBMB05RRyjItIsROjgVEDZADKjWslFCfn2O3PbQtz0KUZqLi2S0IiIcE95ac=
X-Received: by 2002:a17:902:f547:b0:237:edb8:21c0 with SMTP id
 d9443c01a7336-23c5f5c9902mr247665ad.11.1751320061442; Mon, 30 Jun 2025
 14:47:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
In-Reply-To: <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 30 Jun 2025 14:47:27 -0700
X-Gm-Features: Ac12FXzpGhie6P7qqJellgAG_ykX6J8coKdCCg1rWv1bbXPxNkzaSLSQsh0c13s
Message-ID: <CAGtprH9DNVBTMZJuDQEHYBRJqUfWQJgv-2cveXqdE=TSAvp0fA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 10:55=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Mon, 2025-06-30 at 19:13 +0800, Yan Zhao wrote:
> > > > ok! Lets go f/g. Unless Yan objects.
> > I'm ok with f/g. But I have two implementation specific questions:
> >
> > 1. How to set the HWPoison bit in TDX?
> > 2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT pag=
es) ?
>
> Argh, I guess we can keep the existing ref count based approach for the o=
ther
> types of TDX owned pages?
>
> >
> > TDX can't invoke memory_failure() on error of removing guest private pa=
ges or
> > S-EPT pages, because holding write mmu_lock is regarded as in atomic co=
ntext.
> > As there's a mutex in memory_failure(),
> > "BUG: sleeping function called from invalid context at kernel/locking/m=
utex.c"
> > will be printed.
> >
> > If TDX invokes memory_failure_queue() instead, looks guest_memfd can in=
voke
> > memory_failure_queue_kick() to ensure HWPoison bit is set timely.
> > But which component could invoke memory_failure_queue_kick() for S-EPT =
pages?
> > KVM?
>
> Hmm, it only has queue of 10 pages per-cpu. If something goes wrong in th=
e TDX
> module, I could see exceeding this during a zap operation. At which point=
, how
> much have we really handled it?
>
>
> But, at the risk of derailing the solution when we are close, some reflec=
tion
> has made me question whether this is all misprioritized. We are trying to=
 handle
> a case where a TDX module bug may return an error when we try to release =
gmem
> pages. For that, this solution is feeling way too complex.
>
> If there is a TDX module bug, a simpler way to handle it would be to fix =
the
> bug. In the meantime the kernel can take simpler, more drastic efforts to
> reclaim the memory and ensure system stability.
>
> In the host kexec patches we need to handle a kexec while the TDX module =
is
> running. The solution is to simply wbinvd on each pCPU that might have en=
tered
> the TDX module. After that, barring no new SEAMCALLs that could dirty
> memory, the pages are free to use by the next kernel. (at least on system=
s
> without the partial write errata)
>
> So for this we can do something similar. Have the arch/x86 side of TDX gr=
ow a
> new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs =
after
> that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the s=
ystem
> die. Zap/cleanup paths return success in the buggy shutdown case.

This approach makes sense to me.

>
> Does it fit? Or, can you guys argue that the failures here are actually n=
on-
> special cases that are worth more complex recovery? I remember we talked =
about
> IOMMU patterns that are similar, but it seems like the remaining cases un=
der
> discussion are about TDX bugs.
>

