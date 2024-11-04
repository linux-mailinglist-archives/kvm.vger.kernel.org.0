Return-Path: <kvm+bounces-30578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D95CD9BC1AF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 00:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FF4A1F21AAA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 23:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97B11FE0EE;
	Mon,  4 Nov 2024 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hWG3qRuB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ADC18C015
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730764364; cv=none; b=ZInlAyeyJBG9+NZ6DvnlTLouwLRne1/YlfGw+zBXwJI7hFYqsJc5b/AmU4P78oZm1/StGRcgv/RZPn+4m577vPplvCUmd15FuPZZi3qXgoCAUaS/Rx5SVdwRUaV12T/jHcgzANxI/cpjl3D5OoZ6VnYhOyrnn6T5DD23i36/3FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730764364; c=relaxed/simple;
	bh=vhixG5RkH/oO6VwQ6rk9kIDqw46MdIK3xuQrk3w/0Ww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ng+BrjZnuGqc2UBsjtFN4DBJSpCTNsCUP14TBG5YBIW2AKxCYU3SUD81IZYDskvrd52THZRDZYqy7f+j4yztvKajj/T6E281YSpSefOK7T+BsoO60KuWMOLDyG7KQNRonS9VRCOncUK3zyiKRLn2Yg+k33FQNbjCNOs7IQngX9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hWG3qRuB; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e330f65bcd9so4319502276.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 15:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730764362; x=1731369162; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dj23aIP/JSlzkiKGKNR2PyMEMROM4uZwVNVsTv50L30=;
        b=hWG3qRuB1VCSizpcD3lG+tM0VcyPRmF4h7GSxtMEJkhwdsy7j4Qev9sqv92Nh0oNV7
         53yNPtjd6QNEo4cBOP/H2ndn1K9MqPnOcuue/V61EQmfFfQ3MpsXQ2hyCWML5wkuJBsE
         HBXjAf5/1dnJF3B5ikrd27qqZ0nV3Hf7y3R6pdlJGGsBG4mSaFquyTprsuOVSvU4sWa4
         a/9ZZPT58CBIdxcZ276XSO/G/r1np/wpXHch4NlLjKkUP4977oec02KNTRoC5IBjtvJI
         Bp1ojRxKtWR/XxT96DDvUXfAT8kL2TJuGWyL3P7984dVjt9zKFfjByCVq6bZyRutHGPw
         D0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730764362; x=1731369162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dj23aIP/JSlzkiKGKNR2PyMEMROM4uZwVNVsTv50L30=;
        b=Ezmxk6aiG2Euxy5xM/y8/Q3BDDbXUC9uwiYczE/HYLzGwNXy3J0MoOfHADFi8BE7oy
         nToADjioyZ3vGXdL8torb53wo+NbiImNPqH3vYRP54LFRajmLhBh6jymEexDsOzAAi9j
         suADwkPqTJ2drGdvtuxquR5y6I8BR/z/qScfqm3GryCsRDaRr8nUBX04fLRuds9j4cGU
         H66k1Mz4kdAgFe4cTWz7j0ftgIjP/WLXupel3bV7CyF/SqMyrqID51Q+gfG/jQrYloQ7
         fbeBVdGfV+P3bKWI0xYFatS8F1yaS3Tzd2Z67uIQaKbTUxqeA0FUyZvRqJJRd2qPIoWO
         8gHg==
X-Forwarded-Encrypted: i=1; AJvYcCXeQHRUHpPk8P3AC082AxKJbwRU3y62Y0bec5wgbvFyNNfpwM4Z2AZPYkeTFNRetqdyiCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2rGXGLlynYaLSiRSYuImUxoFIwoZvI10MoimmtHGMl2QMLcLL
	dTHxSHrB/VFW6GNBaa1fR2qRdb0VF3YJSBFY3S6vW5twKDkzKpdUMrWA6SsTKr1lglNvt9Lstqh
	f6A==
X-Google-Smtp-Source: AGHT+IHrIdGXd9K5Yl/THI445Wq8aFuSCT311ij4DHUoz7wGUVdZx7bT/V66YVO5ki4f3zA0D2pKFU1DJCc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1801:b0:e30:b89f:e3d with SMTP id
 3f1490d57ef6-e3328a15f4emr24094276.1.1730764362268; Mon, 04 Nov 2024 15:52:42
 -0800 (PST)
Date: Mon, 4 Nov 2024 15:52:40 -0800
In-Reply-To: <448c8367-9f54-4ab1-80c3-bb13c9ac4664@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101185031.1799556-1-seanjc@google.com> <20241101185031.1799556-2-seanjc@google.com>
 <448c8367-9f54-4ab1-80c3-bb13c9ac4664@intel.com>
Message-ID: <ZyleSDssLCYRPzTb@google.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host
 mode) behind CONFIG_BROKEN
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 04, 2024, Adrian Hunter wrote:
> On 1/11/24 20:50, Sean Christopherson wrote:
> > Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
> > for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
> > myriad bugs in the implementation, some of which are fatal to the guest,
> > and others which put the stability and health of the host at risk.
> > 
> > For guest fatalities, the most glaring issue is that KVM fails to ensure
> > tracing is disabled, and *stays* disabled prior to VM-Enter, which is
> > necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
> > is enabled (enforced via a VMX consistency check).  Per the SDM:
> > 
> >   If the logical processor is operating with Intel PT enabled (if
> >   IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
> >   IA32_RTIT_CTL" VM-entry control must be 0.
> > 
> > On the host side, KVM doesn't validate the guest CPUID configuration
> > provided by userspace, and even worse, uses the guest configuration to
> > decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
> > guest CPUID to enumerate more address ranges than are supported in hardware
> > will result in KVM trying to passthrough, save, and load non-existent MSRs,
> > which generates a variety of WARNs, ToPA ERRORs in the host, a potential
> > deadlock, etc.
> > 
> > Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
> > Cc: stable@vger.kernel.org
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 6ed801ffe33f..087504fb1589 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
> >  static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
> >  module_param(ple_window_max, uint, 0444);
> >  
> > -/* Default is SYSTEM mode, 1 for host-guest mode */
> > +/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
> >  int __read_mostly pt_mode = PT_MODE_SYSTEM;
> > +#ifdef CONFIG_BROKEN
> >  module_param(pt_mode, int, S_IRUGO);
> > +#endif
> 
> Side effects are:
> 1. If pt_mode is passed via modprobe, there will be a warning in kernel messages:
> 	kvm_intel: unknown parameter 'pt_mode' ignored

This is more of a feature in this case, as it's a non-fatal way of alerting the
user that trying to enable PT virtualization won't work.

> 2. The sysfs module parameter file pt_mode will be gone:
> 	# cat /sys/module/kvm_intel/parameters/pt_mode
> 	cat: /sys/module/kvm_intel/parameters/pt_mode: No such file or directory

Hrm, this could be slightly more problematic, e.g. if userspace were asserting on
the state of the parameter.  But AFAIK, module params aren't considered ABI.

Paolo, any thoughts on how best to handle this?

