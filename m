Return-Path: <kvm+bounces-32606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F549DAEAB
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238D4165209
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2E1202F8D;
	Wed, 27 Nov 2024 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TqWh6e9n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87919885D
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740976; cv=none; b=k8c1H5yBkQaYS+ZcxsOtGttHMS1/1ycE2/48myHKzAQ76o46YIUuS4qG1D1gWi4X/li7/g2nipTbiY0jr5MhYgKTAKB3bgkaGej0i19ggaJTpwGaUxvIqnypujx8EW9jRwt/LaTliidWu3lFpXCgaob4HLT+PMzRgb9jGOABQCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740976; c=relaxed/simple;
	bh=pAcaCAPG4BMv5JGXb5YisXO1kH/KvOULPhJtvzy6otY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XzyysM+Dng66ptwyJNgqu6wOuN+uE4rE9H6V9n1ywen3OlhxsEhZXeoPXBxbXEGgeSw3tukpopNTXqCJBWzDj/9W3guN23LoN90zVAZXP3kqhPW2xN+eL0VDsRS89R39/wlXBPbtm0vfcONDIKN9/mrGywmvyeJjaiKeDdbRAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TqWh6e9n; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea9d209e75so155222a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732740974; x=1733345774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBtSRCzRIz8AShroO4275cwVMjY2+0/fpvGDFnAyaPk=;
        b=TqWh6e9nYzpohgqLci6X6CvLffx5BlwNUqFk6oAi27zmskDNG9ZoIiHnPsgHOBnvEh
         Ec2f9av3rlI8E4YcrU17lCrEOHmOTTPQ/rcDE85apiN8JBxUuvAoy4D/Sq0Pu6hXK/Sb
         qBZp9qKTndtglkEEJjrZBEj2+pC4aSzKFXgEBYNa20MyJ3PiFpNeJipuvC0Rg1V3KJhN
         L01KT2B+dcETaOTctKTJQ4SBaQP9RchFBP+YO4XSPYHUdpUa5VSuqwOd4wh/b5zXF3H3
         0V3YsNobFkz45QL5S4xv372XzPu+GOupsOOv9O+/AJBgFICJdcU9pFOf3Yj+xBmIGmWW
         G+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740974; x=1733345774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBtSRCzRIz8AShroO4275cwVMjY2+0/fpvGDFnAyaPk=;
        b=sLnAX94uwbatpVsip8t0GE2Bh60utpwPIfNmtaPO6LQF+ViV+FPhqKbfO5fFxvyfCj
         OZFo8N4gtZSTVIljjqeh7LTvgd20+O2HOn4sEpXYLEwCLV+uuq8k4gpykUPcoT5Yleha
         ncoxfrucy9qzB4om/fYsZhhlyPaN2osbsj7FqGmTbXMUGLmZExrcE+WFUJBXdhqiyTCT
         hYhqC+TmkZlYtWbtvvDKaBteDVOkB9/ND3YDdy9mbpj4KqGeJ3z7HIxBqSjZxZq+2vnp
         lGI1Yg9AxS/27EHeW1Z1jfAPW99VJj94Kj3T362kue9FxYSuUHYsFqjpVf/DKsgc+Up6
         +w6Q==
X-Gm-Message-State: AOJu0Yzvs/iEmdeEX4uZfmAabttCA4B6nFGAVUeQLmeTTJT910lOjU0L
	MlBd2Aw6Q0U0ldvDV1rEk4VhTwHGs5IXmAmkoLYiqeyd5aOV/h/YP0eTH4aA4c3rNJFlpVW79qW
	TQg==
X-Google-Smtp-Source: AGHT+IG0qozu9fNtQAqUMhgrqAmHcgXwUmOAuZHZwgxOrHpHCmmSeD3d/dNOjiM3N6xJkomhUeYfwPmxvys=
X-Received: from pjbli10.prod.google.com ([2002:a17:90b:48ca:b0:2e1:8750:2b46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ecc:b0:2ea:b2a5:932b
 with SMTP id 98e67ed59e1d1-2ee08ecd81amr5813505a91.17.1732740974003; Wed, 27
 Nov 2024 12:56:14 -0800 (PST)
Date: Wed, 27 Nov 2024 12:56:12 -0800
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
Message-ID: <Z0eHbD1kQt1LZKEw@google.com>
Subject: Re: [PATCH 00/15] Unify MSR intercepts in x86
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Aaron Lewis wrote:
> The goal of this series is to unify MSR intercepts into common code between
> VMX and SVM.
> 
> The high level structure of this series is to:
>  1. Modify SVM MSR intercepts to adopt how VMX does it.
>  2. Hoist the newly updated SVM MSR intercept implementation to common x86 code.
>  3. Hoist the VMX MSR intercept implementation to common x86 code.
> 
> Aaron Lewis (8):
>   KVM: SVM: Invert the polarity of the "shadow" MSR interception bitmaps
>   KVM: SVM: Track MSRPM as "unsigned long", not "u32"
>   KVM: x86: SVM: Adopt VMX style MSR intercepts in SVM
>   KVM: SVM: Don't "NULL terminate" the list of possible passthrough MSRs
>   KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
>   KVM: x86: Move ownership of passthrough MSR "shadow" to common x86
>   KVM: x86: Hoist SVM MSR intercepts to common x86 code
>   KVM: x86: Hoist VMX MSR intercepts to common x86 code
> 
> Anish Ghulati (2):
>   KVM: SVM: Disable intercepts for all direct access MSRs on MSR filter changes
>   KVM: SVM: Delete old SVM MSR management code
> 
> Sean Christopherson (5):
>   KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
>   KVM: SVM: Use non-atomic bit ops to manipulate MSR interception bitmaps
>   KVM: SVM: Pass through GHCB MSR if and only if VM is SEV-ES
>   KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
>   KVM: VMX: Make list of possible passthrough MSRs "const"
> 
>  arch/x86/include/asm/kvm-x86-ops.h |   5 +-
>  arch/x86/include/asm/kvm_host.h    |  18 ++
>  arch/x86/kvm/svm/sev.c             |  11 +-
>  arch/x86/kvm/svm/svm.c             | 300 ++++++++++++-----------------
>  arch/x86/kvm/svm/svm.h             |  30 +--
>  arch/x86/kvm/vmx/main.c            |  30 +++
>  arch/x86/kvm/vmx/vmx.c             | 144 +++-----------
>  arch/x86/kvm/vmx/vmx.h             |  11 +-
>  arch/x86/kvm/x86.c                 | 129 ++++++++++++-
>  arch/x86/kvm/x86.h                 |   3 +
>  10 files changed, 358 insertions(+), 323 deletions(-)
> 
> -- 
> 2.47.0.338.g60cca15819-goog

Please use `git format-patch` with `--base`, and in general read
Documentation/process/maintainer-kvm-x86.rst and
Documentation/process/maintainer-tip.rst

