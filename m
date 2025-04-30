Return-Path: <kvm+bounces-45004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 671CAAA58C1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 01:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCED41C20811
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 23:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC46822B5AC;
	Wed, 30 Apr 2025 23:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W7zjKHsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002F22AE6D
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746056003; cv=none; b=LtK1wjZ8sQWpm3SaUiBU6zqNUzNAvsv6uTcy9ZoNiU/s2SrTU0HCdVpGafZDRKSDa1dleTajewFMLMhZncHjKxUtGamBXmeqdJNgoL1mnavrEjb0O10Vw70/Lp9KYuO0BakP1ZOgR81Vh5UWxU8ES0GKQmivhQ1k5qvXBq0kias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746056003; c=relaxed/simple;
	bh=13TEoOug1c178shNErwxbItX4rCUgqJob++RRGIzov4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaSFAqNZCGtWcBfgH5Xea+3DCVgPbttaU/xgtUMSxcvmvjo9jj/Z1S4RNulwDkxjsu/Ww9Cy/x8bE0alNleNuH/FrNOWCT6MPz/BwLFi4SXVrFvrzbwO4ETDFV5nNQJHjaH6aSdL81vvqyIxSoO0YlOiA7bRO+W0Xht02b+ieB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W7zjKHsX; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00ce246e38so365427a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746056001; x=1746660801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1afqcCJkSh9e1hKor3mC9NijR9trNJa2vPHDOEPSfQ=;
        b=W7zjKHsXdrPy1Bu5FUKV4myTNac/EnZb/5ByhnkNz4acNn5McPOYkYmGlTNR6zACqP
         NDJnod1OvardS/wnb3XlKEdnb/a9xX9VeYU9rs3VblJPHwwuneCVVvBfn5PlFqdFWKsM
         fvqU6fUBUHtRgHHRLlCNar1B6f/C2huVGVX7RcT/UGm4Wg5qZGYoEbshdLVwMhs7Y123
         tu/pf+vjMR/dIoyE81cE48GojKCT6CJfLm54eEPOdJINBmT3zrnfsnO7oUmGJaIKmDTa
         8zp95WFRO636GUF+APYR+F5OLx8mEpQrrw9UNNAYPMqNTelUmiCYKiYMwNbH9sqflqf1
         5udQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746056001; x=1746660801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1afqcCJkSh9e1hKor3mC9NijR9trNJa2vPHDOEPSfQ=;
        b=S2lanQhPv8XEcwWkhx8Zrlifi/M3Wn94Ue3iLI/asf1BUQgf5dG2KNkCcu64bEtVTl
         sAjXhQ9WZyN/lVQS3Zntxfit4951WLGAtXkjhuiddaR6lhw8gyq2Ab5n7GyK4iONPYi9
         x/rcGo0DEhqMUD+lnz9LtDhbCWqNl/Ag0PxBzmTCPZMbgm/Xf6Q1C8STo50zCrxznii1
         30iv9WUNnTclphLraoH1oeQYQBQU33nnEEEhYiYohZT6myhgYb6z/3cRjzc5sy+JOAzP
         XZbSFp+EUnrHqJDlOxNp7CJvT+l/umQhMxCSDxUr+eEFAk84A9mg1HZeYzAILtCKCexr
         Jjbw==
X-Forwarded-Encrypted: i=1; AJvYcCXXjsHN+gIXYgjNXJPrrGhLz0LaXypaOfww9vs3g+WFUXXBhJdEgOfJDMM5SVdCxqHB+y8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1hIQvX0DcH4JJakcdlHxH1+TZd0C1lyZDfn29ZglQnh7Q8KCz
	8lfRZiJplQ4Te+g898141U1piD1s2lD+MRR1VsBCVFgYdgIo7VZ4rl5x4trI+gAKJZR3HXI1OsJ
	EpQ==
