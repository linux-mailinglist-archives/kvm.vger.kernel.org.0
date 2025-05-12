Return-Path: <kvm+bounces-46261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F425AB450C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87D7319E29F6
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 19:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCE4298CB2;
	Mon, 12 May 2025 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4kLthsVE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494F297A78
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078643; cv=none; b=rf6Ik+mHjm8R99mwSY4IoBFmd9vTG27s/RAvT2mzi66rIyKmjlC0b9pov8RD4vd9bB3dj005i9+54KQzTO/As9wyzjxn9S0xxTqdnwQyO9SrwF3oQlGq5a5T9TQ0ViSNQCkudsodu38NLhvaRjzERTsXov4R9lbwKzixrbeyek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078643; c=relaxed/simple;
	bh=QWiCLP8D2rUi6TG/MoWMjJzDeskVuP36w/zPOMjGcws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JChkJE6Log1WAzmFeWevDIr3ebuNAOJZSh0adGIBChKnlQcBqju1uNxhbcW4Cj6c3otX883zuTyrrDD/1m477Nl6x1DQ6sqNFv1ODUbZTlJv/SV5W+vAU1NHl3WFjkhKhprPbbDqxFpR/F8YG3A7LHSDSYlCY9SIPqIB7IWRJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4kLthsVE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c8c9070d2so3051036a91.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 12:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747078641; x=1747683441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=38HKQiklWepPU3qbWvVj4j0NVLrqbA0sO4nv2WaJHSU=;
        b=4kLthsVEzqD663f3iK1mlng4rS1zzIOSA/ICh91vJrJyQf3lfklRG2GvrvMc0fKl+H
         9K1D43ebiCJ1n5TwVrWHxjZpWxc17q0CnMnOTfS231STmRbd8i+WUZF64zxBjHfcvXsJ
         ApR2Yn0BIsC1PhgombGFK8LsxgOKDCYmpOWPvgS+pGLTIOLAQe07nxItH8bmwkHJhByX
         a6Ksu5rsH8sWSO06ej5WmqTyoBU/KZQhOpof9lbJLYFPacQIB/K1KVxK8MGA1B8QGXQv
         ans453i4U1+6qkdjv+zqVVeNMnm7V6nx1iy0wF88lWGLsv0I6f2y01lAYW7HeIGP+OxB
         XxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747078641; x=1747683441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=38HKQiklWepPU3qbWvVj4j0NVLrqbA0sO4nv2WaJHSU=;
        b=OOX4BvD+AJ/FWbQhLs4L7zFQWat1RTM+9Fa1+WT7RnTbhHzXLaBaEaZru5Y+kO/qUr
         T/j92dVCqBils8DkhP2GDL6oFlZoKa75juz6uSsiIvXpEIoECsREebwjaGI7VjOs2izz
         qZoJ16mQwf4jgmHoTQuYukw0NN8CJk/faprQkAs+LCCix9pTh8SsINkXR1GWkOqlAkL3
         t1RVGCuBV60uOYQ2ODuQgyJmN/c17mmVhf6EA1FRZkmMZ4ot/VUh35JiSlEAp4JNwIAL
         wE8jkA03l6O7Sbad28eh8/TwF7sFnwpN+JNY4nYtS5yJrVEBm7wK++jqlaTvaH3ZMI9k
         X93Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsMqDo63o5H3y22wxJYS3ukorFLKiGB8+3C5shc2n3Eexaw37PsydCwCK4y7EqbCHCCTw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj7b74H3GNuFW6Z4WaJfmxhX1BqLA4KpRYU/fNA8EhM6ioRDIU
	wFnhM1HnrGG+hbGuAEFOLdBrLECFWLv/j6Ss+di/iCSxm0uSOmieHTjYn0rawQfJE9FVzFzkkUE
	9Gg==
X-Google-Smtp-Source: AGHT+IEH/vApxszPhZUNxCOdgc1rPPj0HCQHT2dwioZc2EGArIqaGYNc0uWa7Ib8OiwC6GxFHUvbjJ13Q9w=
X-Received: from pjbpb18.prod.google.com ([2002:a17:90b:3c12:b0:30a:953d:af9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380f:b0:2ff:64a0:4a58
 with SMTP id 98e67ed59e1d1-30c3d628b6emr19141945a91.22.1747078641552; Mon, 12
 May 2025 12:37:21 -0700 (PDT)
Date: Mon, 12 May 2025 12:37:19 -0700
In-Reply-To: <20250313203702.575156-14-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-14-jon@nutanix.com>
Message-ID: <aCJN789_iZa6omeu@google.com>
Subject: Re: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Please be more precise with the shortlogs.  "Understand MBEC" is extremely vague.

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Adjust the SPTE_MMIO_ALLOWED_MASK and associated values to make these
> masks aware of PTE Bit 10, to be used by Intel MBEC.

Same thing here.  "aware of PTE bit 10" doesn't describe the change in a way that
allows for quick review of the patch.  E.g. 

  KVM: x86/mmu: Exclude EPT MBEC's user-executable bit from the MMIO generation

The changelogs also need to explain *why*.  If you actually tried to write out
justification for why KVM can't use bit 10 for the MMIO generation, then unless
you start making stuff up (or Chao and I are missing something), you'll come to
same conclusion that Chao and I came to: this patch is unnecessary.

