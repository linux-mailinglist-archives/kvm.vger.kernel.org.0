Return-Path: <kvm+bounces-13471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF587897373
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FAAF1F21904
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9961814A4F1;
	Wed,  3 Apr 2024 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b0rjqOJM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE4149DE5
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712156847; cv=none; b=ks9pOQb0H4IewGRDfzt0+zrIKv9F56QJx0wBru980fmVal7mM6Dp3EwAlRvOD93FggQ4XAJt28LBJihTYq+HOTLYSQeQZWTg8pQVZvxoZvG0HVG6UtCIddlNaFrSAYIxLfro7epU4czio7BGSz+vJQjmWBqOVEaxWK5St2p8aZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712156847; c=relaxed/simple;
	bh=mCL4lyiZ3+TYVCezPLM4+q2eTMEGLTs2ek5mU230kBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSlphkLCaGnOcVWBg2Fzl2JviWEtxXbfIuwRcPYgqKONKAnTYcktTDXBGbgnuriuoBX2Tr9H9Mj1r58+ZblUepwc4HRuxxYGrbGzdqcTNbzPCp8ygY5K60UrCb/cQFFHB+4psn/n8P+Zu4maY/bOZgJu2lEuuPAVPyeYsmWw7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b0rjqOJM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso9425213276.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 08:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712156845; x=1712761645; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JtZ4iRSe88P1k/ODDADPoGeQTC06aIWlJ9ytym//wPk=;
        b=b0rjqOJMbSWAaVWcSDITyB9FPrWMFOVLw3ablHb7S2rMtOEqC2k8YEi0twHWa4iTqk
         7zs5Es2H1cZT9VUYkXoW2XFwsqYQYq+uNRPORyhuk1qhKZNbAD0IagvarFWotcCVkCu6
         6KehG7g1G/8YOMtQg/p30xZVY5H8S8+2zOPooYu3b/enMw7u8ZXqUXS54ULV/17K+Pnp
         za+zASn83Ug6CxnM2Z2Bzk2T2Jgei5Ubz1j/cQgSlAtGWpAhcV5Ij5zCL1o14HPJvlRM
         F+jATsEF8U+rPYtU5aJzlkM9zonEQG63JMbawHklVwsMxz28N3Dg9ZmFMmFhwSU5NXIj
         Yxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712156845; x=1712761645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtZ4iRSe88P1k/ODDADPoGeQTC06aIWlJ9ytym//wPk=;
        b=HJz5aAMZwn6BOGhgx9X1PzF9L4UQlLes9DXYkaKpYLU58ExyeHDs52ZVYbhnYERFHg
         dRDXxUXrkRBxzj1vKrrd1UDmeVCEM7NdO7evRpqbgLQ4lj1+fAkc98WhNbN3FYV6CCPg
         oRvKimMoVX4x2cLmm5Q3UKe7fXP7SZVZo275vVsX+vc8v4AzO4WLE64YGO2E7gFdGUjc
         AmN3a6FbdvjCqv+Jq3BYq4BR6tHxUO+KEnOmmbI4h8g+QIGNyBMiocZjGPdS7+o5ytdY
         RHIXvQw9b6Jw0N9TXo4q9LWkgNavqDb3ftaF8A4vKZMzdhOljoMDenKJhytgCBkX0dhq
         uuMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDbhJYgo+/3vAYH5iWAITLl0CfYvYc3yQZ9DDol5HVc9Hj4BcgKyWZ0m8lYMdv/xW89LGLsl1QH9qK1YoGypcyORrO
X-Gm-Message-State: AOJu0YzDGMkkFVBc+WSAaqmrXhk91DEFvf8GBzFiwMzq246n0AVgyP48
	cOEiQiUxDcd1Ir2SeFSAc/weUQn3SQV0jHG6JSZWJEVOLsyVvjNQ5h4e+GMyoKrFUKssC/Fs226
	wuQ==
X-Google-Smtp-Source: AGHT+IHUMg7l8Ba/eQMW6xc0LCY8Jqv8pilOK03SFH3Rgyd1QKq6aljjldttrmb86ym4lPSeUmJKzCzcmAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1006:b0:dcc:94b7:a7a3 with SMTP id
 w6-20020a056902100600b00dcc94b7a7a3mr1065852ybt.12.1712156845316; Wed, 03 Apr
 2024 08:07:25 -0700 (PDT)
Date: Wed, 3 Apr 2024 08:07:23 -0700
In-Reply-To: <Zgz8YFgD1CysKaDl@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
 <Zgz8YFgD1CysKaDl@chao-email>
Message-ID: <Zg1wqxSHF-RyLihQ@google.com>
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, Chao Gao wrote:
> On Mon, Feb 26, 2024 at 12:26:53AM -0800, isaku.yamahata@intel.com wrote:
> >+bool tdx_has_emulated_msr(u32 index, bool write)
> >+{
> >+	switch (index) {
> >+	case MSR_IA32_UCODE_REV:
> >+	case MSR_IA32_ARCH_CAPABILITIES:
> >+	case MSR_IA32_POWER_CTL:
> >+	case MSR_IA32_CR_PAT:
> >+	case MSR_IA32_TSC_DEADLINE:
> >+	case MSR_IA32_MISC_ENABLE:
> >+	case MSR_PLATFORM_INFO:
> >+	case MSR_MISC_FEATURES_ENABLES:
> >+	case MSR_IA32_MCG_CAP:
> >+	case MSR_IA32_MCG_STATUS:
> >+	case MSR_IA32_MCG_CTL:
> >+	case MSR_IA32_MCG_EXT_CTL:
> >+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> >+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> >+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
> >+		return true;
> >+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
> >+		/*
> >+		 * x2APIC registers that are virtualized by the CPU can't be
> >+		 * emulated, KVM doesn't have access to the virtual APIC page.
> >+		 */
> >+		switch (index) {
> >+		case X2APIC_MSR(APIC_TASKPRI):
> >+		case X2APIC_MSR(APIC_PROCPRI):
> >+		case X2APIC_MSR(APIC_EOI):
> >+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
> >+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
> >+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
> >+			return false;
> >+		default:
> >+			return true;
> >+		}
> >+	case MSR_IA32_APICBASE:
> >+	case MSR_EFER:
> >+		return !write;
> >+	case 0x4b564d00 ... 0x4b564dff:
> >+		/* KVM custom MSRs */
> >+		return tdx_is_emulated_kvm_msr(index, write);
> >+	default:
> >+		return false;
> >+	}
> 
> The only call site with a non-Null KVM parameter is:
> 
> 	r = static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE);
> 
> Only MSR_IA32_SMBASE needs to be handled. So, this function is much more
> complicated than it should be.

No, because it's also used by tdx_{g,s}et_msr().

