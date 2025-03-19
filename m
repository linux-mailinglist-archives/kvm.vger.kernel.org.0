Return-Path: <kvm+bounces-41525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F390BA69C49
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3272E189D5CA
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF4922068D;
	Wed, 19 Mar 2025 22:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xr4t/+Oe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5791E0DF5
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 22:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742424599; cv=none; b=CuLleVlLidPDKTdCBxpY8R8t3B6ZRBlqkFxMeUvNE+TzR9DNoZ5BQXzLHKGrdmIflmKxP4tN5NjEzELzWDvcFbzQUhYH/Oaz7sbifqfFK8B2U+Se82ssCx1bCz8SvePWSWDQL6HPv518UgRuomfhBFl+QtdUq3/XWbDCYy5D20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742424599; c=relaxed/simple;
	bh=lrSy91elUFWeNXInEMPTCJnyaZA6B+FgQTIyrb7pjko=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ve0ALregYql1aCHqrXGtAH/1udTzOFehUJv00T+DJo3pv/NaYPeowNzCLTxr9fgpCgNNdH9TG8D5/5LdIp/HPxFxonyRa0RjgD9pgeoV4s00gaOGry6rWlgLsUHy9KbOyaYQCq2jLuloEJvRGyKqgSAoPWDS4j7z1vYpt8l+5fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xr4t/+Oe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742424596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcULRLq0h/6Rw82rbFxYL3W3UEU4Ef8C8Kke2Ri6KhA=;
	b=Xr4t/+OedCnRpyaSW7efy83SS4oFT13uRbL9C6jPMRho3/acW2OzwrxkMcDH3roTUPeYRG
	dsmSQpmD7KNKMaw9KPL/WKEOnCKArUbYIrOjSVB2AqgprW6pR6Eg/m+oCsUz/fYgsDl6xu
	Pvfv/itnoQqVz/0FZVfZqs3HPpFMU/o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-zL6bDqW9MnSzTNVKDYY9dQ-1; Wed, 19 Mar 2025 18:49:55 -0400
X-MC-Unique: zL6bDqW9MnSzTNVKDYY9dQ-1
X-Mimecast-MFC-AGG-ID: zL6bDqW9MnSzTNVKDYY9dQ_1742424594
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6eada773c0eso4611776d6.3
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 15:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742424594; x=1743029394;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pcULRLq0h/6Rw82rbFxYL3W3UEU4Ef8C8Kke2Ri6KhA=;
        b=nqH7tmPk81ee6FG42YrzPsNrmLV5dHloUxIRb5z9hSG8d8pwFuExmBxLqscyCdJ4HS
         3GoRgn/TRcYPX+X5wU70RsVLVRjhT8tvphwjg2ogyS9FgCuMm8wKLxl3aKvi2hDQ+Hzg
         mMaTvAPWxFO2RFLlQ3P1XqLJOE+624zu/Rnv2HVCw6yOGniobS6lKA1lvjr3dfXVcaBn
         VC2jfcP7eMAEgtlD0H+rGAyfws29eQ+NCZazOHpbMuhg2ImItPOueSphXFeRI+WkjC6o
         vxdMxBBT2hgtC9j9+cgDMdJ9EdlWnWpmXBXqf3VGxusXFpCI3dslv8J7o0ZUv/6OpL5T
         7sxQ==
X-Gm-Message-State: AOJu0YwfY1cHRGYdaITQxNuNm4f0vsNHewDIYy1RX0H0CZsM7mM3K0/0
	1gvtGHkY8Q/VbV/foXXWFGzgnmpYS0j8gLW7yurRa1N6tpTfmrhcfggUbjAgXrWmRZEaq6s0YdZ
	+Yd2ze8X1lPbeap9S8t/MpIc5NpaMXYZVAG5lOdm+L3SLegHcLg==
X-Gm-Gg: ASbGncup3lZ6oWUJvNJd3H7ngRq7CGjAAx9GdA3Do9JfL5KMudPBm10iFE1VvRzpnfn
	/r6Gbsal5IbOvUODttKSXgYPDKSeXCxiWlRxjqmG4aXPBbln08e0bm5A0snCHRAt4QeFf0qwA0g
	VXBibYlAhD6VJsEvp5SvsuJVJaoZ5teTeYDxahilfaDaO0IYIAivSVPAeRCy9zC0pw+6uB19evg
	DK5cLaISlMycgLpb2zYy3H1HpkOUaiDbaGRKFeVp2IHrLSPNwhRc9/uWRq3/hv3+CkWeHuW/go1
	9THWRO/letcjfag=
