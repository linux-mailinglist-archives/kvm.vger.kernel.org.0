Return-Path: <kvm+bounces-72097-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEDeFQPMoGmlmgQAu9opvQ
	(envelope-from <kvm+bounces-72097-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:41:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E611B079F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66E0D303C59F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F017242849F;
	Thu, 26 Feb 2026 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LF9UHqKX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B71C285CB4
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772145653; cv=none; b=dqOeyCvi7+Yhefsic5ewMdAIZzV5cfX/NAmJSKueP/Mt7hXlBfKniMg58/ZnoJXDUPaVkTSMiS38c4I6DIkuk6g5mGoOBholuBP9TtvCklQIWE5U3S5KbStV2kKXbLXEDkYwPHgGD49I8w17RMAc3AZOXWaI8rfuKoY6PETKTr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772145653; c=relaxed/simple;
	bh=YJoNV5ibtXK7Fjn1qXoDZbyy5ckBfovJdK/fD1zKydE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F8RgpYac82EH0Ljj0ds+WFB0RzWK1ARROT40lhCCspX5jXiR6Vwcd4A8/208nbHRfS6QRT48XY6Y7UrcO+bk1lpbttGkn6Mq1fyhjnInleAqq3b1xobIzKmubz/Pr+0uCEX4ao2UB9wIFaemXsry4YyCljr9KyDbTnWmwxuDQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LF9UHqKX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adca7aba8bso11501485ad.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772145651; x=1772750451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NlR4d3dvmkzYuGlfHJDWO2utwy3AGmj/mSIZB1EeTfU=;
        b=LF9UHqKXA/rz1AhZ4f5r1Lv9dxlsTHn1CWJH6mj4G1Rje4dFvCw5iaNdYxHsvWFPvd
         1TKJu6H2/74cPcEmT2qnvCUH1/OK9WwX2Yh8d2KVdg81zCBCyDHFgGpSwyI5nasIEJx0
         kq0BqYK7+JmM/fwpbJiJauGXCGAwY+tuKDlPsZOTET2zHgrspdpvSI7HM2xcHmC262iX
         kRvbYFXaVfVoLw09bvD2j6T1jDLmOc1+utEmn6GPhdy4tYPHG183j61sAmV6tUEgUaro
         YoETwSyfyQj0DXyaJSUm4x6D7acVpl4OVXLeUjgQH7it8kscx52YVARHC8hGxaBrjrf5
         0phw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772145651; x=1772750451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NlR4d3dvmkzYuGlfHJDWO2utwy3AGmj/mSIZB1EeTfU=;
        b=dCWGFHo6LzsSxbo317bEHEsMZEIOLBLBkFAoduLSOeQg/rYrNwm/LcN3pFyPqz0kiy
         rzcRFgfF6LqT/ytfEaVK/3Oxmnyg/nCFa4q5wpV4mrqZ1qn0jO9edtqHoHtqcMAdhRQa
         ru4mcEKRpB34UtieMxBUsjCNq5WZj3QycsSQm2FKQCe5A/5c4BccoWm7z+LLWrDoDNk3
         gwy2ZTfs/XC/iZSuanxVWHLi/nS4NXzsMOIudUqk3RF31KlQuYp456rVWD/XXyf+xiCq
         IkmTw4iqZGxJMRxr2FCspHSlljWySucViaii8DvPE9adG70Dc6RAZHsrrOmVztsndbXv
         GldQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQgTRiodJZdkhQlZLnVKnp4K7ZF1F0NJJvCkSQKGGUKcoavjL9ykTHfo9ab0I7sOTV8DA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZXL7C7lySjj+FXQHDulJlMLxaPNjf+dJ7rVVjXfygjlKB3xtr
	gBigSRk9zfyLSSxHcUXVoT+vgFmA/WUppqgBdS4xaqLVB+IezcVDsHpdfM658csbswOZ29kKAG/
	UMgPxcA==
X-Received: from plfp5.prod.google.com ([2002:a17:902:e745:b0:2a9:62df:189d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2450:b0:2ad:e535:36ca
 with SMTP id d9443c01a7336-2ae2e3e3c85mr5360285ad.12.1772145651270; Thu, 26
 Feb 2026 14:40:51 -0800 (PST)
Date: Thu, 26 Feb 2026 14:40:50 -0800
In-Reply-To: <20260226190757.GA44359@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225075211.3353194-1-aik@amd.com> <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com> <20260226190757.GA44359@ziepe.ca>
Message-ID: <aaDL8tYrVCWlQg79@google.com>
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ackerley Tng <ackerleytng@google.com>, Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev, linux-coco@lists.linux.dev, 
	Dan Williams <dan.j.williams@intel.com>, Santosh Shukla <santosh.shukla@amd.com>, 
	"Pratik R . Sampat" <prsampat@amd.com>, Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72097-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7E611B079F
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Jason Gunthorpe wrote:
> On Thu, Feb 26, 2026 at 12:19:52AM -0800, Ackerley Tng wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Wed, Feb 25, 2026, Alexey Kardashevskiy wrote:
> > >> For the new guest_memfd type, no additional reference is taken as
> > >> pinning is guaranteed by the KVM guest_memfd library.
> > >>
> > >> There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
> > >> the assumption is that:
> > >> 1) page stage change events will be handled by VMM which is going
> > >> to call IOMMUFD to remap pages;
> > >> 2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
> > >> handle it.
> > >
> > > The VMM is outside of the kernel's effective TCB.  Assuming the VMM will always
> > > do the right thing is a non-starter.
> > 
> > I think looking up the guest_memfd file from the userspace address
> > (uptr) is a good start
> 
> Please no, if we need complicated things like notifiers then it is
> better to start directly with the struct file interface and get
> immediately into some guestmemfd API instead of trying to get their
> from a VMA. A VMA doesn't help in any way and just complicates things.

+1000.  Anything that _requires_ a VMA to do something with guest_memfd is broken
by design.

> > I didn't think of this before LPC but forcing unmapping during
> > truncation (aka shrinking guest_memfd) is probably necessary for overall
> > system stability and correctness, so notifying and having guest_memfd
> > track where its pages were mapped in the IOMMU is necessary. Whether or
> > not to unmap during conversions could be a arch-specific thing, but all
> > architectures would want the memory unmapped if the memory is removed
> > from guest_memfd ownership.
> 
> Things like truncate are a bit easier to handle, you do need a
> protective notifier, but if it detects truncate while an iommufd area
> still covers the truncated region it can just revoke the whole
> area. Userspace made a mistake and gets burned but the kernel is
> safe. We don't need something complicated kernel side to automatically
> handle removing just the slice of truncated guestmemfd, for example.

Yeah, as long as the behavior is well-documented from time zero, we can probably
get away with fairly draconian behavior.

> If guestmemfd is fully pinned and cannot free memory outside of
> truncate that may be good enough (though somehow I think that is not
> the case)

With in-place conversion, PUNCH_HOLE and private=>shared conversions are the only
two ways to partial "remove" memory from guest_memfd, so it may really be that
simple.

