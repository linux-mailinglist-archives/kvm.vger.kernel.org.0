Return-Path: <kvm+bounces-39300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0689A4658D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 16:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B44EB17FBE8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2174227EA8;
	Wed, 26 Feb 2025 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u5YAoUAB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D878224AFC
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740584557; cv=none; b=a970E/Szx2hV7sy4yTQ7MTS+tyZlKf+RzCMOX7fLdlaIIEN4mYnDgRIETGcH6PJ1Vpb3ahH8157ugpAYTPU3MV9ovibvGw7W+gGemg9StLAuvOCr2Wdwx8QHf2xRP0IEx7KANZO3OwkhNma2PSkVo26uwQ0SdLYCSPL0Vbs1Cxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740584557; c=relaxed/simple;
	bh=KRbKUmd8Suh0ja88yDnOaLL3FokkPJkbkg0mjqCewOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AN/EmJ9yd2bvxhYgnjnNZi1jWu1DoF9HsZH/EqdFSyGW/vtFzGZf7b0DuJcIU9jPxH7EVQxCtgOb0i1TXTDa8bL0btZcbG7pH6jQOJFOcdqHi2PbngcUmfTM/gg1gACcrhl+jGZcytN4bEtt0Gqi2qPIHuMkpDNlpDqJLQ2C3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u5YAoUAB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220e7d654acso2985ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 07:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740584555; x=1741189355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSAqjdZM9yF2VJZLhOFBgrAn7uoeADGTauD56+5W3jo=;
        b=u5YAoUABa2oLONJ+PYG0g9c1eRwCzHtps8JqmL+1k/Az+oGyI8cnGtFzo+N6JwNCZB
         GAZPM9BIkJkFiFKDVE5zpy0iHteuxJV6PrQP8CyzKsbgpx1IRacZthkcVspeesfHHkQx
         iAzr6z98QF5DPAQ2pI6zSJ4dhN032RE7w3MmOr+kkWq+A/BAbIw35HN04gtUQ8Vj9Qm0
         oUCc6qam1PhG0WCkGt6JktZjD1Tq6mH2ujoK+c6ZJFYZ6WC9Y9VzFqezytu+W/ZmZbdB
         PCpEV/oNBM8Q2ZveceEe6k/Jr+0gAScr0qUQhC0EJ8Z91CEMgwvtzydaGUNBVnplJZ+M
         u0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740584555; x=1741189355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSAqjdZM9yF2VJZLhOFBgrAn7uoeADGTauD56+5W3jo=;
        b=J2s54OFvs1S4tQZC9nnvp5SrTuVIWfWaXNmvVGOXKIeNGzbvPIjnw2QsWLwaTm7w33
         rCLaHXnj+3/z+GSw1NI+RHfqO0T4dmnjGKvvNqmjabieC6p1faoY3EQ76k9Kn/587MiV
         BqXTkZbMGMhfkLvYklFTOSg80AodjCj5Zhshfdzke5K+CgtJ75cdBitMi4h2kaDrQ1m5
         d59JiflYaAFrws/WVi1QUnXy6dNYkUEtJp5yc2rBYPwRAc5XOnONyNofcqNWxu5CiZ7M
         XL392MyxbCLdVWRcdFLtfbTcArkv7xZ/HHvR1a8x2owzAfAMM9dKB5RE6M1V8uDXTdaD
         5FZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsTbL4mI5dvRAdXpAFj+LSKS7vb6BB8GbSzrng5/7/hSbZzhyrkCfzEKdraa+9atKBxic=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOxWCg66nd0DNDCehBh3byBY7MMiQVG/eAGya+W2FjsBscPGkC
	zkplHaZAiqQ5T7yHTz6ovHuxk3cspDh0bSE+/qgNgDQfLQmFOA1DEwH78jaKw5KKfZuxXrHsZ+C
	scQ==
