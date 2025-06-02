Return-Path: <kvm+bounces-48161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A45ACAC4E
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C1FB7A7C0E
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA541F8751;
	Mon,  2 Jun 2025 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOTOxTsL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969A2D7BF
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748859099; cv=none; b=Ok9DPjjEZDrfxJHa6NNuasDtDMwz1NORH8H9DtUi51qxt1DVlm/0iMAitTIBAjtQPlDE9/A42yE1J2ZUcUovoF3l1kl4K4WTRqxvD6TPZEVsk/k0g96nDpPW6hpLylXoKYtp8XUH8wiVGlIWlsFCFmNOEbrt3gYCHVnIt96UhsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748859099; c=relaxed/simple;
	bh=zdvVq0aMSK5d0BnKt2W/ADHf8bxDhoqsW+0UrPH1piw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GVu7hhgRYQwPjjl45qWkecYOoj7i8oRxPfK6nBQwiyRoplzUGWwIZ5xLZ07iITCXFPps02q4KhDabNpMMWi2BrKn2V6l3B4gCxGZVu55NNqZoN9P8ngRKuH20YhEOEFOnGngV29bB01PC34uy645+cMYNq5WoGqfhPNXTKJLAmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOTOxTsL; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4a58197794eso333441cf.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 03:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748859096; x=1749463896; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aEMJl8VP8eSua4t/ZJoJ6QaKy8c9YP11jQlZ2pAxubw=;
        b=GOTOxTsL23qVYaLT7SDXwI+KE9rOjgxtYoj8ReN4+h25nCzXlR5DMBS55mF8b73H65
         BAcy+j7dey2uFIAnKdVRyZinuOalCYuWRtXtwt+q7HmA6A81kMWjVlUqtaYzQXAoFbyD
         An9FaVvmw/zyAHx53PpwiqMUDeLKizWw7zze+WBaRhWjc8kSB7pDteQV2HmDoMg4SMgR
         rBejYJ2HhluBwpGP2KGMh0bp5paVhfY6g/Gc0ydb741SNQBXIz7xs4lq8pkh8qi6U5rr
         47LNXhUesWxFV+qLjZ+Mw7O78gQewRmWM0o1VActmVoyqN6SYsO1lGyCgUm6QE+OhIo6
         EAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748859096; x=1749463896;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aEMJl8VP8eSua4t/ZJoJ6QaKy8c9YP11jQlZ2pAxubw=;
        b=LLUktRDG/DX2Pq8mwOvT+VJ0cSyTKX2HDwzD+AFqtFWxUGTsgQ10ofaR0PAlNwvEyh
         7PIbB/5rpVYcpJVJlK2JOq9E/JgCbV5W9hsB+ueACQabzCqdo3hi9PsyDp9Lrb2AFHQt
         rkke81PNpHVuzZpzOdyHzpy8aGhQ5JOKrc2vUE0bnaRgzi1Um3pn9OjxsJZ9EGYanWM1
         jkFo3zw2Sjoi9MJnfTpAOw96iZkkgTMOMXDNJOnrsn5hCNielR0jQTyUjfQ/Jp96OsKe
         am3PDbl6ZndR9D6a/HTJ1jIjuT1UMQswSdh/IV6wZNSPCiFo9hKN+GSzR8/BQtToCDr4
         HX/Q==
X-Gm-Message-State: AOJu0YyWv9kD0KQpS+p8u7E3pa+qH2sxzs4FC71hF7CKun+KZ8UuNnB/
	X/gEWIjl6G9LDb0Dz6/MNH2yibwGU1ZRPNAmmi1utCusfQJ4UuwaVSOqytFUjuesSvVFj5df1rg
	ZZDhlCDpIBXGLRuxRudR/jo1npzt9nOJb0SFmuQ4D
X-Gm-Gg: ASbGncux9HX+0UsQ4lTweyeRBTtyNiTFjzeHPKWH3vqETkuJBn4FhwvZPCaimL5r3RL
	7ht2QgbJu84TiZdyu6SFitmrbnYMsLUFYGPFKE49XX4ay46K5wdqKC2f+PybdBXV/jHYb8eRm1y
	+j8CLabPPLEFoxykTyjlwCm/7pYXdJ6zwm/hyMa/jHnAM=
X-Google-Smtp-Source: AGHT+IGyZ8TYf2gCqbOaJDuJwc/O9EQLav/L5nwyBub3SzdxM20y8bC/tbZw3UHBX5ZtnAKdi9jl4ilRG9VgGsxXyzQ=
X-Received: by 2002:a05:622a:1f0e:b0:47e:a6ff:a215 with SMTP id
 d75a77b69052e-4a44e01f677mr6657231cf.0.1748859095642; Mon, 02 Jun 2025
 03:11:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-8-tabba@google.com>
 <a78fcd95-b960-4cf2-aa66-37f01e8d57ae@amd.com>
In-Reply-To: <a78fcd95-b960-4cf2-aa66-37f01e8d57ae@amd.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Jun 2025 11:10:58 +0100
X-Gm-Features: AX0GCFsAz9baqVDDaagY-dVtivpJkBd9gnOBR10o4G1KuVwZ_ot-AmGx08LfEAM
Message-ID: <CA+EHjTy2yQrdgsGo6pJ7CUWA5HZH8C0G4HCe3+nQM6O-+yDUSw@mail.gmail.com>
Subject: Re: [PATCH v10 07/16] KVM: Fix comment that refers to kvm uapi header path
To: Shivank Garg <shivankg@amd.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Sat, 31 May 2025 at 20:20, Shivank Garg <shivankg@amd.com> wrote:
>
>
>
> On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> > The comment that refers to the path where the user-visible memslot flags
> > are refers to an outdated path and has a typo. Make it refer to the
> > correct path.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ae70e4e19700..80371475818f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -52,7 +52,7 @@
> >  /*
> >   * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
> >   * used in kvm, other bits are visible for userspace which are defined in
> > - * include/linux/kvm_h.
> > + * include/uapi/linux/kvm.h.
>
> Reviewed-by: Shivank Garg <shivankg@amd.com>

Thanks for the reviews!
/fuad

> >   */
> >  #define KVM_MEMSLOT_INVALID  (1UL << 16)
> >
>
>

