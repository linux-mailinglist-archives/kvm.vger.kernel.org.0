Return-Path: <kvm+bounces-16386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D74298B9261
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86F621F211DC
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9D916C43E;
	Wed,  1 May 2024 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SHIsYObo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE95168B0A
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714606070; cv=none; b=U5+Xvqr+KCniXyNGRh2TxuXhtYmGe2HGeEvHpOm0BuULC+isfJJChcib92gwMOuV8o4EGOpDkA8kaDjD8XWR8oDzlHrZ4k5k3Z7ze/UNIzZy2YxogMu5fnkRYALqHFP4w9T93sQVuBI1ggASyYiGWKN3C/sYiGdjxvfs3qAwAYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714606070; c=relaxed/simple;
	bh=xPKTQAY6H9NH4LCGNLAuTIrJpoVGbJlh2oFRm7BmuLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PUwkKEt9pkdgXY3ypLEGhOieCavYeBhYIgLZW6nDGTqnORaxTGhDB/lNK5ymW4D0bUBovP67wSICIg8M1wkug9PxBzQVrrW2nbgKsbGGs7vqVqgftkeqC8O4TAtRxFsaok7H8C80yBxyb8bo+/apZYueBAvOR0s1G2AjpFx05WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SHIsYObo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b2738ce656so2205012a91.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714606068; x=1715210868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MXAwrtGLrbcI4VZUxU94il3rKUGPiRgHtzGv9dxe9YQ=;
        b=SHIsYObocUNELf4CV9FZxpUx69nv7W7TC52LxT0jKwUMQ2SUYNPeBT7V4/rN4g99GR
         Wbyg+uAgd6x1ZCFStANOfcizhcfSrm7S/RH2S1GPW4q3mb5g2qzYDgfQHHitqP21aExy
         fHjcIVSRWLqOExMDbuU8y6x3TtL3U7+9xoDF9wu8yKXGK/M5ZTjRRVgohvAmCR5NltdC
         4/ST5AeMhLLD1UfC9xvp6dbb3dnBKmtQthhYfzthozYicfkSdtUNI/iKWIn4ZZOjcXSW
         HbLaZdKQ2e3/uJ9t57OgJtWnPXmlFkdBNpikVFZKrfkHTew/ntOnqfWaxQVyThUzXPgD
         gUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714606068; x=1715210868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MXAwrtGLrbcI4VZUxU94il3rKUGPiRgHtzGv9dxe9YQ=;
        b=v/2sHWjTCsSvUCq85+ZVoBa0zpEsx7c3xPscHfKjCLCfq6vbQUcM34m0UTboz4uPzP
         IuxyWuSLQutqD5Rut6jmelL20JyVl/avBtAbacuGF4zbCLL+YkcY34sosIrca3Bicg0+
         beuwh5MoLob7cYxWBZdbgr8opSNxoiIXSNpgdiI0Zfg7BrNOb+peIu1YjgB1Gsfvl20E
         Dx22bdKHAKIVDEvos5eiWrIcgBK41tT8CQNMdlNmgnMMjb88Pfwg1FsP3vz8GC4YQA+w
         6R0YEBtBypeXW/Ds9lb1ILpXQ8MGgBiLgeST3s1JyAGSCH08t+mT+4CuprDf5P0jdXJR
         p74w==
X-Forwarded-Encrypted: i=1; AJvYcCXAgF4lrPy2/5IBO5kA7Vw6Cp9a2QPhOh16GlZVnmSczrsWE+2MB8gW2tzkUl60Sj6b6fscnYB9nTne5nzovcZcFFqc
X-Gm-Message-State: AOJu0YyJTKehuVFbWsrbQFjjiqTgebza01mBrAW/zxqgZp0y7sHqQJhR
	bEtj3KyzwFAnMKys/oTtaP32383LK8wE54H8L4szLrRECeGJnfXtyWxpVjawrH3J284MrvGuGV5
	iww==
X-Google-Smtp-Source: AGHT+IF4EwXU0JmQLvZRvuwORWuJiQp6XzXl9sqqMI0dc8K3/CZscl+xenDCC2dCoWsq9Og/2wncxvjuPJ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d85:b0:2b2:7c77:ec7d with SMTP id
 oj5-20020a17090b4d8500b002b27c77ec7dmr11147pjb.2.1714606068268; Wed, 01 May
 2024 16:27:48 -0700 (PDT)
Date: Wed, 1 May 2024 16:27:46 -0700
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Message-ID: <ZjLP8jLWGOWnNnau@google.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> Sean Christopherson (4):
>   x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>     __state_perm
>   KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
>   KVM: x86: Report XSS as to-be-saved if there are supported features
>   KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
> 
> Yang Weijiang (23):
>   x86/fpu/xstate: Refine CET user xstate bit enabling
>   x86/fpu/xstate: Add CET supervisor mode state support
>   x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
>   x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
>   x86/fpu/xstate: Create guest fpstate with guest specific config
>   x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal
>     fpstate
>   KVM: x86: Rename kvm_{g,s}et_msr()* to menifest emulation operations
>   KVM: x86: Refine xsave-managed guest register/MSR reset handling
>   KVM: x86: Add kvm_msr_{read,write}() helpers
>   KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
>   KVM: x86: Initialize kvm_caps.supported_xss
>   KVM: x86: Add fault checks for guest CR4.CET setting
>   KVM: x86: Report KVM supported CET MSRs as to-be-saved
>   KVM: VMX: Introduce CET VMCS fields and control bits
>   KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT
>     enabled"
>   KVM: VMX: Emulate read and write to CET MSRs
>   KVM: x86: Save and reload SSP to/from SMRAM
>   KVM: VMX: Set up interception for CET MSRs
>   KVM: VMX: Set host constant supervisor states to VMCS fields
>   KVM: x86: Enable CET virtualization for VMX and advertise to userspace
>   KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery
>     to L1
>   KVM: nVMX: Enable CET support for nested guest
>   KVM: x86: Don't emulate instructions guarded by CET

A decent number of comments, but almost all of them are quite minor.  The big
open is how to handle save/restore of SSP from userspace.

Instead of spinning a full v10, maybe send an RFC for KVM_{G,S}ET_ONE_REG idea?
That will make it easier to review, and if you delay v11 a bit, I should be able
to get various series applied that have minor conflicts/dependencies, e.g. the
MSR access and the kvm_host series.

