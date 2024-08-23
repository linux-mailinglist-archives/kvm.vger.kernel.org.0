Return-Path: <kvm+bounces-24974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B413395D9F1
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E18511C2215A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7C81CDA24;
	Fri, 23 Aug 2024 23:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qgOKpEwE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3581C93A8
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457283; cv=none; b=ntsbFDKMXV0MAABqBXLIl0N3/c1WaW4KsEB3NbNDl/+m6E3WrbW9Xcn9zu7sBTuW3hAZUzJSplCzItA2PVT+xn0wygQM/QdZuwcnFB74PrVqrqibX9FPWAw5HdcLE4uAnjUlnWqr8PPTxLki03fcR3vPyDJxHjOPbi+MpVvKHso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457283; c=relaxed/simple;
	bh=xDC27S1v/Kp1xbIPazQWRZn/0njT0kv4lYdFbaNd7T0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PDsmZaNJdWRjIAuvxO0IxIGKghQ03stRR5F6Tn9t/kMlVlSOB67lMoDdk2kQIdn4ilRJ34jZV43IO/mImCQtR7SMe91GoFCG/wqkjCN1RRlp/bnEXe4U3K8UENCi1omOSQASLqc1prsb/ej2cjKhLP1DBOAyT7s8xnLR2/3nyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qgOKpEwE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-202088f100aso23990485ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457281; x=1725062081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=exn2FrXj636XvpLV2wibQdifpSIPqSIRNFYp2rvI/Q0=;
        b=qgOKpEwEyJ04aH5ouLN8BdRI3nETE1nPxbcaOskaiNfUBIXmijldfdCfDVML0ggqwP
         jWQin+qKFfarMNSXnikvmiBhaQ2dWOR7YRAm1+Fgl9j0ppECoHwf8kUtl+m1lISWmcqo
         BHPq5lAGnaKr6kjTDqeZq2Xe5pTpFFJXpFFVmzMvrXVGk6qsDSf75Gf6gd4x/KpYW8d/
         dPrdaxwA7pHll9EnBt4AA8gd67N0HOjqaERwaWV8XV5MGYwh1plcLyyfLDyqJ+vDa4v/
         0nHMf/m8DlV9RDXRETz1/liqZ948y16oAPqkxwnXPc2OJGmJtiUmFzh7Pe8NvhnlM0DP
         KRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457281; x=1725062081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exn2FrXj636XvpLV2wibQdifpSIPqSIRNFYp2rvI/Q0=;
        b=jeSCG/LAFeqw/xVknNzivcbHw8JILAGBD9NMYcIxRYN+8WIJQFF+XRiNCrow7qQ+Lu
         ZQma/WFPFuunu2PyIfcThwvihT5uDTovIEx05G6wiEuvqSWL11pjljiYVApLauxqY32L
         U8PBWhA6TaHop/Y2z1kl1LgXFi7mMC6H0QGIa769nWOXjc2dFNnIGNSlBM5D2/cO7b5s
         ff7itF2VJUYy4n1zyTE1/kv7tK9ykMPW0MvEBQVySI8l8L6NJx+GUrXOv82rRYj4Sqlz
         D6zzSFEOv5Ix65XVz8CzRyXGVyE2MoAsw9DMKetrfUuVGT7Sekc8vMef/PdDmDD9pLs+
         IFTg==
X-Forwarded-Encrypted: i=1; AJvYcCXLIfRXs8xBNZQ0QH9YXbXy9F2AHjwegYMPRugz59Kf2tpa55QgSr9h456Lg8EXzINmQzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMcY0w4LyR73H+Gg+kgxdqI4IojuPanavb0j2oU4OwneFeU/9x
	/Yv9eu227AvsGYJRc9q9KxWz94nCU5E/ZCD0rgDse7yfpwytmL3jzqWMu6/o+i1+CmniRJtOwXv
	M8w==
X-Google-Smtp-Source: AGHT+IGdwKYeKcdUrQBxNJcTvvQJ2dUJsfSXJmfmSQCZCEAhf0m0Ac2OofhdEQCmTooo7YcNchI8utr83qI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c401:b0:200:ac2c:6796 with SMTP id
 d9443c01a7336-2039e52c4efmr2488785ad.7.1724457280758; Fri, 23 Aug 2024
 16:54:40 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:55 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442184664.3955932.5795532731351975524.b4-ty@google.com>
Subject: Re: [PATCH v8 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 05 Jun 2024 16:19:08 -0700, Sean Christopherson wrote:
> The primary goal of this series is to clean up the VMX MSR macros and their
> usage in KVM.
> 
> The first half of the series touches memtype code that (obviously) impacts
> areas well outside of KVM, in order to address several warts:
> 
>   (a) KVM is defining VMX specific macros for the architectural memtypes
>   (b) the PAT and MTRR code define similar, yet different macros
>   (c) that the PAT code not only has macros for the types (well, enums),
>       it also has macros for encoding the entire PAT MSR that can be used
>       by KVM.
> 
> [...]

Applied to kvm-x86 pat_vmx_msrs.  I won't put anything else in this branch, on
the off chance someone needs to pull in the PAT changes for something else.

[01/10] x86/cpu: KVM: Add common defines for architectural memory types (PAT, MTRRs, etc.)
        https://github.com/kvm-x86/linux/commit/e7e80b66fb24
[02/10] x86/cpu: KVM: Move macro to encode PAT value to common header
        https://github.com/kvm-x86/linux/commit/beb2e446046f
[03/10] KVM: x86: Stuff vCPU's PAT with default value at RESET, not creation
        https://github.com/kvm-x86/linux/commit/b6717d35d859
[04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
        https://github.com/kvm-x86/linux/commit/d7bfc9ffd580
[05/10] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single 64-bit value
        https://github.com/kvm-x86/linux/commit/9df398ff7d2a
[06/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
        https://github.com/kvm-x86/linux/commit/c97b106fa8aa
[07/10] KVM: nVMX: Add a helper to encode VMCS info in MSR_IA32_VMX_BASIC
        https://github.com/kvm-x86/linux/commit/92e648042c23
[08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h
        https://github.com/kvm-x86/linux/commit/dc1e67f70f6d
[09/10] KVM: VMX: Open code VMX preemption timer rate mask in its accessor
        https://github.com/kvm-x86/linux/commit/8f56b14e9fa0
[10/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()
        https://github.com/kvm-x86/linux/commit/566975f6ecd8

--
https://github.com/kvm-x86/linux/tree/next

