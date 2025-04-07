Return-Path: <kvm+bounces-42853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B173A7E52B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 17:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2CA03A6167
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94ED720458A;
	Mon,  7 Apr 2025 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HjO/dtz9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F61FFC77
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040723; cv=none; b=LfmGKiSHPXNF92DQ7k4DkCRDjHXn7BnkghpoAzMJL81sD1HkGF17EG/Z/FBWQtqkaTXAUgRqjcpgJqMVlNaw3jkYxMMoY+dMo3WfOOnP7UUolBeR8OYm0vmZpuZ0Po4PHzEwQvxmIA+oviBnjuv7Uk66vRQEmMGBqZqUQMaQUp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040723; c=relaxed/simple;
	bh=8rczIshB1ndjUPA2IIqxasn8K81KQvQWE4FXH/fl0DI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LZOTi10C/ujYwFpJjK9Tfg09+zRJy8R9Q3APCVUkf/QBX3YHzYpn9i+CGI4YkLbP6Wk0Qs+r3NIvXy420PwzsjbJlhF8sqkhcT4cnzm3DAXaFI/h7lfPU2J+oCujU9E3meE0tNYn9d7w+lcKViWrspej0E9gz0lDDDwUsc4r2SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HjO/dtz9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225429696a9so65466695ad.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744040721; x=1744645521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tjPEuV0twY2ry4rQMkACzclM+7K2QHMF2uXFHgUviZk=;
        b=HjO/dtz9x8PDliI6hVio1AzTn9EXPs5SSS+Q8NAEvSdb7ClxU3pFYtlIpbH3/XEcxq
         y3u5VLST3lWIxtV9qyC2uVbUY2qVSiSKHDXMTUK276LfnaJOAbl4bUR1ot0aQ60/UwUW
         6eqU+fNBLPn8WFfRkb6or+/ZjfnRGy80vwoJKolL/AVWaYMcatY4sB+WEZj8WWyRobhR
         rm0QuRYKjWOIliVmvzre396YZvKDBb/94rf9+o6NcG1b0aKJMhe2kWunqs3cOtzwfo4C
         dLhr1GHoLpwEfUwgo4fynpSwrz83Z+pj1n1K2XuQLOfl/jTvpZDUdsLadir8SGIKPzHQ
         pz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744040721; x=1744645521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjPEuV0twY2ry4rQMkACzclM+7K2QHMF2uXFHgUviZk=;
        b=f6xJDxq8BHWU8O9GBu7C6izzEZPayHGdMtdfm0uhl15N3hd/eQxGg9wFWD7IatKeGz
         +C/UPyW8CLMkERuN6IowZDdpkUZC+QATVgdod8rF0fJkvYsS89XWEs1ehz2vuJcITwiW
         kvlsrORSBMH6I5ydcGrU8F3FEz7DkeOl+FW3KNB/xlvMDfXvnwvuqGttKddyXBDYgTSj
         agwO5L1aaDvLMPCghm3sfYiWuHFgKFkipbnv/lGSxZ3dEtGceDHk1M9ioejULJmIzzko
         8A9si2q5LL09lTur/aWTisA6sHMuyGcdlzkyQaGDfRFa9jzKOPVLiWKSTC4k6fQNehOe
         3JIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtuF58jmtZlbKwg1gVFWURoahOR676jfc1odFPgYaxkG2hGiNYHm+mQUDdV7a4BCbTV6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3lAQwlu+9+L1RzCw5Nj2eG6Hst7qIMOM61sRcd0uQ9ife7H9Z
	Dr6Y8zQZSdW8ekNMF6H8bd1cy5zqOTjb9DqepBS/9wZL7y7LP6gbd/O92I+h4aKh0UjXh2MDi2m
	MDg==
X-Google-Smtp-Source: AGHT+IGAUO0UWTLAsUPDgxRWew05pcp0azizLiFsAkexoecMWcjbM9rZST8Tz2AIA7MAICQmH61wUobQpx8=
X-Received: from pfbbn6.prod.google.com ([2002:a05:6a00:3246:b0:736:5b36:db8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e801:b0:21f:1202:f2f5
 with SMTP id d9443c01a7336-22a8a042a6bmr141409015ad.8.1744040721565; Mon, 07
 Apr 2025 08:45:21 -0700 (PDT)
Date: Mon, 7 Apr 2025 08:45:19 -0700
In-Reply-To: <20250401113616.204203-14-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com> <20250401113616.204203-14-Neeraj.Upadhyay@amd.com>
Message-ID: <Z_PzDyiyLGq2tJl8@google.com>
Subject: Re: [PATCH v3 13/17] x86/apic: Handle EOI writes for SAVIC guests
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Neeraj Upadhyay wrote:
> Secure AVIC accelerates guest's EOI msr writes for edge-triggered
> interrupts. For level-triggered interrupts, EOI msr writes trigger
> VC exception with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. The
> VC handler would need to trigger a GHCB protocol MSR write event to
> to notify the Hypervisor about completion of the level-triggered
> interrupt. This is required for cases like emulated IOAPIC. VC exception
> handling adds extra performance overhead for APIC register write. In
> addition, some unaccelerated APIC register msr writes are trapped,
> whereas others are faulted. This results in additional complexity in
> VC exception handling for unacclerated accesses. So, directly do a GHCB
> protocol based EOI write from apic->eoi() callback for level-triggered
> interrupts. Use wrmsr for edge-triggered interrupts, so that hardware
> re-evaluates any pending interrupt which can be delivered to guest vCPU.
> For level-triggered interrupts, re-evaluation happens on return from
> VMGEXIT corresponding to the GHCB event for EOI msr write.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v2:
>  - Reuse find_highest_vector() from kvm/lapic.c
>  - Misc cleanups.
> 
>  arch/x86/include/asm/apic-emul.h    | 28 +++++++++++++
>  arch/x86/kernel/apic/x2apic_savic.c | 62 +++++++++++++++++++++++++----
>  arch/x86/kvm/lapic.c                | 23 ++---------

Please isolate the KVM changes to a standalone patch.

>  3 files changed, 85 insertions(+), 28 deletions(-)
>  create mode 100644 arch/x86/include/asm/apic-emul.h
> 
> diff --git a/arch/x86/include/asm/apic-emul.h b/arch/x86/include/asm/apic-emul.h
> new file mode 100644
> index 000000000000..60d9e88fefc6
> --- /dev/null
> +++ b/arch/x86/include/asm/apic-emul.h

I don't see any reason for a new file.  arch/x86/include/asm/apic.h already has
is_vector_pending() and lapic_vector_set_in_irr(), this functionality is more or
less the same.

