Return-Path: <kvm+bounces-52897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F03DB0A658
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B3471884E13
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0CB2DCF55;
	Fri, 18 Jul 2025 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cG+t1gbV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6BE2DCBE2
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752848659; cv=none; b=NfqaXsp086Qk1g4am/jCd2FAwFeOarRIYx7YI8xmyFesaZyW8xcH4xVwJEKxbeiGummWU7WC9o6OCM5tNb/g4cUzmOBDRvD+iREj2vBtQ8fwybhYeqhn9RTTouRzZq6490FFW+IVvnqhv1CR7PIGgofhjb6Jz/hD4XYDGccAigw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752848659; c=relaxed/simple;
	bh=FFrCa5VooVpyL6t+rp9PLQD687b0bErglenPWh/5Hpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qUXkqXR1hFa7ICawGCmmnqoC8ZD/f7EdR538MHwvUTSAvKspo3iRdfBifsUXShPIb3+vu6WT8BAr9sHp38wmZrH0C4ejPnQu7GvjKJdR1WAjTm16hOngYlY2jrnjnb3KXYpGFdjRJojkvnhH6hyNBSUFJVwMxrsw8/ePAfJOuDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cG+t1gbV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so3199327a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752848657; x=1753453457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bXQCgpJ3ALeYg67rn3jChwNusOdYOZpmwsnTvicwZkE=;
        b=cG+t1gbViyhf00qEwo9DyL3lrmLpbopjT17JddZ/k5QsbUCEtr1UeIJMkFcsuumZV/
         zxEILHayN1tQoYztkpj9hbw2/KA6IYdsQA5mBSUIJ5Yvgwe8ntzfqerG/BHfgswx7XcA
         sRPuDzqb03mWS14XusiXt1WFW2jnhGHlh77dK+E4WD/xZnB29bXYGaqcVu9HxR5EraWB
         GpwcWLJRmfJQydqkKjXrPzEwdKMF1Ctvt05fxQ3+gcXa/bPo0s2edOt30XX1PNorK8HV
         1B/FMSlgd4nNaN19xkYJc43OHChRxmBLK7zjWT3ATVoso7G7mihfgIElafMJyQvdSUsR
         UpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752848657; x=1753453457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bXQCgpJ3ALeYg67rn3jChwNusOdYOZpmwsnTvicwZkE=;
        b=DEDjgDx0pNRToJIoU/rRbNNdEYcfKWZGr1oE6RwAfKI93fpUDcyVTkkBzvXKIHxvK+
         1cioOdDpvvZtnYgQq9/4jH93+2uJsEocg15mJKdzmWIM6Mi+HioPZOrLNsqtxYv/NtN4
         VghF1I8RtxlaAmBa6fQ3kk0Yw7kQyjWFOHeOPqmS8eqapqsHVYmC/jN/7xD47pUNLLGk
         zEeWuIpo90Yu2gGnR3MnKkEbpy+wTjXw7RkDp2lK1TDzdRBpnlvSeK0R1PeTn+11YRH+
         epX4NBn2mZpuxTcXS0xNIThgkGNzuoelx6RRL6XwKaIak5I7amTZWzZqPHX2bo7zshVR
         NwCw==
X-Gm-Message-State: AOJu0Ywdk+1tsQKQ3/FN4vyDq60xL8k+45rXi2u4G8FbQvU3adw08NeG
	dAi63QidhZTTlT+xQaXFY1mvckd/qPLb5pFqmLcSTGXJCSlCM5XZ0/NEecSNusPDCF3MXZt13PT
	Vbjn2tA==
X-Google-Smtp-Source: AGHT+IFMA48gA7eMpiESjVXmxC6/DuagpArlIqkPqyhV38yWM3iTowC/OPY61++IJe7i6kOBC6fMAdYeZUg=
X-Received: from pjee6.prod.google.com ([2002:a17:90b:5786:b0:312:18d4:6d5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5604:b0:31c:38f8:7efb
 with SMTP id 98e67ed59e1d1-31c9f424137mr17837688a91.18.1752848657252; Fri, 18
 Jul 2025 07:24:17 -0700 (PDT)
Date: Fri, 18 Jul 2025 07:24:15 -0700
In-Reply-To: <6dl4vsf3k7qhx2aunc5vdhvtxpnwqp45lilpdsp4jksxtgdu6t@kubfenz4bdey>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740036492.git.naveen@kernel.org> <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
 <aFngeQ5x6QiP7SsK@google.com> <6dl4vsf3k7qhx2aunc5vdhvtxpnwqp45lilpdsp4jksxtgdu6t@kubfenz4bdey>
Message-ID: <aHpZD6sKamnPv9BG@google.com>
Subject: Re: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Naveen N Rao wrote:
> On Mon, Jun 23, 2025 at 04:17:13PM -0700, Sean Christopherson wrote:
> > On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> > > +		if (x2avic_4k_vcpu_supported) {
> > > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
> > > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
> > > +		} else {
> > > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
> > > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
> > > +		}
> > > +
> > > +		pr_info("x2AVIC enabled%s\n",
> > > +			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
> > 
> > Maybe print the max number of vCPUs that are supported?  That way there is clear
> > signal when 4k *isn't* supported (and communicating the max number of vCPUs in
> > the !4k case would be helpful too).
> 
> I'm tempted to go the opposite way and not print that 4k vCPUs are 
> supported by x2AVIC. As it is, there are many reasons AVIC may be 
> inhibited and lack of 4k vCPU support is just one other reason, but only
> for large VMs.

This isn't just about AVIC being inhibited though, it's about communicating
hardware support to the admin/user.  While I usually advocate *against* using
printk to log information, I find SVM's pr_info()s about what is/isn't enabled
during module load to be extremely useful, e.g. as sanity checks.  I (re)load
kvm-amd.ko on various hardware configurations on a regular basis, and more than
once the prints have helped me "remember" which platforms do/don't have SEV-ES,
AVIC, etc, and/or detect that I loaded kvm-amd.ko with the wrong overrides.

> Most users shouldn't have to care: where possible, AVIC will be enabled 
> by default (once that patch series lands). Users who truly care about 
> AVIC will anyway need to confirm AVIC isn't inhibited since looking at 
> the kernel log won't be sufficient. Those users can very well use cpuid 
> to figure out if 4k vCPU support is present.

If there wasn't already an "x2AVIC enabled" print, I would probably lean toward
doing nothing.  But since pr_info("x2AVIC enabled\n") already exists, and has
plently of free space for adding extra information, there's basically zero downside
to printing out the number of supported CPUs.  And it's not just a binary yes/no,
e.g. I would wager most people couldn't state the number of vCPUs supported by
the "old" x2AVIC.

