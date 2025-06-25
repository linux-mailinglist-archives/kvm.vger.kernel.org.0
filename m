Return-Path: <kvm+bounces-50693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F229DAE8594
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7818F1C20BE8
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C592641F8;
	Wed, 25 Jun 2025 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FB2TnfNb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D805223
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860285; cv=none; b=EpCPBmVKC8Mr323vKL8jMpRDh9YAG5nWjL814+1z8VRl63NHgwsRzJvOhihQ+oocPXBsWKAMExlzvTaqZu8qqrei9JEYp98hUQGhNb54qO9q7vByuUDIQW5VC9L55xKOrTdZmk3lsPzfSETMizNvEoZoEIfRW+8b9GoJCAe3mc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860285; c=relaxed/simple;
	bh=Vthl9OCrzwfCk7xPuvCTsc3MueFPT7P68ongcIgychc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m/t6kU5X+icUL7MaP/cTUmNOU3LmrXyAW0L5wQ+kucWiK0Wl7RxRU4rgXFGTyX313rrGu+2VZTAzdIuFg41WfwmshRlsYAer0r/SyktiUarGMto1ixbrBMcZ/R2vS8zcLoI6xRA8NzEn/U209ioUJAK3KH5FlZaP5nPk91keSIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FB2TnfNb; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1ffc678adfso1168822a12.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750860284; x=1751465084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDvIuTgl+znbHfx7LTS8xADVgYyXuhd1FSun0CfTI70=;
        b=FB2TnfNbFH2QUZsE+fKZ58O4cd6nfI4mSw+p8itO0Y6D0pD7Wd61UKtRF3oXQBEoFP
         TqVQRh3ERqdK4NXdPr94jt3awiGvPp2MlFkFcLW5b4aIdk5RRtQ6GfJOv3urrw4VXeJk
         bdiZuqSCv1AOP9EOMAj+liOryCpxvePFT2B5EhKfmt13Gfhm2PwwltJ3WbvSArLsv5Zw
         huW4pACfqDHO4uEvFVz+sXBrYMed0mDBNcPkqZbsUkLjDsGjHwQw+hXRRjzMND1Z5KaR
         1moMUR7fuAjgt+GEPkhKwfcStBbOpKRTmVOkogxd6SsA/E0/+ke66iWzCjA25Sv2PU1B
         P04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860284; x=1751465084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDvIuTgl+znbHfx7LTS8xADVgYyXuhd1FSun0CfTI70=;
        b=l8dzLIAzjZUqtt8qTIOKMrBbl0jkXH8921f09cMVmGS7eIZR2wfo7R/WS6nDxelVA6
         uFskdEsgpmegj+pXh+bgY8RcPhTG510/aZP83FyTrIsf9hRG5D4F2TXnHHBnjHzJiA8M
         whYwfHhjHhRWuJiQRC++eJIoD6hLWAdIyBkuNLf27SP7a0QNWbWIIcyHfeJBricuzQEW
         FJv9t/6w9zyyAFu4532vdunm8DxsT/xfN4q/LRktT0XOWOg5kOZRwl3TTgJdIREubWOe
         mYfA/hIfnnRkx4F6VuqAneeamXpXa5vudGDPuq2cPMvNG1yhmU+yqlLJsNZwYrcnSytW
         vJ1A==
X-Forwarded-Encrypted: i=1; AJvYcCWhCFzXnRONRw5WnyUf+AYB6tJvndrNHhFZjGDwudtzYcTgUmdnkwutYLvOnIf8X72vUpE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzMErkJrzDMOqDRa2U0IFAnEmi9GWosCkQpsR22zLgYRsFgMd9
	v3H7A9261H4sv5CcwF8fJvyluHY8ZV82xcc3uqrrTxIrTS5XrztqNnzHiMjmzhSls0OzG8ewkxp
	IomvJNQ==
X-Google-Smtp-Source: AGHT+IEQ3enfzMitrA+oVbep3hpNytaZrw7ErQnlZeO5UYmqKnZ+yHhtLYFmyf3cJj+f+3pa9tBgBoZ6FUM=
X-Received: from pjzz13.prod.google.com ([2002:a17:90b:58ed:b0:314:3438:8e79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64b:b0:311:ea13:2e6a
 with SMTP id 98e67ed59e1d1-315f25e985dmr4748652a91.13.1750860283615; Wed, 25
 Jun 2025 07:04:43 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:04:42 -0700
In-Reply-To: <20250610175424.209796-15-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-15-Neeraj.Upadhyay@amd.com>
Message-ID: <aFwB-kkK6wM0y0QJ@google.com>
Subject: Re: [RFC PATCH v7 14/37] KVM: x86: Move lapic set/clear_vector()
 helpers to common code
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

Pick one scope for all of these.  I.e. either "KVM: x86:" or "x86/apic: KVM:".
My vote is for "x86/apic: KVM:", because the "x86/apic" part helps communicate
where in common code the helpers are landing.

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> Move apic_clear_vector() and apic_set_vector() helper functions to
> apic.h in order to reuse them in the Secure AVIC guest apic driver
> in later patches to atomically set/clear vectors in the APIC backing
> page.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

