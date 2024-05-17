Return-Path: <kvm+bounces-17668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A338C8B69
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA83BB241E5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45A31448E8;
	Fri, 17 May 2024 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LAVKJbT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A46143C69
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967615; cv=none; b=fyoasXaYUfzkJeI4CYm1w8TOARxgG2zOAglx2xFmvjxgUN5/WIKFzm0Olizq6DQBX/dk7IR/SkrFnFaZcAPPOmJC/FcZvTgM6D4CdZzEQtqUIb1PEHFl2l6VuspmaHxxj8EQSPX3fg6bGoJl6oZQtQcFZKzM/GGLrT6zsdSYNwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967615; c=relaxed/simple;
	bh=iP0L4SxUVEyEbwSyTD2h0iJ+oHlybHZyrqWrfGMFfXY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pAZZ+QXAe5j5jY9Mi91gNZKpaeQhozkOVgf7qk9ydOqWtY9oQ58XEtlfFg+nBL9XKhbnNpD/BoKfYK8R6/zBciqx7l15XjbqFfYKhkk+KRsvdyMX+9uf1LCUP5rOXo+NPbgESsX/7ZjwLeIiYs9VyQ7/9J9HMo43vduL/UgY0sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LAVKJbT1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ba04ab5e2cso2520157a91.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967614; x=1716572414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uy/Z1Gc/com6+2iOEwxMfm4DvRtWwEY0F8XI68VC7ms=;
        b=LAVKJbT1eHVLkVVxsGftaK8XSm0CTM2GLhlz+tdUCTV1UOs16DHVHhUqzllBwM0CZQ
         qGpxbD/mt2Xj9uiHfLT7bQyASw9Mhl96/0cJYcM5ye6wXlbqz8YjiVrGEzHXLikoNj/0
         capT9Iu9Dcq7dcIE6W9UuApm8Ub0B4NacWvFtFU199oWs3Kil7ngmRnpn60DFRS5EyHf
         7LwqIyi58gpKab/3w0dR5VayN8NRWVShn1L1Hgvmhc5CPqCczfG4+DaYkMQf7/f5/Esv
         vhHX/yLqR11LCKLBmocOkKphAQrVk+Vm9sdQzZFDqwAyKsxrX7YVXFUgTfrb/3/m6VFe
         2B4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967614; x=1716572414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uy/Z1Gc/com6+2iOEwxMfm4DvRtWwEY0F8XI68VC7ms=;
        b=OffaXjb1DssbD/N8IruzyW6jlpHd/MUtE4NaoLVvOW3L6wyvTqO9qrA4a8pbgjJ7Lx
         BCnu6IqOZIewUQlkVTa8ZtD2srf4jnfOzIQ6EM/4CzdcoULQg1/YvguN4/7lt8IB52d6
         72Qi4h+HZxjHLfLdcId4BId6jKKVU45ZvherlL7KBu5YT1th1WD2uwPX0/KM/SX44Gnf
         S0wU0FL5vvk/gEV0toXLlBBExVyea0pzP+VACERqWKjjcT8E3bsnNIRmx21WpGW2gPaZ
         NdX3kvqMpTfcnu0qnIM66WXjbLbrQLSevyWq1t6B5mTSEacvRJENYbmcktpOT38NSG/Z
         eUZA==
X-Gm-Message-State: AOJu0Yy+JxOCvEXtjppU6VP5FcWtbV7Zxn0YAjqSQXwv3r7qzNZ+nNvD
	eRo6vmWgPwZO/VO0NIQX94/TmiPgwL+Z2pOJbDKlRQq/0/rVu7zOss7NuVknG6Zfrtqp/vNA+lT
	pyg==
X-Google-Smtp-Source: AGHT+IHQb3at88a4Lls+46Ij7DF4SuhHSRKBnoDVHFny2AFiJAOxokrYtJUYzj4jwLvM0w0lGadt3DOU6xc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3bcd:b0:2ab:b480:5019 with SMTP id
 98e67ed59e1d1-2b6ccd85cfamr61647a91.5.1715967613719; Fri, 17 May 2024
 10:40:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:53 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-17-seanjc@google.com>
Subject: [PATCH v2 16/49] KVM: x86: Don't update PV features caches when
 enabling enforcement capability
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Revert the chunk of commit 01b4f510b9f4 ("kvm: x86: ensure pv_cpuid.features
is initialized when enabling cap") that forced a PV features cache refresh
during KVM_CAP_ENFORCE_PV_FEATURE_CPUID, as whatever ioctl() ordering
issue it alleged to have fixed never existed upstream, and likely never
existed in any kernel.

At the time of the commit, there was a tangentially related ioctl()
ordering issue, as toggling KVM_X86_DISABLE_EXITS_HLT after KVM_SET_CPUID2
would have resulted in KVM potentially leaving KVM_FEATURE_PV_UNHALT set.
But (a) that bug affected the entire guest CPUID, not just the cache, (b)
commit 01b4f510b9f4 didn't address that bug, it only refreshed the cache
(with the bad CPUID), and (c) setting KVM_X86_DISABLE_EXITS_HLT after vCPU
creation is completely broken as KVM configures HLT-exiting only during
vCPU creation, which is why KVM_CAP_X86_DISABLE_EXITS is now disallowed if
vCPUs have been created.

Another tangentially related bug was KVM's failure to clear the cache when
handling KVM_SET_CPUID2, but again commit 01b4f510b9f4 did nothing to fix
that bug.

The most plausible explanation for the what commit 01b4f510b9f4 was trying
to fix is a bug that existed in Google's internal kernel that was the
source of commit 01b4f510b9f4.  At the time, Google's internal kernel had
not yet picked up commit 0d3b2ba16ba68 ("KVM: X86: Go on updating other
CPUID leaves when leaf 1 is absent"), i.e. KVM would not initialize the
PV features cache if KVM_SET_CPUID2 was called without a CPUID.0x1 entry.

Of course, no sane real world VMM would omit CPUID.0x1, including the KVM
selftest added by commit ac4a4d6de22e ("selftests: kvm: test enforcement
of paravirtual cpuid features").  And the test didn't actually try to
verify multiple orderings, nor did the selftest enter the guest without
doing KVM_SET_CPUID2, so who knows what motivated the change.

Regardless of why commit 01b4f510b9f4 ("kvm: x86: ensure pv_cpuid.features
is initialized when enabling cap") was added, refreshing the cache during
KVM_CAP_ENFORCE_PV_FEATURE_CPUID isn't necessary.

Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 arch/x86/kvm/cpuid.h | 1 -
 arch/x86/kvm/x86.c   | 3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index be1c8f43e090..a51e48663f53 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -242,7 +242,7 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
 					     vcpu->arch.cpuid_nent, base);
 }
 
-void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+static void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0a8b561b5434..7eb3d7318fc4 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,7 +13,6 @@ void kvm_set_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
-void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c729227c6501..7160c5ab8e3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5849,9 +5849,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
-		if (vcpu->arch.pv_cpuid.enforce)
-			kvm_update_pv_runtime(vcpu);
-
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.45.0.215.g3402c0e53f-goog


