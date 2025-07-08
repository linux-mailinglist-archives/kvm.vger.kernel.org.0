Return-Path: <kvm+bounces-51829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3464CAFDBDF
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 01:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 744724A6F00
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E83423717F;
	Tue,  8 Jul 2025 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aqMsairC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEF922D7B1
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017482; cv=none; b=CygrQm7EbaJufZOXQgvfuggc1bxgpPW6jHtSNtyvF8FHOZSZFcQNZTJB3wpeJHd7RjZ0r63FM+2P8OzM5G4BL0TXeqLLi+Rt6w14FZPS4OV3K7bFUGMmdr3AJFxuF4cgoNOntKIMc6HcybU0VSXNR56k3rsl+kZ7OCxMlSlv43s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017482; c=relaxed/simple;
	bh=SAzgLu+LEH3tK9/dGy5esJYRTisM3OaXVWh7G6Cr8f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O9lva87hj1HwKq+Rq2Wz6tXp1cQeXjIDox0QP8U3USHmUxmiULGgcTV5eeppmeVH2cnt57xIOJ+Vh7pZCNoAiZMruvJRGjFdM4DntY7Uk3Jhmz+cEZtrnIRapdk3u5iTe61cWTsuAv0wKPrYb/GiyaZZSeaxYQgrxTPGG2zTVVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aqMsairC; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e389599fso91065ad.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 16:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752017480; x=1752622280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAzgLu+LEH3tK9/dGy5esJYRTisM3OaXVWh7G6Cr8f8=;
        b=aqMsairCGVwgchMbqIlYEkhNczRsYtbtoj401ou8nnM/D4CqRgn2JZJDcfPze+uTd2
         ulwiDHRorMmYNFg3s2/NeHx4j3kpppLEXoL9O+9CbO2Qd8m+wZHKKfC/v/ntxF7dXgO5
         +xy4HQ4bYIAUaAy5WRHY4nNOn/EXWFR0ZccT7hQv7BB0bHI2ueFg6piKK4Wf2foJfGdD
         ijkQPXMwYTze6n/W2AtsmDXC1+vhvOOWf0vxNd0u45YjbP9Duy7UWnBWmwo9IhbUkgoz
         aYe2pR0MQx9huf+KpCDxoBezHDgbvQE1hzX6TCYjGd+lP2fdCJHAmHWtLt3AYFLFgKGk
         w2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752017480; x=1752622280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAzgLu+LEH3tK9/dGy5esJYRTisM3OaXVWh7G6Cr8f8=;
        b=VcneHAgP/LtNAlKGsmilRWrehHUKszj09fzqk3egFT1X08u/9nG/igy8OKE7W/7CKW
         SisQlTOTGuXNpYynO3LpmDKx+50stwMxNlRVf5IZqbDi0q7yianQ4/PgagCCeZ6pvFT4
         RHj+NVm3YUCWPQrr+XRxoZhUrCNCB9bdw49PO7lalFnDajy/L4FPheQ9GZNZZ8WTrmYF
         G4VUsLTm1iYUaqKZjqs2pi33t80I1oC62cMkTlbF9kYHMl3vCZA6E/c4JB4iNx7027G7
         ykNdk6ch85J9KMDT0rqwl4DiAA+QWDmkoQ9vrhSHVRHpvYCOz+0/XcM9B9Cd25wGYl1a
         Ipww==
X-Forwarded-Encrypted: i=1; AJvYcCXEolnaWnaugx3mQAZyblsDh2j4bNjs9wHFj28IuzXt68rwxrozjwyGWN+8eVFYGlOf9kE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkp/D12DqUPD25ct1ofF/GfDeSFnKQqmNkGwHmgDQWonfnMbNz
	Yq22kZCzBVFNGJJmo9+U8jCOQquRZjAE8MK0xYpsvwDwOV/kVpskCx4xLyesQgcV8Uc9Ngq9TOq
	HHsXPaNgQ9ydbMO/E3JI0Kq4T+c66U4dSZDB5nrPr
X-Gm-Gg: ASbGncs0kY9357PBxcqiuhOgc/OZMmD+RRjnWJcz/ZFZ48PwV/ili1Wa5R7pzJvXEl2
	8hTJVk2xw1qbKqRneMUnV+FRWD7Me3Kag0HLNwXEPxkSh7TiA6CnWouZU+Zdr0fxmZbCxZ9fQm8
	weQbs4Nx/mo5jdFgbVH+Xd5G7XoA3zOTDgPhC4fYOsSVVCaZ9qIDu9oyWdLgXPIzbC0QCWeckvJ
	Q==
X-Google-Smtp-Source: AGHT+IEeUeefQsUt6efuPNnMZbVeMJ+9APYmZ1n6v6/pDJBdaauZi8BF+ZvGtY7BTmSSWXXn4mHbe2LPnzqYn6deI/E=
X-Received: by 2002:a17:902:ecc7:b0:234:1073:5b85 with SMTP id
 d9443c01a7336-23ddadba79amr606065ad.1.1752017479673; Tue, 08 Jul 2025
 16:31:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030033.32635-1-yan.y.zhao@intel.com> <20250424030428.32687-1-yan.y.zhao@intel.com>
 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com> <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
 <CAGtprH8jTnuHtx1cMOT541r3igNA6=LbguXeJJOzzChYU_099Q@mail.gmail.com>
 <c22f5684460f4e6a0adac3ff11f15b840b451d84.camel@intel.com>
 <CAGtprH_tgn1Xn-OGAGG_3b2chOZBkd4oO9oxjH5ZMF7w_kV=8Q@mail.gmail.com> <edc5efcab4452d3b0ab6c5099f6ced644deb7a6e.camel@intel.com>
In-Reply-To: <edc5efcab4452d3b0ab6c5099f6ced644deb7a6e.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 8 Jul 2025 16:31:07 -0700
X-Gm-Features: Ac12FXy5PxCoIO6caDTH1-T1FcwjbP8ghhGzV3nVDlOeYn-4MwQVAYV2NwF0jQA
Message-ID: <CAGtprH__25vVq4XgNuO-igsamN=zgFyv8=YdUKKXap3zHCuESw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 4:16=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-07-08 at 15:06 -0700, Vishal Annapurve wrote:
> > > > My vote would be to prefer using "hpa" and not rely on folio/page
> > > > structs for guest_memfd allocated memory wherever possible.
> > >
> > > Is this because you want to enable struct page-less gmemfd in the fut=
ure?
> >
> > Yes. That's the only reason.
>
> I don't think we should change just this field of this seamcall wrapper f=
rom the
> current pattern for that reason. When this stuff comes along it will be j=
ust
> about as easy to change it with the rest. Then in the meantime it doesn't=
 look
> asymmetric.
>
> In general, I (again) think that we should not focus on accommodating fut=
ure
> stuff unless there is an ABI touch point. This is to ultimately speed ena=
bling
> of the entire stack.
>
> It is definitely not to make it harder to implement TDX support for pfn b=
ased
> gmem in the future. Rather to make it possible. As in, if nothing is upst=
ream
> because we are endlessly debating how it all fits together at once, then =
it
> won't be possible to enhance it further.

I agree and if we can't do without page struct for now that's fine. My
response was just to favor pfn/hpa over "page struct" if possible,
given that we have a choice here. Feel free to ignore if symmetry
seems more important.

