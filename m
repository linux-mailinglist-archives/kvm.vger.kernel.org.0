Return-Path: <kvm+bounces-65555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BFCCB08B2
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F39983017A54
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44EF8301717;
	Tue,  9 Dec 2025 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZuCJ19J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227F6301489
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297412; cv=none; b=hXu5loctzRlbTZaQY4d0lzM5QcDZuGEsoQDKh9e+l2VOo+g5KqboRaryhQ9ybov55y9XHOEZP4Pc+r+6/ono6KJX7bYqvlsQVc7spxWPt07a0yhR/kAqKlUu2VNkR561tqPxt1FEfHYv4hxox2Oik61gq7fIYomUpQ8suXWUPss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297412; c=relaxed/simple;
	bh=rY2est9o9tKOhOy05RtlVvi6+hzwvTS90wBZNOTAqIs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NOKWMTQZ3I5jdVj07IgJ/6AQoIT16PeJFS5wq3BR4BWw+OgxQmJzPEOncyRt3xU+nwETPqwnsZ9c4gK7LceD0O2LGE1Xl5zKqMgg7WiKa4J710ATNlLk21or8rz5liLXhH9l2QNexEfMpB/FgmodeKHVcU2ISaKscH0V82IgHsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZuCJ19J; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c7957d978aso6418788b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765297410; x=1765902210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4dB7+s+12T2YlrPZ7A/PFbuE2bQAB8mJ2BcchIEKp0=;
        b=DZuCJ19JIhEJPEVNuBSn66p4nq1yCXbO/kFZ52EhIBm2Mi74lmRQDXOIzW8mmRWz1k
         SKPWSvtyqqqzAo/bNzITC4waqfhe/CCgSohYt/09RYHrvA3rIvrNsA3H3dRJta8VMpc8
         QllfDTIpouPYMSlJTgKS/dSLFnIKOE4vAqwH8mJ77ATUjCYO0U/GJJxyuyhzGF2o27n1
         dx0AdZgMzoUGtAdSLsO4AJeqRCVpyh9rElIb33id7i89ji+7MGts7uAqq1h0jA+fgBv3
         Y0TfRoh+/JpczPwB8akihrWsyRSYSAjQ4iUP91kHmp9RW/R0sn+DoCOoTgb2nPVpMMCc
         stWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765297410; x=1765902210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4dB7+s+12T2YlrPZ7A/PFbuE2bQAB8mJ2BcchIEKp0=;
        b=rbwvwppBTltAa/iglHcFMTun0hLVXnMnH0Oe9eYIfkax6Y2s61uw/XA4FTSeXnWQ5C
         SxgZmH0vLBSAwIP0rlr/nssWONE3IKIt38hzIATIbOp4E7/J1JDG5AWhqVEEzTTaIMvr
         pRst3xvrpNH8JzLfuHlg8RIMTEFkWNPLWDYoE3+BaoRcZnBU5EnjWg57HIe+z4oo5tfh
         +70nKzcE/+vxaW7/CXcBp24BuwybbQieBgA5d4ooXFSyoVPZB8/b5uTy5wXNaPYLE+gB
         ZrXrJ7sUmftlTbS/jvHfU/+rKOWGMuFAEeoNZUB5eZMFj7FlJEkT9F9I+Tg2NP6imLc0
         mohA==
X-Forwarded-Encrypted: i=1; AJvYcCWr5tUAO7szq1A61lsRxzsxf+JMTzAsXGVYCfx4yMynyle5WF7/g6rchWrj+R2zcUVXdAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsL1O3FHlSdreOdLobPiI7GAMt/Nxky8mEobZhwLxZIZXX2hcP
	6mzEbOAuZtGjrzoFMfs2Vcrz36Tcx7yUKrgOGn01js9xJd/MZ8Dk4rhp+DXGurVkdz3WGLUQoa5
	oczjFAw==
X-Google-Smtp-Source: AGHT+IGV9JSz0ODGwiDkOUVCqQkvI3akSUsQSgVMX1u2B5tCT51UChALyl0qcPc+q1W16GpgxDNEJHJO1MM=
X-Received: from pgad28.prod.google.com ([2002:a05:6a02:4f5c:b0:bac:a20:5f1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f91:b0:361:3bda:7155
 with SMTP id adf61e73a8af0-36617e36fbbmr11906345637.7.1765297410272; Tue, 09
 Dec 2025 08:23:30 -0800 (PST)
Date: Tue, 9 Dec 2025 08:23:28 -0800
In-Reply-To: <20251110222922.613224-14-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev> <20251110222922.613224-14-yosry.ahmed@linux.dev>
Message-ID: <aThNAPkIRcTxsUMr@google.com>
Subject: Re: [PATCH v2 13/13] KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
> only bit that needs to copied is NP_ENABLE.

Nit, explicitly state that all other existing bits are for SEV right away, e.g.

  However, the only bit that needs to copied is NP_ENABLE, as all other known
  bits in misc_ctl are related to SEV guests, and KVM doesn't support nested
  virtualization for SEV guests.

> This is a nop now because other bits are for SEV guests, which do not support
> nested.  Nonetheless, this hardens against future bugs if/when other bits are
> set for L1 but should not be set for L2.
> 
> Opportunistically add a comment explaining why NP_ENABLE is taken from
> VMCB01 and not VMCB02.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 503cb7f5a4c5f..4e278c1f9e6b3 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -837,8 +837,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  						V_NMI_BLOCKING_MASK);
>  	}
>  
> -	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
> -	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
> +	/*
> +	 * Copied from vmcb01.  msrpm_base can be overwritten later.
> +	 *
> +	 * NP_ENABLE in vmcb12 is only used for consistency checks.  If L1
> +	 * enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If L1
> +	 * disables NPT, KVM runs L2 with the same NPTs used to run L1. For the
> +	 * latter, L1 runs L2 with shadow page tables that translate L2 GVAs to
> +	 * L1 GPAs, so the same NPTs can be used for L1 and L2.
> +	 */
> +	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
>  
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

