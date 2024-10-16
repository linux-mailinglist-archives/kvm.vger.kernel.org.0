Return-Path: <kvm+bounces-29031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 502099A1496
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76E231C24C5E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA571D27AF;
	Wed, 16 Oct 2024 21:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="27oK8/Et"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3111BE871
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729112758; cv=none; b=rZCUjQTA73Hh3DDDtBAyumawER0j/OvULwlKs9AWSHzayiZNz9cuYzfB/qni7EYh3QuBEiJStwrad3kqPZZ8PKGYlk2QceeSJMM/y+dMX8CCCrbKvyVccnXDfF7CQX9kG7abyknyYOzChTdqJjSFPebtQnK/l2nVlkR5Rtya7p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729112758; c=relaxed/simple;
	bh=WZW00TKTaoemSd6JPBFYlmG2IMjRqCAXZEuW81RfWK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mHcKqtF0wCKo+8ZBloGxeny2e9XUGwucgkEDaoY/0RDWUa0JP5kJVRAsPvRqPpEfRHxThl7CdAYL4EOjeG5r9EVg4MKsPgpX0AEQlP598RGel8XiYCLSpkPv3KGOdjJDmWs4VZWFzI8RcD8SouDTFpbOnmJDD6/owV1S7mrp4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=27oK8/Et; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e370d76c15so7226957b3.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 14:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729112756; x=1729717556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mc2AnrLM2UF0S090yPZTAZNfP2OSi9FUUhZDFa9DYsQ=;
        b=27oK8/EtXtW51boOw0Cqq/s3jKRw/y/UTqIRPOQT56NKBe8PhHPV4UFfVOB40TKIJg
         yYmIeo53THXgEd1yxIU0/59loj8xno5fElgqlKXh3wT628GKlJyxwoIxJf7Ad45dMXDz
         /Rjbrth3yvQpD9GQJl5X9RO33SSzPurme0PdCn8y6PIqESFIjCfwm+JzRkCeK6jKDgjf
         rZjXyemORb/LvaV9VpBa248iPwm6rfqcGoB71gYmOrWnDb0Bdjexutl2a1cJft/P6FWF
         VsJuOXgQ0Tn1xBHucEhx5Wruc7dX795r/KTyX6+bz6xiHVta9fVV+rEcMXmmDhwGEq8T
         1iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729112756; x=1729717556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mc2AnrLM2UF0S090yPZTAZNfP2OSi9FUUhZDFa9DYsQ=;
        b=HzvMl5knhAxlJKNGO/IGUqWnEsuKhcC/6G3x0vmmOLWN4ebxoxA9nD4mv6t1Z4lpF0
         1sPAIj3S4ewpHuQkyW14iSM1ygrf4fyOgEWzsONjl5YK0QZWe1blK+zRnIUbK4EMzEiy
         3gJaaZy4UyNeAxDhJl4c3jck4ExlYVE9aRCj99Cl/ZyAXXuWF7+Rl5kMUj0ZFOD7Uzgl
         UI9c9dHcC1/HHHDhK8/4eC2yvMdDHQb/prKtv8rFWTJaNjmG6d/c8MC2dkwjR1Yh9Guo
         0OKj0bMe3fdckpkq/VxMhz5OgRtET/OVw4HIShMJAzle9gGN6Il0flIccmzaawY9nc8V
         XNnw==
X-Forwarded-Encrypted: i=1; AJvYcCWbse4nNlGgOEBZ+N8KkTIpfuXtd0//jp2HhSgnx5UURgBGCLtAp6mcT3N0sDfPOL9TJgo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUM/WpYtiIEI43gBH34ZCOw9/donwT043vQHw4MNVZpzQMUHlN
	fRYZwWJobbn0b3fClPGs1TGeEvo/KbUYjiyZ9W7AKE5YyfAF8tj0+HXy9TR8RRc600RPfgHWcW1
	T1g==
X-Google-Smtp-Source: AGHT+IGkf38vmY/wJdMjW1LCURxYE7Ec+J9yr0i/d8iGrua/q+lp0G6QiUUZJgyY0LEomNIZeY0ALfUpKv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:f407:0:b0:e1a:6bf9:aa83 with SMTP id
 3f1490d57ef6-e29782d5fa6mr5916276.3.1729112755243; Wed, 16 Oct 2024 14:05:55
 -0700 (PDT)
Date: Wed, 16 Oct 2024 14:05:53 -0700
In-Reply-To: <20241015195227.GA18617@dev-dsk-iorlov-1b-d2eae488.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927161657.68110-1-iorlov@amazon.com> <20240927161657.68110-2-iorlov@amazon.com>
 <Zwmyzg5WiKKvySS1@google.com> <20241015195227.GA18617@dev-dsk-iorlov-1b-d2eae488.eu-west-1.amazon.com>
Message-ID: <ZxAqscbrROD1_szG@google.com>
Subject: Re: [PATCH 1/3] KVM: x86, vmx: Add function for event delivery error generation
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, jalliste@amazon.com, 
	nh-open-source@amazon.com, pdurrant@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 15, 2024, Ivan Orlov wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index c67e448c6ebd..afd785e7f3a3 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6550,19 +6550,10 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> > >  	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> > >  	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
> > >  	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
> > > -		int ndata = 3;
> > > +		gpa_t gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> > > +		bool is_mmio = exit_reason.basic == EXIT_REASON_EPT_MISCONFIG;
> > 
> > There's no need for is_mmio, just pass INVALID_GPA when the GPA isn't known.
> 
> Ah alright, then we definitely don't need an is_mmio field. I assume we
> can't do MMIO at GPA=0, right?

Wrong :-)

From an architectural perspective, GPA=0 is not special in any way.  E.g. prior
to L1TF, Linux would happily use the page with PFN=0.

