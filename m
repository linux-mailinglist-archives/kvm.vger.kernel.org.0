Return-Path: <kvm+bounces-10301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E7386B825
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD1621F22501
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0170F74431;
	Wed, 28 Feb 2024 19:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IP9BevXJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819C074414
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709148560; cv=none; b=jZmN4dIf3g3C9fiJLZl9eIRAfQz7yU5vlBIpBUYPinLjTXx0hx+1jBvZsLMUKMd0Fa8Rc0Xi5IRbdNZwCT7DDuehZNDR27LD6Bp9eFf5phfJX15MYDL4RSLL+mRVULmqgdxu1ozPqVlstIfEXLY5mqogfCcizMC/6edVaj83nyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709148560; c=relaxed/simple;
	bh=HDIINGy+g4s1hGSMPco1nC2p3P5zb08MwBm6RlGXfn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q2Lymu1FAzFIBYwXLbqpR/uMlvh7tAFnb4S7zEy3jkNoRh1hdopJvfe4kZWqEyWREP89uw/ttUqIN52UWsxhLRwxoq2EhQK2ZuWBnqDGuuX3j0iBs8t2LHs7YWKbGR2Kn9FLMKrxn36eMBoEdNpSgKbhiAz5tlsommzuz9OE75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IP9BevXJ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6047fed0132so2031757b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709148557; x=1709753357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7saMouekiNL4SDnY8l1WG6+uM8tId4as9SNT1MABgI=;
        b=IP9BevXJd3HC4O9fDEXGpCRqJwv6FN40NePcqJZSiF/eesXruDf5uoiaOkMMYW3aKk
         f2ezIC2fJlC8HqQHP9/bjSa5Vv03lRQWEAlHtkC4Bso2sV/XRRX4PWUjtlP7RTFBDl8N
         EidRPb8lyh3Fpywe93H2Joh2Zzg3ACFZ2xohYhxmbuiE2FgE2mipQLBm/evMUJZoS2Ec
         wi+dOQL68sm+Tt67nX8ba/MQAQNWeqXeIl4wCy1BirloUR7WqhsvKJXsw9pkD6yGlZuu
         HJHgX1A7GJ/JVoL135K8f1teR88Jv62PwaqdvdJzHhTEdzrhriaiIUXehQqDixmM98eQ
         cwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709148557; x=1709753357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7saMouekiNL4SDnY8l1WG6+uM8tId4as9SNT1MABgI=;
        b=vD0OumAsq6lJfN3dxWY8eTbGSRtZuGcROgPqh9Ib8e0/fB7BFOGtSgAhy0+kRg+eMm
         nt+jH3HY3k9TWRZhLJycEdoUxfpnqcKvaIIN5Z/1W/4JRSzNZaKhGTw5DDL+Ca9LBaIn
         SgOXyv2YP/wnVQ6xJ0lA1DPG8ZMiskJIC4HXKl7il9U1kBntDzfi0rudT/myeaoi/f0J
         B5/dzpfJAMbzPybaewaXXgWHBcgakIVA39jdaNgEKVki1J6D0wWQ7PjFp1EbWsYUAISH
         ElZ5oFKwvi5bwDoRDckqiEHLVuoTTWyzHOZgjuGTdN0k3sPIDz75oXavARMxT/zvHndq
         H+hg==
X-Forwarded-Encrypted: i=1; AJvYcCUMN3/pTOqn1NmxrAfybn+jW6JNSpaM+3KBf9zTWdpO6ff2hgDJr0ul/EbXGbOb65FIgWCveabaQIih+s23bhPR8bkr
X-Gm-Message-State: AOJu0YypnSLNmjk8lyUpzgBqQ7/kRf80VdkRgcGKKMxMkceJ1ABeimex
	Q4eoTYda9ZpfaoAdhZhp3R/eLxmIRHUYVQNcvn4gsEJhUf/Z5/7x2rrpNG820+nM1VgM4N7Fg9x
	YIQ==
X-Google-Smtp-Source: AGHT+IGUwmJBAaiA58+gxzBbHGRKuvTNTMhF9ZigJKYpehWOoTrUnbjqb53H/C0+WfiTZaiYFralNhVs+S0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3507:b0:608:e67f:4387 with SMTP id
 fq7-20020a05690c350700b00608e67f4387mr278ywb.7.1709148557586; Wed, 28 Feb
 2024 11:29:17 -0800 (PST)
Date: Wed, 28 Feb 2024 11:29:16 -0800
In-Reply-To: <501ac94d-11ab-4765-a25d-75013c021be6@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240208204844.119326-1-thuth@redhat.com> <20240208204844.119326-4-thuth@redhat.com>
 <501ac94d-11ab-4765-a25d-75013c021be6@sirena.org.uk>
Message-ID: <Zd-JjBNCpFG5iDul@google.com>
Subject: Re: [PATCH v3 3/8] KVM: selftests: Move setting a vCPU's entry point
 to a dedicated API
