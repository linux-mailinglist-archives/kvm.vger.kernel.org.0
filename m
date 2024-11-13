Return-Path: <kvm+bounces-31789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEAD9C7AFA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12D5D285F6B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09E92038AA;
	Wed, 13 Nov 2024 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCxJqXdi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7016233997
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731522162; cv=none; b=nIfUDhcClVnQnxCGKJ+YpQAYkelk7gglLpyDcH3ZOlqsPigueN5PbYZj3n21TRpXXlgFrNmNluWx8RGyAijY8wFSIs7MoWjnvWJMywMhQz36ovemXZRtz25spqgqogrltPuFUedv/nJoPxG8GAuTdvz6CY6kI4I49DZ5qE/02JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731522162; c=relaxed/simple;
	bh=owvgf1xfhUwmXeGNbhlBFgN1MNaRZnrXUUz7/mLOXlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=stlbwE7H0PKDDGdIQiZa2rokgh/bnf7v5IU41NuO+fyevouPMV7evv10ihuaCC9a7dS8WBlZJR/hy6xCnawqucS+J3M3hglCaZMU7KQwUWpIpfoVDimIoJrLJZqk/rXFv2x0CppsDVCDcsuxUjIW5pZFQtADCB1GFabLMbdTJrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCxJqXdi; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e380e058823so194179276.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 10:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731522160; x=1732126960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=foXo4SwpQ6+tkfr9q/YAIXSpHlhXaZLsZbO7fGNTKRc=;
        b=WCxJqXdiIwuH8lp32Lfn9jYuU/jdCYSoYo/vLp5lXGNgeHZCy5nBBtbuDHJdy+Z3OA
         mufb1hY1dm7cHrGGAWyTIyZaPOd8zxhYsZY5TnHmMq8ABVt/n6RODH2tqhd7pmJVdgN0
         fvXuNC0sgNx7XIzmhVTGHLRK3dlS6V5bifVI1gWYLPrsRETl/4BAU3p6Pg90KI2Hx4dK
         r7GxvFPmOQDMRMZ7f4/YvZpSNm08BlFeHJLVRD9LNTZhod2efiI3iiiR247LUieJ9y49
         rIOBSMztZEKGQNyvEa7AweSFJNsR9+YGQF2vVx5y9yISUrZ+4EtHf3QcnjX6pmhFPBMR
         LrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731522160; x=1732126960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foXo4SwpQ6+tkfr9q/YAIXSpHlhXaZLsZbO7fGNTKRc=;
        b=dDZWYQNdjt/AcrYs28v2Js0RAKIUH+41sZswhfSVbOw5nkSWn3Fdoa8/OawnJPXVsQ
         g7e2HBK/O4FtIrJ2/r6VnFH/cfydB5QwJTsMOMkS8lBV1iescF3WrU1lHb8gEfPSJA/L
         YbKWnDbm33Q8SkO/k4QuPYiWrsDh8f0qhPG2AxyEmvm38UL617dSyahfk18JunOB1V8e
         gWCh5y55m4urZLnW1tZ3E/sBv+nEeJqYshYTtRrQFWYo+ohFo3TaUfHEq31cUrgW0spb
         V4CWCg3RWujqaKurEEkvHiBlGh0L7Lu2cstEYu9hhNDCV+9TR2B5+l0kMtZzFLJDEtaw
         YuHw==
X-Forwarded-Encrypted: i=1; AJvYcCVNv+sGXIJ0p5gFHuOraFDSmcBbi8bJ/YQd5Bjsroz/IOzSzz+6mGGhKWeRjHOlgX1uMoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ35onNw1jU1oj2hcnTbyIsytMuSOpmfiPxsGJHP5aMbAfHq43
	ReUOmvbkHV8DB98dZa2/1uZNLqxeLX6Ecgrvrmf44uDuTDgfbs08+ENErnqa8xSEs6we9pXze7B
	Jhw==
