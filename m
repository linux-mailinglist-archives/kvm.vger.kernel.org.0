Return-Path: <kvm+bounces-42796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E09C4A7D405
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AB8D16C6B6
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 06:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15ED2224B1E;
	Mon,  7 Apr 2025 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6uOubLa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BF1224AFE
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 06:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744007364; cv=none; b=QQLuDOWLQU6ERTeUl5l9qWe9IsUkCcXyeNyWI4bCO84igGYAwc3zuf7mtL5vty8k242zRAhwwXXVdHdr99r3HfSd+bViMdbDxpd45edsau6SxnjCEdCa2glyugyCRoe46NLpBfXxTJSVMAqSkoR9OHT5uxl4D7dLfbJMVdlKMmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744007364; c=relaxed/simple;
	bh=w20mvU+13MNa0HE5XLYY9XiXVSEFLUspHPL2upbK7aU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=BNmj0C7aFuwGWEczdReChy0O6zXEIlg2EdJT1I+umGStABo4/47AXfqqusOnWUELrxaR7zG5m0lsf7nKfxLUjoeiw/lXJOCE/9Rfu5NTi26dhUujbAwiQRgbQkGPb3RnbCW3GqrTa7s4gdKriZ+/585MsgsWJ2bwRgIjdeiLgU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6uOubLa; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47681dba807so408631cf.1
        for <kvm@vger.kernel.org>; Sun, 06 Apr 2025 23:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744007361; x=1744612161; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KNvNM1/p+e2DdNVPpvcS2yeyJQA+eXSwCZpqrERwuiE=;
        b=k6uOubLaxjJTW/1rrc6DlXD6WEuDcMVmFwN9w7xucFgCfLSrQIo5BnfYIw6uW65raZ
         +lLFM0UCqqis5cEg4LdzmPou0N4xg5a+KdIQ54cl78A8CgqitK9um/O+zlg9K0mHKFkR
         /5Rpu8V7PQGm63M/n3Jg/5HYveEgZL661bRGAmtFBVH/tBXdHu5H8PzsvGK57kQIVHZg
         +2trQjgGefG50bg2m53snZC2cyY36yPP9YP0qWLW7bVJa/157qt7T1V3L8ZlQWYr7Cux
         lcsDL1Ff2MuV4BZuLoBHJFk7reWSCN3EO27n4hR/ebikYDDrRU14uycqrmLUNAdF22y+
         uNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744007361; x=1744612161;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNvNM1/p+e2DdNVPpvcS2yeyJQA+eXSwCZpqrERwuiE=;
        b=n+TdI+1WRx4onY9EU3wP2hPPrcI2ebgpj4QaCxEAHpkkS4wIIsxL/C/2D5vGYTrSLy
         evTucD/9tCVfFJ4Ms51jl3gqC55/LcfxoK3ppWRMK4ChDJkpdez/tSFFFP7Wkz54MKjV
         qQckdVHr7HPRRj7a4AANAUO2MTaS8YRaFtJgOnlmoP8DSXVw5+6Q139ljHkwkqsY1uJd
         +ofUBqEsQPNDjZcQXuw4h2mY4RKaFxfUjn3MD2BsOjI/yVnd0K3QdoMmRJkWwMGiQmAH
         6pH9Nqz99uzSkQfpLGGmFbBZdmmokjPnkfhVp1MvPuhh9iZRoujDNTHQu+U0ibwn/uZ1
         fEOw==
X-Forwarded-Encrypted: i=1; AJvYcCUPdrnvrWz6JiZAQATDeImGYL6337q5SkKAwLqii1sCDn7649g9ou6nC0mqhFtwr1twx5M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz4kpvHVtEKTcw65vt3aSiiJ6fn/7aaYIl1EuE+POyw4XHhc03
	gE4LbekZ87otAb4VOjMffC5LIC/Dcrlf1HX6pVAf7+Gm1VXKHG9KfJe4cZ3djkhCTdekIWmROa2
	eA/7vmWyaVu6RI+1nHw/BdHB/dnPrZ5tamIvckB/Znk0BYH2Opg==
X-Gm-Gg: ASbGncu60Rga3tEEppjWIHlje0rrK8sVDMA7Mb38lGmGzE7ggqVnGOanXaCloc0Ky8Y
	frB1OG3SIVvjQEgMkgP6tUanCm7v5jeISPbf81oHv2I8l2fxBkzB3+JbTuP0qWnhyz0H8Saop4c
	qh8CfGVOmY7f5N6Qo0c+zrBME2fMVyhbBUfY5n