X-Google-Smtp-Source: AGHT+IFm9njjlE5pNfUsyb0x+WyhU0sjdiJXmXwvl42UNErt6Y32P30aKUQuxsLOSVMzZQUcZv28ZRoAdDA=
X-Received: from pjvb12.prod.google.com ([2002:a17:90a:d88c:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc8f:b0:221:1497:7b08
 with SMTP id d9443c01a7336-2218c76416fmr473436145ad.23.1740584554883; Wed, 26
 Feb 2025 07:42:34 -0800 (PST)
Date: Wed, 26 Feb 2025 07:42:33 -0800
In-Reply-To: <27bd2e67-5e19-480f-8382-26969045d2f2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224181315.2376869-1-seanjc@google.com> <20250224181315.2376869-3-seanjc@google.com>
 <27bd2e67-5e19-480f-8382-26969045d2f2@amd.com>
Message-ID: <Z782aeSYZpsoD7uK@google.com>
Subject: Re: [PATCH 2/3] KVM: SVM: Manually zero/restore DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rangemachine@gmail.com, whanos@sergal.fun, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Ravi Bangoria wrote:
> Hi Sean,
> 
> On 24-Feb-25 11:43 PM, Sean Christopherson wrote:
> > Manually zero DEBUGCTL prior to VMRUN if the host's value is non-zero and
> > LBR virtualization is disabled, as hardware only context switches DEBUGCTL
> > if LBR virtualization is fully enabled.  Running the guest with the host's
> > value has likely been mildly problematic for quite some time, e.g. it will
> > result in undesirable behavior if host is running with BTF=1.
> > 
> > But the bug became fatal with the introduction of Bus Lock Trap ("Detect"
> > in kernel paralance) support for AMD (commit 408eb7417a92
> > ("x86/bus_lock: Add support for AMD")), as a bus lock in the guest will
> > trigger an unexpected #DB.
> > 
> > Note, suppressing the bus lock #DB, i.e. simply resuming the guest without
> > injecting a #DB, is not an option.  It wouldn't address the general issue
> > with DEBUGCTL, e.g. for things like BTF, and there are other guest-visible
> > side effects if BusLockTrap is left enabled.
> > 
> > If BusLockTrap is disabled, then DR6.BLD is reserved-to-1; any attempts to
> > clear it by software are ignored.  But if BusLockTrap is enabled, software
> > can clear DR6.BLD:
> > 
> >   Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2)
> >   to 1.  When bus lock trap is enabled, ... The processor indicates that
> >   this #DB was caused by a bus lock by clearing DR6[BLD] (bit 11).  DR6[11]
> >   previously had been defined to be always 1.
> > 
> > and clearing DR6.BLD is "sticky" in that it's not set (i.e. lowered) by
> > other #DBs:
> > 
> >   All other #DB exceptions leave DR6[BLD] unmodified
> > 
> > E.g. leaving BusLockTrap enable can confuse a legacy guest that writes '0'
> > to reset DR6.
> 
> What if guest sets DEBUGCTL[BusLockTrapEn] and runs an application which
> causes a bus lock? Guest will receive #DB due to bus lock, even though
> guest CPUID says BusLockTrap isn't supported. Should KVM prevent guest
> to write to DEBUGCTL[BusLockTrapEn]? Something like:

Ugh, right, AMD's legacy DEBUGCTL_RESERVED_BITS weirdness.  Ideally, KVM would
make bits 5:2 reserved.  I suspect we could get away with that, because VMX has
rejected all bits except BTF and LBR since the beginning.  But I really, really
don't want to deal with more guest breakage due to sending such a change to
stable kernels, so for an immediate fix, I'll add a patch to drop those bits.
That'll still be a guest-visible change, e.g. if the guest is enabling LBRs *and*
the legacy PBi bits, then the state of the PBi bits would be accurate.  But given
KVM's craptastic handling of DEBUGCTL, I highly doubt dropping bits 5:2 will break
anything.

*sigh*

And that's exposes yet another bug in this code.  Zeroing DEBUGCTL before VMRUN
is wrong if the guest has enabled BTF.  KVM should *load* the guest's desired
value if DEBUGCTL == BTF, i.e. if BTF is enabled but LBRs are not.

> ---
> @@ -3168,6 +3168,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & DEBUGCTL_RESERVED_BITS)
>  			return 1;
>  
> +		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
> +		    !guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> +			return 1;
> +
>  		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
>  		svm_update_lbrv(vcpu);
>  		break;
> ---
> 
> Thanks,
> Ravi

