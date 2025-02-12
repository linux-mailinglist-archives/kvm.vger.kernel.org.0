Return-Path: <kvm+bounces-37975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7130A32C10
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7170B3A4E7F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C61C2505B3;
	Wed, 12 Feb 2025 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IGI+gaHL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA6120E01D
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739378552; cv=none; b=CsL44lt4bjog+KiI9BS0H0UaOLumsoBxFJqREeEOeBl9fIfkMLj3Lsw3DB6lW2Xwe53flSSqNvFOpNH2nPmaNrqDWzJKs4jXNQJnllq2Y6xRIVkYAOxrprvrsFGeeAJ9K20BIiaevP1tNfhh7ItBHts1cEfzERElmcRPH88Yycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739378552; c=relaxed/simple;
	bh=WQASWieCbIE6kwwSdS9ZC9zn2GZnhcsp9HBAsuV4sJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/DCDngnqYo6TWnfbsJJRgng8pprjS2vziiiFXYKjGUuurBl+wN/r2Iwdhxs1Y/fzg46hyMvtL0plM1Jq+KtADdJ2CFinPTfqkmRok2fJqKkTV1F3uLrr99Hoz2cC+qhARU7WBMo6uX4SE5JUptvksxpl4bdWpXtU0zsszMIEJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IGI+gaHL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa166cf656so13436357a91.2
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 08:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739378550; x=1739983350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4QKEnFcrp5IUoXHy+dx+avwVDPBfLMBRhwLtF3yGOSI=;
        b=IGI+gaHL5Qp/IBmsq9Ps7GClO3CPpvFKdmlAfaoa2QkPDS5IFaOsbPpd5WX0n5h2x1
         3lVjUKj5Wy5ekzDIQsQbIyjTg4lLT4b1EBjV+j5Qvjni/57VEGrzYcXSRhleGn7ErYE9
         eRgh1iZof10Zy4zODAwvvu9246y3S6Q2Wy+7anZ90MN/gbCS+i10YF8ec9MxOWwdSoBT
         SbxzlZ+qOPIa3daGbeuVs/eaGM88v2Y3GIGh7kvCEzjsR3l4Iq7pCos6YkeZ84lqTLaN
         r2sTpB9UwDItNSnGs1uS8XLItNR/ljsnvU6HgCjnf4IorOmSMDYxfc7sz1AX7p8CsTyk
         /rgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739378550; x=1739983350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4QKEnFcrp5IUoXHy+dx+avwVDPBfLMBRhwLtF3yGOSI=;
        b=v+Vu0ivQCdc+39rJwSXgokzKyL1+x35qQpzBjxFu4AZUeV7zGO+B45jGECR98PpW2F
         WJUK17rtwV8HMxEM4voY6fZ+H+k3QBuuq44X6U0iEpOn1jwaBAE8nylLSr4zLZdAV1dA
         Gn6kUF/7jXLQ0ohuJuVVE3cL176GjGXyOO2+8HGgBfgxsVuacScFmWbsA9ykykJ8xAfS
         zYh00aAXMo9BIRILp6qPv0RIQTYcqCIMTa8xX3P0RcVaKRPJbTGygY9xKkAaQTeug5F/
         MJveuQmfF6bRvq1+4867PMWdBzhATO72NwC4Sp2tluqpkwwnEDZnn4jfHUEB8y7j/u7d
         fXIg==
X-Forwarded-Encrypted: i=1; AJvYcCUI5VTabFpYgLgA0WXXQiJ9xE8PVIvipo1LiDAhu0Vd64XLJ7yk02IOhEPixT/DS1nOYM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsXfCizm/xfJ/m2Wy/4vlLFNdHmgR81mzWN/7s9pHZ+uYbFOod
	YrazdS5K4pnOwVTem4O/sQBpCpaTV4fhXzsxZ0F49xd0QpyeO5nzxgF36tVW6l6AOs3zQAwotwB
	JCQ==
X-Google-Smtp-Source: AGHT+IG+lXQ0YpWw0NrxbRll2Xo/KW84TuAuafJJBR5ybt9KbK4odBl2EB09na3g10ZEUP1QsZknCFrPXGY=
X-Received: from pfaz1.prod.google.com ([2002:aa7:91c1:0:b0:730:8518:b97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:68c:b0:1e1:b727:1801
 with SMTP id adf61e73a8af0-1ee6b399d5emr279472637.27.1739378550087; Wed, 12
 Feb 2025 08:42:30 -0800 (PST)
Date: Wed, 12 Feb 2025 08:42:28 -0800
In-Reply-To: <20250113200150.487409-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com> <20250113200150.487409-2-jmattson@google.com>
Message-ID: <Z6zPdN3vCWmm2Irs@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Introduce kvm_set_mp_state()
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Jim Mattson wrote:
> @@ -11288,7 +11287,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  		if (kvm_vcpu_has_events(vcpu))
>  			vcpu->arch.pv.pv_unhalted = false;
>  		else
> -			vcpu->arch.mp_state = state;
> +			kvm_set_mp_state(vcpu, state);

It wouldn't be appropriate in this patch, but I think it makes sense to invoke
kvm_set_mp_state() instead of open coding the pv.pv_unhalted change.  E.g. if
the vCPU is somehow not already RUNNABLE (which is a bug?), then depending on
when pv_unhalted is set, KVM could either leave the vCPU in the non-RUNNABLE
state (set before __kvm_emulate_halt()), or transition the vCPU to HALTED and
then RUNNABLE (pv_unhalted set after the kvm_vcpu_has_events() check).

Untested, but this?  I'll test and post a patch (assuming it works).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0aca2a5dac7e..c51499c66cfa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11292,9 +11292,8 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
        ++vcpu->stat.halt_exits;
        if (lapic_in_kernel(vcpu)) {
                if (kvm_vcpu_has_events(vcpu))
-                       vcpu->arch.pv.pv_unhalted = false;
-               else
-                       kvm_set_mp_state(vcpu, state);
+                       state = KVM_MP_STATE_RUNNABLE;
+               kvm_set_mp_state(vcpu, state);
                return 1;
        } else {
                vcpu->run->exit_reason = reason;


