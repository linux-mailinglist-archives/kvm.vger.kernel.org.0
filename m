Return-Path: <kvm+bounces-15035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEB68A8F69
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C2BE1C20D4F
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391AE8624B;
	Wed, 17 Apr 2024 23:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RH4cxJpR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15640481B5
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396955; cv=none; b=Wy9tJ1nnHEh2LhMiX9cGR5bVGGctj2RjTC+mcBOJfUmRsTwDVe9DC5Q2QUPmeX+qf8g1YJRVd5o7gwcAB7StMdoZUHhxVZooHlY1U8Q43ktO9qFKEBhi6F6wZWZMFsBUrzTizcSO/PsKMadMDMWtag07Uj7f5skArwXB95qv5QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396955; c=relaxed/simple;
	bh=EV0AKrLfU/yoYpRarWPNuys3sAe1Nq/9n2sVWYSToyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9cir3HSB7NZEJUf0+nJcugw/7gm+dqhnxdw14Z7pSwZu66rWLTzhic8NbsSDOj3pJDiUrhBia4rYW4HoWnUwJHK6WJpBCEX0ak+pBuF7U3fi7ZRl8RJedA0VJcAI9p1Ky04pCOMUW7YO+gxboWwlo+tDOPhmYz09JJDb382syU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RH4cxJpR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6180225775bso4075947b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396953; x=1714001753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NirJD3ZZcaTlw8nUlwu/ibV9B8oPJQME/V178SLfQT8=;
        b=RH4cxJpRf8j8Fg6IUenyDGV3CnDdK1MVxbpx5TALfzgda4IFXUsciEeHWTloarQqnj
         gxoBf8mcVZ4+r82WXYY0Ce/bC2Wumigwz+nGzYNddyXcO7L4ZxnK/yhuznqlMiEMcUmM
         uzyA80+/MAaZkjZjXdtPf7PtaV3ciM/dyRU09EP3e4HlOXkRb2sfZ39dqr/34Df5QFMA
         jVpWPoHGWMK/MCDuvc9vSfVrNDw5pmieNEzUOVqvAVwekEsWsY39LXQc7xGhBUC7DTbb
         rD1vAkDSoE2Vl2vnnsSTH2cfXwkWhaNBfcJTCPahLkVlbNaKT0a56EcMwWqYg4SQE9O8
         et4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396953; x=1714001753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NirJD3ZZcaTlw8nUlwu/ibV9B8oPJQME/V178SLfQT8=;
        b=UQFFAFKVA66w0w/naxfQ+uWDObW5813XpZ95G/W8893I31pPheBuv1LF5g0vSPos7r
         +qiF4TTCg2nzETHh71qOz4KkvxchNc4VNxfIjX+Pqpz+C1Z/soWkFdmFwLkW0KzhHMQx
         xXDTdv6H0tVHOmPMNMqudQ7+QMrlirdciZHV62fMjSuM6hDzvl2qqkOO5S6ef8X96IAk
         ufDenrfF1FtOvgTFg7Z5QSGffXYYRVShuiTHxyeYTrnueXtSmz9R55YuZl+V4IvRB5Ib
         i9LmsvovcQOIvexDNZbpDfPVmfVOsgk9dSy2VcYL4+TKRTxHU7OB74ATi2RDa6gI2NEq
         gufw==
X-Forwarded-Encrypted: i=1; AJvYcCU+AfDku2TE0fKeGGN5yQ/EYVb0pHC4UwaFt1+MCw4YVJlRGGy91/0PpwAjop0Pe08whkUKORCzns12nYFUqnigjnGW
X-Gm-Message-State: AOJu0Yxcn2YiJIebRI9KEU4mQNw7SWoCLNIdCas6nRA5sQ1DZAGlIDQe
	Y2dPVAfal3qEv6vInr1xYDVaGB4ob/GMq1khdOMCDMvswpzhy4YgBp8okTLqcvAymFAcEbHVeJn
	wNA==
