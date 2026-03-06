Return-Path: <kvm+bounces-73184-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEmEFc1jq2mmcgEAu9opvQ
	(envelope-from <kvm+bounces-73184-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:31:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B002D228B99
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:31:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4E8F30CC78D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D1437A4AB;
	Fri,  6 Mar 2026 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgB9tin+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810782E7BD3;
	Fri,  6 Mar 2026 23:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839768; cv=none; b=Y1Dzl2ISsixu5Xg3yfpno9LeXafkv9QGj35uujjeXGKeNtYwR4XF3fzxABc6shQ/BKrWUfDbVSVhO9K92YRPDPVkty6v3ZX0awjTFBLisFsY0VUbALYq315dS1pvrXPNA41IH5lNvidaY2rrZNJf1Ak0D9x9ijfGgtDD2GGKqyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839768; c=relaxed/simple;
	bh=9J7o/uZV0P+zsj/J+BViTyP5+BBxAlWq3Pn/Z1eK+vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cw+1N7HvmdMsWLah31jhkcB8XCs7adNpDrjOCPpi98FJEiKVZFK0UjK2kycvGDHgsX1ShedUJXbK26tWj3bTU4e5MGVFNlYj7uLC2/tP8QW8VFl89sfbHVbXQG2OQtRtETvp2aRr6/6Voj0kgJEZkKEdl1g1DDfKqaoXc6bjEMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgB9tin+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772839768; x=1804375768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9J7o/uZV0P+zsj/J+BViTyP5+BBxAlWq3Pn/Z1eK+vo=;
  b=lgB9tin+YpsIC3rfHsRVO044mfFpIrEJKHObMXpvhq9VYECsq7yKV+DL
   SSg7xldWxyy8rPYED3CNBC3c3dQAJfIRbFd9B/cbMf+gWYq17xnib5MVf
   wUOv6btiGgcnpOJ1+ePjxk6BB+n6zu8SNtM8Dyamb1ub/S4QrCEqEQSM6
   2ISR6VcUBx4j0tcxreYLj1JIgCKiFfJTtjYaEbO1lSccY36mWJMLPnyVC
   wb5noJOfSZ1/rZiFvrIfVGB1lGzyXukRT8SrRTCaE5gcJDEUbOkDarjUR
   84BrrzeITvoF2pH8kXaYk959LP4E4t0sl5wDK52bVns7LE+Zmv1yYc5yr
   A==;
X-CSE-ConnectionGUID: l8AQ8JLqRaykUkUP6h8B9w==
X-CSE-MsgGUID: ZAbgH3gGRN+FHtptErgmMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="85429519"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="85429519"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 15:29:27 -0800
X-CSE-ConnectionGUID: 0xwmkCYeTmqoB21PzfICKw==
X-CSE-MsgGUID: OSk1/5ZFTs+Wvl+bce0vWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="219261956"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 15:29:26 -0800
Date: Fri, 6 Mar 2026 15:29:20 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20260306232920.dja5n7cngrsyj6tk@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
 <20260306223225.l2beapz3nvmqefou@desk>
 <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
X-Rspamd-Queue-Id: B002D228B99
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73184-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pawan.kumar.gupta@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.955];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 02:57:13PM -0800, Jim Mattson wrote:
> On Fri, Mar 6, 2026 at 2:32 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > On Fri, Mar 06, 2026 at 01:00:15PM -0800, Jim Mattson wrote:
> > > On Wed, Nov 19, 2025 at 10:19 PM Pawan Gupta
> > > <pawan.kumar.gupta@linux.intel.com> wrote:
> > > >
> > > > As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> > > > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > > > sequence is not sufficient because it doesn't clear enough entries. This
> > > > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > > > that mitigates BHI in kernel.
> > > >
> > > > BHI variant of VMSCAPE requires isolating branch history between guests and
> > > > userspace. Note that there is no equivalent hardware control for userspace.
> > > > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > > > should execute sufficient number of branches to clear a larger BHB.
> > > >
> > > > Dynamically set the loop count of clear_bhb_loop() such that it is
> > > > effective on newer CPUs too. Use the hardware control enumeration
> > > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > >
> > > I didn't speak up earlier, because I have always considered the change
> > > in MAXPHYADDR from ICX to SPR a hard barrier for virtual machines
> > > masquerading as a different platform. Sadly, I am now losing that
> > > battle. :(
> > >
> > > If a heterogeneous migration pool includes hosts with and without
> > > BHI_CTRL, then BHI_CTRL cannot be advertised to a guest, because it is
> > > not possible to emulate BHI_DIS_S on a host that doesn't have it.
> > > Hence, one cannot derive the size of the BHB from the existence of
> > > this feature bit.
> >
> > As far as VMSCAPE mitigation is concerned, mitigation is done by the host
> > so enumeration of BHI_CTRL is not a problem. The issue that you are
> > refering to exists with or without this patch.
> 
> The hypervisor *should* set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> behalf when BHI_CTRL is not advertised to the guest. However, this
> doesn't actually happen today. KVM does not support the tertiary
> processor-based VM-execution controls bit 7 (virtualize
> IA32_SPEC_CTRL), and KVM cedes the IA32_SPEC_CTRL MSR to the guest on
> the first non-zero write.

The first half of the series adds the support for virtualizing
IA32_SPEC_CTRL. Atleast that part is worth reconsidering.

https://lore.kernel.org/lkml/20240410143446.797262-1-chao.gao@intel.com/

> > I suppose your point is in the context of Native BHI mitigation for the
> > guests.
> 
> Specific vulnerabilities aside, my point is that one cannot infer
> anything about the underlying hardware from the presence or absence of
> BHI_CTRL in a VM.

Agree.

> > > I think we need an explicit CPUID bit that a hypervisor can set to
> > > indicate that the underlying hardware might be SPR or later.
> >
> > Something similar was attempted via virtual-MSRs in the below series:
> >
> > [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
> > https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@intel.com/
> >
> > Do you think a rework of this approach would help?
> 
> No, I think that whole idea is ill-conceived.  As I said above, the
> hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> behalf when BHI_CTRL is not advertised to the guest. I don't see any
> value in predicating this mitigation on guest usage of the short BHB
> clearing sequence. Just do it.

There are cases where this would be detrimental:

1. A guest disabling the mitigation in favor of performance.
2. A guest deploying the long SW sequence would suffer from two mitigations
   for the same vulnerability.

