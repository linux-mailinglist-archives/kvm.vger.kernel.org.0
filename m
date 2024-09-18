Return-Path: <kvm+bounces-27072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB8E97BBE3
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 14:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 298AB283D34
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 12:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B69118990D;
	Wed, 18 Sep 2024 12:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bB5W6fBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A217C9BA
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726661242; cv=none; b=DRntd3cjZ/2WzbfMnJRdpMOS1fKfx2oQsZGIiU+4n0KH1+B8QKeZOEAUrCp7hnOvsWUHG7W4Jf213J9UwFRbVNBNad8wOEoo+bDFPrkIQDkqJ28m5gqbaOq78RlCjSPj08HTPn92xrtXv8PlUWiYAEhwXoa4xJapY1aGrio87RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726661242; c=relaxed/simple;
	bh=RAtPKAtbfcHHjMKyv+VNhXNev6NWhjeu9m3hwq3CJK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HmTEjWX2xkRG5BtQiWWVOgiFFLpwjUlQGaQ7fV6FCsM02tAX5wepYoXA4ShJrnA+6G1QzAloxqso73K2dXq7TAvtXaAeBzDL32xuTU+w2QKgX9ObW8g/o9WUPa7jdNx4dkkkw2U0wiPCu5oAxzBCUvRTQBgYP/ufXhqlOsTTfkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bB5W6fBS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1d46cee0b0so12271592276.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726661240; x=1727266040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NkmtIxU+FppdMB18S8izokek2BhBOE8zhRXe1yQJeLw=;
        b=bB5W6fBSmtQ+in+jZzmfr5YPVmv5lF9cFFN8eo0JV2paYPyZVkJq6rU82Xc27hf8Zm
         +DrIMdhStamkYGkhBu5ak9dauP+X2QLBp67CxK9gGj3qUNUHzLoJlZZJgksXuhjbm+gM
         XlCpI7POU+3qaha2yG+UReWq108iVQtvoqAportDckuoFYCae2VffotbCpY2RI1xb8xS
         nWCQ13SA5Ugn9hYEMn2JYtuz8EaT79+m2HO50dfWYWIiJD/7UKI0gfwc25YbYVaNvKy/
         ICbxQCtzdg9YQo6cmGkZeZ3sOKYOXqYI6I6WbOt9Lf649S0QA5HPrv6kvqKWC8f4UC/y
         BZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726661240; x=1727266040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkmtIxU+FppdMB18S8izokek2BhBOE8zhRXe1yQJeLw=;
        b=iQ+2Iz4GbENpJFZCYdK7UlJTEYTYMHGPlZbuvGB4mVCgn39YohNxPOt8CFC2zr+gwK
         C98Op6ZLVEG/T/wtzC/MHa1wvlwkHCOYo4IsvhMKi3mg0cAO2QDXRcNrc12KLSjSXCxH
         1UQvJnarQMP3DMyB0s3h6fpr4rMpz42vGpUlHgRKG93yPshphXHvyGOURFojJuJ/JA2x
         VAAmpMUUYsYb3XZjE3Kt+1IyY6bZKv8xrhkdZaXAu+IWewwfDxDpz8tDHPiPuwVMVh4P
         J80z4lzGiMB/MJZ7qYIXYjQr6vRgFuYwy9BgZ/aJxcPIvD13rGrCFV3ThA+I+iTCRRgy
         T9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAi5DJDOwuRi6OvlrhKV3UG6IgYVQEvQxU+y4UEWvHqtLHpzvnilINeaA5tlfYMS0KzCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3HST47jCn0Vr3grQv6l7ouquUYm0YcibgKXSUTymYBdu2nNBH
	eGPKxGYVBjlYWXzX0j7XVFRGsHkv0wteWty5Ibuext7ikMvloTfPw5pJ0wIBZP7v6niHgP1SDUp
	VXQ==
X-Google-Smtp-Source: AGHT+IHZ41Pb/w7FjZAic6hb0I389ImtsrHjzH0O4hHAsYPrz3KeyzZ/jgKEqyYx+PKdvUkEgUm9YDzMTBE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c78c:0:b0:e0b:f93:fe8c with SMTP id
 3f1490d57ef6-e1d9daa135fmr66936276.0.1726661239692; Wed, 18 Sep 2024 05:07:19
 -0700 (PDT)
Date: Wed, 18 Sep 2024 05:07:08 -0700
In-Reply-To: <9a218564-b011-4222-187d-cba9e9268e93@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240731150811.156771-1-nikunj@amd.com> <20240731150811.156771-20-nikunj@amd.com>
 <ZuR2t1QrBpPc1Sz2@google.com> <9a218564-b011-4222-187d-cba9e9268e93@amd.com>
Message-ID: <ZurCbP7MesWXQbqZ@google.com>
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is available
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 16, 2024, Nikunj A. Dadhania wrote:
> On 9/13/2024 11:00 PM, Sean Christopherson wrote:
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> Tested-by: Peter Gonda <pgonda@google.com>
> >> ---
> >>  arch/x86/kernel/kvmclock.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> >> index 5b2c15214a6b..3d03b4c937b9 100644
> >> --- a/arch/x86/kernel/kvmclock.c
> >> +++ b/arch/x86/kernel/kvmclock.c
> >> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
> >>  {
> >>  	u8 flags;
> >>  
> >> -	if (!kvm_para_available() || !kvmclock)
> >> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> > 
> > I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
> > I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
> > is simply what's forcing the issue, but it's not actually the reason why Linux
> > should prefer the TSC over kvmclock.  The underlying reason is that platforms that
> > support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
> > TSC is a superior timesource purely from a functionality perspective.  That it's
> > more secure is icing on the cake.
> 
> Are you suggesting that whenever the guest is either SNP or TDX, kvmclock
> should be disabled assuming that timesource is stable and always running?

No, I'm saying that the guest should prefer the raw TSC over kvmclock if the TSC
is stable, irrespective of SNP or TDX.  This is effectively already done for the
timekeeping base (see commit 7539b174aef4 ("x86: kvmguest: use TSC clocksource if
invariant TSC is exposed")), but the scheduler still uses kvmclock thanks to the
kvm_sched_clock_init() code.

The other aspect of this to consider is wallclock.  If I'm reading the code
correctly, _completely_ disabling kvmclock will case the kernel to keep using the
RTC for wallclock.  Using the RTC is an amusingly bad decision for SNP and TDX
(and regular VMs), as the RTC is a slooow emulation path and it's still very much
controlled by the untrusted host.

Unless you have a better idea for what to do with wallclock, I think the right
approach is to come up a cleaner way to prefer TSC over kvmclock for timekeeping
and the scheduler, but leave wallclock as-is.  And then for SNP and TDX, "assert"
that the TSC is being used instead of kvmclock.  Presumably, all SNP and TDX
hosts provide a stable TSC, so there's probably no reason for the guest to even
care if the TSC is "secure".

Note, past me missed the wallclock side of things[*], so I don't think hiding
kvmclock entirely is the best solution.

[*] https://lore.kernel.org/all/ZOjF2DMBgW%2FzVvL3@google.com

