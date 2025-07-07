Return-Path: <kvm+bounces-51699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4667BAFBBF3
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 21:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25E491891190
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE6B2676C9;
	Mon,  7 Jul 2025 19:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KA7xvrKG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC8D2E3716
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 19:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918060; cv=none; b=V5j9PlfGytrX/wwHLni2GMQpLRHUVyyF6zZQl87pg3UvKvttd0nRmkTpVd4Ym9gF2pVB23FqPnMfmPxhOPBykupCFO07QoM5dgnQ37gVPo/VaOo00mQk903Ffj1FUi7T+5KsIqF4IWqT7UN9NpPkhvM2SqDYFCoA33zYdHqpqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918060; c=relaxed/simple;
	bh=H8qEbUfQ7QyvwOkwbhXHQStgZi1wyInh+BiQpsfgFso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=siO96Bx7FDRkdlo+IS1LWk7kkvbMk4OoVthyxCV8TVY1JwWjQlydJtHqJKhzeS3toa4TjKQdJyp8GeDLXGWOFzGlTzq79z7NHXIXjogczJ9vsgDXjnuwEZb3lYZUGCnyI3dBlr/5fuOaQTNoa9tFB5LbgkGlFB4hAmHomaW4Bho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KA7xvrKG; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748d96b974cso2896153b3a.2
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 12:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751918058; x=1752522858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvkjx2/EXKNVPNHMXsjFWWDExhVd8STolUBKVwumVSQ=;
        b=KA7xvrKG00aT3GspPC/yAh4gJ48jFTTAz/63nd0zDyv5C7SBcXQZDJcb57t1i3EMIs
         /oLDT19D5/5lgWkka+FH8XSYG9vEfHd1yqYxIBZkAEFR/nbpYJXRA2CAkeBvFAkOj9rD
         37TapwBgP9HZqmuYkFphvyTXLfAez2wW/UnX+k7r28WvggswT9bDRXkxUWnwJDDnd7U1
         FDlvklCGRKnyNvBphwOi+6/Rny5HBllM+ISbLXI6a3IAyn4KT9oy5bgLX9VO52RQW2nk
         ImG/myM9u7lHnEIzo2cFBhnmgU6C7qUlRxfsOs3mdnzA8Shdla/GAeAY/ADj1kzBTeyD
         RiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751918058; x=1752522858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvkjx2/EXKNVPNHMXsjFWWDExhVd8STolUBKVwumVSQ=;
        b=Zsb0Q+gL0g6TkmkpAPCl2yAmNqFmVGmFdfBGZMPv71tQrtt18W44Qd/jA4r6sGuiPC
         J3UiQ/nxyjoaSHnjReSbaAl5m764VYwDYfUlSbvjyN1rYimmdhPfCdJpfDnhgzm3aby3
         u65Jux6LGf5zatD7EZ3/lAGeGTrogAe9lssKO/6gEJ2wMTChZ5lzZo2jj/YmJVU5NHVU
         AMOSPMxYsYuGoaMRp6Tko2uhbeQbXk1ihV51GvHEOlLm2AuKN26crXyLIyCPoG9b7MH6
         UoJMSkavnsSl92izEAGHlj8PSwuzcqzo4+7HETzQ/FTC8JCo5SE7CqwLsBU1JOsVcpTW
         jx4A==
X-Forwarded-Encrypted: i=1; AJvYcCWoZtlIVFD2nMNv90tcC+bm2uglzGYvUuf70oB4klpZodTUBuuisVwavgLnPowryx90N4g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7teqeXxXeqO7xY1p3VP8Te1sRWWNZFN+qfrltvFKeGrIRIzk1
	fJOTJXRLhC+8j3O5J/j1PjQ3DdfTotXC0d4Ni49Jr64/jIyObMnHElFQ7BK2+sN9gyV65FSykWS
	RYiA6GQ==
X-Google-Smtp-Source: AGHT+IE/n24T+yY82t7dVRDwU/3hR1H7fbmnSobXXAgaDbo+nhrjc/FK4GpjJIoi0wiHsG3fN7p26DN5fIY=
X-Received: from pfbfc40.prod.google.com ([2002:a05:6a00:2e28:b0:746:fd4c:1fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4483:b0:748:fd94:e62a
 with SMTP id d2e1a72fcca58-74d242e8ad6mr793708b3a.1.1751918058346; Mon, 07
 Jul 2025 12:54:18 -0700 (PDT)
Date: Mon, 7 Jul 2025 12:54:16 -0700
In-Reply-To: <20250702132307.71e3b783@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com> <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com> <20250702132307.71e3b783@fedora>
Message-ID: <aGwl6GUwYsGVXG5k@google.com>
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Alexandre Chartre <alexandre.chartre@oracle.com>, 
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org, 
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 02, 2025, Igor Mammedov wrote:
> Or even better a single KVM optin feature 'do_not_advertise_features_not_supported_by_host_cpu',
> and then QEMU could use that for disabling all nonsense in one go.
> Plus all of that won't be breaking KVM ABI nor qemu had to add fixups for this and that feature.
> 
> After some time when old machine types are deprecated/gone, KVM could make it default and eventually
> remove advertising 'fake' features.

Such a feature/quirk wouldn't be useful in practice.  There are several features
that KVM emulates irrespective of hardware support, and that generally speaking
every VMM will want to enable whenever possible, e.g. x2APIC, TSC deadline timer,
TSC adjust, and the amusing "no SMM_CTL MSR" anti-feature.  Throwing out x2APIC
and TSC deadline timer in particular would be a significant regression, i.e. not
something any end user actually wants.

If QEMU or any other VMM wants to filter KVM's support against bare metal, then
QEMU can simply do CPUID itself.

Somewhat of a side topic, the somewhat confusingly-named KVM_GET_EMULATED_CPUID
exists to allow KVM to differentiate between features that KVM can emulate and/or
virtualize without additional overhead, and those that KVM can emulate but with
non-trivial cost.  E.g. KVM advertises MOVBE and RDPID in KVM_GET_SUPPORTED_CPUID
if and only if they are natively suppored, because enabling those instructions in
the guest's CPUID model turns exitless instruction execution into expensive #UD
VM-Exits and slow emulation.  But KVM unconditionally advertises support for them
in KVM_GET_EMULATED_CPUID so that userspace can run a "newer" VM on old hardware.

I mention KVM_GET_EMULATED_CPUID purely to stave off any exploration into trying
to move ARCH_CAPABILITIES to KVM_GET_EMULATED_CPUID.  Name aside, it's not the
correct fit (and would still be an ABI change).

