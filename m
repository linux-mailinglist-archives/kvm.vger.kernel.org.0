Return-Path: <kvm+bounces-2975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB7D7FF63B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14BC31C211DA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8E15577C;
	Thu, 30 Nov 2023 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9sYNGK0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0211D50
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:36:50 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6cde4342fe9so1224508b3a.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701362210; x=1701967010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6xHzArs6mE8k0gKFW47uVkaYV8e6TD1wE2C7VOPjLb4=;
        b=u9sYNGK0SnoZJi2M4fNto/d3DBHZVx8oGKr+V0DDNmD/sPLR1DHmyO9GnTmhOpt9pf
         mzqK3qLOfftbhQAsBuGkwl+yyh2s6C6QqGjhvZ4d/HlFbH8ByQbqlybrbDslLGK8SNqw
         WIGacyNWus+FgvF2Le50Sxbe84PDmpk9AkKpIRIuK/8W8kfRATWhdqmyNZp4rUmWmnPH
         5O84qWy3Y+o60/+d1qixZQwvQMRaZtpjCSZA3MydjsAc5hOO/wSy7QjGCuTJ04SxyJFu
         +UTls6N6h/ONtyB6I+/TnpyABGeYUS0jXPfWSN2SeQ6wFjf47kaGSl4ibjivXFpgQgm1
         Xf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701362210; x=1701967010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6xHzArs6mE8k0gKFW47uVkaYV8e6TD1wE2C7VOPjLb4=;
        b=g+GlTbAjQ+PBETAzDGKbhM4Bv0mpXZm0lt1HafmbzyCCk683XtXXdK+nN8hVY05mQ6
         OYC50Yp/iEnCp13wwkLUTQ293K2Ey4BKtqO4bRYXUEzmiiuBnMABQaN8b50TPNp7zIZ2
         MBai+MKHAsz/orH2wxJS5EL4dZfhFE8I33o/X3eijh1QxHwsoKzRg148gvTk9zbUm4q6
         L/rvRdojkxBiU19thzDGHX/JUjbITo570BoZxlpNhO27uIveDFvjSFkzVY5EPBwMdsuE
         7fCj0Ih7sVpt7jBdrq8Y0zw0DIcH0dftcDtHz+4gep72GvJoTN0wWBy4yPnhsluSnrri
         7y9g==
X-Gm-Message-State: AOJu0YwVvPnmv4zfiOPZeFWFEZshMt305DDpQvj+Ivjot54ybEnVKMq7
	ly57dZekK8C9QZcd9byuafOeQia7xos=
X-Google-Smtp-Source: AGHT+IFyTJvqgU7+F4LwNMiRyYQZ/KoAM9H6+dTJ2Jev+HII5QR1S3/PLcJ09hSbpz5CFo9DmapM9ZYore8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:c90:b0:6cd:f769:9c09 with SMTP id
 a16-20020a056a000c9000b006cdf7699c09mr114286pfv.0.1701362210472; Thu, 30 Nov
 2023 08:36:50 -0800 (PST)
Date: Thu, 30 Nov 2023 08:36:48 -0800
In-Reply-To: <20231102162128.2353459-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231102162128.2353459-1-paul@xen.org>
Message-ID: <ZWi6IKGFtQGpu6oR@google.com>
Subject: Re: [PATCH v5] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Cooper <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"

+Andrew

On Thu, Nov 02, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Unless explicitly told to do so (by passing 'clocksource=tsc' and
> 'tsc=stable:socket', and then jumping through some hoops concerning
> potential CPU hotplug) Xen will never use TSC as its clocksource.
> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
> in either the primary or secondary pvclock memory areas. This has
> led to bugs in some guest kernels which only become evident if
> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
> such guests, give the VMM a new Xen HVM config flag to tell KVM to
> forcibly clear the bit in the Xen pvclocks.

...

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7025b3751027..a9bdd25826d1 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8374,6 +8374,7 @@ PVHVM guests. Valid flags are::
>    #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
>    #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
>    #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
> +  #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)

Does Xen actually support PVCLOCK_TSC_STABLE_BIT?  I.e. do we need new uAPI to
fix this, or can/should KVM simply _never_ set PVCLOCK_TSC_STABLE_BIT for Xen
clocks?  At a glance, PVCLOCK_TSC_STABLE_BIT looks like it was added as a purely
Linux/KVM-only thing.

