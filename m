Return-Path: <kvm+bounces-40204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9D5A53F6C
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF49118934C6
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F05933981;
	Thu,  6 Mar 2025 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YILbfmTZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575BEB661
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 00:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741222665; cv=none; b=PYHpEIOZqvTGSNA9mK79W6xCb7P90xN6JIimT3Q72a2XzukZZwGBOdltBs4l+kJdVzzKh4UBz6J+cGaDPSbRp+f/nx+wjBbXW7Iy9Emxu247b43pJj5mQo/2MruAhv5iassirGf4J7gRlMn0V18n9hF5DEzjEcIvdKEmVKe4Szs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741222665; c=relaxed/simple;
	bh=BRzTPsuUtFVxjdzRFQihcgGwgS/fBY4FoJRdAjKtQrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eMJbPHzCRMsmeBicNuN4u+4Vpb/PMI1jj6dENpKVD4qBhBe//zaFtQivAGWcuiYElBIwwB6Ks6f95gvFKDtceaKpWfj5gSCmffX9P5nMLPdoov7AixqNocwH6i3j68fOK9qpaj6CbFT2a0L12AQ0ZNYf4FdU9+e6LPhIDFpz+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YILbfmTZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f81a0d0a18so279426a91.3
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 16:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741222662; x=1741827462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFMXLR5DEt2+VAGefXNYR8zqNGy8KsIqW8Sdzn2Q4Jw=;
        b=YILbfmTZenpCLg1rIf63ngx80kqrHYjgHEbBh2o6hP9avOx56YcpQv2ExyLU5Jv2Gl
         4ffEVnXU3iYGAdOxcMCsBNTtey808q4HZ63MjGLQsqpMQV4SGzkG8y7jGlNeXgGc2NEj
         Oiti58ha2MOIGbhUAM9XuxlIEzR+6GPuqwVcu8OimJIbdJ5DUBrcUjWbDVP/QgNQrvGp
         8lFuRhtzdeJ0vwLRq9ndZ5cKLLege10dNS8SXx6TfQ4HmDx18pxwNb6GkEClf6z8uwqo
         Xo11qDxHqWqN03jgXbrjTKorqeUylfvsmYizgDMR6kV2Qjx9/Awn9BzRh5/1ZWdtFQZR
         zWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741222662; x=1741827462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFMXLR5DEt2+VAGefXNYR8zqNGy8KsIqW8Sdzn2Q4Jw=;
        b=wKEsI2AHoHEWZ6A8t3ADF66w186zl20b94P3/bJgvpTHaNgyKYqqT+xUFAo1xan98x
         bosO/SU9Ka+JkYoLNv4wo3gClEVwvxmKIjLAXcjPcBQB2+4AOAs+7C0GAOwHFBY4upuN
         IRqSeQg+u49TxQ5oDzGQ0YIf889DGuR+GZuUuJxc5Pv8xAk9trjyBp1+7o735rUqsD7k
         9kZewDD3kO+3PdS51/mZF5CRCt0u+RMggDu2Uqw4soZRRrQyadt1k6MH6DmqlRSQ6Y+E
         UfwQmqJBbU0akdHtZhNp2PJCST3VwoczPSPyfPzEyv9/q7tDG1t+Od3iuSX5GyFXPQTn
         9aJw==
X-Gm-Message-State: AOJu0Yzald3cs75ZSfg/0Z2VnftsmtqKlpIluTHqM+pqUbYhQ10baAb+
	mUoh1QQlutqOXQb/uUB6e0QKtDfy+CCymnZfe24fb148YY8klYv9t395SSNQ3DpANxUtghzDzXc
	yLQ==
X-Google-Smtp-Source: AGHT+IFPT939blb6w0S+5BBekpr9w9VO3AEymWncjXsP3CZkDiyR2r8ZM6izTc/wi53NLuX33sPmez2yPdo=
X-Received: from pjbok16.prod.google.com ([2002:a17:90b:1d50:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4e:b0:2ee:ab29:1a57
 with SMTP id 98e67ed59e1d1-2ff49790511mr8702853a91.2.1741222662573; Wed, 05
 Mar 2025 16:57:42 -0800 (PST)
Date: Wed,  5 Mar 2025 16:57:28 -0800
In-Reply-To: <20250304082314.472202-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304082314.472202-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174110882170.40250.8746962643426198696.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Cleanup and fix for reporting CPUID leaf 0x80000022
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 04 Mar 2025 03:23:12 -0500, Xiaoyao Li wrote:
> Patch 1 is a cleanup and Patch 2 is a fix. Please see the individual
> patch for detail.
> 
> Xiaoyao Li (2):
>   KVM: x86: Remove the unreachable case for 0x80000022 leaf in
>     __do_cpuid_func()
>   KVM: x86: Explicitly set eax and ebx to 0 when X86_FEATURE_PERFMON_V2
>     cannot be exposed to guest
> 
> [...]

Applied patch 2 to kvm-x86 fixes and tagged it for stable, and applied patch 1
to misc.  Not zeroing eax/ebx is relatively benign, as it only affects the
!enable_pmu case, but it's most definitely a bug and the fix is about as safe
as a fix can be.

I also added quite a bit of extra information to both changelogs.

Thanks!

[1/2] KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func()
      https://github.com/kvm-x86/linux/commit/e6c8728a8e2d
[2/2] KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM
      https://github.com/kvm-x86/linux/commit/f9dc8fb3afc9

--
https://github.com/kvm-x86/linux/tree/next

