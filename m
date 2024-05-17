Return-Path: <kvm+bounces-17695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613BC8C8BA5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B161286281
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C9E158A39;
	Fri, 17 May 2024 17:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tn+/7Arg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9EC158A03
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967667; cv=none; b=dwXgEev+0PYpXx7f/sIrAA23H2r0VifAzNaJ2/fIgsrcxoo3QOGndcuk/gBsex3IYypRH+5BikPe/eCU6RIAjcpx4hMvE/TEzI/ozVeoYOSxfC76EjzXZUY2H2nrydKSCFSzSvcSlHqDHVlMhQqZnmKdwQ22Gs7qecBgwLLgAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967667; c=relaxed/simple;
	bh=3zUzzzxucQZAbr71D0DmujeOsv7diMSfzYKvmLSrt/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V50D+raw6vXcwXW5vZClKDIOwr5adyKrHTUgYyIfe94FkXH4w7BoGKt9JKAklX+U0IaZSg1rgJpw7kEIcvejQ5DoPSsAuq0IpeIGslFme5VfrJvScLERNOBxuVKpkp+C6JnCrJdjffwG59VJiiSc+jO4HVDBmIzkB92WYnerbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tn+/7Arg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so17822977276.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967665; x=1716572465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k9HN6+T1kQpxqp89cuzhx9jHoM7BiF89qZB9gdOCtKM=;
        b=Tn+/7ArggweaWW9nQLt3knMmriZ/g/+PyJbCtKEQk3l/a75rs0T7taGn7TYN/VCLJs
         F1f60XeG86uOESCVLl4hpWZ2/bcXqCc/iU+MdFhmvdeCgHHBQhN07heYquKCt6pcnrEo
         JnE5Q/2aDBwyqKd2FijWqV1/ZgDg8mYu0pPJZp8ibbY62PxkxBQwR0Kf9hLOLS3KpQ/v
         lZ9V7ArGSTTn0oK2ld1MjFLImbpwZQPvTDZyTAO09qfSU4hl5aMUBSn1aPD27YJdNLKd
         7E4hCrJ5R1i3L/GlpdNBdLPRtq6S9vemGQhwFOzsYKQIt7oSqEJNJJxPJVOY+4RAjUp4
         1G6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967665; x=1716572465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k9HN6+T1kQpxqp89cuzhx9jHoM7BiF89qZB9gdOCtKM=;
        b=N11inv1UZ0FcTdVMduBd2jHT4xitQXFV8Hh/IPk69MMJLAEjlECLuavEQUL9yivG0d
         cyLXcPZdfbWilfUNWTr0JsWnH6vFbofLdg+qMmYKDv21VllZsT9D9WrP0AaIGA1FXPHW
         PX+weefh5Ma2gP0ZO5QKe9PrVgnTLZ1FTRpdIa8FpMfQ15hsY6346ayEj2CI4vAQWq75
         TSdW6My07CnNl+a5dcYGUvPvAH8iVKMJGNxqoO0uK7ySq3f96Z8eiVleC3cYsCnEJidb
         fSFYjvJPSPCcAM6gDB34IL38CblDdSHnQHa38UTWKw4erqzp5sRyVvbFCXSX5NTLD9gH
         Vlhg==
X-Gm-Message-State: AOJu0Ywqx1zhWmofuORGfYch4Zx3JnrWjlvQijvUbhEj0fZEWAXOiFFn
	Gh0bLgGYmB5BLt+27BhffY80yPEQjEwr7kbk3YNSsq+VNVvIw/JGepJGUsv/CBqNnizbt2TPinZ
	7bQ==
X-Google-Smtp-Source: AGHT+IGHKMItbnVB37cVRqK29X+EjhtNIMWRmqgByCNxynwG28s4Mm9qr1xFC5xEY8Pk4mtu5ts0LMTnP54=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c05:b0:de5:2b18:3b74 with SMTP id
 3f1490d57ef6-dee4f33cb2bmr6152009276.2.1715967665318; Fri, 17 May 2024
 10:41:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:20 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-44-seanjc@google.com>
Subject: [PATCH v2 43/49] KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID
 irrespective of host support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

When making runtime CPUID updates, change OSXSAVE and OSPKE even if their
respective base features (XSAVE, PKU) are not supported by the host.  KVM
already incorporates host support in the vCPU's effective reserved CR4 bits.
I.e. OSXSAVE and OSPKE can be set if and only if the host supports them.

And conversely, since KVM's ABI is that KVM owns the dynamic OS feature
flags, clearing them when they obviously aren't supported and thus can't
be enabled is arguably a fix.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8256fc657c6b..552e65ba5efa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -336,10 +336,8 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
-		/* Update OSXSAVE bit */
-		if (boot_cpu_has(X86_FEATURE_XSAVE))
-			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
-					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
+		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
+				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
@@ -351,7 +349,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU))
+	if (best)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-- 
2.45.0.215.g3402c0e53f-goog


