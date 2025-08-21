Return-Path: <kvm+bounces-55403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E170EB3081F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B9EA1882CE0
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF28726F2BF;
	Thu, 21 Aug 2025 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wtUK/Gpi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775DE1BFE00
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810676; cv=none; b=ivi1w4C5xUA3l7YDJS67nZ/DUL7i+uqVMUrtE9GhXgpbw/DZbfb6hQb8mr1mO7CttRqACMM7x+cGBlals+MnXO/2Zt+4P16/HGHoGnd7tkqFQsDjZ2KtI98AKFXUHawnqpxZXoRXxjLOd6wuFXExaVjQDKywLjbXzQWCbB+swck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810676; c=relaxed/simple;
	bh=yAe6WKMNOAPLqG6uE3wI/PcBPJRugF3nwDNw2Cck6gE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VUJ7W0MzWsXv0iH7B2UuPtZFxV+LvC1cJJlvo1/Go38L9XIK7hWHsn11UFB6ffcLj0bSh6Lslauhdzh0yhMPut7wTsochjJMhMRkMk5ON/2AB0e1DNgzsUEU9ff/JUZC19dkjGcAb/OeC0T0wGRQIed9i38spEfDc/UtkkPHlis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wtUK/Gpi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-324e6a1a414so2233122a91.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810675; x=1756415475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2kTOmJET5CY2YmXsSJN5Ri4cRLSNJeepYuftRiHpt+w=;
        b=wtUK/GpiGdmY32K4hrojzioJ+ZFZofdUWaKzsxmXySizhGyQjJgnqYWz4Dr1K73x29
         rqCS3Yo3SeNwmqJjvkGHDl2CC8m3FOsU6ZVEPVtdNM6oTRpKY7vk7oPolY3EtEvZw0cY
         ZkmdqBcYTcwV6a8hqSO6HXzUg0LVPZDccKRbQpbq9/gN5ptRUGr+hKdPfsjKIcRtsBUv
         S7A4ynqAg9TycyEtoURg3Q5K3c8pJP+Wq14A0xUqx+8uCvJsEUuW3qQ/2kOXdHZzeEqV
         gvj692HdhzaCnXx3SMz/bA8TaVb+nYBeJbUJucB+kqZjvMBL92GdFp6UcsfBtqdG6Bu7
         OiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810675; x=1756415475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2kTOmJET5CY2YmXsSJN5Ri4cRLSNJeepYuftRiHpt+w=;
        b=flxTTBCPnds6EPDGjhv92Z7f8nZYLyBroKajJcD/y1UFbtSKwHqeNyFzxZhPpfKal4
         kalVRmjqXPxfpGi/NiCkokN/9Lgg+4VD51zV6My6Raxc7d9Tbkhp8OIM0A4iNaakmok7
         sWhxqkzzlJBRE6lHCIaOPom31k1EqiqEhlbAp7a6XkOMLYOXT+TZrAD0DNgbYRZzOgZY
         gXeWWkJxoevT+PLW0CRdxzp6k+iX7QnlG5KmA05IE81ydc42HDIQp4fmj0j/hNAWNuze
         I+xcTAhqsexUIyh/mhksxpgNV8GiSpYfMBHRUzhW3/gBtvLsyMuDJki4tiydB7uHQfR/
         ufHA==
X-Forwarded-Encrypted: i=1; AJvYcCWPUjpKuPvahZQVZOQ2TZZ6wAeMfwGjjtKuyRBFh5LcmP2W2ZSpOIFB1laOkcTTMjhY0oY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9sSHP8XpLYoDopW+7oaGPmY2bmoCYd4TWKCDKQtlb0eea8Zo2
	1/xheT5FBJJALHb75VAtrZpcbUgDXW04Bm/f2bJvVp/woBt/pTZd5zZ2cMjScKXnxlLYlig7oLo
	gFWsVRg==
X-Google-Smtp-Source: AGHT+IHEBA3GX5sk2NVlCt/kXBe2DuoCt3ExblCPGoicFR+vSF6LiicZfWBUHCZym6cU7+QlSR845MMN0V4=
X-Received: from pjbmf6.prod.google.com ([2002:a17:90b:1846:b0:321:a6cc:51c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d406:b0:311:be43:f09a
 with SMTP id 98e67ed59e1d1-3251d543a09mr684667a91.9.1755810674699; Thu, 21
 Aug 2025 14:11:14 -0700 (PDT)
Date: Thu, 21 Aug 2025 14:11:13 -0700
In-Reply-To: <1f63036c-a72a-47bf-a75f-23ca7fd3b7cf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
 <zeavh4vqorbuq23664til6hww6yafm4lniu4dm32ii33hyszvq@5byejwk3bom3>
 <275b4fa3-9675-4953-8766-c6cd4e5f0d57@maciej.szmigiero.name> <1f63036c-a72a-47bf-a75f-23ca7fd3b7cf@oracle.com>
Message-ID: <aKeLcU5SoCt41RFY@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix missing LAPIC TPR sync into VMCB::V_TPR
 with AVIC on
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, Naveen N Rao <naveen@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 21, 2025, Alejandro Jimenez wrote:
> On 8/21/25 7:42 AM, Maciej S. Szmigiero wrote:
> > On 21.08.2025 10:18, Naveen N Rao wrote:
> > > > Yes, this breaks real guests when AVIC is enabled.
> > > > Specifically, the one OS that sometimes needs different handling and its
> > > > name begins with letter 'W'.
> > > 
> > > Indeed, Linux does not use TPR AFAIK.
> 
> I believe it does, 

Heh, yes, Linux technically "uses" the TPR in that it does a one-time write to
it.  But what Naveen really meant is that Linux doesn't actively use TPR to
manage what IRQs are masked/allowed, whereas Windows heavily uses TPR to do
exactly that.  Specifically, what matters is that Linux doesn't use TPR to _mask_
IRQs, and so clobbering it to '0' on migration is largely benign.

> during the local APIC initialization. When Maciej
> determined the root cause of this issue, I was wondering why we have not
> seen it earlier in Linux. I found that Linux takes a defensive approach and
> drains all pending interrupts during lapic initialization. Essentially, for
> each CPU, Linux will:
> - temporarily disable the Local APIC (via Spurious Int Vector Reg)
> - set the TPR to accept all "regular" interrupts i.e. tpr=0x10
> - drain all pending interrupts in ISR and/or IRR
> - attempt the above draining step a max of 512 times
> - then re-enable APIC and continue initialization
> 
> The relevant code is in setup_local_APIC()
> https://elixir.bootlin.com/linux/v6.16/source/arch/x86/kernel/apic/apic.c#L1533-L1545
> 
> So without Maciej's proposed change, other OSs that are not as resilient
> could also be affected by this issue.
> 
> Alejandro
> 
> > > - Naveen
> > > 
> > 
> > Thanks,
> > Maciej
> > 
> > 
> 

