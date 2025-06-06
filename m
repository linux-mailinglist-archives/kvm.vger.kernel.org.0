Return-Path: <kvm+bounces-48667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61638AD06A6
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7B5B189213E
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FD1289E21;
	Fri,  6 Jun 2025 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJ0ME9Hw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B66D13A86C
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749227440; cv=none; b=brmfuulwBrRwzmksTDSSeJHiUrwS2K7Qki3E1Mty2+gdtrdVit76MKVS9MoRtn9AGJMIQZmIETIHXcsn6cykn5JGUaXBZefkoYdE6rybeuH4JSeS4SMAr1deLOtTGXwLOrVBIxiOe0JwsxBLBL75BtMb5WqP2AsiCcCWrHCc3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749227440; c=relaxed/simple;
	bh=If3SHFV9BXuXwcKjic0mO7s+6R902Ahr/7djWF8FbuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kc2WCqlasOcnNEPYpaApSonxOaejyoi2M6pgv9xj8ZYIwQQBBYqstN8Tj83daO/hmyEBLJpEO0GcCXvmbuAlZzFHVIs1mKvypl90P3dc13tZQwO2NrhxKtx6hg4wWqnHrQ0fWm/iBNv5obWPP5gnjb8IuhyPFOLrd3K5j1cd/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJ0ME9Hw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c38df7ed2so1653087a12.3
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 09:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749227439; x=1749832239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PeZDoSbBvqkhPAnxH1AxtEkHDzzgin1oETJTbTd+Zhs=;
        b=mJ0ME9HwFOS8xYirpNsRajmu0+OhLCrV38244snO4KUQm57GazPQ+1wEaoX2dTsVKg
         I/o9dtxMDYmzTdl9v9CtOPEjDmPfY802gpo/DQSevPANV9YKsgDKpb3MexBEH7Lrk390
         At3wgzt2WA/GDAK5/64gblGtLOpD83I2FtoXZOeux/3ufexRsJwSAuwXxx/VhNEJZBIM
         CToyOAx+vBxloNnqAMGLabtV2rvXR0WPt94adzXCHZMIMplLl1xB2CyTBbCpmxpDLHFd
         OiZQ96rJTjO+xmy2yx8vgk6/+lSvuOqHV1EGPkbcdMh3+mjuFK/hEnwxek0310H+b2rH
         vv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749227439; x=1749832239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeZDoSbBvqkhPAnxH1AxtEkHDzzgin1oETJTbTd+Zhs=;
        b=BCAe/uMvwUfwVa+WzS1DfcF+96B4pRKd67sQgyPuPeVhQrzV8+nvK7ZjKFbe0Z7BLD
         qsD7Y9kwikPjWaJXZTBf5zC/bSEYcG4fnSsh4QlPIf3ctxl0/W8QEmmcCyztEyBQg/oR
         dJkvBIp6Myw9wpUdvYQ55CQ37WVezcXb89m4fUwNJqziK2rWM090kficTSjaQS/tDbUM
         kDE1QtM1w1tN7MVB29VqCvmBm7THuHdpjBF5faQgTXREDX+jCHo7o9AaVZGxocy1xOWD
         c+uVB2OF53Leb1t99jMw3rWxYqhRPrKh/CmfEOw4s4Z0RRhu9DihQ6XC1bs+YqI0KFdr
         aDcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqIGsV1mvY32q5vSJcxaTwxRBJKAGRmKf6UgiFuWZoz7MRUz1TsLwpuQhuK7yj5Etnxlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqhhH7didbopa9M0n0mk8hPMV0zCuZhENglCQGtskihbcEHUww
	m6qTMRd9DeRqE9vyDlAJBzvnCASiSJBOhKyiVt+3IprNQ97ixTEftPLLYFPD1NfNt5Q67fwZYKA
	e03XP3A==
X-Google-Smtp-Source: AGHT+IHke24X9i3QXxhH+WOCf5tN70TEkBtw4F1fB6ZHJgw9mRBnHIQUbobGqbQD12aEDHqeBnktZkH7jjw=
X-Received: from pjuu14.prod.google.com ([2002:a17:90b:586e:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d88f:b0:312:f0d0:bc4
 with SMTP id 98e67ed59e1d1-313472c04b5mr5729832a91.5.1749227438821; Fri, 06
 Jun 2025 09:30:38 -0700 (PDT)
Date: Fri, 6 Jun 2025 09:30:37 -0700
In-Reply-To: <20250401161106.790710-21-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-21-pbonzini@redhat.com>
Message-ID: <aEMXrbWBRkfeJPi7@google.com>
Subject: Re: [PATCH 20/29] KVM: x86: add planes support for interrupt delivery
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> Plumb the destination plane into struct kvm_lapic_irq and propagate it
> everywhere.  The in-kernel IOAPIC only targets plane 0.

Can we get more aggressive and make KVM_CREATE_IRQCHIP mutually exclusive with
planes?  AIUI, literally every use case for planes is for folks that run split
IRQ chips.

And we should require an in-kernel local APIC to create a plane.

