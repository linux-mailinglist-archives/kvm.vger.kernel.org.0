Return-Path: <kvm+bounces-25610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A825D966D73
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6EF1C22309
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7F6208AD;
	Sat, 31 Aug 2024 00:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wwl3OF8T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C85C1F959
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063697; cv=none; b=Q3I10ynx6f8e1qaHUuKtKYi/YgKfbIlXmrruqLWkGtj+MbBa1qbDj2oGqWuryl0eeDU1JX4C40xhRtEHvC204XZkq7YAKeqRoZJ613Y6MIZKlKoKfIlEnZHnJytPagHeZ2M1gui0TkbyR4n5gJHmXQi8ANO4+4yjwilcIefgjvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063697; c=relaxed/simple;
	bh=3vXhrmDJEnvXRrG5wN4+Rj0ALvXRVC7+qovanTKX3Hk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FAW4nT6u5ZnBSHN/j83tOvncnRK4GYzZDSS4gVkHwOqdWbdh9GWSNj6ISeS6XEkrjEmVR6r2jHJsER+n/LiGdQ6lX96Yyh+orqTQNUZuQUf3XpmVboDpxpPWScQL52UN7+RyxPXnSCSdfAOLh1nimT5kxq3b8ZqOPDWPnVMFN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wwl3OF8T; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso1454938a12.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063695; x=1725668495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wfZaQrJ9bQCLmLdc965VyJLEqRz0VYMmjQCDb7HMOwo=;
        b=Wwl3OF8TMmsyfLkWrcASPrq5IFPxY18WeHNx/s0dwrTJ+uTguVRz80mArwga4QWYIr
         lPBRhPldSznRXlwVHuKsTPO8MdoD19IK5pXGnZtBe4WYglfpwRv24EC/pyQ791SWdw5j
         V9cG1N+9e4QgVXS4TrTRUKj25xIYL3bL96J/c3ztpg3vLL73ObP/7OJqJ/xEaJzrOOgP
         RvbT68nAbGpBCvGN7k16eRJsF9oTlkQuGqn9RsmSyBXvY3wHkmnMyQFZL+ga/4YapVii
         TQA9XacaAIzi6XR++M0RRl9ut6oZNwPXSbc17ZXONYoIVQ4W/JgxADk1Olhflu2I6h7R
         /u9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063695; x=1725668495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wfZaQrJ9bQCLmLdc965VyJLEqRz0VYMmjQCDb7HMOwo=;
        b=R1OWLH+5r6EJTyET2MW9Z4y7hggeiKGH/n9MqbgVf1uah7pUOPPP4jxKzL3x1wpks3
         wRjz1RQ7Tut4+HhS9m9LBGPrAkfKlsnLO/s1CjZsJ3py9rzqxRjtc4UMWZWuyhYSHHFu
         /2/Rr10LwwAA/iBTExT4HOjbDkYzM2lhE5dxmBcdV04BWZVeMxWqgy71wQsiRy+ANv2S
         m5In20252vIjloqORNJfrFvhQP0x3xwDuZaX3iEvn8llhuSg5HwFKXhGKWMMpkkj6jNz
         eWpRDDRF5qFGdBc0XWMxb4uN7Qe+DdLUWhN13TZB4awoVIOEV7Mancd7+eRDoYGtcNEH
         EIug==
X-Gm-Message-State: AOJu0YxSv7uMYHecuKotgEBSuN5iXNzubl+SoFR9np6OTxc2Ma82jnpr
	gCszkoYFDDGt5fmW+cxPQb5JQnE4rt0qilsbSu7NvwvPCu11uBdxe0dpNKJu/t3891UWq2pW7QB
	MhA==
X-Google-Smtp-Source: AGHT+IFVTgxvGwsaOwi8zxa84wVlO1vh0D+mqC1XhwaihWWv9cS0aYXp3pWEr2ireJ8z8L6H4kC8QjyohJM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6904:0:b0:702:4fb6:8724 with SMTP id
 41be03b00d2f7-7d447110166mr17149a12.1.1725063693090; Fri, 30 Aug 2024
 17:21:33 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:55 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506346660.337709.9371266874053711771.b4-ty@google.com>
Subject: Re: [PATCH v2 00/10] KVM: x86: Fix ICR handling when x2AVIC is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Jul 2024 16:50:57 -0700, Sean Christopherson wrote:
> I made the mistake of expanding my testing to run with and without AVIC
> enabled, and to my surprise (wow, sarcasm), x2AVIC failed hard on the
> xapic_state_test due to ICR issues.
> 
> AFAICT, the issue is that AMD splits the 64-bit ICR into the legacy ICR
> and ICR2 fields when storing the ICR in the vAPIC (apparently "it's a
> single 64-bit register" is open to intepretation).  Aside from causing
> the selftest failure and potential live migration issues, botching the
> format is quite bad, as KVM will mishandle incomplete virtualized IPIs,
> e.g. generate IRQs to the wrong vCPU, drop IRQs, etc.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/10] KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
        https://github.com/kvm-x86/linux/commit/71bf395a276f
[02/10] KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
        https://github.com/kvm-x86/linux/commit/d33234342f8b
[03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
        https://github.com/kvm-x86/linux/commit/73b42dc69be8
[04/10] KVM: selftests: Open code vcpu_run() equivalent in guest_printf test
        https://github.com/kvm-x86/linux/commit/d1c2cdca5a08
[05/10] KVM: selftests: Report unhandled exceptions on x86 as regular guest asserts
        https://github.com/kvm-x86/linux/commit/ed24ba6c2c34
[06/10] KVM: selftests: Add x86 helpers to play nice with x2APIC MSR #GPs
        https://github.com/kvm-x86/linux/commit/f2e91e874179
[07/10] KVM: selftests: Skip ICR.BUSY test in xapic_state_test if x2APIC is enabled
        https://github.com/kvm-x86/linux/commit/faf06a238254
[08/10] KVM: selftests: Test x2APIC ICR reserved bits
        https://github.com/kvm-x86/linux/commit/3426cb48adb4
[09/10] KVM: selftests: Verify the guest can read back the x2APIC ICR it wrote
        https://github.com/kvm-x86/linux/commit/0cb26ec32085
[10/10] KVM: selftests: Play nice with AMD's AVIC errata
        https://github.com/kvm-x86/linux/commit/5a7c7d148e48

--
https://github.com/kvm-x86/linux/tree/next

