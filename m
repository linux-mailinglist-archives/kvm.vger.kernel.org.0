Return-Path: <kvm+bounces-52916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA88B0A8F5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA1D11C808DD
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED6B2E6D23;
	Fri, 18 Jul 2025 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D9kR2Z0S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622CF1C862C
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752857875; cv=none; b=lXJAk5y6IX/1XGdDvl4wCzWKNaIhmn1V9l47cWAe9i4V9HWVQc9sJZMmc++Zz9Edx7m2tO/sXQgq7EjkplWWKHg6j/t3GwVVdoWzilwMOfYNqd8HLJ/oBu7TO++7FghnrlcIgsaJ/60EgvUp8DfA4/YE7HDggGXGdB4QvvOjvKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752857875; c=relaxed/simple;
	bh=HFE0w/88w1Lyl/K2smHXTTk3UtGuRTe8feXkgJ+2eSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uxfuZqh5FxDAcBs4cjK0WlVaI299MUKE1Yz6MOr6UqitUeyE5+th17DNfquOqJA+a2Cq5WiP2XALYOySBWgXvO+/uI7SNIl80N6f8Ra46a61Ul1SsWuYWe5hTx0i6cqpwPm5E/DQfVXOYgvK0wvG5s1eYnAG2weyy8Dr2sde/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D9kR2Z0S; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23692793178so18930205ad.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 09:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752857874; x=1753462674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a8JmAFoZFmFF4VrncsXMPRkgu6iDWk7fhLl780SkJ+c=;
        b=D9kR2Z0SyVzKS4u22m8ZGDVCXqJtGjtcXM9vX0M/KCus153itQsYi5eu3C8c2goFUc
         CFTs7ASFR1YHrGH2UeL/7eZfMPeXqRdUQiW4PtYwF8DACnxeoW3xlbVv7xeap1Nz/z2b
         TXg2FW8SUGjHehI1BWABvt3wrZd0s6sbxPhZxU7rVuPu00ZTxq2xC0Z0lDVglsZmP23s
         +zgQ33eXMPOF2oi6l11vjhTQJC3hufrm1wZ8mLJ0IKoAHTH6CrOM23y6QOTuIFhu9CqT
         Ht+40KpO1sC5kaVe3zdv395qJoEGE8TO0vB9heFueyw82BaNMp1IrTTow2PmTFpovkPK
         cBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752857874; x=1753462674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8JmAFoZFmFF4VrncsXMPRkgu6iDWk7fhLl780SkJ+c=;
        b=iL7ClTIOJwYHMOwLoW6ANptUhvlZ5xlBZq0ly0hvcWYFvE3DgTWbnZgqMnW1GMrJJA
         PWfkXnUP5qrpzaHBkzchPn8EyVTxOt7MzLoXBwkXC4qrKPDSBqr7w/t52whdHZxdkrur
         /8fWkko12tPmIMm9Mzka/+DWEs0/vlOhI0VnmfTdOqF+7slZduoeC4dIeULa2qMH4OHs
         yPX5nHhsOX3g+E9P7e2yj8DsT/Oib1tSZ+yZ2dK59w2X2+uRXUA5FSt3qERG8qWLHhKP
         oSLj0csnPoqbUuDkTGjqhBaq/WDPWXJ//VCz3DIoN8EQYwjWpz1i/rISNQqOT5v1hnoW
         VdBw==
X-Forwarded-Encrypted: i=1; AJvYcCVt8+peTCTmhbIdgHwiHlLAux7mQbNIW9wadh4x4v7eor4BRXmj6fgLk7jCJk4RzQ7e5IA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpmQbln+yr4uhS0KApyA24i+vmaEYfcJ+YerKpRGPzQWRDij87
	84aNOoWCzgz/sS5Jow6f2IzOQmkZNNrdKBn/wnB4tmChim40cPJ16Vv0emk/MBxmrHJKizraypd
	42HuD2w==
X-Google-Smtp-Source: AGHT+IF7xn00jpbk8G2lQKjDoF2AXEZJ1VQJGfmVYlK0/PKYwzHv3a1zuyVCPoIwNei98xvSRwV+sSXMHSM=
X-Received: from pjyr8.prod.google.com ([2002:a17:90a:e188:b0:311:4bc2:3093])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:84c:b0:23e:3c33:6be8
 with SMTP id d9443c01a7336-23e3c336f4bmr36340205ad.8.1752857873730; Fri, 18
 Jul 2025 09:57:53 -0700 (PDT)
