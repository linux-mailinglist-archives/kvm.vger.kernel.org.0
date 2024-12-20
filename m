Return-Path: <kvm+bounces-34189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B127B9F8912
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2DE16CA02
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 00:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1494C97;
	Fri, 20 Dec 2024 00:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbRAchTi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE10134A8
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 00:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734655378; cv=none; b=JOW0gg8ahyXRipDgjQEI9F7c1NlyDdgrSRv3QkmUhSfVADhXGVsg7T42zbJ+JijUrG5K+eKWNPov07cB6SUlnZedA69z2rh9NUaMIlhLkNn9X6KecdUC7UBABDBpFsY2/9a3GosDk7u4k+MIghqoVPWEzNO0VaLF6dOHF33Sp6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734655378; c=relaxed/simple;
	bh=25NIKixz8K4axw9MJEzYs4LYM7ccJYCm1Otv6fpECMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JwuJlBpPrBo2SegJAPQytyAFotulbcm7G0Y0woYtgHTkwAwuRGJcUOgShAm7EHqP/0dFoAFGHw5rvHUmohllJ+ml0rX9Fvoc/cpUgRNVLF/dafd9OTGDR2ig8GdHeAKoH1beK4pu567gPWs9Bp+THCCNXJuHUoRtqNoA58/FpJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbRAchTi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-728cd4fd607so1273822b3a.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 16:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734655376; x=1735260176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PodBoS32b54JsAl9pHLeWDR36CNehvCvEoxh9C8d01U=;
        b=IbRAchTiCqg4Qp7jr9xp25S2O23vh1FzfxPm2YwsXne8CsSK0sU+jDswB3XSxcORp8
         gHRfQbiNkZ+LmvYTlLZ8UkZRCRJhmuK26ZyPvE86/+yHpuU04EN8qr8x3xuscBiVwVQo
         aa+6U9b8knyBk07qdFdv01fJ/0LFsDojcUJQftrHYfSrLiv0137Y3Sqmm8S9un6N+FVM
         yNNwYNch4CjTj26wdtj1VzP17hqjZ5KQBrWn8H5j2S7YFtBCrRufZ+TCiAZkmssLxB/j
         t4jf0tOFQByiVtZUSuqWCtZ0p9Suho7kx9cjHuUWyHrzEVIW7KWB0DXVq3GC7vLOmQ7e
         2fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734655376; x=1735260176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PodBoS32b54JsAl9pHLeWDR36CNehvCvEoxh9C8d01U=;
        b=hDg9j9kk1U6F50b66XMLebGlzFbea/BQ5cLexZk9l5oB54jnz/Ziq2OmDM03TJmn06
         6WVev9ymQb/9C6nLL+T046MJJzNEECBsXNzRM2TzeJvQuwg4SU1Ndc5D77hw16RW2/S6
         UvG60+Mm6TClhbBDnoK3ECf1K/FVn5OFAKbC4xE+WXnDDrKIJVWqmZJoruK+XD1iFJAW
         4Zck3AhnQL77YA1LsNGZWfsFdNVFDSPGf+UjpSDPyIqvrP6EwSrD7/cGhwV/ZtL3txte
         8Pz137pmikDTYNkc781HYQ7pnQv1uhVEiulnx3V6hll2uW/Eb05XAfThYfyMeB8sczyb
         eRUg==
X-Gm-Message-State: AOJu0YwfXX21qQ/EFKE/mq5oJYsS0+70mHETIk08whrr3vjJEJQ0AFCD
	31wxSJKhk0PSI/5aeAXMmCptRyMP5fIGVC0cF4eEkPPMTJ/O0NOT+aPvnxxyHtmA9HeHB0HeOLi
	2TA==
X-Google-Smtp-Source: AGHT+IEt8kAq9sioD+Me+qBGwD4EU4WFuNQ4mfX3J0g1amYpO/cLV/NmsfvUlW22Te2QeDhhN7gjHMX6WaY=
X-Received: from pfbbw10.prod.google.com ([2002:a05:6a00:408a:b0:725:e84a:dd51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:32cb:b0:729:1c0f:b957
 with SMTP id d2e1a72fcca58-72abded050amr1203427b3a.25.1734655376034; Thu, 19
 Dec 2024 16:42:56 -0800 (PST)
Date: Thu, 19 Dec 2024 16:42:54 -0800
In-Reply-To: <20241021062226.108657-5-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241021062226.108657-1-manali.shukla@amd.com> <20241021062226.108657-5-manali.shukla@amd.com>
Message-ID: <Z2S9jtXSRQg4_IXw@google.com>
Subject: Re: [PATCH v1 4/4] KVM: selftests: Replace previously used
 vm_get_stat() to macro
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 21, 2024, Manali Shukla wrote:
> Compile tested both the selftests.

To be very blunt, not actually testing changes of this nature isn't acceptable.
The HugeTLB dependency of dirty_log_page_splitting_test makes it annoying to run,
as does the root user dependency of nx_huge_pages_test.sh, but I wouldn't say
that running them is hard.

It's a-ok to not fully test code when you don't have the necessary hardware,
configuration, etc., but generally speaking the expectation is that you test the
code you post.

>  static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
>  {
> -	stats->pages_4k = vm_get_stat(vm, "pages_4k");
> -	stats->pages_2m = vm_get_stat(vm, "pages_2m");
> -	stats->pages_1g = vm_get_stat(vm, "pages_1g");
> +	stats->pages_4k = vm_get_stat(vm, pages_4k);
> +	stats->pages_2m = vm_get_stat(vm, pages_2m);
> +	stats->pages_1g = vm_get_stat(vm, pages_1g);

Converting vm_get_stats() to a macro, or rather, changing its parameter to do
token pasting, absolutely must update all users at the same time.  With only the
previous patch applied, the affected tests fail because they try to get stats
for the string "\"<stat>\"".

