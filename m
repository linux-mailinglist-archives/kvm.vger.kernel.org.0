Return-Path: <kvm+bounces-17862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D628CB485
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 22:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1C12282F57
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614901494C3;
	Tue, 21 May 2024 20:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TGrTax9z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECF91EB40
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321779; cv=none; b=q+vdUbRHGas15WElJHRjGAoBeQSbHaiRUNf4ZMWI2dLumxEQRTP5o2dkGssl4jLTNJLx+0r3s8gk40B85qFmOb7j30SBcAliM0Ry8TMVpsXbuyaB2Dvz+ndBrt+dGzUHXM3KDG1kJ5V8E2t8hGtafDB936kxE8irZ6EyV0t+658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321779; c=relaxed/simple;
	bh=iIAKgcqkrQku6Mr29zl/Q3Aq3+KvXVwIDxnt8qxjWcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X2LphUT6ccjfzfKN21Y/zbHlGRcf1a/jGKb29vUL1caNv1C1jKXkZOTxLBDbw8x1kpdgOFziOWeiotw8sJyd0Aj231vPmqbQ7zZsHtLBidasxYCQOFJHjjnSv32BM0ad4TcOhVGQJDvjfhEKgCGYb4dFhhrai8dUxHSct724PN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TGrTax9z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b38f3e2919so152985a91.0
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 13:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716321777; x=1716926577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z2y/OBkKxgzmvSuCRJlFU+1HEUO6FATvJsnEDlaTHY=;
        b=TGrTax9zbcNDUbLBxHleJWLVRommRaTHeZ7MtchmGSTapWxyg0608eh8SjanQ1+KS4
         C6MQ0fEKgnZ1ltX8uqYQXDvd2gFUdnq4qr86GVgPZDvMJVsbtHEhYLP7v/hlKXHs6p2O
         Vfn0iNyc4Wt1XxIzIio9x76UFxDw5WZuFF6Nk8I/bKVpPl57Dm4oi0gkw1kGiW8jPx7o
         bavfnYkzSLtKZse6MR4ngDAjzhb8wTJJCY8O7O9PEW/sZImXQAZP6K8ntW9uYLIPcvyJ
         KmZeezt0idsCVTokFhmd+bigDde/6/ZzEu424tfqxvfT8xER+NCwIKaHTLDmxicgDLWF
         wDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716321777; x=1716926577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z2y/OBkKxgzmvSuCRJlFU+1HEUO6FATvJsnEDlaTHY=;
        b=BHik3IOOz/deAu+tKwswY849M1gdCL7oFoIoYy6/1O1WeiDGQy/hvS77Ny2li/lqla
         dEVSwOFHOm5z2Ny26VO4BEELIt/arKod6GT6y2T707G4zLLvE/kng7jnB3ckCirCZ72v
         kzzMNiuOSIKcaofSvI3Sq8yDyEPpF6Z/pfds8sxL9by0IiE51JCD10WGfD9j4UT6s93e
         3Xva1sIhIbrhJDpUZbdrNUejn59nD/o026CrNIMnpwErdYLY8sgfwpOVafgd+a5Dp1pe
         52K/ZN5KZudx8WhHYcLmRENBj1O20HLkxIhRv2Qnd3NjQF9SqC7i15QGSJuW2tXqTyO2
         SV7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXab+QYTQFxZF0bnvZveGAz/JwKC1AOzu5qh+fFOJfdDqZqeC5d/Q+U2uz2nYxMhLGSrb2YJ8CaOeuFWf1COpUW8D33
X-Gm-Message-State: AOJu0YxcurWceXW45rHQHzG6z3C5HbyvMmFTIc62/kCSVnS9Rxfuz0XW
	GGLdGC5Bmg5aoF0VzvNZtk+e2OWrHroV20E0TwWz7wVbAH+cqnlvYK6KWEHZs7dpRYbHfGcefg4
	26Q==
X-Google-Smtp-Source: AGHT+IGc8AMfLKM+eg0g6UQUcqfUBCYk4fTqnxjiZdUzMhtJbdwzeQwWLJW3iNG9Bbk6zyIuCWPv8Gd0+4Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5384:b0:2af:b21b:6432 with SMTP id
 98e67ed59e1d1-2bd9f5c1a8amr520a91.2.1716321777329; Tue, 21 May 2024 13:02:57
 -0700 (PDT)
Date: Tue, 21 May 2024 13:02:55 -0700
In-Reply-To: <1dbb09c5-35c7-49b9-8c6f-24b532511f0b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com> <20240425233951.3344485-2-seanjc@google.com>
 <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
 <ZkI5WApAR6iqCgil@google.com> <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
 <1dbb09c5-35c7-49b9-8c6f-24b532511f0b@intel.com>
Message-ID: <Zkz97y9VVAFgqNJB@google.com>
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Kai Huang wrote:
> How about we just make all emergency virtualization disable code
> unconditional but not guided by CONFIG_KVM_INTEL || CONFIG_KVM_AMD, i.e.,
> revert commit
> 
>    261cd5ed934e ("x86/reboot: Expose VMCS crash hooks if and only if
> KVM_{INTEL,AMD} is enabled")
> 
> It makes sense anyway from the perspective that it allows the out-of-tree
> kernel module hypervisor to use this mechanism w/o needing to have the
> kernel built with KVM enabled in Kconfig.  Otherwise, strictly speaking,
> IIUC, the kernel won't be able to support out-of-tree module hypervisor as
> there's no other way the module can intercept emergency reboot.

Practically speaking, no one is running an out-of-tree hypervisor without either
(a) KVM being enabled in the .config, or (b) non-trivial changes to the kernel.

Exposing/exporting select APIs and symbols if and only if KVM is enabled is a
a well-established pattern, and there are concrete benefits to doing so.  E.g.
it allows minimizing the kernel footprint for use cases that don't want/need KVM.

> This approach avoids the weirdness of the unconditional define for only
> cpu_emergency_virt_cb.

I genuinely don't understand why you find it weird to unconditionally define
cpu_emergency_virt_cb.  There are myriad examples throughout the kernel where a
typedef, struct, enum, etc. is declared/defined even though support for its sole
end consumer is disabled.  E.g. include/linux/mm_types.h declares "struct mem_cgroup"
for pretty much the exact same reason, even though the structure is only fully
defined if CONFIG_MEMCG=y.

The only oddity here is that the API that the #ifdef that guards the usage happens
to be right below the typedef, but it shouldn't take that much brain power to
figure out why a typedef exists outside of an #ifdef.