X-Received: by 2002:a05:6214:2404:b0:6ea:d69c:a247 with SMTP id 6a1803df08f44-6eb2926b1a5mr89245136d6.4.1742424594435;
        Wed, 19 Mar 2025 15:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYwumfJhgcIfUQ2Qhve0p1Wq69ZGlgHwoTjJBdbbbfJKxqvi4R/lzcTuY2uFhZaiTMWx/OXA==
X-Received: by 2002:a05:6214:2404:b0:6ea:d69c:a247 with SMTP id 6a1803df08f44-6eb2926b1a5mr89244856d6.4.1742424594103;
        Wed, 19 Mar 2025 15:49:54 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eade334639sm85327636d6.90.2025.03.19.15.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 15:49:53 -0700 (PDT)
Message-ID: <9687cbc0b80932fce13fa42a0f3982bd834af926.camel@redhat.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Yan Zhao
	 <yan.y.zhao@intel.com>, James Houghton <jthoughton@google.com>
Date: Wed, 19 Mar 2025 18:49:52 -0400
In-Reply-To: <Z9ruIETbibTgPvue@google.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
	 <Z9ruIETbibTgPvue@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-19 at 09:17 -0700, Sean Christopherson wrote:
> +James and Yan
> 
> On Tue, Mar 18, 2025, Maxim Levitsky wrote:
> > Hi!
> > 
> > I recently came up with an interesting failure in the CI pipeline.
> > 
> > 
> > [  592.704446] WARNING: possible circular locking dependency detected 
> > [  592.710625] 6.12.0-36.el10.x86_64+debug #1 Not tainted 
> > [  592.715764] ------------------------------------------------------ 
> > [  592.721946] swapper/19/0 is trying to acquire lock: 
> > [  592.726823] ff110001b0e64ec0 (&p->pi_lock)\{-.-.}-\{2:2}, at: try_to_wake_up+0xa7/0x15c0 
> > [  592.734761]  
> > [  592.734761] but task is already holding lock: 
> > [  592.740596] ff1100079ec0c058 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}, at: pi_wakeup_handler+0x60/0x130 [kvm_intel] 
> > [  592.752185]  
> > [  592.752185] which lock already depends on the new lock. 
> 
> ...
> 
> > As far as I see, there is no race, but lockdep doesn't understand this.
> 
> Yep :-(
> 
> This splat fires every time (literally) I run through my battery of tests on
> systems with IPI virtualization, it's basically an old friend at this point.
> 
> > It thinks that:
> > 
> > 1. pi_enable_wakeup_handler is called from schedule() which holds rq->lock, and it itself takes wakeup_vcpus_on_cpu_lock lock
> > 
> > 2. pi_wakeup_handler takes wakeup_vcpus_on_cpu_lock and then calls try_to_wake_up which can eventually take rq->lock
> > (at the start of the function there is a list of cases when it takes it)
> > 
> > I don't know lockdep well yet, but maybe a lockdep annotation will help, 
> > if we can tell it that there are multiple 'wakeup_vcpus_on_cpu_lock' locks.
> 
> Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> object) to making a functional and confusing code change to fudge around a lockdep
> false positive.
> 
> James has also looked at the issue, and wasn't able to find a way to cleanly tell
> lockdep about the situation.
> 
> Looking at this (yet) again, what if we temporarily tell lockdep that
> wakeup_vcpus_on_cpu_lock isn't held when calling kvm_vcpu_wake_up()?  Gross, but
> more surgical than disabling lockdep entirely on the lock.  This appears to squash
> the warning without any unwanted side effects.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..5984ad6f6f21 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -224,9 +224,17 @@ void pi_wakeup_handler(void)
>  
>         raw_spin_lock(spinlock);
>         list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
> -
> +               /*
> +                * Temporarily lie to lockdep to avoid false positives due to
> +                * lockdep not understanding that deadlock is impossible.  This
> +                * is called only in IRQ context, and the problematic locks
> +                * taken in the kvm_vcpu_wake_up() call chain are only acquired
> +                * with IRQs disabled.
> +                */
> +               spin_release(&spinlock->dep_map, _RET_IP_);
>                 if (pi_test_on(&vmx->pi_desc))
>                         kvm_vcpu_wake_up(&vmx->vcpu);
> +               spin_acquire(&spinlock->dep_map, 0, 0, _RET_IP_);
>         }
>         raw_spin_unlock(spinlock);
>  }
> 
> [*] https://lore.kernel.org/all/20230313111022.13793-1-yan.y.zhao@intel.com
> 

This is a good idea.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



