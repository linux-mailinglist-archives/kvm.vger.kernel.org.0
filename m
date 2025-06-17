Return-Path: <kvm+bounces-49762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A76ADDD67
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 333ED194022B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFB828CF5E;
	Tue, 17 Jun 2025 20:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aozH+P0n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1046D1E9B3A
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750193258; cv=none; b=f/njL+gmGyDdlD64483TOLXpzFXkRdloc3E9NFjAnM9zzwJwsh94c5RALFnFMN+IWgUtvZtdtEZByYiTKgYeSyBPafqOL/BiuN94T6P6uzCP6VaHv5hdsukvJdwi5D8EY+1bfPebWqsmx6VfB62Y884oaZP6KZIgYN2HWh1pPKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750193258; c=relaxed/simple;
	bh=3/vgO2MAgi61sccA47cBBHfs3OLzoq8V5yMiIVJ4/Gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FfUDHGoHIGnZ10PXNGJuvhQfbt/dH+DuWTRRYsU4Zz1B+WNA8r+lLM2P0W+VDxe5TR+9WeuDDTf+qNli/CzI3E3YWGa63URutbvPUSO3z0DEEj7q8xCzbmnLxfUjGEvnEp5GyT51FlJLRXrvSa5ZRzKq+VCEiXKWMoRBNkzBmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aozH+P0n; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fdba7f818so6399648a12.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 13:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750193256; x=1750798056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FnyrMYQY3dnwrg2Tl4Z0xb3GVnj67wqrvUNa97aPsfM=;
        b=aozH+P0nCatKkzarYW8mZ3o97ddUQmF2i7+vFo+SrbGQhG3FqX+5dIOU1iJMNg+kHZ
         a8szhT0WKU2AiZ0y8hwNceYnUG+Ha4G51+/ZTwKbT4dwAef5Oi2TPLRJSf0LPshC3wp2
         pV5vHJMd1uK15ZES8ldjP6nwAuoNhNUuzZ9xXvqTysmJMxopyzOTmgO8/k8pHKmcXhXR
         AQ4mRML4WPasHscuP4rggIHPt3CWmKNHqDfr8I3Sq4hFEls+B55q7AdeoJLuigVC/Gra
         gY3xvJUiSnw3BeiizCdw0hVfb4QHzoCbT5g4wcRwPLWRL/P3qt0TM3uT8TCDEntVE4z1
         raXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750193256; x=1750798056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnyrMYQY3dnwrg2Tl4Z0xb3GVnj67wqrvUNa97aPsfM=;
        b=ddL6F8AHkmUtBAZbPXiFX4aZTDOfRLHSIUh1HT9UC1xFIj/dtsvdFR6zZAp9jfFcG6
         iH/B8Wijwl7L3bAgsFWj/8Bsvbh0MZwkh7T4WyJLItckDFeO3StrsXWseh5zira59hFu
         JnKaCW+hmE3nV9ZUBsi43HdhKEVuo+r4smwJPvfYBe+xmR39dXzds3hXlggStEN5pF/N
         05C8AoCQWkpPw1ZFElDieLy6Wa11LaC/jjhUwTk/LreMNXo2auV9kjrixHWtRikKKJ81
         reb7tVcIYhOFVlk7Ji1Wq57L3z1vI/8Xecbq2Nxd14pD/TySJEZEpOc2LoWXe5FOQ8l/
         iumg==
X-Forwarded-Encrypted: i=1; AJvYcCVAxjw0C/P+oqctCs6bjRMzA7KTkIGLY2ExS0bpKUsx+NTf1ei5c0eDm9fag9n0FwiHE80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjz/5PwkqcD5clWbAHTsAu9brNfSpH/UYe2m3XfdBeyzO4vbIy
	N4czg37ppyTtxFXWQFaB2BXpVjWN4Gb7UUOLW2cBXKdjZiJQKHQKYapdlZmW7zkQSPuZj013PUE
	4/RZYpg==
