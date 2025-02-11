Return-Path: <kvm+bounces-37894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C356A311C5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA759188B6D5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A679E254B0B;
	Tue, 11 Feb 2025 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S/k6rGQv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404A254AFE
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291840; cv=none; b=Vaw0Dd8B9jeg4NT5wKX38o5F/9izM1LQ1SmENqmweBuWNfmx5V46haGESXL/07P4Y9YW4BXe3vLVSHhqYqrp/9IWTj4NqfP1zBSddAPg9Ep5m0zI2PYGnTjKjEESFm90wjlRyo8115cC9GLIUR3rE+cWNX2ShZaoqJad7YVBqy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291840; c=relaxed/simple;
	bh=jn5aVdVpmULQpMPMJm09Nw0JRtsT7JhnTjDn122jAM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oXMoiLW+EOsi30zBAqcxCK4LCNQazSLD388Y3ed0NwPT8IBEAIlGhoyRxeJ0kZ8SlspxolqCp9G5ZydKm+qfHTCwmcxEougHNmQewK+d1NwB8mBkJsBPm9OYOBzzDRwGk9tJ66UjhOm8WSTZpsKpztpazL2btrluYZ35fWP1fcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S/k6rGQv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa562cc2a6so6512719a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739291839; x=1739896639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JLItSN1MoQyG8GNmr/coUh7HtvBOUtOuKm2mJhYmGOU=;
        b=S/k6rGQv2sd09wvQWu4CxrWaNq+dXZl1NBmEc0P6Y5TdvtC145mHjV5e1H5GHSudxh
         cpcYur9fqAazdsQpsukNTH3471ZAVfnlJmwXBAJz0KldubUsuRvGrcFbZwsv7vResNwe
         o3mY1Uu60B1jV4lJv5nClmxtaptgkuYHO1WNiWZ0GUd+as724vldsDysA7z22SOzqWiC
         oAiBLWA5YlMAWBj9EDTayTwBt/piZeYs1DPg/YHhoSa6bA/3ZWXixw0jQkQchi/gno43
         yRgyYPyCx6RtMMBznvNYh30CP9RHpRrxQHBVnGMtCfi3BPP1knd0yrax7elTg3J0BrPi
         bd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739291839; x=1739896639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLItSN1MoQyG8GNmr/coUh7HtvBOUtOuKm2mJhYmGOU=;
        b=vHrndEQNUYyAATcoY1Ndzc/u9Mist/J+PJ2m6IlpWyk0BfQo/aM9VNzVyicjVHHaRx
         v/ZzxnLX/dRJ0cqgVv1nf8v3Q+q0rPqesvSLrNi6kp4WOH/FFHo2B5qtECNqm0DHTdEg
         tZfSDLgdILlHURjJZ8BOI20q73ESnJt0fEvdRX5qVIIu4tDMUUpVkzlFEByE2mwaTsYp
         BKssznH5/dcD7XOSJo2Ph6CoH8q6khAnVSIxC7PW7Ge/kp3Qce2ISrQNYvAGIrU0M9vh
         bb8gLbMRdcPZYCIREymtTTudeTymDrmkHZErhxZDdUfm7NPzTh5JxxwGJIEo17WO+9KH
         LYfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/4ayw4tn0W7T5BoDrG2e2YZoIwTeviMEjWW5wRgLj2/Fp9zt+3oE2gx/01e9pYAaVpTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvMQlmw2tm1BNDNOXucrtMIP6rR97ssZUOYDS6yPvkGYI3r4tT
	NZ47HlxKVAbkQsGxePiPiaZBiyjlK7yote+wX+BAyEknz8DBZDsE8BRtY1Tf2bseg1YU34eKMdm
	W1g==
X-Google-Smtp-Source: AGHT+IFqd6KdRVdCmUO59/npCeKNaG1EJTFDEmz3/mg0SIO6eDFXmBhqZXAxfPMIgJm2ELHJVsiQJ5v9nxc=
X-Received: from pfih20.prod.google.com ([2002:a05:6a00:2194:b0:730:7485:6b59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f84:b0:730:9446:4d75
 with SMTP id d2e1a72fcca58-73217f5695emr4992739b3a.17.1739291838539; Tue, 11
 Feb 2025 08:37:18 -0800 (PST)
Date: Tue, 11 Feb 2025 08:37:17 -0800
In-Reply-To: <yrxhngndj37edud6tj5y3vunaf7nirwor4n63yf4275wdocnd3@c77ujgialc6r>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com> <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com> <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com> <604c0d57-ed91-44d2-80d7-4d3710b04142@redhat.com>
 <yrxhngndj37edud6tj5y3vunaf7nirwor4n63yf4275wdocnd3@c77ujgialc6r>
Message-ID: <Z6t8vRgQLiuMnAA9@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Naveen N Rao wrote:
> On Wed, Feb 05, 2025 at 12:36:21PM +0100, Paolo Bonzini wrote:
> I haven't analyzed this yet, but moving apicv_irq_window into a separate 
> cacheline is improving the performance in my tests by ~7 to 8%:
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9e3465e70a0a..d8a40ac49226 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1355,6 +1355,9 @@ struct kvm_arch {
>         struct kvm_ioapic *vioapic;
>         struct kvm_pit *vpit;
>         atomic_t vapics_in_nmi_mode;
> +
> +       atomic_t apicv_irq_window;
> +
>         struct mutex apic_map_lock;
>         struct kvm_apic_map __rcu *apic_map;
>         atomic_t apic_map_dirty;
> @@ -1365,7 +1368,6 @@ struct kvm_arch {
>         /* Protects apicv_inhibit_reasons */
>         struct rw_semaphore apicv_update_lock;
>         unsigned long apicv_inhibit_reasons;
> -       atomic_t apicv_irq_window;
> 
>         gpa_t wall_clock;
> 
> 
> I chose that spot before apic_map_lock simply because there was a 4 byte 
> hole there. This happens to also help performance in the AVIC disabled 
> case by a few percentage points (rather, restores the performance in the 
> AVIC disabled case).
> 
> Before this change, I was trying to see if we could entirely elide the 
> rwsem read lock in the specific scenario we are seeing the bottleneck.  
> That is, instead of checking for any other inhibit being set, can we 
> specifically test for PIT_REINJ while setting the IRQWIN inhibit? Then, 
> update the inhibit change logic if PIT_REINJ is cleared to re-check the 
> irq window count.
> 
> There's probably a race here somewhere, but FWIW, along with the above 
> change to 'struct kvm_arch', this helps improve performance by a few 
> more percentage points helping close the gap to within 2% of the AVIC 
> disabled case.

I suspect the issue is that apicv_inhibit_reasons is in the same cache line.  That
field is read on at least every entry

		/*
		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
		 * update must kick and wait for all vCPUs before toggling the
		 * per-VM state, and responding vCPUs must wait for the update
		 * to complete before servicing KVM_REQ_APICV_UPDATE.
		 */
		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));

and when opening an IRQ window in svm_set_vintr()

	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));

and when handling emulated APIC MMIO in kvm_mmu_faultin_pfn():

		/*
		 * If the APIC access page exists but is disabled, go directly
		 * to emulation without caching the MMIO access or creating a
		 * MMIO SPTE.  That way the cache doesn't need to be purged
		 * when the AVIC is re-enabled.
		 */
		if (!kvm_apicv_activated(vcpu->kvm))
			return RET_PF_EMULATE;

Hmm, now that I think about it, lack of emulated MMIO caching that might explain
the 2% gap.  Do you see the same gap if the guest is using x2APIC?

