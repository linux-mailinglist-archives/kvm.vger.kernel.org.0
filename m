Return-Path: <kvm+bounces-32333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C459D5817
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 03:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED325282A08
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 02:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7501527A7;
	Fri, 22 Nov 2024 02:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/j6Qkbt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442B5CB8
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 02:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241497; cv=none; b=d0kd2GChwUG2fiTPRa5NB7P7TFiVUMZakZgW8AthaJ5b1yuXBG9MJkQeU8EwzpjZh2KX2XXOBuPoayEWqpFq5MEMwswFt47a3Ozakbe8l2LHwtpU+SG5RsxH+wgurxM49BJGTPPL3YG6PeaGTZdIWXK11LFX6OKbBEAFBadjMYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241497; c=relaxed/simple;
	bh=15oWvzbzFsyC7/bysCZCjLNUSlvH0XT1jyi58VfdcYM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MZBmo4OmqnoTvnxLPsahf6fL9vM7b/6I+ti7ExU/Obc5gTskdgKWVgJBWS5ULwPx4c2JZUukWZcUy2Jax9bDwx1tBTtl3uELN3pTnc+l4FF1KZTECLzO0etmM545Jpkl4CD91J8/lxCZ1/S3WDD80kqfWDitneUz9AkSum+Nmy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/j6Qkbt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732241494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xprF6kwslVLv7gu/pvSQtcz8F91IGU/uA30drlMd3hg=;
	b=L/j6QkbtkEVJxWJdAggI6x5aFjuZnSLEg3dFSRvFWAG2V8cymI87JIpmgJ3qIlu8QRQzQ+
	efJ0gqLH5oTdVUXaEy3XpZmXAQhIWjntaBXf3zJojkvBDFA607vRiLDj06jWcZND3J7x+K
	bJK/SB8spiLkWc7frpN4+xAHwvYUltg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-4e-dwOZZOyGcEXP0dBjbdA-1; Thu, 21 Nov 2024 21:11:33 -0500
X-MC-Unique: 4e-dwOZZOyGcEXP0dBjbdA-1
X-Mimecast-MFC-AGG-ID: 4e-dwOZZOyGcEXP0dBjbdA
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d407522108so20612116d6.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732241492; x=1732846292;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xprF6kwslVLv7gu/pvSQtcz8F91IGU/uA30drlMd3hg=;
        b=olhxC4bTwPtuaNP2THaXlfQXcnE3vUD7/o8/1B4CwZL/Bjotg2tRtABEzVOUvfadjB
         dJWn9ah4CJ8OgNHdk/KnIE8bL9zYzJF61QeSZ67K+GINMHh9/ObxalnYxA+pC8+XDV1Y
         wEqxQWTN2Crd4uEn5UQhCYk7b74ucg6mLaSPPIz7uQzTCJAv2Emw9WHUiwilX2lhO+yv
         Pt3Eqreruhm7exDiBcNtvPIbTFyZ1aLdTGChdG+L2Z1khDzSgtIAnrJFAVIvhoDiHcrT
         RClk1Lv5tcgUuzYXv1ENEj9qtyuiGFTr+DhsscnvbprcRi4MprCym7ye2EHAxo3Z4XWc
         EZBg==
X-Forwarded-Encrypted: i=1; AJvYcCWwP67sHNQAGJiFrm+uQDum+vv4oRf6CYL1ao4z3VZvtWxbV1e3KarFvLeC1iehsNDCVz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YztM1SX45pvd0DMdYVrlVkHe7jML/e6IEY7hnxfQ7gnvgzvv6pD
	3qadsN+hOJucJ2bRuY2M4T+MhvL/lYhjAjrfKsnkGVm+o6lSQ5zGyJGWJzR4CKy+BnJ8wvXxi35
	sqDsmNY1EXw4Nl476YGvvLlKjZsr/SI0RD+CYjyeVwZ5xdwrySw==
X-Gm-Gg: ASbGncsmTyjFJN3RXH26jH2klC/y4MXSzzJYBBQbUi0+rs791vM3TP0nADFeasGRtlO
	uQBQoWyQjNNU0+2hCGTN9hKQPYCdRBuWZh9gfNdYd5r+XfQTzuQ0otrBoFtV+Fd5w70qMsjXE5i
	73IJ2By/v1CJnEctB/ghPbQMCMutoxA93ije4m8Y+HRAdVMv1ASCHOBYVHF98TSSlwet9VSRauf
	3IcfjtJMDgiGfGs4t0Q9Zk3gp5IyJrY6msVrWOFYuJU/Krozw==
