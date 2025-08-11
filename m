Return-Path: <kvm+bounces-54449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D53B216B4
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36DBA1A24671
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A402DA742;
	Mon, 11 Aug 2025 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KMiKgSmr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884CD311C02
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754945150; cv=none; b=THg7R5QmE0/J1T+baIPLQnUBCIaLNZTL4dPbh1TEJgSgyZ7BuQNWCPQBJpPVf1WCQQE9lMxGHHdxPh1O2QmEh3CdDransQlhTf5+AzFZ4W1ar5HYFErisKsKvuOy1lON/BwYWE/bEqHbEUwdZ/pXX6Aro5IhU4MX+nA2KhsvFYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754945150; c=relaxed/simple;
	bh=x9w6V7pENJMTOyxSXxtDBfeZ6hHo/blTfXAWZ/CChgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m9klP29Y+QiuIGVMwXzC9IOLQrML0llHDj9nh7Xjo4YTrjMULHvLEk8Pal7VXaAx0PFdWDwfuSVwxGhWLC2gc6FFXJn81QNBFWCKeD5WluNE2YA9vdO/Yj0yTaz11J7Ta5d7vzfaRLPqdLz1zCBBgbRkU/tWcdqVwPr1b7at51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KMiKgSmr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4274f5e065so4161103a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 13:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754945148; x=1755549948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCzvuaHTksePcyjhE6+vgQKI6eFemBt/7TJj5lqZjhU=;
        b=KMiKgSmrRCisEMKzu0SqZhJgIqx7Q15Z4FkhmFRe2drVN8kYEUzzgLsDdP012HxL7/
         ZhybWCUSruu2XSs+fv7MXBpJ3d51kWFCgTAg/PIvEUuaBoFqekC710JPs7idjnsLIvqb
         bjVg3rTlVFADWSUkZMbrG4GnMS3A0nCXLd/GFB6kAZgSminGnJyB1nZL2S/XO++M9alC
         1gaA08bk3aFnHekDuA88NU90pOgfcIBmQ932CKqFzVdx2ANxc6ZHrx0l19wyD8Ew2cmk
         iXygdosvjQEmxUq5e84Drk2pIsMTghK248HBmIKmmlvRrGt39rs7KWBqK2Yx79BN5F0N
         CkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754945148; x=1755549948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCzvuaHTksePcyjhE6+vgQKI6eFemBt/7TJj5lqZjhU=;
        b=vtRRR/zTTS2SBSLf3ki71ve43xebI6hS3icXSoyTZ1HkhZ43jj5C6Fgz4LCgJ/wd+j
         oJyYY18kY6HhVgKwzdeWpSLn3aljhL5uY3D3MdCuV/nmNfrtzbzdYIV1quqYbY1u27FZ
         yoXeYASc3YaHVzUtHLwZtSCJsvcsNJC2PyHPU+0CDPn/22zSnT/uFd43MLC70n0BHIRt
         zhKbbKchDEaFikhcM/2H2en/ogNyuME/SWg54ZCjVcXX8H+6Q0X0w+FAPSa1vJJVTzQL
         BNNHItAdFxqSr5KeghEsNxPvWUafFj1Hdwo70Luk7BioWHC3PccOoTzg+mm8hwMzOCXU
         xVGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqyEQOS4M++7gBuhThMvxrvxuPDYvxiRgxqQ3Kj1U5ENstaW5aiVUsWL9JICZxlK1t0Ig=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0jYeNYyVWdZ/oGfpuxx/CzqHYFc9m0tlbX/Bi/cxXF/YYBC3z
	heD54VhSKn8xjdxnA5HolVFrubpxHbFuezjKhP+jawYT2oABLwW8LEt4y7J6hwf9TExYnDCGrcd
	RyZUjBw==
X-Google-Smtp-Source: AGHT+IGbrPTnrEMcQaX9aICrlGhuN/HwbXf/jBn1buIix2r8TwtQnzufznJB8yzLjSRkDiDx2IIc3OUJTF4=
X-Received: from pjqf22.prod.google.com ([2002:a17:90a:a796:b0:31e:fac4:4723])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc2:b0:240:86b2:aeb6
 with SMTP id d9443c01a7336-242fc33d8bdmr13536485ad.26.1754945147830; Mon, 11
 Aug 2025 13:45:47 -0700 (PDT)
Date: Mon, 11 Aug 2025 13:45:46 -0700
In-Reply-To: <20250811203041.61622-3-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250811203041.61622-1-yury.norov@gmail.com> <20250811203041.61622-3-yury.norov@gmail.com>
Message-ID: <aJpWet3USvXLWYEZ@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: drop useless cpumask_test_cpu() in pre_sev_run()
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Yury Norov wrote:
> Testing cpumask for a CPU to be cleared just before setting the exact
> same CPU is useless because the end result is always the same: CPU is
> set.

No, it is not useless.  Blindly writing to the variable will unnecessarily bounce
the cacheline, and this is a hot path.

> While there, switch CPU setter to a non-atomic version. Atomicity is
> useless here 

No, atomicity isn't useless here either.  Dropping atomicity could result in
CPU's bit being lost.  I.e. the atomic accesses aren't for the benefit of
smp_call_function_many_cond(), the writes are atomic so that multiple vCPUs can
concurrently update the mask without needing additional protection.

> because sev_writeback_caches() ends up with a plain
> for_each_cpu() loop in smp_call_function_many_cond(), which is not
> atomic by nature.

That's fine.  As noted in sev_writeback_caches(), if vCPU could be running, then
the caller is responsible for ensuring that all vCPUs flush caches before the
memory being reclaimed is fully freed.  Those guarantees are provided by KVM's
MMU.

sev_writeback_caches() => smp_call_function_many_cond() could hit false positives,
i.e. trigger WBINVD on CPUs that couldn't possibly have accessed the memory being
reclaimed, but such false positives are functionally benign, and are "intended"
in the sense that we chose to prioritize simplicity over precision.

> Fixes: 6f38f8c57464 ("KVM: SVM: Flush cache only on CPUs running SEV guest")
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 49d7557de8bc..8170674d39c1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3498,8 +3498,7 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	 * have encrypted, dirty data in the cache, and flush caches only for
>  	 * CPUs that have entered the guest.
>  	 */
> -	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
> -		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
> +	__cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
>  
>  	/* Assign the asid allocated with this SEV guest */
>  	svm->asid = asid;
> -- 
> 2.43.0
> 

