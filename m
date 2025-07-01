Return-Path: <kvm+bounces-51229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA52AF0657
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34A91C049EA
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298C8306DC6;
	Tue,  1 Jul 2025 22:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vDMwRX4G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929F1302058
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 22:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407745; cv=none; b=ilvZZBhrCkPLCG2s5VL4tfcCSUZ1jMKJjOvmAw0VtiLd3qcbLZL028F3+9z76OLtsGwBxhLTaWmcO4tS1uv4KpfgEJKgRKij7IG8uOPomZQN0RDw3qUJ2G/fX+qNxRETYkqkQp5bQ5+Yurxuw9drP3drQfoBNNT3XwAzSZomn2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407745; c=relaxed/simple;
	bh=6EqsWkpkeYfydp6o8pmzcX4O+MzJ5OGrnXS/xdaYoGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fVQtwgPXDcKTo5M/28tT8fzrlcIfWIf7IWFSsDiij74J+8iyQ23YBjRLfyraEsnbZaucol2Pp/6Y3WojLXf84bQR3FIc89YZUu0T81kEOuALH5KvMxlwIRwe+LjZcaiw1amYBFiXtNGy7b8DaDp9nicxFNg+L1HOGo0+Bfv7Mg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vDMwRX4G; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748a4f5e735so3797591b3a.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 15:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751407743; x=1752012543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrLKmv2Vy7uxFt0iwPk+GWdFZVpcjh098B891Lvn1Lc=;
        b=vDMwRX4G2p4tR7V1F/DQO/GL9SEcwB3IbAPIsA4G3I/0cWb+Srtkv8dqscUon075lm
         SKGbI8FYGk85zdW3oymPLn8BOjJpLMHmKtDwqkc0jdkSUFVi84GO3yBdDpkDLJbTRUcK
         hfQV+uLh8aniyU615Dd5D9HmqbcvWEEULFbr3pbgOpfquVjtnTmRKN5S8xfUv3TF9YYp
         s5OdScC1VdFENX9tltb++g7dnD5QfNgdacLYR8w50n/GfHxbQxdMdVGTBp7OtmDjsI3i
         QNoG8Qd/cwajvhbMYrqXFimPS71jqfo2FA2YbTGjYU2hzowwWqc3lH1OFPLulDyy1pI5
         gywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751407743; x=1752012543;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yrLKmv2Vy7uxFt0iwPk+GWdFZVpcjh098B891Lvn1Lc=;
        b=wq2tNInPeb7i3B0D7tMrxse7J0whnQLJs+NaTybOCLEqjbeXzAGmgBTUM8bO5KHGA1
         RIqIEL8Cimff5QT2rluieW0yrRRpNM0MYhmsR/uyaQogc909rwseby9qshmyGvaifkfe
         vfLPuuupAU7pi5yflRg3l4ESHfV6riu/7jbR2GlmUY3cuLnyz2YFGao1Hp+jgp03c0gi
         /7Te2G3aOzrMOAQnH6Bc04k6L3+pF0vxtMveGLCTg9MbRnKOedmIgrx8+V5eRi2UcBMQ
         CpDrlKDU2043OG2NDFbRI7apnVqudypwEpstgy68KzFvZegzLvrv4KLSXo26IED5k3dx
         iEdA==
X-Forwarded-Encrypted: i=1; AJvYcCVKNaiRXS9OMmmNzgPkTaZ1v5BHGfJbmLdbBceaRA7YN5E09oxl3Zx5z02zYQD77uJLnmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJoyMiVoj6nRKHKTieNUcG2v5VdCz3VQ6nnnlrG061af/2azM3
	9Hq4yjmkUm5+DOe1J/F9HThQ4f+lvut6rRtSnvo8sfSVnV+9VH8khLUkL51kJ9e/akJCPyXm+/8
	7kw4xUKicChMqg0ZMu45e/lZk5w==
X-Google-Smtp-Source: AGHT+IEe+r8Ltcv+81mNHFMOPEijls9stGq5miDhJ0WBatB0rMdu1zOeKhl/PXPmMqvALg7A2CkCRNJxJK/Vn6Jeag==
X-Received: from pfbbw26.prod.google.com ([2002:a05:6a00:409a:b0:748:2476:b25f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:23c3:b0:742:a91d:b2f6 with SMTP id d2e1a72fcca58-74b50f2a035mr633828b3a.13.1751407742749;
 Tue, 01 Jul 2025 15:09:02 -0700 (PDT)
Date: Tue, 01 Jul 2025 15:09:01 -0700
In-Reply-To: <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com> <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
 <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
Message-ID: <diqzms9n4l8i.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, Jun 30, 2025 at 10:22:26PM -0700, Vishal Annapurve wrote:
>> On Mon, Jun 30, 2025 at 10:04=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
>> >
>> > On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
>> > > On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
>> > > > > So for this we can do something similar. Have the arch/x86 side =
of TDX grow
>> > > > > a
>> > > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs=
 out of
>> > > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any S=
EAMCALLs
>> > > > > after
>> > > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs=
 in the
>> > > > > system
>> > > > > die. Zap/cleanup paths return success in the buggy shutdown case=
.
>> > > > >
>> > > >
>> > > > Do you mean that on unmap/split failure:
>> > >
>> > > Maybe Yan can clarify here. I thought the HWpoison scenario was abou=
t TDX module
>> > My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() =
was hit in
>> > TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged=
 on and
>> > about to tear down.
>> >
>> > So, it could be due to KVM or TDX module bugs, which retries can't hel=
p.
>> >
>> > > bugs. Not TDX busy errors, demote failures, etc. If there are "norma=
l" failures,
>> > > like the ones that can be fixed with retries, then I think HWPoison =
is not a
>> > > good option though.
>> > >
>> > > >  there is a way to make 100%
>> > > > sure all memory becomes re-usable by the rest of the host, using
>> > > > tdx_buggy_shutdown(), wbinvd, etc?
>> >
>> > Not sure about this approach. When TDX module is buggy and the page is=
 still
>> > accessible to guest as private pages, even with no-more SEAMCALLs flag=
, is it
>> > safe enough for guest_memfd/hugetlb to re-assign the page to allow sim=
ultaneous
>> > access in shared memory with potential private access from TD or TDX m=
odule?
>>=20
>> If no more seamcalls are allowed and all cpus are made to exit SEAM
>> mode then how can there be potential private access from TD or TDX
>> module?
> Not sure. As Kirill said "TDX module has creative ways to corrupt it"
> https://lore.kernel.org/all/zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7i=
uk2rt@qaaolzwsy6ki/.
>
> Or, could TDX just set a page flag, like what for XEN
>
>         /* XEN */
>         /* Pinned in Xen as a read-only pagetable page. */
>         PG_pinned =3D PG_owner_priv_1,
>
> e.g.
> 	PG_tdx_firmware_access =3D PG_owner_priv_1,
>
> Then, guest_memfd checks this flag on every zap and replace it with PG_hw=
poison
> on behalf of TDX?

I think this question probably arose because of a misunderstanding I
might have caused. I meant to set the HWpoison flag from the kernel, not
from within the TDX module. Please see [1].

In addition, if the TDX module (now referring specifically to the TDX
module and not the kernel) sets page flags, that won't work with
vmemmap-optimized folios. Setting a page flag on a vmemmap-optimized
folio will be setting the flag on a few pages.

[1] https://lore.kernel.org/all/diqzplej4llh.fsf@ackerleytng-ctop.c.googler=
s.com/