X-Google-Smtp-Source: AGHT+IG3bCBsOcrBYJmDX9OVwj2KQ4phrXgCiORMgy9ics3yw/XvqHxvG2UzR55s0Mz/gkrg7oUsOfqWfp0=
X-Received: from pgbbf10.prod.google.com ([2002:a65:6d0a:0:b0:b2e:bad0:b462])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7313:b0:21a:ef2f:100b
 with SMTP id adf61e73a8af0-21fbd666e45mr24322046637.24.1750193256240; Tue, 17
 Jun 2025 13:47:36 -0700 (PDT)
Date: Tue, 17 Jun 2025 13:47:34 -0700
In-Reply-To: <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250617073234.1020644-1-xin@zytor.com> <20250617073234.1020644-2-xin@zytor.com>
 <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
Message-ID: <aFHUZh6koJyVi3p-@google.com>
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
From: Sean Christopherson <seanjc@google.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com, 
	tony.luck@intel.com, fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 17, 2025, Sohil Mehta wrote:
> On 6/17/2025 12:32 AM, Xin Li (Intel) wrote:
> > diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
> > index 0007ba077c0c..8f335b9fa892 100644
> > --- a/arch/x86/include/uapi/asm/debugreg.h
> > +++ b/arch/x86/include/uapi/asm/debugreg.h
> > @@ -15,7 +15,12 @@
> >     which debugging register was responsible for the trap.  The other bits
> >     are either reserved or not of interest to us. */
> >  
> > -/* Define reserved bits in DR6 which are always set to 1 */
> > +/*
> > + * Define reserved bits in DR6 which are set to 1 by default.
> > + *
> > + * This is also the DR6 architectural value following Power-up, Reset or INIT.
> > + * Some of these reserved bits can be set to 0 by hardware or software.
> > + */
> >  #define DR6_RESERVED	(0xFFFF0FF0)
> >  
> 
> Calling this "RESERVED" and saying some bits can be modified seems
> inconsistent. These bits may have been reserved in the past, but they
> are no longer so.
> 
> Should this be renamed to DR6_INIT or DR6_RESET? Your commit log also
> says so in the beginning:
> 
>    "Initialize DR6 by writing its architectural reset value to ensure
>     compliance with the specification."
> 
> That way, it would also match the usage in code at
> initialize_debug_regs() and debug_read_reset_dr6().
> 
> I can understand if you want to minimize changes and do this in a
> separate patch, since this would need to be backported.

Yeah, the name is weird, but IMO DR6_INIT or DR6_RESET aren't great either.  I'm
admittedly very biased, but I think KVM's DR6_ACTIVE_LOW better captures the
behavior of the bits.  E.g. even if bits that are currently reserved become defined
in the future, they'll still need to be active low so as to be backwards compatible
with existing software.

Note, DR6_VOLATILE and DR6_FIXED_1 aren't necessarily aligned with the current
architectural definitions (I haven't actually checked), rather they are KVM's
view of the world, i.e. what KVM supports from a virtualization perspective.

Ah, and now I see that DR6_RESERVED is an existing #define in a uAPI header (Xin
said there were a few, but I somehow missed them earlier).  Maybe just leave that
thing alone, but update the comment to state that it's a historical wart?  And
then put DR6_ACTIVE_LOW and other macros in arch/x86/include/asm/debugreg.h?

/*
 * DR6_ACTIVE_LOW combines fixed-1 and active-low bits.
 * We can regard all the bits in DR6_FIXED_1 as active_low bits;
 * they will never be 0 for now, but when they are defined
 * in the future it will require no code change.
 *
 * DR6_ACTIVE_LOW is also used as the init/reset value for DR6.
 */
#define DR6_ACTIVE_LOW	0xffff0ff0
#define DR6_VOLATILE	0x0001e80f
#define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)

