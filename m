Return-Path: <kvm+bounces-7953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FDD848FA4
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 18:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99EFD1C215EA
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 17:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49E224A03;
	Sun,  4 Feb 2024 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxnHVoaR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4155E241E5
	for <kvm@vger.kernel.org>; Sun,  4 Feb 2024 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707067285; cv=none; b=EhVjAFNl7xjbXiFiSI24ko+e+DPVszvjeDNwlAg21b7Z4iAxOGQ5T+X3De2lbBZtfAa371t0NVi2nRWg59EZxxLwMRIza6TTqDN/9m+4BtziqlBujhe0kliSHrkuBl6rLw2QTo/sQJ20S7/JPCV38ud6ME86WkGAvdZT/FZYhsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707067285; c=relaxed/simple;
	bh=QdyWE/+4R+pp9b6gUvuomY37p6mJ6ibdykiKC47jIMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ARlk6K9Ji75CngngbQSAXnRIaRl8qfRyNLb5WYFDt22WvIUMPcxPlZiKdAF2VoPHWMb1KxDBm9ogqqK1Tys+x7a4B9XN12wrFcSoynwZCN7XwgzZKB9G1Rm0RS/cMzB12SwvU83vKQhkAMzrpcab5ztp1X34FLZGeBTNEk/EDSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxnHVoaR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707067281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLuigqxpjpbSlXGKelVFxUNqaWxVoHJdGn0HSN9dgIE=;
	b=DxnHVoaRjjPU4KdA5OkL6J6wsdw9jcYjcp703eynVAj6zgyvY2wMLrZExrbRCH3ryMy/LS
	5lc/shaagarYP1J0jshbg56lLswWjtjZQopUouIRo1RRhECrRJGIcmapadgAIO+BU4Av/0
	Um7jBfiXJDx25fhKvSbFzKWNuhb9skE=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-KoU08FRQP7WY1d2Q1dVy9g-1; Sun, 04 Feb 2024 12:21:20 -0500
X-MC-Unique: KoU08FRQP7WY1d2Q1dVy9g-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7d611256c4fso1887651241.2
        for <kvm@vger.kernel.org>; Sun, 04 Feb 2024 09:21:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707067280; x=1707672080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLuigqxpjpbSlXGKelVFxUNqaWxVoHJdGn0HSN9dgIE=;
        b=a1V9LIvgbe9VSEgdRiFzYIp9xf6q8iv45jcLB3c8CUd8OrgObq0TsaTKg9uNpDH2mN
         EQW6K4hZSruggVrwpYfH50Gk1ftQ3TGncX82P5zrd1DWo427/T/Gunj1d35gXmamA8wR
         d9KeaCc766pU9F/iHsdFNs5l6TZEHm9qBDRyBVb3z5pQYaD0DgJGm9eG77LZTgy+wMoO
         lmbN1VNW2CXfPD3Rm7iNlFxj7NwlYwdWgaFFrQ7pBmyhKfsOQBEqqPOyklyGiF9DDLAE
         3LfHuyLklpu5upj/DMvliJU9F0XUIgwWRZSbp0jb9g912bknZ1+eg1W+FX+sn5F+5hbA
         5oDg==
X-Gm-Message-State: AOJu0YwfKAK4ebinj8cqS+SJgOGljgtOvj8Qrbo1FOagz+zKWWoCfj0o
	0EqsG0fQAJpBjXXmtek01mcF23+i0W85VBf1PS4ofUQKuBxdEqGlY00UQoB4iAi7bGWElBDy1lK
	D8rWN+i6eLIPYI5/bMIQVfav9yQ4afZVIBQJdYY6JNqCCmzw38TTxPSEcSX6ky023fP9zYXJnfg
	24ankNdmBHyXVaZ8Sdtk2Rzd5E
X-Received: by 2002:a05:6102:3e1f:b0:46c:f805:eb7e with SMTP id j31-20020a0561023e1f00b0046cf805eb7emr11084299vsv.28.1707067280031;
        Sun, 04 Feb 2024 09:21:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAs2KyQXIPnKUwTCrpj1r1SPLjjEChNRmvmED/CgO+sue7ZkpZWrb/adNLNUNmDyEOk1SEe7VEnvAmY/7QWtY=
