Return-Path: <kvm+bounces-68326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B6964D333C5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A62B6312B7CC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662A133A00C;
	Fri, 16 Jan 2026 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QPQlIZlt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DE033A6F4
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577610; cv=none; b=LYHbR5Ow19RAzM0e3Nbm/7jWPSE13KAKtLjMmRQ9daDzBTDWiin4YpMVLsCCTyfPD7HZISgw5TDj/p3tSE7RP+dAf/dloHTbU+L58WZX52/2aYjGMZWDtN/6SS3XphjNCWEy605TpOFpQTFrNqyP+cj9++hRNweEE8Ro6V69+Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577610; c=relaxed/simple;
	bh=oYQJjlZIpsIZF7YLAGKB4ZoezlcIQxYNhsIH/ahTxms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UI7KmRTKpTFeNNLNmpz21oP3LoYkoipLlZRhr4uiBvwIhvbCRgQQi044Av8nQ5LP2s18fx9LdwF/OSe2PUfCRN0584BNWteIIMx+FlHE3uMSb8V+JrSsZVrpb5cAu7LdQvDOf0rubGvGdabDR7ei3pqZGOch22fC/tMWS8OIzko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QPQlIZlt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c213419f5so1416562a91.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 07:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768577606; x=1769182406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFDMwcUB+g0lr3+O0uNE+y+KlNYemC0Uyu3/6hhSiCE=;
        b=QPQlIZltlMacfSq+JUF2zmC7QUxM9RH0MPnqYQEsH6JnLgdE4dagHVjtoL0nLSrw9C
         qPpNKwLAVgccJKks2nHxGq6DwuoLrmOY/wBZuSt8EArFeXZoudwJOCd+kN4zR09bC1hz
         yFuowYhNMHKlMeRtY7bGDLw3wQPcLh1nwd6cYlm0lfEP8mUh3fkcn8AKhl7++ciT6BBw
         Ji8hyaegUHGVzN7QmyQY9a94DrV9kzZbHwnAaImHn5EuGNAZRBMM7pdxcjxiV1cIePn3
         Y/FF1wu8Z6JPiUFxHV/PqxVz6o8ws9KS7+813ZK61GNQ/N0yuicmRCGn4KoDF6TvmGgD
         NAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768577606; x=1769182406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFDMwcUB+g0lr3+O0uNE+y+KlNYemC0Uyu3/6hhSiCE=;
        b=OhaP3T5+emobKIsXTU6FD72K1gKW12pBPP9ExCznVn2sC6RtGsNe6GrB7FzAXG+jM/
         v+SH4o1I5tWVyg9zmO9XLsss1YrOVawiir5DAVeSozfVRrKsL+TcwJFWthMCpJLAQf56
         ZntLNBEa1j63EgdLyp2Iuk7jheEj6sEpzfUMRBpuMDRArVjrzp+j+zR2L+mXe+ylY1hw
         QUfCPwZm0wREL03l8kwZiMR9q1ILaiOh9/ZhL60t6LTpYv9JIJbW14E3oZNjhpPctqOR
         4Lk/wSdnM0h6uSJJQmnuX8tBl1fKqhBDxUvZAWBMghcs6JtvqUYdrdcWjyJepuEuew1k
         33kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtSJg8kuPOIBhf5S52tXWzEv+BxQF5+ygGlvdIAUC944t8U5VwlhQKjTmP0Hckbw5aU60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz29Dy+z01ZraYiz9DqWJoZWvZtEHc5RwVixb4jsF8ycAew4LLM
	CSKywHC5uiEC3AnR+Wrtd+kVR7FnbQ9kXASq4MZdh1cOd1Wf8UNlrUujDzJHWYu6rnTwQIGUNSB
	vCvhgHw==