Date: Fri, 18 Jul 2025 09:57:52 -0700
In-Reply-To: <2d787a83-8440-adb1-acbd-0a68358e817d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716055604.2229864-1-nikunj@amd.com> <2d787a83-8440-adb1-acbd-0a68358e817d@amd.com>
Message-ID: <aHp9EGExmlq9Kx9T@google.com>
Subject: Re: [PATCH v2] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, Michael Roth <michael.roth@amd.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 16, 2025, Tom Lendacky wrote:
> On 7/16/25 00:56, Nikunj A Dadhania wrote:
> > ---
> >  arch/x86/kvm/svm/sev.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 95668e84ab86..fdc1309c68cb 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -406,6 +406,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> >  	struct sev_platform_init_args init_args = {0};
> >  	bool es_active = vm_type != KVM_X86_SEV_VM;
> > +	bool snp_active = vm_type == KVM_X86_SNP_VM;
> >  	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
> >  	int ret;
> >  
> > @@ -424,6 +425,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> >  	if (unlikely(sev->active))
> >  		return -EINVAL;
> >  
> > +	if (snp_active && data->ghcb_version && data->ghcb_version < 2)
> > +		return -EINVAL;
> > +
> 
> Would it make sense to move this up a little bit so that it follows the
> other ghcb_version check? This way the checks are grouped.

Yes, because there's a lot going on here, and this:

  data->ghcb_version && data->ghcb_version < 2

is an unnecesarily bizarre way of writing

  data->ghcb_version == 1

And *that* is super confusing because it begs the question of why version 0 is
ok, but version 1 is not.  And then further down I see this: 

	/*
	 * Currently KVM supports the full range of mandatory features defined
	 * by version 2 of the GHCB protocol, so default to that for SEV-ES
	 * guests created via KVM_SEV_INIT2.
	 */
	if (sev->es_active && !sev->ghcb_version)
		sev->ghcb_version = GHCB_VERSION_DEFAULT;

Rather than have a funky sequence with odd logic, set data->ghcb_version before
the SNP check.  We should also tweak the comment, because "Currently" implies
that KVM might *drop* support for mandatory features, and that definitely isn't
going to happen.  And because the reader shouldn't have to go look at sev_guest_init()
to understand what's special about KVM_SEV_INIT2.

Lastly, I think we should open code '2' and drop GHCB_VERSION_DEFAULT, because:

 - it's a conditional default
 - is not enumerated to userspace
 - changing GHCB_VERSION_DEFAULT will impact ABI and could break existing setups
 - will result in a stale if GHCB_VERSION_DEFAULT is modified
 - this new check makes me want to assert GHCB_VERSION_DEFAULT > 2

As a result, if we combine all of the above, then we effectively end up with:

	if (es_active && !data->ghcb_version)
		data->ghcb_version = GHCB_VERSION_DEFAULT;

	BUILD_BUG_ON(GHCB_VERSION_DEFAULT != 2);

which is quite silly.

So this?  Completely untested, and should probably be split over 2-3 patches.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..f068cd466ae3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,6 @@
 #include "trace.h"
 
 #define GHCB_VERSION_MAX       2ULL
-#define GHCB_VERSION_DEFAULT   2ULL
 #define GHCB_VERSION_MIN       1ULL
 
 #define GHCB_HV_FT_SUPPORTED   (GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
@@ -405,6 +404,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 {
        struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
        struct sev_platform_init_args init_args = {0};
+       bool snp_active = vm_type == KVM_X86_SNP_VM;
        bool es_active = vm_type != KVM_X86_SEV_VM;
        u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
        int ret;
@@ -418,7 +418,18 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        if (data->vmsa_features & ~valid_vmsa_features)
                return -EINVAL;
 
-       if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active && data->ghcb_version))
+       if (!es_active && data->ghcb_version)
+               return -EINVAL;
+
+       /*
+        * KVM supports the full range of mandatory features defined by version
+        * 2 of the GHCB protocol, so default to that for SEV-ES guests created
+        * via KVM_SEV_INIT2 (KVM_SEV_INIT forces version 1).
+        */
+       if (es_active && !data->ghcb_version)
+               data->ghcb_version = 2;
+
+       if (snp_active && data->ghcb_version < 2)
                return -EINVAL;
 
        if (unlikely(sev->active))
@@ -429,15 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        sev->vmsa_features = data->vmsa_features;
        sev->ghcb_version = data->ghcb_version;
 
-       /*
-        * Currently KVM supports the full range of mandatory features defined
-        * by version 2 of the GHCB protocol, so default to that for SEV-ES
-        * guests created via KVM_SEV_INIT2.
-        */
-       if (sev->es_active && !sev->ghcb_version)
-               sev->ghcb_version = GHCB_VERSION_DEFAULT;
-
-       if (vm_type == KVM_X86_SNP_VM)
+       if (snp_active)
                sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
        ret = sev_asid_new(sev);
@@ -455,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
        }
 
        /* This needs to happen after SEV/SNP firmware initialization. */
-       if (vm_type == KVM_X86_SNP_VM) {
+       if (snp_active) {
                ret = snp_guest_req_init(kvm);
                if (ret)
                        goto e_free;

