Return-Path: <kvm+bounces-36937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2324A2325D
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47B941651D0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4E21EE7C6;
	Thu, 30 Jan 2025 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ER7h2Rg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49C21EE01A
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 16:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738256318; cv=none; b=r0yZ55KnVAYnglc3L9aD7//9G/1OwECEXmJWU0v0jP7deLsRa8AK2O3fwqxyYv8Nx3WFTIYFFbkHKz6KmK/1Crwc1PjiSI9vbsuWuwsxkl2X2uYi4sKbuJekJrKsAPxSvegcvyj2WuM50HIZDligPw1sSLR3UsRgZdE2aTeBzCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738256318; c=relaxed/simple;
	bh=d+XERwEorFMtt/canygb3yzxG8nO4ybue2mgukhF8iA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5CuqDLW80GFgxFLIwqU0mNpxD1iybly/4C0fF7hsxPf2smibcFTMBjzbolJh2X2feXDXCDzppMCwBQZ+SNgV9fykiUtggQDLq+GAr6R9sAMK+yUgScy6fxNVYpKzlb0zdPGf6WZHXO5F8j5gwZQXtpD8NFCMjDs5RTiVB6ddVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ER7h2Rg; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4679b5c66d0so252301cf.1
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 08:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738256316; x=1738861116; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OjVSJeaXnqEO6kzNOY1Q8YRm02MOKH0yqrkAcstxsgU=;
        b=3ER7h2RgmEGDgX70pYFVBWSFTW8aJ/segOd49o/TrhK/Isx8hFne3nwqAaT5RpBp5i
         esTPw38VjZbWHu0W2Q424ASsr2ImHAtf96pmPHZz5O903fD7tFebcIAGYzglTaLLMc8F
         gZyDNDbAK5YD0QZxnhToeg8erNJ7hJzQt/Onv9AJEeEdUTdAeMgBQ+cOmrmnT4/b4QUx
         BIR6OGPq1kU/FG8YHkegL/Z953mi1ouOOKSicSxAC1u+CZEtEmLd3HxOosKNWPUutxUd
         vGeA0AjnmDQylPJu5T4F3y0ZHOJgRfMtBT94hUPmTNMaJ3QrwOvgYxMh5LkRUcY+VUhN
         Oe+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738256316; x=1738861116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjVSJeaXnqEO6kzNOY1Q8YRm02MOKH0yqrkAcstxsgU=;
        b=miQ+HR4A3oQWDWz3IVcPw944mPHDrPFTVmdZBicNC4mhNW3ViZze0xIksLEtMoM/lK
         lv8+Ck7+4VuuogPo/bopbGTrXL9gRK4Esc8wjGq9b8dXFfgZ7hiUIeYiD1oApLArlfTn
         2nSJLRuiXQNpC+tEreXNkvGqCf92ieEfkpWBpFL2PfeD2gnXfj62vVWPWnrp8r6Qu4o5
         yLfz9JmZTD46V/G0XNUSKx+UCfdWRxdsLx8xUyGgVC2LDbVzcdjKdsyC05OVrTiKZG2y
         iQg42kW8gfHIPKaxiiwMuCxv8JAK0jaXE2Lmlvp/RdoaeJmAXzToWpZTWVKNhZH6HG4g
         ijtw==
X-Gm-Message-State: AOJu0YxIIVx6KLtHbfXV6SUcjG1h8Y5+QRXKSTbzMlBR4G8v9JoSdFvC
	EsHTiusjOGcJpWi2aiBqN/oiw/izL6CR+YemEEjUrbHZtRAiZ4yBONd1wo0EiSfTI8pJYCmiKYT
	aqknZq0ZEylGIHgXttjXjlmEFTpM/cZoUWB/E
X-Gm-Gg: ASbGncsPmrBecDxeVmj31bmL5kQSwvcxXH9XJxEwtb+NQN7so5hMwzCf6QIiE9aIPoJ
	7FsdKmRv3TYeX+CcAW7+74TiAGNm5iXuKS2NjdhW3W9RKzt7BXaMGCnHJuY5Vc2gLLHBKR6M=
X-Google-Smtp-Source: AGHT+IHCwX9tBUNJ4vUL+HRtX/pNUZGqGIBRJgFIeh7dwGLzBMH2QbmaQNU6B5i4kDVwxKn3b3C2BGkQe7GPOVyR6ew=
X-Received: by 2002:a05:622a:1a9a:b0:466:97d6:b245 with SMTP id
 d75a77b69052e-46fde4b14e3mr4241201cf.22.1738256315469; Thu, 30 Jan 2025
 08:58:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com> <6810dbdb-1b44-4656-9f65-abca471523f9@redhat.com>
In-Reply-To: <6810dbdb-1b44-4656-9f65-abca471523f9@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Jan 2025 16:57:58 +0000
X-Gm-Features: AWEUYZkqjd_c8s8_NqAiNB2ua1_PSsCvwT_KNHeeEKbL3m2RKXKoGVCEenSF2OE
Message-ID: <CA+EHjTwE3mn+eJgmcFk1GqFdtyBHgM4SpgHNJ-0omNKLSzP8pA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/11] KVM: Mapping guest_memfd backed memory at
 the host for software protected VMs
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Thu, 30 Jan 2025 at 16:50, David Hildenbrand <david@redhat.com> wrote:
>
> On 29.01.25 18:23, Fuad Tabba wrote:
>
> Thanks for the new version
>
> > Main changes since v1 [1]:
> > - Added x86 support for mapping guest_memfd at the host, enabled
> >   only for the KVM_X86_SW_PROTECTED_VM type.
>
> Nice!
>
> > - Require setting memslot userspace_addr for guest_memfd slots
> >   even if shared, and remove patches that worked around that.
> > - Brought in more of the infrastructure from the patch series
> >   that allows restricted mapping of guest_memfd backed memory.
>
> Ah, that explains why we see the page_type stuff in here now :)
>
> > - Renamed references to "mappable" -> "shared".
> > - Expanded the selftests.
> > - Added instructions to test on x86 and arm64 (below).
>
> Very nice!
>
>
> I assume there is still no page conversion happening -- or is there now
> that the page_stuff thing is in here?
>
> Would be good to spell out what's supported and what's still TBD
> regarding mmap support.

Thanks! No page conversion happening yet. I'm rebasing the other
series, the one with the conversions, on top of this one, as well as
fixing it based on the feedback that I got.

What this is missing is the infrastructure that tracks the
mappability/shareability at the host and the guest, as well as the
implementation of the callbacks themselves. I thought I'd send this
one out now, while I work on the larger one, since this one is easier
to test, and serves as a base for the coming part.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

