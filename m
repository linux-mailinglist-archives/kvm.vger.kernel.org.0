Return-Path: <kvm+bounces-64008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DCB6C76B08
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 596672F659
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B786A312816;
	Thu, 20 Nov 2025 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7gVvcuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4D30F95E
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682854; cv=none; b=taDG0u5b3O7uS5wDzc5dlGhRVQK4OqY5qMSut8oZzwFKQPjhstir7IKcp27LtkJ1C2iD6BrOY+E4QlMzHAUEyB+GkvT7AwKSKXIGdJN/VshWF3krXZcNBuaD8Hfdsmy+ukC+gkVXBey7xxnGT14+q+GNkeU0NsZPRBaLRv07QfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682854; c=relaxed/simple;
	bh=/knz902HB8Imeo2DMNUV/a6y2/esyP1GOSH7PCVaBPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qU/xoMmGNva+QLuwPIvj7BVKcLXAXHGsY50DpE6lTDS2cuSemcH1bnTAkaAuxOM3G3OvfcZH3pC85YGv+g+3pLAc+u38gRUVJZH1Y3yyaoaoEd5U4iDygePHEs/uS3i5HOO7kLLi6rWW7POW6gFq1qOddY66Lx+uxiLVx2jdLy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7gVvcuA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f12fso4185797a91.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682852; x=1764287652; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FIc4pBTEFJ7HO22GYtnpqxVHoGYAoRfcBM3r7fGCABI=;
        b=v7gVvcuAMehBOmLyub0Qq7Rdl4Z7qXTKsTvyzQ2lLkjy2i9LSC3drhvAINnnkbwThR
         zhlKYQ2ItmfU1P7qWo/WSNTYJBRiMVz/fRe5wVJ2a+yQx9IYw5Wtg1ycmJVC9SiGp7WM
         kn6OekmX+Wwrzo6keZZaNH+FtfWMGkU3CBOEsfU9LsHH7sPi4alKyM2krgJ4ZiqGVXHz
         gVt2akNxcMgNxn1ZqpG6FWwSeL587Ckgz21Ot8IDdz7Wy5gEAtMsu/V2UTlkPKskzLfL
         Q6RtGYjIiPUmT6AvWgzBfrWD0hs+YZKDq9uaOWhiqFyfNyzJamKBY6bbvelbC0Ixrpo7
         /Ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682852; x=1764287652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIc4pBTEFJ7HO22GYtnpqxVHoGYAoRfcBM3r7fGCABI=;
        b=SwMPI8fXyL0m6LhL4Ep1lJ9/uxsywWhXpkeLaEFedxeuj+R0GDEj0jszbJaxI5v1qY
         F6s2Wl+CYdlZ0g/JoKtkQXtmmnhr6kq68xseHByuYH7ggjkOJNH/5GN7qnlVy6Cq2Zu+
         JBZLF7a2zU0HR6MlT6wxuwjiDl0A6ePCgHme6FeB4cI7WoPqszr2tCBlkgX86pmbqSDB
         exQ/4/eoOQ+SgNfduhzLp9v0TNsk8EfyYGiq9nmHZrYyXKqgufHxYQECWL0G8ToFxgTZ
         tek8m5WH3jOEsDGyx0rC1yRTi0hYQ+dU8TRfvN1T/w36SWbK9qD6gAIu3SpMpsKyQrif
         MTgw==
X-Forwarded-Encrypted: i=1; AJvYcCVYM+zW2HtCcybg7YO15gnTAsfFoNL1qsZXJtrrm3uR2m/swSeifpc2ro3nOcCMjoyh+uo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT79JC8Qv/muHwr6B9zp7PqMLFzTTdsUcYEeU5BPiqsD+s9Ba7
	YOTZQ8fdq4QeSw2JP6SE7KFPN2rtnbGJ8/6jZQlpW9xHBiu0JZLUcKcBtE0eDjAu29KFkKAkOK7
	2YxCApQ==
X-Google-Smtp-Source: AGHT+IGF3DKUx64Jr1r0woEJ7swfbKgkoEESwwJv1xqSl9lAQZl/H1EqWsIV7ALszuixCRECX6BXZC/oiK8=
X-Received: from pjbfa14.prod.google.com ([2002:a17:90a:f0ce:b0:343:641d:e8c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4b:b0:33f:ebc2:645
 with SMTP id 98e67ed59e1d1-34733f2a471mr271535a91.20.1763682851447; Thu, 20
 Nov 2025 15:54:11 -0800 (PST)
Date: Thu, 20 Nov 2025 15:54:10 -0800
In-Reply-To: <20251021074736.1324328-5-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-5-yosry.ahmed@linux.dev>
Message-ID: <aR-qInzhSf1dFxRC@google.com>
Subject: Re: [PATCH v2 04/23] KVM: selftests: Extend vmx_nested_tsc_scaling_test
 to cover SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> Add SVM L1 code to run the nested guest, and allow the test to run with
> SVM as well as VMX.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
>  ...aling_test.c => nested_tsc_scaling_test.c} | 48 +++++++++++++++++--
>  2 files changed, 44 insertions(+), 6 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index e70a844a52bdc..bb2ff7927ef57 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -119,7 +119,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
>  TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
>  TEST_GEN_PROGS_x86 += x86/vmx_la57_nested_state_test
>  TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
> -TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
> +TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test

Please keep the tests sorted (bad apic_bus_clock_test, bad test).

