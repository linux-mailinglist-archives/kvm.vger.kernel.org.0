Return-Path: <kvm+bounces-64006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F652C76AC4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 1B5802BE2C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B83F30F534;
	Thu, 20 Nov 2025 23:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4DcBHnF8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94C30FC17
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682760; cv=none; b=hWpF++984+B40uUVsvU4YCNd3fny9yso0G7FDwK1us1K9c/LmqACfSgpvjoi6KR/PtH5fWEZTu6G+jcQJnhvYH2xcuPWIX1SoeBE3wQpi96CA19Og6Ln39n8jCfw/xf0PuFGwFlodsth3RIrWpqJH0FvMGSJXEuQVvBkDvSDGTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682760; c=relaxed/simple;
	bh=d5SFzwpVfTqHbDmF71qtCD5IheHmSs3pERubds/cQXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LRChIzelqtj6yr9Y3iXogHqhL5CWeQBMSr9xvZSlOq2EQb816zPIDZ7geIGEatYhMhVpVDaAu5rareZQ3LBc+XCrkDALXuKb3TL5goyNcdVfkHVWPtqsMxJXEKgvjtZPTMdS7/dhjmlQesFmRP6AOpZrei0csBlgkn1q3X1fWo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4DcBHnF8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7ae3e3e0d06so1212395b3a.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682758; x=1764287558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9iqLKx2gkjXebRaCGAi49cf8rrme+DnuhmEkCCPYMD0=;
        b=4DcBHnF8hWqKnGCvpdbYwFJsP0Nhta3fXfJsieXujvbjah5AIah54nzOgNkgra/O5q
         IBdBLRuAJlQp+SLvi0muRG6WHryw85AOQhDONHNkWSavppEzMX31f3zQd2fXSKLpKs6D
         LRn3535Hup78bCxYsrqGWryIsDk1264Bovlpc6SXv8b7+9H31r9VRoAfnmXK6CbAeMaD
         yZv+lHl+MQF22cM9nHFwBiQC1ALn9XbqwBOnJmcVec3TN8F02MsMV+zi2yMkpP/epNot
         GzWqLia8FGG8bHsl48vFwX6u+cl3s9+aIui+9+E15OnTzMHwZmeJCp0ywygRw7/fwhXt
         tI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682758; x=1764287558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9iqLKx2gkjXebRaCGAi49cf8rrme+DnuhmEkCCPYMD0=;
        b=Pzk8Go1BWhSf5rkgVa2seGsB7Kia4k1QtWYw8bVleIRSTMmuxUdsVrk3cQdUR28dCG
         0r97rzNKlGkzGg2I5NcCtl5Sev6PVd/4mrs8koxA8oRMPemZMIkUXQPKi0TqN2GF5uyX
         nt7QVZ0ribpRG1iSHNHXy931zj4YtcX261fdCtq2BSAIMgdzfrEzlG4ccJUDD+93Im+r
         XBLMe0FveEbvSWAatCbU7jBgfmNwIz1uZUeuDc+AxZGSMcQgF88RLAGBr6IKNdSxZXQq
         eBHKS0Wn+/U/wABYtOWTF1bzh+F+oPmh1BBxR4MRTSAC92PcR7Y7vNP9/dZQDHR6MMPB
         FxZw==
X-Forwarded-Encrypted: i=1; AJvYcCUnJfPptpnXQgTHIJkmH+suzCvzAQSLzUZqFTbnR5yfm4WPABfJy9zoPYCE9rSwv+bvQuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNcv/akju1zxdClrbdjtq8+7i50zkz+km/dRArPIp85HXEHi6i
	fA4i4VhQvQwhPxTTDcBeWxLurSxGIXnVzW/Nz9UrBmveaAbKps7DcBbUnkx9F67SM6GUX90++PL
	G5Ar0gg==
X-Google-Smtp-Source: AGHT+IE0SU1I2FVGfQHbJx6CcQ4xVzuTnW2+ll07PiLd7ieZZd/pJChIRZWaWnBCYQ0B2B/gmw65n28p0j8=
X-Received: from pgg25.prod.google.com ([2002:a05:6a02:4d99:b0:bac:a20:5ee0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:244d:b0:35d:b963:f877
 with SMTP id adf61e73a8af0-36150e99468mr33369637.25.1763682758413; Thu, 20
 Nov 2025 15:52:38 -0800 (PST)
Date: Thu, 20 Nov 2025 15:52:37 -0800
In-Reply-To: <20251021074736.1324328-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-3-yosry.ahmed@linux.dev>
Message-ID: <aR-pxbAtS9J1mfxM@google.com>
Subject: Re: [PATCH v2 02/23] KVM: selftests: Extend vmx_set_nested_state_test
 to cover SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> Add test cases for the validation checks in svm_set_nested_state(), and
> allow the test to run with SVM as well as VMX. The SVM test also makes
> sure that KVM_SET_NESTED_STATE accepts GIF being set or cleared if
> EFER.SVME is cleared, verifying a recently fixed bug where GIF was
> incorrectly expected to always be set when EFER.SVME is cleared.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
>  ...d_state_test.c => set_nested_state_test.c} | 125 ++++++++++++++++--
>  2 files changed, 116 insertions(+), 11 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => set_nested_state_test.c} (70%)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index b9279ce4eaab8..acfa22206e6f3 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -100,6 +100,7 @@ TEST_GEN_PROGS_x86 += x86/set_sregs_test
>  TEST_GEN_PROGS_x86 += x86/smaller_maxphyaddr_emulation_test
>  TEST_GEN_PROGS_x86 += x86/smm_test
>  TEST_GEN_PROGS_x86 += x86/state_test
> +TEST_GEN_PROGS_x86 += x86/set_nested_state_test

Hmm, when you post this with the next version of the GIF fixes, I think it makes
sense to go with nested_set_state_test, so that we can bundle all the nested
tests together (selftests are often sorted alphabetically).

>  TEST_GEN_PROGS_x86 += x86/vmx_preemption_timer_test
>  TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
>  TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
> @@ -116,7 +117,6 @@ TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
>  TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
>  TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
> -TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86 += x86/vmx_la57_nested_state_test
>  TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
> diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/set_nested_state_test.c
> similarity index 70%
> rename from tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> rename to tools/testing/selftests/kvm/x86/set_nested_state_test.c
> index c4c400d2824c1..fe12fffacd2ec 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
> +++ b/tools/testing/selftests/kvm/x86/set_nested_state_test.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * vmx_set_nested_state_test
> + * set_nested_state_test

Just delete these comments, they're completely useless.

