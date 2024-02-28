Return-Path: <kvm+bounces-10309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DCF86B9E8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E895289069
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 21:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F8D7003A;
	Wed, 28 Feb 2024 21:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f/Oybt2Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A3A4D11F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 21:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709155956; cv=none; b=XaGG3otT9IFcoyLLbwPv7q09N6/Kak2FlypnlNPIedmDVFrEJmjDIpoLoDLd4frd0TZ6dFJoHeo5+xLBhNxjlDHEoLV+rzi9BwK4xTr5Z+zD3ETjwzRSrwwz4kMnw5t1CVxa0srDbSL6uOTGJBBvDbdXoq4dfofmSn9JzYOKzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709155956; c=relaxed/simple;
	bh=vurzQAkj+Uzk8AykBkc/bg1M650EYGHX9phKK+ngi0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mcC2aB8MVjnlelDQ7F2khVDqICah+TkbOtHaF8/UzHlQ28kid5B5ASZhzKAILcsHDbbNPkb+CXraMDUZvqvKvwGcqJ93r8jEQj0lVozzVNeHtIuL8SrYePE7/tN1eyy20U+QhIvuk6/K8Z0NHgHoXnukVuXxvY9DT3sIsV9XgWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f/Oybt2Z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29ab1ccc257so102717a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709155954; x=1709760754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yIIQ0MmR6ymPVVYqXu0m83pfog7nJNUxZwJFPucVFi0=;
        b=f/Oybt2ZTdB8ibW9HCLlsyTFjHTJIuEH6r7V3EuX115LuGPZfd8PgiCeR4iZaLX/FY
         vXqOLCaLEJm+GELgvd1FyNFBNFKUUd9Rtm1ynU+t8mNbwmfk4BUhRe37wAnUziwlpYl5
         4JjFp7VadKgTs3Gc7YuOTvJqLOatzpmUyuFoNqgbeY19BWn6kM34A1cdGGSyEKDJ96z9
         m8UduaOF28ZRLEYmKn0TQSRXUVvJdCJgwuYiV6f/uw7t82mhdnlw+YqA2HPjppDLvNVX
         RyHxCRlqfVS8U2zlANEzfid0sSBWLeEYaPNKXLFUp3D1uXDDuxuRGFasZFXRS+YV/583
         yE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709155954; x=1709760754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIIQ0MmR6ymPVVYqXu0m83pfog7nJNUxZwJFPucVFi0=;
        b=azwEGjJvEmHW+aum3UYWYj5NEYBkuTBb6l0mv5B4W1rPkiwMXE0L32npn+CTiT5PYq
         wB7Tk5fLip+2KC9UkW1xaZCENH+YYUYnYOJWcx3S0RHoYvKA36jnqxYDocHpsB+HOY6m
         e61c7bJXLVSC7xteDzphOWNAGHt17dUchdLuYhKz6Ouehp5QRO1k9TDvUGvcycmmDTMM
         BZ7bJVaTMu05D562Mz5UPbjZ03PTD1NyY9di+VWpVrGhS/qfDZlAsLVrSLAgnEjAQSnY
         d6ASjy48eLJWLOgOTfCnJQakL8QlrvwcqOAspCugQ/ZcveLWZ+GbWUXZS2qfiYzh4Y0l
         9XTw==
X-Gm-Message-State: AOJu0YxiZaCU7F8+t3hw38xZLPuII5H+LDoxzGrZ2Rxx2y75o4aH+0sc
	r3VY3y7WBZfbERbF60MDt4eo931cugror9uLAJPFTxhhcAtMJ2sYx/O9ut3oqAd9RMScABrdcnB
	Z5p8i0juTnVJhB8TFIL4e55mCJmHaDF7AILOOIsL9kgiUaEEi1IGt30R5O23t1akLo4wA7KefMO
	5BAonxT4U26DOC16iCNPYFdQhpHg48
