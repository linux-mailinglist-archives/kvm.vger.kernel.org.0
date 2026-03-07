Return-Path: <kvm+bounces-73220-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFbWGJWQq2lHeQEAu9opvQ
	(envelope-from <kvm+bounces-73220-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:42:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC17C229A89
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD2A23063740
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FA42E1746;
	Sat,  7 Mar 2026 02:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PxNRdUUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10CE2DB7A9;
	Sat,  7 Mar 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772851300; cv=none; b=k/TWMATghM82EePfGqWEf+q88D6if6gSxRMu1KR86pCuzr1rPn34Cp1ekvPHDHkrx+0OFzyBtXGymQw70EvjgIfTAGT7KoDZTpp2evj41lo0LaXr0LT9QsAslUlqHzu8ueflUr0hhY5AXUOdenWvN9A/wSbR2BEPcKay2yiLGZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772851300; c=relaxed/simple;
	bh=2Hk+Ukv/JmDB+0sEW1ekV1MWEyBKDUQoHCydvOVio5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALXG5P1VAa1BTg5fkW573DXMkylfkcnjXYqk3Eav4jsFkfiHtQcWmv+8zbdN0FptbTadvmJt11sZwWdo1w98ANzAspZxfBz5+UgSTKjUsljvBFaUfi3txfGHtJiaMSYA431bTDaqYnksFOTlJMas7NCS7xEVQjsCtEgfA/Geq1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PxNRdUUJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772851299; x=1804387299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2Hk+Ukv/JmDB+0sEW1ekV1MWEyBKDUQoHCydvOVio5k=;
  b=PxNRdUUJ+Oalj0nj/sqUXC7vT/ysStuwv46joUQ3CIE4rLUCN2Vg5PF5
   wfoNJh37HQnj8ZZomG1XV8EDn0Mi5BpRjjvr5wyKSbsLd+k7cssUsDymm
   i1C3SZsZNCMET/WN4S2WzdpCh5bJWPu1Wj4QA0GegrNmb7pVDGYE5ng7c
   O6COvk6zf0fO0oxFbETxTJOQG4VA6XaSXRdQwcRcCl0bAwcR/q7hUqigt
   o/fqf0mOdmp8dx8QT2SEWBZQrGwx5duQQEVS5DBYgF1LFdWp0StON/DV3
   EJOdf6YVb/X2JCJ/xAhVdQD2Q6joVlWeObP886d+FcNsHRopJ3nii+mEl
   g==;
X-CSE-ConnectionGUID: 7JVLumOnRlSR26zhSy3uSQ==
X-CSE-MsgGUID: WcZTbAIKQxy9p5FDRYA4tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73838112"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="73838112"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 18:41:39 -0800
X-CSE-ConnectionGUID: t6dpALQoTMCsPGXJYig7kA==
X-CSE-MsgGUID: quy5FKj0TL+ldilYeavCkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="224135610"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 18:41:39 -0800
Date: Fri, 6 Mar 2026 18:41:32 -0800
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
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>,
	chao.gao@intel.com
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20260307024132.wleqtpovzd6wtvm7@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
 <20260306223225.l2beapz3nvmqefou@desk>
 <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
 <20260306232920.dja5n7cngrsyj6tk@desk>
 <CALMp9eSoNaifKyppbjJjNx1YEw9KFv0LGAJ6xD-ko0zJnNXEbw@mail.gmail.com>
 <20260307010051.u4ugg3nyvsu6hwbg@desk>
 <CALMp9eQGZcekQ3QtL=J7TqHJ9YfZ+SbrgY5P8fp14p4KNThYmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQGZcekQ3QtL=J7TqHJ9YfZ+SbrgY5P8fp14p4KNThYmw@mail.gmail.com>
X-Rspamd-Queue-Id: BC17C229A89
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
	TAGGED_FROM(0.00)[bounces-73220-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pawan.kumar.gupta@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.960];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 05:10:23PM -0800, Jim Mattson wrote:
> On Fri, Mar 6, 2026 at 5:01 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > +Chao
> >
> > On Fri, Mar 06, 2026 at 04:35:49PM -0800, Jim Mattson wrote:
> > > > > > > I think we need an explicit CPUID bit that a hypervisor can set to
> > > > > > > indicate that the underlying hardware might be SPR or later.
> > > > > >
> > > > > > Something similar was attempted via virtual-MSRs in the below series:
> > > > > >
> > > > > > [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
> > > > > > https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@intel.com/
> > > > > >
> > > > > > Do you think a rework of this approach would help?
> > > > >
> > > > > No, I think that whole idea is ill-conceived.  As I said above, the
> > > > > hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> > > > > behalf when BHI_CTRL is not advertised to the guest. I don't see any
> > > > > value in predicating this mitigation on guest usage of the short BHB
> > > > > clearing sequence. Just do it.
> > > >
> > > > There are cases where this would be detrimental:
> > > >
> > > > 1. A guest disabling the mitigation in favor of performance.
> > > > 2. A guest deploying the long SW sequence would suffer from two mitigations
> > > >    for the same vulnerability.
> > >
> > > The guest is already getting a performance boost from the newer
> > > microarchitecture, so I think this argument is moot.
> >
> > For a Linux guest this is mostly true. IIRC, there is atleast one major
> > non-Linux OS that suffers heavily from BHI_DIS_S.
> 
> Presumably, this guest OS wants to deploy the long sequence (if it may
> run on SPR and later) and doesn't want BHI_DIS_S foisted on it. I
> don't recall that negotiation being possible with
> MSR_VIRTUAL_MITIGATION_CTRL.

Patch 4/10 of that series is about BHI_DIS_S negotiation. A guest had to
set MITI_CTRL_BHB_CLEAR_SEQ_S_USED to indicate that it isn't aware of the
BHI_DIS_S control and is using the short sequence (ya, there is nothing
about the long sequence). When KVM sees this bit set, it deploys BHI_DIS_S
for that guest.

x86/bugs: Use Virtual MSRs to request BHI_DIS_S
https://lore.kernel.org/lkml/20240410143446.797262-5-chao.gao@intel.com/

