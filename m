Return-Path: <kvm+bounces-43117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7587DA84FE6
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D2DC1B86B0A
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA9720FAA8;
	Thu, 10 Apr 2025 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R6tV4Nsz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A192172767
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325818; cv=none; b=dolR00fVML0UYqKtEueqBbfuXgP1r2W9QjNTxn4ssN3zfTWyZPU3SClJN4OiWjOlUq5r+gJrQV2o8y4NDBKYbWICeHGTMymM7qqH4fVR6/h1ayRrG1+NPTUbxlvz19Uf3Agot8DX1XCE4082Ynid/a++eA+OQCEaVYSSoQsUTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325818; c=relaxed/simple;
	bh=ioO7YnFQp/5JpmP9BSFi1G6qczczKVGe499+v+64Fmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nm/4uIpAMfpWKDTVcFAceptJpdt6JeO0lQUC0dzWxh5QYE2yfBWjaiD+I8w4dTHWyp3K82+TiG5BM76jnDAbRfiLlqIW3pc4LoWGdGUbXHQEK9CYC15mi/Z5c36cdNEt/9YVGy+xDGGTUcxKc1J02qeqk5LuU765JkK9iNTIs5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R6tV4Nsz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af8d8e0689eso1494452a12.2
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744325815; x=1744930615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aSIC6qytDmqhN54u3QCj5+Mk33tFk68mhLUykdlDCdY=;
        b=R6tV4Nsz1qBgtfcD5P62Eo1Z5IWkpta58Bs4TyrtuZxsOvXAaPebSZ3M8AflNEZfsk
         2aFQh2+zHh7VgD6WtpsnqhQqAvp/csOUj4FHhKSQylhSvOrIdU8ExXWgaDGrEi3QtL9I
         gGkrejhaUgKRRqEiLbaT5/RIw3ClLlF3zYJkb2wIrKjHOweG6VViqx3Q6r08vc04uEsk
         GUzZ9iis/+30lj0+rfOeCoc60159YTQbJrF4zX6Dcm06ubas+BsXJmBN7Y4FKLylPK/R
         3zMzSWlluafuhDuieaoZKVrgYMZrQOjcQbELxwhkwXZIE1CPIK+gj0FaT/0d7TzFe+xT
         yaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744325815; x=1744930615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSIC6qytDmqhN54u3QCj5+Mk33tFk68mhLUykdlDCdY=;
        b=mg7XDORcZxSYh5vcZiucGOxLdjbl+X0fW6fsupBoc/ziAcmdV0QLwVd5yNtCV186ae
         GW6CiKEydtEJfAapx0VwM/YCL2yq1d+BhV6Qay1YOQh199JYC9OtswRuewiS710KfbbY
         dKUnusbNpq9OSMuAMG7rBue1P+RoaKhjOK3AvraKTK7TRAzsmSL+lU2X4y/VIXZrDJHZ
         09er4kO2t3Rt1Eq8VhXmxTbp+1L1OVQAi9KsR1/pd9q+yMZz5Q6+2g/fEGUGqFXh4cti
         hrU7qxFM1EFwGUAj2syhLwfJ38fZyfyec6mz6ZuzAbq3o1gNktUYLBGuv9MW/yLu7q9s
         LIMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHusAIGuhltK6+MdfQGsUSeYtyor4v6BV52UhxS00KJuof7ndrZD70Xi4DJJfivH2rmn0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa6TAkdAif3olSNTSFDVvl/aV/SpX0Ykzi4Ug7Dz7t4hgI5Bw0
	G6Ts56MnHNV/VimvGZ4j1YsVXqo6SuXuJG5683xWeoDVSw5nbWjU8qu5qDAi/Ulve7a3gBmVBpH
	THw==
