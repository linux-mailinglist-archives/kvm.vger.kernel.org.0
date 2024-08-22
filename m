Return-Path: <kvm+bounces-24850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB41195BF0B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 21:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B4351F21CD4
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 19:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515211D04AD;
	Thu, 22 Aug 2024 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4YThaEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137981474D3
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724355710; cv=none; b=eR1gNAauHei1UlQKFRIeu2jxY59qKYnebRPI3CWB2Xt0pKWmhDJ3kPgCc26qeioCqlZ0R2vALSvIfpcXrwLCqDezLOztl9R27XBPzW365CpVRr83azVdbiLW3q4HdvbOQJ/bXwDQNGv2LfsbQgyhIoWo3I+qKRArg5gvB/WyDwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724355710; c=relaxed/simple;
	bh=BxxeA09AkHi/Rmon5GlnfCCtQOP/lAeqUeXDmx+jjLk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rgt/JRDsw+efaMNlBcj4Pai59nbmdhxSd9fsciqiLSskxaccpmsROtWUaKHCRl8dPaWI7GvNMeinGgkzeaqRFB6fHvBeouWAo+o7rOxUlri1Tia4/mq1cr4msLMeUcbQQ9g+kXtro9U4igG1g+b+fr3CZtS5uulX1sFlO5vZrKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4YThaEU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02fff66a83so2040782276.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 12:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724355708; x=1724960508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mz9wGeuXm6EpIBUb6YvKcCToAhANCut6lncmUTXot4A=;
        b=o4YThaEUvyVKEizLA0VgXTByPoXooNrN+sCyhKoAReErCm1N/LZHdZTvHQtL9S2jjB
         F2Pir4srYm3mKWXLZ47brFaKTW/lUuUTiRylNQJ9QNELogWDXdzdETbxaQjEUjjgQo/I
         lINSXlBKgQ8NBqU1qpHIzk1OZkpmsazc3Py5x4WvFGh5uAs8Qo4LNg7cry/OZJIWPr1V
         5QsoaqQW18jR1DheBxSRweMvdJlkuwC+Ly6MIrkXH8z5D+K2GtBg7iKlkTR6KWSDjixD
         IgidVq/iE/rqUmNAXOsetttaDU41vtrbZNuQNorWagJaUFW/P/+AylRXAS3Fn1Gv5eH+
         FMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724355708; x=1724960508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mz9wGeuXm6EpIBUb6YvKcCToAhANCut6lncmUTXot4A=;
        b=REX4S1kIvWoXac3/xX33Ahanxk4usTTwFpMQoON/LMv9yNkou7ryG2263AsYZEVhBR
         h1S/+GnWyPYw1ZmESeC2huNA/ZBk9NLRHDP94WDKgeDb/U5intJ4v16lWB0OD7J+wQsP
         1Rqt03yDlacfM6l8IB0YlfKIX/f9gARFopDxTDlI0YQzgO/Ap++XpvS2Gqy6BMSpQRpf
         BCA8rOVyBMqL9icKWdKKJZV9LVOF25BLYlO860IrekoDY2mwPdc0igrjQI0dyH/Dp58P
         rnTHWMbzMO0iEZvxhR8RGXfq6CtFi+lLdzCAHQk5X92StrFJ8fXFnsDQmcKQnHTOmFQH
         AlYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJoTZOOxDeWVxc9j5HslbdSB9oBxYNiuky0khArUNON5skNLMMMHUutSF0FgFe8onX5P0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3nISyU2OUH9R3xoFgDDL/MJ4LlYKYE1AtZvbsNowf2I/mII6g
	hiLQ+F6rFN7pSAEDbi3ITthOswI499A7L6QtQ4t7QNOvhmdpIKY0DIyjrZF9xi7vtbWat427EM6
	YAg==
X-Google-Smtp-Source: AGHT+IGx7dO6lgld0wkmZJ1yV/WZ2OKuXb8FbYJBWkCzLsCwE15e3wBoWvQmGN0Der/RuQZx4fIWsMbQ3mM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1352:b0:e03:59e2:e82 with SMTP id
 3f1490d57ef6-e17a8659c57mr11276.10.1724355707969; Thu, 22 Aug 2024 12:41:47
 -0700 (PDT)
Date: Thu, 22 Aug 2024 12:41:46 -0700
In-Reply-To: <2f712d90-a22c-42f0-54cc-797706953d2d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com> <20240719235107.3023592-4-seanjc@google.com>
 <ZseG8eQKADDBbat7@google.com> <2f712d90-a22c-42f0-54cc-797706953d2d@amd.com>
Message-ID: <ZseUelAyEXQEoxG_@google.com>
Subject: Re: [PATCH v2 03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for
 AMD (x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 22, 2024, Tom Lendacky wrote:
> On 8/22/24 13:44, Sean Christopherson wrote:
> > +Tom
> > 
> > Can someone from AMD confirm that this is indeed the behavior, and that for AMD
> > CPUs, it's the architectural behavior?
> 
> In section "16.11 Accessing x2APIC Register" of APM Vol 2, there is this
> statement:
> 
> "For 64-bit x2APIC registers, the high-order bits (bits 63:32) are
> mapped to EDX[31:0]"
> 
> and in section "16.11.1 x2APIC Register Address Space" of APM Vol 2,
> there is this statement:
> 
> "The two 32-bit Interrupt Command Registers in APIC mode (MMIO offsets
> 300h and 310h) are merged into a single 64-bit x2APIC register at MSR
> address 830h."
> 
> So I believe this isn't necessary. @Suravee, agree?
> 
> Are you seeing a bug related to this?

Yep.  With APICv and x2APIC enabled, Intel CPUs use a single 64-bit value at
offset 300h for the backing storage.  This is what KVM currently implements,
e.g. when pulling state out of the vAPIC page for migration, and when emulating
a RDMSR(ICR).

With AVIC and x2APIC (a.k.a. x2AVIC enabled), Genoa uses the legacy MMIO offsets
for storage, at least AFAICT.  I.e. the single MSR at 830h is split into separate
32-bit values at 300h and 310h on WRMSR, and then reconstituted on RDMSR.

The APM doesn't actually clarify the layout of the backing storage, i.e. doesn't
explicitly say that the full 64-bit value is stored at 300h.  IIRC, Intel's SDM
doesn't say that either, i.e. KVM's behavior is fully based on throwing noodles
and seeing what sticks.

FWIW, AMD's behavior actually makes sense, at it provides a consistent layout
when switching between xAPIC and x2APIC.  Intel's does too, from the perspective
of being able to emit single loads/stores.

