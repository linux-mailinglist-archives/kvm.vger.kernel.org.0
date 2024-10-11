Return-Path: <kvm+bounces-28640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BADCC99A893
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 18:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 596331F2285C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE40198E6E;
	Fri, 11 Oct 2024 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gzNcBMM4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057798121F
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728662694; cv=none; b=GCwaNLhF3+HRcCBkff9tghh7NK9oP6bNEl4jK37DKbbOnwCmSJz4EPMkuAsf4Sh1+NmuY+KYHGgUBr8UD7yuTl/3pKJHMbNTYCpgoESInMEB3gu97ND6tr8uPu5oZ8CIh8UdnDpmqJgDbCnkrdHcsYCJ5v+tRZj04boHhH3GYss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728662694; c=relaxed/simple;
	bh=/WvOYSc1S4lLGzVHzV0yvKIKVV854XtzSnHOuroJvCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JFk9fmk7qkylh+LSwmoaErZ3jeA7/BNkN6w+2/SPVAyhq/xv7NfxxGZxdt702mfBWJ6IVnd9/xOjDK+FX/38+kiAafHWnAKTUfqRopFw62sthvyWJdauy9q+OSRvJPxCwcnq9hwEZ6YxLmq8BjZy5pMiS56vzclrzJH/z2hXy4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gzNcBMM4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e32f43c797so20517207b3.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 09:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728662692; x=1729267492; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aTr2NdjN0dv7LipVyeTPEwovi9SHaz0obBqhvYr++Oc=;
        b=gzNcBMM4TN6Nrc4/633uTrsGvQ/7HbUSRo6gC8GbnlZi+CB86X2gdOG6NEAnqVXYWm
         9qeuEssDjf7BM5+D7q5Mqa8wIR5vrMtULt103nz2cgNJe0Kqrs6UkLYLW1L+KBrqa9TE
         u14Ou8Ckf2NsLfbAtPMZ3Z0e/lehdgig8LY6yDNWJqvhAi5MttucKN24r9brs8U/+Gcx
         r9omklaY69Hs6kAclRTHcGcIdjBAZA8l2X3XG/axDkVLq1u6uZz7Z6cZqSqNr7w8xVrD
         1YmPZRPxEFYf9BZ9uFWztqJTfSBBvC8eObrbYuCDk6m6M/CpXxbXktFr4NvV+7/bBVlS
         +VGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728662692; x=1729267492;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aTr2NdjN0dv7LipVyeTPEwovi9SHaz0obBqhvYr++Oc=;
        b=MdM3+DFbAB9P/ThhuH1T5CIWUwYI3od8UTdDUQJYshAKPCILU9bW9tPZ9jR+Lbm/Kx
         Rsjdaqss3FNgGbCqCAdxwPsQwImEB9QHWfQvUcnJ1YuSNIGcouQNQMCEEpuR5Fi2JsOu
         482OBrXWeAL0oYIhvrvZ/MVTHUUsjZ7WDFIN4B29vIQVIc43Zv30dlUoS53Dj0kHeolb
         uQN9yDs6o0APrNncO58O3M9MMQkhfT1HtVugwb8Vn9WP2KDpCNaNreWpFBSjh7jbT7FX
         tuKHysG33ToeieUrBTMtwlooZ4xITVNMt2qJMhnCXwOj3hNhyaHwyxKqOTs6cctYq0cB
         hrCA==
X-Forwarded-Encrypted: i=1; AJvYcCW0+kJhdQ9Qs+C1pBu5K8O/9gTaQ4XoAiHCAVr4VHISgDQdzP4OXUO0CATvks3sycolka8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXrKQNmiTG7eucOr4jZDpR9YEnU29mZqIIAKJymbSLuwMRo9oV
	f0DaOsjKqZf56BR7tYSrZx8Lh+lfVd6ZtiKbjzEljagwSCRPULgyKOdEcBpBWK65d79jKpzM3TC
	Paw==
X-Google-Smtp-Source: AGHT+IEFPFvz0vBCZ+g1VXJWRI0wYgSDpPxyfmUPvTa83pFlFfSeBq9osRJtahZ4BOBwU65AgtshdTp74Lo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6887:b0:6e2:ac0a:8982 with SMTP id
 00721157ae682-6e32f07e518mr2515757b3.0.1728662691997; Fri, 11 Oct 2024
 09:04:51 -0700 (PDT)
Date: Fri, 11 Oct 2024 09:04:50 -0700
In-Reply-To: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com> <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
Message-ID: <ZwlMojz-z0gBxJfQ@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 02, 2024, Ashish Kalra wrote:
> Hello Peter,
>=20
> On 10/2/2024 9:58 AM, Peter Gonda wrote:
> > On Tue, Sep 17, 2024 at 2:17=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.=
com> wrote:
> >> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev=
.c
> >> index 564daf748293..77900abb1b46 100644
> >> --- a/drivers/crypto/ccp/sev-dev.c
> >> +++ b/drivers/crypto/ccp/sev-dev.c
> >> @@ -73,11 +73,27 @@ static bool psp_init_on_probe =3D true;
> >>  module_param(psp_init_on_probe, bool, 0444);
> >>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initi=
alized on module init. Else the PSP will be initialized on the first comman=
d requiring it");
> >>
> >> +static bool cipher_text_hiding =3D true;
> >> +module_param(cipher_text_hiding, bool, 0444);
> >> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable =
Cipher Text Hiding");
> >> +
> >> +static int max_snp_asid;
> >> +module_param(max_snp_asid, int, 0444);
> >> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Te=
xt Hiding");
> > My read of the spec is if Ciphertext hiding is not enabled there is no
> > additional split in the ASID space. Am I understanding that correctly?
> Yes that is correct.
> > If so, I don't think we want to enable ciphertext hiding by default
> > because it might break whatever management of ASIDs systems already
> > have. For instance right now we have to split SEV-ES and SEV ASIDS,
> > and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
> > enable ASIDs on a system.
>=20
> My thought here is that we probably want to enable Ciphertext hiding by
> default as that should fix any security issues and concerns around SNP
> encryption as .Ciphertext hiding prevents host accesses from reading the
> ciphertext of SNP guest private memory.
>=20
> This patch does add a new CCP module parameter, max_snp_asid, which can b=
e
> used to dedicate all SEV-ES ASIDs to SNP guests.
>=20
> >
> > Also should we move the ASID splitting code to be all in one place?
> > Right now KVM handles it in sev_hardware_setup().
>=20
> Yes, but there is going to be a separate set of patches to move all ASID
> handling code to CCP module.
>=20
> This refactoring won't be part of the SNP ciphertext hiding support patch=
es.

It should, because that's not a "refactoring", that's a change of roles and
responsibilities.  And this series does the same; even worse, this series l=
eaves
things in a half-baked state, where the CCP and KVM have a weird shared own=
ership
of ASID management.

I'm ok with essentially treating CipherText Hiding enablement as an extensi=
on of
firmware, e.g. it's better than having to go into UEFI settings to toggle t=
he
feature on/off.  But we need to have a clear, well-defined vision for how w=
e want
this all to look in the end.=20

