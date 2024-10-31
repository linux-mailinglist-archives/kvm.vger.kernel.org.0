Return-Path: <kvm+bounces-30231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB299B83C5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05754B21686
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4931CB53C;
	Thu, 31 Oct 2024 19:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rTD1TBDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FC1CC153
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404491; cv=none; b=FSeSXy06dZ80F66feLxa8SqTA65rB7f0R5ilNZ5F44vQG4Pm62wev4I5DOp8F/L+ScSjQyLQtflc3LiA9VarSieQKw2rDgy71U9Jwsd6T+2ja3JuNgdwp2ftpXSCmTtELuDENI30HEtpJ8zwQF2qPmh2qmB2bnwoK+FSHZjd/K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404491; c=relaxed/simple;
	bh=ji1ZGggslDNLPdyPAEHksUOY3esBFrCQXJ+WzXWowTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GNZcASawPNgTTGqSyXW9758bmXZjyEzzkzr4+/NPO+lMnQKl3WhSSrlLQLWgZs4slmjRDgYotom2Dr8hib0su0any6gPxg80Kya5b6mGwm4vAMdemtxhA2H6q5bTMWwAvXCXHKU1MtV8HNw/zH6FxbJXLzEnygIThH4ZC1FrCQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rTD1TBDg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29142c79d6so2196507276.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404489; x=1731009289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hoGCK8+4LjEMDCBa93UaXD3fiD3DB3Wb4hPONNe9Rc=;
        b=rTD1TBDgYaGoB+PSOHZXxODSYrERhTN3pWkTQQS2D10wHKdrtmqda0ST6JLMqno4w8
         haCJ2CXp5Nvjzmdgd6CjQjE64MOsgGZIm5jtzaWViFueBCgzSF1pm2yXqfZv7PjRybL/
         85mGthLcZgAb3vopyCV+9xf3hxMc1oNluclebwRISTJwzn9OmC2+vmNWHFI9cRxaHENE
         ONB6jLg3j/YJMZf34S0atf9+x7peL2Q7HvlaczthL+kMsYIOrdNyyS69DkLnoRUMg0f0
         jfdQqXnu4VJgIM165l9enK4ilQ7sor17vAksD4Gti/niHauXHqBMFNbopaYHmZ42fc4P
         8Kpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404489; x=1731009289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hoGCK8+4LjEMDCBa93UaXD3fiD3DB3Wb4hPONNe9Rc=;
        b=tnn6+Q5DN1U1gUhsGW4kyjWWv13YfPWkAlvFnVYET4Qjf56IxPzvmMKapgimBj4Z+s
         GhZVxDmbgY3dIB1PTTnT7u2D4cDFHMWlo1WcvKU9UhIntcNu3F5u7mwutgDN5q6Ct4vD
         gpkTFIOTQzaApkPGqvhk6I2oyRBFKCDLIWShlai/5eJAdWSLlNRB54LtYFxByW79P7jJ
         0IY0pqEyQ63c1hf6/jQb8+uM/aTcj+hGsmQkIAwgaNE820AG5ns4lOC/uTwhFFeDb/G+
         ILzpZtK26Tti/cQhBwR1SbglUw0D0FGCyojTpjp2q0mMTqUVPYTgoI1ENaTqCcdQziNZ
         nIWg==
X-Gm-Message-State: AOJu0Yy2U2HAojk5iddKS9zxdTFU4qu9TNdV5hSb88PpEAGZRfcLX6W0
	1lNxK2rJhgQgGKVvfh84xanrEW0n/ZGzB+1chfpW9EemKXEL0HfQLRCxLJZPQFSMWnTa+DQU+2M
	nPw==
X-Google-Smtp-Source: AGHT+IGx+dhXZZpZ1cMRDtZ0KNVGD2joed8AnfGFL98nEBItFp6t4i1krvCt4NoKfJwx2ah7sw+/LPgM/gY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:3054:0:b0:e30:d445:a7c with SMTP id
 3f1490d57ef6-e30e5a03f4bmr2444276.1.1730404488923; Thu, 31 Oct 2024 12:54:48
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:39 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039507944.1509256.3272782345564937862.b4-ty@google.com>
Subject: Re: [PATCH 0/9] KVM: x86: Add a quirk for feature MSR initialization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 11:55:02 -0700, Sean Christopherson wrote:
> The primary goal of this series to fix an issue where KVM's initialization
> of feature MSRs during vCPU creation results in a failed save/restore of
> PERF_CAPABILITIES.  If userspace configures the VM to _not_ have a PMU,
> because KVM initializes the vCPU's PERF_CAPABILTIIES, trying to save/restore
> the non-zero value will be rejected by the destination.
> 
> The secondary goal is to try and avoid such goofs in the future, by making
> it explicitly clear that userspace owns the vCPU model.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/9] KVM: x86: Co-locate initialization of feature MSRs in kvm_arch_vcpu_create()
      https://github.com/kvm-x86/linux/commit/383383cfd202
[2/9] KVM: x86: Disallow changing MSR_PLATFORM_INFO after vCPU has run
      https://github.com/kvm-x86/linux/commit/d76a5e78f16d
[3/9] KVM: x86: Quirk initialization of feature MSRs to KVM's max configuration
      https://github.com/kvm-x86/linux/commit/088b8eeb25ec
[4/9] KVM: x86: Reject userspace attempts to access PERF_CAPABILITIES w/o PDCM
      https://github.com/kvm-x86/linux/commit/c2eb2d0318c0
[5/9] KVM: VMX: Remove restriction that PMU version > 0 for PERF_CAPABILITIES
      https://github.com/kvm-x86/linux/commit/bae593b20e92
[6/9] KVM: x86: Reject userspace attempts to access ARCH_CAPABILITIES w/o support
      https://github.com/kvm-x86/linux/commit/83a5fe6cf1eb
[7/9] KVM: x86: Remove ordering check b/w MSR_PLATFORM_INFO and MISC_FEATURES_ENABLES
      https://github.com/kvm-x86/linux/commit/9d2dcfb82db1
[8/9] KVM: selftests: Verify get/set PERF_CAPABILITIES w/o guest PDMC behavior
      https://github.com/kvm-x86/linux/commit/6a4511f8602f
[9/9] KVM: selftests: Add a testcase for disabling feature MSRs init quirk
      https://github.com/kvm-x86/linux/commit/58a7368f104d

--
https://github.com/kvm-x86/linux/tree/next

