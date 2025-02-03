Return-Path: <kvm+bounces-37148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84704A262CA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 293737A252E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72531199236;
	Mon,  3 Feb 2025 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxhBoA9+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B470821
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608331; cv=none; b=ig+yQ3MTjpioAfOrsWyBxSuUPHy5U6VSkBpuGUkTZwataEMoDtJNTVQPl9Nr9x4llBWALs+G6Mr+Zcikbvv+Fzol3De916qrKQR9ABT61L+GqvKvZPxn7j3owod3C5ViqY0Bu9xCYJLNbntXnfeJpkP4KVD715tmAOK+n6Y8npM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608331; c=relaxed/simple;
	bh=/4W9xvHGeCr3mU6Qd3+ZKz3UtiIi86q6ZuHSHXmqbcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQqyBuldA94SiaAvvK8g4wgnwmXi9MXtTEtUc/X3Cj4KMXFWSxyBE11ey5UYzwsvK4pzYDrikKusKJDNJz1LSlcmqsUWegy6RNMtgt2GBe7qt/s7JZ2EPPaiVoOzhIK99Dop09OYrSjlfwFbVtu8fR5RSlO3C4Z91Wt+CvLfCTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hxhBoA9+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2167141e00eso112474365ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 10:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738608329; x=1739213129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8EBg9yr3SZ5VzxNr92/uhVOfd5I96F3xw5RlnlgXXyA=;
        b=hxhBoA9+5ULyfSV25WYAU4j6/W9Vr2Yho77ifa9MH0VcTXHeKvGOpYx38pCoR91N+e
         4ht1272ZOz8u/Hdqx3bWpKERN+M8dUwucY+RXkNxBQJbBAQ5T8LUHAKiB2AkakU+ywGD
         n5EolzI+WFUNHbrKmFkL/ZKN8k9AZeyp3eZabUgnTcZdfUQ4zNIa7WLhKAwcjIehjYuy
         gRP58/vrNdUvzuhYS+Ww+GDXeBvyeyMVAAxL6f6UK5zxLK6i9ujv0CezrhpkOC3B8uvS
         Fezy0QudzaD4uLtYFaDiahhtTZJMskWC/4aTfUzjdDgnJ2VDcAhNjPxwPxpiJkcvhsYH
         LTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738608329; x=1739213129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8EBg9yr3SZ5VzxNr92/uhVOfd5I96F3xw5RlnlgXXyA=;
        b=M9TYrhrgA+WozOeUkUVIqf59Xe20fus5pO59wt808nmoEQAoymuzPpHIMfanC4/l28
         NhxEYP/F30kVMjlu62Nle/McMCbwegSKs42nN7ZAPMyPN/oHrhMSDO7tbiOHuhkDjrda
         8aKQRxgd5qZu9MUxl8VleNkZLz+QZ8zhGLSKTSvR5phAjAwETpteA9qlzdjIF7DuqCRv
         0vUDzl+tsBwP/EmjMmLj4L872i1oCp1MJp6ShmkFr2wqqEpVKpfws6+9HLua/r1IFwd2
         TJ4Ct+Yh+7alRkhi8TFhAhQAjdwnSwgsaVaqzVJQkgYKgnjLleqlYqjMWKWHhR7zuAA3
         xbvQ==
X-Gm-Message-State: AOJu0YwBX5aopoFYSDHarGkfsV+Nml6rtbF3X62hgIuzmXDPyZkuabJg
	yZTOrXI63N83v/361y9Q+Cph+El69Cu6zkjAxOFt7ebtAqqB2HpVfbT/C38/JmPIfopCY3DWyk0
	hag==
