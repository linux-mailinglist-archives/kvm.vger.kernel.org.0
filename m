Return-Path: <kvm+bounces-39055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC3DA43029
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD7101892024
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EF2207A2D;
	Mon, 24 Feb 2025 22:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tLCG/Uhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC077469D
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 22:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740436359; cv=none; b=lUsbuw9hLRqLpAqm8W1MVdEOYpiPYfnJiB55gD3CEl92AK6JWhQxA9AemsDL63aisvLt0F+GrjG04cnaNJD1O75zpfCdnUohV5cD1HnWP2WxOTGbCB12Ahigll7xMrsPu771FLmNHXCjcNToQ2qg8Rx35tYTzB+7ixnY0x6YVjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740436359; c=relaxed/simple;
	bh=lR5+K2O0C7fa3hblXHm0+cUXI+NHjy4Oog7sgRxfZDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fKTUdobDp5oqh3RbHK9EEtQexEizR2fnkTb2RlWIaSJqdQ5TBxBpk3c9i0wsqcd7RFv2pVj8TOagJCUYyjsuvpIAntE8JdVqmX0h1HU1TgBTvapy05bzFZhaUZ1llh0Ld754V3fJl+zDq8qiY/5ho0CfIe4Me/h/Fwi5T979TbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tLCG/Uhd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2210305535bso163449775ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 14:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740436356; x=1741041156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJ602F89Qrv98s0dTpyvrapFlWCXZ4Q+ukdN0YogNYc=;
        b=tLCG/UhdftbDpTzcxPLk+q3MhOnF0jbS5KzVBsWCsPtq6XpjxbDfEfSDeX081pBW0Y
         tq8g/IIqVqpg3GZa3x41efGjPXppBXxEkonn1BjIffkSItuVqACahhemD17rQy3nJ65H
         kNMZxTEmQpBtwn8fxxtpqxPHnJjTR4uaU+jjZ3svRXCCUsplGHJsovSIczOTJmUapjEW
         Nyv6iUABFlQP+deJVqoZiT2+9wLXtQxG4DfcLXUVlft6bJuXD6sb/iopU+CqsQevDuPz
         C3GSStgQdMcQ2PtYn7cFMXGB2/eIB0In/s1Ksd7LY8K2otZWrmu3mbxZHhzKqaDxOe3G
         bgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740436356; x=1741041156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJ602F89Qrv98s0dTpyvrapFlWCXZ4Q+ukdN0YogNYc=;
        b=tXZRV9z+ypz36RhOh7RjoegCCakEy4RKPed4lOGJgglVrzFLoojg+8gbEq0vRtaUJp
         ze/OfRtPGSBl5NU1q3Q2u6A2fnu7Gv/BI/lTzWE0WbpLdvia4IsLdeQ94c2+VYeKiAIN
         CM4J7MS3n9rh/0e85C0Wtpe4VJRzM+A6ejX10iewe8hvuJr1QZwlgbs0y3mkzGBI9h/A
         W76CMkOw6KDqOeVmx0p1mB21ZcNR3vJGFytZEHttzM6qrXNfq+OglhnD7qZoHOnNho1n
         L73R3ZtFo8ArC+EKwJsbUghJiDsy2TU6FUkIywA4Bls2KLMpfteHf7BXJPqSB0i0pcil
         3yrA==
X-Forwarded-Encrypted: i=1; AJvYcCW000JaMjxDowUmzOdXQ/4ThqSPkFJAYAPpeIRs4p6Iv+HGKOWMTnR8e3W89qs4UNXb7D0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyqwBvHhHzU8n+XUyS6ATtQlWohLLCWPyhSXK+1GAHJ6rcasE8
	dsH3lJpNJbXpnQzwmTEllEd+szlU8V9iBnPN1d0GsvyPPITu4fucjJrn7X0dqM33q4MOi/POABY
	baQ==
X-Google-Smtp-Source: AGHT+IFqOEUKQsuWHVPpQJ0lKf4SviNWdzaOb6PyYguj4zrO83Ubft771/46kQy1zz7pRXushkp2tdi5FeE=
X-Received: from pjyp12.prod.google.com ([2002:a17:90a:e70c:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0f:b0:21f:52e:939e
 with SMTP id d9443c01a7336-221a10deb2amr283318145ad.28.1740436356245; Mon, 24
 Feb 2025 14:32:36 -0800 (PST)
Date: Mon, 24 Feb 2025 14:32:34 -0800
In-Reply-To: <7794af2d-b3c2-e1f2-6a55-ecd58a1fcc77@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com> <20250219012705.1495231-3-seanjc@google.com>
 <7794af2d-b3c2-e1f2-6a55-ecd58a1fcc77@amd.com>
Message-ID: <Z7zzgtS-iu0YHwia@google.com>
Subject: Re: [PATCH 02/10] KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Tom Lendacky wrote:
> On 2/18/25 19:26, Sean Christopherson wrote:
> > Never rely on the CPU to restore/load host DR0..DR3 values, even if the
> > CPU supports DebugSwap, as there are no guarantees that SNP guests will
> > actually enable DebugSwap on APs.  E.g. if KVM were to rely on the CPU to
> > load DR0..DR3 and skipped them during hw_breakpoint_restore(), KVM would
> > run with clobbered-to-zero DRs if an SNP guest created APs without
> > DebugSwap enabled.
> > 
> > Update the comment to explain the dangers, and hopefully prevent breaking
> > KVM in the future.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> See comment below about the Type-A vs Type-B thing, but functionally:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> > ---
> >  arch/x86/kvm/svm/sev.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index e3606d072735..6c6d45e13858 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -4594,18 +4594,21 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
> >  	/*
> >  	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
> >  	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
> > -	 * saves and loads debug registers (Type-A).  Sadly, on CPUs without
> > -	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
> > -	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create",
> > -	 * and so KVM must save DRs if DebugSwap is supported to prevent DRs
> > -	 * from being clobbered by a misbehaving guest.
> > +	 * saves and loads debug registers (Type-A).  Sadly, KVM can't prevent
> 
> This mention of Type-A was bothering me, so I did some investigation on
> this. If DebugSwap (DebugVirtualization in the latest APM) is
> disabled/unsupported, DR0-3 and DR0-3 Mask registers are left alone and
> the guest sees the host values, they are not fully restored and fully
> saved. When DebugVirtualization is enabled, at that point the registers
> become Type-B.

Good catch.  I completely glossed over that; I'm pretty sure my subconcious simply
rejected that statement as wrong.

> I'm not sure whether it is best to update the comment here or in the
> first patch.

Probably first patch.

