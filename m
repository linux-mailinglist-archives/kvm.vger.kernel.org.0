Return-Path: <kvm+bounces-18243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 495E08D283B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 00:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD6F81F27505
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 22:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8503B13E41D;
	Tue, 28 May 2024 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6idNiH3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7FD13D8BF
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936635; cv=none; b=XxQyEkYzuZprNeaDMPhLG5NDT4C0jVolXl182ZBURiWQS8OvEGFdmXdeFQw51S6a4/hUA/JCMPNTQmIArmyjfRxUhO0dvoUCrP74wGv5dhF3a7oQJQkyjtrM4YTFJkij5AVlvElj8+yLa2U9e0v6Sb6BGReFVgFFHEAOE2duGj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936635; c=relaxed/simple;
	bh=gHbpfeSgkDfVxwkYwenrZjhrUWC3V/PMjbQDgO81FQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dTjt5DMHOo+HELVI0LKyOJcc8egP2c2Sbbl1/Hn/XXCKzm5JPGKyZtRkSQyinzHRQCxyPTTIZnHN5jYfAuT105dY1ltxXlv52oqK4hML2AOCxb/N4/nrMZTBRdZXDTqIqhchNpDLneR35D1yy3wV/07uULTUV0AigAIKVba852g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L6idNiH3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ff8fcf5aabso202750b3a.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 15:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716936634; x=1717541434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTOH3e/EfW+pY1lF/i3FXaQ/pSIJmaxop4NhBeQiFYU=;
        b=L6idNiH37diLwjehmgo9dJ6wWrSW9rJ7seR9p+j2RMPPcVAX75e8svzoPFzRna/t51
         KM1vC5iBhZ4RAhXLnsSBdGjfXet+EZG015rWVYzs5ASva4MBXrpDfExe12GHKbX4S2rP
         fLYaICQw2lb5QdqTMVtzZGzZuj6GSzmw623mGTQDRWiHj/cKEICImwwpeO5sqoI2XFJR
         ptTr/CsuTKWuIXgiqra0KGnGHTqaKJiVCtLJ0nIVhv4v2xo5qno0f8uMmSbcl5RmNW3b
         1LkRaeEogfnX03hk4Y0yPC09gXOj9DTqf9jbp2tSyfyXfSs9sFIEkFRv3yOxKkPz2PDf
         a8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716936634; x=1717541434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTOH3e/EfW+pY1lF/i3FXaQ/pSIJmaxop4NhBeQiFYU=;
        b=iRWqi897GFVtc5y98FBIOV4HtYwTkp7Q1U1NCr/DtszpeWIXPuAC8jO5vh8zr7b/vc
         pIkFf5vtNkTRqw19dS2ugu1p4jnEq9x1nFwGEyNqETU+NflzksVb9ofVI5ZutosdMrsl
         kV0Co8NYq2WhiipCkVzZ84lEzcI0LtQl52XTeoAtGSEqlk5v17V8zyf+uA3z3RAx7bTq
         tNLximM/JnbAa2B5FqCqwIFhCq4Dw+MtKrCwIHYKvr09kv9+K/u0aSzbafEEmA7fB5j1
         SEFQww5c3uZTQ9sqqRJuJ9cUyy/5/tqIFTUQpHmPTiFHJTi8lR5/n7AxqNKXc5cIINLK
         XVFg==
X-Forwarded-Encrypted: i=1; AJvYcCXYS4jmhtKsJQHUpLsFuHgqMHZRaCFA9RQXiWY1HhzTaD6ktgU9Iwat3ZqqnqJIynC5x6ZB+CY3XYyyvlLLG0+KNbou
X-Gm-Message-State: AOJu0YwfAw7dD9hxgbCdz4EQIymf08jD7SkPtOkV82oxfumwnch4XD5J
	OM5yEpynXFMIrsS6Vclj3Gs0dg6q1sv/0fD57jPoYR+8SHc04fgqfCPFyL6UqtqxWBGdJudkjoV
	VoA==
X-Google-Smtp-Source: AGHT+IE3ANcFSo4euu0zbXpca3MbcUJ+ZlvRED7hUs1VWjND6y66XDhsptVuXUjsU+9B6EI4YXgVUsKh6U8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:28cf:b0:6ea:df4b:86d0 with SMTP id
 d2e1a72fcca58-7020306b721mr1477b3a.2.1716936633742; Tue, 28 May 2024 15:50:33
 -0700 (PDT)
Date: Tue, 28 May 2024 15:50:32 -0700
In-Reply-To: <2d873eb4-67d2-446d-8208-a43a4a8aba14@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com> <20240522022827.1690416-5-seanjc@google.com>
 <2d873eb4-67d2-446d-8208-a43a4a8aba14@intel.com>
Message-ID: <ZlZfuCI77O9wmHh0@google.com>
Subject: Re: [PATCH v2 4/6] KVM: Add arch hooks for enabling/disabling virtualization
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 23, 2024, Kai Huang wrote:
> On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> >   static int __kvm_enable_virtualization(void)
> >   {
> >   	if (__this_cpu_read(hardware_enabled))
> > @@ -5604,6 +5614,8 @@ static int kvm_enable_virtualization(void)
> >   	if (kvm_usage_count++)
> >   		return 0;
> > +	kvm_arch_enable_virtualization();
> > +
> >   	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> >   			      kvm_online_cpu, kvm_offline_cpu);
> 
> 
> Nit:  is kvm_arch_pre_enable_virtualization() a better name?

Hmm, yes?  I don't have a strong preference either way.  I did consider a more
verbose name, but omitted the "pre" because the hook is called only on the 0=>1
transition of kvm_usage_count, and for some reason that made me think "pre" would
be confusing.

On the other hand, "pre" very clearly communicates that the hook is invoked,
and _needs_ to be invoked (for x86), before KVM enables virtualization.

So I'm leaning towards kvm_arch_pre_enable_virtualization().

Anyone else have an opinion?

