Return-Path: <kvm+bounces-70303-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIwhJ9o2hGm+1AMAu9opvQ
	(envelope-from <kvm+bounces-70303-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:21:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C458EEFEC
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1E2E3016902
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEAA352F98;
	Thu,  5 Feb 2026 06:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ta7dQlpb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754313EBF3F;
	Thu,  5 Feb 2026 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770272454; cv=none; b=RjiO7Fa5GH1DKTAUb8dNCA4IklmRBfQ0M/cPb6iQMoA+6gLaD0OxcCd5FeTaPyDVeWMbkFyv/ikWIjwc7lvCttx+2D65q8sPyBvhPh2oKRKBPSkf/vSkR/aWkJ68qnhDwJFHwxaPC2TlixwX64Z1LtUF4eEVn7akK4FbGYd/Y8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770272454; c=relaxed/simple;
	bh=oK10kepsl3jzI90ptFFtk+CXJdtZJT1rBvGVox1Uhho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGdDDgQfbbIeNYsMRq0f+z16pPS5h/j3hkzy+a6vfkzvGqF0Z8LXn4HB9Mx1PDUh8eESmNjGDJMTjjYbhiRFsRYdzooijaaKn2lVQ9DcnJBCdje6oi2rTDJ5aTmM/E6hGZD9Sh0JMbUbUku9iXJEWzcPjQVlLhqkRJCtGYPBdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ta7dQlpb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE5EC4CEF7;
	Thu,  5 Feb 2026 06:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770272454;
	bh=oK10kepsl3jzI90ptFFtk+CXJdtZJT1rBvGVox1Uhho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ta7dQlpbijqktPbEYVCgkwHt6CiHVBj+vWLcEWiRQfVjaZ0iygjjbH4n17L2X9LrV
	 Ta4JxZDN5au0brYCGNd3djXqyGuke5ZgXSSJM1pleCJ6caziaklnauTm00skTyGgLp
	 pV2QBK7kCJcNlpAP5vAWGF8syRf30VC028NLnlV8=
Date: Thu, 5 Feb 2026 07:20:51 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de,
	thomas.lendacky@amd.com, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com,
	seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
	jon.grimm@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Message-ID: <2026020546-wrongness-duplex-bccd@gregkh>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <2026020559-igloo-revolver-1442@gregkh>
 <59781811-a98b-4289-89e4-58e8247241f8@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59781811-a98b-4289-89e4-58e8247241f8@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70303-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,linuxfoundation.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0C458EEFEC
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 11:40:11AM +0530, Nikunj A. Dadhania wrote:
> 
> 
> On 2/5/2026 11:25 AM, Greg KH wrote:
> > On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
> >> FRED enabled SEV-ES and SNP guests fail to boot due to the following
> >> issues in the early boot sequence:
> >>
> >> * FRED does not have a #VC exception handler in the dispatch logic
> >>
> >> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
> >>   console output triggers a #VC which cannot be handled
> >>
> >> * Early FRED #VC exceptions should use boot_ghcb until per-CPU GHCBs are
> >>   initialized
> >>
> >> Fix these issues to ensure SEV-ES/SNP guests can handle #VC exceptions
> >> correctly during early boot when FRED is enabled.
> >>
> >> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> >> Cc: stable@vger.kernel.org # 6.9+
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> ---
> >>
> >> Reason to add stable tag:
> >>
> >> With FRED support for SVM here 
> >> https://lore.kernel.org/kvm/20260129063653.3553076-1-shivansh.dhiman@amd.com,
> >> SVM and SEV guests running 6.9 and later kernels will support FRED.
> >> However, *SEV-ES and SNP guests cannot support FRED* and will fail to boot
> >> with the following error:
> >>
> >>     [    0.005144] Using GB pages for direct mapping
> >>     [    0.008402] Initialize FRED on CPU0
> >>     qemu-system-x86_64: cpus are not resettable, terminating
> >>
> >> Three problems were identified as detailed in the commit message above and
> >> is fixed with this patch.
> >>
> >> I would like the patch to be backported to the LTS kernels (6.12 and 6.18) to
> >> ensure SEV-ES and SNP guests running these stable kernel versions can boot
> >> with FRED enabled on FRED-enabled hypervisors.
> > 
> > That sounds like new hardware support, if you really want that, why not
> > just use newer kernel versions with this fix in it?  Obviously no one is
> > running those kernels on that hardware today, so this isn't a regression :)
> 
> Fair point.
> 
> However, the situation is a bit nuanced: FRED hardware is available now, and
> users running current stable kernels as guests will encounter boot
> failures when the hypervisor is updated to support FRED. While not a traditional
> regression, it creates a compatibility gap where stable guest kernels cannot run
> on updated hypervisors.

Great, then upgrade those guest kernels as they have never been able to
run on those hypervisors :)

> Other option would be to disable FRED for SEV-ES and SNP guest in stable kernel.

That's a choice for the hypervisor vendors to choose.

thanks,

greg k-h

