Return-Path: <kvm+bounces-59589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E54BC2243
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 510944F6E9D
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4692E8881;
	Tue,  7 Oct 2025 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rnp7i08F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183301862A
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 16:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759855383; cv=none; b=alfy8GQ3fy6gonAPTi8ZI104W6a0pXLrAPHbIRXdmV1RDbsCsupa9CGn1Kf0KlsmmJOr4bj4GcCLURdXf6Xhzo+8njwdwnTag8U8RIacFy46Rv1GZ0KajYC6o0nRyTRNlFjHYT/T64LFfyugKX4oC5xK197URMB9MITpylkofwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759855383; c=relaxed/simple;
	bh=1I3jSACvZj52dzAKxBDeApC+0iug0xrEx1kH0ZI8aYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=trg30HeOcZ8Lhb/ugIA4ay72xEtBTOKVY7/g3JQJosf5SprtLHbAeMHTP0APo4VVuTeZxomWbwcqtFoGJWRRP31mE0kwtHgaEb1DqIUb61J3zga4wCcDdhk34rDr6MpTMaHHWKia59TqBzSv4j4vznKS0iw5yr4G9PhcKUKn17E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rnp7i08F; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso7435981a91.3
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 09:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759855381; x=1760460181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oz1jqWWg+SoU/ogJkFuXFKT4EoUpLm9W9ZKhzFV4aIM=;
        b=Rnp7i08FH5hsPPSFGN/v6iRO/MXIEcLiJ4PmGA/w0+mVOCVNZ0AoAjPnk+frHepdtm
         WVU7GRLTegLRsaUO3DZQ6Jl5A1doyoAAiUzMlLgyHqZW5ueheYEUcESmGTmGpBuEH6rw
         waxNxezWH+ly+LPQ6f/Hl6OjCmu5iaGd6cL1U2H84RMUlCu81RLzpTumoVzHVYc3WNDR
         Mi4+45d+B+rEepaFGeqYKlCE4iAdEipOUipqWk95C/dXi2Uc1Oyyjly70z/mRgiRT+xu
         OGDSqdUHQhahzMLn3DkNjb2iSwu1cQAFZ3iHI2JfZcBEgpL/u1bZofqwlVQfVoHB1ZiC
         k3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759855381; x=1760460181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oz1jqWWg+SoU/ogJkFuXFKT4EoUpLm9W9ZKhzFV4aIM=;
        b=R4tf9mtTOpr1izh44sRSUiG7a8Hcmr152NlDE0nMGR2aDcjC30kgT1m5LwP5vCcxXk
         lET2Q/5PkRRtisvLnGo5w/pjkmBdixXqs+wJcaLoV3/vPabmuQ52EY0gMfWHHVTFlBoj
         7Qy0yjmkulnSDMEGEpyVRFTXYLgxxvHmd/SNwCn7yRMS+x7jkP/DIX1WmWg5X1kcynUc
         7X4cWENaGN75YIPNWVSZDrGDSd7XyHQplIuRHF0/kOSBNkhtsig4/lU9iDOn+9GdPP/m
         5ul/Ic1tTKuKrBuv+urs0ytNI6ePty7MJbWxa6qygqL2e1lZepcUuMD3K/Odzoo7iJgz
         kpxQ==
X-Gm-Message-State: AOJu0YzVbxA3ondlo6IApI9UYXDKoQ0B3wOh9CMsU6gaXPoWq09gTUof
	AIMQrcJP6K+HKum3eTrE1PJLtkygNmYgVrp3XYGeteh++odbfuhnQI1efJJRkdUd1RzWSbXJxdp
	tIp+z4zBb/LqQ9J6ALZ7UZNVHeg==
X-Google-Smtp-Source: AGHT+IGb5pFhL/AY+MlAKGnk7BkcIMmIEce49PNrjagW8tb9GwlMHqoxNKHixhepMoCTL/8Y4mkXl0xkoJXBngxvww==
X-Received: from pjbhk16.prod.google.com ([2002:a17:90b:2250:b0:32d:dbd4:5cf3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3846:b0:32e:87fa:d95f with SMTP id 98e67ed59e1d1-33b513eaae0mr109039a91.32.1759855381473;
 Tue, 07 Oct 2025 09:43:01 -0700 (PDT)
Date: Tue, 07 Oct 2025 09:43:00 -0700
In-Reply-To: <20251003232606.4070510-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-6-seanjc@google.com>
Message-ID: <diqz7bx6ek8b.fsf@google.com>
Subject: Re: [PATCH v2 05/13] KVM: guest_memfd: Allow mmap() on guest_memfd
 for x86 VMs with private memory
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Allow mmap() on guest_memfd instances for x86 VMs with private memory as
> the need to track private vs. shared state in the guest_memfd instance is
> only pertinent to INIT_SHARED.  Doing mmap() on private memory isn't
> terrible useful (yet!), but it's now possible, and will be desirable when
> guest_memfd gains support for other VMA-based syscalls, e.g. mbind() to
> set NUMA policy.
>
> Lift the restriction now, before MMAP support is officially released, so
> that KVM doesn't need to add another capability to enumerate support for
> mmap() on private memory.
>

Also thought through this: before this series, CoCo VMs could not use
mmap, but that's a tighter constraint, relaxed in this patch.

The actual restriction is that private memory must not be mapped to host
userspace.

In this patch series, guest_memfd's shared/private state is controlled
only by the presence of INIT_SHARED. CoCo VMs cannot use INIT_SHARED,
and hence cannot have guest_memfd memory that has shared status.

CoCo VMs can only use guest_memfd memory with private status, private
memory can't be mapped to host userspace, so we're good in terms of CoCo
safety and keeping the original purpose of guest_memfd satisfied.

> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  arch/x86/kvm/x86.c       |  7 ++++---
>  include/linux/kvm_host.h | 12 +++++++++++-
>  virt/kvm/guest_memfd.c   |  9 ++-------
>  virt/kvm/kvm_main.c      |  6 +-----
>  4 files changed, 18 insertions(+), 16 deletions(-)
>
> 
> [...snip...]
> 

