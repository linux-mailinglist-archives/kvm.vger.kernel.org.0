Return-Path: <kvm+bounces-44381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54529A9D664
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C99FA9E609A
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B47298CCE;
	Fri, 25 Apr 2025 23:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wGazmbqX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75364267F75
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745624899; cv=none; b=OmU3N3+Ort+SJuRoClCki6TuE9mJh393pq48LLvLEgzG6VqpD4dS6vH+97aTWJUf+CVsrvRUnPA6/hOxXBGm9NICr9QbF1uBDHeD1yKb/9ot3sIdcdB9S2aKwX4GJzz1KqJZs5euN8qvxcekHBvlt5j5Yrt+k6jtw0oD0GvtPlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745624899; c=relaxed/simple;
	bh=rcwF2few5buON5TeOGJAeun8dgRx2Lc2YvNg/juyAHg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n7o1QZep/b/isRJfhHKAXfnIQDvTB2shmg7ANkX3Q5VNHDntQqT+KI8NuzxSW/O2WcBvtSIctw1sVKYhLCfenHSYTsJLuAVfEze7Ty3HoTNM7hgPaJwA2YPNmy1K2z41AfF1YYaj1+RwhomKpN9GwsNATKhlTY4iwG9BeDUcdIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wGazmbqX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30828f9af10so4966701a91.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745624898; x=1746229698; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/x8iC+HcuQnN1vsmJzMK0s2/hjQW7GH3MOf75CWrrM=;
        b=wGazmbqXOEqDr749sBivdlPi1++6zNZI9dDWck3Tze9maTEKd04V7/O86fTvBJ1wdA
         9K76GpuU5YrcvpeIteZiOZJ9r5BHWRNYgnf+MVcJAnZRuYBPg9VpNXlkD9TqzcAqrvwj
         H//BZlLOKRwSkvHHv+WIAubhpVDp3DZlQv6xYSLGCv2Wo3+iIeKTwtBaX3usoccQ5j2k
         /Ovs+MgQHokXdKpKibqpqxfQesfd9VXUfg4MZjPIa+FuHamqcaimMF/nlcKtyZ+Rs9qc
         099n8P5udqpE4l1jMtGyxJGiKa0Vba/mztfQaZF/t5Obx4hXxHMNykyipq8myHkxz0+E
         zTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745624898; x=1746229698;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I/x8iC+HcuQnN1vsmJzMK0s2/hjQW7GH3MOf75CWrrM=;
        b=uRiK0CJbAuFsqpsPzMSaf2qJpv++Vj3RwtWcOov9UTFEzfj/vutLCr13xrjjEp/6bT
         sGOF32t8w0Qctuh4HFrhu+CUHU4zSIQ+RA3nCXcJcWY4fEKMjh5/QUVKqvkRkbOjw7aj
         xBHn7iMR/LRuPE3EiHkigTP2GlBV2rMeBYwUJdi0CliTQZTUNdnbxpm7o1Suaq1qIXvN
         1I20ez+395Evd/Yp96ixSa5a9xCS1x0KBfyEAFYYkxjIXnYRzJo2jP37G2lI5l9afLr3
         LKWe95VyNLmGNKf/9i+6OXJp5vkpC5qCIugKMHZuJNKqwO6f7Fd9hHDNJDleLi4awr3C
         gQqA==
X-Forwarded-Encrypted: i=1; AJvYcCVw4uzlkQ/NIChw/afl1rxZ0+eZlibESCRmCAJuZkR9139SXiKKNFwIs4eg9qV71IjPpcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKe7pKfrtjCBvs8X4/G2gZRRh7JSXgdEexQ2liZEU920s+9HOw
	S6DxPQtmwjrh1qKnTZZWUfve4wBoJIF1126SEZy/e4GybFj3BVqs4aIeFDP7gtLUxLRg6Xo3WPo
	qqg==
X-Google-Smtp-Source: AGHT+IFGWSAl0YF8xmQ0bkqFQwE3kUAYPuX6gbFCDm0JaFRr4jPu3Vx+zTClObJXZ7KBW0uBCZiCol26qfk=
X-Received: from pjbos15.prod.google.com ([2002:a17:90b:1ccf:b0:308:64af:7bb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:586e:b0:305:2d27:7ca7
 with SMTP id 98e67ed59e1d1-30a0133b15fmr2060649a91.16.1745624897759; Fri, 25
 Apr 2025 16:48:17 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:48:16 -0700
In-Reply-To: <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250410072605.2358393-1-chao.gao@intel.com> <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com> <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
Message-ID: <aAwdQ759Y6V7SGhv@google.com>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, Dave Hansen <dave.hansen@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>, 
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, Xin3 Li <xin3.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Weijiang Yang <weijiang.yang@intel.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "john.allen@amd.com" <john.allen@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Chang Seok Bae <chang.seok.bae@intel.com>, 
	"vigbalas@amd.com" <vigbalas@amd.com>, "peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"bp@alien8.de" <bp@alien8.de>, 
	"aruna.ramakrishna@oracle.com" <aruna.ramakrishna@oracle.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-04-25 at 16:24 +0800, Chao Gao wrote:
> > >=20
> > > In the later patches, it doesn't seem to change the "user" parts. The=
se
> > > configurations end up controlling the default size and features that =
gets
> > > copied
> > > to userspace in KVM_SET_XSAVE. I guess today there is only one defaul=
t size
> > > and
> > > feature set for xstate copied to userspace.=C2=A0The suggestion from =
Chang was
> > > that
> > > it makes the code more readable, but it seems like it also breaks apa=
rt a
> > > unified concept for no functional benefit.
> >=20
> > In the future, the feature and size of the uABI buffer for guest FPUs m=
ay
> > differ from those of non-guest FPUs. Sean rejected the idea of
> > saving/restoring
> > CET_S xstate in KVM partly because:
> >=20
> > =C2=A0:Especially because another big negative is that not utilizing XS=
TATE bleeds
> > into
> > =C2=A0:KVM's ABI.=C2=A0 Userspace has to be told to manually save+resto=
re MSRs instead
> > of just
> > =C2=A0:letting KVM_{G,S}ET_XSAVE handle the state.
>=20
> Hmm, interesting. I guess there are two things.
> 1. Should CET_S be part of KVM_GET_XSAVE instead of via MSRs ioctls? It n=
ever
> was in the KVM CET patches.
> 2. A feature mask far away in the FPU code controls KVM's xsave ABI.
>=20
> For (1), does any userspace depend on their not being supervisor features=
? (i.e.
> tries to restore the guest FPU for emulation or something). There probabl=
y are
> some advantages to keeping supervisor features out of it, or at least a s=
eparate
> ioctl.

CET_S probably shouldn't be in XSAVE ABI, because that would technically le=
ak
kernel state to userspace for the non-KVM use case.  I assume the kernel ha=
s
bigger problems if CET_S is somehow tied to a userspace task.

For KVM, it's just the one MSR, and KVM needs to support save/restore of th=
at MSR
no matter what, so supporting it via XSAVE would be more work, a bit sketch=
y, and
create yet another way for userspace to do weird things when saving/restori=
ng vCPU
state.

> (2) is an existing problem. But if we think KVM should have its own
> feature set of bits for ABI purposes, it seems like maybe it should have =
some
> dedicated consideration.=20

Nah, don't bother.  The kernel needs to solve the exact same problems for t=
he
signal ABI, I don't see any reason to generate more work.  From a validatio=
n
coverage perspective, I see a lot of value in shared code.

