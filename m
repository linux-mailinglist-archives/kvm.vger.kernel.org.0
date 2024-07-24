Return-Path: <kvm+bounces-22189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FD193B65B
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16B361F22C90
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A3116B386;
	Wed, 24 Jul 2024 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g0n6qxhy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5A1662FA
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844007; cv=none; b=FaVWy2EXLjT2HmCoHASQHudX3twFfrgqg/Z0iQOhKcwFawE/zE7Eu2tuKY57ep5CFC7c+zVjo4gng100ogZ/8P3/lk24y4EYx76u3s/rsAvEhtvJeGDVFZE0q6mhcXXPspjeHzns826HgNpB2tsT8oSxjM6EtGG0w9F5XZ/xkNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844007; c=relaxed/simple;
	bh=wi4PVMj/RylII+kfp9JvNJ0g3isAzxZ36/+o7Gw4c2s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mluaEtOzH93NaIMpmBapbNxAsrIYyfs0UKERV/bjD+KF7nR1tmXyC4Sk4gu+ro9mMEYzxLpnrDbG/mnj6wmMgQSQLBDRG7XevZ4tYmUfl9feWFDSmct7/3bH6wUkkYfKjzy4V+cpipEnpsug/65C91Zjo1JLjzZLtVqhmVscVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g0n6qxhy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OUhs1zi8/K2uHCURlex7Z0IBPujaiiqC2g0oUiZ4EtY=;
	b=g0n6qxhyYLJ4msc7DEs2/2z++V4ksCtohyCI7QmLczr3wHb1B4GVI2PrOToq1ynFXLtMkR
	F3R2gOa64flF0V0U1fQG1yE5pa2q8Xbp9V9nrTX/80cDdFxcGsnu3Z8tR/TwEiuDR8EXTo
	mRX52jV5VpcUIcT4EFTeoA7tBSmpjGo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-h0nuLGIlO76m1rLowUwKEg-1; Wed, 24 Jul 2024 14:00:03 -0400
X-MC-Unique: h0nuLGIlO76m1rLowUwKEg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b7b3ed86ccso1148186d6.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844003; x=1722448803;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OUhs1zi8/K2uHCURlex7Z0IBPujaiiqC2g0oUiZ4EtY=;
        b=Egx4G8934pL/xfQKXlEW6+qN3Y++uqc0RCLC8JOjijA96IY8w6ovJU1oHo7nE/iXbt
         mmKh+dsob6euqxqqWUzjZyCphlC5zCARjuc6igYTOxO5pvpgUjNmggPmy0jbELPpc16x
         Fz3UIykCPWiSPX4VcCy8xdtJi0BcuiBar3vNySqLvcabva+sskeLLPrFLn+4r1d6ToKa
         rbAOJcj/5MNqlTSb723XU+9GZKEOMqdS8RM1L5C3dR//qWB9A0n8UNOMvD/0rzMm9ACx
         TMF+JdIyxib2XAykBz/lYm9BwwMXFB+TdqxZrEMiR+wJVxAqZIsHcxS3c+eqO0fcPq2R
         vIWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6EuG9JOVVxz4X7UGRaoCAYDWe01WqVweaSZ/TnB/7OvEL2Zarv5IgtKY9ozI5ZenAHlUYBgqa+RXzklhpokZm/lGS
X-Gm-Message-State: AOJu0YwjbYPlQpsraYLf1Cg8lQW3pvMF1dRgezvjv54pGy3+vaqKffwj
	50ChudlBjbBG+I+rABZ0XG3BieR+ABOkhOH73mS7cSir8lkIzdfvP/5/TM1+FgQZDhhd6kw5B4K
	PK8BFyyOHql169NLyVxSeyPYzx3UVwZv0SywpN7hr8dwjhW31jg==
X-Received: by 2002:ad4:5f4e:0:b0:6b0:7f0c:d30e with SMTP id 6a1803df08f44-6bb3c9cf607mr5057126d6.10.1721844002959;
        Wed, 24 Jul 2024 11:00:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFV5ZeOzeO98y/PIGai+ELZySp2k2TXNjwAGQ61vgRr5QwqvMpKKDJO87IqdHpG0qrm2UACvQ==
X-Received: by 2002:ad4:5f4e:0:b0:6b0:7f0c:d30e with SMTP id 6a1803df08f44-6bb3c9cf607mr5056596d6.10.1721844002640;
        Wed, 24 Jul 2024 11:00:02 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7dc47esm60141676d6.43.2024.07.24.11.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:00:02 -0700 (PDT)
Message-ID: <f6e5e836b356c4f852e9191d4eea283ff9534b09.camel@redhat.com>
Subject: Re: [PATCH v2 33/49] KVM: x86: Advertise TSC_DEADLINE_TIMER in
 KVM_GET_SUPPORTED_CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 14:00:01 -0400
In-Reply-To: <Zo2PRdv1KMf_Mgwj@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-34-seanjc@google.com>
	 <924352564a5ab003b85bf7e2ee422907f9951e26.camel@redhat.com>
	 <Zo2PRdv1KMf_Mgwj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 12:28 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > >  4.47 KVM_PPC_GET_PVINFO
> > >  -----------------------
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 699ce4261e9c..d1f427284ccc 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -680,8 +680,8 @@ void kvm_set_cpu_caps(void)
> > >  		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
> > >  		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> > >  		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
> > > -		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> > > -		F(F16C) | F(RDRAND)
> > > +		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
> > > +		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND)
> > >  	);
> > >  
> > >  	kvm_cpu_cap_init(CPUID_1_EDX,
> > 
> > Hi,
> > 
> > I have a mixed feeling about this.
> > 
> > First of all KVM_GET_SUPPORTED_CPUID documentation explicitly states that it
> > returns bits that are supported in *default* configuration TSC_DEADLINE_TIMER
> > and arguably X2APIC are only supported after enabling various caps, e.g not
> > default configuration.
> 
> Another side topic, in the near future, I think we should push to make an in-kernel
> local APIC a hard requirement. 

I vote yes, with my both hands for this, but I am sure that this will for sure break at least some
userspace and/or some misconfigured qemu instances.

>  AFAIK, userspace local APIC gets no meaningful
> test coverage, and IIRC we have known bugs where a userspace APIC doesn't work
> as it should, e.g. commit 6550c4df7e50 ("KVM: nVMX: Fix interrupt window request
> with "Acknowledge interrupt on exit"").
> 
> > However, since X2APIC also in KVM_GET_SUPPORTED_CPUID (also wrongly IMHO),
> > for consistency it does make sense to add TSC_DEADLINE_TIMER as well.
> > 
> > I do think that we need at least to update the documentation of KVM_GET_SUPPORTED_CPUID
> > and KVM_GET_EMULATED_CPUID, as I state in a review of a later patch.
> 
> +1
> 


Best regards,
	Maxim Levitsky


