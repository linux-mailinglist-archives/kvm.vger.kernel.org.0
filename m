Return-Path: <kvm+bounces-34254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1189F9771
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 18:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFA5D189B85A
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D2721A952;
	Fri, 20 Dec 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qsd+TdNe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C972153EF
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714216; cv=none; b=m/ambXy+yc+kESk3jTQ4x4taclMTuRlZd9dX9zOtX/aCA4WHvKVb28hxVNnrC4XM88nSv06+zgtsDErnBpoTc3K7PJpLS+mXujZvx1JjIsGKYOmcch+25bw22ARvb5Nza2JDYKGBLwY9G8Z842/drnlgTbWPPJgNCyktm7mM6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714216; c=relaxed/simple;
	bh=XixWERsnTiJRqts/WwEbYo2pyD7Nc8ZnsgWBeb4RkzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kZKHvNBCok4kEBjFfkcnL3cBc/SOI44/KXg6vrV4+9WiTtzxbcU0I96l8CucXu1KH+2Ie48HmDt0IDU6IoKNgmNToj1VrYQQyefFr+vNEH5mWOEefjubBiI7GYdTZEp/m32m19LGdnAf9VMkd3Rab4YvxRr0mq2vK5R2kDl1XJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qsd+TdNe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so1962913a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 09:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734714214; x=1735319014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5yr6t69gOvH70w/wkJRwmL2V9/iNwAhu2xaX5YWKo4=;
        b=Qsd+TdNeYrVPuOKOxLkXs4kDnGonsGS8BgomM7fysvuO4iWPpaKuGy8fYBXj2Roh2D
         YcMg8aWVLIK51GCiosmO2yKHvq8ebV9s/uRy6jppE+KWuIYp9GGQ29uC8m5N1jRI5r5x
         xM2d2oVLuvhNZxFQzSRRAXedxFu6l3BRS+2y3QOtHYbqgXqOmmq0ijckaVe6pYmoKFW1
         c/AgiaBNsosKQmyh+MpCCvgj+nb8teH0Z/L4hi29NkwM16nko/qHJJMDTHQBVBNRwJrh
         jTCb7Xi5QK1Sxx3tT4AenqU/pYbcjCysKwSYo02ejREcwpq527/UcBkerHEZecIxuek3
         27JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734714214; x=1735319014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5yr6t69gOvH70w/wkJRwmL2V9/iNwAhu2xaX5YWKo4=;
        b=J69OfMUZcc7UDjBKAwXjTIXWz2DmQRzj5KZeBJqJjEzNhblJSCDO4EfkI6snk8d8uE
         qa/cPNro88PcPMilHizDzkaakNHOMFD0dGVjQfRIkAqfjMOgV778cwrWCiCNKkFSrIE/
         mju4Z+WjIuFXmyEzevDzcxxHCUAj2kLbOYQwvkdvFh1M3hLtQRhlSq+5N8t4NWQuTusT
         Q/mbWnBMOfTghbkBa0kC1Tdqd06TCf/se2wXLVy6l4E48DKe0/8BmYMBEZXgVb/iAuzP
         uyGxY9gviLzGW6gq2YS9nJF9m/RP/KPkOYpNfkjPtPI4mwyUejPkpNnonry8xRFyIf6r
         1tVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN1MB1Ag5wclMSYkFct39cZ6qEzWNYiek7jhGg/rnEoZCI5M6gRMMj0siKGG5uQIJcLZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2GInDcCoFX2+Cf6lTYnQS3ETjm8PhVfZGRBqQrstHzrHAqqvd
	xeQ44IH/mVs1/eqLVAvHLL650XNaVjp2sc+CpI/CXSzyfSBBWytt1Vp0m6PRbt16eopNwXmsRwf
	QNQ==
X-Google-Smtp-Source: AGHT+IEqBrnezB1GN7pFiCoWOhDUqGVsSUgzaeHOmkxBKF5WRD/GsHalV8OTgJ6lAurNZBX5g4ESY9Ow2K0=
X-Received: from pjbsy4.prod.google.com ([2002:a17:90b:2d04:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8e:b0:2ee:f80c:688d
 with SMTP id 98e67ed59e1d1-2f452ec37a0mr5138242a91.25.1734714213969; Fri, 20
 Dec 2024 09:03:33 -0800 (PST)
Date: Fri, 20 Dec 2024 09:03:32 -0800
In-Reply-To: <20241219124426.325747-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241219124426.325747-1-pbonzini@redhat.com>
Message-ID: <Z2WjZAKBOi1x2MVA@google.com>
Subject: Re: [PATCH] KVM: x86: let it be known that ignore_msrs is a bad idea
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 19, 2024, Paolo Bonzini wrote:
> When running KVM with ignore_msrs=1 and report_ignored_msrs=0, the user has
> no clue that that the guest is being lied to.  This may cause bug reports
> such as https://gitlab.com/qemu-project/qemu/-/issues/2571, where enabling
> a CPUID bit in QEMU caused Linux guests to try reading MSR_CU_DEF_ERR; and
> being lied about the existence of MSR_CU_DEF_ERR caused the guest to assume
> other things about the local APIC which were not true:
> 
>   Sep 14 12:02:53 kernel: mce: [Firmware Bug]: Your BIOS is not setting up LVT offset 0x2 for deferred error IRQs correctly.
>   Sep 14 12:02:53 kernel: unchecked MSR access error: RDMSR from 0x852 at rIP: 0xffffffffb548ffa7 (native_read_msr+0x7/0x40)
>   Sep 14 12:02:53 kernel: Call Trace:
>   ...
>   Sep 14 12:02:53 kernel:  native_apic_msr_read+0x20/0x30
>   Sep 14 12:02:53 kernel:  setup_APIC_eilvt+0x47/0x110
>   Sep 14 12:02:53 kernel:  mce_amd_feature_init+0x485/0x4e0
>   ...
>   Sep 14 12:02:53 kernel: [Firmware Bug]: cpu 0, try to use APIC520 (LVT offset 2) for vector 0xf4, but the register is already in use for vector 0x0 on this cpu
> 
> Without reported_ignored_msrs=0 at least the host kernel log will contain
> enough information to avoid going on a wild goose chase.  But if reports
> about individual MSR accesses are being silenced too, at least complain
> loudly the first time a VM is started.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8160baf3838..1b7c8db0cf63 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12724,6 +12724,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm_hv_init_vm(kvm);
>  	kvm_xen_init_vm(kvm);
>  
> +	if (ignore_msrs && !report_ignored_msrs) {
> +		pr_warn_once("Running KVM with ignore_msrs=1 and report_ignored_msrs=0 is not a\n");
> +		pr_warn_once("a supported configuration.  Lying to the guest about the existence of MSRs\n");

Back-to-back 'a's.

If we're saying this combo is unsupported, should we taint the host kernel with
TAINT_USER, e.g. similar to how the force_avic parameter is treated as unsafe?

> +		pr_warn_once("may cause the guest operating system to hang or produce errors.  If a guest\n");
> +		pr_warn_once("does not run without ignore_msrs=1, please report it to kvm@vger.kernel.org.\n");

This should be a multi-line string that's printed in a single pr_warn_once(),
otherwise the full message could get split quite weirdly if there is other dmesg
activity.

> +	}
> +
>  	return 0;
>  
>  out_uninit_mmu:
> -- 
> 2.43.5
> 

