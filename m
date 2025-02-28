Return-Path: <kvm+bounces-39769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D260FA4A5F5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85E1D189C0DA
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 22:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC041DED48;
	Fri, 28 Feb 2025 22:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONVpTQlg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB9E14375D
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740781943; cv=none; b=aIgp2RPohIpbGmz2EXqj/mEry4vzwl145CzLDPdMtI6hYrjNZ43k3D3nOm6NbPvkYknFo/acVy/fxxOXPgyRBnaw/VDvyZeVUTwaa+wcnjJF2PH1oGxzbOBgOOppEe8kyDlP+gvE7+t3RzxMifQsQsAv4l9rwVbZ5Wnp7CI1UN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740781943; c=relaxed/simple;
	bh=lbrTtqbFv3Whh3RcQpbnY2bGfXxrtaICUrF92VRuHxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jGgEee0XQkOimi/XUxq0wGkKYRB9dAarXIA50b0/fiGZpJsTIdTIbUodL2K7KBF7kZS0fwQpRAysiC9ES44H5C8v+bV1G61102twVZa1RCGKMMwOILqCrEjnpbk49axzYLjUIb1lXog+m7zFbA3Qw5eAO07o475+bF+jUI0Efms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONVpTQlg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22331df540aso77300675ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 14:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740781941; x=1741386741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6E2xuVnec2I+gtyFLC/LUdzxkSAeiHHuFOdb6/52cV4=;
        b=ONVpTQlgjf04N84e3kdHsjlBZuuNP/UpMhIW2s5npOroEiq5y391Rwq5CbkA2DBejB
         9IC2OQeficcbNYrpcSPdihDavBSbRagKT6QLw+OuEkQrPPdcMfxFHt9Jadi6UfsD5W3L
         h1l7ZFLh7wrj/1ocL2+MADLpjCMgir6pGKfz/oyRg23877Q9GGCbwV18/I2+5/dRhGMo
         DHY+o31ReTTXd6MUrMZ9v2s5Nx10fHTD07+qtIPozU83Dicrk0a0/tCQYtGGOcIFaW1r
         0qZU3AFQxw9feY9doY1t70cCtCCrc//XCHrD/PlHl24Pclvy9qjKzz9+kswVz1jIpeF1
         0SCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740781941; x=1741386741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6E2xuVnec2I+gtyFLC/LUdzxkSAeiHHuFOdb6/52cV4=;
        b=EVkMvOcCjpkxgq9XZMXKQAFmFD1xCq+BLDQggjMHVBOZMh/H8SSAazf/HDu0IZ2WuH
         51Rs3c3AUG6EZNnMXlYiVE38eZEMNKTXg0pPV51CIN5Em0Gwnc+DJvJ8UOuhHppU2Qj6
         qPAOuVd3AL1IEJDWDQWm4mTk7jhlBSlClbItgfZXb6epH1X1RX0LtnHDoLf83Wjf50Jk
         rzuQPpJ1WbfI8EbtlF++ehPwq6H7gWxBd7ToN/GnIalzjaDUAKPYjQZyhXBCLBLThA7q
         wHrX4YcpJzqqOay+V7Z52PY9Hm8pVixFeQ7fcUmJjrECqqWkqzTjU86ux5BcLUVTqCip
         gatA==
X-Forwarded-Encrypted: i=1; AJvYcCWczliQ6ainO4JQv+pCvbC/vbb11GYFnSDZb9Mi5j58CA8hFgixmADgrkecZt93Iyvd2xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJuLQVKZDPcxPENcqY9B/pOikBWISsfUJi4tROya2dz02HT5qC
	MFArbRqvl/+AIRbxBhPMnW2pa6++vdjf1E6uGT/3n0OA6RvkaPxgWvpS+NFdm04qm7DCNdzOfV8
	Oow==
X-Google-Smtp-Source: AGHT+IFVdvcpjdF2xOPtOtzaj3lqomK7UUPeWCpb2tFVi/FPCwoBxXIl4PAdRxnS6Na+PT6qTAHHalPbn2E=
X-Received: from pfoo3.prod.google.com ([2002:a05:6a00:1a03:b0:730:8f44:a42b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fae:b0:223:674d:c989
 with SMTP id d9443c01a7336-223692585fbmr79599735ad.41.1740781940758; Fri, 28
 Feb 2025 14:32:20 -0800 (PST)
Date: Fri, 28 Feb 2025 14:32:19 -0800
In-Reply-To: <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740512583.git.ashish.kalra@amd.com> <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
Message-ID: <Z8I5cwDFFQZ-_wqI@google.com>
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 28, 2025, Ashish Kalra wrote:
> Hello Sean,
> 
> On 2/28/2025 12:31 PM, Sean Christopherson wrote:
> > On Tue, Feb 25, 2025, Ashish Kalra wrote:
> >> +	if (!sev_enabled)
> >> +		return;
> >> +
> >> +	/*
> >> +	 * Always perform SEV initialization at setup time to avoid
> >> +	 * complications when performing SEV initialization later
> >> +	 * (such as suspending active guests, etc.).
> > 
> > This is misleading and wildly incomplete.  *SEV* doesn't have complications, *SNP*
> > has complications.  And looking through sev_platform_init(), all of this code
> > is buggy.
> > 
> > The sev_platform_init() return code is completely disconnected from SNP setup.
> > It can return errors even if SNP setup succeeds, and can return success even if
> > SNP setup fails.
> > 
> > I also think it makes sense to require SNP to be initialized during KVM setup.
> 
> There are a few important considerations here: 
> 
> This is true that we require SNP to be initialized during KVM setup 
> and also as mentioned earlier we need SNP to be initialized (SNP_INIT_EX
> should be done) for SEV INIT to succeed if SNP host support is enabled.
> 
> So we essentially have to do SNP_INIT(_EX) for launching SEV/SEV-ES VMs when
> SNP host support is enabled. In other words, if SNP_INIT(_EX) is not issued or 
> fails then SEV/SEV-ES VMs can't be launched once SNP host support (SYSCFG.SNPEn) 
> is enabled as SEV INIT will fail in such a situation.

Doesn't that mean sev_platform_init() is broken and should error out if SNP
setup fails?  Because this doesn't match the above (or I'm misreading one or both).

	rc = __sev_snp_init_locked(&args->error);
	if (rc && rc != -ENODEV) {
		/*
		 * Don't abort the probe if SNP INIT failed,
		 * continue to initialize the legacy SEV firmware.
		 */
		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
	}

And doesn't the min version check completely wreck everything?  I.e. if SNP *must*
be initialized if SYSCFG.SNPEn is set in order to utilize SEV/SEV-ES, then shouldn't
this be a fatal error too?

	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
		return 0;
	}

And then aren't all of the bare calls to __sev_platform_init_locked() broken too?
E.g. if userspace calls sev_ioctl_do_pek_csr() without loading KVM, then SNP won't
be initialized and __sev_platform_init_locked() will fail, no?

> And the other consideration is that runtime setup of especially SEV-ES VMs will not
> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
> KVM setup time.
> 
> This is because qemu has a check for SEV INIT to have been done (via SEV platform
> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>
> So effectively, __sev_guest_init() does not get invoked in case of launching 
> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
> sev_hardware_setup().
> 
> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.

In that case, I vote to kill off deferred initialization entirely, and commit to
enabling all of SEV+ when KVM loads (which we should have done from day one).
Assuming we can do that in a way that's compatible with the /dev/sev ioctls.

