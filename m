Return-Path: <kvm+bounces-39922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 276D4A4CCE9
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 21:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39CBC18954F1
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 20:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206C12356AB;
	Mon,  3 Mar 2025 20:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzk4nyqB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB38211CA9
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 20:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741034990; cv=none; b=ZyR+/k2fDifqL5k78i6e8T3Wp73RRm/+ZrnGU3veJtHU2XL7ZhGb189B2cN676q/T9qwLuzIWqx0I5ExlIAgnRjB/417Kytin98O7+TM2ger4T9fOQz4nGglkmKKr+E1F/cpWtgrEraFamKWGuEclHlSmg+Bm6y/7Pl3+Au6+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741034990; c=relaxed/simple;
	bh=b9+l60C5FmoVBcnZ+2dbkAJ08foGGzMBuHGxYh0c6wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FrkzDBznzFbEgO2ymBTH4erzEVXQjpdRmZ+NCoiiH6KlESw+oeOm0rl8JksEJWDStfE4hdqSeKChS6Q89m1PBridjygd8YiaExFPs/MyyNGJRm+bMDYBaq8vXwRNU93zA5i69k+2Q1HDJ4zy8UTU9JFF0XJjf6hfG9UlEQDpTXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzk4nyqB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22387acb40eso69077325ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 12:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741034988; x=1741639788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rX5WpwWoXZ5gyhXwc+nu9BIgzZ5Qej6ZgjHIIk8ELGc=;
        b=hzk4nyqBgWEG/Yk3cTUxdyOvTKBqEBsK9uuJDEodkyKAwFYoV6v6Yi9CSI2kC3vdjn
         iHO+bnP/aMRdAjmzP9MDTku1jR9qDZ9Xp9kCfiRBL1yYMDfImF9H7Gq39jKX1XBFqyF4
         SXucn8l7CFxAu1D1foErcjxHBt1qAJg124RIplkaIL2U8jq97qV8LWOZdCWZV9LxWn91
         QoEO9SF8K9xyMLXz4ia+GGHf0flxQ0E1IOdvSjoag0rfscFmXCjZ7rde9BqPAhMoTJv6
         Z8g2jSR1Hfdjn/u1rmD+3P1qHqMXts2yjdUUK9cj934Xhr5I0A6d7FVKBPQEsbTycMMA
         /BqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741034988; x=1741639788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rX5WpwWoXZ5gyhXwc+nu9BIgzZ5Qej6ZgjHIIk8ELGc=;
        b=ahqF/aEDXv91AOE+D+X5opfLRZ2etVB3G2WFhg9ZKNFO853T6DXEAgvRgBzn4l3tU+
         ocWXboPUbffXN5TY78RcQyndL3ztlV+FnQJ2/jkhK7QwagjvT7zw5Vu3WZ0h+c03s6Iz
         sEYeHm6Yst3tWevoZTRASaGklAFA7X1X0rnTRNpbfsT8iRxdHVGF4GgTU1k4u9SULI5h
         3XfqPO8EWntLJcU6pwLi0XwdTE0aiL8ZE7wqoJ8goKBGsLtzLWuSIEJWlngcLNYy+t42
         fDHDsdRECIIKqoWCjfvaxa8PWHhUwXkR3/zKHCrI7yC3MrJd2TiAOw3zFkUEGlO+re/a
         QfOw==
X-Forwarded-Encrypted: i=1; AJvYcCXjp+fBack2ZFa5I5bZL3WZLCcdad6k8m203VDBwT2K5HXGZLnUr3g0h92olaqEljZ8m5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT5a0vUDBjm2NhcNPp47GEhQ28q2fkxVXsX/yTo7GjZiXXxXGW
	3JYrfXSoR8ivyn3pgy6PFwwWQIoilTyYXtfStOad5Wbz9KINQnQ0Hrzipbqe5XdeQZVFVltHuYq
	vhg==
X-Google-Smtp-Source: AGHT+IE+C6JcZdh5hffwpn3YaLy4DTdjGMQWY0Wxr9tX8RPUF4fmhR1pHZq+6TPiOW5dJqi6J/yP+vTUj+Q=
X-Received: from pjbqx5.prod.google.com ([2002:a17:90b:3e45:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc4e:b0:220:c4f0:4ed9
 with SMTP id d9443c01a7336-2236921eb6amr236795425ad.45.1741034988314; Mon, 03
 Mar 2025 12:49:48 -0800 (PST)
Date: Mon, 3 Mar 2025 12:49:47 -0800
In-Reply-To: <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740512583.git.ashish.kalra@amd.com> <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
Message-ID: <Z8YV64JanLqzo-DS@google.com>
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 03, 2025, Ashish Kalra wrote:
> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
> > On Fri, Feb 28, 2025, Ashish Kalra wrote:
> >> And the other consideration is that runtime setup of especially SEV-ES VMs will not
> >> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
> >> KVM setup time.
> >>
> >> This is because qemu has a check for SEV INIT to have been done (via SEV platform
> >> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
> >>
> >> So effectively, __sev_guest_init() does not get invoked in case of launching 
> >> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
> >> sev_hardware_setup().
> >>
> >> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
> > 
> > In that case, I vote to kill off deferred initialization entirely, and commit to
> > enabling all of SEV+ when KVM loads (which we should have done from day one).
> > Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
> 
> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
> 
> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
> DLFW_EX.
> 
> We still probably want to keep the deferred initialization for SEV in 
> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
> case.

Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
casing?

