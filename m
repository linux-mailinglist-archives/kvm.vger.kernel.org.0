Return-Path: <kvm+bounces-56365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29827B3C3B5
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63391A20324
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9824E31CA49;
	Fri, 29 Aug 2025 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TEv5pGlL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0EA194A73
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 20:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756498762; cv=none; b=ZoVrm12Q0Z+eceKoZuwkVDeGlhm6GtIjujDRyEjQPQuXrzCxapOziDt2sfTKfACGuF96C/RxH9V0aDlo1Yn85pOyS+kaDAsgdsuW9FYd/zZI8xAg+d1nO/d0sprMzcMUnKBhbq9e757rajGhon+SVcODF7s1rjC/TiTt8MKD8UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756498762; c=relaxed/simple;
	bh=FEKhz3ECVP3t58lSzNu8Ew6KLlvtFqxpG5No8XGjzjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E9NQH414KHl0MJ6iH3/LLCo83KrDxp84PU/oQvF7JNBxkUwo9jMpLtulL3AAozeqUypif62AfvvQR/qIWFauF/0iftfnz42wDbJ//ZXSXsFUTTwB6AhtPRvhvcouhPmworVenQaRpEpvzibqIkI8sQqEiVh48tCQalukd9dEo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TEv5pGlL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-327709e00c1so2616903a91.3
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 13:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756498759; x=1757103559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnp79aqzbIYGGf1SXSxq1GFs0tpvf1vdrgYVoIzkttM=;
        b=TEv5pGlLFgbwvAhF8JNPaWDTudqBMxNVXkBpDZAfmbIBeJtI257hpIPkbjUJlm2DPA
         HDAYxfGU/sxPLYdH63LSh/WtMdwJlXBZLviVab9FnARZ+ksoBSXXMUvex55Q0v3m/GmS
         K7/7NHuW2uzcBzBd5DGDNLUymzHIe84Z+u4vB2EOZOOX5K45MR8pXldbAn4EimZUOEz8
         ntDBdYe/Ub+57xmUMWep7PVh4SWepFBZpJWu80lM6vs5srQQJmQ3Y819nwQA7/Q8AdTV
         hBMCbnRWJIGmyXrcMGr6hzMH/7GmaIkYVQpF2kG+ROpVOmh2ceNp9zPJ8885dsodH+EP
         03rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756498759; x=1757103559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnp79aqzbIYGGf1SXSxq1GFs0tpvf1vdrgYVoIzkttM=;
        b=LUNj1kT3j0xecaOMbDnvT2DqTtIk+HqE00XRkDGCK6c+KArwivdiOdy+gC3qInYaKk
         TOge7IwJTT+kFPFIQyZMURF9u2eL4XoK3Vc9RsMYdkqXkimQURgB61LA49fNH7b7VLcI
         tDawCcnZHkQkqvPb2kw6IkmQnZf7r7iebVj6MgU3fio8ZT4ZW/ryKhf2AEx+i7o9Hz8F
         mr6ouV0xfcve8Rx6AVEG4wzH6sWyhqOufdTZg5oA57rdiLexxiuVJjOxAf2pq0DtT8m6
         VpoYdiAUlhzwe7qrleg8/tfgyEMxaFk9nBFgHXhKe1lSgXVcYmsM3r8u5zJt2TUP72h/
         5K0g==
X-Forwarded-Encrypted: i=1; AJvYcCVmM9GBmm45+2qeuwMdRSoezmh+02QPj6chrsqIWJjLjM8hH8halE43tTvLEcaE3IFhQDI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKck6KP1DXUh+Z18JZHhysNXXhbfhS9NrtuWVhLBOPRPHVjNg+
	gfRPQFe6u0jEcpKXEmHqc/XF9WB1YIL8f0D0GgCye/2ICL4s+cl7qlBFKVsUU325XBaHk1Y8stS
	HIXBvRg==
