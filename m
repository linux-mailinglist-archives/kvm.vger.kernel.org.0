Return-Path: <kvm+bounces-36543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FC5A1B843
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D95211885676
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E00B14E2CF;
	Fri, 24 Jan 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gm3+Btif"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4644914831C
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737730724; cv=none; b=Wpj2HvLKeoACsnXh2GLkpKvRJbd04sCghpUcOmc7Fheae2PHbPCiF6lPZC+RrlkVrg79S8hU21yXb8bE8CjIcDnmVcCmMykEI+kONfv2QZQInlE5UbBtDD8YiiRAkoyBr+20vq0yBvyKUCaSfP+XbKYLstRww1uf5L6o5r3gy18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737730724; c=relaxed/simple;
	bh=5q8o3VAK616DYEUCQ3uFljyadi/KAlDBISFIOCLp0i4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L517W5/Zx5j0gIQ9qNGbsCjHsuuRV8YOT7w3Di58FBfMTNSnFTEtsbpHmRyIDQNh+1q8QvB/Q5mAGTtnRaVnvVxN9sKSqhaTtb5RUEgNdcjJ3hyafhBiEloH0f/mBA9PjamR18bf2y7186selVqai+Hi3L/++qltCdSoE0kRN/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gm3+Btif; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so6212457a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 06:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737730720; x=1738335520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ih7bo1+rSYUrkrU5DiFx25AwH0aJw31nW73F+nUU4y4=;
        b=Gm3+Btifp22nE4fcdCK8oTXNaKjlg3+UWeZtUT8D8+oQtue6VTa4PlW1jvm3oak1EM
         KGsd3v0283LXGK4ywtYJXjPC0PvbvZzpKrtFsuxrGGy9MLWqLVN+djrr/+QmaKDbJJnB
         NlA6qdtxtOZJlepXYcseTrNObw4YZmQ4hpSXu/hVEL5fktfWMUBdecb8XCV8h9222cIe
         XulXvHZNsxFZipAnhOBwz9p3af7ySSq3oqzyZIF732rYngO/IssoxiuoUUT6saN5rLBf
         LptlObogH6q4OhyAf4vTVM2HTS+gbboUe1/SKQP1z6ErAQ5T/z7M03KMBWp+2sLsqT2J
         kzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737730720; x=1738335520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ih7bo1+rSYUrkrU5DiFx25AwH0aJw31nW73F+nUU4y4=;
        b=bvT6adbHg4/f9TdW3EmV/N2MWalbaTI3YuRMdjCRtu21r8Klt/DNGifjOgPCIwpGgQ
         9JOYTLyHlgRJ4FmAvVynR2ZD40Rh/sjrjSWccVGQaSU9Vrvh3zZ8xoja7qyF0XNvPqGx
         PRkiWV+qvGL/GOOets3R8XyjOE5yL5bQ+gkpxqo2nhlX70BZBVC7Vn6O9i3mr6ldx4ct
         IBkSg//ltbtgcbzMU4z91EiKJLAMc7OnAQeT/kQBIiXka1YSS2ZHWlIKa3K5M3RxlzW1
         G3hT8XT5tPDpfEMZDJFfuBaHmrqYw3LphtlRNUpRuIhrft8wSrK7PlcadWKB1MKCJnbA
         IXzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF2w7RpQT5LweToox1dY221LLg13y9Ab9k43bVT3IjIGOAm0idQrh/BWK4p7rk6qX/LeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmUcC/pwgQ69ZEJX6mwgeD6H9n/eJF2cdwwxxJsqOyksbfROnh
	hBLOZgggdwB0f8ZIQ93Pwi1QaHA4Cmw4lBgmbH4zEGow4W0MCpPiitMnverQAy1TgA2BLIQm1BV
	h/w==
X-Google-Smtp-Source: AGHT+IHa1p2TF87YFX31sUH+Hu1nj4ZRj5xHn8y5p9wW1NWIW8o8jywZsKH5M1XqNH6o7ecFj0zSrd2m+WM=
X-Received: from pfbf7.prod.google.com ([2002:a05:6a00:ad87:b0:725:f376:f548])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:300a:b0:729:597:4fa9
 with SMTP id d2e1a72fcca58-72dafba344amr41396483b3a.22.1737730720516; Fri, 24
 Jan 2025 06:58:40 -0800 (PST)
Date: Fri, 24 Jan 2025 06:58:38 -0800
In-Reply-To: <336f5623-b380-49e4-8dbe-ffa98f5aee19@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123190253.25891-1-fgriffo@amazon.co.uk> <c7b494d34d3e14531337311c286a9c06a99c9295.camel@infradead.org>
 <Z5LqeGa_G_NZ_boC@google.com> <336f5623-b380-49e4-8dbe-ffa98f5aee19@gmail.com>
Message-ID: <Z5OqnrPh6Pa2LXZT@google.com>
Subject: Re: [PATCH] KVM: x86: Update Xen TSC leaves during CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: David Woodhouse <dwmw2@infradead.org>, Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org, 
	griffoul@gmail.com, vkuznets@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Paul Durrant wrote:
> This LGTM. My only concern is whether vcpu->arch.hv_clock will be updated by
> anything other than a KVM_REQ_CLOCK_UPDATE?

Once the "full" vcpu->arch.hv_clock is gone and only the multiplier+shift are
left behind, the probability of rogue changes to those fields should go down.
I'll also add a comment explaining the relationship between hw_tsc_khz,
pvclock_tsc_shift, and pvclock_tsc_mul, which I should have done it for v1.

https://lore.kernel.org/all/20250118005552.2626804-9-seanjc@google.com

> I don't think so but the crucial thing is that the values match what is in
> the vcpu_info struct... so maybe a safer option is to pull the values
> directly from that.

But that relies on the XEN PV clock to be active, which I don't think can be
guaranteed.  And even if that isn't a concern, I think we're doomed either way
if any of the relevant fields get clobbered.  Hah, actually we're doomed, period.

E.g. if KVM emulates CPUID, and then before resuming the guest reacts to a TSC
frequency change, the values returned by CPUID will diverge from what gets stored
into the PV clock.

In general, if the TSC isn't stable, using the info from CPUID instead of the
PV clock itself is a guest bug, because only the PV clock provides a sequence
counter to ensure reading time is consistent.