X-Google-Smtp-Source: AGHT+IFOEHpwzdozPVxqUnlSfoWlpxvDliZGJf68SoqSvZOKzC5+Fe9J92CrBOtOUeQb0G7mypA5g1jUWGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1f83:0:b0:dcc:50ca:e153 with SMTP id
 f125-20020a251f83000000b00dcc50cae153mr230133ybf.7.1713396953157; Wed, 17 Apr
 2024 16:35:53 -0700 (PDT)
Date: Wed, 17 Apr 2024 16:35:51 -0700
In-Reply-To: <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240322212321.GA1994522@ls.amr.corp.intel.com>
 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com> <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com> <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com> <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com> <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
Message-ID: <ZiBc13qU6P3OBn7w@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Kai Huang wrote:
> On 18/04/2024 2:40 am, Sean Christopherson wrote:
> > This way, architectures that aren't saddled with out-of-tree hypervisors can do
> > the dead simple thing of enabling hardware during their initialization sequence,
> > and the TDX code is much more sane, e.g. invoke kvm_x86_enable_virtualization()
> > during late_hardware_setup(), and kvm_x86_disable_virtualization() during module
> > exit (presumably).
> 
> Fine to me, given I am not familiar with other ARCHs, assuming always enable
> virtualization when KVM present is fine to them. :-)
> 
> Two questions below:
> 
> > +int kvm_x86_enable_virtualization(void)
> > +{
> > +	int r;
> > +
> > +	guard(mutex)(&vendor_module_lock);
> 
> It's a little bit odd to take the vendor_module_lock mutex.
> 
> It is called by kvm_arch_init_vm(), so more reasonablly we should still use
> kvm_lock?

I think this should take an x86-specific lock, since it's guarding x86-specific
data.  And vendor_module_lock fits the bill perfectly.  Well, except for the
name, and I definitely have no objection to renaming it.

> Also, if we invoke kvm_x86_enable_virtualization() from
> kvm_x86_ops->late_hardware_setup(), then IIUC we will deadlock here because
> kvm_x86_vendor_init() already takes the vendor_module_lock?

Ah, yeah.  Oh, duh.  I think the reason I didn't initially suggest late_hardware_setup()
is that I was assuming/hoping TDX setup could be done after kvm_x86_vendor_exit().
E.g. in vt_init() or whatever it gets called:

	r = kvm_x86_vendor_exit(...);
	if (r)
		return r;

	if (enable_tdx) {
		r = tdx_blah_blah_blah();
		if (r)
			goto vendor_exit;
	}

> > +	if (kvm_usage_count++)
> > +		return 0;
> > +
> > +	r = kvm_enable_virtualization();
> > +	if (r)
> > +		--kvm_usage_count;
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_x86_enable_virtualization);
> > +
> 
> [...]
> 
> > +int kvm_enable_virtualization(void)
> >   {
> > +	int r;
> > +
> > +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> > +			      kvm_online_cpu, kvm_offline_cpu);
> > +	if (r)
> > +		return r;
> > +
> > +	register_syscore_ops(&kvm_syscore_ops);
> > +
> > +	/*
> > +	 * Manually undo virtualization enabling if the system is going down.
> > +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> > +	 * possible for an in-flight module load to enable virtualization
> > +	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
> > +	 * being invoked.  Note, this relies on system_state being set _before_
> > +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
> > +	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
> > +	 * a syscore ops hook instead of registering a dedicated reboot
> > +	 * notifier (the latter runs before system_state is updated).
> > +	 */
> > +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> > +	    system_state == SYSTEM_RESTART) {
> > +		unregister_syscore_ops(&kvm_syscore_ops);
> > +		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
> > +		return -EBUSY;
> > +	}
> > +
> 
> Aren't we also supposed to do:
> 
> 	on_each_cpu(__kvm_enable_virtualization, NULL, 1);
> 
> here?

No, cpuhp_setup_state() invokes the callback, kvm_online_cpu(), on each CPU.
I.e. KVM has been doing things the hard way by using cpuhp_setup_state_nocalls().
That's part of the complexity I would like to get rid of.

