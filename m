Return-Path: <kvm+bounces-20191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31454911710
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659351C20C9F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA9715B106;
	Thu, 20 Jun 2024 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEdyHzab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B531E15957E
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718927644; cv=none; b=i2zSR0KtT7nRuJ87wnx752UQiSdQPIMyVOqgw3sbgfiCha/5c2enATxWS1LHN1SdvhWe8NBXvPiONA7gR1rNghkvg4SJeV2PuvIJ55uZAo2ddtrBuP5Rpsi3pdNBzzpYaflA8hZONjLvvHW9gcnOiafZ3UeDx0MQ7JsNsU+1K+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718927644; c=relaxed/simple;
	bh=6Kw4I2gz47xBlSWU1bCHtbmt7t3vLNmf2vRXulDomGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JIR1zb1m0AX3ln6LHnMsz45mTzytAFqrQYNz9ls54vslGI+MNgQQLUjSIrA4XK7OIP/cI+rgGO6VoIBCL7sSEkUUH79TusUABZV+EaujrWXwrtvVH/QAogpekOwFNP/P62BeOKlvL4sKJn00gZINGTaxfR+fUngU3iePFBkiWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEdyHzab; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62d032a07a9so24598747b3.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718927642; x=1719532442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0cRQk7/XDy8pfU62IMrgS6+Av/DI0qRpfb94ZPZk38=;
        b=zEdyHzab9YYFEYAfspfHy/bz91yL58XO6vRgPkH76Ggy/AH38yBQhingLGl+9McGgf
         2Px74oC3hlanRyJHv5OdfvK4SGwxGV4BZqYy9BNp37AJZN6FiWM4QcYu+fjII3NQwW27
         wKgoDDnFlzn/8K1Qf3jmfML2qObWpHJi0YBolBeoT0yt3ASxki5RIr+tkhKI/d2Dk1Az
         nrk0aHcsOAMm2eaot5hm/7D/FDiH05wyv1wiG18kY8WQXAT+WnSjzlVW8kLBH8t+QBMd
         OuceQmJulS5lfDgVXIqfJVW6N1sBFzusKtMr60hAdzf7rigkd+esCiA5xNESSiU2KFSR
         oh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718927642; x=1719532442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0cRQk7/XDy8pfU62IMrgS6+Av/DI0qRpfb94ZPZk38=;
        b=Dm2uYilZVRrEwnzXW5iNJAO+WuH2FYI4aoKPtgU3b/BYsnPjNcrgEsmkpf6qPo4XYR
         +y2esOrnnniN5verWVv5AOonRzGFlqwm3pq0j2nU4jG7UJHRd0fN3g67n37ElcNXl5Wc
         rmIBhoCjY7JHE9HAC/JZqd9tSzrKtZTeTD4oegMDSl7ldFd8tD1UPXQQXRMXPe7w73xE
         Fu8oezgDLgmHu7OaT2UeIgmAJ98wbQxGX2QOCBYBrUaueIoCCn7Pbfo0ckGXvwYJwNZw
         BS4M6BLui0Holj12D+iROM+86vL4EkeY9LwJV5XCcqPgT0y7aRRVR1voqHzq08kjulLo
         ti8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLvEU9l2uI1300zs5tdbClJ43MLXzQ1tCV2otKq7rA/F94mn1FXDbF1QGdPP+VVcfAESrivKNHR8pgb16TjpBYlNvN
X-Gm-Message-State: AOJu0Yw8qalqX/ZzoXGvoNDFhBWe/a6YpkwxfWWTPjrm5/9OR9wX14WI
	Y2tf/ibECJIj/EA6+BzL6euEGcHtuIooCfsXlITcq5ePDWfMmSooNPv4Sipq2H2bUV4psTnFQjX
	Kig==
X-Google-Smtp-Source: AGHT+IFqao5Na4T3rzYX1N/evGid4F+5vGCBEQVSEibXvNgi7IKeL5G0APBP0MUgJnp7hbOtvkBt0IPXmEs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:943:0:b0:dff:2f78:a5d7 with SMTP id
 3f1490d57ef6-e02be130582mr1296664276.5.1718927641763; Thu, 20 Jun 2024
 16:54:01 -0700 (PDT)
Date: Thu, 20 Jun 2024 16:54:00 -0700
In-Reply-To: <20240620231133.GN2494510@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZnOsAEV3GycCcqSX@infradead.org> <CA+EHjTxaCxibvGOMPk9Oj5TfQV3J3ZLwXk83oVHuwf8H0Q47sA@mail.gmail.com>
 <20240620135540.GG2494510@nvidia.com> <6d7b180a-9f80-43a4-a4cc-fd79a45d7571@redhat.com>
 <20240620142956.GI2494510@nvidia.com> <385a5692-ffc8-455e-b371-0449b828b637@redhat.com>
 <20240620163626.GK2494510@nvidia.com> <66a285fc-e54e-4247-8801-e7e17ad795a6@redhat.com>
 <ZnSRZcap1dc2_WBV@google.com> <20240620231133.GN2494510@nvidia.com>
Message-ID: <ZnTBGCeSN1u6wzLb@google.com>
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>, 
	Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>, maz@kernel.org, 
	kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Jason Gunthorpe wrote:
> On Thu, Jun 20, 2024 at 01:30:29PM -0700, Sean Christopherson wrote:
> > I.e. except for blatant bugs, e.g. use-after-free, we need to be able to guarantee
> > with 100% accuracy that there are no outstanding mappings when converting a page
> > from shared=>private.  Crossing our fingers and hoping that short-term GUP will
> > have gone away isn't enough.
> 
> To be clear it is not crossing fingers. If the page refcount is 0 then
> there are no references to that memory anywhere at all. It is 100%
> certain.
> 
> It may take time to reach zero, but when it does it is safe.

Yeah, we're on the same page, I just didn't catch the implicit (or maybe it was
explicitly stated earlier) "wait for the refcount to hit zero" part that David
already clarified.
 
> Many things rely on this property, including FSDAX.
> 
> > For non-CoCo VMs, I expect we'll want to be much more permissive, but I think
> > they'll be a complete non-issue because there is no shared vs. private to worry
> > about.  We can simply allow any and all userspace mappings for guest_memfd that is
> > attached to a "regular" VM, because a misbehaving userspace only loses whatever
> > hardening (or other benefits) was being provided by using guest_memfd.  I.e. the
> > kernel and system at-large isn't at risk.
> 
> It does seem to me like guest_memfd should really focus on the private
> aspect.
> 
> If we need normal memfd enhancements of some kind to work better with
> KVM then that may be a better option than turning guest_memfd into
> memfd.

Heh, and then we'd end up turning memfd into guest_memfd.  As I see it, being
able to safely map TDX/SNP/pKVM private memory is a happy side effect that is
possible because guest_memfd isn't subordinate to the primary MMU, but private
memory isn't the core idenity of guest_memfd.

The thing that makes guest_memfd tick is that it's guest-first, i.e. allows mapping
memory into the guest with more permissions/capabilities than the host.  E.g. access
to private memory, hugepage mappings when the host is forced to use small pages,
RWX mappings when the host is limited to RO, etc.

We could do a subset of those for memfd, but I don't see the point, assuming we
allow mmap() on shared guest_memfd memory.  Solving mmap() for VMs that do
private<=>shared conversions is the hard problem to solve.  Once that's done,
we'll get support for regular VMs along with the other benefits of guest_memfd
for free (or very close to free).

