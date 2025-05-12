Return-Path: <kvm+bounces-46255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2877DAB43A4
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB35A178346
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A8C298CBB;
	Mon, 12 May 2025 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rcSsYrlg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3251629824B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747074771; cv=none; b=qW5MRfi88W/gpJ23JPMMV1Evn7tiNwqN3SifXgLlGyInreL+lLRRVo5OcVfbmZQd7F857ToI0Vc6jkjNZvaPYIOtBzOCwq8jTc13x5coHl38JS5FJHIupY12RDxOv9POSoWEZsfSLZfT/0AufLG8SsWXvVOPOu+mYvZUblxMwMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747074771; c=relaxed/simple;
	bh=AAIIenbc+d7FxcqG64ms5dtMeSFjiKAShRQtQwUxbqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R4Q6LjEN2ZYNsfnjQ34gk2QhPy3digOdLyAbmTvKlpRZ9v8aMGDGD9Q/ODtZhxinEvo5vTnRvfbIUtwMq5dWuckeBJvaPWjJcchd17YKt+naIvFYy2BU6+bFvIv79g7X3RGK/OrGPieOhu++of2mxe/LIEDIMBKEsYqYPdy2f3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rcSsYrlg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1ffc678adfso2871806a12.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747074769; x=1747679569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/gxOKtBBDZqqDmvsSr73mAYX/83+2w4poyEp2awYQM=;
        b=rcSsYrlgO/CgwzbfRi6qKmvNOa7c6rSNuSJTDxnKyhPFfzVdF4IeEOq/iyQ4BuGDTK
         foCLM+jtYYqFVCGld718rmCtyJ88hJVrtPJ/LJ5KmHsrpL5YUzeMT+OuWdzdjmPrCok2
         /4Vnxfpb7CKUceCm4/gj5OfPlxtsddmuB/7/UhNbiuOP8x3feuYa0680Y8CiWQVcJEXK
         goI29sI2N9WuNe/lW2M1kWk9Wu8WynHpm4Dub9fSfgPvYntxkRguR0ZLEUpDArAnOHKi
         c3U/V1RJR3K6wPdC7jYMapwnth7/qNPxP8aNb8B/U3+8EANvm/pXFjQVT2efrGC+yB6t
         hytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747074769; x=1747679569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/gxOKtBBDZqqDmvsSr73mAYX/83+2w4poyEp2awYQM=;
        b=MNLaT1gQd+9LECtN/IcPEmO0WdZCOHB88pSOcD0ydnlmYh1pR5H26s4/rxzIPtw1sV
         R/utTTk/wTVlnPNKf5mkJOiE6CgLhFxQIc7XmJJRrAsV8/NuA5dMz5iEA2/zvHqPvlxB
         xsxLuFaT8Ih5Q6A/peu8hJwkACbg4dT//AOtyjf578LjR3ML0K+ndPb5CqWNpNz/OkEM
         SYmZtf0D58rBpWXTPQYLkHj+6kUaMgmhAto6sfy1vc5HFtzJUZ/6Wrk5MQNQsYf3T2/n
         gOt8m83scmSrNiXz+3A8avDxlnxcntQ4XpEgiKvzL22TtqPMzj3aCGLzxaVcOC4kH/p9
         6Sew==
X-Forwarded-Encrypted: i=1; AJvYcCXdbn+l0iLR5ce+RQcWWNTI76rwAzfKOy5lLItxENEHNifUnGCzuPXV9vNzRapz7boi2gE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7/fMP0hkE0BfyRsSYGvWshjzDy4vrLulqeBWc7LD+mkoJcx0B
	a4SyQywCeQz+3WBTcrbwfIOqUgkHdNavDAQyS47UbXOGHJ8SZPV5rHGdWvyMUQEgli9NGTwn35D
	EuQ==
X-Google-Smtp-Source: AGHT+IG/D/jSo3c5DwUvTZhtwy6RkxcPf+zUGVrU9iIwBmOVhV1e2yEZ0csfAY7+5g9vZ2Pnw1DToFiT7Gg=
X-Received: from pjbqn8.prod.google.com ([2002:a17:90b:3d48:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a88:b0:2ff:5a9d:937f
 with SMTP id 98e67ed59e1d1-30c3d62db46mr21960004a91.24.1747074769292; Mon, 12
 May 2025 11:32:49 -0700 (PDT)
Date: Mon, 12 May 2025 11:32:47 -0700
In-Reply-To: <20250313203702.575156-10-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-10-jon@nutanix.com>
Message-ID: <aCI-z5vzzLwxOCfw@google.com>
Subject: Re: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in kvm_mmu_page_role
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 71d6fe28fafc..d9e22133b6d0 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -45,7 +45,9 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
>  #define ACC_EXEC_MASK    1
>  #define ACC_WRITE_MASK   PT_WRITABLE_MASK
>  #define ACC_USER_MASK    PT_USER_MASK
> -#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
> +#define ACC_USER_EXEC_MASK (1ULL << 3)
> +#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK | \
> +			  ACC_USER_EXEC_MASK)

This is very subtly a massive change, and I'm not convinced its one we want to
make.  All usage in the non-nested TDP flows is arguably wrong, because KVM should
never enable MBEC when using non-nested TDP.

And the use in kvm_calc_shadow_ept_root_page_role() is wrong, because the root
page role shouldn't include ACC_USER_EXEC_MASK if the associated VMCS doesn't
have MBEC.  Ditto for the use in kvm_calc_cpu_role().

So I'm pretty sure the only bit of this change that is desriable/correct is the
usage in kvm_mmu_page_get_access().  (And I guess maybe trace_mark_mmio_spte()?)

Off the cuff, I don't know what the best approach is.  One thought would be to
prep for adding ACC_USER_EXEC_MASK to ACC_ALL by introducing ACC_RWX and using
that where KVM really just wants to set RWX permissions.  That would free up
ACC_ALL for the few cases where KVM really truly wants to capture all access bits.