X-Google-Smtp-Source: AGHT+IHA2tU9fmodeKKj4wNJF1CmHY6EYcSAZlb4ury7FhVhH8iZPp0UzgjQHs7WpsvPsidc+Ipop646fzQ=
X-Received: from pjj5.prod.google.com ([2002:a17:90b:5545:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2883:b0:2f9:cf97:56a6
 with SMTP id 98e67ed59e1d1-30a34409e9cmr6804834a91.14.1746056000424; Wed, 30
 Apr 2025 16:33:20 -0700 (PDT)
Date: Wed, 30 Apr 2025 16:33:19 -0700
In-Reply-To: <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250213175057.3108031-1-derkling@google.com> <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local> <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local> <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local> <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local> <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
Message-ID: <aBKzPyqNTwogNLln@google.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Patrick Bellasi <derkling@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Patrick Bellasi <derkling@matbug.net>, 
	Brendan Jackman <jackmanb@google.com>, David Kaplan <David.Kaplan@amd.com>, 
	Michael Larabel <Michael@michaellarabel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 29, 2025, Borislav Petkov wrote:
> On Tue, Feb 18, 2025 at 12:13:33PM +0100, Borislav Petkov wrote:
> > So,
> > 
> > in the interest of finally making some progress here I'd like to commit this
> > below (will test it one more time just in case but it should work :-P). It is
> > simple and straight-forward and doesn't need an IBPB when the bit gets
> > cleared.
> > 
> > A potential future improvement is David's suggestion that there could be a way
> > for tracking when the first guest gets started, we set the bit then, we make
> > sure the bit gets set on each logical CPU when the guests migrate across the
> > machine and when the *last* guest exists, that bit gets cleared again.
> 
> Well, that "simplicity" was short-lived:
> 
> https://www.phoronix.com/review/linux-615-amd-regression

LOL.

> Sean, how about this below?

Eww.  That's quite painful, and completely disallowing enable_virt_on_load is
undesirable, e.g. for use cases where the host is (almost) exclusively running
VMs.

Best idea I have is to throw in the towel on getting fancy, and just maintain a
dedicated count in SVM.

Alternatively, we could plumb an arch hook into kvm_create_vm() and kvm_destroy_vm()
that's called when KVM adds/deletes a VM from vm_list, and key off vm_list being
empty.  But that adds a lot of boilerplate just to avoid a mutex+count.

I haven't tested on a system with X86_FEATURE_SRSO_BP_SPEC_REDUCE, but did verify
the mechanics by inverting the flag.

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Apr 2025 15:34:50 -0700
Subject: [PATCH] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count
 transitions

Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
only if KVM has at least one active VM.  Leaving the bit set at all times
unfortunately degrades performance by a wee bit more than expected.

Use a dedicated mutex and counter instead of hooking virtualization
enablement, as changing the behavior of kvm.enable_virt_at_load based on
SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
result in performance issues for flows that are sensity to VM creation
latency.

Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
Reported-by: Michael Larabel <Michael@michaellarabel.com>
Closes: https://www.phoronix.com/review/linux-615-amd-regression
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5d0c5c3300b..fe8866572218 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
-
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
-		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
-
 	return 0;
 }
 
@@ -5032,10 +5026,42 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+static DEFINE_MUTEX(srso_lock);
+static int srso_nr_vms;
+
+static void svm_toggle_srso_spec_reduce(void *set)
+{
+	if (set)
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+	else
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+}
+
+static void svm_srso_add_remove_vm(int count)
+{
+	bool set;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		return;
+
+	guard(mutex)(&srso_lock);
+
+	set = !srso_nr_vms;
+	srso_nr_vms += count;
+
+	WARN_ON_ONCE(srso_nr_vms < 0);
+	if (!set && srso_nr_vms)
+		return;
+
+	on_each_cpu(svm_toggle_srso_spec_reduce, (void *)set, 1);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
+
+	svm_srso_add_remove_vm(-1);
 }
 
 static int svm_vm_init(struct kvm *kvm)
@@ -5061,6 +5087,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	svm_srso_add_remove_vm(1);
 	return 0;
 }
 

base-commit: f158e1b145f73aae1d3b7e756eb129a15b2b7a90
--