X-Google-Smtp-Source: AGHT+IGubsT96u1o3j+RmR8kfG5FWlObG7Q+IXPU/pt+XH6aKFJjnUg2nj9BZEmVlfZA8HUeJOMt5JH+YUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:23d4:b0:29a:a842:6eff with SMTP id
 md20-20020a17090b23d400b0029aa8426effmr1162pjb.1.1709155952903; Wed, 28 Feb
 2024 13:32:32 -0800 (PST)
Date: Wed, 28 Feb 2024 13:32:31 -0800
In-Reply-To: <170900036555.3692027.1057525433723685864.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240208204844.119326-1-thuth@redhat.com> <170900036555.3692027.1057525433723685864.b4-ty@google.com>
Message-ID: <Zd-mbxzD--SkEBjP@google.com>
Subject: Re: [PATCH v3 0/8] Use TAP in some more x86 KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, Sean Christopherson wrote:
> On Thu, 08 Feb 2024 21:48:36 +0100, Thomas Huth wrote:
> > Basic idea of this series is now to use the kselftest_harness.h
> > framework to get TAP output in the tests, so that it is easier
> > for the user to see what is going on, and e.g. to be able to
> > detect whether a certain test is part of the test binary or not
> > (which is useful when tests get extended in the course of time).
> > 
> > Since most tests also need a vcpu, we introduce our own macros
> > to define such tests, so we don't have to repeat this code all
> > over the place.
> > 
> > [...]
> 
> OMG, you didn't tell me this allows sub-tests to run after a failed test!
> That alone is worth the conversion :-)
> 
> There's definitely a few enhancements we'll want to make, but this is more than
> good enough as a starting point.
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/8] KVM: selftests: x86: sync_regs_test: Use vcpu_run() where appropriate
>       https://github.com/kvm-x86/linux/commit/e10086285659
> [2/8] KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
>       https://github.com/kvm-x86/linux/commit/221d65449453
> [3/8] KVM: selftests: Move setting a vCPU's entry point to a dedicated API
>       https://github.com/kvm-x86/linux/commit/8ef192609f14
> [4/8] KVM: selftests: Add a macro to define a test with one vcpu
>       https://github.com/kvm-x86/linux/commit/992178c7219c
> [5/8] KVM: selftests: x86: Use TAP interface in the sync_regs test
>       https://github.com/kvm-x86/linux/commit/04941eb15439
> [6/8] KVM: selftests: x86: Use TAP interface in the fix_hypercall test
>       https://github.com/kvm-x86/linux/commit/69fb12492005
> [7/8] KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
>       https://github.com/kvm-x86/linux/commit/200f604dfd07
> [8/8] KVM: selftests: x86: Use TAP interface in the userspace_msr_exit test
>       https://github.com/kvm-x86/linux/commit/8fd14fc541c7

FYI, the hashes have changed for patches 3-8, as I forced pushed to fix an ARM
goof in patch 3.

[1/8] KVM: selftests: x86: sync_regs_test: Use vcpu_run() where appropriate
      https://github.com/kvm-x86/linux/commit/e10086285659
[2/8] KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
      https://github.com/kvm-x86/linux/commit/221d65449453
[3/8] KVM: selftests: Move setting a vCPU's entry point to a dedicated API
      https://github.com/kvm-x86/linux/commit/53a43dd48f8e
[4/8] KVM: selftests: Add a macro to define a test with one vcpu
      https://github.com/kvm-x86/linux/commit/55f2cf88486c
[5/8] KVM: selftests: x86: Use TAP interface in the sync_regs test
      https://github.com/kvm-x86/linux/commit/ba97ed0af6fe
[6/8] KVM: selftests: x86: Use TAP interface in the fix_hypercall test
      https://github.com/kvm-x86/linux/commit/a6983e8f5fab
[7/8] KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
      https://github.com/kvm-x86/linux/commit/de1b03f25f3b
[8/8] KVM: selftests: x86: Use TAP interface in the userspace_msr_exit test
      https://github.com/kvm-x86/linux/commit/8d251856d425

