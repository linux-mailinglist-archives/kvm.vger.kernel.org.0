Return-Path: <kvm+bounces-57811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B222AB7DBD1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE47B32740D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 00:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF16D1F9F70;
	Wed, 17 Sep 2025 00:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hcrw+VPV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E3D1F582A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 00:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758069891; cv=none; b=GeLV01Q49HCT4NrKk6ZEU3B9X+NY4zxtyH5jco05MTbWWKN53LaVDLQq6ZidRixRzfJzBDcLhHvgcZwuMKvcL7pihPyElJ7fsfC8l9T21fux0PJlcqcqK9wF4Z8p93hgNgenin2Rxhtvea02roYMTl42RyOFJortJQmP+V48tEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758069891; c=relaxed/simple;
	bh=wnCfF1Pq7qMApkqSvVsfUpw6VTCZD2Uh7l+XHVS47BQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A5/c1kSBYOh/N5CyPxTX3gwv99VOXMyg2TKhVgj/KuNEYQh7p6sPnUNAnmc4jxDTPPjsaWo3H7cWtZM+WySiOvUL2xa7bDLvdwJB4Iy+M5ddzIvu6vO0ZKmKuOtIuaqJPNcoLvs2M2u6lI6Gk1uTplUY7rvU+/ZHNCt8fmwMzf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hcrw+VPV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so34847a91.3
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 17:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758069890; x=1758674690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/hswYf7lVvCWOohdPLUi8yVfXTjuoy2lk/q+DzDdos=;
        b=Hcrw+VPVmZwRghTgszmv/q6jgMCPPzQf+AWkt182O2/nIqeBtI4hifCT2cQP6D0NfN
         9n6W9H/m1y8LyA+P4eNf6iVvu6ERuyFvyUetirEchszdic5ZD+bt5onrrN4mJCcU48Cq
         OxQDfP1ATyr6KodWJdNv/dzAaz2tu8jCGbhQQKUK18oJQpAIY8F23k+JsVFrT9MH9tEq
         lJuhlHe++Hm2T0lMPK2/NUwSKST8IxGPWU+BTIyNWZxSZRdygHB1rVdEc+A1GSGClww4
         ajP5N4UlnyOe08Ijg8A9bqWFQk7BAlFOjszC8neMl/JJwzyXepV3Y6aqmu5Ej1+FDTl/
         PVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758069890; x=1758674690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/hswYf7lVvCWOohdPLUi8yVfXTjuoy2lk/q+DzDdos=;
        b=bXSXjn7dggNhpgg4CYbs3z0YuPnAaW5ccAtQDKbiXVIf8DNP0toaANtTE2BhFnhEkw
         OLfyRY0J68VSCu7Fusz5TjhHpmqycsSV9AaDn24Gt2aMGmUQnr1u8uoThUTPf7oopV8/
         HUtyRCcH36EyD8mf63fQhC7gEW7PCflWyngjK6ckKG+YgnCAGVYQio+wY+jLTKFMrPqa
         AueFYrEEuql4uAHeJMlUwpcxccvTTZg39da5HMUX2W27JwBSBocVB42Kc9IW4JioLvF0
         O7Wzzmat41dO2NrMaOJq3IXynC9wj3QOw0MuibufNxd0Zcbfzmsi8/R439L8ZlYQyhrf
         +gug==
X-Forwarded-Encrypted: i=1; AJvYcCUNnQqoIafx4eonEGfVjYcYG8LyovG3S6pEoM6jq+g2Ovv0zIErvkVU0Znh0f8E7kYFGd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5LHUHNxrrVU9BmjFstYRwH0KG+WPn4hoGvVP4Il+gYhMGZEJ8
	/n4FdFjiEmKYAbYr1vcvo8tY0ke4RfCRTkoO79ZYrx0dg8iQvBVP0saS/W1rE5ZOmGrCzye2cfF
	hdssWqg==
