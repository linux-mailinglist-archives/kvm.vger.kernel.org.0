Return-Path: <kvm+bounces-44365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A953A9D52E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5494C1C01714
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0E52343BE;
	Fri, 25 Apr 2025 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L+LlPTpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585D22327A7
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745619012; cv=none; b=b6NfjN7PvSnRiIdGNNOjA4lj1wO9Xdot7JuIMziBwmrr36z1k+bbSFgyfouqcBNqw24C3S3zEIml8cUBmQhkif+Hgd8p80UvmEYj0zT8iezcyrT/eOiXhKQZph4PltEaWm4EFNvJuUcM2B3pUp62aVhHPSSKGWQPpE5V0Tccrq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745619012; c=relaxed/simple;
	bh=QDpNpdZSVvNzvd5MLR7pzG4I1iT2a6SWMqrV4UoqPjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lix5etY4MvrrgYjSTNbkLnGCgu0+Efpd1YKk+pY4VcaSvTTz/d3hrs8Ra1VlZNABKZzO2mf5RKJq9agcUjB1ePwkpDVke0oyiKHziiPFuWC6wH2H1dfzh1saAtTctyiwb049RBFqBKiI7OoD550HV66R0MZvfDRhoIGA0GQXW0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L+LlPTpq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73c205898aaso1942032b3a.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745619010; x=1746223810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KP7SMXC0UpOU8ebuPaD2r2QZRSGge8gBq4uVn0V+Tno=;
        b=L+LlPTpqPRnCx7GgCslDOfN2aYRsMKD2Y8PL3Xsi+CNHogAdOyz6RqJsvPKgeD+gV+
         LdkTFNPx+yCSVE+hYA70vT6DZNVzfb4DIJOqdM4odkc57y9WGJuVseU4IVp1ofvUk/T0
         e3HrtzV8QAffZmawffOBFCSb10QRL3Uyc3Qt4Bp96GX52vFslkxXEs+J6IjyhFP36qYZ
         5Jahtw8NJaI3FNJhSuh1BiutOfzFBJiPzHkqWhG+LYNNpVYifyMV5sFFETN9tX0IiSjm
         VcyQy5Ry91KjrENITxQRVx+UWwI0BlXjP4EFlBDo3POxxXODd3Ees+zPt053JUUSEhqM
         mQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745619010; x=1746223810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KP7SMXC0UpOU8ebuPaD2r2QZRSGge8gBq4uVn0V+Tno=;
        b=NwY7KsKfO0GlTHaxLJdi2JpMCPhhs9Ry8pHYTLWLcoeKKsLF77D0z9dByZxmNsHr9R
         QiVrTfj8YRO38slnkPRsONfXhRHyeeZ2j78EpZ6r/CTXqZi4sQE2Y9pYc09rZ6m0xelx
         Wbsc05ua9ESmFT3ZUb8yCPD7tb6xUSC2xahd5gmvZMTPc/d3u91lDgcTQ48oQhX7zVnA
         15XsBt7NjHeupybPJ1qzeOxWNFs2bLGFkdLBq2D/7iC90hmtrMo14gCq+Y+w995jxwX0
         hDwYv66E32gdAOZuRaF2J+I2Zdsfvs4LmnAMrBhua2MeQgt9F5NgbQHLugV17NEMp7KB
         QRYA==
X-Forwarded-Encrypted: i=1; AJvYcCUxPFM8zYg5apI2/l0TEVcAW148z5rrUXmZS8KWFQnCoRGZ35g10pUAszJ0dmlcTICq5bg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz76mJ9b7tgg8yDmJIAhBOYwubzC9FgC4qzEeG3NlNFyJVFU4gr
	OnH2ON46Ph2Z6J5kHYtiRTf1y54o5AG8kzsMHt/lWp+fIhX6rCMQhB77umZxbFHRj5ktnT8hp1A
	Zhw==
X-Google-Smtp-Source: AGHT+IHlxsqOZTM+LSrc0NBMmc8B9QyOShS3ixyiaGAbKud07pM591093aslJMz7+/hiacjkdUWS8cPxxuk=
X-Received: from pfbhx20.prod.google.com ([2002:a05:6a00:8994:b0:73b:c271:ad40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:179e:b0:736:476b:fcd3
 with SMTP id d2e1a72fcca58-73fd9145c92mr6310645b3a.24.1745619010562; Fri, 25
 Apr 2025 15:10:10 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:08:58 -0700
In-Reply-To: <20250414171207.155121-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414171207.155121-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559665447.890486.10602051835802598167.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: SVM: forcibly leave SMM mode on vCPU reset
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 14 Apr 2025 20:12:06 +0300, Mikhail Lobanov wrote:
> Previously, commit ed129ec9057f ("KVM: x86: forcibly leave nested mode
> on vCPU reset") addressed an issue where a triple fault occurring in
> nested mode could lead to use-after-free scenarios. However, the commit
> did not handle the analogous situation for System Management Mode (SMM).
> 
> This omission results in triggering a WARN when a vCPU reset occurs
> while still in SMM mode, due to the check in kvm_vcpu_reset(). This
> situation was reprodused using Syzkaller by:
> 1) Creating a KVM VM and vCPU
> 2) Sending a KVM_SMI ioctl to explicitly enter SMM
> 3) Executing invalid instructions causing consecutive exceptions and
> eventually a triple fault
> 
> [...]

Applied to kvm-x86 fixes.  I massaged the shortlog+changelog, as firing INIT
isn't architectural behavior, it's simply the least awful option, and more
importantly, it's KVM's existing behavior.

Thanks!

[1/1] KVM: SVM: forcibly leave SMM mode on vCPU reset
      commit: a2620f8932fa9fdabc3d78ed6efb004ca409019f

--
https://github.com/kvm-x86/linux/tree/next

