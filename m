Return-Path: <kvm+bounces-24146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7FE951D01
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EE6CB20EFF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EEF1B374F;
	Wed, 14 Aug 2024 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ojiX3ZbI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9BF1B32B6
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723645409; cv=none; b=nm4mGoSeRiFJ7taa5zSQPSsWp3itsgvhSRWnsXG2rSdjPw5IVSxT0BvZalxO14dfh7EY967DIgTlU0QLH4eL98c8X2J4fXZPHrgWil5YlVpV/W1zrz6GKCj6n/gOGCWSNbPK8l2ah+1Q+xFttKfHavWkzfeCHLBQF3J2evYbVNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723645409; c=relaxed/simple;
	bh=5cLAuQ61iDBCAWlNH24kfuLmPgqegQd2dzbYuUac2dk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E8qjSRe1iOOpjqoHYg4SW9E1IO6JpXI6hxq80uJ0YYVNBhD0PJBKRI0zJ4H57jn/6vAJGldZku9Z7VtIk3nPTAiyFEAPHdEGVXA+NmlIoYkMybGAyWY4zLqA7IrLqi6p0OE7xVzrTnWwOp7hPaYeCGlKe5sMiul6qe2IhLb1UjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ojiX3ZbI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cd4e722d82so6615859a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723645408; x=1724250208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg7Z6HPc6YbnuAyQKf9l4Kwwyg7M7gxKeR8BkfMVjOA=;
        b=ojiX3ZbIzn+mEpM9adk5kF+rKLGiXluF50whV7Db6dDYxbEiWQwEenGnjCB0qTIqVO
         UnIx+i713zeqLUaJBJZs4ZUpRIVcNGz8eSe5HVEHF93Zr6rhsZ1G/ZR7v6G6yuwZ+LxS
         XjBIlNf8k4Qrg9wdiqGx/8QmB0Et4iTqLiJsZEftISbbQctrV2eK/KnZ+vbIKIzYG1A5
         aKJ4+RzD8HE9p/03vYwb+05o5pXK46d1kV4TI9KglxXdC2iy8yxIsdLPunzTbftknd0O
         b9vbQHLVh/BOMqMSeAEgYQHJA9nABxAUYJfWGYYwz362cH3kH4MVWR2ipTDDcsuAT+tz
         MuQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723645408; x=1724250208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg7Z6HPc6YbnuAyQKf9l4Kwwyg7M7gxKeR8BkfMVjOA=;
        b=E24k8uwsYRvTnRZVt+IFTJZq3sRwb2UTFbXZflmHFyfAlEyVeq1TXf35INbkbwfxdJ
         1c+m+osRZ4bcQCAX2wGexG2L38zsyKD03mGgz8R+TOaOULgIpD5H8fhKCxJ/3jwP1C/P
         Ux3cqA6BnzKcHuFCtI1PXC1XSyZC11Q1bPV7VRdKypXHBv7Bbc2tBmOl+bkyEsNET5T4
         YK2XWque3NYRm2TnizsrbcrPLlvAW/Oo2/PJnWOQu9aWB02WGsZWK9todn8Rf4StLpmf
         FvKbx780avzFg2ufqn1xHKdae3Hpyg0QGr+/yAeekASgDoqkpnFVLHjvmP7FFjZssF+W
         w+5A==
X-Forwarded-Encrypted: i=1; AJvYcCXezXk2DUiwO9GPl+nCyOwHvud3Qyfwjl704ESuCnpZie8G0pLFLFESh3YSPNvueC9k/v8UXFYnSb+INffEdtpC9jP9
X-Gm-Message-State: AOJu0Yzv3w6HdN0SeFyE097DXdA2iQprN37BbbLz6+uHxWNJE7yQH704
	BXTfyBfFTQYWk6KrBxpMfE1zHsLdZtve8CyyJ1MZLJT8aTF56QBpE33cRhjErzSz2r4EJJ6kLoR
	EnQ==
X-Google-Smtp-Source: AGHT+IE8K9ernEt/qh7dn+1OHmtOhjlZRg5DWU6KU712b9wel2NvDzCtf+nXpMhkwXka1BX1I745J1ypunQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b10f:b0:2cb:4b7e:ffa3 with SMTP id
 98e67ed59e1d1-2d3aaa74a9emr7282a91.1.1723645407394; Wed, 14 Aug 2024 07:23:27
 -0700 (PDT)
Date: Wed, 14 Aug 2024 07:23:26 -0700
In-Reply-To: <20240814131514.GJ2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240809160909.1023470-11-peterx@redhat.com>
 <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com>
 <ZrpbP9Ow9EcpQtCF@x1n> <CAJHvVchObsUVW2QFroA8pexyXUgKR178knLoaEacMTL6iLoHNQ@mail.gmail.com>
 <ZrqeaN2zeF8Gw-ye@google.com> <20240814131514.GJ2032816@nvidia.com>
Message-ID: <Zry93tug5Iz4FbrL@google.com>
Subject: Re: [PATCH 10/19] KVM: Use follow_pfnmap API
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> On Mon, Aug 12, 2024 at 04:44:40PM -0700, Sean Christopherson wrote:
> 
> > > > > I don't think it has to be done in this series, but a future
> > > > > optimization to consider is having follow_pfnmap just tell the caller
> > > > > about the mapping level directly. It already found this information as
> > > > > part of its walk. I think there's a possibility to simplify KVM /
> > > > > avoid it having to do its own walk again later.
> > > >
> > > > AFAIU pfnmap isn't special in this case, as we do the "walk pgtable twice"
> > > > idea also to a generic page here, so probably not directly relevant to this
> > > > patch alone.
> > 
> > Ya.  My original hope was that KVM could simply walk the host page tables and get
> > whatever PFN+size it found, i.e. that KVM wouldn't care about pfn-mapped versus
> > regular pages.  That might be feasible after dropping all of KVM's refcounting
> > shenanigans[*]?  Not sure, haven't thought too much about it, precisely because
> > I too think it won't provide any meaningful performance boost.
> 
> The main thing, from my perspective, is that KVM reliably creates 1G
> mappings in its table if the VMA has 1G mappings, across all arches
> and scenarios. For normal memory and PFNMAP equally.

Yes, KVM walks the host page tables for the user virtual address and uses whatever
page size it finds, regardless of what the mapping type.

> Not returning the size here makes me wonder if that actually happens?

It does happen, the idea here was purely to avoid the second page table walk.

> Does KVM have another way to know what size entry to create?
> 
> Jason

