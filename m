Return-Path: <kvm+bounces-36331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3896DA1A126
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 10:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812E6168902
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 09:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0899520D4E2;
	Thu, 23 Jan 2025 09:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g3DG7YXM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AAD1C54BB
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737625773; cv=none; b=GI13IXiBkplyNwwjMGPeiyFQBjRRjfxsMP1iSvdLC0Ti2LrDAWy0osfvFidS+3X6tjKwvVju+cfMkNd7umZ06Uwx0m9h62YCCrBJrGfdiiudPKVVkUNizOODXTkju5T1yGM1zKHaYIx08d/t71wjZ3OOHuQmp3sIpUpy1f0sf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737625773; c=relaxed/simple;
	bh=tGAjwfHnUykwJ2HHn/M5tuddLdAT0DP/rUfHVv+1U84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jOdRDbJwLtDAs1M/n5PKMCVtAuNAvbSoGfkc/7LHSCrWtTSy5dEY3CmBVzxI1M16+E5J0XEP3CfOykeyyIu7Q81ZhKZi4kXm4AHynB5apjD1YWUVZUS6DgBBSxdaMC2fnOxkNgvI0zLizKSDFwGYp4hfsavEK8f8QlCmVr6JerI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g3DG7YXM; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4678c9310afso153431cf.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 01:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737625770; x=1738230570; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tGAjwfHnUykwJ2HHn/M5tuddLdAT0DP/rUfHVv+1U84=;
        b=g3DG7YXM/IEYwvSG9xM0YbA16B45RgOXhKqKUdtJz5o1mR8W1WK2OuENHih2FOahfU
         qjolb6rU1RhkiJ4vAxgV0/eK0QCHggTWKHR69ludmp6Il3siSZjlxNPCiVedJpyInFdN
         u6Rf2kTEBZuQkymDIg0KXC1ix/hs/G8OV5uQUUMM39f4KEIwr5wOwPmLqqQlkaKfNhbr
         8WdokCEl9gXY0DEYepqSd/0zj5pdrbCW+ivXmNcylOl8MKh76FL8xZUTttOldP8TlkLn
         3QZhijWpbefI2TBeSPexxytRIVE/58bSBS7gg8Gvh8w3k1N678YvBnj+AV9IklBIAyXn
         BJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737625770; x=1738230570;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tGAjwfHnUykwJ2HHn/M5tuddLdAT0DP/rUfHVv+1U84=;
        b=KeR9oBuiJ6O4QfiVb8EP5JSDn3pPUx2ntPXPltkmASuHvuOPj9ZaJYS9rTYobq6vUP
         t/uNDhjm5p6q6SMY8DPZUni15ifBuF3FjsdtKin710htESxsH5V/VTAgPgcRF+b8x2yL
         H1z9S/AB6togVrbf7CWlE3jWKdEZzUQ9vc5tgCwGz8j0D+tIgA86+HzYwh7/ja/GBJ0g
         sGb43fQqanGbtk/uulifDSgRtNP+0DbY8dZK4zRRtoS7lqCWmuFDdb9xPWK1GBxD6IgX
         OYAsy6UEIpzCwMOwRwYbo4/HK4ED2lIzrmoXvdtXTMq4h2ZGIq+p+f30SXU4BDjwnMr5
         plTw==
X-Gm-Message-State: AOJu0YyMUDtHTyJltbyGPUbVmUzhYKfm4UsZQ28+anizJm7mCvcc4ZDw
	ATsIrEbkWIT4l1WjNCR5bNyj+ZZbnTRnFgXwRp22f0/f94UtIyGp92ArrSCXMDl9K5omdOBcMSe
	ethP1nkp+nDdyHE8qeZn8t3ZK4/QtFzwdhMxk
X-Gm-Gg: ASbGncvSCDv42urN1cMXy9JmS40NmpJVPku+xDY2ST+VJOnQ+LQjzogrbQCwRBTw9aC
	UQFof00k8vLJsFtXO7VNsGQS20NpGPfvDMZ3JwLrgfcOQbRqW6cPElUtdUHRj3GBFu1Jp1IJmyU
	NYdUeWncanos10vA==
X-Google-Smtp-Source: AGHT+IF1ST3fMVmS7ZS8aox2cNwj0YmDc3lu5/hh1pCw7G0VXEklkCsJqQVRLh5q5A+7HfCoG3CBOQAh/J03JAf5RR4=
X-Received: by 2002:ac8:7c4f:0:b0:462:b2f5:b24c with SMTP id
 d75a77b69052e-46e5dafd15fmr2333681cf.29.1737625770399; Thu, 23 Jan 2025
 01:49:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com> <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
In-Reply-To: <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 09:48:53 +0000
X-Gm-Features: AWEUYZmCLCgbEEVBEV5FFMaLev25KTqqUcEcZLSpslypZ2rETPMziZWnGfHJ8xk
Message-ID: <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
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

On Wed, 22 Jan 2025 at 22:10, David Hildenbrand <david@redhat.com> wrote:
>
> On 22.01.25 16:27, Fuad Tabba wrote:
> > Make kvm_(read|/write)_guest_page() capable of accessing guest
> > memory for slots that don't have a userspace address, but only if
> > the memory is mappable, which also indicates that it is
> > accessible by the host.
>
> Interesting. So far my assumption was that, for shared memory, user
> space would simply mmap() guest_memdd and pass it as userspace address
> to the same memslot that has this guest_memfd for private memory.
>
> Wouldn't that be easier in the first shot? (IOW, not require this patch
> with the cost of faulting the shared page into the page table on access)

This has to do more with the ABI I had for pkvm and shared memory
implementations, in which you don't need to specify the userspace
address for memory in a guestmem memslot. The issue is there is no
obvious address to map it to. This would be the case in kvm:arm64 for
tracking paravirtualized time, which the userspace doesn't necessarily
need to interact with, but kvm does.

That said, we could always have a userspace address dedicated to
mapping shared locations, and use that address when the necessity
arises. Or we could always require that memslots have a userspace
address, even if not used. I don't really have a strong preference.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

