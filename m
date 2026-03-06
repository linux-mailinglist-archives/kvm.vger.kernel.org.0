Return-Path: <kvm+bounces-73174-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iDSWLylWq2lRcQEAu9opvQ
	(envelope-from <kvm+bounces-73174-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:33:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 201CE22855B
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6FE393067A23
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B375433C51D;
	Fri,  6 Mar 2026 22:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cnRJ93gp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273CF35CB6C;
	Fri,  6 Mar 2026 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772836355; cv=none; b=MG1QV1zitlVNZQjjvo5LIYvk2TWe4RdiThcn3Y4rQBAaJ1/YJnTzMZaOzFkATder6YwjqxL730Cm5AEMGoIV3oW26UWTSbGeetjMrVfcesqMzw35fzBKeVHBVrQtFJFkxhZG+E4t1enW/kW9H35Aqw5zpjz7/0wy+VzZxE11C6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772836355; c=relaxed/simple;
	bh=yYZxP45bgaLJ4KZ2YXjdgt20jbuKKxFCRZLZtTOBqpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6g78FjkY+hJNyNAyIRkjgzk7uZNP1umO/am0d3tRcvhkQP/UZtKNZPA2PhayWGtlkSDw86DGJIM7+WLINPkx5A0fTStDsDLC6VazfgVc+Yn++h6HtN1T4+eFPsllzc/V/nDbVBDv+0+SvXvj8h6s13gHTvS8nUJe2khG/0RZhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cnRJ93gp; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772836352; x=1804372352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yYZxP45bgaLJ4KZ2YXjdgt20jbuKKxFCRZLZtTOBqpM=;
  b=cnRJ93gpju1oqIpPzVQGG6Ws+hC2G1sg33eWOfiqmPfy/Sw+EwXKnQvC
   oFuCv2ZbuJSncyQ2bP2dIAzHbOltG5kqFeFMrWHixHMe8cQsz1ZxcRado
   D3CJnh1vAUY3JdoKG9mEeSjbt25e30Fc35W2safFc51Tz/a8kyljRbw4u
   ZCMR4RHZrXdYGFUoWtA9nxtahj5o/eHv+PVSS63z3BFKyC2t6pHR3Uzq8
   QyF+oSW0/MWhFMXc3XlKfyacW81CDfPYK84EANVlW6Kk5dGBjiB7w5BIh
   zqt+TWTKujOIiiT5Inmt30SJCeEmDyibSMVnc5s6a6ICEettyXcIa3f5c
   w==;
X-CSE-ConnectionGUID: TMJe/TfDQVeuigzsEkInRg==
X-CSE-MsgGUID: SlHoXVV7SmCC+o1CxlwpFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73869075"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="73869075"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:32:31 -0800
X-CSE-ConnectionGUID: NpXJ58BzSSqX7dWFc1mZYw==
X-CSE-MsgGUID: 6hfGAABvQc+me34ph2PK3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="223826445"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:32:30 -0800
Date: Fri, 6 Mar 2026 14:32:25 -0800
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
Message-ID: <20260306223225.l2beapz3nvmqefou@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
X-Rspamd-Queue-Id: 201CE22855B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73174-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.956];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 01:00:15PM -0800, Jim Mattson wrote:
> On Wed, Nov 19, 2025 at 10:19 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > sequence is not sufficient because it doesn't clear enough entries. This
> > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > that mitigates BHI in kernel.
> >
> > BHI variant of VMSCAPE requires isolating branch history between guests and
> > userspace. Note that there is no equivalent hardware control for userspace.
> > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > should execute sufficient number of branches to clear a larger BHB.
> >
> > Dynamically set the loop count of clear_bhb_loop() such that it is
> > effective on newer CPUs too. Use the hardware control enumeration
> > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> 
> I didn't speak up earlier, because I have always considered the change
> in MAXPHYADDR from ICX to SPR a hard barrier for virtual machines
> masquerading as a different platform. Sadly, I am now losing that
> battle. :(
> 
> If a heterogeneous migration pool includes hosts with and without
> BHI_CTRL, then BHI_CTRL cannot be advertised to a guest, because it is
> not possible to emulate BHI_DIS_S on a host that doesn't have it.
> Hence, one cannot derive the size of the BHB from the existence of
> this feature bit.

As far as VMSCAPE mitigation is concerned, mitigation is done by the host
so enumeration of BHI_CTRL is not a problem. The issue that you are
refering to exists with or without this patch.

I suppose your point is in the context of Native BHI mitigation for the
guests.

> I think we need an explicit CPUID bit that a hypervisor can set to
> indicate that the underlying hardware might be SPR or later.

Something similar was attempted via virtual-MSRs in the below series:

[RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@intel.com/

Do you think a rework of this approach would help?

