Return-Path: <kvm+bounces-65032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF35C98E0D
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 20:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125383A55E7
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 19:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F033242D76;
	Mon,  1 Dec 2025 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k46U9Z/A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490A23AB87
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 19:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764617779; cv=none; b=jLPLWQ2tfEQwbV1Py3MlO05+E8Ym8NSJGwleM724onyz7Nmi7WHKnDtJbaUGYQhblQGNJFx4jKtYjXQV80Qln0YLN2Py1q882qmi/2HLQrtKeUNUDo6HhQmEs4t1Go0UKqyhV/lJbPX9GHnVE3uMdRr/i6tLG8zL1eu5LJHEtDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764617779; c=relaxed/simple;
	bh=JT7UdysScTLYEB5jBr+aSxxOSkbAsp8TEva5g0SGp3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4+9nl6EQpNNEtsYAX9Q40lDYqsSw+B5HNdCPlDB1wbWGFyIX63mCZjEfa4TfBjpZDzEuzXIHLZ7udGQ38cOnztF432n9IEScoAC5bUAQB4csb4wllzydButqN3tCwDkjTldWOmf2xDcSv0Eeo1X0coHaYh8ggeZ0hB1H94F+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k46U9Z/A; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-bde2e654286so3689489a12.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 11:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764617777; x=1765222577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQCjbV2mGlw6O2izvO5BhwvWW02BN1I+cPKMcGvpYFQ=;
        b=k46U9Z/Az2zAkAWJwVxrxU8ZFirsu/foJRldofwlA7g+L+g0axnAyo7zHp8HlvG1bV
         ++5Xwt2DTGQwvSYl/a+bg7cuqcyZ9ovt2OWnoQtlDM2S9E6MWDtGsBgwmz4fnfjvRgzq
         nqQx5wWysNIWZrYegvlm3DrtXliOzB2w60IjDyZOpAlB9gb6EUQCOstJ/kp6Kd0EKt5R
         le4aHVssimBhEVC7+0fMcYWtGlPqsAoRH9wZkFhkzUOWjgzw040UldV/kYbKzz4Ew5vj
         Z4QBcluQ9I8fl/GQ/yuqLkC2u2/6rpljHhz83MhcSit28CZFpos4VVj51K6K4wrVcoyQ
         0dNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764617777; x=1765222577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQCjbV2mGlw6O2izvO5BhwvWW02BN1I+cPKMcGvpYFQ=;
        b=sLuLktPyGlvbz8WVyQ80eK+qZz0HjHKIxO0L1t+grdfjb3vX+TH3tbKGrhRVpBMjrJ
         aML/AIlcGHJ+3rtl4tw/iYPkZVPVtjOjIjTSRJzIdKLHFUB+YsGh3oMExYaQnxsihj3a
         TEMaTEYqCoFelPRcFBa2OQeYcJJShnTlyDmsmyvILkUGJa81+5GleTH3kcwd3Ovqs9Na
         eHlfBi/lkV3eH2UIhHhf6qk9SL6gXN8fk0vzlN5V9GT7aI58+2w7+DBj51Wj0BIdzmTE
         HvJUqsmkSwRZG7qF9DEGRBrzxZLiUREaVUnkToQvPNJsxy5p5plKvs3cEILimN6ZQVYc
         pz4w==
X-Forwarded-Encrypted: i=1; AJvYcCUEMP/HtRvALI/Mr9/YxctNZ72qvHGusjTRAHEPs1hncdFhdg0LsvXhexw3pRqG7lCHwPI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIIaf7bOyfzvkAzHd6iTwqGTx8K8Yt2/nzHecViCim0ttSUmIu
	Ad9odfOS1K9qh3KGPSYUCZks+MjuCG9SVFKVorDy9qrg9PRU8u1t7Dv/RuwzMIbCDwHG2fspW18
	b4Mdv1g==
X-Google-Smtp-Source: AGHT+IEaB2xyQ9W2Sbn8MH6Myd3NvAY+3AdHE8SOPGd2yoSG1JOwLeWDNU8UrlFrMXrDOX71NxS3t9XyjIc=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:32e:aa46:d9ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54cd:b0:33b:a5d8:f198
 with SMTP id 98e67ed59e1d1-3475ed6ada7mr23445156a91.25.1764617777282; Mon, 01
 Dec 2025 11:36:17 -0800 (PST)
