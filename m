Return-Path: <kvm+bounces-24839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E76D95BC8F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4770C1F2344E
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2C51CDFD7;
	Thu, 22 Aug 2024 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o5NM5+I8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D661CDFB9
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345927; cv=none; b=OcGjqU/fw4F76yl3NylyV/nGhOcdS3Q65Joduxg36bQ7JUbZgiSdxggWRJb+ggWPeVvVrFVbHsCdF3uN8NyRaav12s9jxC8tX15vQaTMxzJ6o1RI0827EwMe0V2KyaahXxfawpeJMhtVqRFQ3L2/UgK5J9isM8d8tozocaw7OxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345927; c=relaxed/simple;
	bh=UeomF2//hAwCF+QkX7m0LD9i0ymmYaQhD/LHrqSfOr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EHpx9Q5G058sMSFBLgu8HD/J/FNSf9F+6vKMeW5g9aO51wRRI1k4r6peBWPqAntnIsSNk4vx3ckIggvdUjRRjSZtmmugsMcHVa8q5r8tXmg5O93ufRhsIyY/T+Z9nhF/eBXC39JIZPWizszcq8l/CHpws2M4SXlYtJBP2yYHcHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o5NM5+I8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7c3da1ac936so454474a12.2
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 09:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724345925; x=1724950725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PnptKaBIwTlVutbudys0Nw5Cu09TSnmrnQQJzWGV6c8=;
        b=o5NM5+I8Px1XHFS8zSMcYEKneea7C3sW4Anl+GALFbdc8W7jzIxocKi4/uKfkDzxkj
         ueyR3JeYe3oeAmNJyEf5n3rPKWxA7MycA1dlmV6ebWAV8ct8p8k9XmLbLWh5M30tTMvR
         /YJQfi7k0Xl6XA5ddm/XKjvPZFYnOO/uQ/gCAC1eSPgzzxFSxmvVtIF+aAYXzoPFwKl2
         ggSVcE3e+2P5jW+0ENVvotAaT10ynT/VvWiP58thkA3R22ExGFKLax4HUwJrWkGp4ISs
         r4OIkzomWGDRFOXnLZGXlsoXJUgZmWj5VC26mpkqoSOXmkLpi0KaIlLffmJMghJ44m4B
         YUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724345925; x=1724950725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnptKaBIwTlVutbudys0Nw5Cu09TSnmrnQQJzWGV6c8=;
        b=IdzSfTMajqva2u0CB7JiDBjGlqRNxGv74h6eLO6vq6X/VrN1AvjO1woUbVTqTiOso0
         8JpKHdokbXAf+UfIAomhd5Bc4cMvlhbX5RvThaWqf/3I4ky7QBpAvCfih/Y++WsrlpaD
         PaOyUz1lz4BTV+EkcaU3sKqK2IQYQh8uNE+HdKCo0GvrohFK3duvS4EF1b18SC1FiAi5
         gjwtsS61Ch58dzXyvC0pzkrU4Fk0uWUNEUOy1WzKk4HXc8R2qJ7KFztgL6sCyxo123A9
         6ALdgeIwCNSnZOBnGsZwaSq52gu0lsgd9YsVnFknzWYjfX9xqcUBkBt5GhiCRi8Nibdi
         W/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXEu7IrLR0PaO85JbKegWyvO5u1XM0S7BHaweqfJhT+0Q+0GeSw6NG8MQEJNapDsT498Q4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9p8nuek7eTT1+twSPPAoAWW1qZP/ZjBtbNEeuwbmPU0kHMLOu
	1wLczd3DCtN2JTg0StFcv3cEh9udritS9S2t/2t63qlLPvGaeideidK/HuUv7r4E0FOVUtuPIRM
	0IQ==
X-Google-Smtp-Source: AGHT+IHwvoth9fT1Z/DL4U24HgtU5PZ34fwWotGULJe3J4WG7tBh6KRt8uzZjRmfX56Dy8PjGUScXSTTOtc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:64ca:0:b0:6e3:e0bc:a332 with SMTP id
 41be03b00d2f7-7cd88b70338mr16399a12.2.1724345924436; Thu, 22 Aug 2024
 09:58:44 -0700 (PDT)
Date: Thu, 22 Aug 2024 09:58:43 -0700
In-Reply-To: <D3MJJCTNY7OM.WOB5W8AVBH9G@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240609154945.55332-1-nsaenz@amazon.com> <20240609154945.55332-17-nsaenz@amazon.com>
 <D3MJJCTNY7OM.WOB5W8AVBH9G@amazon.com>
Message-ID: <ZsduQ7tg0oQFDY8h@google.com>
Subject: Re: [PATCH 16/18] KVM: x86: Take mem attributes into account when
 faulting memory
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	graf@amazon.de, dwmw2@infradead.org, pdurrant@amazon.com, mlevitsk@redhat.com, 
	jgowans@amazon.com, corbet@lwn.net, decui@microsoft.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	amoorthy@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 22, 2024, Nicolas Saenz Julienne wrote:
> On Sun Jun 9, 2024 at 3:49 PM UTC, Nicolas Saenz Julienne wrote:
> > Take into account access restrictions memory attributes when faulting
> > guest memory. Prohibited memory accesses will cause an user-space fault
> > exit.
> >
> > Additionally, bypass a warning in the !tdp case. Access restrictions in
> > guest page tables might not necessarily match the host pte's when memory
> > attributes are in use.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> 
> I now realize that only taking into account memory attributes during
> faults isn't good enough for VSM. We should check the attributes anytime
> KVM takes GPAs as input for any action initiated by the guest. If the
> memory attributes are incompatible with such action, it should be
> stopped. Failure to do so opens side channels that unprivileged VTLs can
> abuse to infer information about privileged VTL. Some examples I came up
> with:
> - Guest page walks: VTL0 could install malicious directory entries that
>   point to GPAs only visible to VTL1. KVM will happily continue the
>   walk. Among other things, this could be use to infer VTL1's GVA->GPA
>   mappings.
> - PV interfaces like the Hyper-V TSC page or VP assist page, could be
>   used to modify portions of VTL1 memory.
> - Hyper-V hypercalls that take GPAs as input/output can be abused in a
>   myriad of ways. Including ones that exit into user-space.
> 
> We would be protected against all these if we implemented the memory
> access restrictions through the memory slots API. As is, it has the
> drawback of having to quiesce the whole VM for any non-trivial slot
> modification (i.e. VSM's memory protections). But if we found a way to
> speed up the slot updates we could rely on that, and avoid having to
> teach kvm_read/write_guest() and friends to deal with memattrs. Note
> that we would still need to use memory attributes to request for faults
> to exit onto user-space on those select GPAs. Any opinions or
> suggestions?
> 
> Note that, for now, I'll stick with the memory attributes approach to
> see what the full solution looks like.

FWIW, I suspect we'll be better off honoring memory attributes.  It's not just
the KVM side that has issues with memslot updates, my understanding is userspace
has also built up "slow" code with respect to memslot updates, in part because
it's such a slow path in KVM.

