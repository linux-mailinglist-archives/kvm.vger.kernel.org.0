Return-Path: <kvm+bounces-39211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 914BCA45248
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E78F7165B59
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F0E19F424;
	Wed, 26 Feb 2025 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kLSkW6pu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006C198A06
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740533862; cv=none; b=keo83G9OW4KLgPxXfKKyOdQCIDyjq5QpLC2SCeOQKLixLh9yKqozj2OwLooQ9v3kOUrUdmASITHLmgKzigC9fHoCT3/HR0jzkeUUdi3LejlXdiZjVOmj6LtqgaLGqo1JotgXkosU8Z3QMVg7dzH65HGc2YiGKePfMhURiwOpkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740533862; c=relaxed/simple;
	bh=SZXVHGpnAZAjUR/CtLa8PUD2AYYL1dTCoQzVwHq4l6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pT4rKe4nzo3WwLkmRZf3T+ypgJChqdGyjTMBMJAOlA/loxni7H4OXQmiLNneH32m3yja8hw/d0bOma7u95eiEw8kNnV5VXJEYfYkuK+PJfxcWRx2p8s7EIdqh6NI9JYaEJW86/ThB06pIoV98GMfpy05Ft3PIf9gNnlj/eRWx18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kLSkW6pu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so13402841a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740533858; x=1741138658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULZtC1FDd6NUJ3rI9g4pbuHdjytTUlPfqVdSRlPBgi0=;
        b=kLSkW6puJ0deJ0Y6F7Dm4/ygcE9253BQi0wbtG/OUUSPQ2ha+SFovO91g2HCke1GZ/
         PdrU6bC6V7si0Sq4nNLOD9Vwv1pGaJVzSp1lvVtv86JubadJups6h0Z7oOCR8+PTPQ8H
         yvE9hZrNi822PwoIyPelafcLd5m/CQJBebP19/krmfMJfp2rEHPK5r2y+mPYaT2vU9fi
         ngJ2pcpw9Ejglz1ajr8xHCyn7hB8r9i8z7r/NEaboHJQcULeaDo/PnKbMU3tspsQq1Is
         blf/FpAijK1uQ3i9F26dVb3Je15Uh042jlf/ko/z7DRWVrwl4/4LB6Kjs3iPnubAcemm
         jCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740533858; x=1741138658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ULZtC1FDd6NUJ3rI9g4pbuHdjytTUlPfqVdSRlPBgi0=;
        b=KSHa41wJOsYFEVHd5JfznCQJ4t2dNEKmnNGzJdXkXdm4dJrN5EeZCqMsZOLWwuoFvv
         1Nu39PsAO7Zj5tUXuTZyDYckI9vqCbKQcYxDTawVSK41s/p5FXvHE3m5ZugFpsSONdRd
         W8jTBP9XvlNqEVXRA9XtNNrmcE+qO0uztWyG3Q2qhUCNygEU9bLFwNL+7mxMZarImtbD
         ADC6IadpHGbOZEWCQLexNzDfd+COc4leuiWqHTCPFi+Le4OI8wvXnOaDh+uDCy7wYeZi
         huHfqWrORrDERk7tqasv8boJY5JA5IllxsBMjKBN/8CNp9T9X9mg643qiRMXLrHTZweN
         x9Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXRC9ZpDS/sMLiAS4wz+l2K9odr+ldShOCDiYfWXlSgGW+ugsyylZOD0WxWbsKlEt9OnM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUD0WuNT1clfNOR0Xvl1chDNKYvXCzRvxFljbFY33nnoZ9y2RK
	os0pczHNKxXgQXQ/XIuVB0DhfGAogIZIN/VajEg5LEKAdlDgxRGEBs4V2dQUY6uQGUFOgIC1BsI
	EwA==
X-Google-Smtp-Source: AGHT+IHA8CF5QxCpD/x/wbknob1L7guzavFzGaqCBJ/GtwIioN65VvOsc9KVNLvbhXTXOB4aN7b1T5gcI8o=
X-Received: from pjbee8.prod.google.com ([2002:a17:90a:fc48:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d48:b0:2ee:f550:3848
 with SMTP id 98e67ed59e1d1-2fe7e2e1088mr2350421a91.5.1740533858514; Tue, 25
 Feb 2025 17:37:38 -0800 (PST)
Date: Tue, 25 Feb 2025 17:37:37 -0800
In-Reply-To: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
Message-ID: <Z75wYblH3_IFsoUW@google.com>
Subject: Re: [PATCH v7 0/3] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: thomas.lendacky@amd.com, pbonzini@redhat.com, tglx@linutronix.de, 
	kevinloughlin@google.com, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 28, 2025, Zheyun Shen wrote:
> Previous versions pointed out the problem of wbinvd_on_all_cpus() in SEV
> and tried to maintain a cpumask to solve it. This version includes
> further code cleanup.
> 
> Although dirty_mask is not maintained perfectly and may lead to wbinvd on 
> physical CPUs that are not running a SEV guest, it's still better than 
> wbinvd_on_all_cpus(). And vcpu migration is designed to be solved in 
> future work.

I have a variety of comments, but no need to send a new version.  I'm going to
post a combined version with the WBNOINVD series, hopefully tomorrow.

The only thing that needs your attention is the pre_sev_run() => sev_vcpu_load()
change between v3 and v4.

> ---
> v6 -> v7:
> - Fixed the writing oversight in sev_vcpu_load().
> 
> v5 -> v6:
> - Replaced sev_get_wbinvd_dirty_mask() with the helper function 
> to_kvm_sev_info().
> 
> v4 -> v5:
> - rebase to tip @ 15e2f65f2ecf .
> - Added a commit to remove unnecessary calls to wbinvd().
> - Changed some comments.
> 
> v3 -> v4:
> - Added a wbinvd helper and export it to SEV.
> - Changed the struct cpumask in kvm_sev_info into cpumask*, which should
> be dynamically allocated and freed.
> - Changed the time of recording the CPUs from pre_sev_run() to vcpu_load().
> - Removed code of clearing the mask.
> 
> v2 -> v3:
> - Replaced get_cpu() with parameter cpu in pre_sev_run().
> 
> v1 -> v2:
> - Added sev_do_wbinvd() to wrap two operations.
> - Used cpumask_test_and_clear_cpu() to avoid concurrent problems.
> ---
> 
> Zheyun Shen (3):
>   KVM: x86: Add a wbinvd helper
>   KVM: SVM: Remove wbinvd in sev_vm_destroy()
>   KVM: SVM: Flush cache only on CPUs running SEV guest
> 
>  arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  5 ++++-
>  arch/x86/kvm/x86.c     |  9 +++++++--
>  arch/x86/kvm/x86.h     |  1 +
>  5 files changed, 41 insertions(+), 12 deletions(-)
> 
> -- 
> 2.34.1
> 