X-Received: by 2002:ad4:576e:0:b0:6ce:26c3:c6e6 with SMTP id 6a1803df08f44-6d45137a320mr21571336d6.40.1732241492728;
        Thu, 21 Nov 2024 18:11:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzV5VTqMmVWe7TtTxnNt3pCfkC0t6uOXM7iv1ufGpnFtArMOqeHEkUI6z9ExmizFfWkqlNdg==
X-Received: by 2002:ad4:576e:0:b0:6ce:26c3:c6e6 with SMTP id 6a1803df08f44-6d45137a320mr21570996d6.40.1732241492428;
        Thu, 21 Nov 2024 18:11:32 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d451a831edsm4276196d6.10.2024.11.21.18.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 18:11:32 -0800 (PST)
Message-ID: <8e5d5480e7f926329759f41933df0d59185cf1e4.camel@redhat.com>
Subject: Re: [PATCH v2 44/49] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 21 Nov 2024 21:11:30 -0500
In-Reply-To: <ZuG6LqLA6tGw9Edi@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-45-seanjc@google.com>
	 <2d554577722d30605ecd0f920f4777129fff3951.camel@redhat.com>
	 <ZoyDTJ3nb_MQ38nW@google.com>
	 <b9cf0083783b32fd92edb4805a20a843a09af6fc.camel@redhat.com>
	 <ZuG6LqLA6tGw9Edi@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-09-11 at 08:41 -0700, Sean Christopherson wrote:
> On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> > On Mon, 2024-07-08 at 17:24 -0700, Sean Christopherson wrote:
> > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > > > -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> > > > > -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > > > +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
> > > > > +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > > > +
> > > > >  
> > > > >  	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
> > > > >  	if (best)
> > > > 
> > > > I am not 100% sure that we need to do this.
> > > > 
> > > > Runtime cpuid changes are a hack that Intel did back then, due to various
> > > > reasons, These changes don't really change the feature set that CPU supports,
> > > > but merly as you like to say 'massage' the output of the CPUID instruction to
> > > > make the unmodified OS happy usually.
> > > > 
> > > > Thus it feels to me that CPU caps should not include the dynamic features,
> > > > and neither KVM should use the value of these as a source for truth, but
> > > > rather the underlying source of the truth (e.g CR4).
> > > > 
> > > > But if you insist, I don't really have a very strong reason to object this.
> > > 
> > > FWIW, I think I agree that CR4 should be the source of truth, but it's largely a
> > > moot point because KVM doesn't actually check OSXSAVE or OSPKE, as KVM never
> > > emulates the relevant instructions.  So for those, it's indeed not strictly
> > > necessary.
> > > 
> > > Unfortunately, KVM has established ABI for checking X86_FEATURE_MWAIT when
> > > "emulating" MONITOR and MWAIT, i.e. KVM can't use vcpu->arch.ia32_misc_enable_msr
> > > as the source of truth.
> > 
> > Can you elaborate on this? Can you give me an example of the ABI?
> 
> Writes to MSR_IA32_MISC_ENABLE are guarded with a quirk:
> 
> 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
> 		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
> 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> 				return 1;
> 			vcpu->arch.ia32_misc_enable_msr = data;
> 			kvm_update_cpuid_runtime(vcpu);
> 		} else {
> 			vcpu->arch.ia32_misc_enable_msr = data;
> 		}
> 
> as is enforcement of #UD on MONITOR/MWAIT.
> 
>   static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
>   {
> 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
> 		return kvm_handle_invalid_op(vcpu);
> 
> 	pr_warn_once("%s instruction emulated as NOP!\n", insn);
> 	return kvm_emulate_as_nop(vcpu);
>   }
> 
> If KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is enabled but KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS
> is _disabled_, then KVM's ABI is to honor X86_FEATURE_MWAIT regardless of what
> is in vcpu->arch.ia32_misc_enable_msr (because userspace owns X86_FEATURE_MWAIT
> in that scenario).
> 

OK, makes sense.
Best regards,
	Maxim Levitsky



