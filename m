Return-Path: <kvm+bounces-41423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2AEA67B8A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D189C19C4DEC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918C1213254;
	Tue, 18 Mar 2025 18:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rAxQrmx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5AD211A33
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320989; cv=none; b=SVRE3ih9tntsKXMIjBRkdGY7zbQ8aoFdC3CFdCdRoWMir4KunmzgNNKW3P13R9Gp077weKbfFK21Az/Mhs+yAo8AEA8iX/vWWC0rMiVXV71lDRQGUobOPrJ3Sy25KP3/A4Lq6Tg89QkXKqvIo7Mo8LfwfXxYjUphCmSfIj5jinE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320989; c=relaxed/simple;
	bh=KENC4RjlZ0X4TyudrMDbrXvOzjDL0WiMjcmJsQFWibc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=C6EYencNyrF+pOMw26jEBR9rxI1KratMHnmOoCijYkfqOQVA7QT0EueAOFEebowNU1ihFBOFi9h5N2zlscyGwoUR9dxv0h5A0QV2hffbQR1b2Ew5sQsMLYhXcl/5qevyYN6HgwXgaPQidFB1HbexqAijawF+m7tTogSe4Y/WGus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rAxQrmx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-223477ba158so171429775ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320987; x=1742925787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzJAfV/bUsOvTBEHqlYxu62ZiO+HkVeOaadUps7WQgc=;
        b=4rAxQrmxFB39h3vA6iwtV/btrQzn46web3yVTDBXHaZeSQBRWmZybqeDBdZNQC1wJp
         mhSjnRkfFakw8NcMh/6bsobwBK6IXsHRrjh7dLux0P3O9xrOk7IvNSNEZv7JxUXp6pml
         sryOhf4pMVhiH4dBjFH9KqAlxGXf6AufnlAzpnk5rrt+/vk4JoiPVHDaydeGbZCSggCf
         1s0AhRgcJHEV8Jciv1Z57GIhuP2XDplTEywNc7F6J8gW4rkUyV834gndByOctX0V9Jh3
         mzpoqYV0jQPsiY9pYc0kf0YkCUY/6F0T84pBFUKCvT/h3nuX0dEjAkNQBeUmQOffRiOE
         A9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320987; x=1742925787;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DzJAfV/bUsOvTBEHqlYxu62ZiO+HkVeOaadUps7WQgc=;
        b=mJdXzQMqWfJkVIRMpSJTDZISNRoo2sRPQ0T4wijHevyIu1SmsvbnQEGnXjocKelPhl
         L9tcxx4potFMXCLnRIKrs1McWxGNXcFycW2yPZDfrKqbqPPAFUt/sdfRZ6lMvI4O2jjY
         mDBg4b+CppE9Koeb5vbHqEuaf8evmZIVeb+EGFL+N8uf+mqBSdWgG/i3VNwny9eMr3vl
         IQ2cU9OLxrVSg+Ph0EEkxT7G8gecIfohyTtDtN5tmuPn81lIb0QLAqwpF0d+YxuLhGyH
         JZxUAkbjUZVxmGjSccxH4hfH7/xMODQn0EVXXAIR3eTC1rRpv3ZaBFWZ7YtNOyVbQ8JR
         lw9Q==
X-Gm-Message-State: AOJu0YzV8U2LAtqx8JSB5qxhs30XPW0ER89MCRPvvt4XLlxZh8yN2YzB
	SVcL272R5xcvo7gmyeKAvej2BNwNs0ST6jlotAE0g9ieeFwi8slgU/OrO9zFHCY49BVQLduJ3Fc
	9ag==
X-Google-Smtp-Source: AGHT+IEQhlpm2/LL+7EBkmZARZuu5EZhZyR1zpmdmd4aRSN4LdpUvkThdLTY/U47aPkpqbQsnhWd5hPZ1GE=
X-Received: from pfbcq25.prod.google.com ([2002:a05:6a00:3319:b0:732:51fc:618f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a83:b0:1f5:837b:186a
 with SMTP id adf61e73a8af0-1f5c10f6505mr27660358637.6.1742320987462; Tue, 18
 Mar 2025 11:03:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:02:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

There are two conflicts between the PV clock pull request and the Xen
pull request.

1. The Xen branch moves Xen TSC leaf updates to CPUID emulation, and the PV
   clock branch renames the fields in kvm_vcpu_arch that are used to update
   the Xen leafs.  After the dust settles, kvm_cpuid() should look like:

   		} else if (IS_ENABLED(CONFIG_KVM_XEN) &&
			   kvm_xen_is_tsc_leaf(vcpu, function)) {
			/*
			 * Update guest TSC frequency information if necessary.
			 * Ignore failures, there is no sane value that can be
			 * provided if KVM can't get the TSC frequency.
			 */
			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu))
				kvm_guest_time_update(vcpu);

			if (index == 1) {
				*ecx = vcpu->arch.pvclock_tsc_mul;
				*edx = vcpu->arch.pvclock_tsc_shift;
			} else if (index == 2) {
				*eax = vcpu->arch.hw_tsc_khz;
			}
		}

2. The Xen branch moves and renames xen_hvm_config so that its xen.hvm_config,
   while PV clock branch shuffles use of xen_hvm_config/xen.hvm_config flags.
   The resulting code in kvm_guest_time_update() should look like:

#ifdef CONFIG_KVM_XEN
	/*
	 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
	 * explicitly told to use TSC as its clocksource Xen will not set this bit.
	 * This default behaviour led to bugs in some guest kernels which cause
	 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
	 *
	 * Note!  Clear TSC_STABLE only for Xen clocks, i.e. the order matters!
	 */
	if (ka->xen.hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE)
		hv_clock.flags &= ~PVCLOCK_TSC_STABLE_BIT;

	if (vcpu->xen.vcpu_info_cache.active)
		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
					offsetof(struct compat_vcpu_info, time));
	if (vcpu->xen.vcpu_time_info_cache.active)
		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0);
#endif

