Return-Path: <kvm+bounces-25685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3600C968A9B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 17:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E117E1F2250B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 15:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AA519E960;
	Mon,  2 Sep 2024 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PR0ECwNO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2F1CB505
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725289527; cv=none; b=lgfz7mad+FhB8/ZCIgNAWWBOmInJUrhlpuWDjaIOrEPumkMengk1DT4mVXYFrHiW+pFubDqJcjlyhgusUyTLZZc1YF33s8x21k3jx3XEaljUg/L8+2tXkK3WRkhHwTGvYl6twteboKEnge+pgBR5+K3V5iDQIJPLOMCOwR/INTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725289527; c=relaxed/simple;
	bh=k0/DqNn6r0hvbqjOGsbxJs9bNKNoTLtYp0jpsW3kue0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Shir/bIlgjVWLXtDU/uAW24fbqGCQ15QEaIWI1WIOYtjz/VPdMVJfigSSh8Fydha/l8+ZwDlfq0vMsuir0O+RjBada0YktswDtHmLUrrTgWE8BKddyqJ6YGbvBeovOSMBsSBzwNAany+F9/JM2vwMMKIbtxixuT0ZfizLgC2lZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PR0ECwNO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725289524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ziH5RycTQIYEsjONg+GaJvTnZD1q/SgNIqzqcE498lo=;
	b=PR0ECwNOpesYja2qQn+UlwfxAjGONnF+RCuLIBPWtGSrOjF0z/0CfCF3LLQIZUzIjlfAzH
	lQCn+Zy1cp7oL0Xx/JFFMy/umbwi9C7kwk6piMww9p+g064awyNLrQYS53hLl6himwWsfB
	WmhMh8/HUyKMmKsfDaGseht7LqWToMA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-3vno31W_MT61VMRuJSHL2g-1; Mon, 02 Sep 2024 11:05:23 -0400
X-MC-Unique: 3vno31W_MT61VMRuJSHL2g-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2d8817d8e03so3106225a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 08:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725289522; x=1725894322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ziH5RycTQIYEsjONg+GaJvTnZD1q/SgNIqzqcE498lo=;
        b=bQjrMWnoJawssmAK6WYwaLzyWMjMofLdOGHaPCxmeud7lmVbUy9l7+SKb4+SO79K0/
         g1OZQTYutDyzbyGcJJe7HEeKxXLKSithYOoIWGqqIYRCh7DKMu33ugVErtvWztN/gNdp
         Mk8E52HaIX9a7gm0pMTWWSD6wN4TTiiCOq0PUTOcC+nVWNL23eRfrbEMb4X9npi1KfA3
         gfRSfsU7lFHsXOe3MKI9uZg5HL6hQiZkunFBjRacL53XW7k9yoCoPFYKQl0rS7E/M4wx
         hKAW3lTPNFvXiWGeYCl9WiSZmhgYRi3djEYWMWD4m0sb85p91q93Ca+YBNKzAclXFtAX
         VpNw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ//7cmhmLTxedwCXY9MOQsdvmrwUbRCpnpUbgHPAJdCavR7t/Kz1HsUQzuUV7c0Kiux0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw7Ut+u7cJxq2pGaTqiX+urf65S/DLLOkLFLZYEpidqFqwuBWw
	GgxGLbUCa0zIbTWlfPgXbabnOSm7yeodIr9U5ASpravtYRmxsfB/RRl3332vb7Fz0y75PDAxfdc
	tl3fqMHqUlnyIZOSM1wYy2t4QXrPyto+1+MnAg6QK84lMGuiU0On01VRrr9NKSdwYyUXc9+eB8j
	+36Sa/gAGGAvCbUeGerziUNSqb
X-Received: by 2002:a17:90a:8d07:b0:2d8:27c1:1d4a with SMTP id 98e67ed59e1d1-2d88d6dbadbmr8803279a91.24.1725289522154;
        Mon, 02 Sep 2024 08:05:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0yHTmMgIu13OPCtaJjdH70dJqkGRaPQI7+UUIjnFKNKjMRWxvi7+frXfjTnChdUxzt4MQr6gq2Zp/Dq3TmBk=
X-Received: by 2002:a17:90a:8d07:b0:2d8:27c1:1d4a with SMTP id
 98e67ed59e1d1-2d88d6dbadbmr8803237a91.24.1725289521719; Mon, 02 Sep 2024
 08:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
In-Reply-To: <20240827203804.4989-1-Ashish.Kalra@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 17:05:08 +0200
Message-ID: <CABgObfZMQ1qcQf-XLZaPGFzmbtoe3gGuMvXF-N0qo_5Z9jf+vg@mail.gmail.com>
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, dave.hansen@linux.intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kexec@lists.infradead.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 10:40=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com=
> wrote:
> +void snp_decommision_all(void)

Should be spelled snp_decommission_all (with two "s").

> +static DEFINE_SPINLOCK(snp_decommision_lock);

Same here.

>  /*
>   * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switc=
hed via
>   * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
> @@ -594,9 +597,97 @@ static inline void kvm_cpu_svm_disable(void)
>
>  static void svm_emergency_disable(void)
>  {
> +       static atomic_t waiting_for_cpus_synchronized;
> +       static bool synchronize_cpus_initiated;
> +       static bool snp_decommision_handled;

Same here, and below throughout the function (also SNP_DECOMMISSION).

Please create a new function sev_emergency_disable(), with a stub in
svm.h if CONFIG_KVM_AMD_

> @@ -749,6 +749,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vc=
pu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +void snp_decommision_all(void);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -779,7 +780,7 @@ static inline int sev_private_max_mapping_level(struc=
t kvm *kvm, kvm_pfn_t pfn)
>  {
>         return 0;
>  }
> -
> +static void snp_decommision_all(void);

This should be inline (and after the change above it should be
sev_emergency_disable(), not snp_decommission_all(), that is exported
from sev.c).

Thanks,

Paolo