Date: Mon, 1 Dec 2025 11:36:15 -0800
In-Reply-To: <aS26gBXQnHjgSDW5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com> <20241211013302.1347853-6-seanjc@google.com>
 <20251128123202.68424a95@imammedo> <aS26gBXQnHjgSDW5@google.com>
Message-ID: <aS3uLyKFawM8V-ed@google.com>
Subject: Re: [PATCH 5/5] KVM: x86: Defer runtime updates of dynamic CPUID bits
 until CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 01, 2025, Sean Christopherson wrote:
> On Fri, Nov 28, 2025, Igor Mammedov wrote:
> > On Tue, 10 Dec 2024 17:33:02 -0800
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Sean,
> > 
> > this patch broke vCPU hotplug (still broken with current master),
> > after repeated plug/unplug of the same vCPU in a loop, QEMU exits
> > due to error in vcpu initialization:
> > 
> >     r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);                         
> >     if (r) {                                                                     
> >         goto fail;                                                               
> >     }
> > 
> > Reproducer (host in question is Haswell but it's been seen on other hosts as well):
> > for it to trigger the issue it must be Q35 machine with UEFI firmware
> > (the rest doesn't seem to matter)
> 
> Gah, sorry.  I managed to handle KVM_GET_CPUID2, so I suspect I thought the update
> in kvm_cpuid_check_equal() would take care of things, but that only operates on
> the new entries.
> 
> Can you test the below?  In the meantime, I'll see if I can enhance the CPUID
> selftest to detect the issue and verify the fix.
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d563a948318b..dd6534419074 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -509,11 +509,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>         u32 vcpu_caps[NR_KVM_CPU_CAPS];
>         int r;
>  
> +       /*
> +        * Apply pending runtime CPUID updates to the current CPUID entries to
> +        * avoid false positives due mismatches on KVM-owned feature flags.
> +        */
> +       if (vcpu->arch.cpuid_dynamic_bits_dirty)
> +               kvm_update_cpuid_runtime(vcpu);
> +
>         /*
>          * Swap the existing (old) entries with the incoming (new) entries in
>          * order to massage the new entries, e.g. to account for dynamic bits
> -        * that KVM controls, without clobbering the current guest CPUID, which
> -        * KVM needs to preserve in order to unwind on failure.
> +        * that KVM controls, without losing the current guest CPUID, which KVM
> +        * needs to preserve in order to unwind on failure.
>          *
>          * Similarly, save the vCPU's current cpu_caps so that the capabilities
>          * can be updated alongside the CPUID entries when performing runtime

Verified the bug and the fix with the below selftest change.  I'll post proper
patches after full testing, and cross my fingers it fixes the hotplug issue :-)

diff --git a/tools/testing/selftests/kvm/x86/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
index 7b3fda6842bc..f9ed14996977 100644
--- a/tools/testing/selftests/kvm/x86/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/cpuid_test.c
@@ -155,6 +155,7 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 {
        struct kvm_cpuid_entry2 *ent;
+       struct kvm_sregs sregs;
        int rc;
        u32 eax, ebx, x;
 
@@ -162,6 +163,20 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
        rc = __vcpu_set_cpuid(vcpu);
        TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
+       /*
+        * Toggle CR4 bits that affect dynamic CPUID feature flags to verify
+        * setting unmodified CPUID succeeds with runtime CPUID updates.
+        */
+       vcpu_sregs_get(vcpu, &sregs);
+       if (kvm_cpu_has(X86_FEATURE_XSAVE))
+               sregs.cr4 ^= X86_CR4_OSXSAVE;
+       if (kvm_cpu_has(X86_FEATURE_PKU))
+               sregs.cr4 ^= X86_CR4_PKE;
+       vcpu_sregs_set(vcpu, &sregs);
+
+       rc = __vcpu_set_cpuid(vcpu);
+       TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
+
        /* Changing CPU features is forbidden */
        ent = vcpu_get_cpuid_entry(vcpu, 0x7);
        ebx = ent->ebx;


