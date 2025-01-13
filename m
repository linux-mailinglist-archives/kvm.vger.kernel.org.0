Return-Path: <kvm+bounces-35336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C86CCA0C4BB
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 315363A8497
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6381E1F9F52;
	Mon, 13 Jan 2025 22:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cXc96mjN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278931F9A96
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807400; cv=none; b=goDny1+/BjDQAPhM2c0NwUHhFJG7UvroT40clGolKiYA7xYLLV7bX63oiAsB72z30tBo1w0ihqMU5OSLA8y/s7Meb2n3+xvkymhsV12dX4UE1kaTDVZcFs2aD0gZhHxx6xqFGM6HaTV+N+2ip7WWID63own5Xb1Dni84C8vWbiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807400; c=relaxed/simple;
	bh=vFXTme0l2EtGLDvMvr7Wb8nxPHKTVbjWj47NnLK7m4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=DH1Lk7zzg4+h7+bcdCY8v4qFJZOTwoWbVR7/Ia00/X5PehxdorAkcQzsLxcy84xbRooVNslnSLF/xBVDIwemAIv8jUJB/f58x3Hjtq38GnSjdzESInnVazwMo8+xzYD43+l9slMJrHu5VlVG4+perJp6wRT+03FwWVCumEhGE4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cXc96mjN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso8644352a91.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807398; x=1737412198; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bw9SY9vXLU/AJEykJA1x18c2kg/nuCeiQgdJRPgfpfc=;
        b=cXc96mjN7a9aBU8nCaRlBmGx3G2p5um/FDOtOYPqHf+gHoYc/U0neCd3pIGqhmfoWZ
         +I9EJraRZEU0GUoqB7bYq6bthQoiqRj37enOosINsSVfPaUmYrDA7Ohq7yR8JIsYmP5n
         G7Tl7a2r1dmImdvIsntbnIraI0k1VYYgK5kewRjxyQ4mQFmUBQ6EQAC1LxWWAwq75ywP
         zCvSxXN/zLjkoKdOAemG2ykIr/GixLxZ0tpf0Zuztbg1gkH7mBsHur/bHcLd8jFCuiN1
         xamCMbfkrMJDMrA6HEgFJhucvTdyJ/3E+Eup3mC7eW7rLXxpajjt38cLgsuebE8uNv1X
         bqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807398; x=1737412198;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bw9SY9vXLU/AJEykJA1x18c2kg/nuCeiQgdJRPgfpfc=;
        b=VsFVKk9U/fDpz1fV5cqTwrERzobe1HFD3ufjfbht3R48S4eGBtPVNduuJl0o3Hd8kq
         X28N+9okzLt5uJlOXbmOhzlUT/Ap7Xc7DSKr1VGehPYEpgWL7SzwAL//RASwRS3O0zQm
         uLW/bcD9CFNebZxHx05sRc+2OfJS+g7iwI8bzlIMne5LWqPPHWUBYpoFZGMt6nb7DQ5d
         Lj2grGNyFieNJl5bkmwTMritWEJy15CAE4pvTxssQ9aVI7h7ZrLu1KUw3HZgMX9pKx9n
         9lEI7H8NMqWcWtz+P5rkxiW55beb0+p1od/f6eSct0n84TkIXyLHkc0Gp+bpuou5br5l
         iz4A==
X-Forwarded-Encrypted: i=1; AJvYcCUkZhmvhqPILrLO66KIY9Rgbkq/yPllGgAfkGaTd7agzZko7T3yIngijEeomHdAqBQGbmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVoNBH7TUA+zbsmxf+iexCs7QU4wjcGdAuHu1U9YKr0LnHRyzO
	w1vUCaqjWt4G6YJBCJm621XcfwECxjRTkF7Hx1i3kQNSS5JEdTfYCpjBh8VFF8NnQvpcH/88D5g
	uQQ==
X-Google-Smtp-Source: AGHT+IHyeNuhBnW0QqO63/mQpYNWJJkaFMu8OIJPcWZdkHxnOXShSpmfKQvcDgQI94dU6/2l/aAm83E3Rco=
X-Received: from pjbsz15.prod.google.com ([2002:a17:90b:2d4f:b0:2ef:8a7b:195c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54cb:b0:2ee:8e75:4aeb
 with SMTP id 98e67ed59e1d1-2f548ec9267mr36225691a91.17.1736807398604; Mon, 13
 Jan 2025 14:29:58 -0800 (PST)
Date: Mon, 13 Jan 2025 14:29:57 -0800
In-Reply-To: <20250113222740.1481934-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com> <20250113222740.1481934-2-seanjc@google.com>
Message-ID: <Z4WT5VA4N7hLQnAr@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if
 local APIC isn't in-kernel
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Sean Christopherson wrote:
> Advertise support for Hyper-V's SEND_IPI and SEND_IPI_EX hypercalls if and
> only if the local API is emulated/virtualized by KVM, and explicitly reject
> said hypercalls if the local APIC is emulated in userspace, i.e. don't rely
> on userspace to opt-in to KVM_CAP_HYPERV_ENFORCE_CPUID.
> 
> Rejecting SEND_IPI and SEND_IPI_EX fixes a NULL-pointer dereference if
> Hyper-V enlightenments are exposed to the guest without an in-kernel local
> APIC:
> 
>   dump_stack+0xbe/0xfd
>   __kasan_report.cold+0x34/0x84
>   kasan_report+0x3a/0x50
>   __apic_accept_irq+0x3a/0x5c0
>   kvm_hv_send_ipi.isra.0+0x34e/0x820
>   kvm_hv_hypercall+0x8d9/0x9d0
>   kvm_emulate_hypercall+0x506/0x7e0
>   __vmx_handle_exit+0x283/0xb60
>   vmx_handle_exit+0x1d/0xd0
>   vcpu_enter_guest+0x16b0/0x24c0
>   vcpu_run+0xc0/0x550
>   kvm_arch_vcpu_ioctl_run+0x170/0x6d0
>   kvm_vcpu_ioctl+0x413/0xb20
>   __se_sys_ioctl+0x111/0x160
>   do_syscal1_64+0x30/0x40
>   entry_SYSCALL_64_after_hwframe+0x67/0xd1
> 
> Note, checking the sending vCPU is sufficient, as the per-VM irqchip_mode
> can't be modified after vCPUs are created, i.e. if one vCPU has an
> in-kernel local APIC, then all vCPUs have an in-kernel local APIC.
> 
> Reported-by: Dongjie Zou <zoudongjie@huawei.com>
> Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
> Fixes: 2bc39970e932 ("x86/kvm/hyper-v: Introduce KVM_GET_SUPPORTED_HV_CPUID")
> Cc: stable@vger.kernel

Argh, I missed the ".org".

Paolo, if you end up applying this instead of me, can you fixup the email?

