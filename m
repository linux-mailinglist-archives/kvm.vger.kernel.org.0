Return-Path: <kvm+bounces-51936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E905AAFEB82
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B37086449F6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BFE2E8DFA;
	Wed,  9 Jul 2025 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="USGXwLDN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F62E764B
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069830; cv=none; b=YH52BC7WHcgfuA4pBJ9Ve8mPcDWS6XPs5x7oOQGHXfenk+n32QF0oM+FiItIV4QTGm/IOuNcabPtEjbfPFI06EmtfzMnh5skFE49cAWeoMIh1DOicLKZdzrU8uG+DQFAZlBwoByuErIKX40raR/5bB6YHgfhU5fSkgsGShpNbtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069830; c=relaxed/simple;
	bh=B4BEBVfO43SbmgceatslkYpp7eXsXn0FMJ6j+FiP5kc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YYSzXvXR7e+MLoNlUdpXzQaVI70OT1G8S1FpdilQIJikMu/x3/tSMSWxMaIKJ6nl+Mv/GVllSiUtWqNu+/Q2DRUNV4RsjUBKS1pXmy2sx/aTNxXvS645KL76F5v6ZnsCNmjBP7b9KaexD+GHNPmNrCcnUN9+H8sIA8uVu72vJPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=USGXwLDN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso7819196a91.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069828; x=1752674628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hykxadXvTSxtN5RusGv413qm2dHa+a46+Kml5di85rU=;
        b=USGXwLDNlnWRprMHIWtF8fdYb1MLxe55+OrBRWiWP33kXKLqiiDNf6vgx2OwsBm/RV
         iP3nSrXnDzAsmmf+IGaln4HkllajWlRcoXi8oRImTrhiNHjCMCsKPTEhm0fsMNvGOAku
         9Kr5iYV5JLKviA2PmJoceUbvDSW71TL+gi9s8LlKYbZ3jbN0gxpr9Jo5YrEqVPFZcH5u
         aUUhOTRUJB5sayCQD0S1QvCuWrI8xsZLR0nGfBsS/B3HB4ZkcFgK/vzxAmPl3I3RAoH7
         yoqmYGRQaPG7atXtkZB+xoPC1avNzzIQVjnfgyBbT6XQbFqmBPqZi4bQO7G4oZRh1u7l
         JLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069828; x=1752674628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hykxadXvTSxtN5RusGv413qm2dHa+a46+Kml5di85rU=;
        b=KDYXVY87Pq3iTHEwiceS98PCoWMqgeLuob0DTdEJ6wy18qOL4uPupOEdfTGOm4VGJH
         m+RNQefMJsnwJOSAkR9nJwhoSLKVZHKXAYX5ALg3MgZ52mqvPWJBhVPYPpUicl4zaRdN
         Al4r9VrxZUfLpQmF0whdbbSnH42WYnZb5C8883+nbTUhOKPa3S5QCpQGNpC0x74FB8jX
         BnFvcPH2RWo3MXMgg4SJ0Dlv5smpMBC6W/kh/IcKsY54Uw8ktaDtYtlCII6ruDb9/hcf
         T+q0CQ1dSQWAzKTvfa8fYtVgBZZX8yFHIbTNuR0J+oVJ/uJ3zqi4mEDb6+iiGHfciUTJ
         zY0w==
X-Forwarded-Encrypted: i=1; AJvYcCVUTnFNljyzt64ff/MA/UQvP3NFxvft8xFLlC3SlikqM2YjoZnMlB++psrDTCBQK9dhGCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi8kaBg+1ZUKROZ/607Kww9tykOZO0wboq5e9/AtnHeP5rjLix
	e2LGPOHSj4CcdAfeOixATh8VDss57Q+BguaNZrUfC46jTxJGopIjiLzaHUBbe4x6gX3E0UlKxp0
	FqXZF8g==
X-Google-Smtp-Source: AGHT+IENVhgeJ8BB/CtSoknldCEQ//74b5hlP1X6+EAiK7+g1oePobK3Aftm1IJA21KDRMk2vShoory4ir0=
X-Received: from pjbrs11.prod.google.com ([2002:a17:90b:2b8b:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e98b:b0:312:1ae9:152b
 with SMTP id 98e67ed59e1d1-31c2fdd0249mr2655621a91.23.1752069828232; Wed, 09
 Jul 2025 07:03:48 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:03:46 -0700
In-Reply-To: <20250709033242.267892-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-2-Neeraj.Upadhyay@amd.com>
Message-ID: <aG52wupjDpEMChr7@google.com>
Subject: Re: [RFC PATCH v8 01/35] KVM: x86: Open code setting/clearing of bits
 in the ISR
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
> because the _only_ register that's safe to modify with a non-atomic
> operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
> service an IRQ or process an EOI for the relevant (virtual) APIC.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

