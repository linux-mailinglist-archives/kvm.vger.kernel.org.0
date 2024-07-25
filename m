Return-Path: <kvm+bounces-22268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B9093C8A4
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 21:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 676DFB2137E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 19:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30D555884;
	Thu, 25 Jul 2024 19:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kMbCa0Tg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEC32901
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 19:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721935121; cv=none; b=HFk1SeEfPD9AJn6TJXXimjGSRXIwWCbVNkAjanP326Ec55TTHbPgt5bRTWU621syBHCfT9I3ejRKgswx9N2bBLZdKNlWqIQsguYp/ppc5EzlsUoeC6hCig71p7i5cbTm7ntxHwDJ0xHEk4AXYumdfO1YTj4Ja6aYceQoKPqH5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721935121; c=relaxed/simple;
	bh=f47S07HxQhk5OOeKiB9K1NaJdEfEGg6zonQdkfbmIVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pVqMT64S/sjbNd4+O4cjpHQRdNsxrZ8LmJpKAjJrLTXrc8zExPgMKfac3ANa1XwMZTjv5m7kSUqOwpVB75THAddeg0e5/WyE6zl9ldoGxMbgZKZcx6SdtKx26Qwhn7Qdoc4JNwzPYrwB+nao0qrq2mH1GYX8jl5dM+ANl7kbqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kMbCa0Tg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb5ab2f274so192974a91.3
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 12:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721935118; x=1722539918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZqGB/Cz1hoMbWM8Wtkli9j/fLw3XavIJq7H92YX62Q=;
        b=kMbCa0TgsuCAlnbdpQEAVo/z3PbRq4Vv1jseTm+F8yup9LqmlU4Gt3V/kPyWGRUaBl
         pPiWaQXP3rSkmKng9wy87krZvz7mgM+TK4W2A+Zzg0qhVdcr0+WDNygbQpYXd8MT909N
         MCE0PTlaQ6iiK5pQ2cPcg/ziqi+3yLaKDTF+UcpaIhDjkG7esi+h+f0karZhT+1fMXHU
         KTlBc83RcNLtfcTf/MbE8p5YICTIof9knDsOdTL/h4o/uBhh4E72mDAbTm6upxRW/52M
         k1xvqdWEjFEXKPiGbnnLB2i8jDtk2YdcFhZ2wGjqNhn6iftlbH4jyFS4cXK+DOGOVpkl
         uV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721935118; x=1722539918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZqGB/Cz1hoMbWM8Wtkli9j/fLw3XavIJq7H92YX62Q=;
        b=jTX2n2i43I43UEelCCojWBFCQtlLlPaj9R/tf6SCFcC2TFOo6unnYBh99pyT8zXHaz
         oBDrk2thuv5ZhaSE299jJgkjbULt22hsnJk/1Bc13xNOk2YoyHArUcIQX8p4oFSSsTJS
         ecdredU3yHUQobQf/7Dq8ZYuXF1ZZ9cU3cvISbV1fk4D6yupPdBTXF8ebMuf/KYh6JMr
         BTPz1orXdI0q3//gUYy8vX4NZQY23kVOSW8uv+pzm84XshtJbub6DNUDC6Y+mm3nrQmQ
         oEQqIQE3Z82bsqLxg/1aSPmh8tUpwhSrNtRSrhZqqR2mIW56yf4cX/qz7v3nMDYlwwzY
         EWqA==
X-Forwarded-Encrypted: i=1; AJvYcCUKprlXzt/HBmkG9YNj5/0lFoZ4GZ1M0zapW5fdGlKHlqhC2Crg7H9M1/tUgx5vsnOx4xZmIy8yM1ko5Lhupd735q+c
X-Gm-Message-State: AOJu0Yy/JEoJrh8NxrYGfLhmtOPmVr9W55qdttC/IB41hT9NJ49U2BLz
	+GRFICECDCyX5AUPzHjgZIv6NBQnc9o0Mov7fyjRVLdiDNlmrIAi22Q17te5z7ECbXvU+9XzhgF
	f0w==
X-Google-Smtp-Source: AGHT+IEtgXYQkUIXD37Yz/7t6WWh99EgPL7KRqPGuvhdlSeVbC72DRGRweBbcAO2hMFFoU/E0DLF31xjEVU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d3c5:b0:2c9:7d81:fb1f with SMTP id
 98e67ed59e1d1-2cf2eb69b79mr65683a91.6.1721935117499; Thu, 25 Jul 2024
 12:18:37 -0700 (PDT)
Date: Thu, 25 Jul 2024 12:18:36 -0700
In-Reply-To: <41bdc5a77013796fa8cb6e61c410af3e064e274b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-24-seanjc@google.com>
 <7bf9838f2df676398f7b22f793b3478addde6ff0.camel@redhat.com>
 <ZoxXur7da11tP3aO@google.com> <41bdc5a77013796fa8cb6e61c410af3e064e274b.camel@redhat.com>
