Return-Path: <kvm+bounces-50688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B0BAE8557
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99E9B5A496A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1D8264618;
	Wed, 25 Jun 2025 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HSmzJqf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683A263C9F
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750859920; cv=none; b=SQ1MsK/HSns+f2FiVzHoUBgJILgQetNrgfmljX/wEMi0QVaJCiYsA1R9Dt2Pw1hmim85XmCjauNE6IEahxtJmajvxVfA4LLnaGGmlrt8nY/IzOn+flhcPXEA4AzYjIU/lvevh3zqiJOnVlzyBzp6kmAtRwT0ffPf8KJvSk0K8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750859920; c=relaxed/simple;
	bh=xwmzEUlG2R7xVazTb9/Jc2Qom2RBZMVFZfDlBmoQ4Mg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iZYir5gGLrHW8w69EMYp8g6P3I89vC5Uesb8UEUWzJznSdPpYWZiuf293Da73cOHWHow1HtUq/xPWB3j26Z2gNhpQNfeDqrF5YMMfBY2prqWnXRJq1qgiNIPsG/hUW1A0scECBZXj4kJzb/umm3dFQa1BlbcFHoAaaf2ptNQDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HSmzJqf6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313c3915345so2656146a91.3
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750859918; x=1751464718; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qP1LjaQLH363yLgNr/FeUMdQPTa16fdKsNMB8w7jtyQ=;
        b=HSmzJqf6nAwXz/5/uurEDPD5UP+rjklQKQZQGJRLH7jgVCHZP7S6UCJz2sCb/t/gf1
         Jp/nMYQQwJwCApFeW4p0h1CsylCUaZypkKNON1yG6GTOmCXNMzctY+gfjwIeds226uKt
         bE1gjsWRl+PfsJuT8mfWe/ZXBGunA9znH8/jPapCfLiHO2oyx6uyin3kGjpZklHLUF81
         QFnIkvHjUVrUBFfB1Wyf81f/q4L2CTGKJKcrzJjHrexz2m5IAN5eNO0UYrlh1oQ592ev
         0i3RHqHaHMel42KqYb32hIVead70ldij1bjdKlzBpK+H95mnTGUXF/xS5XGpbycZaQrB
         KIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750859918; x=1751464718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qP1LjaQLH363yLgNr/FeUMdQPTa16fdKsNMB8w7jtyQ=;
        b=Yx/DphfUddcpxeiAEIZgWPlDk4ZBhzIb2H3aPAEXH0xBoJxsFH4SBOMm/3AfW1Gv4Q
         JIChHNQdw873GobrL2nX02TBeQvhXhPYQP5fUqYcKknuc1AVngUQmoBTS9RZVUbOOKdd
         VdVqFtQg1tX4ZAvt4wAjrHc4q9XIekEKTBUvxxTsoiPmzNWaWSf3QgazeSoe58uFCB9B
         7NvPDQ/2D5IyyCaau/DHCY430EIb1uQYQJe3M7LE77/AsQr9YUgtp/vIqoS+n33KuiAh
         rQY6sBWNsdPPv3s5Q2ghh+uf9n/ZlKLJOcwh8KflH1kV7+tZQ5ZVoFeMTecyE4XnYMrg
         dLtw==
X-Forwarded-Encrypted: i=1; AJvYcCU+fh+YImN8u3mFWkYioZ1psVcVj0ipnuQdV+ynRUs0AdJxZkGf4F1r1narw8C4E1oVuEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYg6tSvj+YOs+wbVTFeWZl5/BuOhhc1OjSvHIhjkK6ThYKf5oX
	HT9NgRludksvW+H+vP4dlPSGCTgZFZTm6U6M1p6tXL8vPmrIRhW/2rN0yiYKTzYFsAgywvwtX0r
	HStQf5A==
X-Google-Smtp-Source: AGHT+IFfkRs8pTU1cqMi3anm83+ieWHKSGcCAn99oVQttbpqmHod9vPFoo3AfSmdUW1/AgkE+CjFGYOK2xk=
X-Received: from pjqq16.prod.google.com ([2002:a17:90b:5850:b0:313:245:8921])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cc:b0:311:fde5:e224
 with SMTP id 98e67ed59e1d1-315f25ce93dmr4245772a91.6.1750859918426; Wed, 25
 Jun 2025 06:58:38 -0700 (PDT)
Date: Wed, 25 Jun 2025 06:58:37 -0700
In-Reply-To: <20250610175424.209796-11-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-11-Neeraj.Upadhyay@amd.com>
Message-ID: <aFwAjaTeqHco2J-c@google.com>
Subject: Re: [RFC PATCH v7 10/37] KVM: lapic: Mark apic_find_highest_vector() inline
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> In preparation for moving apic_find_highest_vector() to
> common apic.h header, annotate apic_find_highest_vector() as
> inline.

This is way, way too fine-grained of a patch.  If placing the helper in apic.h
is the desired state, then mark it inline when the code is moved.  

