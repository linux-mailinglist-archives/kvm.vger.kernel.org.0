Return-Path: <kvm+bounces-9551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98273861877
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1CF01C233A3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3B9128833;
	Fri, 23 Feb 2024 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8e0znP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A0B84FAF
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707072; cv=none; b=LE6HwF0v637xlOQS5vKCV6R2I6FJZPnJAN1TQTH/1mUt1nkOHt60qu1YEQxtdJ2KuU7K5XOpVpl+aWyfM0oGMcs9ZohIgFkZW2guKcBRxw6GLiXJD/B0hFQzKvD+AnAl+bGBrrxvbkfsQQWZ2+dFsqpe/r7K0vsqLmkYFtjWUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707072; c=relaxed/simple;
	bh=K86n2PLe4V7ZstD7p0ayJ/X5fiWcYxjh3elhoSAYw8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W8RcC3fUWLJ0NsrgpkLyydClOAws2/TUJ+odKHleuBEqA2V6n2YKnH+3DV9/lZNemeDCkHTZSN4Yim5u8JhpVNfDw9iVci7lFkgCnIJU9/Fv8iywRZuCCAP0N/DLp+r6m2nIOxLlXNJmege6ywmek+Ql14rS8s22tzyI3CdH27M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8e0znP5; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so1011082276.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708707070; x=1709311870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H982CKrjEM3zVkjSPU+J+WNizEP2QCcAVQV6QKucHL8=;
        b=p8e0znP5v9Vlcz1f9owEuDKkdfJkzqvVysaERciumbLtXADC6fMst7pJRwoZAHrucO
         1MtGF8/K0ehegb+1PCcxv4paW11JWPVpvXUIzG8wkZLpgt5sDxQ3NqCsfpx0l0O840Pf
         /QfcHxBKktu0OqMGqXmZNWLRquDEyl0UlzpHnFudkYIurwvBVuZNOkv0AlZMA1lcWPas
         Bqdk2q/JBBMW6Jz5cljmTJkNC5qzX9Ceh983wFGahmLNvSFZ82E0fq3aDGVa2UvUGPCI
         SPkvEYfEOrqD4+z0Q4HZwCr1g7qNe8PRbhvuTYYwrNcFTtvmMnS7ihHu/2Ln+DhUOCKJ
         AY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708707070; x=1709311870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H982CKrjEM3zVkjSPU+J+WNizEP2QCcAVQV6QKucHL8=;
        b=qTCIlj2B7T+gAcbCHeNoEyjENTUvD6nu/jxrBjrNFcR+zp7AXwBtTpIyT0mR7lc6XJ
         1F5Wo+AK8nl/KW6vQy2XlZxl2BC4P6Fa2k92+bwNv+sVXsjv+rj8ScQkd4BU3VO4C1kH
         TcfShX75UwbOVqACEg+ftUMS6DeXno1E7mJ1bj/QCrsV63DJfzAG8RPkYyTsl3FiSVAz
         CuyvkFW0qZ2wqBe9nI0FqjkUUZJu+gfN4oVa7eZOeb2WPOXcYMt8cMxJW7rfjkxiFiRf
         IxmnJH2eBRC4mwBl54kF220Ja15AnI08IQ3WPw4WMc+Y4cuqOBk0IJTwLIgKSZf7OfDC
         10gg==
X-Forwarded-Encrypted: i=1; AJvYcCX2828nSqvvkz7q56NAcSNDCSpMXABB+LSHkGzRRCoBGCX6jQAaaPNz6jrMIFbcueHI29cGnL7ji+TnfXLpxSRzQN2V
X-Gm-Message-State: AOJu0YyF/91vdWjIrv5kowcKJ6v7pgmQXi6RX27j26IsmxrmDAAWMUgr
	jHST+GCiO6MWz3a81n0tWPEByDDGI6qqfXm+uMiqb/AqT3nhYCr+43d+OflupSdmbCaJBo/Oqpv
	K7w==
X-Google-Smtp-Source: AGHT+IEmIJAxnTmijGvjXk4dw64jZqXiQZkaHJtqJKekCM5z3bHw1FpJVJI13Rhw8+eqpimDRwCPT+6sr0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1108:b0:dc6:fec4:1c26 with SMTP id
 o8-20020a056902110800b00dc6fec41c26mr91952ybu.1.1708707070439; Fri, 23 Feb
 2024 08:51:10 -0800 (PST)
Date: Fri, 23 Feb 2024 08:51:08 -0800
In-Reply-To: <20240223104009.632194-9-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-9-pbonzini@redhat.com>
Message-ID: <ZdjM_LVd3avtZj1h@google.com>
Subject: Re: [PATCH v2 08/11] KVM: x86: Add is_vm_type_supported callback
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> Allow the backend to specify which VM types are supported.

Hmm, rather than another kvm_x86_ops hook, I vote to add kvm_caps.supported_vm_types,
and use the existing harware_setup() hook to fill in the vendor specific types.

As a very incomplete stub:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bc69b0c9822..bb7d979db2df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,17 +4576,9 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 }
 #endif
 
-static inline bool __kvm_is_vm_type_supported(unsigned long type)
-{
-       return type == KVM_X86_DEFAULT_VM ||
-              (type == KVM_X86_SW_PROTECTED_VM &&
-               IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled);
-}
-
 static bool kvm_is_vm_type_supported(unsigned long type)
 {
-       return __kvm_is_vm_type_supported(type) ||
-              static_call(kvm_x86_is_vm_type_supported)(type);
+       return kvm_caps.supported_vm_types & BIT(type);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -4787,13 +4779,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
                r = kvm_caps.has_notify_vmexit;
                break;
        case KVM_CAP_VM_TYPES:
-               r = BIT(KVM_X86_DEFAULT_VM);
-               if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
-                       r |= BIT(KVM_X86_SW_PROTECTED_VM);
-               if (kvm_is_vm_type_supported(KVM_X86_SEV_VM))
-                       r |= BIT(KVM_X86_SEV_VM);
-               if (kvm_is_vm_type_supported(KVM_X86_SEV_ES_VM))
-                       r |= BIT(KVM_X86_SEV_ES_VM);
+               r = kvm_caps.supported_vm_types;
                break;
        default:
                break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..802ac1ead055 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -29,6 +29,8 @@ struct kvm_caps {
        u64 supported_xcr0;
        u64 supported_xss;
        u64 supported_perf_cap;
+
+       u32 supported_vm_types;
 };
 
 void kvm_spurious_fault(void);

