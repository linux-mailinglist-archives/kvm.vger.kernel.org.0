Return-Path: <kvm+bounces-71535-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MELJFJ3SnGkJLAQAu9opvQ
	(envelope-from <kvm+bounces-71535-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:20:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CFB17E31C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 15ED4304CEAA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B273793CF;
	Mon, 23 Feb 2026 22:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfEgEKgI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C2833120E;
	Mon, 23 Feb 2026 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884750; cv=none; b=O7n8vWo1pC0u7aT/FNplNR7egzwOgwjVcv8qHhQlfR9J55hU3K/qOHkmoeUVSJZCQ4qbWgK8b1w95u2Qrayuf0W9DtwCT2ANIbYy2xKCe8ugnuVO8b3lCzD+c8zb3xpotiI3ai1DEwlcM8+YjHQzQfTVY9ZOH9LW+z30nZSSQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884750; c=relaxed/simple;
	bh=OWub5nswDSi5TmwvNoO5gqG24elF/8q8aeObIUkJA4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ax2nuHAn1vzWQB03HdpRDqPDlXcFL7MdReDDAs2VQ0gd3Mwi3HeE+61/MU+1mVBUFqppB+Ob4b0R/pj5FFf4rl/aS8wk9ohygaSF/voUXbHyCbdMgFg1OSOUS9C8Ki5kYlwv2IWMwj2O916cl5mSyMTaSo9QbId7iHoxFfppK7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfEgEKgI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A63C116C6;
	Mon, 23 Feb 2026 22:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771884750;
	bh=OWub5nswDSi5TmwvNoO5gqG24elF/8q8aeObIUkJA4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfEgEKgIgvC3Jji1an1FpWaex/z5nDC54A+AUXpkkhfqcHKobfA5Pmrie+/VvSNnU
	 sgbxEuw4L6rczNTS7CL/JR1n6wfEQtvduOfpiKAdg+l5tYmb3c/apftlYdTfi3EJch
	 rS5CScEr7zigIj+gK8qetYHABlopcLeeQU3oRCDMx12BAdanu/rCWG982BJSP5K6De
	 W+nLpS5spMDLfY/mrGoEuBi3LnFLhIz9jXjbr69Rs5+admL1I3ohmLuT/QHr101u3q
	 bByQvLlvgPuFOeOHuqoDfT+klN1QcxpjuASNXXjigx6nYhib7QJjMPXmHbENFhN0f9
	 wNBL1dnLWDYtg==
Date: Mon, 23 Feb 2026 15:12:27 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
Message-ID: <aZzQy7c8VqCaZ_fE@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com>
 <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZyLIWtffvEnmtYh@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71535-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tycho.pizza:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:url]
X-Rspamd-Queue-Id: 60CFB17E31C
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 09:15:13AM -0800, Sean Christopherson wrote:
> On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > > > +	/*
> > > > +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> > > > +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> > > > +	 * check the underlying firmware error for this case.
> > > > +	 */
> > > > +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> > > > +					 &vcpu);
> > > 
> > > If there's a legimate reason why an SEV-ES VM can't be created, then that needs
> > > to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
> > > of ASIDs due to CipherTextHiding or something?
> > 
> > Newer firmware that fixes CVE-2025-48514 won't allow SEV-ES VMs to be
> > started with SNP enabled, there is a footnote (2) about it here:
> > 
> > https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> > 
> > Probably should have included this in the patch, sorry.
> > 
> > > Throwing a noodle to see if it sticks is not an option.
> > 
> > Sure, we could do some firmware version test to see if it's fixed
> > instead? Or do this same test in the kernel and export that as an
> > ioctl?
> 
> Uh, no idea what would be ideal, but there absolutely needs to be some way to
> communicate lack of effective SEV-ES support to userspace, and in a way that
> doesn't break userspace.

Just to clarify, by "doesn't break userspace" here you mean that we
shouldn't revoke the SEV_ES bit from the list of supported VM types
once we've exposed it? Or you mean preserving the current behavior of
CPU supports it => bit is set?

> Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
> unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
> stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
> because making SEV-ES unusable would require a deliberate act from the admin.

We know these parameters at module load time so we could unset the
supported bit, but...

> "Update firmware" is also an deliberate act, but the side effect of SEV-ES being
> disabled, not so much.

since this could be a runtime thing via DOWNLOAD_FIRMWARE_EX at some
point, I guess we need a new RUNTIME_STATUS ioctl or similar. Then the
question is: does it live in /dev/sev, or /dev/kvm?

Tycho

