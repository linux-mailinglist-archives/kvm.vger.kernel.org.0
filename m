Return-Path: <kvm+bounces-25436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DC2965601
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2163BB23905
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694DE14AD2D;
	Fri, 30 Aug 2024 03:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMp4jy1J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645429A0
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 03:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724990071; cv=none; b=PYj7Nfuhyv9vVRGA7ATmKyL+iBMaRCi5BM/2DdkywZPOLUXqkm6QIbaAYacVzWsY9j7u0+DD6WvsDOI7dukt1yVaMQXEzlzzR0EPLcz9gPW191XBN/W9ysXIlum7Vkwt7yxmXCOVwYsWsfFpeGve2SU7dMH/i8sN9kALpFHlNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724990071; c=relaxed/simple;
	bh=31dLxBG2pHuc5K43M1r7dD8jYtIW5XvOexIWLpQY+N8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l6JWt13CChZRxIQHk5hsUzC2zMi98Ka8EHT308RTGM/Fn8QxVih/rcs+nqsA1evMCtTR9E1zDJKW5q94uHQ43x9Ta0c5HssduwMoZVM5I2ANmFc+iyM6rOR/ajVfeiINZ7KGbhZsZ/baRQVByggEYc6lPuOc8KaxlgqsBQ+aiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMp4jy1J; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20201834f25so13466675ad.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 20:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724990069; x=1725594869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tOG5qkNNDJkY18+7TrbFk1KrDMJwlUHvCg9BDGG+Cc=;
        b=eMp4jy1J7BWTwOrrh9xlzgpbw+1ovI7MnWFATLKnlfA0sdrpKqx5eJJmUIwFw0vA7S
         OfBH+IfPIOs3paklAtz3LmRxsFzIXI7yvDa7/QR0nWP44+s8973WUZ7QFMYBK7RbF05/
         0YRabL+sVw32wBWj6rw9i2QIRi1P9dbNWiWCp78W0YaDi/qZJakPmKuiCwwmODw+nOEe
         dgxne1LaHWdaAk+XAOKwa9O/pqFsyWvPxhNtX0Y6pQpBsWLpTgayuq6p8iZKNSbuLXWB
         L6FukU9BRyJ4SQWXMqtQ8w7nVF7ZmuFWhdM5VdYEA2gtc4YXXpelLdwhiaZeK3eX0Zj/
         oNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724990069; x=1725594869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tOG5qkNNDJkY18+7TrbFk1KrDMJwlUHvCg9BDGG+Cc=;
        b=S3tGHSpdJ7OkcsTOIcBJ/ttFuelszLoq6df2WwRRkeC1F/VVMilOodxxT6lEgIMdCo
         FcSJNcf0oKZbfgRwgbbbEzifv3rP5olPmZKL+ovsPGnvuNkuMqTiVr8w2vh+Q3R/x3ZP
         7Qf87kBUDxAsqV4RoKXWiRYl6ZbktsDbdSm4R6ENhhJoBB0oALp32d13V6+40VZ69K02
         eLCS+3R2zF0Ri9edbnduCyl7cjZ0b2Sx+FN0z7PLCTLMO7gbO1A+zyuUrwJ4JrrTccG1
         7A6OBp+Eus9l8g4CtrhtKukfQqpPZXAO65a6LSIRVuqzHHNtBhAVtTVUsHPNoBybEBnn
         IMyA==
X-Forwarded-Encrypted: i=1; AJvYcCWkshTGKnf+GOnG71Q923m50oxqU2HAZw04BKgvxDmQN+jzoy4wiFlC+mHw/Jmv+/wrpGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoNOvwbjfI2DBHAcwW0+Zjyq0vCmhP6EyqBIkDjDEQwjtLFZM6
	+Ujm/f5MvOlypnEdti4fkE7hbwnViWUvOsLGn9t6txJ7eD5qen5PadOAhOxwbo9GBTE5b8obOy0
	MXA==
X-Google-Smtp-Source: AGHT+IHXNByn7UwwVavNe4gNRft8EMTNHYeUebn7k4fMModwtDay98ihGuJA7AjWk1/w3mOUUhhVhuzDyT4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d507:b0:203:616a:8673 with SMTP id
 d9443c01a7336-205275079a6mr921775ad.5.1724990069398; Thu, 29 Aug 2024
 20:54:29 -0700 (PDT)
Date: Thu, 29 Aug 2024 20:54:23 -0700
In-Reply-To: <20240830022537.2403873-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830022537.2403873-1-yuehaibing@huawei.com>
Message-ID: <ZtFCb_zN1eik3Xn-@google.com>
Subject: Re: [PATCH -next] KVM: x86: Remove some unused declarations
From: Sean Christopherson <seanjc@google.com>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 30, 2024, Yue Haibing wrote:
> Commit 238adc77051a ("KVM: Cleanup LAPIC interface") removed
> kvm_lapic_get_base() but leave declaration.
> 
> And other two declarations were never implenmented since introduction.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  arch/x86/kvm/lapic.h            | 1 -
>  arch/x86/kvm/mmu.h              | 2 --
>  arch/x86/kvm/mmu/mmu_internal.h | 2 --
>  3 files changed, 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 7ef8ae73e82d..7c95eedd771e 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -96,7 +96,6 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
> -u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);

Ha!  I have an APIC base cleanup series that I'm about to post that modifies
these APIs and does a similar cleanup.  I might defer deleting this declaration
to that series, purely for branch orginization purposes.  Hmm, or maybe I'll
split this into two patches.

Anyways, just an FYI that I might tweak this slightly.  No action needed on your
end, I'll get this applied for 6.12, one way or another.

>  void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 4341e0e28571..9dc5dd43ae7f 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -223,8 +223,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  
>  bool kvm_mmu_may_ignore_guest_pat(void);
>  
> -int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> -
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1721d97743e9..1469a1d9782d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -349,8 +349,6 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>  
> -void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> -
>  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
> -- 
> 2.34.1
> 

