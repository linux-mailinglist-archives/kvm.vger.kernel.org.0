Return-Path: <kvm+bounces-30998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B749BF2F8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD4201F239D7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C9C20514B;
	Wed,  6 Nov 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKvcNNQQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39301DCB06
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909626; cv=none; b=ZXDSfatDW5jAgz+D964OkfO/q3e1aQEg1PCo3L14RTcQvHvq93kpmuHxRARqQPvqxh0+20TsIY8lPSUHaAjY2H+iXwxuRcyeICeflXypjzC8amXGM/BtnIN695oSkEc0mJztSyvpACevh4L0xoXRjR0DNnrXreKSyzpJK93yJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909626; c=relaxed/simple;
	bh=w4+fCcvR4oM4WWWUJ+u/s+1Qjx2+vbTzSmsSnKjJzWc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mDUQXOPl/B9Z1FrvSYhARGZvLQ7Mv+uDWaG1obkh8GgbendjhftD1P12uLdBW1eIZnSy2/PYodoImcRDL+190XSjk51+Qda9zR/WR3Rzs0C2blRpNCqPD+GwO8+gI7+LhMhAxC4tuUaTs81dNKNgeW4j2sn1ZzenvgADwoDEWl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKvcNNQQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730909623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrqOAqpZHTz17PMgdEC1HtsMkJQLqw7yDhbhgcS9Drs=;
	b=PKvcNNQQ6SswrrMQvcJV7uxbtlPFWyTgDxMaV4PRk3qK2a61PxZZoaNvAluHrtVRavDAgl
	RQuFNgfDIN8dERfxfEpJraupZoROkWV+Yvc3suxQO7YjxuK1EL8c6HvYiijVzJC8NQykuR
	dOaQgiHSqMolr0m1VtBR+IUo9/u7a94=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-zY4xAOXBO5qAx-uXBAv2Sw-1; Wed, 06 Nov 2024 11:13:39 -0500
X-MC-Unique: zY4xAOXBO5qAx-uXBAv2Sw-1
X-Mimecast-MFC-AGG-ID: zY4xAOXBO5qAx-uXBAv2Sw
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-460b8f4bab8so133161801cf.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909619; x=1731514419;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IrqOAqpZHTz17PMgdEC1HtsMkJQLqw7yDhbhgcS9Drs=;
        b=vjT9bzxYf3YKPwidnAN567RJWjKNkSEbmv0O/qa4j5rBbYXeVeFuVEqTWvL9dn8P3K
         NYj8f5Ko2FTdVJhyg8atqWmyb9R3MXyoDRprYHwwE/h8Wm5t3dGEFlmhMZzk4Q9854/r
         a4eh9YKX7ZuH8mTECIWFzS6dKqr1bS5Jw9CZy5KvxU8uOdhZzuTKBUr63j7LXLX6pMwo
         cQUUbq/evARu/fNVtvTmB2ZTi+c3SVUH3hRNlDHxHhkdZcYRWHGYYjm60zwwd5u1oMQl
         rMGUcWr0FMJYS99M0SoI6dNOco1dsXV3OO3u/nafY2i3e+6qtf4ZG0apziFouirT5zLo
         a0YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvgAZ59IYky0tnyBdH5j0GAE9+oEQtiuZ1pLEccycAOGrGgL12ug4LJlRh7pe+BQnbfT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCz3bEPnd6aVpUE9gLhjgqvcDFsccorZdlEN7e7qt4ceptacBZ
	cvdVqtXe0aRG1eLBr0Tx9iLO1aRCQezXShc1MS5/SOLiu2dPTfnqGfERzSU8+T9ychUNdMxkZ8s
	TApvug4YdZcqzpRyzEuRVq3fsTHQyF4YYtfM+Oi+4azUrMlfBLg==
X-Received: by 2002:ac8:57d3:0:b0:460:a8c9:faa6 with SMTP id d75a77b69052e-4613bff2246mr564891991cf.22.1730909618940;
        Wed, 06 Nov 2024 08:13:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeWxrSJWy3bzDP1EcRBgYPcj9VVgBgX5eutzYJ9QRJxrmKWze8aKGhLUHOtCawvtF5OboAhQ==
X-Received: by 2002:ac8:57d3:0:b0:460:a8c9:faa6 with SMTP id d75a77b69052e-4613bff2246mr564891631cf.22.1730909618545;
        Wed, 06 Nov 2024 08:13:38 -0800 (PST)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ad0cac07sm73538351cf.48.2024.11.06.08.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:13:38 -0800 (PST)
