Return-Path: <kvm+bounces-48349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4C6ACD068
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 01:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF61D3A3E6E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE11122D790;
	Tue,  3 Jun 2025 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KXySehKp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2181B85C5
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 23:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748994832; cv=none; b=L1WGYBW4uYEw76wjp2VYcsGRZcH2e2rn76OAd7YxfH8zpZ6p36Otk2IDmWMxv6X9D6Xkcylzk7gw3N/W64Q/SYI9IqX29VtHrzdrhHJZJ6tHKBF01VFMT40tLwW92YShvmMjGrjQ4PKS+x5eBqKgRz8nFHzBDk+yCt/cOQD8KPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748994832; c=relaxed/simple;
	bh=vuo5DjzJDnf/gmSDRw+wRmKxlc7dsUXRL4VBTi9xf48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t4OqNgVstfDFS0hC8DG0f04x3Ag8Pkwk+rCBi7hN9cKaDa214RRdXK9aHXHKJGnaA3q/cRIuqf+ch55b1PEWnPpsqQzKLW0kvjpdwPhvthq3vTRc2hOxOcYeLQ/AXH4BaGkSKBciHVVjriDpVejoMG20mxJrbXhOlN6TnmGh71U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KXySehKp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso8763607b3a.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 16:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748994830; x=1749599630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iO4lvFVzPRIoByznTzPvRR/1CVOQS5/ueegQ4wE+dkc=;
        b=KXySehKpIsjVMsD1wY8ZtLyHdBKnxwEHad2ThJUC/IWccteofqG7jMZnUZnwh1r2G7
         +CCAKg/Yy1iPHQzdq8p3hqqaY8j47imU9zzaDUHknaQpsJViopitTiEpm8UQA4F967lh
         nDxGxX4mGzu/L1p0QHMijnpsVEacK5xA2bFGagle+YQLkroTqYGBc1hJOY+NtWa6DSTz
         E9HbZkI80KNSY7WHtuZ/zzV+MTBjrQ2UgWI5rYoyk+et1cOIadT9bmeBHAam/S5tahFm
         /cS1cg1PsL42cV69a/VJfc8cdlgHin2j1PL7+qreSOaMnzcQm9W52L7PakV+i7SolPHc
         RBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748994830; x=1749599630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iO4lvFVzPRIoByznTzPvRR/1CVOQS5/ueegQ4wE+dkc=;
        b=s0jt9WKOan0DJPpTFvGlHeekLno21JMkMcapFmexUq5E8KhXffYDEIyS4GluMOjoRN
         ivNQkZT1i+W9Fd1As9XSAbG7cZCTmmBBewQC2fhWD7TV500GdvqqKs/yx77HBxkEGBaN
         lh80DnwDzNFEyqwtlCpoF/YSi2kpZa6C3orkh4sR0cGYuF0XXO2THxZHeuVFkJarczro
         aGxBWzmOZHVRTcW8Lqvjzj/OH4VVabLmyjp42gqehjzm9jk5PidUbi1A3A8A2XdtEwgl
         hXj45N0SszwkXr7BiEULk5Pp13RN0JNxjAZjzqkKWoMNXi2CR6opi27HzFfpvayQWNEy
         4o5A==
X-Gm-Message-State: AOJu0YwxI4L4vICandfqA+L7I8bCPC+r4Sf6ULWxvxGnR4c7lME/vDnZ
	t/wNnpx5352Exln0mBFjkVEvynPzJWWmuYcpp+fguZ73UbTYR+8GS/REnN5UxKKhRjhg1Ylx2VU
	KpVG2PQ==
X-Google-Smtp-Source: AGHT+IEIAijtpogO5kRFWihWWBXBQcALRLnXuAaMxLTmjYVQIFzh7JMWDfPtlEpr3CmLM5HVWTzkjyjCxgI=
X-Received: from pfvx14.prod.google.com ([2002:a05:6a00:270e:b0:747:9faf:ed39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cd6:b0:73d:b1ff:c758
 with SMTP id d2e1a72fcca58-7480b41eddemr1222496b3a.18.1748994829920; Tue, 03
 Jun 2025 16:53:49 -0700 (PDT)
Date: Tue, 3 Jun 2025 16:53:48 -0700
In-Reply-To: <6aba109b9ac7e883d00b74d084e58f37acd805e3.1740479886.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740479886.git.naveen@kernel.org> <6aba109b9ac7e883d00b74d084e58f37acd805e3.1740479886.git.naveen@kernel.org>
Message-ID: <aD-LDPPQ6elCrDdH@google.com>
Subject: Re: [RFC kvm-unit-tests PATCH 2/4] x86/apic: Disable PIT for x2apic
 test to allow SVM AVIC to be tested
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Naveen N Rao (AMD) wrote:
> SVM AVIC is inhibited if kvm-pit is enabled in the default "reinject"
> mode. Commit f5cfdd33cb21 ("x86/apic: Add test config to allow running
> apic tests against SVM's AVIC") disabled PIT in xapic test to allow AVIC
> to be tested. However, since then, AVIC has been enabled to work in
> x2apic mode, but still requires PIT to either be disabled or set to
> "discard".
> 
> Update x2apic test to disable PIT so that AVIC can be exercized with
> x2apic.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  x86/unittests.cfg | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 8d046e6d7356..35fb88c3cb79 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -14,10 +14,11 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
>  arch = x86_64
>  groups = apic
>  
> +# Don't create a Programmable Interval Timer (PIT, a.k.a 8254) to allow testing SVM's AVIC
>  [x2apic]
>  file = apic.flat
>  smp = 2
> -extra_params = -cpu qemu64,+x2apic,+tsc-deadline
> +extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine pit=off

Similar to the split IRQ chip, playing whack-a-mole to disable the PIT in every
test where (x2)AVIC might be interesting is rather silly.  The realmode test
uses the PIT, but AFAICT it doesn't need re-injection, i.e. we can simply disable
re-injection mode to get the same effect, e.g.

    qemu-429929  [233] ...1. 16531.028284: kvm_apicv_inhibit_changed: set reason=9, inhibits=0x200 PIT_REINJ
    qemu-429929  [233] ...1. 16531.028311: kvm_apicv_inhibit_changed: cleared reason=9, inhibits=0x0

I'll send a patch.

>  arch = x86_64
>  timeout = 30
>  groups = apic
> -- 
> 2.48.1
> 