X-Google-Smtp-Source: AGHT+IEojre5lz+OxmngvdVqLN1KtTwsWACVjyD16MFf07sg4OiDszm756ulpW/Ml+uxcG0gRpJ7nQnFSQw=
X-Received: from pfbgv13.prod.google.com ([2002:a05:6a00:4e8d:b0:730:848d:a5a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:ce4a:b0:1f5:6e00:14c9
 with SMTP id adf61e73a8af0-201797a56eemr936365637.15.1744325815468; Thu, 10
 Apr 2025 15:56:55 -0700 (PDT)
Date: Thu, 10 Apr 2025 15:56:53 -0700
In-Reply-To: <20250324175707.19925-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324175707.19925-1-m.lobanov@rosa.ru>
Message-ID: <Z_hMtVGU9Sg-TTtc@google.com>
Subject: Re: [PATCH] KVM: x86: forcibly leave SMM mode on vCPU reset
From: Sean Christopherson <seanjc@google.com>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Mikhail Lobanov wrote:
> Previously, commit ed129ec9057f ("KVM: x86: forcibly leave nested mode
> on vCPU reset") addressed an issue where a triple fault occurring in
> nested mode could lead to use-after-free scenarios. However, the commit
> did not handle the analogous situation for System Management Mode (SMM).
> 
> This omission results in triggering a WARN when a vCPU reset occurs
> while still in SMM mode, due to the check in kvm_vcpu_reset(). This
> situation was reprodused using Syzkaller by:
> 1) Creating a KVM VM and vCPU
> 2) Sending a KVM_SMI ioctl to explicitly enter SMM
> 3) Executing invalid instructions causing consecutive exceptions and
> eventually a triple fault
> 
> The issue manifests as follows:
> 
> WARNING: CPU: 0 PID: 25506 at arch/x86/kvm/x86.c:12112
> kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
> Modules linked in:
> CPU: 0 PID: 25506 Comm: syz-executor.0 Not tainted
> 6.1.130-syzkaller-00157-g164fe5dde9b6 #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> RIP: 0010:kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
> Call Trace:
>  <TASK>
>  shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2136
>  svm_invoke_exit_handler+0x110/0x530 arch/x86/kvm/svm/svm.c:3395
>  svm_handle_exit+0x424/0x920 arch/x86/kvm/svm/svm.c:3457
>  vcpu_enter_guest arch/x86/kvm/x86.c:10959 [inline]
>  vcpu_run+0x2c43/0x5a90 arch/x86/kvm/x86.c:11062
>  kvm_arch_vcpu_ioctl_run+0x50f/0x1cf0 arch/x86/kvm/x86.c:11283
>  kvm_vcpu_ioctl+0x570/0xf00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4122
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> Considering that hardware CPUs exit SMM mode completely upon receiving
> a triple fault by triggering a hardware reset (which inherently leads
> to exiting SMM), explicitly perform SMM exit prior to the WARN check.
> Although subsequent code clears vCPU hflags, including the SMM flag,
> calling kvm_smm_changed ensures the exit from SMM is handled correctly
> and explicitly, aligning precisely with hardware behavior.
> 
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b64ab350bcd..f1c95c21703a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12409,6 +12409,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	if (is_guest_mode(vcpu))
>  		kvm_leave_nested(vcpu);
>  
> +	if (is_smm(vcpu))
> +		kvm_smm_changed(vcpu, false);

Hmm, this probably belongs in SVM's shutdown_interception().  Architecturally,
INIT is blocked when the CPU is in SMM.  KVM's WARN() below is intended to guard
against KVM bugs more than anything else, e.g. if KVM emulates INIT when it shouldn't.

SHUTDOWN on SVM is a weird edge case where KVM needs to do _something_ sane with
the VMCB, since it's technically undefined, and INIT is the least awful choice given
KVM's ABI.

I can't think off any other paths that can/should force INIT while SMM is active,
so while it's a bit gross to have this as a one-off, I think we should do:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc1c721ba067..5a2041bc1ba2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2231,6 +2231,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
         */
        if (!sev_es_guest(vcpu->kvm)) {
                clear_page(svm->vmcb);
+               if (is_smm(vcpu))
+                       kvm_smm_changed(vcpu, false);
                kvm_vcpu_reset(vcpu, true);
        }
 


> +
>  	kvm_lapic_reset(vcpu, init_event);
>  
>  	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
> -- 
> 2.47.2
> 

