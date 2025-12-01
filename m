Return-Path: <kvm+bounces-65012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E24C9823F
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 16:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A0EF24E2184
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 15:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE962333433;
	Mon,  1 Dec 2025 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ye6IveXn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27F2332ED0
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764604548; cv=none; b=F8fm/u5Zk5AxXLcJ2oUjlNtaL/EMxpYtnHveBaW8/QTpMYO6Uh4OPEuffaYf4c8kG6qP4Ak5poKppaY9Sjojhb6Fw4vx2BsV94rpxnwrmy0p1aVSvrswH0WvSvccJ24/BUJraaQEAIAAgVpjNHHgN/27YZAqc4URh/HXxya5tn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764604548; c=relaxed/simple;
	bh=dYdbGSq1hyaFcK0Vbnfam/5HkvnPvCtpmqz5zFQEQRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gjeG6JIVrw811fELlyHX8ba8kcUc+biPRBaSF0DItZwu1ECdI6q7CxesOxI8P3hbPr07XAx+hjBljFl6MHa6oAuZXQRdedl2fy0u+AcJ6c3EKdH3tavreyEc6sENMOxGf25q6fywj2hMX53HbhrQchUIphgaEp/PARxcquJFHqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ye6IveXn; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7c240728e2aso7879425b3a.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 07:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764604546; x=1765209346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ojq6WP276k7ulL9n/nH2NWkQuA4BiAIh8qTVVTbn9M=;
        b=ye6IveXnVs4CDuLtYir996MjXQ1yd1ff9QWu5neXcsTrnPO/K1Y2kSzolPhPP7hOw6
         JXZGx5X8BYRQPfJ/AazJQNOGA8/VwUUTnvNE0tREShUsJPKQqsxeFHbNoIys83MJ8lhw
         uWhOGMBY1RqmTTNsehAzAoOGFiIMLK8dHy9bhoFAp9uS6O5UnDl76+SJi7+K3FT1KCkH
         X4JAsmBLfmAaXwb4rQx5/nZF6aqBoDftR6mTyhNaCzZfdWTBwLAAaS4wPhPu++dF3Cnb
         M2IxQIuVpfk63Ju9U6Ww1oqIRKkEUUNWmffIpIWfUsH7u+aRHNlIMWIE72K89WsstD4E
         OvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764604546; x=1765209346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ojq6WP276k7ulL9n/nH2NWkQuA4BiAIh8qTVVTbn9M=;
        b=GNDmMfjhrgQmBsgi7FY4ggpIwXApg6xJFRXyg5p9LWV5ZJNGTUKLHD8WZbGClYx1uD
         gBZ4W22ERUfavTttNkoReceH9UALeYcTkKV33XHlhhRlhxjvhmW1DXiSz6D13cfiQIqD
         Flj4yP+DVJUM1kEazl/JKW4a4jY4bnsfqxIyXK8/sziMDHq/zGVpC4zQrmVIcDKKI4IH
         YeTcw8XmOy3eerAb2+uMb0GBkeLtNHEe6rN5ak1RvNU3bqloa1veP7w47OpxGeKbpTZF
         AQatdMcLXnqiGuFrvjEn0T27AcfSJIyS0b4HNEM1jZEQbOtcYbL9xCUZZlEX9uSLBJZK
         OjzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG9RXZec6X1hYCha4gb63kwLRDk97jrZ3VIvs8Myhx47NDedJw43qS460trAMAknn9ENU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvuYfMtKkmCK+ZDyyArzeopr68z1y2Uc3riEjQnrb5Dijg2b4L
	Phw6gsBNZB/QUBH0RANt4Mic+o20Ye/N2B86nPxs/S4Fn/505l/e8P/IppimctRPL54IEsMHyxn
	yW23yBw==
X-Google-Smtp-Source: AGHT+IHYlsnd6krdSCI3OWnVJ7V1appZkU6hmkhgHr+N2fGX/9NSiltXr3T5N0gnEQ22pw551C85ykj99i0=
X-Received: from pgve25.prod.google.com ([2002:a65:6499:0:b0:bc3:cbd2:e0a1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da3:b0:34f:a16f:15ad
 with SMTP id adf61e73a8af0-3614edd99bemr45418160637.53.1764604545930; Mon, 01
 Dec 2025 07:55:45 -0800 (PST)
Date: Mon, 1 Dec 2025 07:55:44 -0800
In-Reply-To: <20251128123202.68424a95@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com> <20241211013302.1347853-6-seanjc@google.com>
 <20251128123202.68424a95@imammedo>
Message-ID: <aS26gBXQnHjgSDW5@google.com>
Subject: Re: [PATCH 5/5] KVM: x86: Defer runtime updates of dynamic CPUID bits
 until CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 28, 2025, Igor Mammedov wrote:
> On Tue, 10 Dec 2024 17:33:02 -0800
> Sean Christopherson <seanjc@google.com> wrote:
> 
> Sean,
> 
> this patch broke vCPU hotplug (still broken with current master),
> after repeated plug/unplug of the same vCPU in a loop, QEMU exits
> due to error in vcpu initialization:
> 
>     r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);                         
>     if (r) {                                                                     
>         goto fail;                                                               
>     }
> 
> Reproducer (host in question is Haswell but it's been seen on other hosts as well):
> for it to trigger the issue it must be Q35 machine with UEFI firmware
> (the rest doesn't seem to matter)

Gah, sorry.  I managed to handle KVM_GET_CPUID2, so I suspect I thought the update
in kvm_cpuid_check_equal() would take care of things, but that only operates on
the new entries.

Can you test the below?  In the meantime, I'll see if I can enhance the CPUID
selftest to detect the issue and verify the fix.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d563a948318b..dd6534419074 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -509,11 +509,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
        u32 vcpu_caps[NR_KVM_CPU_CAPS];
        int r;
 
+       /*
+        * Apply pending runtime CPUID updates to the current CPUID entries to
+        * avoid false positives due mismatches on KVM-owned feature flags.
+        */
+       if (vcpu->arch.cpuid_dynamic_bits_dirty)
+               kvm_update_cpuid_runtime(vcpu);
+
        /*
         * Swap the existing (old) entries with the incoming (new) entries in
         * order to massage the new entries, e.g. to account for dynamic bits
-        * that KVM controls, without clobbering the current guest CPUID, which
-        * KVM needs to preserve in order to unwind on failure.
+        * that KVM controls, without losing the current guest CPUID, which KVM
+        * needs to preserve in order to unwind on failure.
         *
         * Similarly, save the vCPU's current cpu_caps so that the capabilities
         * can be updated alongside the CPUID entries when performing runtime