From: Sean Christopherson <seanjc@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Aishwarya TCV <aishwarya.tcv@arm.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 28, 2024, Mark Brown wrote:
> On Thu, Feb 08, 2024 at 09:48:39PM +0100, Thomas Huth wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Extract the code to set a vCPU's entry point out of vm_arch_vcpu_add() and
> > into a new API, vcpu_arch_set_entry_point().  Providing a separate API
> > will allow creating a KVM selftests hardness that can handle tests that
> > use different entry points for sub-tests, whereas *requiring* the entry
> > point to be specified at vCPU creation makes it difficult to create a
> > generic harness, e.g. the boilerplate setup/teardown can't easily create
> > and destroy the VM and vCPUs.
> 
> With today's -next I'm seeing most of the KVM selftests failing on an
> arm64 defconfig with:
> 
> # ==== Test Assertion Failure ====
> #   include/kvm_util_base.h:677: !ret
> #   pid=735 tid=735 errno=9 - Bad file descriptor
> #      1	0x0000000000410937: vcpu_set_reg at kvm_util_base.h:677 (discriminator 4)
> #      2	 (inlined by) vcpu_arch_set_entry_point at processor.c:370 (discriminator 4)
> #      3	0x0000000000407bab: vm_vcpu_add at kvm_util_base.h:981
> #      4	 (inlined by) __vm_create_with_vcpus at kvm_util.c:419
> #      5	 (inlined by) __vm_create_shape_with_one_vcpu at kvm_util.c:432
> #      6	0x000000000040187b: __vm_create_with_one_vcpu at kvm_util_base.h:892
> #      7	 (inlined by) vm_create_with_one_vcpu at kvm_util_base.h:899
> #      8	 (inlined by) main at aarch32_id_regs.c:158
> #      9	0x0000007fbcbe6dc3: ?? ??:0
> #     10	0x0000007fbcbe6e97: ?? ??:0
> #     11	0x0000000000401f2f: _start at ??:?
> #   KVM_SET_ONE_REG failed, rc: -1 errno: 9 (Bad file descriptor)
> 
> and a bisect pointed to this commit which does look plausibly relevant.
> 
> Note that while this was bisected with plain arm64 defconfig and the KVM
> selftests fragment was not enabled, but enabling the KVM fragment gave
> the same result as would be expected based on the options enabled by the
> fragment.  We're also seeing an alternative failure pattern where the
> tests segfault when run in a different environment, I'm also tracking
> that down but I suspect these are the same issue.

Gah, my bad, I should have at least tested on ARM since I have easy access to
such hardware.  If I can't figure out what's going wrong in the next few hours,
I'll drop this series and we can try again for 6.10.

Sorry :-/

> A full log from a sample failing run can be seen here.
> 
>    https://lava.sirena.org.uk/scheduler/job/645026#L1581
> 
> Bisect log:
> 
> git bisect start
> # good: [75d8cf735082728a5dfb7e46926ee184851cc519] Merge branch 'for-linux-next-fixes' of git://anongit.freedesktop.org/drm/drm-misc
> git bisect good 75d8cf735082728a5dfb7e46926ee184851cc519
> # bad: [20af1ca418d2c0b11bc2a1fe8c0c88f67bcc2a7e] Add linux-next specific files for 20240228
> git bisect bad 20af1ca418d2c0b11bc2a1fe8c0c88f67bcc2a7e
> # good: [1322f1801e59dddce10591d602d246c1bf49990c] Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> git bisect good 1322f1801e59dddce10591d602d246c1bf49990c
> # good: [f996a1cab1c3547a0bd2edf0daa7a71eddec9b58] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git
> git bisect good f996a1cab1c3547a0bd2edf0daa7a71eddec9b58
> # bad: [22e19d7b30a88dc9e7b315935f44fb2a6c6bf7bf] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt.git
> git bisect bad 22e19d7b30a88dc9e7b315935f44fb2a6c6bf7bf
> # good: [f9ad77051d5d45000848e87650a382995adf7e50] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> git bisect good f9ad77051d5d45000848e87650a382995adf7e50
> # bad: [6e9a1d8a249374b0c8ff9472f30f160c98881519] Merge branch 'next' of https://github.com/kvm-x86/linux.git
> git bisect bad 6e9a1d8a249374b0c8ff9472f30f160c98881519
> # bad: [f3ac6b5aec49c3f8ced623802ee9efa6484263eb] Merge branch 'xen'
> git bisect bad f3ac6b5aec49c3f8ced623802ee9efa6484263eb
> # good: [938ccbf4327f38cec365986136e349486ddbb005] Merge branch 'pmu'
> git bisect good 938ccbf4327f38cec365986136e349486ddbb005
> # bad: [f3750b0c7f6e48b0adfb9bd2419de4a3c604ca68] KVM: selftests: Add a basic SEV-ES smoke test
> git bisect bad f3750b0c7f6e48b0adfb9bd2419de4a3c604ca68
> # bad: [992178c7219caa0bcdaa5c0ce59615b12da21662] KVM: selftests: Add a macro to define a test with one vcpu
> git bisect bad 992178c7219caa0bcdaa5c0ce59615b12da21662
> # good: [71cd774ad2f98d4c78bc868e7e55397810be3540] KVM: s390: move s390-specific structs to uapi/asm/kvm.h
> git bisect good 71cd774ad2f98d4c78bc868e7e55397810be3540
> # good: [db7d6fbc10447090bab8691a907a7c383ec66f58] KVM: remove unnecessary #ifdef
> git bisect good db7d6fbc10447090bab8691a907a7c383ec66f58
> # good: [221d65449453846bbf6801d0ecf7dfdf4f413ad9] KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
> git bisect good 221d65449453846bbf6801d0ecf7dfdf4f413ad9
> # bad: [8ef192609f14272b7bd6fc3a553ebe02d1133cd0] KVM: selftests: Move setting a vCPU's entry point to a dedicated API
> git bisect bad 8ef192609f14272b7bd6fc3a553ebe02d1133cd0
> # first bad commit: [8ef192609f14272b7bd6fc3a553ebe02d1133cd0] KVM: selftests: Move setting a vCPU's entry point to a dedicated API



