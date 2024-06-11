Return-Path: <kvm+bounces-19283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A91C8902DE6
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4960A1F2294C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4671D79C8;
	Tue, 11 Jun 2024 01:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="okUFOnC5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4466FCC
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 01:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718068648; cv=none; b=SEsNricIMrkVqKD6/qZssbyj8IstregDEtEE7Vf4l/HMUGSDr1llOLvN9+Q1I0+EHzKCxfkvrB11u0d68EMr7E7hV5V12dh59yKur0kFnaTXGg8EBUtAuY8WhPlPAoD5xuSlctemn7Mg6jOMASGvfOdIJCbmnJeKklsJarnB04Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718068648; c=relaxed/simple;
	bh=cDG4sBmtaLwX3BcWuqNAVreT/h9JlC27J2E+qHFs6b4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lhU0MaM2sh358n94+S9oHSKhhygqZrZimXacbnM4kwbqqgNPIpudOy3Wx/1nlGzAEfQv8cCL+RJEaacN+x5z8nYBvRou/9pns6+eHEjFJBMSW0nWEFPU4DLzLc4HiGQ3sb18kGQpDGyoeyumoV9kaZy1RMGhuwsCklgwGHahAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=okUFOnC5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2c5bf70f7so3380578a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 18:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718068646; x=1718673446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lD/LO/gxXCIGTZKmzDO3IySUcSGm5VYiE8jvdtRhgQQ=;
        b=okUFOnC5kQPxvERe3gp1C9v8dcFAFH/DpCyD5cqahTmZW9If8wno8KTBmLyKgjfO2a
         s412FXhgyXXreAcq9Ot1nF7g5LKP1HZXs+SpBf9IMioUrlJ8tOcARhgW+g/JJbYe8v/7
         b5hP1L44HQwt9S+C8v2ZESy+MLKA4NBCnH39WdgbMuRP2SO7h44eBQxr5ijzux2iFd/y
         jJ/JPlX4c/YNekGgqc87OQAx6z4T34RFQaIxbU242nSd6GJvqpivwL1lam7bWgeJRJTb
         LNRHGsqoviW6o6Fn0Oo8+hJzotLYIVo3xZg8slxLlY9TO2tthQnYZQOBqwpNO+E/gHKg
         Oteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718068646; x=1718673446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lD/LO/gxXCIGTZKmzDO3IySUcSGm5VYiE8jvdtRhgQQ=;
        b=Mca4L98znPd7m79zzNvRO+qHvdqvgRhvJEuqHyodbIWLfmhQobkxY4qGJIuy8Bg1ii
         QbE0sqUdGXYpitvsiDjSzbixUsE4pIv2D8E/tBT3CNulhu2/0G0fQYzxN8mrKLlUkmOS
         nqBYZyiGEgtDaAf6DXAS9dFG2s8o74qSK2ml7RW+3KPH+rk250+FZ3iSmcPyrkFyP0ch
         4oofthZ240sofmcV7QpAiVwdamUrbWJBr2GwOZx3eMdCtCYN8ICwV8nYcHzgi4VHdvlp
         Bymn9wS4jHwE8YCiM4uRIQBJZMHfEM3Mh8X6Ox9eOzFSHSsJkLYrXW+rXbkdF5uHfwS3
         aqsw==
X-Forwarded-Encrypted: i=1; AJvYcCVK17jLtA8g9g1x5+lmTmlrTdWOpbA27dqNoHULRICZNyP/39iU1PctELQZsFuomZ8tX18iHs0UoorLNQ/4cW73ai/Q
X-Gm-Message-State: AOJu0Yxa0GnJ2GNx+w623KU1HjYB3QPjp2G6IVmoaDLfGjBz39aHGjic
	UfQslE4hihi5kvc574cq7t6qQPyNgTuyLQzroBg+QwrgrnbxhZQkbqX4xa9T5Pk1e/RYIgLZJtq
	+Ig==
X-Google-Smtp-Source: AGHT+IHhAcgd3utbJYDRGxgrLzP9SGACR5u04abW5bR8SQQdYf0g+W+AAgne/wgHvaBuqh1i70Q6FxoEe/M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:807:b0:2c3:2e2:8391 with SMTP id
 98e67ed59e1d1-2c302e283cdmr13494a91.0.1718068646422; Mon, 10 Jun 2024
 18:17:26 -0700 (PDT)
Date: Mon, 10 Jun 2024 18:17:24 -0700
In-Reply-To: <20240509075423.156858-2-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509075423.156858-1-weijiang.yang@intel.com> <20240509075423.156858-2-weijiang.yang@intel.com>
Message-ID: <ZmelpPm5YfGifhIj@google.com>
Subject: Re: [RFC PATCH 2/2] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, mlevitsk@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Yang Weijiang wrote:
> Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
> CET guest SSP is HW register which has corresponding VMCS field to save
> /restore guest values when VM-{Exit,Entry} happens. KVM handles SSP as
> a synthetic MSR for userspace access.
> 
> Use a translation helper to set up mapping for SSP synthetic index and
> KVM-internal MSR index so that userspace doesn't need to take care of
> KVM's management for synthetic MSRs and avoid conflicts.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 +++
>  arch/x86/kvm/x86.c              |  7 +++++++
>  arch/x86/kvm/x86.h              | 10 ++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index ca2a47a85fa1..81c8d9ea2e58 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -420,6 +420,9 @@ struct kvm_x86_reg_id {
>  	__u16 rsvd16;
>  };
>  
> +/* KVM synthetic MSR index staring from 0 */
> +#define MSR_KVM_GUEST_SSP	0

Do we want to have "SYNTHETIC" in the name?  E.g. to try and differentiate from
KVM's paravirtual MSRs?

Hmm, but the PV MSRs are synthetic too.  Maybe it's the MSR part that's bad, e.g.
the whole point of these shenanigans is to let KVM use its internal MSR framework
without exposing those details to userspace.

So rather than, KVM_X86_REG_SYNTHETIC_MSR, what if we go with KVM_X86_REG_SYNTHETIC?
And then this becomes something like KVM_SYNTHETIC_GUEST_SSP?

Aha!  And then to prepare for a future where we add synthetic registers that
aren't routed through the MSR framework (which seems unlikely, but its trivially
easy to handle, so why not):

static int kvm_translate_synthetic_reg(struct kvm_x86_reg_id *reg)
{
	switch (reg->index) {
	case MSR_KVM_GUEST_SSP:
		reg->type = KVM_X86_REG_MSR;
		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
		break;
	default:
		return -EINVAL;
	}
	return 0;
}

and then the caller would have slightly different ordering:

        if (id->type == KVM_X86_REG_SYNTHETIC_MSR) {
                r = kvm_translate_synthetic_msr(&id->index);
                if (r)
                        break;
        }

        r = -EINVAL;
        if (id->type != KVM_X86_REG_MSR)
                break;

