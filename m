Return-Path: <kvm+bounces-54888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E31CB2A967
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8B937BBC5D
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5332341AAD;
	Mon, 18 Aug 2025 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNE2cVWY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B567322C97
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525962; cv=none; b=TXn0A9hrBDO6zB48r86pBweJKTvcDCyJ63jDy5jK+Y3bu3cb0t+iQO+saaFaGp3l1+ETQde1c2DCNukCRDXkplNk6gjASWYnAj4V0rZ9YSCxonzKAYlG/Oj0CJr102Ygl8xTMpGCAf60wmpwmGzrGEUMjQVZ9oXnnbaWmEFGU+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525962; c=relaxed/simple;
	bh=q7wLnIsj9Df7M2SoJo8Fw4xD92hyZgAUi5vWBunSKF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OmdKW33q1iujj8HDKOBhC+pUv1oXGaQRypbbXb8ZmYBtjm5dF9GszyLqufqIppPRNo8Dyh+B8OhdqQi2/r4blHLcug8mordhU47VttVb33f9DptaEM2ZIv6kfm9SsPipQoah9uvEg9j2zi+1gMt+dYEP8K0sEVmdjdB2t8RpOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNE2cVWY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3235e45b815so1445223a91.0
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755525960; x=1756130760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/oUX5Dmzb3a1t3+woS8WIA1+SPMGVyYKTMkq0zy7sA=;
        b=VNE2cVWYrzuF47g0gXZTjbm0vwff1pYqpQN7d96yCJWty6L/wGgi8gCTyoWp+54ibi
         sCtjOD6c4BaTmvVBFfq1him98WAP8i2Lbqk4c0hXWUNEnUCnjTzjBzuXwT8AcBhPb7SU
         20upy9A9lI1s2pk30K2xSNGSOTgxBAcCsBdtyHhW+7kBlHcA+lWP6Gq5btMOu/iobN/P
         4yaBt+wauRItvkLyAbMjJPFg6FTLc8u+MY6TjeLm2ZFYY22xI17ZgrYQaWwErWN/+4yd
         rwf/SNPjZvOxwElM3HpHph5p0fvG3G/hf1rDOg1Kghcc2egMRd2RshUNWzeJFmvBwV5w
         PLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525960; x=1756130760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/oUX5Dmzb3a1t3+woS8WIA1+SPMGVyYKTMkq0zy7sA=;
        b=lP6JQzTOlSTfJ+bv7DrpFsjzDqmO35n9RAm6a0zZIBo63JAK6ennjvPSuvgJTgSjoV
         VJJkmERd2YR6mYixn1ZUCHjXsOdADC1tixHLN37eaA5Rl2n69M0QGV/ElVofj4pE90f1
         KnBnSE9sanzWEdGiK9jiYEliGw2+1eztlYHyI59qWbpYuEo9SczUhk6bzdUazLj7eqtN
         d3ffXUQo4doIhEP0qNfTMj+BEaUdxCQKQ9wEMu8S6IUM+CL9u7gXosX5Ne5PsWldutkQ
         mA+cd27ZH/077XGx+TFvQ0Y3gcNxPzQBaceCPWDLOfEjSiQg/ecCSSV6V5D/f5sOnzJl
         OFJg==
X-Forwarded-Encrypted: i=1; AJvYcCVDK1anSmOMZzWtMSqe2gmEJasS0rEwNS9UVPG4inLn1iqDU/5IMIfa1t8hxXXufwNwU0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YySJZynbg6+ycnhkcMnNcGW25u1Sv4emn1yNAIdaLtY6TG0duxV
	MzCdJyv0PfBiN+c2OYwf21E1dyX/ba/eZp6u5SadsmAOPhIYLny7Sq5jLrdcNY9IeyDEjyEHQMr
	kyxibEA==
X-Google-Smtp-Source: AGHT+IEZ18KRb8Ud9T9C7ZMtoWkAppjv/C4HYE/3Gp5h59qoFkr23IdFXfeenzesUJbEnHOJIPEEcpWDjwg=
X-Received: from pjbsl16.prod.google.com ([2002:a17:90b:2e10:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35cb:b0:312:e731:5a6b
 with SMTP id 98e67ed59e1d1-32342122901mr14781254a91.32.1755525959777; Mon, 18
 Aug 2025 07:05:59 -0700 (PDT)
Date: Mon, 18 Aug 2025 07:05:57 -0700
In-Reply-To: <20250816144436.83718-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816144436.83718-1-adrian.hunter@intel.com> <20250816144436.83718-2-adrian.hunter@intel.com>
Message-ID: <aKMzEYR4t4Btd7kC@google.com>
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in guest
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Aug 16, 2025, Adrian Hunter wrote:
> TDX support for using the MWAIT instruction in a guest has issues, so
> disable it for now.
> 
> Background
> 
> Like VMX, TDX can allow the MWAIT instruction to be executed in a guest.
> Unlike VMX, TDX cannot necessarily provide for virtualization of MSRs that
> a guest might reasonably expect to exist as well.
> 
> For example, in the case of a Linux guest, the default idle driver
> intel_idle may access MSR_POWER_CTL or MSR_PKG_CST_CONFIG_CONTROL.  To
> virtualize those, KVM would need the guest not to enable #VE reduction,
> which is not something that KVM can control or even be aware of.  Note,
> however, that the consequent unchecked MSR access errors might be harmless.
> 
> Without #VE reduction enabled, the TDX Module will inject #VE for MSRs that
> it does not virtualize itself.  The guest can then hypercall the host VMM
> for a resolution.
> 
> With #VE reduction enabled, accessing MSRs such as the 2 above, results in
> the TDX Module injecting #GP.
> 
> Currently, Linux guest opts for #VE reduction unconditionally if it is
> available, refer reduce_unnecessary_ve().  However, the #VE reduction
> feature was not added to the TDX Module until versions 1.5.09 and 2.0.04.
> Refer https://github.com/intel/tdx-module/releases
> 
> There is also a further issue experienced by a Linux guest.  Prior to
> TDX Module versions 1.5.09 and 2.0.04, the Always-Running-APIC-Timer (ARAT)
> feature (CPUID leaf 6: EAX bit 2) is not exposed.  That results in cpuidle
> disabling the timer interrupt and invoking the Tick Broadcast framework
> to provide a wake-up.  Currently, that falls back to the PIT timer which
> does not work for TDX, resulting in the guest becoming stuck in the idle
> loop.
> 
> Conclusion
> 
> User's may expect TDX support of MWAIT in a guest to be similar to VMX
> support, but KVM cannot ensure that.  Consequently KVM should not expose
> the capability.
> 
> Fixes: 0186dd29a2518 ("KVM: TDX: add ioctl to initialize VM with TDX specific parameters")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

NAK.

Fix the guest, or wherever else in the pile there are issues.  KVM is NOT carrying
hack-a-fixes to workaround buggy software/firmware.  Been there, done that.