X-Google-Smtp-Source: AGHT+IENsC5jGsPnB8CmIHsaqNJl1ydsIYWgIdbVjFWo2tYe9QGGIM0fU+yrpn2AGdWi97/1qTE+g+eYnH6qOkjep28=
X-Received: by 2002:a05:622a:1491:b0:477:871c:2db4 with SMTP id
 d75a77b69052e-479332e3014mr6057831cf.5.1744007361239; Sun, 06 Apr 2025
 23:29:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com> <egk7ltxtgzngmet3dzygvcskvvo34wu333na4dsstvkcezwcjh@6klyi5bjwkwa>
 <894eb67c-a9e4-4ae4-af32-51d8a71ddfc4@redhat.com> <Z_BTr9EbC0Vz1uo7@google.com>
 <aizia2elwspxcmfrjote5h7k5wdw2stp42slytkl5visrjvzwi@jj3lwuudiyjk>
In-Reply-To: <aizia2elwspxcmfrjote5h7k5wdw2stp42slytkl5visrjvzwi@jj3lwuudiyjk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 7 Apr 2025 07:28:44 +0100
X-Gm-Features: ATxdqUGIvqi7yupl0S6E-dravwacnxsOIqGqv-ufIIOSzVLf9oEd58mckgm4bP8
Message-ID: <CA+EHjTyDNhyPdCXS+cmdKotcgRa6bmc+bROzNDVksrV_-YLzBA@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] KVM: Restricted mapping of guest_memfd at the host
 and arm64 support
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Sean Christopherson <seanjc@google.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On Sat, 5 Apr 2025 at 03:46, Liam R. Howlett <Liam.Howlett@oracle.com> wrote:
>
> * Sean Christopherson <seanjc@google.com> [250404 17:48]:
> > On Fri, Apr 04, 2025, David Hildenbrand wrote:
> > > On 04.04.25 20:05, Liam R. Howlett wrote:
> > > > But then again, maybe are are not going through linux-mm for upstream?
> > >
> > > [replying to some bits]
> > >
> > > As all patches and this subject is "KVM:" I would assume this goes through
> > > the kvm tree once ready.
> >
> > Yeah, that's a safe assumption.
>
> Okay, thanks.
>
> It still seems strange to have such vast differences in the cover letter
> between versions and require others to hunt down the information vs an
> updated cover letter with revision history and links.
>
> I did get lost on where the changes since v6 stopped vs new comments
> started in the update.
>
> But maybe it's that I'm set in my grumpy old ways.
>
> I really like the cover letter information in the first patch (this
> patch 1 of 7..) to have the information in the git log.
>
> >
> > > > It looks like a small team across companies are collaborating on this,
> > > > and that's awesome.  I think you need to change how you are doing things
> > > > and let the rest of us in on the code earlier.
> > >
> > > I think the approach taken to share the different pieces early makes sense,
> > > it just has to be clearer what the dependencies are and what is actually the
> > > first thing that should go in so people can focus review on that.
> >
> > 100% agreed that sharing early makes sense, but I also 100% agree with Liam that
> > having multiple series flying around with multiple dependencies makes them all
> > unreviewable.  I simply don't have the bandwidth to track down who's doing what
> > and where.
>
> Yes, sharing early is crucial, but we lack the quilt file to stitch them
> together in the proper sequence so we can do a proper review.
>
> My main issue is barrier of entry, I have no idea how I can help this
> effort as it is today.
>
> >
> > I don't see those two sides as conflicting.  Someone "just" needs to take point
> > on collecting, squashing, and posting the various inter-related works as a single
> > cohesive series.
>
> It *looks* like all these patches need to go in now (no RFC tags, for
> instance), but when you start reading through the cover letters it has
> many levels and the effort quickly grows; which branch do I need, what
> order, and which of these landed?  This is like SMR, but with code.
>
> >
> > As you said, things are getting there, but I recommend prioritizing that above
> > the actual code, otherwise reviewers are going to continue ignoring the individual
> > series.
> >
> > FWIW, if necessary, I would much prefer a single massive series over a bunch of
> > smaller series all pointing at each other, at least for the initial review.
> >
>
> Yes, at least then the dependency order and versions would not be such
> an effort to get correct.  If it's really big maybe a git repo would be
> a good idea along with the large patch set?  You'd probably be using
> that repo to combine/squash and generate the patches anyways.  I still
> don't know what patch I need to start with and which ones have landed.
>
> If each part is worth doing on its own, then send one at a time and wait
> for them to land.  This might result in wasted time on a plan that needs
> to be changed for upstreaming, so I think the big patch bomb/git branch
> is the way to go.
>
> Both of these methods will provide better end-to-end testing and code
> review than the individual parts being sent out in short succession with
> references to each other.

The idea was that it would be easier to review the two series
separately, with the second one being tagged as RFC (which I
accidentally dropped). That ended up making this more confusing and
difficult to review. The next series will just be one series.

Thanks for your feedback and sorry for the noise.

Cheers,
/fuad

> Thanks,
> Liam

