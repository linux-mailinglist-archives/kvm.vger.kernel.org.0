Return-Path: <kvm+bounces-24289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9B395370A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF55A1C237AA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD181AD3F5;
	Thu, 15 Aug 2024 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7H7vJFW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07104C69
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723735399; cv=none; b=c+fIG6SzUyP3uYp2hhpMGAM3Euk987uRYkJrFon3y/+2ypjBhGZilQwCHzNotpOcjlcyPHTO1WOoXp4Plp5DbBJ43SPL9eL5Q80HedkdXbsFFitN7stWi+b2L6SOnOgqc7QHUGZiTprNck5RNNq9yBUSJUdninLlVtTsbBN+/aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723735399; c=relaxed/simple;
	bh=RCmMBR8DvUYeuvHk6y3sEzZPOE5ZBWrbKoIqGeQ9lWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=XI6Zkr07hzX+zoLL/W0IwwvbyYMQ77cM8lIqp25Px2zX30j5YP1YZN1ou9pgjtsPdhv8LWNBVYYiG+8d2rcaGvwArq4ZWXIyVXXFJ8VIF2233ddzr6jOvCQ/3hm9pAXCAxqKTbgIXTsSZY+RKbvFQLtQ28sLBh/nWY0oEB8ZCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b7H7vJFW; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1df50db2so762422b3a.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723735397; x=1724340197; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ZHCOvhAjcmBbX1eOeOharlXaIX1okAqgVUy9FSEGIA=;
        b=b7H7vJFWv/E7gPm7yd+JT827VrbWqc2F0PwUNhvwaSD3f3DBZlilmVF/fkr+6DCG1K
         aqeJKUxMmW0GlyzWbdXbQNrQfUeL+rV05eUM9xmRNaejG7rGZp8wzTPBsAwHZV7/zZak
         UFQ5rtE+Nfg1ezM1Ygy1huHszDhJXZQpnFqjDQLjP48DCHjRSkxhALT89sybkAzERRRZ
         vdAPRCkmrdAi/l5USDzvSQceXbKTueKjhicsu2CuARVxg+4gZOmrsDQk8uqQcm5ekNIs
         +bmZWQNy6cu5F0w510FJWTLXzJ9euSepNg43/nh3RTICPGbEzpueNhOhoRowR2XUhHU6
         9DWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723735397; x=1724340197;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZHCOvhAjcmBbX1eOeOharlXaIX1okAqgVUy9FSEGIA=;
        b=sZ7YJHNP7nvnlNV4+eISSrEFIRtdkoEAnkdbfftTi+QutOZvUrUQfe2rGTbTMlHSEn
         PabLikvbkg4I4k3JXfTVJz9+yzvXmA90lxJtPVZ8GuVoBUr3gzDbWZACdKa7alezBlK0
         bqCGeF9HRahuOCnxVDMeJZQLwHEb25cnvsdnbENqEfln0lFuJzXT4+Aqw0qDOfQQHZqe
         lgARcOTOZWBu8r2kiWNspIitf94cfm1H/Wf8LLJR/PaNUPhwI6VED1vZw8RR/D5nItTG
         yopN1qiNGYkDjElkg2MimspcfXgjYItNxoGsKTdYz7JVK1Wx9pcYbxjcJ2vbesakkHso
         pDbg==
X-Forwarded-Encrypted: i=1; AJvYcCVU+6qdu3tY6Gz/M1Bu4UO7ZXT4g6xRKcKkwwflfvNCFA04eVVy6drz3+rPJ6aWrYDVsAvboJaZh3075Bez3jQiqVCw
X-Gm-Message-State: AOJu0Yy13kV7Yib8EE/dXEGstRAKA/yzW05pdBFcu4ojmEdCoUgSZbLd
	0e36TxcYafMhDkSIKJFFgtgQRG8Q7NQWr8OoVGspgIjfgTMk+5mzH7CCTIt8KOW8EdJH0ZXyVqU
	FYA==
X-Google-Smtp-Source: AGHT+IHmTF1tHqrCbwhVwT870NoGi74qkwpNRwiZLS3kdWZMOuGyHdwVhFJz1azvuma30wR+ZpAWfYoUa/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:915f:b0:70d:3466:2f1a with SMTP id
 d2e1a72fcca58-7127aedd631mr17807b3a.1.1723735396761; Thu, 15 Aug 2024
 08:23:16 -0700 (PDT)
Date: Thu, 15 Aug 2024 08:23:15 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
Message-ID: <Zr4dY1EbVu6u7Czv@google.com>
Subject: Re: [PATCH v8 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 05, 2024, Sean Christopherson wrote:
> The primary goal of this series is to clean up the VMX MSR macros and their
> usage in KVM.
> 
> The first half of the series touches memtype code that (obviously) impacts
> areas well outside of KVM, in order to address several warts:
> 
>   (a) KVM is defining VMX specific macros for the architectural memtypes
>   (b) the PAT and MTRR code define similar, yet different macros
>   (c) that the PAT code not only has macros for the types (well, enums),
>       it also has macros for encoding the entire PAT MSR that can be used
>       by KVM.
> 
> The memtype changes aren't strictly required for the KVM-focused changes in
> the second half of the series, but splitting this into two series would
> generating a number of conflicts that would be cumbersome to resolve after
> the fact.
> 
> I would like to take this through the KVM tree, as I don't expect the PAT/MTRR
> code to see much change in the near future, and IIRC the original motiviation
> of the VMX MSR cleanups was to prepare for KVM feature enabling (FRED maybe?).

x86 folks, can I get Acks/reviews/NAKs on patches 1-2?  I'd like to land this
series in 6.12 as there is KVM feature enabling work that builds on top.  It's
not a hard dependency, but having these cleanups in place would make my life easier.

Thanks!

