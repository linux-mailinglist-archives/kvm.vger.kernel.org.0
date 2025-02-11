Return-Path: <kvm+bounces-37890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBFBA3114E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 391153A42AE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A62B1255E32;
	Tue, 11 Feb 2025 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJfVChW7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A81E24C69D
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291303; cv=none; b=LgowT6ve6We64tZrlXXoVZYTP5W7EJ2/h7IpE8EmcpT0J1XOLyUrdy+L2VNGsg4SsM2ACwktPfwddU19GxiT/Uj9Wnoe6ywbc7GPReVtPVF6S3/Wp4Mja72/itZbUUUAtw3hnin58suj1tslqJKQVyQJ7qV+pB/zClK09lJzM3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291303; c=relaxed/simple;
	bh=yilJGqWW4RYMKFOjUyyusb+5EmeDe91eA1bXhwR/YFI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6wBZJX7lk5x4BJ+lTQ6dzWGUAlAU2NodYTCyLoO4TggJXQkh677YCLx2yzuZgeXI427pqUBpSsqwrrO//6ytiRhpQ+DY0UXZ+05u3MTnc4g0Q3iLBGyoxJNvXSfYbuDYAAyq1wgPvjXE4+UFmpHpwnRkyS+gKEH6FyKuVjSvsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJfVChW7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so11356014a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739291301; x=1739896101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5MEK/stSb+AMRyC9Zhx6OFHXRnHPVcvklj9Pc8LhwOQ=;
        b=BJfVChW7Y2jO/ywJh08g35IqukXtKRfHNnPeT6Bb3V/ctZQ55gghSQG/uMR3pK21Bs
         JvH9zAxfQCZnieEjFG21FepKyMy0VktvKZSM/wHgUVMek3KngJeRFAWXnlQAkLJT1fBO
         0kMJoJyBhJn5C60ZaCV+zrWIdUi6Zp+F0SaVohKpppry40OkTPtUxLz0BEJcAkrE4P3z
         coKYEgCgw68vqVQHOn3wKvdFlL+OtKZkDRqGA1tdPq6Qwq9gKRpKzP6HBbxvHQFo4dfz
         lyfP8pWshLNusB9L9qdUDpMa8h2AQPhbAQKAkjhxJAY7oMQSiK0mbyUUy75QWfWcg40P
         i1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739291301; x=1739896101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MEK/stSb+AMRyC9Zhx6OFHXRnHPVcvklj9Pc8LhwOQ=;
        b=XpgELMZUvwzB0ggkkEwr+kFGMawXnYFplgpbTeP/kl72KN3ldMJ080gKhLlCemly0Y
         J+QiYvPs0l9HeKPHEpcqgyxN9ORgU3+HEBVKAOAyfVmDz0KO4NJ/wOvKe/U5d8XRUcV+
         7J/+x0ItnHnoYloTOf5BbXrbb8WZ28Fvm7GRkhLUwlbRgHHvPntZw9jrUbnjkmliO/4e
         BSoc3zLBE219KfY/BmzVCtdiHUi6wBLHTtUIr1f3BSeudNYI85LN4KipB2zWcER4MKpp
         60UhZEzjYPfxCB45IA0WeX6BwDnhCvRz6yf02IbMBwaTkkMrv1a2UKYej+DVwoIbDDT0
         9VsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSuS4phcWlOMmweh0ThgDJEOs5YKqreP0c+XCC/a1ppBgpnW7SmtGh6n5f0B9oA5VYiO0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7yWlGDbJxS1wtcN/mtuzsS6I4nPEt0U0fYE7Qha1SsVmqy3XY
	Zvgg8cr0w/YH9ROjXHYCkxxgkzAKgzHbYBDAm/JUD9IjR2Sbui9puS4ZH75RV8+3dDLt5+1ozJY
	SAQ==
X-Google-Smtp-Source: AGHT+IEW6FT5SzWSOj0JB0UAPg+blRK0ibYMj54XT+2rd1e326WroNU4nUmkSnUDL4aqV/75Jp14hq1SYiM=
X-Received: from pfrc11.prod.google.com ([2002:aa7:8e0b:0:b0:730:7648:7a74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:188f:b0:732:2170:b69a
 with SMTP id d2e1a72fcca58-7322170b72bmr3189092b3a.18.1739291301572; Tue, 11
 Feb 2025 08:28:21 -0800 (PST)
Date: Tue, 11 Feb 2025 16:28:20 +0000
In-Reply-To: <20250211143919.GBZ6thF2Ryx-D2YpDz@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com> <20250211143919.GBZ6thF2Ryx-D2YpDz@fat_crate.local>
Message-ID: <Z6t6pMgAjHckWMs_@google.com>
Subject: Re: [PATCH 00/16] x86/tsc: Try to wrangle PV clocks vs. TSC
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com, 
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Borislav Petkov wrote:
> On Fri, Jan 31, 2025 at 06:17:02PM -0800, Sean Christopherson wrote:
> > And if the host provides the core crystal frequency in CPUID.0x15, then KVM
> > guests can use that for the APIC timer period instead of manually
> > calibrating the frequency.
> 
> Hmm, so that part: what's stopping the host from faking the CPUID leaf? I.e.,
> I would think that actually doing the work to calibrate the frequency would be
> more reliable/harder to fake to a guest than the guest simply reading some
> untrusted values from CPUID...

Not really.  Crafting an attack based on timing would be far more difficult than
tricking the guest into thinking the APIC runs at the "wrong" frequency.  The
APIC timer itself is controlled by the hypervisor, e.g. the host can emulate the
timer at the "wrong" freuquency on-demand.  Detecting that the guest is post-boot
and thus done calibrating is trivial.

> Or are we saying here: oh well, there are so many ways for a normal guest to
> be lied to so that we simply do the completely different approach and trust
> the HV to be benevolent when we're not dealing with confidential guests which
> have all those other things to keep the HV honest?

This.  Outside of CoCo, the hypervisor is 100% trusted.  And there's zero reason
for the hypervisor to lie, it can simply read/write all guest state.