X-Google-Smtp-Source: AGHT+IHJmxUaulr8wCfRiTnOmBcHKcQFhF9RUASDG2WGqXOLSXBLpRmTBm5RPoY4I9DmIwCY7sXW+KdoBDU=
X-Received: from pjbpm11.prod.google.com ([2002:a17:90b:3c4b:b0:327:7035:d848])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b43:b0:327:ced1:26da
 with SMTP id 98e67ed59e1d1-327ced12a92mr6776764a91.36.1756498759596; Fri, 29
 Aug 2025 13:19:19 -0700 (PDT)
Date: Fri, 29 Aug 2025 13:19:18 -0700
In-Reply-To: <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-6-seanjc@google.com>
 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
Message-ID: <aLILRk6252a3-iKJ@google.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 17:06 -0700, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> > doesn't support page migration in any capacity, i.e. there are no migrate
> > callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> > kvm_gmem_migrate_folio().
> > 
> > Eliminating TDX's explicit pinning will also enable guest_memfd to support
> > in-place conversion between shared and private memory[1][2].  Because KVM
> > cannot distinguish between speculative/transient refcounts and the
> > intentional refcount for TDX on private pages[3], failing to release
> > private page refcount in TDX could cause guest_memfd to indefinitely wait
> > on decreasing the refcount for the splitting.
> > 
> > Under normal conditions, not holding an extra page refcount in TDX is safe
> > because guest_memfd ensures pages are retained until its invalidation
> > notification to KVM MMU is completed. However, if there're bugs in KVM/TDX
> > module, not holding an extra refcount when a page is mapped in S-EPT could
> > result in a page being released from guest_memfd while still mapped in the
> > S-EPT.  But, doing work to make a fatal error slightly less fatal is a net
> > negative when that extra work adds complexity and confusion.
> > 
> > Several approaches were considered to address the refcount issue, including
> >   - Attempting to modify the KVM unmap operation to return a failure,
> >     which was deemed too complex and potentially incorrect[4].
> >  - Increasing the folio reference count only upon S-EPT zapping failure[5].
> >  - Use page flags or page_ext to indicate a page is still used by TDX[6],
> >    which does not work for HVO (HugeTLB Vmemmap Optimization).
> >   - Setting HWPOISON bit or leveraging folio_set_hugetlb_hwpoison()[7].
> > 
> > Due to the complexity or inappropriateness of these approaches, and the
> > fact that S-EPT zapping failure is currently only possible when there are
> > bugs in the KVM or TDX module, which is very rare in a production kernel,
> > a straightforward approach of simply not holding the page reference count
> > in TDX was chosen[8].
> > 
> > When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
> > vCPUs and mark the VM as dead. Although there is a potential window that a
> > private page mapped in the S-EPT could be reallocated and used outside the
> > VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
> > information.
> > 
> 
> Yea, in the case of a bug, there could be a use-after-free. This logic applies
> to all code that has allocations including the entire KVM MMU. But in this case,
> we can actually catch the use-after-free scenario under scrutiny and not have it
> happen silently, which does not apply to all code. But the special case here is
> that the use-after-free depends on TDX module logic which is not part of the
> kernel.
> 
> Yan, can you clarify what you mean by "there could be a small window"? I'm
> thinking this is a hypothetical window around vm_dead races? Or more concrete? I
> *don't* want to re-open the debate on whether to go with this approach, but I
> think this is a good teaching edge case to settle on how we want to treat
> similar issues. So I just want to make sure we have the justification right.

The first paragraph is all the justification we need.  Seriously.  Bad things
will happen if you have UAF bugs, news at 11!

I'm all for defensive programming, but pinning pages goes too far, because that
itself can be dangerous, e.g. see commit 2bcb52a3602b ("KVM: Pin (as in FOLL_PIN)
pages during kvm_vcpu_map()") and the many messes KVM created with respect to
struct page refcounts.

I'm happy to include more context in the changelog, but I really don't want
anyone to walk away from this thinking that pinning pages in random KVM code is
at all encouraged.