X-Google-Smtp-Source: AGHT+IFDlulUlqQJ4uSoLm5pSTu7Qe8PBX29jVHGo6PIKHEOxVPRJED4+2XYHeYgGpbn2As2bUG/FqkmGqI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:6888:0:b0:e29:9c5:5fcb with SMTP id
 3f1490d57ef6-e380e241492mr3384276.4.1731522160502; Wed, 13 Nov 2024 10:22:40
 -0800 (PST)
Date: Wed, 13 Nov 2024 10:22:38 -0800
In-Reply-To: <308f26c5-d47c-df63-19eb-59ebbf1e16dd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-10-dionnaglaze@google.com> <43be0a16-0a06-d7fb-3925-4337fb38e9e9@amd.com>
 <CAAH4kHasdYwboG+zgR=MaTRBKyNmwpvBQ-ChRY18=EiBBSdFXQ@mail.gmail.com> <308f26c5-d47c-df63-19eb-59ebbf1e16dd@amd.com>
Message-ID: <ZzTubiWtfmNTPlLK@google.com>
Subject: Re: [PATCH v5 09/10] KVM: SVM: Use new ccp GCTX API
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, 
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, Tom Lendacky wrote:
> On 11/12/24 13:33, Dionna Amalie Glaze wrote:
> >>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >>> index cea41b8cdabe4..d7cef84750b33 100644
> >>> --- a/arch/x86/kvm/svm/sev.c
> >>> +++ b/arch/x86/kvm/svm/sev.c
> >>> @@ -89,7 +89,7 @@ static unsigned int nr_asids;
> >>>  static unsigned long *sev_asid_bitmap;
> >>>  static unsigned long *sev_reclaim_asid_bitmap;
> >>>
> >>> -static int snp_decommission_context(struct kvm *kvm);
> >>> +static int kvm_decommission_snp_context(struct kvm *kvm);
> >>
> >> Why the name change? It seems like it just makes the patch a bit harder
> >> to follow since there are two things going on.
> >>
> > 
> > KVM and ccp both seem to like to name their functions starting with
> > sev_ or snp_, and it's particularly hard to determine provenance.
> > 
> > snp_decommision_context and sev_snp_guest_decommission... which is
> > from where? It's weird to me.
> 
> I guess I don't see the problem, a quick git grep -w of the name will
> show you where each is. Its a static function in the file, so if
> anything just changing/shortening the name to decommission_snp_context()

Eh, that creates just as many problems as it solves, because it mucks up the
namespace and leads to discontinuity between the decommission helper and things
like snp_launch_update_vmsa() and snp_launch_finish().

I agree that there isn't a strong need to fixup static symbols.  That said, I do
think drivers/crypto/ccp/sev-dev.c in particular needs a different namespace, and
needs to use it consistently, to make it somewhat obvious that it's (almost) all
about the PSP/ASP.

But IMO, an even bigger mess in that area is the lack of consistency in the APIs
themselves.  E.g. this code where KVM uses sev_do_cmd() directly for SNP, but
bounces through a wrapper for !SNP.  Eww.

	wbinvd_on_all_cpus();

	if (sev_snp_enabled)
		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
	else
		ret = sev_guest_df_flush(&error);

	up_write(&sev_deactivate_lock);


And then KVM has snp_page_reclaim(), but the PSP/ASP driver has snp_reclaim_pages().

So if we want to start renaming things, I vote to go a step further and clean up
the APIs, e.g. with a goal of eliminating sev_do_cmd(), and possibly of making
the majority of the PSP-defined structures in include/linux/psp-sev.h "private"
to the PSP/ASP driver.

> would be better (especially since nothing in the svm directory should
> have a name that starts with kvm_).

+1 to not using "kvm_".  KVM often uses "kvm_" to differentiate globally visible
symbols from local (static) symbols.  I.e. prepending "kvm_" just trades one
confusing name for another.