X-Google-Smtp-Source: AGHT+IEckrImT0quLmOSWMfOCxjo0iCWgxhLoZRf4K4HDS8cgcz0+IkmWvTXp8SAwP/of2B0DqD2j7YL6E4=
X-Received: from pfjf11.prod.google.com ([2002:a05:6a00:22cb:b0:724:f17d:ebd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9186:b0:1dc:e8d:c8f0
 with SMTP id adf61e73a8af0-1ed7a6b825amr40319556637.29.1738608329238; Mon, 03
 Feb 2025 10:45:29 -0800 (PST)
Date: Mon, 3 Feb 2025 10:45:27 -0800
In-Reply-To: <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
Message-ID: <Z6EOxxZA9XLdXvrA@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Naveen N Rao (AMD) wrote:
> apicv_inhibit_reasons is used to determine if APICv is active, and if
> not, the reason(s) why it may be inhibited. In some scenarios, inhibit
> reasons can be set and cleared often, resulting in increased contention
> on apicv_update_lock used to guard updates to apicv_inhibit_reasons.
> 
> In particular, if a guest is using PIT in reinject mode (the default)
> and if AVIC is enabled in kvm_amd kernel module, we inhibit AVIC during
> kernel PIT creation (APICV_INHIBIT_REASON_PIT_REINJ), resulting in KVM
> emulating x2APIC for the guest. In that case, since AVIC is enabled in
> the kvm_amd kernel module, KVM additionally inhibits AVIC for requesting
> a IRQ window every time it has to inject external interrupts resulting
> in a barrage of inhibits being set and cleared. This shows significant
> performance degradation compared to AVIC being disabled, due to high
> contention on apicv_update_lock.
> 
> Though apicv_update_lock is being used to guard updates to
> apicv_inhibit_reasons, it is only necessary if the APICv activation
> state changes. Introduce a separate boolean, apicv_activated, to track
> if APICv is active or not, and limit use of apicv_update_lock for when
> APICv is being (de)activated. Convert apicv_inhibit_reasons to an atomic
> and use atomic operations to fetch/update it.

It's a moot point, but there is too much going on in this patch.  For a change
like this, it should be split into at ~4 patches:

 1. Add an kvm_x86_ops.required_apicv_inhibits check outside outside of the lock,
    which we can and should do anyways.  I would probably vote to turn the one
    inside the lock into a WARN, as that "optimized" path is only an optimization
    if the inhibit applies to both SVM and VMX.
 2. Use a bool to track the activated state.
 3. Use an atomic.
 4. Implement the optimized updates.

#3 is optional, #1 and #2 are not.

It's a moot point though, because toggling APICv inhibits on IRQ windows is
laughably broken.  I'm guessing it "works" because the only time it triggers in
practice is in conjunction with PIT re-injection.

 1. vCPU0 waits for an IRQ window, APICV_INHIBIT_REASON_IRQWIN = 1
 2. vCPU1 waits for an IRQ window, APICV_INHIBIT_REASON_IRQWIN = 1
 3. vCPU1 gets its IRQ window, APICV_INHIBIT_REASON_IRQWIN = 0
 4. vCPU0 is sad

APICV_INHIBIT_REASON_BLOCKIRQ is also tied to per-vCPU state, but is a-ok because
KVM walks all vCPUs to generate inhibit.  That approach won't work for IRQ windows
though, because it's obviously not a slow path.

What is generating so many external interrupts?  E.g. is the guest using the PIT
for TSC or APIC calibration?  I suppose it doesn't matter terribly in this case
since APICV_INHIBIT_REASON_PIT_REINJ is already set.

Unless there's a very, very good reason to support a use case that generates
ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
clear it.  And then we can more simply optimize kvm_set_or_clear_apicv_inhibit()
to do nothing if the inhibit is sticky and already set.

E.g. something like this:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d4a6734b2d6..6f926fd6fc1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10629,6 +10629,14 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
        if (!enable_apicv)
                return;
 
+       if (kvm_is_apicv_inhibit_sticky(reason)) {
+               if (WARN_ON_ONCE(!set))
+                       return;
+
+               if (kvm_test_apicv_inhibit(reason))
+                       return;
+       }
+
        down_write(&kvm->arch.apicv_update_lock);
        __kvm_set_or_clear_apicv_inhibit(kvm, reason, set);
        up_write(&kvm->arch.apicv_update_lock);

