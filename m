Return-Path: <kvm+bounces-48182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2890CACBA0F
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBD63169A37
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42C12248A0;
	Mon,  2 Jun 2025 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h4fxPBFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A138D6ADD
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884255; cv=none; b=IPNKgLUiNWWZr9klpyY+bC4bzPFpY8CLSqHkLmT9c5yAd2KbXBzcjS0rjw11LKUzYqFzU3p6SJuHLG+9fPkBWM+qIqb7ft8W3fDAGXhxVGlRol6RMw6Tr77+XidcnRzp6U4u5hF8Of3NR2zakXZ7l/8Pvol+zVSwkB/rr2NolXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884255; c=relaxed/simple;
	bh=v0XE2JFU3PXQw1oYBcQG5l6MPvAm2M5g2to2E2+f2Yc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oB1I3nlczmblor6uWaWD4Zj7dUY4Y9KnPgkGf8WPF5yjEapGL+cIvGftgrUd1aI1wP1Rm1z2J/NYrQKHu12/QHZqQTjolVmX9+v6dZ1qxV8KpujKuiLtRC7VpEX8IZ5xJuikto2wdfRwb9GA3dLAGazDB0c5B80VmjfJ58X7QOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h4fxPBFw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215090074so7468026a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748884253; x=1749489053; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GEZapm8fiWqKuDBlb4/ws27a3eN39EKuHvs9QfnS6cE=;
        b=h4fxPBFwp2vXAZgrmPJd+w0gcP99sg96vLww51OaVSqpPSBblEReozKpTDytdO41BH
         SZP9kcfltFKFvhwR7T4W5pzQvsPQrgzh3BpDNvybpc6mQ9+Rb9xWhv2fRyVLF1SIuCeN
         pn0h23ynw36BviuW+gWhyTJahC9lZe9k62Sv6s7/fnXIhUtUBqiEfYQtj/JiITFqgdL4
         bIAJq7lopojHoLGlBAWkHx7s+dDFJmL/B9RTuROuVDcDNdEOPoBU3J5j1/vJBSn2TF0t
         tUxowg5Xdl0q+zJ1qgrz+PcGLtPx/rx7C/u9f0dAGhGMymlTqVUcsssca6mwAOo2i91B
         m1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884253; x=1749489053;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GEZapm8fiWqKuDBlb4/ws27a3eN39EKuHvs9QfnS6cE=;
        b=miHXgF7ht8JLF5uNG8cYDQeubyKQfe52kWZpJKA5vTik3QoHVd3+WzCFrfOsqWjPI/
         51lkPwGCnif+vmVQbW1bfmFlUg9WO1Fff/CViW+Ra5u9P6HDMm1gjsCGsYMrwhP7BZIM
         bl12Si53Bo8oY2sCWPeRgrq0sq2z5SIT0ZtXUwwxFSiiHLngtQdqIBbukCEHMzOPdnCR
         PLr/wxZyHtJ4hTpDkVw/+BbTK6X+raIlVQjf9+yzxVQU3sROoyDaV2QXQHtfEklYELZ0
         j/NjyY8gaAjivjHDeWWbQPO2ZzOATP9nvJ84727FH4jNYimsRbro4tYSHxj770Vs/8OP
         fwcw==
X-Forwarded-Encrypted: i=1; AJvYcCUlbeM3fJU+QlvR5iHByYCV2qFZVxHuhoif1A5fQpqI3vVCrUd/09BDE92oZiHOXtZrQ0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzgvxM6p8lW3ffgKamRpirl0N9HiRBvP6/18OeeQJdn4+RLp0F
	T7yZvZ/FMqiek0BT3EuchUCNbkDUR3Bc87rMvg/lvoMZAIXZSjAgOY/Tzn79WcjCCEedb/Xr/4f
	K6T0yVQ==
X-Google-Smtp-Source: AGHT+IGtPRo3fW4cHMqcCN7uH/TGK3HbpFpsizomYXt9Zj04sUjf3sES8XZPqN19AiOl8JNCngkzOInECOc=
X-Received: from pjbse6.prod.google.com ([2002:a17:90b:5186:b0:311:a4ee:7c3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cd0:b0:30e:8c5d:8e4
 with SMTP id 98e67ed59e1d1-3127c73d4e1mr16039502a91.16.1748884252968; Mon, 02
 Jun 2025 10:10:52 -0700 (PDT)
Date: Mon, 2 Jun 2025 10:10:51 -0700
In-Reply-To: <04e4c088-46f9-41fe-a681-cf494bdbdb03@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-17-seanjc@google.com>
 <04e4c088-46f9-41fe-a681-cf494bdbdb03@zytor.com>
Message-ID: <aD3bGxdrrplf0YvT@google.com>
Subject: Re: [PATCH 16/28] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025, Xin Li wrote:
> > +
> > +	if (vcpu->arch.xfd_no_write_intercept)
> > +		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
> > +
> > +
> > +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
> > +				  !to_vmx(vcpu)->spec_ctrl);
> > +
> > +	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
> > +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
> > +
> > +	if (boot_cpu_has(X86_FEATURE_IBPB))
>=20
> I think Boris prefers using cpu_feature_enabled() instead =E2=80=94 maybe=
 this
> is a good opportunity to update this occurrence?

Yeah, I'm comfortable squeezing in that change.

> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> > +					  !guest_has_pred_cmd_msr(vcpu));
> > +
> > +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
>=20
> Ditto.
>=20
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> > +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> > +
> > +	/*
> > +	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
> > +	 * filtered by userspace.
> > +	 */
> > +}

