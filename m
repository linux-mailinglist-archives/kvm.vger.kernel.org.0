Return-Path: <kvm+bounces-71859-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFFtH/k0n2m5ZQQAu9opvQ
	(envelope-from <kvm+bounces-71859-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:44:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F1C19BBBA
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3F8443032DCB
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1804B3ECBF9;
	Wed, 25 Feb 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXUZgkId"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EF43D7D77
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041459; cv=none; b=QUQa/+Y3vP8/O20ZnTjKb8sC242BOn4Vl2ZikI2594wLFKqJpqRYgbp6gg6bULcGwHG3QH+pC7pWx5zbB2ULaikRa7YKzPGOj99YD49ZUZoGpjE1tzTXfllJYnFNzslKdx3FKJ93p7vAdnLCFX3lo64BdmlOjhGJwYCEyw1NMwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041459; c=relaxed/simple;
	bh=e8g6K6jqH7yi+J7S+Llf7wJHW3GxzjdSA1XAzbdLd+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VLaGdAXC3IEJZLC+fbdIcZ7iv1gqU+LYbqVT0EeZtHL//RuTGFGTzfDdBu9g0e434q04Oj6fA6B8ZPlJEkTEamo1qjKgw0QW8r7ImI29qRfvutUzecJd9xnEoW6YDLPuhBcEvNrFWcPrOakNySWT/oEDD2NCNmxME7zTCgTfb9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXUZgkId; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso42521546a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 09:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041457; x=1772646257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw6GQL6ZdLBj1XQdIzcZiKvieiwtt1s7FniDgSgRoX4=;
        b=uXUZgkIdnxhqudhwwNwNJyjHnndkQWn+hblQTZ8KYQsYWhSizwej7/C3gXnYRxjVJV
         u1L2BxmH8n92RkO/XHI3Jhq3tpVQXzzao6GQXaSGXagXMgMNJpW2LETBFN0H/slc93Ra
         6X0C1r0y+x2XSxASKGWwTjNvTjdO4uE9jbYf3j2MowoaZXoS14+Ds5i7z6H/cZiVm7/e
         8axmlzAG3+4lfWD11BtVEuFf9THYkwDJFvy1DWFwiW4lNK+vZTuisG5d+709dmE0V0Ia
         jgnMZl2aNLv6/F3XmEmrNOQ8d4Dd5f//7MkHpNVbl1xJRvU06rwZgp1uVKPCZuBBGU+n
         T7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041457; x=1772646257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw6GQL6ZdLBj1XQdIzcZiKvieiwtt1s7FniDgSgRoX4=;
        b=ICyvDqgeYJO9BR0AkHWIC+uOTYlUiER/fo28leXAq/ZkoFYwqCsjdimt0NygtZ2Zeu
         /xYsExeRx37KLVSUscqXBQAqEZ+n2oH8Yr5m1aO7Kw8QmyC1IdZGlrFK7Y3SagoG6FoU
         RquN5H46wRIpxPB7ICabKmziGu7LoSaVc0pFp2wRBl5KEeVATq7DXSyLuNrA/Jlz2c9A
         jX87Hwo6otvSXzVLVRMoDcLeHFuMdBW0QQjGdFecEZZRP/5vufiwNJbe9MhBYHEGiIh+
         A4r7uUJdoJbfsLP824vz9dtP38i4rKver/Z8bVG6kDtCUIKHBfrzhh/FEYPO5N96BPKZ
         zaew==
X-Forwarded-Encrypted: i=1; AJvYcCVy1Ru0C8N1d1IGS/2evOjj5lcV9CybxoTs52XrfqGeSGD1ERMx7v+6xYf58ct6hl6dRKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTZVmoPywFvAePjqHvF90ULHJwO5m65NsIXAb15JK+1zo5BPIl
	/zH07hZ+s5MC33v9sefrPptUS7uLHFEx+oFn7GTlSZLIghTdpfgE0df3f7PRTfWrZiXsMAJJlTp
	27SVFZg==
X-Received: from pjqo2.prod.google.com ([2002:a17:90a:ac02:b0:359:dfa:87b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ccd:b0:34c:99d6:175d
 with SMTP id 98e67ed59e1d1-358ae7e9facmr14240529a91.2.1772041457104; Wed, 25
 Feb 2026 09:44:17 -0800 (PST)
Date: Wed, 25 Feb 2026 09:44:15 -0800
In-Reply-To: <aZ8xje-iM0_9ACie@tycho.pizza>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com> <aZzQy7c8VqCaZ_fE@tycho.pizza>
 <aZ3ntHUPXNTNoyx2@google.com> <aZ8xje-iM0_9ACie@tycho.pizza>
Message-ID: <aZ8077EfpxRGmT-O@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71859-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 40F1C19BBBA
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Tycho Andersen wrote:
> On Tue, Feb 24, 2026 at 10:02:28AM -0800, Sean Christopherson wrote:
> > Hmm, I like the idea of clearing supported_vm_types.  The wrinkle is that "legacy"
> > deployments that use KVM_SEV_INIT instead of KVM_SEV_INIT2 will use
> > KVM_X86_DEFAULT_VM, and probably won't check for SEV and SEV_ES VM types.
> 
> Does that matter?

Yes, but I don't think it matters so much that it's worth dealing with.  For me,
being slightly nicer to userspace doesn't justify the risk of confusing KVM.

> If in the case of CiphertextHiding we would revoke KVM_X86_SEV_VM, users
> already couldn't start a VM anyway in the configuration.
> 
> The firmware update is more tricky, but I don't think you can blame
> the kernel there...

Yeah, that's about where I'm at. 

> > Alternatively, or in addition to, we could clear X86_FEATURE_SEV_ES.  But clearing
> > SEV_ES while leaving X86_FEATURE_SEV_SNP makes me nervous.  KVM doesn't *currently*
> > check for any of those in kvm_cpu_caps, but that could change in the future.  And
> > it's somewhat misleading, e.g. because sev_snp_guest() expects sev_es_guest() to
> > be true.
> > 
> > Given that it doesn't make sense for KVM to actively prevent the admin from upgrading
> > the firmware, I think it's ok if KVM can't "gracefully" handle *every* case.  E.g.
> > even if KVM clears X86_FEATURE_SEV_ES, userspace could have cached that information
> > at system boot. 
> > 
> > > > Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
> > > > unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
> > > > stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
> > > > because making SEV-ES unusable would require a deliberate act from the admin.
> > > 
> > > We know these parameters at module load time so we could unset the
> > > supported bit, but...
> > > 
> > > > "Update firmware" is also an deliberate act, but the side effect of SEV-ES being
> > > > disabled, not so much.
> > > 
> > > since this could be a runtime thing via DOWNLOAD_FIRMWARE_EX at some
> > > point, I guess we need a new RUNTIME_STATUS ioctl or similar. Then the
> > > question is: does it live in /dev/sev, or /dev/kvm?
> > 
> > Ugh.  Yeah, updating supported_vm_types definitely seems like the least-awful
> > option.
> 
> Since firmware update only happens on init right now, I think we can
> add a:
> 
>     int sev_firmware_supported_vm_types();
> 
> that will do the feature detection from the ccp, and merge that with
> the results based on asid assignments during module init.

Ya, I don't have a better idea.  Bleeding VM types into the CCP driver might be
a bit wonky, though I guess it is uAPI so it's certainly not a KVM-internal detail.

> We'll eventually need some callback into KVM to say say "hey the
> firmware got updated here's a new list of vm types".

