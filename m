Return-Path: <kvm+bounces-30989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBCC9BF225
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 001BA285795
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4594206509;
	Wed,  6 Nov 2024 15:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWZ82qCz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D5203709
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730908113; cv=none; b=bKRblPLhVnZEjO/uIfOfttS9+b+4/15mgPI05GZXdYfOZotVQh7NYDzCdUEEVtri6DTwfX09qbOSa/kRUhybsdkQIz89tJHD2erGDpR8YVKNW2fOINDrgDQ/AC+l8mUsJkb2IEYWlJm6PWC/+mAK8DuoD0eJcrny16KWiYAgOGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730908113; c=relaxed/simple;
	bh=fwsEXJjtk8v0ISoRS2Z75zjkgFCesWiBtSDZ1C9QZSI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g1vlpA6mieW6rdI5bBjLsQJVLCxDAkHOuGJSAtw3uZE29TscI4VMCgD/F8LofY5OxKw+5qefOXVmjGUxKmJvC3JMA6kGVDiSjE6psG+dVNPENl4pAV3MxkqzkZMsBKw1REtzS1LCk6kt1lxnlNoZ08mHEh2oIsUL2ImWgZOR7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWZ82qCz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730908111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TKm7nv8/Q2P9LN6MBqoOnvkypFeePmRShgUBE1FwNVU=;
	b=HWZ82qCzhJ7a+6QO2acK47d349xSDE94aIIt0pRubUBpQddGk1hrgRLZgvmIEcyUE4X8Fk
	Zq7WTxY785iejxu/FFQZ1i3VLcwBZvAq4uqsFgf3NysxwFIpCWlxfY6fh+fE0LGFt21aJL
	RQy8/QA7A81A1z9aRGp/oDEHTiw/ddY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-ak7FkaQFPka5NXn2DRNuqw-1; Wed, 06 Nov 2024 10:48:29 -0500
X-MC-Unique: ak7FkaQFPka5NXn2DRNuqw-1
X-Mimecast-MFC-AGG-ID: ak7FkaQFPka5NXn2DRNuqw
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-460bfa9ff3dso112188251cf.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730908109; x=1731512909;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKm7nv8/Q2P9LN6MBqoOnvkypFeePmRShgUBE1FwNVU=;
        b=vbFrsfhZ//Y2fBLbkPals8l6bX/mPaOdy3E8rfFCLJ1UQEUUwihY7ZCvrODeNb9AxM
         sfY3hPpsCCPDbeNEhJvpDErXNpAvAqtXfqGlgu81NVvLVXilxpkZ6CuK1lOeyQYvRkwk
         fv213PA0e6/l2Yk4U6nKO9BaL9ppiN6LWJGxzc3jPqx343tSJdTXgvNMfX7s5yiafafu
         tf7r7/ogsioR+CtV6yfOtLaqNqbvh4qH6+TcazARUocBh/QuBda5ADasrsGHRjihv6/Q
         AolXixPM/r8j8uQ/eZmUe4VQmSuNkPWjgOTuN5LwNDdY9MELSe1p40R+H2RKelrMm9EB
         TuWw==
X-Forwarded-Encrypted: i=1; AJvYcCWv06E724ZJvdXE/l+11asMkhWQc+IapW1tcFu/N+ref9Ew7sB6GszzCucg/yDmxV2mP7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiR8rWkJIE4cQVR9fSkv/IEMASoCz0yYy/ALxy4tZFk8sWn5hL
	Ki7C030XaPEFHL0EiCydSK8smFCYq4zLVCsJ+d6ZzCWMS34s1RbZzEG7EuiDyBb4ijLYRMUnsgt
	HoigZWkY/m8wrLa/GH6jRosDTF8rNGu/a8hM7fF3ykLn/1OBkeA==
X-Received: by 2002:a05:622a:1a8f:b0:461:202:d5e5 with SMTP id d75a77b69052e-461717909dfmr354594201cf.44.1730908109450;
        Wed, 06 Nov 2024 07:48:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHudpKfshd1qVEmNsmDvLw8euPsBPDQNHzlIk8BTNmJOEfsn+u/beosLqzi1o+WrcmKfj+JCQ==
X-Received: by 2002:a05:622a:1a8f:b0:461:202:d5e5 with SMTP id d75a77b69052e-461717909dfmr354593821cf.44.1730908109053;
        Wed, 06 Nov 2024 07:48:29 -0800 (PST)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ad0a004asm72460341cf.23.2024.11.06.07.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 07:48:28 -0800 (PST)
Message-ID: <37b73861cb86508a337b299a5ae77ab875638fe4.camel@redhat.com>
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4
 client
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Mario Limonciello
	 <superm1@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H .
 Peter Anvin" <hpa@zytor.com>, Nikolay Borisov <nik.borisov@suse.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>, Mario Limonciello
 <mario.limonciello@amd.com>,  kvm@vger.kernel.org
Date: Wed, 06 Nov 2024 10:48:27 -0500
In-Reply-To: <ZyuIINwBdiztWhi3@google.com>
References: <20241105160234.1300702-1-superm1@kernel.org>
	 <ZyuFMtYSneOFrsvs@google.com>
	 <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
	 <ZyuIINwBdiztWhi3@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-11-06 at 07:15 -0800, Sean Christopherson wrote:
> On Wed, Nov 06, 2024, Mario Limonciello wrote:
> > On 11/6/2024 09:03, Sean Christopherson wrote:
> > > +KVM, given that this quite obviously affects KVM...
> > > 
> > > On Tue, Nov 05, 2024, Mario Limonciello wrote:
> > > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > > 
> > > > A number of Zen4 client SoCs advertise the ability to use virtualized
> > > > VMLOAD/VMSAVE, but using these instructions is reported to be a cause
> > > > of a random host reboot.
> > > > 
> > > > These instructions aren't intended to be advertised on Zen4 client
> > > > so clear the capability.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
> > > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > > ---
> > > >   arch/x86/kernel/cpu/amd.c | 11 +++++++++++
> > > >   1 file changed, 11 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > > index 015971adadfc7..ecd42c2b3242e 100644
> > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > @@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
> > > >   {
> > > >   	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
> > > >   		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
> > > > +
> > > > +	/*
> > > > +	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
> > > > +	 * in some BIOS versions but they can lead to random host reboots.
> > > 
> > > Uh, CPU bug?  Erratum?
> > 
> > BIOS bug.  Those shouldn't have been advertised.

Hi!

My question is, why would AMD drop support intentionally for VLS on client machines?

I understand that there might be a errata, and I don't object disabling the
feature because of this.

But hearing that 'These instructions aren't intended to be advertised' means that
AMD intends to stop supporting virtualization on client systems or at least partially
do so.

That worries me. So far AMD was much better that Intel supporting most of the
features across all of the systems which is very helpful in various scenarios,
and this is very appreciated by the community.

Speaking strictly personally here, as a AMD fan.

Best regards,
	Maxim Levitsky


> 
> Why not?  "but they can lead to random host reboots" is a description of the
> symptom, not an explanation for why KVM is unable to use a feature that is
> apparently support by the CPU.
> 
> And if the CPU doesn't actually support virtualized VMLOAD/VMSAVE, then this is
> a much bigger problem, because it means KVM is effectively giving the guest read
> and write access to all of host memory.
> 



