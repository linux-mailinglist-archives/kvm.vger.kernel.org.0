Return-Path: <kvm+bounces-55132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B87B2DEE4
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E48A01753ED
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3AD264F85;
	Wed, 20 Aug 2025 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dK6fW8vU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D1265632
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755699162; cv=none; b=a7K5DmH4/fgTgwtCFV/ya5VhuvQlR1RtdEumu3Nh1usdZDxuU8vwNQPVYnslwhXDKaiKqY/JDlmOJOPF58oJG+2QpLJie/YisK918ts0/69nBXp8/WRxIufTgkTeEJDP8Hx4juWXTq1W9AlJ7gRaVOlIfYcKMc1cMZH39CUZ0Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755699162; c=relaxed/simple;
	bh=9InHyz6ARRdf1AnUIymokXOt+NhUlq/lA972qGSJMVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaBTwPJUJAhbYMb8CEj8JWI8U5ZHFyreNl2XwceQDJL1DU1FCfOCoR4jpjYULP9isKYyEmMxyPoig50X7e5kqlxaUCtIpUGVbeMxpOvop470GcEllkIjRXhLTvaYwD7k4cXCqAHqijmujkl1K6mrIPV2d7ezmuC9dlMxmIEJ3gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dK6fW8vU; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso6228015b3a.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 07:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755699159; x=1756303959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KkLo76GtbITqKuw6aQh/pzZK0f614lGIwVkQDIxZQ4g=;
        b=dK6fW8vU8ZUfHgRZrTy8xlcr3Pr9Fwh8slVglVci1Lbgu9BxkQrTVp0gZxbI0ZVQA2
         ce0fnedfOUOTS0ABhP51oPICRE9EMAeVqG8glDND+KOvieDxJim8PJO2nzHa9lLpKDYg
         vstBnYc8qjdMpJW6L2ZAUV2HqIOokfHDtO2wwuswsZ2ktk/KMyoOHWY+3htHSz8tEi5d
         atrZay++620B//gDqkUmHfLzZ55hvStun2SILJr0m5Baipc+SyAv4Q1fjyaJ+uFEuduG
         6HDb9WuxD+dGNpTUNt5CddpbHUhNYjOu5xiVrA6BEov93zK2sDAgSPmHtHBXAi4Ndm2G
         ggiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755699159; x=1756303959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkLo76GtbITqKuw6aQh/pzZK0f614lGIwVkQDIxZQ4g=;
        b=uaXXhbgk0+UVANkQV+GP8bZpCanloMWniBKWPQS//Na36z4KPghHsMs4+hiovD/+Tk
         6zGue2+Xl8s+jEPgojI9FM5yuMh6QxM3H+3bye967bETaVyyE595B+FBIEqFyDBU0yxL
         cnJAw8r3tahcwf08Jle97LU3AYsVEwREcZ8FidQ2IPLU4YSNiIAO9EQDT3m7zKBmQuc1
         htGzWDGHq3kzqbJhgj97wKm9dt8qjwb36D7UTi3QRQNqKzTJY1h9d7Uyuy/wQ2u9+GbQ
         028mOzNgvs166iy9/BYvnG/g6fLevbAW0zV9L0E3Lrb+BfGLEZhy6jinOEpZJ+1Z3y/c
         3WyA==
X-Gm-Message-State: AOJu0YyQ+bckUXP7jmKEzooFqxF6+HGw23pzAcBo/odZCsd+uAMxEHzQ
	2uI295Qj62KwFhwsVO7+6VD5DZEsrXUzXdwjPzzhyljedHgdPey/9th14y07TylME0pcQD0yhTn
	eCAHhkg==
X-Google-Smtp-Source: AGHT+IGJQhBCVhVqaliziU8HDIj70XqxSr8dKTM1UVKTblB7QOEUcsE0cHTvWeeKL4c9L3kLeIOlS/MKYdo=
X-Received: from pgbfe11.prod.google.com ([2002:a05:6a02:288b:b0:b47:3ab8:86d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a28:b0:23d:54cb:2df6
 with SMTP id adf61e73a8af0-2431b7b90dbmr4933430637.3.1755699159523; Wed, 20
 Aug 2025 07:12:39 -0700 (PDT)
Date: Wed, 20 Aug 2025 07:12:38 -0700
In-Reply-To: <aKUzvnUHMUSC/A8/@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-16-chao.gao@intel.com>
 <aKShs0btGwLtYlVc@google.com> <aKUzvnUHMUSC/A8/@intel.com>
Message-ID: <aKXX1nOJb_q7GjQR@google.com>
Subject: Re: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, xin@zytor.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 20, 2025, Chao Gao wrote:
> >> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> >> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
> >> +			return KVM_MSR_RET_UNSUPPORTED;
> >> +		if (is_noncanonical_msr_address(data, vcpu))
> >
> >This emulation is wrong (in no small part because the architecture sucks).  From
> >the SDM:
> >
> >  If the processor does not support Intel 64 architecture, these fields have only
> >  32 bits; bits 63:32 of the MSRs are reserved.
> >
> >  On processors that support Intel 64 architecture this value cannot represent a
> >  non-canonical address.
> >
> >  In protected mode, only 31:0 are loaded.
> >
> >That means KVM needs to drop bits 63:32 if the vCPU doesn't have LM or if the vCPU
> >isn't in 64-bit mode.  The last one is especially frustrating, because software
> >can still get a 64-bit value into the MSRs while running in protected, e.g. by
> >switching to 64-bit mode, doing WRMSRs, then switching back to 32-bit mode.
> >
> >But, there's probably no point in actually trying to correctly emulate/virtualize
> >the Protected Mode behavior, because the MSRs can be written via XRSTOR, and to
> >close that hole KVM would need to trap-and-emulate XRSTOR.  No thanks.
> 
> I don't get why we need to trap-and-emulate XRSTOR. if XRSTOR instruction in
> protection mode can change higher 32 bits of CET MSRs, it is the hardware
> behavior. why KVM needs to clear the higher 32 bits?

If the VMM configures the virtual CPU model to be a 32-bit CPU, i.e. a vCPU that
"does not support Intel 64 architecture", i.e. CPUID.0x80000001.EDX.LM = 0, then
the behavior of the "hardware" that the guest sees should be that the upper 32
bits do not exist and should always read '0'.  But because the actual harware on
which the virtual CPU is running _does_ support Intel 64, XRSTORS/XSAVES in the
guest could observe behavior that violates the architecture.

