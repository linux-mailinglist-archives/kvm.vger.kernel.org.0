Return-Path: <kvm+bounces-70300-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPOiMq8zhGll0wMAu9opvQ
	(envelope-from <kvm+bounces-70300-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:07:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54BF1EEE6B
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 469453019910
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE0B334C25;
	Thu,  5 Feb 2026 06:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="VFWUOk52"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob01.noc.sony.co.jp (jpms-ob01.noc.sony.co.jp [211.125.140.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F452D46D6;
	Thu,  5 Feb 2026 06:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271632; cv=none; b=GZMrULGyuqXbDaH46069PtGCqquNBb/eOfvQZpow/nb9ZvBQvkUWZIwFnObhhdQn0vRqBrJ/7yO72+Zr7I3KqxkDdJrS90ZwQGpCnakfCqMgtuwRvUTcVUYUwlUIJowlm88t4gIflMFoX8b5brhl/+x6lrN+Wy4wraXU0z1jKkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271632; c=relaxed/simple;
	bh=iLAKRWnJ4xFV61YkHX327DOOGbae/giyWkllC2m/aVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nO7ShXBu/5ePJzH/+xRREevGC780se4RMaHrIMafcog/Yjn5uewH19MaGDTHm1QIRlEKE6gwPCUQca0GP1s31Ic+0Uh+uBq986SGI7jkXoSzMMdKfyuW94WPOp3kjrnuW1YFBSIxDqVp97gd4674p+s/K386Oe0KF0oYPomW8/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=VFWUOk52; arc=none smtp.client-ip=211.125.140.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770271632; x=1801807632;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UBawYbMlXUOKgrz6LV1oJhX/gsrHRCKMioT7xEbWP+c=;
  b=VFWUOk52jOWcGi8pj9k9yr/ikYHOdIKZqb2K1uWGipADY1SE3PQwOTAd
   L1fLtNarakqJrl3BQYWs+6W4oyyUdZ+0FIs0dyOj6CQ+MfqzHxh2KAdIH
   KGWt31+gP6+/qFc0RaScONa/Iscq8V+bJRGQChyS1VjkFs/6uNL0Klj4V
   F3dZo4x3hIQEWk2FM2k9w1/kJjQDxg9fIL1jKGEn8vhCi5zUeIAZOAEps
   yaLH9WYQl9P3XdFxUeL/srUNydMF/rc/fmyYMC55dStmlEPivS0aHwUhs
   mv9q4sb+M1E35Nwfj+vY5pbcasXXbcmYpXwcqGxmNsm8oUL3mj/HMM43P
   A==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob01.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 15:07:03 +0900
X-IronPort-AV: E=Sophos;i="6.21,274,1763391600"; 
   d="scan'208";a="608419792"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 15:07:03 +0900
Date: Thu, 5 Feb 2026 15:07:01 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <aYQzhRN83rJx6DSb@JPC00244420>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
 <aYMOqXTYMJ_IlEFA@JPC00244420>
 <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70300-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[sony.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 54BF1EEE6B
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 10:53:28AM -0800, Sohil Mehta wrote:
> On 2/4/2026 1:17 AM, Shashank Balaji wrote:
> 
> > __x2apic_disable disables x2apic only if boot_cpu_has(X86_FEATURE_APIC)
> > and x2apic is already enabled. 
> 
> I meant the X86_FEATURE_X2APIC and not X86_FEATURE_APIC.

My bad, I got that wrong. __x2apic_disable checks for X86_FEATURE_APIC,
while x2apic_enabled checks for X86_FEATURE_X2APIC.

> But, thinking about it more, checking that the CPU is really in X2APIC mode
> by reading the MSR is good enough.

But yes, I agree.

> > x2apic_enabled also does the same checks,
> > the only difference being, it uses rdmsrq_safe instead of just rdmsrq,
> > which is what __x2apic_disable uses. The safe version is because of
> > Boris' suggestion [1]. If that's applicable here as well, then rdmsrq in
> > __x2apic_disable should be changed to rdmsrq_safe.
> 
> I don't know if there is a strong justification for changing to
> rdmsrq_safe() over here. Also, that would be beyond the scope of this
> patch. In general, it's better to avoid such changes unless an actual
> issue pops up.

Makes sense.

> >> I considered if an error message should be printed along with this. But,
> >> I am not sure if it can really be called a firmware issue. It's probably
> >> just that newer CPUs might have started defaulting to x2apic on.
> >>
> >> Can you specify what platform you are encountering this?
> > 
> > 
> > I'm not sure it's the CPU defaulting to x2apic on. As per Section
> > 12.12.5.1 of the Intel SDM:
> > 
> > 	On coming out of reset, the local APIC unit is enabled and is in
> > 	the xAPIC mode: IA32_APIC_BASE[EN]=1 and IA32_APIC_BASE[EXTD]=0.
> > 
> > So, the CPU should be turning on in xapic mode. In fact, when x2apic is
> > disabled in the firmware, this problem doesn't happen.
> > 
> 
> It's a bit odd then that the firmware chooses to enable x2apic without
> the OS requesting it.

Well, the firmware has a setting saying "Enable x2apic", which was
enabled. So it did what the setting says

> Linux maintains a concept of X2APIC_ON_LOCKED in x2apic_state which is
> based on the hardware preference to keep the apic in X2APIC mode.
> 
> When you have x2apic enabled in firmware, but the system is in XAPIC
> mode, can you read the values in MSR_IA32_ARCH_CAPABILITIES and
> MSR_IA32_XAPIC_DISABLE_STATUS?
> 
> XAPIC shouldn't be disabled because you are running in that mode. But,
> it would be good to confirm.

With x2apic enabled by the firmware, and after kernel switches to xapic
(because no interrupt remapping support), bit 21 (XAPIC_DISABLE_STATUS)
of MSR_IA32_ARCH_CAPABILITIES is 0, and MSR_IA32_XAPIC_DISABLE_STATUS
MSR is not available.
 
> > Either way, a pr_warn maybe helpful. How about "x2apic re-enabled by the
> > firmware during resume. Disabling\n"?
> 
> I mainly want to make sure the firmware is really at fault before we add
> such a print. But it seems likely now that the firmware messed up.

