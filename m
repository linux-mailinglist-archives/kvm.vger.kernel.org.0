Return-Path: <kvm+bounces-24970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 100F295D9E7
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 406B61C22A67
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2797E1C9EC8;
	Fri, 23 Aug 2024 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIebXDOw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC1018F2E1
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457249; cv=none; b=YNSqEtO4wHAV08RSRu+LVPAKo6N4x2yfh65ViPopollzETMTmGgYIK5G1rVZZ812d5oI7n+dOa5nt7u5bGXb4yW2tYRwBJ4DUmoZ3mmWsWGqFAYKSHpVDeugYyQZEa4KIGOFP5e6Y5MjogXoJIIoZyBkwDzPkM1Lnf9rE1Yhk/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457249; c=relaxed/simple;
	bh=syaC91o95OEEW2s70JvlpUn03eys1tP3gYIKE9pNcmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H7L3t6m70w4lrLo99EC2I9r427wuga8BgJYaNO+FMaS271oHjsLJ7KXyPs5UNc68MTU3RJHqnZJfnLAVmvOsHXvav1vhSr/vnyUAR8qq3Gf1T2A2rbyhT5vHm2pbVEfAKayd8zL8btpJjETzc7B4Zos+6E1D26laOUlB+zJpJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIebXDOw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70f0a00eb16so1852314b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457246; x=1725062046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjeQ4sUJxepKMd1YuoYTecnAndxcQA2Py/BA+Uc+sjo=;
        b=PIebXDOwaWVr245X0FWO/V2qscbX/0dVO9w5BUs/HrDmFczAPodEA3h+EluVfPzCwt
         4MjSBV6ihFHjmrO4ltTMLUIbGVFa1613vsPegSY8Vlp3RJuF0PDoK5sqHhSNolNDoq2n
         2omtH1y4rI5sXsOlWONev4dpJ8igotUcJIq+lQvxfmiHmra9Tky4mX/Gowc8DnbCV8GD
         6qh6VhD5Ef7AYBXpKtkoeyvOEUVkjALzme96kqwfU1z4H9SrccKFPMNQY+VaXUZZUF4h
         6tTz5qTFrd6pJOp/EZxJYi0KnBVTRlkMWWDeOWIZRqw9JdfegNtnYvHE8JgTAf1EfeSu
         MbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457246; x=1725062046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjeQ4sUJxepKMd1YuoYTecnAndxcQA2Py/BA+Uc+sjo=;
        b=dVQe+Gor61iEm1R6VYuCMcSyK/4cJ8UW1ugqWumu9B2uIYOKZ9+JJ2SO4plx/az7oN
         gZGH5wN1I6t/SRgHegDOAYCdHqQVSRg2ut4WSW8f/t08I0xDyZ83pAjNZ4TW+jX7pd2Z
         IkKzbRemdes005hLvw5yOYxk9LKahEZ/dTWfA/ZTnRI3n6JfNSE00u7e/aetYWt4VvlX
         2hpWEAf6L0HioxzLhsT/nlIolKb43IdA/nzZGofEVJCHmTYgHa2Jd0L1waH6yi1VqJLN
         7YGL+tv9xGjzQiz5Ioo6Y/XBTTY9/WkY14rRYdyE+y3EBvhZumwXO8avu24W+rgLJe8S
         cJaw==
X-Gm-Message-State: AOJu0Yyurk6pXI6SUHI7qUXDlw88eozAK7/m4cDHSIPbmOcWg5EU757b
	O7gXyRa1yRRPcmg4+iFf6uk//FOEWyL5Efnd1FYuaISO8zYdsESowM8UwZCOVsqWjRa1GyyW8Cj
	MjA==
X-Google-Smtp-Source: AGHT+IGkirtwyUTKyL39wix+m1OnVtTNEg7AM+vXXhVJfwyHpsD/kM8ZEV5NLVaNIrH2ZTAFsjxvpNTM4u0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9181:b0:70d:30a8:abaa with SMTP id
 d2e1a72fcca58-71445aa7003mr10252b3a.5.1724457245889; Fri, 23 Aug 2024
 16:54:05 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:47 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443897959.4130036.5832329559174205887.b4-ty@google.com>
Subject: Re: [PATCH v2 00/10] KVM: x86: Clean up MSR access/failure handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 11:19:25 -0700, Sean Christopherson wrote:
> Rework KVM's MSR access handling, and more specific the handling of failures,
> to begin the march towards removing host_initiated exemptions for CPUID
> checks, e.g. to eventually turn code like this:
> 
> 		if (!msr_info->host_initiated &&
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> 			return 1;
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/10] KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value
        https://github.com/kvm-x86/linux/commit/74a0e79df68a
[02/10] KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to x86, as enums
        https://github.com/kvm-x86/linux/commit/b58b808cbe93
[03/10] KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
        https://github.com/kvm-x86/linux/commit/aaecae7b6a2b
[04/10] KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to avoid kvm_msr_entry
        https://github.com/kvm-x86/linux/commit/74c6c98a598a
[05/10] KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
        https://github.com/kvm-x86/linux/commit/b848f24bd74a
[06/10] KVM: x86: Refactor kvm_get_feature_msr() to avoid struct kvm_msr_entry
        https://github.com/kvm-x86/linux/commit/7075f1636150
[07/10] KVM: x86: Funnel all fancy MSR return value handling into a common helper
        https://github.com/kvm-x86/linux/commit/1cec2034980a
[08/10] KVM: x86: Hoist x86.c's global msr_* variables up above kvm_do_msr_access()
        https://github.com/kvm-x86/linux/commit/3adef9034596
[09/10] KVM: x86: Suppress failures on userspace access to advertised, unsupported MSRs
        https://github.com/kvm-x86/linux/commit/64a5d7a1091f
[10/10] KVM: x86: Suppress userspace access failures on unsupported, "emulated" MSRs
        https://github.com/kvm-x86/linux/commit/44dd0f5732b4

--
https://github.com/kvm-x86/linux/tree/next

