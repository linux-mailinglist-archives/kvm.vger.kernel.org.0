Return-Path: <kvm+bounces-70345-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0D7hFCLAhGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70345-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:06:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAE6F4F6D
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 192E6305EC0F
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 16:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4546C436356;
	Thu,  5 Feb 2026 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/WyEK/L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94242EECC;
	Thu,  5 Feb 2026 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770307261; cv=none; b=c2IF1r5NQfGEY3jGy9PcLhF0xaoX2mrOvFiZVKP5tqxwFetAEZYD3nklMweF83Hk9CbWO61ZnDJHn+ijW1ntcvAyFxSuinh9Uoma3DKfcqqXzcJVxxCVOUkYmxBImBIZYo0kmDFgIT1ePwDOrWHKgjDLxyngVycsFIesdPgDhBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770307261; c=relaxed/simple;
	bh=r9Yuf71TUcYKqUYaYV0MLO9h0hwdLoZTaCgO+0DE0yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrlM4dyNKuixrCEG656vZrTUsBmzM21w9eF3wDwPl8rPH5owM6dIJh987otXs4NcWN2V5Gp2NlIefyezS5UML722uoe8/vXZXYLi5Qt4qb9dzcNHBq/z5sGLJWnSwG5HJJn7DjF63EWlFdemDqXYiziJwkflQbr3gn93YbwVW3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/WyEK/L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22B8C4CEF7;
	Thu,  5 Feb 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770307261;
	bh=r9Yuf71TUcYKqUYaYV0MLO9h0hwdLoZTaCgO+0DE0yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/WyEK/Lc1S1aKKJFo3THZVJHM2JxrUzAGWEbnhrkFNBS534OF5/r/7yYE9H26C9t
	 ngtTG+Uz7lWk0HGSvCE1O3MeG7Bvz5hp9c86u7JpWRXV4q+OC3vmOC3g0AXn642Iyw
	 5ZxDr46HpEFRm5tfLPeO8rBiXX28pCbJzmM+MDvI=
Date: Thu, 5 Feb 2026 17:00:57 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, bp@alien8.de, thomas.lendacky@amd.com,
	tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, xin@zytor.com, pbonzini@redhat.com, x86@kernel.org,
	jon.grimm@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Message-ID: <2026020511-filth-promotion-8727@gregkh>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <2026020559-igloo-revolver-1442@gregkh>
 <59781811-a98b-4289-89e4-58e8247241f8@amd.com>
 <2026020546-wrongness-duplex-bccd@gregkh>
 <aYS8MQLcGs08PxYK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYS8MQLcGs08PxYK@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70345-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxfoundation.org:dkim]
X-Rspamd-Queue-Id: ECAE6F4F6D
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 07:50:09AM -0800, Sean Christopherson wrote:
> On Thu, Feb 05, 2026, Greg KH wrote:
> > On Thu, Feb 05, 2026 at 11:40:11AM +0530, Nikunj A. Dadhania wrote:
> > > 
> > > 
> > > On 2/5/2026 11:25 AM, Greg KH wrote:
> > > > On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
> > > >> FRED enabled SEV-ES and SNP guests fail to boot due to the following
> > > >> issues in the early boot sequence:
> > > >>
> > > >> * FRED does not have a #VC exception handler in the dispatch logic
> > > >>
> > > >> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, and
> > > >>   console output triggers a #VC which cannot be handled
> > > >>
> > > >> * Early FRED #VC exceptions should use boot_ghcb until per-CPU GHCBs are
> > > >>   initialized
> > > >>
> > > >> Fix these issues to ensure SEV-ES/SNP guests can handle #VC exceptions
> > > >> correctly during early boot when FRED is enabled.
> > > >>
> > > >> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> > > >> Cc: stable@vger.kernel.org # 6.9+
> > > >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> > > >> ---
> > > >>
> > > >> Reason to add stable tag:
> > > >>
> > > >> With FRED support for SVM here 
> > > >> https://lore.kernel.org/kvm/20260129063653.3553076-1-shivansh.dhiman@amd.com,
> > > >> SVM and SEV guests running 6.9 and later kernels will support FRED.
> > > >> However, *SEV-ES and SNP guests cannot support FRED* and will fail to boot
> > > >> with the following error:
> > > >>
> > > >>     [    0.005144] Using GB pages for direct mapping
> > > >>     [    0.008402] Initialize FRED on CPU0
> > > >>     qemu-system-x86_64: cpus are not resettable, terminating
> > > >>
> > > >> Three problems were identified as detailed in the commit message above and
> > > >> is fixed with this patch.
> > > >>
> > > >> I would like the patch to be backported to the LTS kernels (6.12 and 6.18) to
> > > >> ensure SEV-ES and SNP guests running these stable kernel versions can boot
> > > >> with FRED enabled on FRED-enabled hypervisors.
> > > > 
> > > > That sounds like new hardware support, if you really want that, why not
> > > > just use newer kernel versions with this fix in it?  Obviously no one is
> > > > running those kernels on that hardware today, so this isn't a regression :)
> 
> I disagree, this absolutely is a regression.  Kernels without commit 14619d912b65
> will boot on this "new" hardware, kernels with the commit will not.

That commit added the new FRED feature, which "broke" when it hits real
hardware.  Not really a "regression" in my opinion as obviously it never
worked at all :)

Anyway, I'll let you x86 maintainers here hash that out, just my
thoughts...

thanks,

greg k-h

