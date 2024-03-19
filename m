Return-Path: <kvm+bounces-12116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 847F887FB0C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC772822BB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889437D095;
	Tue, 19 Mar 2024 09:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJoP+lQ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3F71E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 09:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710841668; cv=none; b=Lu5KQdLoXju+lG8n+EPvRpzqofX11hwkVePMUHKp4jVH27jTm9PyvACZGtx5M0eO60TFl3J9PZ45phFhKQrWbb8erDxP7CqK+DS2g1XNVKsBYKE/Tj7DMJSQXyOtgx0E4sKrGpabJpdF/aEk5ofGDpUqTm3/EtMTShHaQNVig4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710841668; c=relaxed/simple;
	bh=tB59vQHrrWfNtXgOa+QXun/KGjIcXOV4U0cREwm/b3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVNaqUpHx3eTZWff4GVxs5uObTqvBkmvUAVvkIlk59lRkQPNdQMea41KlkJ+jds2Ar35DjrV9k9kIh8AguCvkVNhJ2rmawfVn3YIWPX52W9Jlj9Up7gj+P/fMnrYJztYbWTjvIZYvbfb/5UZPXBTS/vqU8J65i886htvuVKA/Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJoP+lQ/; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a466a1f9ea0so358967966b.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710841665; x=1711446465; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HHhyDwGvRCaPjjju0RIkoEll4g5zmeDctgezA6gAMo=;
        b=tJoP+lQ/a6jFixhtP3WPuGkd0n2eYXDa6zvMYMLIKh2qVUnJKtj6iFcPhHQbWX3I/H
         xUc7ksE6YiylkeA5HbuqUki8P7QwMoTtad23/40wg++njdRPLIFofqUiQTmpQI3iBzAK
         Mds6eh8m3vKJOzFbgWF6GEkZGUY/nVsvlwBg/8koPH+lAMuYO0BdYBZ7ys/lF317tXFQ
         NmEQKPYQWrftM4HyaFjyu0/5q5jgbSr6mj1fA6PE9w58Vh2xEj+nyx24+34k8jlDodIF
         r9I3XdnjZ1K4A6nQr0L+3V2LL8x6Mhr3xxpFZCL8NxhP22rpBnASn9ukcXVAUvy/hz0M
         gxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710841665; x=1711446465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HHhyDwGvRCaPjjju0RIkoEll4g5zmeDctgezA6gAMo=;
        b=XT0eRfJGd9asUUwMFhSTlFUgpAARpfRboI/6CUct6XzMSYHiHwB/wyvG9CfeICNflB
         x4lZHlHn+NAtCImTfFyzACaWzzdZBWqPHj7N2MGTkZiNThQvzTGYrJagJHAfevvvIZPX
         q3GSj7Q/jG04wm5ZfU2bgrEoOmAjozJUqyp3LqfedCtSU7NJUlBlEZ6eNrGvSmUAiOtF
         gvdVTEAwTrop52QFIVS88cu1rIyJTD2pfrg75VJ6IjfhatRblEFzGRbVeSpQ/kGLOQFu
         smYhctV3PlKorh84syyG0NtQHsk5CpnCqtdkUW+X0nyvZqxPQvijeSZymB+z5vUUJ6t9
         ugNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvUhEz4nHlfd/1TUwpHm6b0/zwCFQGI1gW5n/OA4VxKT+T2BfMZaXU2PMadDnZ5pICNm2ipEFtdy4aFbYn3LbcPJgP
X-Gm-Message-State: AOJu0Yz52X/8kH4h7AnVn+aCk/aeRC5M7rKQEix3qA7q7QgKyhxEtYEb
	/pg/2LanItW8jPByNwX9TpCJZemAB59tngnFhyY5PrpK5x/CoKBV2HrgPffk/Q==
