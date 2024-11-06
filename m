Return-Path: <kvm+bounces-30995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDC59BF2E0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAAD9B21D6F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0961A204086;
	Wed,  6 Nov 2024 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DBqfOGk7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07372EAE0
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909472; cv=none; b=NaaOnpiHRQ8QAQUGOfXZ6GXxHa51VqzZC1sSEJ3xnvnZvYBkkWyU1zoWNH81VAINdSBZZs0qdvw+IzJJZ6QEWOzDQDAKcc+Gwse0Do7paEjiQrrMTh/swh/Tb59Ezbg7REKT+m6FWP4tWXjdiBq7rybtbUsnlXcqTx8tmCdRsQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909472; c=relaxed/simple;
	bh=mQWGP2+2dHnsJHAp4+gKGfAR7r4pUwuigIwI+pjGUI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TEHVOosYbgug0EUFZCECIH02OClafLP/OA0UwruJyJvQZhHkejRz3ianOus11AJ+aT1fwpg7zkqxoDpJ7K0b2qEg2VZwWKDNADq0mLYATgSyKgNM/YINKwrV0hp317vhU1GdjbWm8c6qpICWcvAY8QunW9rU87wHW+hJhWaFrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DBqfOGk7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e55c9d23cso7739b3a.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730909470; x=1731514270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6k40+fe0KdTgjyeXKK2jvU+7V/OtIEet3QC+IoUobOs=;
        b=DBqfOGk7uVhSn3LMY88MKgiFBxCsliGdLcoUb6eJlyRXJu5bXkFoIPDwOx3gF+FSvT
         zZKuCbiOcF1d8mKC4W8hyLjub0XxwlWhElcYHZ1siOyVIE+d3flTamNWYYMDP7Mp/uxg
         bIk7Or4wkIVAYPTCkUyoeWhwnhFwbJYEqM3SjOZjDgbJtluDzKPvsYnQ/s+JVJTlKfcT
         1VA/GbW8qtf8HUXyUThpngDFLrG9ZUTtZiwH+uR1QdoE/L2L4lV4FwTUaGYlQYmrQssf
         JQFcSpKF9geRh6uVNvIDYauLiPFX946Yi+DW1XP7fAMlLAzJ79bvRWi+KRcYk1G1+psp
         Xhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909470; x=1731514270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6k40+fe0KdTgjyeXKK2jvU+7V/OtIEet3QC+IoUobOs=;
        b=gDQFRLCh8JP5CSHSeEFRQEaYblz2CJnqy0p8DptH8O5AJGlyY9mUP6uKhGaTqZSWRT
         bcukx1FC6VXPN3LgYYs5pL4jHhPwDq0P3FeeWMG5clUTwbL2OBBuLOwmS1OJijwrGhlB
         AztHA7htU5iIhMztdCHC0+WNbUVZQjIcrmoqHzTUInOSSx+hb7JWhuP9QCi0es8YC9Km
         iop9BQMSGF6100DCxnr8e9Yh6VIE7TqyjIFVa5VIPGAHDlx7VA7rQTNB+m3f7WzqafXV
         cUsKACTi0EctQ3zBD9Mo1DDARNZU1QHNyOIPEpCKeao916FaTg6Znop+ikrgl46yEPr4
         1jgA==
X-Forwarded-Encrypted: i=1; AJvYcCW13twGD8ifRRocUVjlOUcc1l8PkqUIF85mRVH47wBA3J4mEAUqdnZaHiphr9lfaMaTOlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXAADP6DInYPhcFdIsdheOwkyeOYWrmSeeEuhd8U6gfT4jz9HO
	XX6BusSDOhTflPtKwqJhPx0vxSSFucJ5HtP1GXOHo+FUBXZAo5rvmhgmpEWxIEL9hpfcV7iQBDK
	F2g==
X-Google-Smtp-Source: AGHT+IEtwl30f9l4Gs0C51y2tW7a7XqFq8bJr1VL5oboFCNh3+W8lcmupQoDyH6ZL/YX2BlKlpTgCO+1PW8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:846:b0:71e:466a:5b32 with SMTP id
 d2e1a72fcca58-723f7aac2c6mr192924b3a.2.1730909470100; Wed, 06 Nov 2024
 08:11:10 -0800 (PST)
Date: Wed, 6 Nov 2024 08:11:08 -0800
In-Reply-To: <65fdc558-21e9-4311-b2b0-8b35131c7aac@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160234.1300702-1-superm1@kernel.org> <ZyuFMtYSneOFrsvs@google.com>
 <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org> <ZyuIINwBdiztWhi3@google.com>
 <37b73861cb86508a337b299a5ae77ab875638fe4.camel@redhat.com> <65fdc558-21e9-4311-b2b0-8b35131c7aac@kernel.org>
Message-ID: <ZyuVHJ9K51tOkOMM@google.com>
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client
From: Sean Christopherson <seanjc@google.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, 
	Mario Limonciello <mario.limonciello@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Mario Limonciello wrote:
> On 11/6/2024 09:48, Maxim Levitsky wrote:
> > On Wed, 2024-11-06 at 07:15 -0800, Sean Christopherson wrote:
> > > On Wed, Nov 06, 2024, Mario Limonciello wrote:
> > > > On 11/6/2024 09:03, Sean Christopherson wrote:

...

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
> 
> When they launched those bits weren't supposed to be set to indicate
> support, but BIOS did set them.

As you quite clearly call out below, this isn't simply a BIOS problem.

> > That worries me. So far AMD was much better that Intel supporting most of the
> > features across all of the systems which is very helpful in various scenarios,
> > and this is very appreciated by the community.
> > 
> > Speaking strictly personally here, as a AMD fan.
> > 
> > Best regards,> 	Maxim Levitsky
> > 
> > 
> > > 
> > > Why not?  "but they can lead to random host reboots" is a description of the
> > > symptom, not an explanation for why KVM is unable to use a feature that is
> > > apparently support by the CPU.
> > > 
> > > And if the CPU doesn't actually support virtualized VMLOAD/VMSAVE, then this is
> > > a much bigger problem, because it means KVM is effectively giving the guest read
> > > and write access to all of host memory.
> > > 
> > 
> > 
> 
> I'm gathering that what supported means to you and what it means to me are
> different things.

Yes.  And the distinction matters greatly in this case, because "VMLOAD/VMSAVE
in the guest are broken" is *very* different than "VMLOAD/VMSAVE in the guest
actually operate on SPAs, not GPAs".

> "Architecturally" the instructions for virtualized VMLOAD/VMSAVE exist.

Which means they're supported, but broken.

> There are problems with them on these processors, and for that reason the
> BIOS was not supposed to set those bits but it did.

In other words, this a CPU bug.  The kernel comment absolutely needs to reflect
that.  Passing this off as BIOS going rogue is misleading and confusing.

