Return-Path: <kvm+bounces-43118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD94FA84FFE
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 01:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD08A1BA3BD7
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8E3211A3C;
	Thu, 10 Apr 2025 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3w9VnE1a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BE61E520D
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 23:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744326857; cv=none; b=QMfXMLPtXUI2TKkVtzmWKtOk2y34bY+WFhumlogqT9Rpqkgb/N+ZZp4Cq9ZXfIjP6D7JLT6IDWYsckjcbeAunebDxvh+5il3kMLo0KpJc/uz2iZuMag8hE7lSS8tWq4o1Bu+1R831ZDzruNBbXibm1GDJtdJoKxJ/fgn8qLrngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744326857; c=relaxed/simple;
	bh=qkSaapK883t5uoz1lvxJW+LFO8V1ykXIfUoWpx6uTiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s4X+g2bYniLn4OzM9549+8uQAM+ptkKeO629c8js55d1OBj9xuWD8Ry+y3EMM8jgtpFS0qJB44kvbRGGjLpTpaoyZza5n59bkgWXoBIjnXmqvaHNSAo5Ovtmy6OWdmuX11isuYMYFKN8CC+du3oLKS2EcfBHPdvzchqdmqBUTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3w9VnE1a; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2242ade807fso21444125ad.2
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 16:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744326855; x=1744931655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1vAriw4t6psV6Mnw805zp91Lfa95WMa8Ue+6gI9hvg=;
        b=3w9VnE1aLIydknwqbGBT+0NCitc1mzWD6fOzCTrjSMNZ6A7TrdFZCc5+DiNymslvSX
         w5be8lmc4kuPy/3m3MB1U3vghMJlCUXDKv+wv89HGP5NPSQ9pSHAJ6SvDxSOacPwoYhq
         9mc9KVQNW1qr5PQl7xb1NyDt0mQZXOYWBxnPvVS4jnkIUA7d90U5XU96Hu23psLQPjig
         EYuAFXVNqN4urtjPP6XIoJp3865xn82fu6KwY+aMfPsO3GPAZBVAaEsW1ZdPNHheYvyV
         17n4SPD5r9egNyaLp5I5IrLWImNDZ32Yst4NRvj79kcnqC6wdyXnKbA5u1qkYu5OuLZQ
         f0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744326855; x=1744931655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1vAriw4t6psV6Mnw805zp91Lfa95WMa8Ue+6gI9hvg=;
        b=Ca+KUb+VLCh1+hn4lgHcInGCRMlOH28wzAhRyr477jUc7HYtN4J2YR4I+UCYb6Tzpb
         QfbgNp/m/Hn9eUvZOfM1XIQRtsn00e08p5jNsHkN6p/QkTu1Xqj3MTI5ZdvTDMJStK/R
         AZc+JCe87Fsf/qKu2AvoTrPP+175zwixrFy9f10MUOwtmsEXuEqJvnBRvCruAEq85HQV
         d6B8HNy6vYyvQq4NfwUAWhAXxQvgUg+QMM+AjcEFeW2S9vSv/twls6RkIVtqx6GEVQen
         pZa0duA99aqs0RombwT1Thy90jjvS2qvv29/2pVVA8ZmPT+2rLiFygbIJR16exCgc2B6
         5+kA==
X-Gm-Message-State: AOJu0Yzi6BuI8bLXmX3Iye4P8jhjCyfNDX8ihUanfwkmNq8IBG4yzkqx
	t3gabGj8oTQbpGEGAcRXxNCmoJ1BuDW/1nFUuQwygDmlALQFq1E8A5pyPdFpRe88WWdiFha/Xpn
	/zw==
X-Google-Smtp-Source: AGHT+IFg0gbNaQKaAA8ABHV+MYR/T02bvHSkVwnlDKV72fFVsEdr+va1slPpwXWKPkQkEaGi6W/80WLhdxE=
X-Received: from pleg18.prod.google.com ([2002:a17:902:e392:b0:223:f59e:ae50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19cc:b0:224:1074:638e
 with SMTP id d9443c01a7336-22bea4ffa37mr8206525ad.52.1744326854888; Thu, 10
 Apr 2025 16:14:14 -0700 (PDT)
Date: Thu, 10 Apr 2025 16:14:13 -0700
In-Reply-To: <a06ed3bf-b8ac-15b7-4d46-306c48b897ca@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1742477213.git.thomas.lendacky@amd.com> <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
 <a06ed3bf-b8ac-15b7-4d46-306c48b897ca@amd.com>
Message-ID: <Z_hQxXtLaB_OTJFh@google.com>
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Tom Lendacky wrote:
> On 3/20/25 08:26, Tom Lendacky wrote:
> > An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
> > policy allows debugging. Update the dump_vmcb() routine to output
> > some of the SEV VMSA contents if possible. This can be useful for
> > debug purposes.
> > 
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c | 13 ++++++
> >  arch/x86/kvm/svm/svm.h | 11 +++++
> >  3 files changed, 122 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 661108d65ee7..6e3f5042d9ce 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> 
> > +
> > +	if (sev_snp_guest(vcpu->kvm)) {
> > +		struct sev_data_snp_dbg dbg = {0};
> > +
> > +		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
> > +		if (!vmsa)
> > +			return NULL;
> > +
> > +		dbg.gctx_paddr = __psp_pa(sev->snp_context);
> > +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
> > +		dbg.dst_addr = __psp_pa(vmsa);
> > +
> > +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
> 
> This can also be sev_do_cmd() where the file descriptor isn't checked.
> Since it isn't really a user initiated call, that might be desirable since
> this could also be useful for debugging during guest destruction (when the
> file descriptor has already been closed) for VMSAs that haven't exited
> with an INVALID exit code.
> 
> Just an FYI, I can change this call and the one below to sev_do_cmd() if
> agreed upon.

Works for me.  Want to provide a delta patch?  I can fixup when applying.

