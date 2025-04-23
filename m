Return-Path: <kvm+bounces-43970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43350A99305
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5D414A2159
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A3D28EA5C;
	Wed, 23 Apr 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMdCxPPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C126A08C
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422222; cv=none; b=ifVoPrvcjG1zw/0ujNVGoJCmnl9xF9s2ZdTEBb3cCqumyk0nJUT4UdLKAnpdefKkPgzv1s66zgzNXKh0pCuKt8WjocEV4JXKezycOzGsn+MNy9zNnGGYue8SG8Aek4owfxlD0KYF60sUFLER+bPI+sNKo+hOt1ES9eCu7SZ85NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422222; c=relaxed/simple;
	bh=Vq6vhsxs40tP9d5NlmjPRy8NhwbWi1gHcz6l7t5TzC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tWkLPx8t2X6p5N7VHVAFRGR7wpxgkKuGWXUIuXDpsjTRFXrdY/7vk4bjUd09VT1ABVlhIFC8vYZTX5FjAkBmLvYo6iE/e4Zo3oK66g0qhTl+TaKiB7+o6baci09wAJSLhEkBFms8akN1hTmOJS0iF+m1LdkXq/dsvDcCdmLyoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xMdCxPPM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224364f2492so57547775ad.3
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745422218; x=1746027018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RuF5aM5uvUzwQnspTEzQdS23ITC9dWctjltafpb1GqA=;
        b=xMdCxPPM5ihdKRIpdHW5+de76Nle+U9DtelaxlpWiaIU31i5ZgcUp5PVyllBDYq0NL
         RARdQK2Pwyv98sbDvDt14RcOoGqg8+zrLOZYGKoTP96jBYBE5sECjssCrooqKH0jOclu
         QvWZ4K3kHU2LGEQ+KSwkky9xjc/Lvro1hw5EVtQ3KTbXd1GPurerOQxw/+L3gRnpPEJP
         pmcGZbGT+dTojTUD+gpZmI1bwxSeogjnlcZdgp+X1oUZhssq50clE9693ZpSjtr3nNZ6
         vbsZipsqNo59nrdFFqSd+kBpPNOuAiTEiCaslQdv5ZMGnpU7yoLrgCvrRwEbmtPMaPI4
         VOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745422218; x=1746027018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RuF5aM5uvUzwQnspTEzQdS23ITC9dWctjltafpb1GqA=;
        b=eXVoRXhIihZW0zyuyD4QkevVytoDL0u40ek8YEIp8Fy6S797gnpjwM2d8aAJzBqopE
         0shdMEXXg1R+cRatlUhQ3BJGTLTFlmNqaUG2IqN4jGd1Sme05KVy1fXepT9fLdeGyxYn
         7LfRpn2lZwL4HSUaSc+tUiGG9wMoIDPLP0/bb726biIMMc3p9xlETteZAfK+kCQ62XAf
         iE+ASrC6uAIlTav+xJW9b0671gOyq5LU/ZxkXfvpVKTNlU/cqbeJiN+HloPunDbQytww
         dvrBIYIkV/9AsPqL3jF1+252SVDw8XAQHs6X77l0Pnm38RwlspNseeqanA7cXN6Ms9vs
         dSvA==
X-Forwarded-Encrypted: i=1; AJvYcCWrmx/KZaEaHaBrGrXzl3ACWxjTl99Jvg4TJwvLlRVu/9+/mcOiYeTyoXiJM0hAGxGfbKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2LXcEzXktmRD9Ot4iftyWCB43n8kF5+iz+DdkJ4hPrpURhmm4
	lu0Cg+Gphzb2KLxARCjYWKtbzvMrOAJp73PGokXNMTEzPIOfPDscNWj/oiufm2WCbL/roZCIGsO
	s2A==
