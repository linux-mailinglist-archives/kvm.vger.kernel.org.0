Return-Path: <kvm+bounces-16190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0F28B6334
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 22:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8658D2816BF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 20:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4BA1411F0;
	Mon, 29 Apr 2024 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4M3XXzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE751411C9
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 20:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421216; cv=none; b=EcVwXaxGTfIYeEBw7j4Ed3jvBStBXZlNgAYWmMx2rjhqdytRbem4Fnh/wIyWkBOXrc+EpGER1dIVB4VqQow/RRNiQNFlRoiIwvbuNPEBWBzzBT534MgnXuNZBEbbzH4HdrIdKTemb28mYawBcsM9eaYoAbb+oXXxdRDbFshPiZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421216; c=relaxed/simple;
	bh=ZQkpSdpmt4mYDJwdDVa8RfLmPSrJrAufaXCOysNf5gk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UBR/DCrYqEFPeW+Ptoqg6f1YRxGQTJswX1uswlsreRA0AhMSUuBbAMlAbwHSEfHmf7Qe5Kva+BHURRWSyKzPYhg9L3AgZF0hdckC8vgo/N70JBjdDkMdLABrm7rEXupuQKVvzMbyjssNngmaM+WxIs6lPm0a7ke5Z/KtwQ5fgMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4M3XXzP; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de604d35ec0so1287516276.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714421214; x=1715026014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X5r9jrj7lJ8K2c/A/X813S+F4evPMkrfmwuk9AJ2VgE=;
        b=B4M3XXzP2iQXxgSV+N1tdLcL/ldPIxZodk+z9Ek9SwtVBjUFW6+VNMRyK1R/LKqYhR
         6/KTDP0RvVxXm1MLemFV9ktyTwvBaJagz6twaL7B8IowpxNlqe8brVePneBxgasLYX40
         +ME6R8X+skT3ZKPKXSiXtP5euoxxmHFDh/z2GxT1TSm07Il3k7j4MPKg7HPv5hsQNBry
         TU3LsxD4EpXtD61LEo2KGE6DXCORI89Iu1U0pSBthH1nSTaYkC9C/w8M6sjDpKr8Foe5
         Nv+VE6G99Ly9aY0PFYRaTF8JiRkFBLgnXn2AUKQ8Y1GxB+eQgiAyWc5MN3O/ZzqV8ahQ
         5+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714421214; x=1715026014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X5r9jrj7lJ8K2c/A/X813S+F4evPMkrfmwuk9AJ2VgE=;
        b=A8rCjSKXN6TiW8TV0fCv8tDgobysw3yz6Wz3Fq2gzf3KWZBD4Dsz8BLhvfcQ7uPdnz
         EF7a8uFC57XF1wHk7VVTqMLu7wBOJLpdWtR78J9uDd10d4NuIMMwyF0avQPJ56Ir/3dL
         GAgTqo+STS46dgzzJnWzbXlrkqa5BfwyOj1GXNhYN9TyZrNwRNvCfpvcLQXB4M6uhykR
         szSIaqVrJ+w/+QOEllTRTyPWBzLS7MQ+ngu+1UiFJx/NeBwJ92XzKEuegU+8PSBowxvU
         tzvnr8o8K1pfc1Dy+M4qdfGNGBK8rXESOu4eAeSIUh8YEX2MllO6QAV6DWyiiIcMAQup
         N68A==
X-Forwarded-Encrypted: i=1; AJvYcCWdHEqd1nX6MQ/tuwBvyFm0yY2Y2I/NPlONnIoSNTfZtKfkzzKeCwnmHZRuZ9BA/HIcOxZbe2sSMpqubPF3Tl6GGVZr
X-Gm-Message-State: AOJu0YzDbq69KrKVGRPnRrkvxHFzav3r0fHt/17dwSztDu1T8ToPeyDZ
	CncX+62uE5fstazQ62yzDxE5RB1NrnM2QTWU/x1WUaWJy10EJqmMqiECTTNykpQrsp9mVf2K2Pt
	iVw==
X-Google-Smtp-Source: AGHT+IFf8IzkssAjSX9+E+pyZ8b6wCf8T3MVnGnh3lV3JTeTnffbD7Ts+m4DeJyAG04Wpn1kmZbYGRXnX+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c12:b0:dc6:cd85:bcd7 with SMTP id
 fs18-20020a0569020c1200b00dc6cd85bcd7mr3946933ybb.3.1714421214393; Mon, 29
 Apr 2024 13:06:54 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:06:52 -0700
In-Reply-To: <b2bfc0d157929b098dde09b32c9a3af18835ec57.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com> <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
 <ZiqFQ1OSFM4OER3g@google.com> <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
 <Zircphag9i1h-aAK@google.com> <b2bfc0d157929b098dde09b32c9a3af18835ec57.camel@intel.com>
Message-ID: <Zi_93AF1qRapsUOq@google.com>
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

On Mon, Apr 29, 2024, Kai Huang wrote:
> On Thu, 2024-04-25 at 15:43 -0700, Sean Christopherson wrote:
> > > And the odd is currently the common SEAMCALL functions, a.k.a,
> > > __seamcall() and seamcall() (the latter is a mocro actually), both return
> > > u64, so if we want to have such CR4.VMX check code in the common code, we
> > > need to invent a new error code for it.
> > 
> > Oh, I wasn't thinking that we'd check CR4.VMXE before *every* SEAMCALL, just
> > before the TDH.SYS.LP.INIT call, i.e. before the one that is most likely to fail
> > due to a software bug that results in the CPU not doing VMXON before enabling
> > TDX.
> > 
> > Again, my intent is to add a simple, cheap, and targeted sanity check to help
> > deal with potential failures in code that historically has been less than rock
> > solid, and in function that has a big fat assumption that the caller has done
> > VMXON on the CPU.
> 
> I see.
> 
> (To be fair, personally I don't recall that we ever had any bug due to
> "cpu not in post-VMXON before SEAMCALL", but maybe it's just me. :-).)
> 
> But if tdx_enable() doesn't call tdx_cpu_enable() internally, then we will
> have two functions need to handle.

Why?  I assume there will be exactly one caller of TDH.SYS.LP.INIT.

> For tdx_enable(), given it's still good idea to disable CPU hotplug around
> it, we can still do some check for all online cpus at the beginning, like:
> 
> 	on_each_cpu(check_cr4_vmx(), &err, 1);

If it gets to that point, just omit the check.  I really think you're making much
ado about nothing.  My suggestion is essentially "throw in a CR4.VMXE check before
TDH.SYS.LP.INIT if it's easy".  If it's not easy for some reason, then don't do
it.

> Btw, please also see my last reply to Chao why I don't like calling
> tdx_cpu_enable() inside tdx_enable():
> 
> https://lore.kernel.org/lkml/1fd17c931d5c2effcf1105b63deac8e3fb1664bc.camel@intel.com/
> 
> That being said, I can try to add additional patch(es) to do CR4.VMX check
> if you want, but personally I found hard to have a strong justification to
> do so.
> 

