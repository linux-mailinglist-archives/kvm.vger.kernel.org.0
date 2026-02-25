Return-Path: <kvm+bounces-71854-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oG4/IJkxn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71854-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:30:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 258AF19B916
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0B6C63028B5E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EAD93E9F83;
	Wed, 25 Feb 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wtg4b+wD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAD127A45C;
	Wed, 25 Feb 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040592; cv=none; b=jo1SnG/nmFJGKX/8OOFuXQsNG6r2ZigX+CPlSjB2eJc8BIO4NRGfuWVYJH4NPzHj4/h+hyaesBcFURu1R8noIU2f+dcBDZZNFU6GxVXA/FeT89pLOWP1ZURdIDixnzhVsOtlaYVGFPDF7JC3Q5CbMZyQDPtl0G2xKxqngbAkYqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040592; c=relaxed/simple;
	bh=0NznGpQd9koR+NDgSzpNiwtG/d8wl3ltVnSIMUxgvZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYEPPc/b2KPVxvlTvZrzTK4aBa/sOTeCl1zy5gA7pHd1SZQNSh3bA1c45Z+Nt4nzHzgdx9otrGQ61PfmRgBIx1tMTNJV45pi+h6/D9mX4n59nt/5n239qHF0gD9wyQ3qerqRLj6AADbLIoJHLv+lb0HFiecf0h4af6zk0Pp6Fe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wtg4b+wD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A7EC116D0;
	Wed, 25 Feb 2026 17:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772040592;
	bh=0NznGpQd9koR+NDgSzpNiwtG/d8wl3ltVnSIMUxgvZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wtg4b+wDK4NGNGRmiAdPyJA/KjY9qWR/MOfihY1W6FP3CfdL3KaVHc80z2ccuYCjr
	 BFlE3OhYPFV3+rFqBGW5jnSZUkiHGWOPPOYbH7RBivQFbDvwe7t8S1Zd0Q+CoOFQUE
	 oIJXZTDifenMlGnyaURNp7wue6ka05mCmRPLe2nsgfjyPPj688AlipKTTrGzLKLbEY
	 gyCYwq1z8xL3B062m/y+O2Q7t/CFqNVuQ4aSCci9y8mfAavTbNH/43Jt/MUvSHLTlF
	 z5jK51B1mKBxva8gtaAvcWhzMLHlWMn8hQnUi08WKiePqDfq2pyDAX0kbzGrY7iYdH
	 8IIa1hQR72WzQ==
Date: Wed, 25 Feb 2026 10:29:49 -0700
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
Message-ID: <aZ8xje-iM0_9ACie@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com>
 <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com>
 <aZzQy7c8VqCaZ_fE@tycho.pizza>
 <aZ3ntHUPXNTNoyx2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3ntHUPXNTNoyx2@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71854-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 258AF19B916
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 10:02:28AM -0800, Sean Christopherson wrote:
> Hmm, I like the idea of clearing supported_vm_types.  The wrinkle is that "legacy"
> deployments that use KVM_SEV_INIT instead of KVM_SEV_INIT2 will use
> KVM_X86_DEFAULT_VM, and probably won't check for SEV and SEV_ES VM types.

Does that matter? If in the case of CiphertextHiding we would revoke
KVM_X86_SEV_VM, users already couldn't start a VM anyway in the
configuration.

The firmware update is more tricky, but I don't think you can blame
the kernel there...

> Alternatively, or in addition to, we could clear X86_FEATURE_SEV_ES.  But clearing
> SEV_ES while leaving X86_FEATURE_SEV_SNP makes me nervous.  KVM doesn't *currently*
> check for any of those in kvm_cpu_caps, but that could change in the future.  And
> it's somewhat misleading, e.g. because sev_snp_guest() expects sev_es_guest() to
> be true.
> 
> Given that it doesn't make sense for KVM to actively prevent the admin from upgrading
> the firmware, I think it's ok if KVM can't "gracefully" handle *every* case.  E.g.
> even if KVM clears X86_FEATURE_SEV_ES, userspace could have cached that information
> at system boot. 
> 
> > > Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
> > > unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
> > > stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
> > > because making SEV-ES unusable would require a deliberate act from the admin.
> > 
> > We know these parameters at module load time so we could unset the
> > supported bit, but...
> > 
> > > "Update firmware" is also an deliberate act, but the side effect of SEV-ES being
> > > disabled, not so much.
> > 
> > since this could be a runtime thing via DOWNLOAD_FIRMWARE_EX at some
> > point, I guess we need a new RUNTIME_STATUS ioctl or similar. Then the
> > question is: does it live in /dev/sev, or /dev/kvm?
> 
> Ugh.  Yeah, updating supported_vm_types definitely seems like the least-awful
> option.

Since firmware update only happens on init right now, I think we can
add a:

    int sev_firmware_supported_vm_types();

that will do the feature detection from the ccp, and merge that with
the results based on asid assignments during module init.

We'll eventually need some callback into KVM to say say "hey the
firmware got updated here's a new list of vm types".

Tycho

