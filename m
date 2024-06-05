Return-Path: <kvm+bounces-18972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F20598FDA5C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83C2428540A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B4516B754;
	Wed,  5 Jun 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kroYdbxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC9916728F
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629681; cv=none; b=g5ysxTUO4XyQ+s0jW2MMlhXvcZVkNIVpj/2eWox4PhBvEzO9vZgLPFklX3lGjHHVkjL1bas8njT2ERiLjtYDsN4RnekJSq0HKXsqg9fmZYh6QgIPk4F2cHIC5CWLkFYU8ZKcOZ7sCFbUElVKzyIuGNq/oXbwxsfHWtcLrYze0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629681; c=relaxed/simple;
	bh=qSrviGdz9SdJKmMQvjhgXHOHD64aQaSZf6qr57qV2sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CxrJDsOjN00lg6+II4Md65Wd+WGPP1xcDWaN6SdSsyrouGqy/qbYibku2U+IKC/Ve3sgEbOslXqRIX6kWaxSprS5b0fnqq/YRmmoxVnsnJ2wjPaSCnXirf9MinTwleLG8lVm0WHOydx3lNAdSiYge8sNzBBvFWbF8EvlcageG94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kroYdbxZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6582eca2bso4266065ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629679; x=1718234479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JzxXCpltM5lcn1MmDqbIc8oTgrwSdEGB5JJS9pz+4pY=;
        b=kroYdbxZNt+MpuaaFIenbJLrV/q5N0UUoa1aCkWvjkgkNeIPqrHq8M1B73LQVhIc4z
         K84XABYp9+Du9EpeQfXsBri4G5PuRbo3DEXNkr9ox8vtpB28/JNlA1IM+bKcwVBx5fbs
         J5znRm46kYjVM9xPpO+elMPAIrrbHYV39NnYjBnimcRdN0+HxmM2PE6cFSsllJexgitX
         ciwLWoCbN8QiO9umBsF6OVPdfXGIO5nCgGpoWRWfM9K97iJQSNuSyCqBBD8ej4FLEJCQ
         L4Mk5pIB+8GPkglTL18cXv4HBrcZfLqjGDVnC2x8fAHlVVIDHmXLav5rTfbJgrMmXjOB
         YS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629679; x=1718234479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JzxXCpltM5lcn1MmDqbIc8oTgrwSdEGB5JJS9pz+4pY=;
        b=dTswKJobiogbpLKP+BoGKB/ietT9E1Np9WbJn/tR9Ueu2OLX5u9pqqFr0sDVeRE+93
         e59A5DQZ3/3uXGMFfb+3oxfUGREC08g9+A/ishsOXLshsqrecWRN8v0LSOIQCu3C42Fe
         If1NVl5pFsxnzSIIUW3rjQ6TB/+rj+zzLRKOyiNKwFb8Rx80U439Az92CkbdX6/fkHTN
         NVL5PptusPbyGnDYKwBDUnth/kS8UdyoZf66HQZETpOJqqYg+ObgUHhOBArUalgmeZWz
         Zjekn76vTAmWH/nU8QBNVP7+R78KE0ktKUYvINzLTe6THomwWjw4TSMgrmJXzClmG/m6
         jECw==
X-Forwarded-Encrypted: i=1; AJvYcCVTMi64H2X45oTz27lu0JbfUGVcdaP/GWFkvyVx460warowvef5FEze+Gh76HYPa9B0ifOCr1Ru7Y+mcYxWP0YfQBsP
X-Gm-Message-State: AOJu0YxpQ5rAhi70bUqHmdxZLiLZwV+6OUilT75C8iCyuhnzh0C+rezh
	Mc7K1B5GWgEtbZvD+sce0om6YQUw+Jg3kg8SMA3woIbB57xnq9p77p8FD9GqaYGDuPcC11mc08D
	GEw==
X-Google-Smtp-Source: AGHT+IF8PAkl3OEERuy7p1zzmcXcpWIrmsGymwqhF/13F5C5zEkwuYKfqsFN4+7OHtFGLkc/jOM+iz03tQ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d2:b0:1f3:508:833c with SMTP id
 d9443c01a7336-1f6a586ad2cmr238945ad.0.1717629679285; Wed, 05 Jun 2024
 16:21:19 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:38 -0700
In-Reply-To: <20240108063014.41117-1-dan1.wu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240108063014.41117-1-dan1.wu@intel.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762782948.2911686.521478184084249781.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86/asyncpf: fix async page fault issues
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Dan Wu <dan1.wu@intel.com>
Cc: xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"

On Mon, 08 Jan 2024 14:30:14 +0800, Dan Wu wrote:
> KVM switched to use interrupt for 'page ready' APF event since Linux v5.10 and
> the legacy mechanism using #PF was deprecated. Interrupt-based 'page-ready'
> notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well in
> MSR_KVM_ASYNC_PF_EN to enable asyncpf.
> 
> Update asyncpf.c for the new interrupt-based notification.
> It checks (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement
> interrupt-based 'page-ready' handler.
> 
> [...]

Applied to kvm-x86 next, with one tweak.  To avoid failures in the common case
of running without configuring cgroups, I changed the asyncpf_num check to skip
instead of assert:

	if (!asyncpf_num)
		report_skip("No async page fault events, cgroup configuration likely needed");
	else
		report_pass("Serviced %d async page faults events (!PRESENT #PF + READY IRQ)",
			    asyncpf_num);

Thanks!

[1/1] x86/asyncpf: fix async page fault issues
      https://github.com/kvm-x86/kvm-unit-tests/commit/3ed8e382d4cb

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

