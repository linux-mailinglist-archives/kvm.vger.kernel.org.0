Return-Path: <kvm+bounces-15711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160DA8AF6E7
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 485851C22AD2
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D175A13EFE3;
	Tue, 23 Apr 2024 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DPvHoa0A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B40113D516
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713898381; cv=none; b=LEGEbOVdjS7eEHI5kvkNMh4A6ZvXJGlCe+F7qZCPn/nM7OT4s3uDR4xBHFBwSy02tdGXfFHXMtK0BvtUIwTn/kH1PNTY4SV55ZE6bKJFZxW+jprstNJnHvZyKwFWZSYPXkFZpgIUy/bb3e1OEDQQo0XguPWeU0muIBeOYlkPTCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713898381; c=relaxed/simple;
	bh=5oUEO2CmPLdJW03n2wWvGLeOn43pW/gweO4TeIEfA88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzudwmmkGr8ECelT1ilisj4cLJDJGHvpPtP/sCXBASHiV6E9xuOthYXL1IGZczJKLyFc2nDzygmOXFWiD5H1WqN9aqa5jFtJys2zk0OOLSiiQDPiwZadFHx4KUan+iqAXAC1ir6S/3LpiCcqSgppHWiO8AeL1R9FXlbozws02Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DPvHoa0A; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56e78970853so290832a12.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 11:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713898378; x=1714503178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vAcnidZon+wtsm/iUcBLxhJs2JUrTa0JkYPmpRFUcUU=;
        b=DPvHoa0Avbm2FujSDBOrlvqkxxouRx8DyCJRVSKvhk+u8X8IYQT7Ey0cAlBYCOtWPK
         EFWXzG4s8CSw8jh0HHkqB/NWNIXWancV2ou0mUKZHDfiKv4wKfwl7LUGBGJlRqVszZmw
         Gp+uenvkiJErCsmXrlzbwZgBQYfW7rX2/5n5JFwPtCNwPwjMzyuyUxNoDZWniI/PkqQZ
         sH79cSEkrOQBYLkInsCR2hCG8shKiNcUG84kmY1p8H3rfBfg9VwFJ8Rcm3IK74Cws+ZY
         H0upjy9wjxcqNYScW2IFOCt5OZBCTQ2P/00faTUaujOWZ6Bt35xMBDK5qEpnDPz+o4tl
         EqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713898378; x=1714503178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vAcnidZon+wtsm/iUcBLxhJs2JUrTa0JkYPmpRFUcUU=;
        b=I5citk+m4jIcm41tG1f5wkmhqAA2zbj4N6MByuJr+yAvsjBHJuA3GIAmLhu9yXT8UT
         5JXgOscZhQUxu8epHWltWaiA0N6Pn2GuW0DL2R5OD77+R8mURJ9N4m92HODxEtlg2MRr
         qcV7/xSJ3ULvPoDAC1Ap5uLCf2Zcvny6zF/uHVAPEDi0iFu7QLm/1wKef/8i1RYLXXKb
         muZgslsmjNrG2uaFLVM1KNMFEGkWKjAjwRXLRYN5MjY3fzs44LH5mzUoZCbHH4g9IIOB
         0XnctfdV0qs8fsYw9SDIaxV9yC4IJ2TWUWewMLG2EcCeHM6urA7UNv6Nu33EGSvmQIDG
         xSrg==
X-Forwarded-Encrypted: i=1; AJvYcCV5ghzVWmUvY70mwWLj4pBBSo8OWAyCmzYaHTedHvChf0reBMAm+iPziQtQvz6w55Cd+m5dcbf9CvgYpatI6jn/9Ot/
X-Gm-Message-State: AOJu0Yydg0JfZz69VBwgLWZzEZVp13EC9Nwz6dniSqBTRdmrLvfOU91Z
	+qarVO/Rgml2tCND2/Ly5XyoFr8qeNeDczlzmbHHnhmN4l9X+ayuoW3EAZFjhEyVcwJAOzXjNUh
	+41lEe7zCtjp0pZPIVRcTsNA3Jni7UIQdERs9
X-Google-Smtp-Source: AGHT+IFI0KakWcuRn7zUhZl9lfms+ZUJ4Inz8sQCYoqzt6ndohp5Pzez/6wsEMfSf2FNilov2ZsZ2tBiUujzoUJGFtE=
X-Received: by 2002:a17:906:b88b:b0:a58:7bc5:26c0 with SMTP id
 hb11-20020a170906b88b00b00a587bc526c0mr324081ejb.30.1713898377509; Tue, 23
 Apr 2024 11:52:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
 <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com> <ZigBYpHubg00BnAT@google.com>
In-Reply-To: <ZigBYpHubg00BnAT@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 23 Apr 2024 11:52:21 -0700
Message-ID: <CAJD7tkafCAP=qx2H=U2taxPL-5eqrVTqPuSUxQZKSPA-qAjyvg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 11:43=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Apr 23, 2024, Yosry Ahmed wrote:
> > On Tue, Apr 23, 2024 at 6:30=E2=80=AFAM Peter Gonda <pgonda@google.com>=
 wrote:
> > > > struct page *snp_safe_alloc_page(int cpu)
> > > > {
> > > >         unsigned long pfn;
> > > >         struct page *p;
> > > >         gfp_t gpf;
> > > >         int node;
> > > >
> > > >         if (cpu >=3D 0) {
> > > >                 node =3D cpu_to_node(cpu);
> > > >                 gfp =3D GFP_KERNEL;
> > > >         } else {
> > > >                 node =3D NUMA_NO_NODE;
> > > >                 gfp =3D GFP_KERNEL_ACCOUNT
> > > >         }
> >
> > FWIW, from the pov of someone who has zero familiarity with this code,
> > passing @cpu only to make inferences about the GFP flags and numa
> > nodes is confusing tbh.
> >
> > Would it be clearer to pass in the gfp flags and node id directly? I
> > think it would make it clearer why we choose to account the allocation
> > and/or specify a node in some cases but not others.
>
> Hmm, yeah, passing GFP directly makes sense, if only to align with alloc_=
page()
> and not reinvent the wheel.  But forcing all callers to explicitly provid=
e a node
> ID is a net negative, i.e. having snp_safe_alloc_page() and snp_safe_allo=
c_page_node()
> as originally suggested makes sense.

Yeah if most callers do not need to provide a node then it makes sense
to have a specialized snp_safe_alloc_page_node() variant.

>
> But snp_safe_alloc_page() should again flow alloc_pages() and pass numa_n=
ode_id(),
> not NUMA_NO_NODE.

alloc_pages_node() will use numa_node_id() if you pass in
NUMA_NO_NODE. That's the documented behavior and it seems to be widely
used. I don't see anyone using numa_node_id() directly with
alloc_pages_node().

