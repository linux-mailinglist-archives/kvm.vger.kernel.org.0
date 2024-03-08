Return-Path: <kvm+bounces-11407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CFF876D52
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F216E28180B
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3898136B09;
	Fri,  8 Mar 2024 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uFArpV64"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6589445
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709938060; cv=none; b=kkU3uNb71RnnltDdXSJuuFBo2hqCCGDayQ/bB9H/rMW5D+2Ot64lkD4+1alKjJfnwUabqKzkmDXwol6RRg7AuWsBtCN2j2Vht2ug/fHbxnWKKYFssvF2EcUu89BMO69vxwUveiQbKUmG7nfgAUFzN5a77IsyZkJq+9ambpTZQpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709938060; c=relaxed/simple;
	bh=M/bx8q8CM3qETkQji4PtCsuoRWZzooyLQhnGcyOMldU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UYEsDX5n6XQapNPYjOuVLDXYL4NTJ8UKhZ/gLVVqVJtDgHuhNWgzMb7HmM3YNRW4AlUqzovHH0dg67D3vA09d2ojBaP4Nwnx8oc714jU+Hchjx+h+E5yVGaX1QPJzl9TWjibqhQuezrmJoArsD4dNbPDZYghT6TgAXEasRbUI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uFArpV64; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fb719f48so33066267b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709938058; x=1710542858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SKmvQ5PcWXT/71cgvqMhhqx5Wzq7n7WsxYjGNYsq8ec=;
        b=uFArpV64e2cMQ7HFp6kljIG0NjTC9gYCv109ZFatYS2IcXxRq23Dp486AGixx2n6zb
         3MqXzd2XySjlCnvVTJtecELt9jnKW44EmDqdWICrc0mmueySOXwxnc/8EXx5J/+FLzNu
         upUhky71jXV4T6nqaqCtIa/GGYFR7cJ7TOicmLaF7ggwLF5fS2+NMlM09qh/jp+hPggA
         WlL2itndegtZqmNMvnBjhJezNWCnqhs3XsYYqS2fIQx3M2xiB9RD4f5AE6Dr7xzd/KCW
         TofL/SAWGHY2WK5LZI3U8JIKlYh+sU04wAB778R3JfkMogrUvjSMUwxsLt9mgcMGUWT/
         71Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709938058; x=1710542858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SKmvQ5PcWXT/71cgvqMhhqx5Wzq7n7WsxYjGNYsq8ec=;
        b=pJEZoYFB6AcVPmSMsyB5CP7H7O0Rh0F1ddyGw0+iZ4r4D+jLv9jDUsdWFvDIFoeQ+h
         hRkDk/0RgfXSVvdl1x4gCW53Qwo/ZjoKsYuCkZWkTy6P6b41RIvoWIzSZtBS38JjOzeP
         BQDYJzBwhrzGgAVsC1izJ9qQpRodt/6JPuWwenOppHfvoaQqeFCCEHTSxWwzIeg6QoXE
         ukCpFtDla0suUVSPAiAPJgRE7jwwYzwYGyIKw8VvSdZKCZMyFC7gbJn8b1g8YSqws0mi
         1vZqu91NgpKOME9n5e2CwAPV1FzxWj/roaZxiv7yrUxfgKjGEFFgtaCYiwLcOm4FfwNK
         Znkw==
X-Forwarded-Encrypted: i=1; AJvYcCWN58e4KAxNaAptUY/xjsYAYZLp3erYuEH85gTdgxFxu4gzc93r/IJBPIVVDurzA22Co99yUcbXXDqN3BfHIeAxXQm5
X-Gm-Message-State: AOJu0YwYw+RbGanKHoPFdfwC4VE0Ax9YoYlNn2vMsyDGQ0yjhrOm1D9x
	Em0lWcAIT9QYYSvsHMpG1QCnPudNccX4XEfcpG9V7KDgInVeJNDSWZnJ5RC0uKUWpbFQYDTCjdY
	oqQ==
X-Google-Smtp-Source: AGHT+IFqRwVOtamqH/NKTy0aNd2o9IZB1qaPOD/2a3NruNRdmlhFTn+MhqozJICSJlnbYsW/c2VqgNYGi+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5201:0:b0:608:ecf3:ef8 with SMTP id
 g1-20020a815201000000b00608ecf30ef8mr124505ywb.0.1709938058024; Fri, 08 Mar
 2024 14:47:38 -0800 (PST)
Date: Fri, 8 Mar 2024 14:47:36 -0800
In-Reply-To: <aa50a5ea6dbcd5f3f1df39dcf2fc4f5ee881ec8e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <CA+i-1C34VT5oFQL7en1n+MdRrO7AXaAMdNVvjFPxOaTDGXu9Dw@mail.gmail.com>
 <CALzav=fO2hpaErSRHGCJCKTrJKD7b9F5oEg7Ljhb0u1gB=VKwg@mail.gmail.com> <aa50a5ea6dbcd5f3f1df39dcf2fc4f5ee881ec8e.camel@infradead.org>
Message-ID: <ZeuVV3Jo31lcL41H@google.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Matlack <dmatlack@google.com>, Brendan Jackman <jackmanb@google.com>, 
	James Gowans <jgowans@amazon.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, Patrick Roy <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, Derek Manwaring <derekmn@amazon.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, "lstoakes@gmail.com" <lstoakes@gmail.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, Alexander Graf <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 08, 2024, David Woodhouse wrote:
> On Fri, 2024-03-08 at 09:35 -0800, David Matlack wrote:
> > I think what James is looking for (and what we are also interested
> > in), is _eliminating_ the ability to access guest memory from the
> > direct map entirely. And in general, eliminate the ability to access
> > guest memory in as many ways as possible.
> 
> Well, pKVM does that... 

Out-of-tree :-)

I'm not just being snarky; when pKVM lands this functionality upstream, I fully
expect zapping direct map entries to be generic guest_memfd functionality that
would be opt-in, either by the in-kernel technology, e.g. pKVM, or by userspace,
or by some combination of the two, e.g. I can see making it optional to nuke the
direct map when using guest_memfd for TDX guests so that rogue accesses from the
host generate synchronous #PFs instead of latent #MCs.