X-Received: by 2002:a05:6102:3e1f:b0:46c:f805:eb7e with SMTP id
 j31-20020a0561023e1f00b0046cf805eb7emr11084278vsv.28.1707067279752; Sun, 04
 Feb 2024 09:21:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131230902.1867092-1-pbonzini@redhat.com> <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
In-Reply-To: <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 4 Feb 2024 18:21:07 +0100
Message-ID: <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 2, 2024 at 12:08=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Thu, Feb 1, 2024 at 7:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.com=
> wrote:
> > I really wanted get_cpu_address_sizes() to be the one and only spot
> > where c->x86_phys_bits is established.  That way, we don't get a bunch
> > of code all of the place tweaking it and fighting for who "wins".
> > We're not there yet, but the approach in this patch moves it back in th=
e
> > wrong direction because it permits the random tweaking of c->x86_phys_b=
its.
>
> I see your point; one of my earlier attempts added a
> ->c_detect_mem_encrypt() callback that basically amounted to either
> amd_detect_mem_encrypt() or detect_tme(). I bailed out of it mostly
> because these functions do more than adjusting phys_bits, and it
> seemed arbitrary to call them from get_cpu_address_sizes(). The two
> approaches share the idea of centralizing the computation of
> x86_phys_bits in get_cpu_address_sizes().
>
> There is unfortunately an important hurdle for your patch, in that
> currently the BSP and AP flows are completely different. For the BSP
> the flow is ->c_early_init(), then get_cpu_address_sizes(), then again
> ->c_early_init() called by ->c_init(), then ->c_init(). For APs it is
> get_cpu_address_sizes(), then ->c_early_init() called by ->c_init(),
> then the rest of ->c_init(). And let's not even look at
> ->c_identify().
>
> This difference is bad for your patch, because get_cpu_address_sizes()
> is called too early to see enc_phys_bits on APs. But it was also
> something that fbf6449f84bf didn't take into account, because it left
> behind the tentative initialization of x86_*_bits in identify_cpu(),
> while removing it from early_identify_cpu().  And
>
> TBH my first reaction after Kirill pointed me to fbf6449f84bf was to
> revert it. It's not like the code before was much less of a dumpster
> fire, but that commit made the BSP vs. AP mess even worse. But it
> fixed a real-world bug and it did remove most of the "first set then
> adjust" logic, at least for the BSP, so a revert wasn't on the table
> and patch 1 was what came out of it.
>
> I know that in general in Linux we prefer to fix things for good.
> Dancing one step behind and two ahead comes with the the risk that you
> only do the step behind. But in the end something like this patch 1
> would have to be posted for stable branches (and Greg doesn't like
> one-off patches), and I am not even sure it's a step behind because it
> removes _some_ of the BSP vs. AP differences introduced by
> fbf6449f84bf.
>
> In a nutshell: I don't dislike the idea behind your patch, but the
> code is just not ready for it.

This is the diffstat before your patch can be applied more or less as is:

$ git diffstat origin/master
 arch/x86/include/asm/processor.h |   1 +
 arch/x86/kernel/cpu/amd.c        |  12 ++--
 arch/x86/kernel/cpu/centaur.c    |  13 ++---
 arch/x86/kernel/cpu/common.c     | 103 +++++++++++++++++++----------------
 arch/x86/kernel/cpu/hygon.c      |   2 -
 arch/x86/kernel/cpu/intel.c      |   4 +-
 arch/x86/kernel/cpu/transmeta.c  |   2 -
 arch/x86/kernel/cpu/zhaoxin.c    |   1 -
 8 files changed, 69 insertions(+), 69 deletions(-)

$ git log --oneline --reverse origin/master..
d639afed02aa x86/cpu/common: move code up to early
get_cpu_address_sizes() to a new function
40d34260a4ba x86/cpu/common: pull get_cpu_*() calls common to BSPs and
APs to a new function
67b9839f9c38 x86/cpu/common: put all setup_force/clear capabilities togethe=
r
ebeae7f91cbc x86/cpu/centaur: do everything before
early_init_centaur() in early_init_centaur()
d62fa7400885 x86/cpu/cyrix: call early init function from init function
0aa0916cd7e0 x86/cpu/common: call early_init function on APs from common co=
de
d656b651d217 (HEAD) dave


I still haven't tested very well, but anyway, what do you think?

Paolo


