Return-Path: <kvm+bounces-32220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D57F9D43A7
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 22:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D2D51F22A29
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE911C07F9;
	Wed, 20 Nov 2024 21:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nR6Tdwwc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1455B16130B
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732139626; cv=none; b=SMh9zefUOBOkEmNUaRJSe4oec0gd95ThepA2nzUfg3LMZykDOzyxYTlIS9m/L4K9mTjwR5039ZyxiQJToGMS++huQkdLjDnPSVe5XrWB7gnTs3/J4X4+w0S7177INshC8Q+vUAsu4WPNYIjsfigCKfvKlxQGEvBNZ4VGcycDHGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732139626; c=relaxed/simple;
	bh=r/VcHayKG4EaOZI8wo3ko4simcXIJKTk2WkBMfnIa5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q9c97e/RAcx/FIsxup6xXwfvXlOrRlveF1qTjgRq2kbaq679zWMOWZcaL4xCrlHUOc/PmvYFeC4pSbyLqCISZ0++Cs+QECWjEy1zWt9ufOKakkLMO8nDyaTK6x0UCNZY/3FtYxfUenVnBVsPxw5cc9FhlgBQ3A89a2GriQ1/ePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nR6Tdwwc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e388f173db4so356188276.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 13:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732139624; x=1732744424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP9uLmhESgaddk7OpYGm45ZV5lLwiTS6B5XdgU7dFY=;
        b=nR6TdwwcVlNYiN+XzdHpJcYmiXEvN7vVrlvIRK09BUPxQlwCB4Bs4Z6UDvotL+ohNE
         w6QQftMa1TVqQK1cTCTQFkhbkLOgrgy1MLYDxCnk57y3sMtLg1QcYcIzsWzItWneEA/s
         RjJg7rS1kToT51iZPH1CkHLDeFxbMPJCxRXtZDzYWi8dri2JdixXJSLHgRJqhbokrNBO
         qa3qqIikYrRBgxepZEF1mvbPegJ4hTlCppIrBZSr1wwC9sSQHLZJWQw9p2/5sQ8A/Q7q
         TrwpNDc5ce5dKKij1RaAw1Y9lyPEmuDcZsMFmEGR33FwX3wUp+RCFRRJTpyCJSl4Prxg
         WZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732139624; x=1732744424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP9uLmhESgaddk7OpYGm45ZV5lLwiTS6B5XdgU7dFY=;
        b=XkB78yIUUdbxfkqKd577632UJhlB71kxXUGlZfUs84lZLDuH3Lw/pRKdu3cVcW/kP9
         ceHJwYWxpvP4YsTE7YYSVFoSogszRcoUXBkyOWnLMq9+e+0Avtot2PoRn8bOy91bFvyr
         KXbEszIkzdXCV1qsxqLSe3Oj//c934sOfWTPZk3ofv7Y+0ZDVasGLDzdTEQloK45KWxV
         3CdHRTCxXkXLY4v71SkcwsDGW840b2XuFMGdMlaYjQrf17RWSffr3+Fb6ikPkFdE5bOo
         ZKLKL8PaPdlc+8DHSqSCpjcLV6b+qsyLYMh7hCUadayP6sk+NIHHk2l29kqU7ZPKalgz
         aeCA==
X-Forwarded-Encrypted: i=1; AJvYcCXaatwbcPMRqf2N8oR5iQXtbjHVtH7Pvwmv5eDic6xK/+u8I/U8PRIc3a8eGQLO5F2zaaI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yylng/eTXdOaS3/Vb1bOtlfLYWZa4R47HcNdFRUm+qXx3KyCaux
	61tFccQSK4fxAE1+6+n18E9qfuzCQi87DJg960HAur41GVy7zkvSUfk4CvOmIGxo8DzQKyHkx1I
	liQ==
X-Google-Smtp-Source: AGHT+IGffkcftOgF2KIRVjjRpawSwB9GtSSiFJjON/BGaimJ3oaflhdxoE6c2aPgB0fEGghARktE6MhGvsI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d601:0:b0:e30:d445:a7c with SMTP id
 3f1490d57ef6-e38cb5470c0mr1664276.1.1732139623994; Wed, 20 Nov 2024 13:53:43
 -0800 (PST)
Date: Wed, 20 Nov 2024 13:53:42 -0800
In-Reply-To: <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com> <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com>
Message-ID: <Zz5aZlDbKBr6oTMY@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 19, 2024, Ashish Kalra wrote:
> On 10/11/2024 11:04 AM, Sean Christopherson wrote:
> > On Wed, Oct 02, 2024, Ashish Kalra wrote:
> >> Yes, but there is going to be a separate set of patches to move all ASID
> >> handling code to CCP module.
> >>
> >> This refactoring won't be part of the SNP ciphertext hiding support patches.
> > 
> > It should, because that's not a "refactoring", that's a change of roles and
> > responsibilities.  And this series does the same; even worse, this series leaves
> > things in a half-baked state, where the CCP and KVM have a weird shared ownership
> > of ASID management.
> 
> Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX
> patches got posted in the meanwhile and that had additional considerations of
> moving SNP GCTX pages stuff into the PSP driver from KVM and that again got
> into this discussion about splitting ASID management across KVM and PSP
> driver and as you pointed out on those patches that there is zero reason that
> the PSP driver needs to care about ASIDs. 
> 
> Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets
> involved with ASIDs as CTH feature has to be enabled as part of SNP_INIT_EX
> and once CTH feature is enabled, the SEV-ES ASID space is split across
> SEV-SNP and SEV-ES VMs. 

Right, but that's just a case where KVM needs to react to the setup done by the
PSP, correct?  E.g. it's similar to SEV-ES being enabled/disabled in firmware,
only that "firmware" happens to be a kernel driver.

> With reference to SNP GCTX pages, we are looking at some possibilities to
> push the requirement to update SNP GCTX pages to SNP firmware and remove that
> requirement from the kernel/KVM side.

Heh, that'd work too.

> Considering that, I will still like to keep ASID management in KVM, there are
> issues with locking, for example, sev_deactivate_lock is used to protect SNP
> ASID allocations (or actually for protecting ASID reuse/lazy-allocation
> requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
> (DEACTIVATE). Moving ASID management stuff into PSP driver will then add
> complexity of adding this synchronization between different kernel modules or
> handling locking in two different kernel modules, to guard ASID allocation in
> PSP driver with VM destruction in KVM module.
> 
> There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data)
> which gets referenced during the ASID free code path in KVM. It just makes it
> simpler to keep ASID management stuff in KVM. 
> 
> So probably we can add an API interface exported by the PSP driver something
> like is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid()

What about adding a cc_attr_flags entry?