X-Received: from pjbsh12.prod.google.com ([2002:a17:90b:524c:b0:34c:2156:9de7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5803:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-35272efcc92mr2558426a91.16.1768577606439; Fri, 16
 Jan 2026 07:33:26 -0800 (PST)
Date: Fri, 16 Jan 2026 07:32:47 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176857711424.940905.14821355548518788463.b4-ty@google.com>
Subject: Re: [PATCH v6 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 16:16:36 -0800, Sean Christopherson wrote:
> This series is based on 'https://github.com/kvm-x86/linux next', but except
> for one minor conflict in perf should apply on Linus' tree once the KVM 6.19
> pull request lands.  I considered waiting until 6.19-rc1 to post this, but
> I've had this in a "ready" state for a few weeks and want to get it out there.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> [...]

Applied the KVM patches to kvm-x86 pmu, thanks!

[14/44] KVM: Add a simplified wrapper for registering perf callbacks
        https://github.com/kvm-x86/linux/commit/4b24910c0569
[15/44] KVM: Add a simplified wrapper for registering perf callbacks
        [DROPPED - already merged (and then fixed)]
[16/44] KVM: x86/pmu: Start stubbing in mediated PMU support
        https://github.com/kvm-x86/linux/commit/3e51822b2fdf
[17/44] KVM: x86/pmu: Implement Intel mediated PMU requirements and constraints
        https://github.com/kvm-x86/linux/commit/bfee4f07d880
[18/44] KVM: x86/pmu: Implement AMD mediated PMU requirements
        https://github.com/kvm-x86/linux/commit/9ba0bb4ae76a
[19/44] KVM: x86/pmu: Register PMI handler for mediated vPMU
        https://github.com/kvm-x86/linux/commit/1c4ba7286afb
[20/44] KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
        https://github.com/kvm-x86/linux/commit/80624272129e
[21/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated PMU
        https://github.com/kvm-x86/linux/commit/d3ba32d1ff2a
[22/44] KVM: x86/pmu: Disable interception of select PMU MSRs for mediated vPMUs
        https://github.com/kvm-x86/linux/commit/2904df6692f4
[23/44] KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter accesses
        https://github.com/kvm-x86/linux/commit/0ea0d6314870
[24/44] KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
        https://github.com/kvm-x86/linux/commit/02918f007792
[25/44] KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter updates
        https://github.com/kvm-x86/linux/commit/3db871fe185b
[26/44] KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on AMD
        https://github.com/kvm-x86/linux/commit/a2f4ba534cc5
[27/44] KVM: x86/pmu: Load/put mediated PMU context when entering/exiting guest
        https://github.com/kvm-x86/linux/commit/56bb27369750
[28/44] KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are active
        https://github.com/kvm-x86/linux/commit/f7a65e58d643
[29/44] KVM: x86/pmu: Handle emulated instruction for mediated vPMU
        https://github.com/kvm-x86/linux/commit/283a5aa57b22
[30/44] KVM: nVMX: Add macros to simplify nested MSR interception setting
        https://github.com/kvm-x86/linux/commit/cb58327c4c8a
[31/44] KVM: nVMX: Disable PMU MSR interception as appropriate while running L2
        https://github.com/kvm-x86/linux/commit/88ebc2a3199c
[32/44] KVM: nSVM: Disable PMU MSR interception as appropriate while running L2
        https://github.com/kvm-x86/linux/commit/3b36160d9406
[33/44] KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space
        https://github.com/kvm-x86/linux/commit/860bcb1021f5
[34/44] KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already match
        https://github.com/kvm-x86/linux/commit/b0b6a8d3be16
[35/44] KVM: VMX: Drop intermediate "guest" field from msr_autostore
        https://github.com/kvm-x86/linux/commit/462f092dc55c
[36/44] KVM: nVMX: Don't update msr_autostore count when saving TSC for vmcs12
        https://github.com/kvm-x86/linux/commit/58f21a01417f
[37/44] KVM: VMX: Dedup code for removing MSR from VMCS's auto-load list
        https://github.com/kvm-x86/linux/commit/0bd29379114b
[38/44] KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
        https://github.com/kvm-x86/linux/commit/84ac00042a28
[39/44] KVM: VMX: Bug the VM if either MSR auto-load list is full
        https://github.com/kvm-x86/linux/commit/2ed57bb89976
[40/44] KVM: VMX: Set MSR index auto-load entry if and only if entry is "new"
        https://github.com/kvm-x86/linux/commit/0c4ff0866fc1
[41/44] KVM: VMX: Compartmentalize adding MSRs to host vs. guest auto-load list
        https://github.com/kvm-x86/linux/commit/2239d137a71d
[42/44] KVM: VMX: Dedup code for adding MSR to VMCS's auto list
        https://github.com/kvm-x86/linux/commit/c3d6a7210a4d
[43/44] KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR with list address
        https://github.com/kvm-x86/linux/commit/9757a5aebcd6
[44/44] KVM: VMX: Add mediated PMU support for CPUs without "save perf global ctrl"
        https://github.com/kvm-x86/linux/commit/d374b89edbb9

--
https://github.com/kvm-x86/linux/tree/next

