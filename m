Return-Path: <kvm+bounces-27424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39D4A98611B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3DA21F260C9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 14:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432BE18891B;
	Wed, 25 Sep 2024 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZXhBq6C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CAC18873E
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727272486; cv=none; b=e2b0wPUhM+X6A/1f8corRRGfqcjoFCa8FvVcl0F5LztR6HYh4hSib+inHugy08mWMxCGEBbaPbjsIiIxT0ffDXr8lVLuJmoG0Sf2PFNuQUiaiC5/yBi3GQuGb+QZPTpMuhqSUdngYAXZA6BlWs9Yis7P1oXZF/xrfru9oRctUN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727272486; c=relaxed/simple;
	bh=auo8uEeKyWNAzNHUp26PfITSjFYNhRSuij1t+uvKJ+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rcXCraVRIKGnI4ng9KyZtZn9hUdvm9ijnf4PaKNeOFEpR9gsLsGZSzOXy3f5/NvXKJ9SIHo1k7fCJi4m5HZku1AqDXyPkmUu2OdxkjZ1Z2pqk3pweiFnNgfwy8OTT0FdMxs3cNANLh0GuWY7WsdiLL0mChzBDDv2O9aDQ3z7hKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wZXhBq6C; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e1fea193a4so49197357b3.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 06:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727272484; x=1727877284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lk7odMaYNjZ3G3yZ3a1OOv4D2tbEjCMBdR1l/GbHUKE=;
        b=wZXhBq6ChZ40/3s6Le8FR0ru0peSTpOHuaUK6zSdLGQClMIOaL23w7adC3dWuu6jae
         mm1QNfV8jBeptzuFlrJZH1FBKSRlXA25Agfa7a5a/hE3b4magq4mBU6O7zlT71qq5T1q
         zTHfbTJE3Rb0Q1kOB3m1fbdqtKhcd1T/0AUBiyKmPRiFmDkvJjCcgu+ZGhCckKfLgIwL
         J7H0TRPampAnZbMsSDh4Ac7msPuqJZhGbos7fOB43JMXkeA1kF5462wvUY4Gn//wtKm6
         FDgGCg6LyvS6HDVaLRLcP/00c5vJR7v0EbQBbaQyVgN0COgovryU4Dcxn/k6yQlxIukh
         KanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727272484; x=1727877284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lk7odMaYNjZ3G3yZ3a1OOv4D2tbEjCMBdR1l/GbHUKE=;
        b=rZ3AB4CILZp3ckSwVHPHXHkNPnEjlpOwrsvUG/R/wI6+yamFBPQEUwu8mMD8zK0FrC
         y/2l0d5MfA3jBQZFX0IkfEPp9xoHQAYX77DU8PuTSZuf6K5whHxwDbp+sgJ+LPBr3Lk7
         QsMrXX6AZc1LcPHN/EMwTucwzVHfBxBqKnshXAHXOxKY0HkOU+MNnS13pwr4qCtTZ0eA
         mQKI88/sXOly1PLXxMzzgkt48oxjQWFOpsU6UnTQjKckbJF83Ayu3GBGdaSnILLjGEyB
         RNhv6bDvh2yeqhqoebwvZgTB1TGNvTe+YSMK6ahxu4DbX4wwEPkYa/10rD+zrCNyh+AJ
         ga8g==
X-Forwarded-Encrypted: i=1; AJvYcCXOd3arJJHGbDyKmPJbe+TRFMbl1g3ynnmpOtDGf34B8xsz4L9I0u4jQPQdDQhyLD/LnT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw13QkRpt8Y6tdoMGP9pnhCsxYOi8oXoptZyw2XK+f71pyWmo/R
	2XXXHF5xqvNqZXdhZylhZ8tAw1ROQyWne92osPm/d77WI/4SYcHG2sIQofK0X5YcwmPILJ36LtD
	LBA==
X-Google-Smtp-Source: AGHT+IGNnn1aj0UHP4wBrW71FUTe7T79UNAeqYjqD4o0lNABDe6DdiB/r+Nvqs6lAjXf1a9NIwYM5CX11Cs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5086:b0:6dd:bc07:2850 with SMTP id
 00721157ae682-6e21d9fc145mr46697b3.6.1727272483918; Wed, 25 Sep 2024 06:54:43
 -0700 (PDT)
Date: Wed, 25 Sep 2024 06:54:42 -0700
In-Reply-To: <20240820043543.837914-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com>
Message-ID: <ZvQWIsRlrmHsB3DB@google.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: Include host suspended time in steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="us-ascii"

+David W for his input.

On Tue, Aug 20, 2024, Suleiman Souhlal wrote:
> This series makes it so that the time that the host is suspended is
> included in guests' steal time.
> 
> When the host resumes from a suspend, the guest thinks any task
> that was running during the suspend ran for a long time, even though
> the effective run time was much shorter, which can end up having
> negative effects with scheduling. This can be particularly noticeable
> if the guest task was RT, as it can end up getting throttled for a
> long time.
> 
> To mitigate this issue, we include the time that the host was
> suspended in steal time, which lets the guest can subtract the
> duration from the tasks' runtime.
> 
> (v1 was at https://lore.kernel.org/kvm/20240710074410.770409-1-suleiman@google.com/)
> 
> v1 -> v2:
> - Accumulate suspend time at machine-independent kvm layer and track per-VCPU
>   instead of per-VM.
> - Document changes.
> 
> Suleiman Souhlal (3):
>   KVM: Introduce kvm_total_suspend_ns().
>   KVM: x86: Include host suspended time in steal time.
>   KVM: x86: Document host suspend being included in steal time.
> 
>  Documentation/virt/kvm/x86/msr.rst |  6 ++++--
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 | 11 ++++++++++-
>  include/linux/kvm_host.h           |  2 ++
>  virt/kvm/kvm_main.c                | 13 +++++++++++++
>  5 files changed, 30 insertions(+), 3 deletions(-)
> 
> -- 
> 2.46.0.184.g6999bdac58-goog
> 