Message-ID: <ZqKlDC11gItH1uj9@google.com>
Subject: Re: [PATCH v2 23/49] KVM: x86: Handle kernel- and KVM-defined CPUID
 words in a single helper
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 14:18 -0700, Sean Christopherson wrote:
> >  And in the unlikely case that we royally screw up and fail
> > to call kvm_cpu_cap_init() on a word, starting with 0xff would result in all
> > features in the uninitialized word being treated as supported.
> Yes, but IMHO the chances of this happening are very low.
> 
> I understand your concerns though, but then IMHO it's better to keep the
> kvm_cpu_cap_init_kvm_defined, because this way at least the function name
> cleanly describes the difference instead of the difference being buried in the function
> itself (the comment helps but still it is less noticeable than a function name). 
> 
> I don't have a very strong opinion on this though, 
> because IMHO the kvm_cpu_cap_init_kvm_defined is also not very user friendly, 
> so if you really think that the new code is more readable, let it be.

Hmm, the main motiviation of this patch was to avoid duplicate code in later
patches, but looking at the end result, I don't think that eliminating the
KVM-defined variants is necessary, e.g. ending up with this should work, too.

#define __kvm_cpu_cap_init(leaf)					\
do {									\
	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
	u32 kvm_cpu_cap_emulated = 0;					\
	u32 kvm_cpu_cap_synthesized = 0;				\
									\
	kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |			\
			       kvm_cpu_cap_synthesized);		\
	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
} while (0)

/* For kernel-defined leafs, mask the boot CPU's pre-populated value. */
#define kvm_cpu_cap_init(leaf, mask)					\
do {
	BUILD_BUG_ON(leaf >= NCAPINTS);					\
	kvm_cpu_caps[leaf] &= (mask);					\
									\
	__kvm_cpu_cap_init(leaf);					\
} while (0)

/* For KVM-defined leafs, explicitly set the leaf, KVM is the sole authority. */
#define kvm_cpu_cap_init_kvm_defined(leaf, mask)			\
do {									\
	BUILD_BUG_ON(leaf < NCAPINTS);					\
	kvm_cpu_caps[leaf] = (mask);					\
									\
	__kvm_cpu_cap_init(leaf);					\
} while (0)

That said, unless someone really likes kvm_cpu_cap_init_kvm_defined(), I am
leaning toward keeping this patch (but rewriting the changelog).  IMO, whether a
leaf is KVM-only or known to the kernel is a plumbing detail that really shouldn't
affect anything in kvm_set_cpu_caps().  Literally the only difference is whether
or not there are kernel capabilities to account for.  The "types" of features isn't
restricted in any way, e.g. CPUID_12_EAX is KVM-only and contains only scattered
features, but CPUID_7_1_EDX is KVM-only and contains only "regular" features.

And if a feature changes from KVM-only to kernel-managed, we'd need to update the
caller.  This is unlikely, but it seems like an unnecessary maintenance burden.

Ooh, and thinking more on that and on the argument against initializing the KVM-
only leafs to all ones, I think we should remove this:

	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));

and instead explicitly mask the boot_cpu_data.x86_capability[leaf].  It's _way_
more likely that the kernel adds a leaf without updating KVM, in which case
copying the kernel capabilities without masking them against KVM's capabilities
would over-report the set of supported features.  The odds of over-reproring are
still low, as KVM limit the max leaf in __do_cpuid_func(), but unless I'm missing
something, the memcpy() trick adds no value in the current code base.

E.g. 

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dbc3f6ce9203..593de2c1811b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,18 +730,20 @@ do {                                                                      \
 } while (0)
 
 /*
- * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
- * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
+ * For leafs that are managed by the kernel, mask the boot CPU's capabilities,
+ * which are populated by the kernel.  For KVM-only leafs, as KVM is the one
+ * and only authority.
  */
 #define kvm_cpu_cap_init(leaf, mask)                                   \
 do {                                                                   \
        const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);    \
        const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;   \
+       const u32 kernel_cpu_caps = boot_cpu_data.x86_capability[leaf]; \
        u32 kvm_cpu_cap_emulated = 0;                                   \
        u32 kvm_cpu_cap_synthesized = 0;                                \
                                                                        \
        if (leaf < NCAPINTS)                                            \
-               kvm_cpu_caps[leaf] &= (mask);                           \
+               kvm_cpu_caps[leaf] = kernel_cpu_caps & (mask);          \
        else                                                            \
                kvm_cpu_caps[leaf] = (mask);                            \
                                                                        \
@@ -763,9 +765,6 @@ void kvm_set_cpu_caps(void)
        BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
                     sizeof(boot_cpu_data.x86_capability));
 
-       memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
-              sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
-
        kvm_cpu_cap_init(CPUID_1_ECX,
                /*
                 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*