X-Google-Smtp-Source: AGHT+IG3ZfaZuHuLl6tG9igc6TROAYnGCS+93+i2EnpH5jq21Q97uLnrdJpiHpiNCS7xZFVke3MttxhmyUA=
X-Received: from pllb3.prod.google.com ([2002:a17:902:e943:b0:21f:14cc:68b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88f:b0:220:f151:b668
 with SMTP id d9443c01a7336-22c535815admr231239285ad.20.1745422218189; Wed, 23
 Apr 2025 08:30:18 -0700 (PDT)
Date: Wed, 23 Apr 2025 08:30:16 -0700
In-Reply-To: <5fb4f5f8-55d2-44a7-808e-76c8a452cd2f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324130248.126036-1-manali.shukla@amd.com>
 <20250324130248.126036-5-manali.shukla@amd.com> <5fb4f5f8-55d2-44a7-808e-76c8a452cd2f@intel.com>
Message-ID: <aAkHiL_N7QGND8Tj@google.com>
Subject: Re: [PATCH v4 4/5] KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT
 on SVM CPUs
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, nikunj@amd.com, 
	thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 16, 2025, Xiaoyao Li wrote:
> On 3/24/2025 9:02 PM, Manali Shukla wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 5fe84f2427b5..f7c925aa0c4f 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7909,6 +7909,25 @@ apply some other policy-based mitigation. When exiting to userspace, KVM sets
> >   KVM_RUN_X86_BUS_LOCK in vcpu-run->flags, and conditionally sets the exit_reason
> >   to KVM_EXIT_X86_BUS_LOCK.
> > +Note! KVM_CAP_X86_BUS_LOCK_EXIT on AMD CPUs with the Bus Lock Threshold is close
> > +enough  to INTEL's Bus Lock Detection VM-Exit to allow using
> > +KVM_CAP_X86_BUS_LOCK_EXIT for AMD CPUs.
> > +
> > +The biggest difference between the two features is that Threshold (AMD CPUs) is
> > +fault-like i.e. the bus lock exit to user space occurs with RIP pointing at the
> > +offending instruction, whereas Detection (Intel CPUs) is trap-like i.e. the bus
> > +lock exit to user space occurs with RIP pointing at the instruction right after
> > +the guilty one.
> > 
> 
> 
> > +The bus lock threshold on AMD CPUs provides a per-VMCB counter which is
> > +decremented every time a bus lock occurs, and a VM-Exit is triggered if and only
> > +if the bus lock counter is '0'.
> > +
> > +To provide Detection-like semantics for AMD CPUs, the bus lock counter has been
> > +initialized to '0', i.e. exit on every bus lock, and when re-executing the
> > +guilty instruction, the bus lock counter has been set to '1' to effectively step
> > +past the instruction.
> 
> From the perspective of API, I don't think the last two paragraphs matter
> much to userspace.
> 
> It should describe what userspace can/should do. E.g., when exit to
> userspace due to bus lock on AMD platform, the RIP points at the instruction
> which causes the bus lock. Userspace can advance the RIP itself before
> re-enter the guest to make progress. If userspace doesn't change the RIP,
> KVM internal can handle it by making the re-execution of the instruction
> doesn't trigger bus lock VM exit to allow progress.

Agreed.  It's not just the last two paragraphs, it's the entire doc update.

The existing documentation very carefully doesn't say anything about *how* the
feature is implemented on Intel, so I don't see any reason to mention or compare
Bus Lock Threshold vs. Bus Lock Detection.  As Xiaoyao said, simply state what
is different.

And I would definitely not say anything about whether or not userspace can advance
RIP, as doing so will likely crash/corrupt the guest.  KVM sets bus_lock_counter
to allow forward progress, KVM does NOT skip RIP.

All in all, I think the only that needs to be called out is that RIP will point
to the next instruction on Intel, but the offending instruction on Intel.

Unless I'm missing a detail, I think it's just this:

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5fe84f2427b5..d9788f9152f1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7909,6 +7909,11 @@ apply some other policy-based mitigation. When exiting to userspace, KVM sets
 KVM_RUN_X86_BUS_LOCK in vcpu-run->flags, and conditionally sets the exit_reason
 to KVM_EXIT_X86_BUS_LOCK.
 
+Due to differences in the underlying hardware implementation, the vCPU's RIP at
+the time of exit diverges between Intel and AMD.  On Intel hosts, RIP points at
+the next instruction, i.e. the exit is trap-like.  On AMD hosts, RIP points at
+the offending instruction, i.e. the exit is fault-like.
+
 Note! Detected bus locks may be coincident with other exits to userspace, i.e.
 KVM_RUN_X86_BUS_LOCK should be checked regardless of the primary exit reason if
 userspace wants to take action on all detected bus locks.


