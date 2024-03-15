Return-Path: <kvm+bounces-11935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8030C87D469
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 095B71F23693
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305BD524CE;
	Fri, 15 Mar 2024 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kviWD2WK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4798BEC
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710530434; cv=none; b=oIVTq7NuG59mThBTshcF0klZEUZIrwBZJMHhHwENqpuSTOYC/FD1NLiu9Ut9PK3rIJBulaO1ycGW285IN+4PSDdPSNw2l9IuApq8q5a9Q4QEk66OaVtQgtElPeFqZ3GkRx0AACgctDTFIA0drswOfmbXKUWku+9PbGYFRwI70oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710530434; c=relaxed/simple;
	bh=mrTyWLKNzbPd+Es/f7k4riqHuUAgAcAswomjRq95eU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WmchQkqYlwR3woIck5NFglqDgx+RVzPOg2JYHtsNMl93AlXAObbRGGuuuygmjbbpfVHlFoiPqJuEuu/yOFWCIAWvRNmUxhypZ5Ju36kmaLskE9/SA6f/msQm0B8fQqav5I1tAlXACtmFNR18LXroZwAfKIWte17rTSH+hYGkxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kviWD2WK; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a2386e932so49862227b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 12:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710530432; x=1711135232; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGq29qQOFJv52Q4bTVIictDDuC4jaHMG/xiohXW6Wrg=;
        b=kviWD2WKAigKRar70oD9qu8aC7dtFGyvNC/LCAN/xCb7nbKp3EBPg06czInnlqpI/s
         R2WNYWVE0IbWislcHkYB+wpXJPTlu//bEGREcfXhCNmyoWPUVj7FJsK2pVKvnXohmYGf
         yncTTfjNebks31Mo8X19QxusyOk2MlGOaCfCCazMPKQ7ZP91lvPt9CQ/2mArHKpp58wl
         Dx7K4ZMt9ceVime903PCacPb9ltmG7tONmw75xBglBPBSSvD/x2JMuXehlLaJ1c5Rvwy
         flPh+hciran1gXkSCa0O0zTfd4vmbnLAY46+VVGCgmWPWrgMn+/hO7Tc16AcpDnHcmNO
         1jqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710530432; x=1711135232;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xGq29qQOFJv52Q4bTVIictDDuC4jaHMG/xiohXW6Wrg=;
        b=tFoUY+bAqqrMQHLLnpA5AXpu+bCqqRWt4OYJsTyRwqlRx+MUuKpW1EKCcJamcD7KKN
         jjSMCaXg3LkB1UzrPxs/IKLTA8kZ5b5Tx4YP/60bVnKcenX1UoB8EE4fGl4U0CcVww6n
         5bPp5zYpyn9Ip2pxDR+94Buxyl+rxNuzCBmwEnCdw7R2cqTmD3lg39yn0PRHmmzf+fKA
         ZQp6gSZDDu6Lz5iDJtc3phgW0ck2q3wvvRUtCJwGCD5EyAZw6CYb33y6WuWYQ50Lanif
         pJoY4U6zCw5N9eoL4TK/NKB0HP4F6kpD3Bt470VTNWDekYwdNmPy+B9FXKvWnhKNiR2O
         17yQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0hop4jpCcoRoiJPA21AjN7yEgRLXafu1XLdrj9jrKZZdoxpfzXtMW/0f60tVK5oUWg89/2tWCoXBuqYeMd9wLOnBm
X-Gm-Message-State: AOJu0YxQXi2cy0xkhRNFdpk5UPlApD2lJc4VzbEZINNDhroNRS6NPRbR
	GiudgA2ik3KNHDogHOD89BOKUsUYXq1Afre/0gCFfR5YwmLHawV7zvNn7Y5cbHt2MbxFF+QrSwC
	cSQ==
X-Google-Smtp-Source: AGHT+IF6S3TxprvwoJU2GOkok9Zi0eiF/NCn2IJTYEv9k7CxvacWoa7pAyS5+65wdo+4/6YoHFi411jrrjk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:db03:0:b0:608:72fe:b8a1 with SMTP id
 d3-20020a0ddb03000000b0060872feb8a1mr1377179ywe.4.1710530431809; Fri, 15 Mar
 2024 12:20:31 -0700 (PDT)
Date: Fri, 15 Mar 2024 12:20:30 -0700
In-Reply-To: <07b75e0f18a5082a91f80fb234d29c97489e2f75.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
 <ZfSJkwnC4LRCqQS9@google.com> <07b75e0f18a5082a91f80fb234d29c97489e2f75.camel@intel.com>
Message-ID: <ZfSQC8vsqqE2DziW@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Bo Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024, Rick P Edgecombe wrote:
> On Fri, 2024-03-15 at 10:46 -0700, Sean Christopherson wrote:
> > On Fri, Mar 15, 2024, Sean Christopherson wrote:
> > > So my feedback is to not worry about the exports, and instead focus o=
n
> > > figuring out a way to make the generated code less bloated and easier=
 to
> > > read/debug.
> >=20
> > Oh, and please make it a collaborative, public effort.=C2=A0 I don't wa=
nt to
> > hear crickets and then see v20 dropped with a completely new SEAMCALL
> > scheme.
>=20
> And here we we're worrying that people might eventually grow tired of
> us adding mails to v19 and we debate every detail in public. Will do.

As a general rule, I _strongly_ prefer all review to be done on-list, in pu=
blic.
Copy+pasting myself from another Intel series[*]

 : Correct, what I object to is Intel _requiring_ a Reviewed-by before post=
ing.
 :=20
 : And while I'm certainly not going to refuse patches that have been revie=
wed
 : internally, I _strongly_ prefer reviews be on-list so that they are publ=
ic and
 : recorded.  Being able to go back and look at the history and evolution o=
f patches
 : is valuable, and the discussion itself is often beneficial to non-partic=
ipants,
 : e.g. people that are new-ish to KVM and/or aren't familiar with the feat=
ure being
 : enabled can often learn new things and avoid similar pitfalls of their o=
wn.

There are definitely situations where exceptions are warranted, e.g. if som=
eone
is a first-time poster and/or wants a sanity check to make sure their idea =
isn't
completely crazy.  But even then, the internal review should only be very c=
ursory.

In addition to the history being valuable, doing reviews in public minimize=
s the
probability of a developer being led astray, e.g. due to someone internally=
 saying
do XYZ, and then upstream reviewers telling them to do something entirely d=
ifferent.=20

As far as noise goes, look at it this way.  Every time a new TDX series is =
posted,
I get 130+ emails.  Y'all can do a _lot_ of public review and discussion be=
fore
you'll get anywhere near the point where it'd be noiser than spinning a new=
 version
of the series.

[*] https://lore.kernel.org/all/Y+ZxLfCrcTQ6poYg@google.com

