Return-Path: <kvm+bounces-18362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 097368D4490
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 06:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80D80B23B58
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 04:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC1C143897;
	Thu, 30 May 2024 04:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+YkU0KA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D6D2B9AA
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 04:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717043704; cv=none; b=pTh9gKIr3LTVzgFNmon4QeQjTvyOhI8urH9A+u3HbCWN2Nfl7xOqu5q0tyUzNkg7qPKay5MACVJ4h9VcBy1uMg3R20aA2z/73YpDE0hgztxjVxTNMOnK1/wlQ53dOJZh33RmDmU3Y1r8gLdL4MDX/TWCu5T+ohHR5uuoi//t668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717043704; c=relaxed/simple;
	bh=ijlLsRtZZHnYoJ3yPB7419sfe/EZuo0NMSQNtDHtzfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=op3G6AJ4PUlIXYvS/uvocR46WPlzasQaZeIHFj4hVZG36YvMIA/Fu0pCYn5gbmmxiCw1clbhUzQyupQltpl5f9mLYdUvwl9Q+3XwfiasOOXFOwUPMGI5zqXXZ80QdfmkEoUJCfYv+twjpSbUi/uNjcKNt2VVSGMzvLOakMfvJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+YkU0KA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f8e98760fcso416872b3a.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 21:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717043702; x=1717648502; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHXFGF3VHEvVXRDqzcqAshyg/fjTm7rBwWkt3TNwjyA=;
        b=Q+YkU0KAJ3MLcQpMwu0aYBq6HV2+V+M9XH2G/DyW5AUnzQ6nftHyhyO/exN/M/NcAq
         IETYCnXLyieLSHnR6du7oGFUSW3B/c/k2Ac0drC7RcdDAot3gwdc+vizBdbQrDeyWtfs
         wWOLE2ZvkBBUzZOjvUwmUsnLRu4wMtOM06wEnbkHHEk3CrPxsybE74wqwQjOVnMekSOO
         3DJGFrhFGj04UFWH5Xe/JVTd6Y205e/5hLhDjgnbEE2YB4+UMPvOrslxb+er04H4GzJa
         6U7TCETHFXUjaI1eONFNom66BlMQ3OeQjnrvYUAwiUuPa4N1cPNaQqtyQEds65HcF0A5
         +IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717043702; x=1717648502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHXFGF3VHEvVXRDqzcqAshyg/fjTm7rBwWkt3TNwjyA=;
        b=AEbXDSJvcDjZldT7b32V+1TnPYyWOXQfYYq1WBLpHBN6m80D4KlNy3fexI+xMq9YhO
         jzYXNjjqa5rKVi8Gj8Pb/suyzWFO/ywS5bWYuOpxcgNZxp0jLF4h1RV+iKVCWpUrp4XK
         eWOLCvrQBEU2gsJQMrLpyCX4y0LYrtpRmj9k0RyQWnSUSC3+0bOqxPJJaohdehFKLoYa
         rb+QTElpmA1VhiSgybDbyqBcPzR0CxnBCiaR63ehfPRP8AAp1Dd3IXDfGeT2u+ZriU8s
         3/zAWgt5XZCnbnTo5/GEJNi9PVXRbjhRpxKB9jKlZAc6+owz0GJZj7bbUABoG1z3bsG+
         Cu2g==
X-Forwarded-Encrypted: i=1; AJvYcCXM9SgHa5Bof7Z1Mpjxc8Ta/9dnyGtKxFSTVLnuoTLvEgzqJw7PjJ+aCOrhIpcSVZTnP/2yEAaH+lBX+7m21neKOc4t
X-Gm-Message-State: AOJu0Yw7/cPLHLFfWV6Cl4b6Pcvej4qJekKOwRber1FLw0w4d6G18fBK
	B2q0xc8rqaOcQ+gIok4ErSW1qe+fy6TuiTWWdpMvVvGRfUT1RSvZQdNFk9/YOA==
X-Google-Smtp-Source: AGHT+IGgw+5vD7RhYJxJHZ93dg/f+8YAuzix2FsRP4g0ggs4yticRBrzHezxJ/1L56xtHkllUq/glw==
X-Received: by 2002:a05:6a20:7f94:b0:1b2:1bf1:2b03 with SMTP id adf61e73a8af0-1b264564d37mr1706923637.26.1717043701693;
        Wed, 29 May 2024 21:35:01 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f60a5aa7ecsm11991535ad.213.2024.05.29.21.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 21:35:01 -0700 (PDT)
Date: Thu, 30 May 2024 04:34:57 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 38/54] KVM: x86/pmu: Call perf_guest_enter() at PMU
 context switch
Message-ID: <ZlgB8Y08bU3yUI2S@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-39-mizhang@google.com>
 <20240507093923.GX40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507093923.GX40213@noisy.programming.kicks-ass.net>

On Tue, May 07, 2024, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:30:03AM +0000, Mingwei Zhang wrote:
> > From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> > 
> > perf subsystem should stop and restart all the perf events at the host
> > level when entering and leaving passthrough PMU respectively. So invoke
> > the perf API at PMU context switch functions.
> > 
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > ---
> >  arch/x86/events/core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > index f5a043410614..6fe467bca809 100644
> > --- a/arch/x86/events/core.c
> > +++ b/arch/x86/events/core.c
> > @@ -705,6 +705,8 @@ void x86_perf_guest_enter(u32 guest_lvtpc)
> >  {
> >  	lockdep_assert_irqs_disabled();
> >  
> > +	perf_guest_enter();
> > +
> >  	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> >  			       (guest_lvtpc & APIC_LVT_MASKED));
> >  }
> > @@ -715,6 +717,8 @@ void x86_perf_guest_exit(void)
> >  	lockdep_assert_irqs_disabled();
> >  
> >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > +
> > +	perf_guest_exit();
> >  }
> >  EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
> 
> *sigh*.. why does this patch exist? Please merge with the one that
> introduces these functions.
> 
> This is making review really hard.

Ah, right. This function should be added immediately after commit "perf:
x86: Add x86 function to switch PMI handler". It was just mind set of
development: "how can we call perf_guest_{enter,exit}() if KVM has not
implemented anything?" So we defer the invocation until this moment :)

Will fix that in next version.

Thanks.
-Mingwei



