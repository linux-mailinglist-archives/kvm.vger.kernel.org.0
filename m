Return-Path: <kvm+bounces-51942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F231AFEB87
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 536D8188505A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382702EA157;
	Wed,  9 Jul 2025 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z2gMGYnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772B32E7642
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069997; cv=none; b=kFwJ0rCHg6cOafsqaUQb80RSe97f39o2VQNVr7wNaFLKU/6Jo8vWItQ9/R0TxQ+oRxjeBF1XDacSe+Ur0V/617EIqnz2Pu0ShfkuUU6QohNGtsHCJGZo5pVZkAwmpZKVaf53Hyl93d7ZTIqmz+VGLh+TZ5I2I49GFUQ9iHRnFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069997; c=relaxed/simple;
	bh=K2ubXN8Y7FV4gsNj9ChZZrRRUrk7boAkqhqP2kLyldg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j0ouL+a+Vp8z8H/f0QH98g4Q23fb4aioDvmYuf7+P5sYgRVJROEy6lfKJeSK2XFNyq4kEp4e5zF50iA2SiwX7KjcZjGAZuMeLtLpdJ4H/NoYQsmD/YJnF00GCc78CyIlQpsEqD/hc5EX4vtn97Yyw62K04IWF66o+E7RhOc9ULE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z2gMGYnW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso3553717a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069995; x=1752674795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XipEZY8UbdY2iY2xgScmeGFI4rkvAM9wtVZR86idj3E=;
        b=z2gMGYnWLTEsu0hJjmoi4y0VCPBz2zN2pGqpq6Ce/W/GuNVcYb+ycD5le2Bm7DLgaR
         kj5JSWr57lgVMbPhv8M+VQJv4N+ssg0EDSgBxE/1X5UD522AZdq6MXgKiAhFY7DI6XA5
         5mCePj7tLipVqnK/KgGj2a/KbtRhApemziPtCBCs5P2sDfArVIN5v3zXys8bijWP4P3E
         44U+zAWjITIpPoBPKIPrzHmWpLwmeNeTHuYEta127oYFn7TB6js8CQqk9ZM5hdAuA6SY
         UwVlgN4umDb8g8PXCnB/NfSMLc3Rkooo82G+llkh2MgAqfV5tjLyMllLXCXBg42ge07K
         mvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069995; x=1752674795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XipEZY8UbdY2iY2xgScmeGFI4rkvAM9wtVZR86idj3E=;
        b=VhQfgI+R+LWYMG1FKA7QC6U8HI2NTFhlW/5GRzWa7VA2h6oFg0zPieqI79s/9eEsVz
         VufN1imU9DqunbaK6jQAS0cwlM/pQDS4v3ha+ejvq1HhX1mrzTIf0uT/ru5CULtnJl4T
         ekpUMfge+TBCVVRsuzAG0iaSSrja8iDlMykRmwWlnlQf7kYf8QKJKtfL/+QU0skJEq/K
         QNTobPGnCE8y08N3UtDjxJyYR+qI+5uarbxOalufWjOSuTTkLVS+hQSpYw3V9MPluBw0
         71C3qPgj6LzXLleEu72NZBzAKqVA39cT37HO8UpGGYbnq1C/JOYGRX2VmbkWRI39LvLn
         NJFw==
X-Forwarded-Encrypted: i=1; AJvYcCVHvnl7dHG1NZajHlANJyV06I3inynFDWwJ2uoHBGPc77TBo0IqXP0aThoRmbK1vS5+gec=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrRPOcB9ra7MW3MRvtxMH+Dl4cRh+WCDbHIBe39jlQ6R+ApncP
	hfFpPaIbJiRNfcK9BNZ/4GWor07VeO1IPaGFGRfh0nK4CZmG/9wv8+2DsADATnw61lgu2WEHQYz
	f5nuVUg==
X-Google-Smtp-Source: AGHT+IF0cjdX1UgdEZi2gM57ZVPSAIjTiT4q1I3Mb4JhgStZQ6TbejjYG9u2HzHUMY6MGxy4uA1F8k/rwqA=
X-Received: from pjbcz4.prod.google.com ([2002:a17:90a:d444:b0:31c:15c8:4c80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c7:b0:313:271a:af56
 with SMTP id 98e67ed59e1d1-31c3c30a79amr39477a91.30.1752069994773; Wed, 09
 Jul 2025 07:06:34 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:06:33 -0700
In-Reply-To: <20250709033242.267892-10-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-10-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53aXD7IsiXBR61@google.com>
Subject: Re: [RFC PATCH v8 09/35] KVM: x86: Rename lapic set/clear vector helpers
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
> In preparation for moving kvm-internal kvm_lapic_set_vector(),
> kvm_lapic_clear_vector() to apic.h for use in Secure AVIC APIC driver,
> rename them as part of the APIC API.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

