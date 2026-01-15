Return-Path: <kvm+bounces-68227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFDAD276A6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B11F303DAB9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3823D6032;
	Thu, 15 Jan 2026 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXpZe6hP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1A3D5D9E
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500418; cv=none; b=i8KWAWRzFtgSMvOEp9hdRoXQPC7/EMZWM5fGIvIZdTUVwtBtHSkC/BxyAhee5H/kyv1pU7NFt7L+3P2T39ZhZNB02rMUsI5zZGtcd6UWRiQKDsHnou6bdstN/Iqwyo6Ca4jM5w4uJiIBBiuv9JdGDOVtHE47MQTFLciCL2xHVZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500418; c=relaxed/simple;
	bh=RhHr0pJFJ26CbuLBfKjiOOVCWk5pWWlWGWHHOUt+22k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I60OQSFEIw4PRe2veJNlznQzDZV5x82cIa3MfX7bN3m63f8tsQdYhsUHTQSCVeprZBYjHCnhh5sRt+ye1LUkb54kMZ89DzaKTyYQnYINCeyBYTc8ZH1fn8VtXc9p52JHeVrdS5gfXcbfLT5n4mMxiCRlQJhrx9Oc48Ie775A6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXpZe6hP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34abec8855aso972011a91.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500416; x=1769105216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+pM2AdAUHzZiIsyDHjpvI0YAYlBBlp6EV0LHIGDuJM=;
        b=oXpZe6hPcYiywf61VKhttw12/x7m2prt5E8cIcGe7B2QtuQR47kmc5O8bQwBwmMUBD
         ysiki0dWBNnoWXuGdEcWBF4T7ytwuqI76Wff6yA1AdbvHiaGCGbDVuUnzs+WA+BnnDCt
         +8xTEFuaPOybckUH2ZQHAMpxrZhNDYxy7bHpE2DrU7uTBt/kLDgBT9UCHGvHSg0HL/Wt
         YkvQ+vWlpNMFvZXHeDlNY0aJW48/GEU79bLP2noizTactC9u9Dcb3O7Y4nzuc9cpMgwH
         e7DYZhdywjTBCVZjzVHuSi2mk6H0ezCBkczfaGoeLQXu5PTPhjH8ym1S58xrUEtEHJSU
         etfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500416; x=1769105216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+pM2AdAUHzZiIsyDHjpvI0YAYlBBlp6EV0LHIGDuJM=;
        b=MBqLXjjiZL0EBe83XjuQI+8NpW2wsKhNCvdj81gx5DO6u/DaRyIcRKo1Z3RWsCNjjj
         uhnCA4tPu4IgbXinQhtzYc2zG8Bi7+Ktsyti2sWALcwYcWEhxEpk3WsCRHLsJ77N6Nbs
         aB7snt9kiYYdDOYe8rnrre4dL0MyBaKNedgleIXdLNA+uARNG3uYrghb6nsGH5q5ivLY
         Zh7rMOmvDMKJ5gP8uQMiBHmNI3yeAevGZG1fMghgfPL0QROF1Hw5zsbq1PtcXEbEwrgr
         GI2gGPZYeo84BG1wYJjariAAMDU5YFeBZF7L3eq2Q7JsjYHKsz2c2CNm792/9r7949Tw
         OPcA==
X-Gm-Message-State: AOJu0YzzVzVQKOlzFUhaquJaGLcN4SqGFc/lNxt2u+Mor5S5lEDa9OY+
	dfJ4Hz/ylSn3YgkSG4SO4U45qtk69wgLnxg+/DtzvMDtqDFf0bqRDEkK8hB4OViLqzt9+eZc0A/
	zomdD/Q==
X-Received: from pjbcl2.prod.google.com ([2002:a17:90a:f682:b0:34c:88ca:9ef8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ece:b0:340:2a3a:71b7
 with SMTP id 98e67ed59e1d1-35273166040mr173393a91.12.1768500416337; Thu, 15
 Jan 2026 10:06:56 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:34 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849898589.719783.8437609817202022715.b4-ty@google.com>
Subject: Re: [PATCH v2 0/8] KVM: SVM: Fix exit_code bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Dec 2025 13:13:39 -0800, Sean Christopherson wrote:
> Fix (mostly benign) bugs in SVM where KVM treats exit codes as 32-bit values
> instead of 64-bit values.
> 
> The most dangerous aspect of the mess is that simply fixing KVM would likely
> break KVM-on-KVM setups if only L1 is patched.  To try and avoid such
> breakage while also fixing KVM, I opted to have KVM retain its checks on
> only bits 31:0 if KVM is running as a VM (as detected by
> X86_FEATURE_HYPERVISOR).
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/8] KVM: SVM: Add a helper to detect VMRUN failures
      https://github.com/kvm-x86/linux/commit/217463aa329e
[2/8] KVM: SVM: Open code handling of unexpected exits in svm_invoke_exit_handler()
      https://github.com/kvm-x86/linux/commit/2450c9774510
[3/8] KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE "fast" handling
      https://github.com/kvm-x86/linux/commit/194c17bf5eba
[4/8] KVM: SVM: Filter out 64-bit exit codes when invoking exit handlers on bare metal
      https://github.com/kvm-x86/linux/commit/405fce694bd1
[5/8] KVM: SVM: Treat exit_code as an unsigned 64-bit value through all of KVM
      https://github.com/kvm-x86/linux/commit/d7507a94a072
[6/8] KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running as a VM
      https://github.com/kvm-x86/linux/commit/a08ca6691fd3
[7/8] KVM: SVM: Harden exit_code against being used in Spectre-like attacks
      https://github.com/kvm-x86/linux/commit/1e3dddafecee
[8/8] KVM: SVM: Assert that Hyper-V's HV_SVM_EXITCODE_ENL == SVM_EXIT_SW
      https://github.com/kvm-x86/linux/commit/d6c20d19f7d3

--
https://github.com/kvm-x86/linux/tree/next

