Return-Path: <kvm+bounces-47390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6CFAC1284
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BECB3A4108B
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9390529DB7E;
	Thu, 22 May 2025 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VLBksaEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16229299ABD
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747935675; cv=none; b=jQVke1RkYBAoAzfAe3zJ6JjFMsfBQk/zMHxQaAykvNGvPt4xzaZ8R7hItj4cALxtA7yFaIHNDzQjMg+yZXNnLev4ZEgITgWWg2JNQOA67WxBqCzn3tZ3SR6oiVM1OttEHChaLgkhe4vyT/gOxrmAt/hr0fJ3FQRmZrPmUWxeZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747935675; c=relaxed/simple;
	bh=lGBxI9OCtZJuGAq0zcPwd74EgaIQAmyhF8n7m1xT4V8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OEL9XtjRaZy5A47LdgGo+rcfgoK32DOPNypnli+RBfEEXsTrGImZ+hUKDg9WUguw/3yhrpOKuBv1CsWYd2UXc+M0s79xN2jFw0uK0SvdUy5lYtKeums0u4d/P74hrysFbD2U7+BPaOUKDbQJSI0UWc4xH5nNRwrzCfISXrmu/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VLBksaEP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231e6e1d988so87581285ad.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 10:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747935670; x=1748540470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ag38dhq4dXm3ibKh0H63wetUkYvwY754FjJDUuyvy8Q=;
        b=VLBksaEPFPWUMDjP440wnNuiAT2JeUKgmWO2BfVPekPUE6NqAZK6KVmzi44n3ksQnz
         MVRiMgWENUZu5OrZKREok6T6LuGUrMABqU97ZCX8pTNCr+xGFCgG+WFpeK0L1nogFn3i
         wg/M/gS9AU6wMbL1yLn+bCoUxlyD2G2g35YSKjrZ1E2ICSeUEByduTvkr5PF/gUoaL97
         opZyxuRkcw0FYCj3DEy4ze2G0wLA0cPj7W0+GqXQMv/wRlTR+RbUJ5ehlL88val4Bb70
         Dj/jOhpoHAdRWW+ELA9AAd8qER4tcYi9ZlFDYaSBo3IzWM621DlFQJHenXHyWbIvWpj6
         AqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747935670; x=1748540470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ag38dhq4dXm3ibKh0H63wetUkYvwY754FjJDUuyvy8Q=;
        b=kbKg3K45+r348KpYMn2Vm7gGaSp1Pxu3sTf0tyfzcZ8DBPG2TNEPr2zm8Ewqisk5pW
         SgC8Z9rCHd+eXUf5D0hxIKaW7ztehaYWBvJ+0Izrlx1mynnuA1R5NOGYjDQLZ6O0Uj9I
         c2jNQhtI8G2vOUwl0lL3+iMOpfr4+9Mvq3jQfC5dEI4ZQ+SttFF3AVTIcipMWWBtg2dx
         oOInOLzBpyi14bChFQQuFn153xBggP/+U+HreV2/xfI5mZKm8308fkXMqt2N+OOSdX3u
         9JBkuHeSASAUg8IxkjsQVCFdDbgXLryAhyS3qcqDDeoM3CNBkZkBf17/FohrBlpCx1OJ
         ooRw==
X-Gm-Message-State: AOJu0YzQhVhEFIXGu3VTd9YMgrE63MtwIOKk3lgZe2Kt0y98GeIIdJmD
	ZQV4X1RavsUegcAzimM0cghP4sO3z9Nev2YoHno6Jbbek8wodihzz+KWXTCPWeBFf3D95wuAXFV
	tgJj2yg==
X-Google-Smtp-Source: AGHT+IEKYo9T1skkKALkOQM3lragb0fX9j4mssklDqAQEruq37vmejRfGQO+eTiLY330Ywwe86rho3P8czE=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:aac:e580])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:483:b0:22e:634b:14cd
 with SMTP id d9443c01a7336-231de3ae56emr253780405ad.39.1747935670297; Thu, 22
 May 2025 10:41:10 -0700 (PDT)
Date: Thu, 22 May 2025 10:41:08 -0700
In-Reply-To: <20250522005555.55705-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-2-mlevitsk@redhat.com>
Message-ID: <aC9htBtwpBGaPoeu@google.com>
Subject: Re: [PATCH v5 1/5] KVM: x86: Convert vcpu_run()'s immediate exit
 param into a generic bitmap
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Maxim Levitsky wrote:
> ---
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..7dbfad28debc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1020,8 +1020,9 @@ static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
>  				DEBUGCTLMSR_FREEZE_IN_SMM)
>  
> -fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  {
> +	bool force_immediate_exit = run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT;

Talking to myself, but I think it makes sense to drop the local force_immediate_exit
entirely, specifically so that the WARN_ON_ONCE() can just yell on run_flags being
non-zero.  All immediate usage of run_flags is mutually exclusive with TDX.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3cfe89aad68e..9a758d8b38ea 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1018,20 +1018,20 @@ static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
                                DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
                                DEBUGCTLMSR_FREEZE_IN_SMM)
 
-fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 {
        struct vcpu_tdx *tdx = to_tdx(vcpu);
        struct vcpu_vt *vt = to_vt(vcpu);
 
        /*
-        * force_immediate_exit requires vCPU entering for events injection with
-        * an immediately exit followed. But The TDX module doesn't guarantee
-        * entry, it's already possible for KVM to _think_ it completely entry
-        * to the guest without actually having done so.
-        * Since KVM never needs to force an immediate exit for TDX, and can't
-        * do direct injection, just warn on force_immediate_exit.
+        * WARN if KVM wants to force an immediate exit, as the TDX module does
+        * not guarantee entry into the guest, i.e. it's possible for KVM to
+        * _think_ it completed entry to the guest and forced an immediate exit
+        * without actually having done so.  Luckily, KVM never needs to force
+        * an immediate exit for TDX (KVM can't do direct event injection, so
+        * just WARN and continue on.
         */
-       WARN_ON_ONCE(force_immediate_exit);
+       WARN_ON_ONCE(run_flags);
 
        /*
         * Wait until retry of SEPT-zap-related SEAMCALL completes before
@@ -1041,7 +1041,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
        if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
                return EXIT_FASTPATH_EXIT_HANDLED;
 
-       trace_kvm_entry(vcpu, force_immediate_exit);
+       trace_kvm_entry(vcpu, run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT);
 
        if (pi_test_on(&vt->pi_desc)) {
                apic->send_IPI_self(POSTED_INTR_VECTOR);

