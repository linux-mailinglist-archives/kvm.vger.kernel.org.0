Return-Path: <kvm+bounces-57726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E68B5982E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AC8F3B15E1
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5127431D740;
	Tue, 16 Sep 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bJ1G0SMi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904C31D364
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030719; cv=none; b=qCeV1AzTQbKg29plwt84bjo/KXutflAsuW86mwKCr9IdihBDQkZzfe/6Obj33QEz/glcOSnwY+G7PUdnAWpey7G9i57sATQ69DO6U1IavyPaa9O7BcKs5e1pMel9VnGBLXsVpG/psqUZvDpw2GGZSlo8dovRsrSNNp1lLvFSCEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030719; c=relaxed/simple;
	bh=aikffUtOfR8xKoPHUDMLQ7eMk2xQRnxmQsuttZn7zvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ObAYULqI88CjGdM1rsZ5kt4PfGuMc2wM1BSJu9pKbuuuC7JsT71ziEvFA7AMRlebX7wcqqTyOSlNLlFnfezlZvYMgp+D3SILAyQBW4oN9IFcHlEv2g3BILSun76RyBoMZjRtZqnVmh3+EW6QfMzkV0GzpM7UhGQvmy9XtdZmNDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bJ1G0SMi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25bdf8126ceso96492915ad.3
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 06:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758030717; x=1758635517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=leCuR6CA4D9yFHVPEEh337W4UnazCBwwWSIpXVnD2Ig=;
        b=bJ1G0SMihVTnW8VuaRRPSQAVsmJb5qfcnaNMSIsImOqDCKBpCbpDGXTAwoll5wI2aH
         P5ZOHE92pTRR5cerVVZ/ARjI3Y608RAnVCzlIQcSsxyczinS5qTG3yctU4h9OFOJUYEs
         01zsNlzsnXi91hVkb/IpkB03WnlKl1t9lH6z42LF/8d3NLFYayv72DhSMGtA8cfu9Zdl
         ERzE/5VB/duTcMFsa2IJZ+6qoYCfsZSaPopcHprctj639lGAUgINuuEKNx5KJF2//vOA
         mfp3ixN2ETpNy/W0AxRfkSYnuWjLc6WiIzC8RVfJd9+uIx1e8/oj/WmMEAAd9ba2YVQK
         /RKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758030717; x=1758635517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=leCuR6CA4D9yFHVPEEh337W4UnazCBwwWSIpXVnD2Ig=;
        b=HvUnpnhRp7mGXvigbBkcUTvgSHIOPtIDV5qygHw/iwUBm86j+AygxIc9HBJGAFcKQo
         XUgx1Zhm1GJOu4UvoFWkS0075KDM1PPMgqTPlEI0qZNv4kMdvz8DF9vMGuy13eGF+x6J
         r//2pA6H9YNa1NXdgZEhOIUu6A/0U1BB1M2stTFspnWeUXN8gPI4HSCcKWciQs4w7wI3
         +S70eJ6+yNhC5UXxLje8y2yvqOwT3F8lKUjTmR/HbeHTBgSZEWNsfD+I6rwLV7kcEvvF
         T2hIqvF17zegzSO2Y7x1cnlFWxwZ0hJUDCeTjGLK7exnmmqt8Gu3IPVnw/A/AbWnzqC1
         1H1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMZ/P3AeHBYTsMxkn+J5TEllwwGahcMKI8FGQOAAZm4NeSELd/78oSyHVB9eAhtqvm0ws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy60Gmyn6WBlgm/HCV0IAqDYJ737uKq8uRjfwr4tl63teSbcGPk
	VEL3FAC1IeIlpxedHF7i0PAJoAHWQod3Nl0fppjHi9sxSicImI54fCWx5oWY/4ax52+ePE50on6
	StS7yPw==
X-Google-Smtp-Source: AGHT+IGp8qDt86gGH3TqFZZHLKZuTM801U+9zI7En+96NE3Syd5c29JWxoY1ASaLiHC4Ab7wKUZSePLEgCM=
X-Received: from pjbph15.prod.google.com ([2002:a17:90b:3bcf:b0:32d:df7e:66c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e784:b0:24c:82ad:a4ef
 with SMTP id d9443c01a7336-25d2646f80cmr164968405ad.32.1758030717398; Tue, 16
 Sep 2025 06:51:57 -0700 (PDT)
Date: Tue, 16 Sep 2025 06:51:55 -0700
In-Reply-To: <f9d43ba5-0655-4a4e-b911-30b11615361d@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
 <aMhxaAh6a3Eps_NJ@google.com> <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
 <f9d43ba5-0655-4a4e-b911-30b11615361d@kernel.org>
Message-ID: <aMlrewJeXm-_ierH@google.com>
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
From: Sean Christopherson <seanjc@google.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Mario Limonciello wrote:
> On 9/16/25 2:14 AM, Naveen N Rao wrote:
> > On Mon, Sep 15, 2025 at 01:04:56PM -0700, Sean Christopherson wrote:
> > > On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > > > A platform can choose to disable AVIC by turning off the AVIC CPUID
> > > > feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
> > > > AVIC support for the x2APIC MSR interface. Since this is a valid
> > > > configuration, stop printing a warning.
> > > > 
> > > > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > > > ---
> > > >   arch/x86/kvm/svm/avic.c | 8 +-------
> > > >   1 file changed, 1 insertion(+), 7 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > index a34c5c3b164e..346cd23a43a9 100644
> > > > --- a/arch/x86/kvm/svm/avic.c
> > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > @@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
> > > >   	if (!npt_enabled)
> > > >   		return false;
> > > > -	/* AVIC is a prerequisite for x2AVIC. */
> > > > -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
> > > > -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> > > > -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> > > > -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> > > 
> > > I agree with the existing code, KVM should treat this as a firmware bug, where
> > > "firmware" could also be the host VMM.  AIUI, x2AVIC can't actualy work without
> > > AVIC support, so enumerating x2AVIC without AVIC is pointless and unexpected.
> > 
> > There are platforms where this is the case though:
> > 
> > $ cpuid -1 -l 0x8000000A | grep -i avic
> >        AVIC: AMD virtual interrupt controller  = false
> >        X2AVIC: virtualized X2APIC              = true
> >        extended LVT AVIC access changes        = true
> > 
> > The above is from Zen 4 (Phoenix), and my primary concern is that we
> > will start printing a warning by default. Besides, there isn't much a
> > user can do here (except start using force_avic, which will taint the
> > kernel). Maybe we can warn only if AVIC is being explicitly enabled?

Uh, get that platform to not ship with a broken setup?

> I'd say if you need to say something downgrade it to info instead and not
> mark it as firmware bug.

How is the above not a "firmware" bug?

