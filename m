Return-Path: <kvm+bounces-14916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2208A79EE
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B77221F223FA
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FD717EF;
	Wed, 17 Apr 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Za2yJcOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EA57EC
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713314388; cv=none; b=Sly05B6ZwuhC9fSwq/pabhGncmb3qmoT+OC7KJ+VHHs6VV66OeUOK+3CtO54GXEEjuWfXVnRWfdadhEnqT68Jtv3K8enwTN5ozuc6Uvh2zplnwEZx1RxMQDxhg+C6xXlhL6XqKwRrrFwzZsNwWWl7C+jpZVGMkJFV288qHfbd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713314388; c=relaxed/simple;
	bh=FbyNbtK36AqmEzY194l7ZNmnDo1F52tA9CX+PzaMTXY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EjOSTQRSR0b9cD6/nX2asiB35yvGjuxD6xI4/ox2bEhJb7rc5NrF531KXqD4mRNPdgwDbD4dOG+VFPk5Eryv4Ei6Pdr0e62D/3wdMqXooq+KdF6YzhQc/ZK0ndxPpGYZqpEPhOgRUDFlLrAv7MHWcQWCNz+1USzoBoGUKWiRchk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Za2yJcOg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b2682870so8370411276.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713314384; x=1713919184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vnQ65n10C6Pq0ZkKHds3ZlpX5TuDQlyTU6+t/yldsJg=;
        b=Za2yJcOgwtPcIdgdC3T3QXK6MZsAJoI/rMRdX3QB04XSkD5JMnOwIa9EDDzHJCJYYP
         10belE5g6mcN4jI3t0HyvT+x/Q7ImGO2PUWtiDRIOsjiwcP9nowt1M1xoJfrcx24S8wr
         8W85rk3yUIiN5TjU4myh3oBjU61Q4YvPGBxdYoIYQDovEfpFUN5i3wTsiuFD2Kr15ElO
         Wvp0ZgR47fHSLNIfGC6mhFJrM6Cbd6q5NmdSFtqTqv2uCVnDckTFFn0hYJn0LjGaMCi9
         rwKrJ67YApiI3SK6sk5i58pHUIF5oFIk6HS03RhynSH8pDhb/x2CuRgu0SDZIO9uTD/Q
         Dbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713314384; x=1713919184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vnQ65n10C6Pq0ZkKHds3ZlpX5TuDQlyTU6+t/yldsJg=;
        b=XEwbIBDvYO9+BbnEmFW48SeA87KS/LXqnRYM9ooREYkDZcHDhL0aBAyh7Qhi9ohUhP
         v5q/pCKRDAZECp5E6EhAvKmp5AO209sesx/LF5XUjLaU1wBgBsCt4qMNmwC9fDVsGhlf
         YSMCKh9BrMY//PcqQt7wZmuG4eEaIfNCezX2jsxTHjT+1TpDDJIfmp7r/6RU1dAAyOtZ
         0eQPqsh6D/z0NtaM7b7/msOpaAjYeiZsWCh90KtcD5xLL+oWt1MxQBH6EhQCzRPsg6Ks
         F4OIR4lspIS7CbUudsXPz3POhXQKCZ4/UCiqK5ItzFvhI33ZdV2yDReiUsmpEtERgoNv
         srzA==
X-Forwarded-Encrypted: i=1; AJvYcCUwNLGnIRn70rwBf9tP5++S9motwtukWi83bEh9ZoGY1xKqwmDn/lZHE3YzHDyNKNEIztyxenAzlvLujgXefCYq3F4/
X-Gm-Message-State: AOJu0YzsdWb11QQJy3tk+wEGBHvMMpMqGQ0OzXtHONd130jDhFw8+xKv
	cp7OKpqaF/Zfr1/eOdYadc3XYQQL4ahs59K6Cr65CyFl7VlJGhOBWaI1wT/pzFwHX0LipK/Tdsk
	k2A==
X-Google-Smtp-Source: AGHT+IFwI0Wtw33+GURLOQF//ea8KMM5/5ZtkJss0iAPKibWoLIvmvqUy3HJlRJSnH442r8pov1BHfB/nsA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1081:b0:dc7:8e30:e2e3 with SMTP id
 v1-20020a056902108100b00dc78e30e2e3mr4432687ybu.2.1713314384627; Tue, 16 Apr
 2024 17:39:44 -0700 (PDT)
Date: Tue, 16 Apr 2024 17:39:42 -0700
In-Reply-To: <20240405223110.1609888-4-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com> <20240405223110.1609888-4-jacob.jun.pan@linux.intel.com>
Message-ID: <Zh8aTitLwSYYlZW5@google.com>
Subject: Re: [PATCH v2 03/13] x86/irq: Remove bitfields in posted interrupt descriptor
From: Sean Christopherson <seanjc@google.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Jens Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	maz@kernel.org, Robin Murphy <robin.murphy@arm.com>, jim.harris@samsung.com, 
	a.manzanares@samsung.com, Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com, 
	robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"

"KVM" here would be nice too.

On Fri, Apr 05, 2024, Jacob Pan wrote:
> Mixture of bitfields and types is weird and really not intuitive, remove
> bitfields and use typed data exclusively.
> 
> Link: https://lore.kernel.org/all/20240404101735.402feec8@jacob-builder/T/#mf66e34a82a48f4d8e2926b5581eff59a122de53a
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> ---
> v2:
> 	- Replace bitfields, no more mix.
> ---
>  arch/x86/include/asm/posted_intr.h | 10 +---------
>  arch/x86/kvm/vmx/posted_intr.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c             |  2 +-
>  3 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
> index acf237b2882e..c682c41d4e44 100644
> --- a/arch/x86/include/asm/posted_intr.h
> +++ b/arch/x86/include/asm/posted_intr.h
> @@ -15,17 +15,9 @@ struct pi_desc {
>  	};
>  	union {
>  		struct {
> -				/* bit 256 - Outstanding Notification */
> -			u16	on	: 1,
> -				/* bit 257 - Suppress Notification */
> -				sn	: 1,
> -				/* bit 271:258 - Reserved */
> -				rsvd_1	: 14;
> -				/* bit 279:272 - Notification Vector */
> +			u16	notif_ctrl; /* Suppress and outstanding bits */
>  			u8	nv;
> -				/* bit 287:280 - Reserved */
>  			u8	rsvd_2;
> -				/* bit 319:288 - Notification Destination */
>  			u32	ndst;
>  		};
>  		u64 control;
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index af662312fd07..592dbb765675 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		 * handle task migration (@cpu != vcpu->cpu).
>  		 */
>  		new.ndst = dest;
> -		new.sn = 0;
> +		new.notif_ctrl &= ~POSTED_INTR_SN;

At the risk of creating confusing, would it make sense to add double-underscore,
non-atomic versions of the set/clear helpers for ON and SN?

I can't tell if that's a net positive versus open coding clear() and set() here
and below.

>  		/*
>  		 * Restore the notification vector; in the blocking case, the
> @@ -157,7 +157,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>  
> -	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
> +	WARN(pi_desc->notif_ctrl & POSTED_INTR_SN, "PI descriptor SN field set before blocking");

This can use pi_test_sn(), as test_bit() isn't atomic, i.e. doesn't incur a LOCK.

>  
>  	old.control = READ_ONCE(pi_desc->control);
>  	do {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d94bb069bac9..50580bbfba5d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4843,7 +4843,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  	 * or POSTED_INTR_WAKEUP_VECTOR.
>  	 */
>  	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> -	vmx->pi_desc.sn = 1;
> +	vmx->pi_desc.notif_ctrl |= POSTED_INTR_SN;