Message-ID: <1e70410240ca5cc0b9b60a2a1022929b93ea535d.camel@redhat.com>
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4
 client
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Mario Limonciello <superm1@kernel.org>, Sean Christopherson
	 <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H .
 Peter Anvin" <hpa@zytor.com>, Nikolay Borisov <nik.borisov@suse.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>, Mario Limonciello
 <mario.limonciello@amd.com>,  kvm@vger.kernel.org
Date: Wed, 06 Nov 2024 11:13:37 -0500
In-Reply-To: <65fdc558-21e9-4311-b2b0-8b35131c7aac@kernel.org>
References: <20241105160234.1300702-1-superm1@kernel.org>
	 <ZyuFMtYSneOFrsvs@google.com>
	 <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
	 <ZyuIINwBdiztWhi3@google.com>
	 <37b73861cb86508a337b299a5ae77ab875638fe4.camel@redhat.com>
	 <65fdc558-21e9-4311-b2b0-8b35131c7aac@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-11-06 at 09:58 -0600, Mario Limonciello wrote:
> On 11/6/2024 09:48, Maxim Levitsky wrote:
> > On Wed, 2024-11-06 at 07:15 -0800, Sean Christopherson wrote:
> > > On Wed, Nov 06, 2024, Mario Limonciello wrote:
> > > > On 11/6/2024 09:03, Sean Christopherson wrote:
> > > > > +KVM, given that this quite obviously affects KVM...
> > > > > 
> > > > > On Tue, Nov 05, 2024, Mario Limonciello wrote:
> > > > > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > > > > 
> > > > > > A number of Zen4 client SoCs advertise the ability to use virtualized
> > > > > > VMLOAD/VMSAVE, but using these instructions is reported to be a cause
> > > > > > of a random host reboot.
> > > > > > 
> > > > > > These instructions aren't intended to be advertised on Zen4 client
> > > > > > so clear the capability.
> > > > > > 
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
> > > > > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > > > > ---
> > > > > >    arch/x86/kernel/cpu/amd.c | 11 +++++++++++
> > > > > >    1 file changed, 11 insertions(+)
> > > > > > 
> > > > > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > > > > index 015971adadfc7..ecd42c2b3242e 100644
> > > > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > > > @@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
> > > > > >    {
> > > > > >    	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
> > > > > >    		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
> > > > > > +	 * in some BIOS versions but they can lead to random host reboots.
> > > > > 
> > > > > Uh, CPU bug?  Erratum?
> > > > 
> > > > BIOS bug.  Those shouldn't have been advertised.
> > 
> > Hi!
> > 
> > My question is, why would AMD drop support intentionally for VLS on client machines?
> > 
> > I understand that there might be a errata, and I don't object disabling the
> > feature because of this.
> > 
> > But hearing that 'These instructions aren't intended to be advertised' means that
> > AMD intends to stop supporting virtualization on client systems or at least partially
> > do so.
> 
> Don't read into it too far.  It's just a BIOS problem with those 
> instructions "specifically" on the processors indicated here.  Other 
> processors (for example Zen 5 client processors) do correctly advertise 
> support where applicable.

I am very glad to hear that, thanks!

> 
> When they launched those bits weren't supposed to be set to indicate 
> support, but BIOS did set them.

In other words if I understand correctly, there was an errata and to work
it around on the affected CPUs, AMD decided to disable the feature in CPUID,
which is reasonable, but some BIOS vendors forgot to do this.

It all makes sense, thanks again!

Best regards,
	Maxim Levitsky

> 
> > That worries me. So far AMD was much better that Intel supporting most of the
> > features across all of the systems which is very helpful in various scenarios,
> > and this is very appreciated by the community.
> > 
> > Speaking strictly personally here, as a AMD fan.
> > 
>  > Best regards,> 	Maxim Levitsky
> > 
> > > Why not?  "but they can lead to random host reboots" is a description of the
> > > symptom, not an explanation for why KVM is unable to use a feature that is
> > > apparently support by the CPU.
> > > 
> > > And if the CPU doesn't actually support virtualized VMLOAD/VMSAVE, then this is
> > > a much bigger problem, because it means KVM is effectively giving the guest read
> > > and write access to all of host memory.
> > > 
> 
> I'm gathering that what supported means to you and what it means to me 
> are different things.  "Architecturally" the instructions for 
> virtualized VMLOAD/VMSAVE exist.  There are problems with them on these 
> processors, and for that reason the BIOS was not supposed to set those 
> bits but it did.
> 



