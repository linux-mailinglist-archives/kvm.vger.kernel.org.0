Return-Path: <kvm+bounces-63221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BE035C5E4BC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5AC2D384F10
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F4332D0F0;
	Fri, 14 Nov 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hD8rCw8G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4E32C954
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763134063; cv=none; b=hO12waiEdSRxOixhpk6FqnsTCGebwoc0dIjMAa5U3m/cJ83KZuUbgJww/1cTDHrEb9jTm0fdAVQFmQd99TZF7ay5ojQzPpFV4RJcusJHKyxe3V5QUqF/XfBHbQMG0lGiPHdFmFTbaQGKg1EmwrrScOA3lSaYK7YSVxi7MDhDmVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763134063; c=relaxed/simple;
	bh=Js8j/NG9gqdlcvCQlJveM0zst979u1fWcjgGE8CbeDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=jU7SXhQN6GqwAORcExFfx85VuV/Z9giLN6aZiMESza1mrjFp9pzDBDTRJBGZKB7oSdXe4aLZysMPfsGmYmX4NCJPp0RdBmaGBAYAzsr+hYg0p3+zt+fl7TiKOWqVaS4F/NMOz2NtXudncHpl1mUTKIcy8oS0WH/5Pqy1esIeoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hD8rCw8G; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f11bso2977384a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 07:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763134061; x=1763738861; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P7qur3oNJDjn0ufieeTMCoxJ9koWZdOXvP4VkDtArKY=;
        b=hD8rCw8GtND9oje3xhdCOQOLibtfYhx3FpA3wxm494z2o5mZugDhPz/Q5xFFUlwIxH
         CRcyRQrVsCt2obW/qn5ZDdOywbZUISCCcsYAO0m/VQrFEsxFmOxsW1D0sKGOjvHopYUZ
         O+KcudTGXpMmicXibIuLrDZuSomBseKX9tp5xpiJswAv4xdkKgAI9qyBNH+gYepnHUJ2
         +17M3QqAO4R+hB9f8nL8JompXAaEMK1gimOq15pxoaHmw+O5SKYm151HnaqBtNdE48kn
         5bpHwz/sBtkFXIaubm/sbBCIPUu4+MbnE3yBtJ8j9wYeSiMdSaN47twyLMNAyJH8v2pA
         biAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763134061; x=1763738861;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7qur3oNJDjn0ufieeTMCoxJ9koWZdOXvP4VkDtArKY=;
        b=Ibg0mRolFYdhBcRKAjufXGRwdqaeI4p2jT5SM3YwuYGuV2OPWrLigRCI9N3aa9usv2
         LyN+9DmI3h21Q10Ja5OvxwUkD1xgkcOC4jvGkw9dUHgpYt2aRJYDMgjwoVb20oQ13RcF
         JzjgsdRhcAB9brtcse9IyDypAFXHbijiLNDSsS9p7TKxg67JszCYp2Aif6dk2mk/mvyl
         e28kpEehISWk8/pnGqCvMzidIxZKkekYvPEuqryGy3JY1pvKLolganHlGQdOwfHY7Ea3
         ZTZi8vqo+/JG4u3QZOEJPpxeOyMOcOvN+OhoX4ahiEJkZ9uuAqqQ43Qr2PAAj0OrP9ly
         96ig==
X-Forwarded-Encrypted: i=1; AJvYcCWTEtMPB4YWkiAeInwksGCbXZdxfViohcB0LA0XJHrg13GKnwfV+7sbHcvOd3HZfArQ32Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVXmXeyCYcG10M2N99FkbUKH4rCcecBHakPBx57rzTEm+chylt
	78w/aJ3WRlYz6L0gdIXB/cXlPQctFK3le/g4IpudnkwZHEqXCzdPvfu722HXP91TxQuEl8Rvm08
	PqC1cfQ==
X-Google-Smtp-Source: AGHT+IGaZMsok9zj7+AIZxZQZifyj8jg6T9CJOKyvCnzF6EFugGvhUwNvNxHTPEHPKDJPPYyf/bpN+dPvCQ=
X-Received: from pjoa6.prod.google.com ([2002:a17:90a:8c06:b0:342:b238:e0ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2685:b0:33b:b078:d6d3
 with SMTP id 98e67ed59e1d1-343fa62bf74mr3886801a91.23.1763134061288; Fri, 14
 Nov 2025 07:27:41 -0800 (PST)
Date: Fri, 14 Nov 2025 07:27:39 -0800
In-Reply-To: <20251113225621.1688428-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com> <20251113225621.1688428-8-seanjc@google.com>
Message-ID: <aRdKa9jVMt0Rn5tj@google.com>
Subject: Re: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit value
 through all of KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Sean Christopherson wrote:
> Fix KVM's long-standing buggy handling of SVM's exit_code as a 32-bit
> value.  Per the APM and Xen commit d1bd157fbc ("Big merge the HVM
> full-virtualisation abstractions.") (which is arguably more trustworthy
> than KVM), offset 0x70 is a single 64-bit value:
> 
>   070h 63:0 EXITCODE
> 
> Track exit_code as a single u64 to prevent reintroducing bugs where KVM
> neglects to correctly set bits 63:32.
> 
> Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

...

> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e79bc9cb7162..4c7a5cd10990 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -781,7 +781,7 @@ TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
>   * Tracepoint for #VMEXIT reinjected to the guest
>   */
>  TRACE_EVENT(kvm_nested_vmexit_inject,
> -	    TP_PROTO(__u32 exit_code,
> +	    TP_PROTO(__u64 exit_code,
>  		     __u64 exit_info1, __u64 exit_info2,
>  		     __u32 exit_int_info, __u32 exit_int_info_err, __u32 isa),
>  	    TP_ARGS(exit_code, exit_info1, exit_info2,

As pointed out by the test bot[*], the trace macro to print exit reasons needs
to use 64-bit variants to play nice with 32-bit builds.

And now I'm questioning all of my testing, because my build setup detects that
as well, _and_ the hyperv_svm_test selftest fails.  *sigh*

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4c7a5cd10990..0fd72ce83926 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -383,10 +383,10 @@ TRACE_EVENT(kvm_apic,
 #define kvm_print_exit_reason(exit_reason, isa)                                \
        (isa == KVM_ISA_VMX) ?                                          \
        __print_symbolic(exit_reason & 0xffff, VMX_EXIT_REASONS) :      \
-       __print_symbolic(exit_reason, SVM_EXIT_REASONS),                \
+       __print_symbolic64(exit_reason, SVM_EXIT_REASONS),              \
        (isa == KVM_ISA_VMX && exit_reason & ~0xffff) ? " " : "",       \
        (isa == KVM_ISA_VMX) ?                                          \
-       __print_flags(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
+       __print_flags64(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
 
 #define TRACE_EVENT_KVM_EXIT(name)                                          \
 TRACE_EVENT(name,  


[*] https://lore.kernel.org/all/202511141707.t4ad044J-lkp@intel.com

