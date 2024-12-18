Return-Path: <kvm+bounces-34078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C489F6F4E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 22:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4990B18915D9
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 21:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351CD1FCFD2;
	Wed, 18 Dec 2024 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tZktQvlx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC941FCD15
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734556445; cv=none; b=Qh+Vu0TYrGpM+ZFxEDqqJhysDaNJ9/LbN0o9QVXONGCdiIM5qB/J9cB9ArL2ydDlbjFJr05K0GnxMh9D97ZIxu9/MZMvrIezmqjdP82s1d3hEWjJfQzvaDrJcG30xwtjzPAhh+UpDFw7CM7Hi5iO8R3mRzi539U72+x2XYKJcFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734556445; c=relaxed/simple;
	bh=QMtEY8un4mt1jfO19haGD4G/VxR/ngferKpt3tOmycg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eBNJXrjyFwnr8ghB3dFIEAlZUzccmHqlUQXWE3Ioci9fq3ijXFuIjk//TZHLqVSvWAcOceit64L5OerPm1HSuuzv9nFzF075DhcBPLfBwv89X5HukOiQq3IUo64xPl0cSrsK963e8pD/28LqkSBeTGVQArbbNNntGSYNGQWiDF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tZktQvlx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so92962a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 13:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734556443; x=1735161243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lA/iM2V/+XmvBKcMHUbv+t9aXqGsPH0HbYDBmDEH3d8=;
        b=tZktQvlxxMrYEDwxqJaD5eA6tWue3zF/9i2CoJUDWhWJ+3HE0SxXA6vWX8hFJq/omM
         uO38Zp1pctmYwp/qpxN5ttKFyVsmIyouBQHsst610gFdHoJ8s7tm1Ka/pOeP3V4no1+U
         x/7r81NGJEFo13ojZCdaLHosybTQ+mb6kzmqRvF+vpvB8/2zalw23QiL4s93Z5ZpvkDh
         1BMt5MfJ4OrFlj744dUkfjrDJLPOzuVqW4KtNc4258j6AfkTLh0uEV9H+PKy4pds3yWT
         RWlwpKoK379bCj16oR4tNSBNYQaT0rkkaRqFzSlNFyy7M7puG40w9oJQD7rLFJAI3Pwq
         lM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734556443; x=1735161243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lA/iM2V/+XmvBKcMHUbv+t9aXqGsPH0HbYDBmDEH3d8=;
        b=EEBQ3MiWmFyd3Wx4TSQ5IFvdjTvNuf+Pd3XjbeduROtRSBofuvU4g5hNpM6V/BVih/
         gqwUjhkmV0+gcMUCga1e7ar/FJECDhz8uIXVxaxBDcvAYAvl4RaXi76i7ZjbRBsd2fMe
         uGd23+SpDtjJ10R0k9LitSrqebXF4x2Ke/llE229NjMtjOQUqPXi8OhUpzH282Oy+jqI
         ndVV94kIAJTbnPJRrfFAjyMR0j0Qfe8p0hvGSfARoXLQYmvc8YqPacf9iivtteU6UJdT
         q8mLEbGcce1eN4+0ETQaD2cmDO8J5t76EpkDXl9BRqPDZhRIpSsCA9+PtFbE6+4fNdKj
         7QCw==
X-Gm-Message-State: AOJu0YyJlDFVkvkUCKmdIvtFvg2Azm2qsNrrrhC2i9rU/S5+haDqRp7g
	s8kRJYlNXTl0lubfZ8yfWgyqYOP0Jxbq1Pzdxkex+PSWg5Y0TS0zR0IpRbxHmvLtOcLJAb/5fzk
	Szg==
X-Google-Smtp-Source: AGHT+IEM53bthukV6nPqDidGJX3W6c0r60w2pXzy9xgZ64DtOVKnIptTFIRp+yp6zSf1sVmdzGST1rAKIQA=
X-Received: from pjbss3.prod.google.com ([2002:a17:90b:2ec3:b0:2ef:6fb0:55fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50c3:b0:2ee:f19b:86e5
 with SMTP id 98e67ed59e1d1-2f443ce9ae5mr1179965a91.14.1734556443354; Wed, 18
 Dec 2024 13:14:03 -0800 (PST)
Date: Wed, 18 Dec 2024 13:14:01 -0800
In-Reply-To: <20240910200350.264245-4-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240910200350.264245-1-mlevitsk@redhat.com> <20240910200350.264245-4-mlevitsk@redhat.com>
Message-ID: <Z2M7GajddaBqDFnC@google.com>
Subject: Re: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepointsg
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> Add 3 new tracepoints for nested VM exits which are intended
> to capture extra information to gain insights about the nested guest
> behavior.
> 
> The new tracepoints are:
> 
> - kvm_nested_msr
> - kvm_nested_hypercall

I 100% agree that not having register state in the exit tracepoints is obnoxious,
but I don't think we should add one-off tracepoints for the most annoying cases.
I would much prefer to figure out a way to capture register state in kvm_entry
and kvm_exit.  E.g. I've lost track of the number of times I've observed an MSR
exit without having trace_kvm_msr enabled.

One idea would be to capture E{A,B,C,D}X, which would cover MSRs, CPUID, and
most hypercalls.  And then we might even be able to drop the dedicated MSR and
CPUID tracepoints (not sure if that's a good idea).

Side topic, arch/s390/kvm/trace.h has the concept of COMMON information that is
captured for multiple tracepoints.  I haven't looked closely, but I gotta imagine
we can/should use a similar approach for x86.

> These tracepoints capture extra register state to be able to know
> which MSR or which hypercall was done.
> 
> - kvm_nested_page_fault
> 
> This tracepoint allows to capture extra info about which host pagefault
> error code caused the nested page fault.

The host error code, a.k.a. qualification info, is readily available in the
kvm_exit (or nested variant) tracepoint.  I don't letting userspace skip a
tracepoint that's probably already enabled is worth the extra code to support
this tracepoint.  The nested_svm_inject_npf_exit() code in particular is wonky,
and I think it's a good example of why userspace "needs" trace_kvm_exit, e.g. to
observe that a nested stage-2 page fault didn't originate from a hardware stage-2
fault.

