Return-Path: <kvm+bounces-35339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D27A0C5DA
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 00:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D93293A2DDC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783941FA16C;
	Mon, 13 Jan 2025 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sLHU1YuM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CCD160884
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736812076; cv=none; b=DWVPN5rkdHJfESQI24yrrMB7honplyrdSnoa0V+wdv6FUn1MWW3Ls3ayajconyadrhVVnzHQxvkGW07HU2J5tO3HNzqX9VW6KBHkOs3Ib8Nn9XBN0MDn9ZdfY+/gjQruQn89zfoFTaraBXIvxnem5Y3+t8RV5MWPr6uP31zJHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736812076; c=relaxed/simple;
	bh=fTCT5TpXqNmZ9ymdvmc4dfpQWlYy0cDbHGSxcupe9KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vGRT/ewaOv8nZO5Zbp90iTP3ygatu9hQ3D+fXfUoVx5W53ZdqLLKVwu1/sP/UiVZAhxCr4/Fe+MhnQa/Pcvqnes3yNJZ3TNTf4jKEx9EGHH3VyC3gxO9VEvLzIhFf0WgcNhQDX0uJD6YdRnqdKPLsw95JjaithcybS1rT17kF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sLHU1YuM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so8427668a91.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 15:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736812074; x=1737416874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hD6m22BigUgoEDVkJoE+6XsquT1/RMxI0C+5BKRGrtI=;
        b=sLHU1YuMOuingmbENb4szBJfKwXJD6HN/pAPMj7hgfvLoAqVfbKOjZKzKZqSOHABI7
         2AcVuARyTSCp6X9ELDDOdxU44cGUyQUVploZVktsTNzD6syGK7KNPvpnQtQt8oVM7gyl
         Zuj7WPif03zNYH3rcBLTVk57e7ueQU1qIO89dD1PYFzg7ROYf3NkIj+vNqqJTARivGto
         LtNRErwC38GfMhA+kQPPiT4VrQrYRxxx6TrQ/TMtYupCgDMqP7QIiMk8UVXTW/mMnaoK
         GRooLQgG8zhWRbhxFhLPJKuX8HXeKeLoFZcE91LLasZBxUNfwjsDEgfQ/OH19QEWqfbS
         /hTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736812074; x=1737416874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hD6m22BigUgoEDVkJoE+6XsquT1/RMxI0C+5BKRGrtI=;
        b=GDYAMAXvXyk8So5Qp+uStpawL7vjoHccYDubsGhhncxBtMAJVn39tNPSaDPfo9qEqX
         wT08Hs2bgAZOLYB2ybS8uF4k1e45WaEst78FIr5suyfsJ2JIBLL1pVGtlr2j5A8P67Jg
         ee+By5BXhSWmdhPJKpXqOhyuIIT19WajkLA6NEB5XDiLw/6LiGPHjve/zpWWJUH6scqf
         myj6mFFa/ob9dTEQVzZOs34Xj42eBGEaWOXqMa2pjPJawK6qJK+3HMkOAD2fv1peeIQT
         +k4RFIbFYyiLyr7FE21KQOcIXEtdEcAysxhJEn1kXAB6+LOHPLQ9164G/7lCjrD33nbW
         HXWA==
X-Forwarded-Encrypted: i=1; AJvYcCUdUMyOAOW/ueIj3lnLkt4GXv7ci9Kc+8SB6Iq5PzaT5vdxsLMY4P+KIJoBmeEmnqUQurA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNe3onav4t81/30mIA9s8GzN0gTv8P8VqLDnKhklwOrc8UkRoG
	pNG7o1yM+AJ2XNXlWV5iSA99nDaZr94YMo6ZzhtzumTIokUIix+B06WFnpioljn+OG8gJ+iz826
	fJQ==
X-Google-Smtp-Source: AGHT+IEqBMb9BlWA9vSB1KYYIXdFRR7DtH4FfJdEq+KBIiQlOOl/g8td+7ypW2x1d66hMNENsHVArA/Xkwc=
X-Received: from pjbsm10.prod.google.com ([2002:a17:90b:2e4a:b0:2e2:44f2:9175])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8f:b0:2ee:dcf6:1c77
 with SMTP id 98e67ed59e1d1-2f548ebf531mr36203067a91.16.1736812074665; Mon, 13
 Jan 2025 15:47:54 -0800 (PST)
Date: Mon, 13 Jan 2025 15:47:53 -0800
In-Reply-To: <c88ae590-4930-4d22-988c-60a5eeaad490@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com> <Z2WZ091z8GmGjSbC@google.com>
 <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com> <Z4Aff2QTJeOyrEUY@google.com>
 <c88ae590-4930-4d22-988c-60a5eeaad490@intel.com>
Message-ID: <Z4WmKTRQ8e-amGus@google.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Adrian Hunter wrote:
> On 9/01/25 21:11, Sean Christopherson wrote:
> > My vote would to KVM_BUG_ON() before entering the guest.
> 
> I notice if KVM_BUG_ON() is called with interrupts disabled
> smp_call_function_many_cond() generates a warning:
> 
> WARNING: CPU: 223 PID: 4213 at kernel/smp.c:807 smp_call_function_many_cond+0x421/0x560
> 
> static void smp_call_function_many_cond(const struct cpumask *mask,
> 					smp_call_func_t func, void *info,
> 					unsigned int scf_flags,
> 					smp_cond_func_t cond_func)
> {
> 	int cpu, last_cpu, this_cpu = smp_processor_id();
> 	struct call_function_data *cfd;
> 	bool wait = scf_flags & SCF_WAIT;
> 	int nr_cpus = 0;
> 	bool run_remote = false;
> 	bool run_local = false;
> 
> 	lockdep_assert_preemption_disabled();
> 
> 	/*
> 	 * Can deadlock when called with interrupts disabled.
> 	 * We allow cpu's that are not yet online though, as no one else can
> 	 * send smp call function interrupt to this cpu and as such deadlocks
> 	 * can't happen.
> 	 */
> 	if (cpu_online(this_cpu) && !oops_in_progress &&
> 	    !early_boot_irqs_disabled)
> 		lockdep_assert_irqs_enabled();			<------------- here
> 
> Do we need to care about that?

Ugh, yes.  E.g. the deadlock mentioned in the comment would occur if two vCPUs
hit the KVM_BUG_ON() at the same time (they'd both wait for the other to respond
to *their* IPI).

Since the damage is limited to the current vCPU, i.e. letting userspace run other
vCPUs is unlikely to put KVM in harm's way, a not-awful alternative would be to
WARN_ON_ONCE() and return KVM_EXIT_INTERNAL_ERROR.

