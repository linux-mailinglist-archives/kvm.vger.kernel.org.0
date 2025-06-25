Return-Path: <kvm+bounces-50758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E1BAE9109
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA09517FB2B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675332F3C03;
	Wed, 25 Jun 2025 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1UQKCTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3E2F3657
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890388; cv=none; b=EG4PeTgLhHHgPbYxzKEBEMMll8C9IAO7kV4VuP+tjWXoQYds26Pkhf57QpqqcBRkIbXa2lI8so1czMYyQGoRtnUBH7oLZurog875XEAr61vLBaL570jxiALngKbi0VTbTJQdYq4Ngf7IYK3waClnoQ3IjzX8HeDq9qrxheJFWbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890388; c=relaxed/simple;
	bh=cENihrWaJoNe51D+SqgzCNhb55BtlBsJxs4uwq7Pu3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I4/QMsG82bz56F/zyMql3Ea3flH9jSJYXj1S7DznfWLUvYSMGJ2OCuqFNdGCVazyU10t7W4DsD0lSu6saJl78azTD+D9OMgVHPYEViPTecWi9+8BHiorUUGHOoWf3PhFf+1/x7YquhIxqB0dX2TVMPDZ5HnstCM+JOUd14jth6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z1UQKCTW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31366819969so224398a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890386; x=1751495186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlxyOI/6ZakVbVruzFwn3Uf4AvGZK12nS6OdNKON/5A=;
        b=z1UQKCTWn3CelJ/BdUerTk+4gopRYWR75IrOFtlI6HcP4KUGz7a0wDzyv0/hUQy0jM
         KZt9REo1Au7J0YR2rtn4k55Q8NnR9SjhNerx+efZbPPZPuhwqrXf8g6O64Wkn6NTF26g
         hvvXdytWP6mb7OgS0HtPhAqEPxHm9CGOgZZtdjcgbzFyS8BYUe8aD6nSw6UfVGzqCsW6
         Nzp/xp6EgH7q7Nf84yH7H/RQ+Q8RFtD5gNwjpFtKe314d/6zepoanO3rVQurb0ZZfVHZ
         11rqg4B5yVGxXlOY1GBjoflSB7KadJMP7E0yUdY3J2sRwopLB8nF5L4/t5KhNW2c4eDe
         V6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890386; x=1751495186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlxyOI/6ZakVbVruzFwn3Uf4AvGZK12nS6OdNKON/5A=;
        b=sMVAMr6g+rYsDZOHkPhy8ESixopxlDZsh0KSnl4pC9x4JtBbUJkFMiO9wG9DUzmatM
         sX3UqG+TyKwt1PZaQroavvZSwfR19i4mh5r0uEPNbGO7i1saB3wGGT2EYV39E/BzKm8s
         0YlLWG6ol8Ps+cB3sF3LjAenyX2mGwK5enkCvxc1k2M7ym+FVGffrU9hrtu5xCgy2Vug
         d4qaEivzMt4WoS5fEYdwItmHNAqAkj5iNKR8FqKrN2V0NJgsbU6dqgyP4j0XpJX2pLEO
         e+tvjH5x0v6RWbymHQI1wN/7z0go5H85c84gOvythumOATivEndGdF4HWIqPZga2H+Nq
         RU5A==
X-Forwarded-Encrypted: i=1; AJvYcCXnvfqbt6sZNiV7Zh4nRaRimea8pSkhDbBT3me3ypfqRyJaSeGRLpovMEgcMdTPQmBcg2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3In3zplgCJhNKNx5LSMFLF7Xl/ocLhDEjSCR7cZsENd5MXyNd
	7mPedjqNAT+dTkFS3zi+09jrM56alNfwD8Zlpc74I6v/NzeyBE75GUUWQd2LVAwQDuDkmIBsQui
	xr6TZzQ==
X-Google-Smtp-Source: AGHT+IHqwfiqw3m3kBtp1ef78tyyvexjhPgQ2xi8sq1EFiQaOZdu9FL4CqTvr/PJiltMOhSWTRDkdVENbq8=
X-Received: from pjbcz13.prod.google.com ([2002:a17:90a:d44d:b0:311:d79d:e432])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc4:b0:311:b3e7:fb3c
 with SMTP id 98e67ed59e1d1-31615a727demr1727145a91.31.1750890386542; Wed, 25
 Jun 2025 15:26:26 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:31 -0700
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250408093213.57962-1-nikunj@amd.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088961694.721025.5248353991381426195.b4-ty@google.com>
Subject: Re: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Nikunj A Dadhania <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de, 
	isaku.yamahata@intel.com, vaishali.thakkar@suse.com
Content-Type: text/plain; charset="utf-8"

On Tue, 08 Apr 2025 15:02:09 +0530, Nikunj A Dadhania wrote:
> The hypervisor controls TSC value calculations for the guest. A malicious
> hypervisor can prevent the guest from progressing. The Secure TSC feature for
> SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
> ensures the guest has a consistent view of time and prevents a malicious
> hypervisor from manipulating time, such as making it appear to move backward or
> advance too quickly. For more details, refer to the "Secure Nested Paging
> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
> 
> [...]

Applied patch 2 to kvm-x86 fixes.  I'll wait for v7 to grab the others (and
stating the obvious, not for 6.16).

[2/4] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
      https://github.com/kvm-x86/linux/commit/51a4273dcab3

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

