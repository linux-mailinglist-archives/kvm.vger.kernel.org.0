Return-Path: <kvm+bounces-24858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF57495C14F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 01:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A36C51F240A2
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 23:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56A21D1F7D;
	Thu, 22 Aug 2024 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lO6NF9H4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D529168C20
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 23:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724368239; cv=none; b=TcPqbNKdRqli4idzKaWQbS5GU8RB3bdWNF07Nf5EP94rgvZxqoJeV4Vk7WngAMAvVXf57MZotRruuSESXlMAr8IUcitVO2XAW93v0H4yFj2GJaIPneIAuL56k16XYLOWRlarHzyoofdUVSwqM3ndhd2joUYqDKK+2osDLEM9rIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724368239; c=relaxed/simple;
	bh=MkcfCenS3xFCKvWO2XiK5Kf1TRh1w2lilKwkPSXjMXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c9QEOE7aiQjD9PO8CEciiF2+qtX1GjLpSPznB7tujcJJyednV4bek+8OVDzyoaFF+LOy9Gt8jFyaxRoQljCGOJ79BOZrt19gHwVScCKVFMYupk3LL89QYxzGwWL19BZ3lEh0cQ2jEiRNykLfQCpbgIWYiJd92Kngu2vE7F6Zo5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lO6NF9H4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b41e02c293so26486987b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 16:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724368237; x=1724973037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9eTeJ7+1hJHMk+pmGCHSxA/xju6KE1INydXkWpPn8k=;
        b=lO6NF9H4l6Ae1ZTzlwcAtZVP7eNjRc4I13+4kkXL90fO29D1AobljXKnM0OUKj/wse
         MyZjtq4Zst6SEqdTq1fVrljQfuZE4Ime3qabu1fiCfWGNjloxMLbqe79FEac33Feus80
         XmAN4022M/sfoAZUep80nDhEZsxr0XK5UeNLSFhSvUHLsTN5h31uq1VGpgoHmTiJak4n
         1goCO6tJBkvmkN5ordNO2yZjsqjLcJpqBBbh7pJP0iT6/jqtwdiYE22hfTJp6St0J8A/
         slaCl20DTfxPMyA1Bq4QM6HQkW5A4d2N+l84j12CKD2Kzmr9CYmudkZl4gVH8s2AnTr4
         rx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724368237; x=1724973037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9eTeJ7+1hJHMk+pmGCHSxA/xju6KE1INydXkWpPn8k=;
        b=CVLUtkNKLqIdCaIoxA1Jos5D/wnrmjR5ofk1MM522rclmyBXV6DBqBD0cq6jpEb85n
         I9KwjaK9v3RbJK7L7jy+WuYwUM0/B8eALl/924q0fWXWuPmkf6y0GOuoQCEQaRHetfYw
         vJkkL3Nf01QZIy48K6LxDeKyTWn3MV4PgQckNhPxbmGsQ/gmN/lcLZzW3cQaLb3WpU6i
         4jmMOvCz9O0BVLlwNA0uFQKo5LSqIp0wrH98UzvvQhJOQhXMtwSpuzvwOwzXambcrLFO
         3PsL/DNrmysbwVz6oxcNGZ+up7r4m9pT9VN2/ZVQkSmLQjPTSRIHQrm8cPct8lRA0BND
         p7Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVChXuWlXHoiCrPowk5DMGs4fJqKMSaF43AXezk6ov7qYY2iP2biu29FSnqz4JTAMM9Ggw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHYKp78UvJkc7QNwUT/PyObosUb4/dBF5zXlB73HhvZQGSjbyV
	6UniO/Uy8UnFgnSIGeSBw+p6Dq1RSAX4vty8wqBn9SwAN83we3/XA2hjmavT0DmEMkxKi73043k
	t0Q==
X-Google-Smtp-Source: AGHT+IFT091iygxCVdPT22rOOgTixYu9Nccdsrs9AC1KE7uMFgRYqeS107OZYAbUZZkbRmekLfLLOaJhaag=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:26d1:0:b0:e11:5807:1072 with SMTP id
 3f1490d57ef6-e17a862de14mr572276.8.1724368237348; Thu, 22 Aug 2024 16:10:37
 -0700 (PDT)
Date: Thu, 22 Aug 2024 16:10:36 -0700
In-Reply-To: <cc9b9df6-583a-d185-0c32-6d26d0717548@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com> <20240719235107.3023592-4-seanjc@google.com>
 <ZseG8eQKADDBbat7@google.com> <2f712d90-a22c-42f0-54cc-797706953d2d@amd.com>
 <ZseUelAyEXQEoxG_@google.com> <cc9b9df6-583a-d185-0c32-6d26d0717548@amd.com>
Message-ID: <ZsfFbMpVm9qWRVz5@google.com>
Subject: Re: [PATCH v2 03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for
 AMD (x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 22, 2024, Tom Lendacky wrote:
> On 8/22/24 14:41, Sean Christopherson wrote:
> > On Thu, Aug 22, 2024, Tom Lendacky wrote:
> >> On 8/22/24 13:44, Sean Christopherson wrote:
> >>> +Tom
> >>>
> >>> Can someone from AMD confirm that this is indeed the behavior, and that for AMD
> >>> CPUs, it's the architectural behavior?
> >>
> >> In section "16.11 Accessing x2APIC Register" of APM Vol 2, there is this
> >> statement:
> >>
> >> "For 64-bit x2APIC registers, the high-order bits (bits 63:32) are
> >> mapped to EDX[31:0]"
> >>
> >> and in section "16.11.1 x2APIC Register Address Space" of APM Vol 2,
> >> there is this statement:
> >>
> >> "The two 32-bit Interrupt Command Registers in APIC mode (MMIO offsets
> >> 300h and 310h) are merged into a single 64-bit x2APIC register at MSR
> >> address 830h."
> >>
> >> So I believe this isn't necessary. @Suravee, agree?
> >>
> >> Are you seeing a bug related to this?
> > 
> > Yep.  With APICv and x2APIC enabled, Intel CPUs use a single 64-bit value at
> > offset 300h for the backing storage.  This is what KVM currently implements,
> > e.g. when pulling state out of the vAPIC page for migration, and when emulating
> > a RDMSR(ICR).
> > 
> > With AVIC and x2APIC (a.k.a. x2AVIC enabled), Genoa uses the legacy MMIO offsets
> > for storage, at least AFAICT.  I.e. the single MSR at 830h is split into separate
> > 32-bit values at 300h and 310h on WRMSR, and then reconstituted on RDMSR.
> > 
> > The APM doesn't actually clarify the layout of the backing storage, i.e. doesn't
> > explicitly say that the full 64-bit value is stored at 300h.  IIRC, Intel's SDM
> 
> Ah, for x2AVIC, yes, you have to do two writes to the backing page. One
> at offset 0x300 and one at offset 0x310 (confirmed with the hardware
> team). The order shouldn't matter since the guest vCPU isn't running
> when you're writing the values, but you should do the IRC High write
> first, followed by the ICR Low.

Thanks Tom!