X-Google-Smtp-Source: AGHT+IF/puef8zhuN1727aKfDCay8r7kOdm59liIzFTyv3w/POjfIRKnd9fb5D53y8VNfxHFZefOTw==
X-Received: by 2002:a05:6402:448c:b0:568:1599:b854 with SMTP id er12-20020a056402448c00b005681599b854mr6246355edb.42.1710841665168;
        Tue, 19 Mar 2024 02:47:45 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id p11-20020a056402044b00b00568d325acf8sm2526799edw.20.2024.03.19.02.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 02:47:44 -0700 (PDT)
Date: Tue, 19 Mar 2024 09:47:40 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZflfPDhZFufZdmp0@google.com>
References: <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
 <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0fd46a-cc4f-4cb7-9f6f-ce19a2d3064e@redhat.com>

On Monday 04 Mar 2024 at 22:58:49 (+0100), David Hildenbrand wrote:
> On 04.03.24 22:43, Elliot Berman wrote:
> > On Mon, Mar 04, 2024 at 09:17:05PM +0100, David Hildenbrand wrote:
> > > On 04.03.24 20:04, Sean Christopherson wrote:
> > > > On Mon, Mar 04, 2024, Quentin Perret wrote:
> > > > > > As discussed in the sub-thread, that might still be required.
> > > > > > 
> > > > > > One could think about completely forbidding GUP on these mmap'ed
> > > > > > guest-memfds. But likely, there might be use cases in the future where you
> > > > > > want to use GUP on shared memory inside a guest_memfd.
> > > > > > 
> > > > > > (the iouring example I gave might currently not work because
> > > > > > FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> > > > > > guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> > > > > > details)
> > > > > 
> > > > > Perhaps it would be wise to start with GUP being forbidden if the
> > > > > current users do not need it (not sure if that is the case in Android,
> > > > > I'll check) ? We can always relax this constraint later when/if the
> > > > > use-cases arise, which is obviously much harder to do the other way
> > > > > around.
> > > > 
> > > > +1000.  At least on the KVM side, I would like to be as conservative as possible
> > > > when it comes to letting anything other than the guest access guest_memfd.
> > > 
> > > So we'll have to do it similar to any occurrences of "secretmem" in gup.c.
> > > We'll have to see how to marry KVM guest_memfd with core-mm code similar to
> > > e.g., folio_is_secretmem().
> > > 
> > > IIRC, we might not be able to de-reference the actual mapping because it
> > > could get free concurrently ...
> > > 
> > > That will then prohibit any kind of GUP access to these pages, including
> > > reading/writing for ptrace/debugging purposes, for core dumping purposes
> > > etc. But at least, you know that nobody was able to optain page references
> > > using GUP that might be used for reading/writing later.
> > 
> > Do you have any concerns to add to enum mapping_flags, AS_NOGUP, and
> > replacing folio_is_secretmem() with a test of this bit instead of
> > comparing the a_ops? I think it scales better.
> 
> The only concern I have are races, but let's look into the details:
> 
> In GUP-fast, we can essentially race with unmap of folios, munmap() of VMAs
> etc.
> 
> We had a similar discussion recently about possible races. It's documented
> in folio_fast_pin_allowed() regarding disabled IRQs and RCU grace periods.
> 
> "inodes and thus their mappings are freed under RCU, which means the mapping
> cannot be freed beneath us and thus we can safely dereference it."
> 
> So if we follow the same rules as folio_fast_pin_allowed(), we can
> de-reference folio->mapping, for example comparing mapping->a_ops.
> 
> [folio_is_secretmem should better follow the same approach]

Resurecting this discussion, I had discussions internally and as it
turns out Android makes extensive use of vhost/vsock when communicating
with guest VMs, which requires GUP. So, my bad, not supporting GUP for
the pKVM variant of guest_memfd is a bit of a non-starter, we'll need to
support it from the start. But again this should be a matter of 'simply'
having a dedicated KVM exit reason so hopefully it's not too bad.

Thanks,
Quentin

