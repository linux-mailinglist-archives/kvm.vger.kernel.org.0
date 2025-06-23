Return-Path: <kvm+bounces-50377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 613CCAE48EA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C17571B651BD
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5FC29A9FE;
	Mon, 23 Jun 2025 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gnu2gg9K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41082989BF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750692610; cv=none; b=BEYbg+dPlWymg2gQMMuHVZK4luyxntTAtTZcE/maaU0IxdphbH56z/rPND0aLen3NBM+eCi4prdtFUmnKrnEsPChb2bVEn7R/4l31/895ZsreX2UfN82zgoGQOW5O1InzIDsAJNPBoaO8o7g6xIfTESpO58aRAUYzSEoBX9S4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750692610; c=relaxed/simple;
	bh=L/cfSGnSX28XY4cLKESl0PHduhleGIW8TtQJ6a7uSMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PKke9as3/eOlmffJ2KOs4XKO5NJoegsNhMc+l2Ms5cY+SmvTRG6s7qXLwFTUyvle4v534Ufytvo4N6PinqC0CMel+RH69dnT1JBoL9bA/VgRHUWqogHvEM/0cELFAqbLU3urH6Mo6fXxr1rPp9UhQbpoDdd8BGa3swdScKPe9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gnu2gg9K; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234f1acc707so39431115ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750692608; x=1751297408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KdWZjBOZrnoU5S/xxe3p4LyXR96yMFXC81nKL3+yk3w=;
        b=Gnu2gg9K5VjoJqa4XV+g1WVNR4O5UeHDp7z0gkgKanaOuUXvXyMpDpbz07hty8YCPt
         AzT7R69Com6vzX9utR74L5eogxBnheU5Y9/xe7P8Gi9FDuSOhY73N33yk6E4DeNtbz7j
         +1b/66QBtJS2oci/Air/YkcxlEk64OVSh6ohapZVd5Qrm13FMfOFC6L5PhAweIkUdJ2g
         4O2Kg2Ft23Y77nlc6AY4Fnt9yGMV8c7c+7r/mZasMz0hVzK2CNlSm2IOyS+OILIswN9B
         SIh8uI6ADHz3/19Q2+oWxpcs99XtlH6bU09IgNdmgFqBxnmc2eAH5UV4/mQqC/a0FDie
         3pUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750692608; x=1751297408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KdWZjBOZrnoU5S/xxe3p4LyXR96yMFXC81nKL3+yk3w=;
        b=fbC724LnQ2LfXPk88jes62Q/FPLFm1KFVQjV073NlkCcLAbSWtNCvZktultKoGtTyy
         B2Dm6hn3qOwd7qaMx1TD5AjZdnW1u07g2xpMaDUM23gjfKhWJqJ9oV6aVROMZb0xL86R
         pMpMjaspD6u7iM1CPGOm6Jyh/ywZGLO2NnXzLETWnjSyocitbfhIrZ1kD47FFSf7/LSF
         0mHTHdtl3uq2+WOVhSvDKSvchavw4nBOy9Sw7YhkKKfQRN19WqzduZd1qmh1+ZEbiYyl
         qzF10f2oX1WKysQDRn4L+FO3C/AmUJJVMWmMiYqKVbKq/yCMq2kdNFPkZbmrIH1zF9Pi
         y/Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUfRbtGaeyH0AIkbEnDKK19ZEU2jiWVeXWbBOsGclm2/sCwxejGRQpG7WexLztfXmNjfhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMx0IUJpPZqai2p94wR0miWaFLQHok5azQRyapkQE4ZfRRnQ+o
	6YSLDAxsjNrQ01DUjFWKNFztVKjTWc3qXoEbs9GMWFTi3r6Ehrt/MvliXCSiMsWxkqxgYHiNfy+
	cvQWYBw==
X-Google-Smtp-Source: AGHT+IEMdoRNFqlp7zHt8uHjKfPleNVgWrvxFNisVXQLf3SXuV2EWfHq7AYIrMPraED+yf8roaT/XGVYptg=
X-Received: from plhw5.prod.google.com ([2002:a17:903:2f45:b0:234:a456:85ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da8c:b0:236:6e4f:d439
 with SMTP id d9443c01a7336-237d9965716mr203757385ad.23.1750692608274; Mon, 23
 Jun 2025 08:30:08 -0700 (PDT)
Date: Mon, 23 Jun 2025 08:30:07 -0700
In-Reply-To: <jskiyda3defofthrtniugcdbcoftx4o5yvgt47koswq64qf7d7@2pzrr5v5yssy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-20-seanjc@google.com>
 <jskiyda3defofthrtniugcdbcoftx4o5yvgt47koswq64qf7d7@2pzrr5v5yssy>
Message-ID: <aFly_5c0aqTOGEem@google.com>
Subject: Re: [PATCH v3 18/62] KVM: SVM: Disable (x2)AVIC IPI virtualization if
 CPU has erratum #1235
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 23, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:21PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 48c737e1200a..bf8b59556373 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -1187,6 +1187,14 @@ bool avic_hardware_setup(void)
> >  	if (x2avic_enabled)
> >  		pr_info("x2AVIC enabled\n");
> >  
> > +	/*
> > +	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
> > +	 * due to erratum 1235, which results in missed GA log events and thus
> 							^^^^^^^^^^^^^
> Not sure I understand the reference to GA log events here -- those are 
> only for device interrupts and not IPIs.

Doh, you're absolutely right.  I'll fix to this when applying:

	/*
	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
	 * due to erratum 1235, which results in missed VM-Exits on the sender
	 * and thus missed wake events for blocking vCPUs due to the CPU
	 * failing to see a software update to clear IsRunning.
	 */