X-Google-Smtp-Source: AGHT+IFsjL/8hjgK+SlOUP1KxLet5e59olC6UPdkGZJl/+EpswwUkD/EtMLcMiG57Gwu8VdNgrGo7PVX/LU=
X-Received: from pjuj4.prod.google.com ([2002:a17:90a:d004:b0:32d:57a8:8ae6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c2:b0:32e:a3bf:e606
 with SMTP id 98e67ed59e1d1-32ee3f8df4cmr318291a91.28.1758069889599; Tue, 16
 Sep 2025 17:44:49 -0700 (PDT)
Date: Tue, 16 Sep 2025 17:44:48 -0700
In-Reply-To: <fa63be53-8769-4761-b878-556f20e1fbfc@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
 <aMhxaAh6a3Eps_NJ@google.com> <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
 <f9d43ba5-0655-4a4e-b911-30b11615361d@kernel.org> <aMlrewJeXm-_ierH@google.com>
 <villgy3ehps5puo3grrs2zoknbr7oyuy3jikr2cvikm4xrdgtd@ftkyxrfmptsl> <fa63be53-8769-4761-b878-556f20e1fbfc@kernel.org>
Message-ID: <aMoEgKQsfkIfL_wz@google.com>
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
From: Sean Christopherson <seanjc@google.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Mario Limonciello wrote:
> On 9/16/25 1:37 PM, Naveen N Rao wrote:
> > On Tue, Sep 16, 2025 at 06:51:55AM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 16, 2025, Mario Limonciello wrote:
> > > > On 9/16/25 2:14 AM, Naveen N Rao wrote:
> > > > > On Mon, Sep 15, 2025 at 01:04:56PM -0700, Sean Christopherson wrote:
> > > > > > On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > > > > There are platforms where this is the case though:
> > > > > 
> > > > > $ cpuid -1 -l 0x8000000A | grep -i avic
> > > > >         AVIC: AMD virtual interrupt controller  = false
> > > > >         X2AVIC: virtualized X2APIC              = true
> > > > >         extended LVT AVIC access changes        = true
> > > > > 
> > > > > The above is from Zen 4 (Phoenix), and my primary concern is that we
> > > > > will start printing a warning by default. Besides, there isn't much a
> > > > > user can do here (except start using force_avic, which will taint the
> > > > > kernel). Maybe we can warn only if AVIC is being explicitly enabled?
> > > 
> > > Uh, get that platform to not ship with a broken setup?
> > > 
> > > > I'd say if you need to say something downgrade it to info instead and not
> > > > mark it as firmware bug.
> > > 
> > > How is the above not a "firmware" bug?
> > 
> > Ok, looking at AVIC-related CPUID feature bits:
> > 1. Fn8000_000A_EDX[AVIC] (bit 13) representing core AVIC support
> > 2. Fn8000_000A_EDX[x2AVIC] (bit 18) for x2APIC MSR support
> > 3. Fn8000_000A_EDX[ExtLvtAvicAccessChg] (bit 27) for change to AVIC
> > handling of eLVT registers
> > 4. Fn8000_000A_ECX[x2AVIC_EXT] (bit 6) for x2AVIC 4k vCPU support
> > 
> > The latter three are dependent on the first feature being enabled. If a
> > platform wants to disable AVIC for whatever reason, it could:
> > - disable (1), and leave the rest of the three feature bits on as a way
> >    to advertise support for those (OR)
> > - disable all the four CPUID feature bits above
> > 
> > I think you are saying that the former is wrong and the right way to
> > disable AVIC would be to turn off all the four CPUID feature bits above?

Yes.

> > I don't know enough about x86/CPUIDs to argue about that ;)
> > 
> > However, it appears to me that the former approach of only disabling the
> > base AVIC CPUID feature bit is helpful in advertising the platform
> > capabilities.

My objection to that approach is that by disabling AVIC, the platform is no longer
capable of x2AVIC.  There are other situations where firmware can disable a feature
that is reported as support in CPUID, e.g. VMX vs. FEATURE_CONTROL on Intel, but
in those cases, the disabling is visible to software in something other than CPUID,
i.e. it's obvious to software that firmware has disabled (or maybe just not enabled)
the related feature.

For me, this is different.  It won't be at all obvious to the vast majority of
users, myself included, that firmware is even capable of manipulating CPUID in
this way.

> > Assuming AVIC was disabled due to a harware erratum, those who are _not_
> > affected by the erratum can meaningfully force-enable AVIC and also have
> > x2AVIC (and other related AVIC features and extensions) get enabled
> > automatically.  If all AVIC related CPUID feature bits were to be
> > disabled, then force_avic will serve a limited role unless it is
> > extended.
> > 
> > I don't know if there is precedence for this, or if it is at all ok,
> > just that it may be helpful.
> > 
> > Also, those platforms are unlikely to be fixed (client/desktop systems
> > that are unlikely to receive updates).

I know, but IMO it's not KVM's responsibility to hide the existence of what appears
buggy firmware.  With my user hat on, I would be very frustrated if I had to post
to the KVM mailing and wait for someone in the loop to explain that my firmware is
buggy.

> > The current warning suggests passing force_avic, but that will just
> > taint the kernel and potentially break more things assuming AVIC was
> > turned off for a good reason. Or, users can start explicitly disabling
> > AVIC by passing "avic=0" if they want to turn off the warning. Both of
> > these don't seem helpful, especially on client platforms.
> > 
> > So, if you still think that we should retain that warning, should we
> > tweak it not to suggest force_avic?

Hmm, yeah, I agree.  Suggesting random users to enable force_avic by default is
borderline irresponsible.  Even suggesting it to anyone that enables AVIC manually
is a bit sketchy...

