Return-Path: <kvm+bounces-24087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B8D9511C6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BFAD1F24E36
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB0B18B14;
	Wed, 14 Aug 2024 01:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LrRaYfO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D91CD06
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723600681; cv=none; b=kYwZLzwveqh1kkWG6QMoILveuHBVsgZdErcyDDfse5dQD4pCvKk4SL+gqhyzIm0QJcR0duM5l12uxQilHs2VJI2nL9ngd7l1og1sqXEkhNFAyRDOe1+Qm4I+dKJq6675cLf8rYkYWKApJG6rzsKXehHMFgZdWTMrQ0aNGWg26XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723600681; c=relaxed/simple;
	bh=8d6PGwMHzA81/psTz46KEeZYkJAFBDXykPr3u6Uz85M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SSjhoVf7kWJ2uXkRo0piV08TRG6NA/Wj4n3shl5T6ogCoGFOD0FA7Tp+cGhwH2soAhkwBrtIGbY/xLyhjbudXxLVQIUC8Q57IHxmVP2lbx09mJ08HSFEEIwx66eFg/rfGPWXrUXWBrr0UYUHosXatYIbSx80zyboFTY5kwfepzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LrRaYfO3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66b3b4415c7so132431227b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723600678; x=1724205478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vVR4Zs76dJzNPyP14EOD69bGamaJOE55Zhb/9oRDLUQ=;
        b=LrRaYfO3/0laRqEjl900l88XVQBebftj3SBTVQDv45Db2C91vuIlveAhODmM+8guKK
         inLGNq3SOrPMRopJn5RzOaCTguPlFaCK3J+aSiEzaWroBmqkJ+quhXvjezbXWRFAGc5F
         DO/V+xGFLHVcMiPd4KsmQX0+pGSyvaqU+t+hX4a/pqUMJmEz+XgB9R3/101TorTreZDI
         J2a9PirOprWbV3vWFcB/HyAr9egfOrtud7Cw+I9UKaKiMKP4lXKoPBv0riah18odN19P
         9Mh9FMJyBs0uvYss1npNgHwsO0kZbIrFGF0tBWwkEloXx5H2q6/r2/dNgegwSWE6TnpM
         zkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723600678; x=1724205478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVR4Zs76dJzNPyP14EOD69bGamaJOE55Zhb/9oRDLUQ=;
        b=LDuFaK6CMNEpMSdQLYPS5ViNcpxqR5RkR2E//eha/7rGKPmY6iUaDDZ1FPudThXT4N
         08aO/PK446+J01Nm5kRVOkLiHpEHDg8CrtJxVJjEf4hW0qmbF9g6awsLJ4sa4oDQ8l8q
         m3t50aWBMlQbU72FjWx0PHNyzD/kedr1ZdldFz4GhBfBREH4K5HOO0EkLoIK2DEQ1fFr
         OG4JTgyvduxO9/bWATPIiAtV5JjMJ6W7r9NRMSGj7qtq9z7KW1HGmTkE9ufdll/AKsjG
         PiuY+FCBMejQtLrUCl0M8FZnLUWyuGKPPciZ54MgCKhnLE5x/ZS/gU9eFnv3NeW4QolL
         eY0Q==
X-Gm-Message-State: AOJu0Yz+FBnTxryZ/ybWMlQcxdTZ6EuSbljilr4hBN0XuN1qrRFK5/lm
	cmWfDr8spwmX1vOpDHdDUqb8lwRlMaIZ9XqKn2UwT0xkemeDOaSzjviMEfILm4tuygw3kBII1hi
	BOw==
X-Google-Smtp-Source: AGHT+IFSegjyE66t4s58gnf9XNM5UY1397H7m/p5j+j7FRYqPMhvRwirhseK7sojYieVrgGq1fO67l5GO7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:88c6:0:b0:62a:564d:aed1 with SMTP id
 00721157ae682-6ac9aa3f26dmr204777b3.8.1723600678485; Tue, 13 Aug 2024
 18:57:58 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:57:57 -0700
In-Reply-To: <20240522001817.619072-9-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-9-dwmw2@infradead.org>
Message-ID: <ZrwPJWdRThqSvY0X@google.com>
Subject: Re: [RFC PATCH v3 08/21] KVM: x86: Avoid NTP frequency skew for KVM
 clock on 32-bit host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
>  static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  {
> @@ -9984,9 +9977,10 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  
>  	if (pi_inject_timer == -1)
>  		pi_inject_timer = housekeeping_enabled(HK_TYPE_TIMER);
> -#ifdef CONFIG_X86_64
> +
>  	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);

The unregister path got missed.

#ifdef CONFIG_X86_64
	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);

>  
> +#ifdef CONFIG_X86_64
>  	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
>  		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
>  #endif
> -- 
> 2.44.0
> 

