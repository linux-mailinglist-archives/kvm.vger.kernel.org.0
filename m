Return-Path: <kvm+bounces-32670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8CC9DB0EB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06ACAB232E8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA547F460;
	Thu, 28 Nov 2024 01:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dWGtAEC6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35CE1990C8
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757707; cv=none; b=auseYuajwYPqsCjWMAztvNhJMleEjb+piU50qeLrDMUtroRcJzQDk/4ag2rpBGJV0LOxrcUl7sQNJ2R3PcjDpZB+BlBWHSIAeAPhwG6urMUVdHlaGdFsoQZOP2YDoKpW3/1BGbqo4XbH8YCrq4aWj1cF8nyUcwHzexhxCQwDKNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757707; c=relaxed/simple;
	bh=VseGUgryPcPTWZKlC0C2iibRsz1MHN1KsIK5nnX3zDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hZIAM1LrIHJ9BYuYPQB1cXpvjBx+sjdfUa+szL/qTsxTM0h5zsceAnaypRNX7Qlejx2RxWdwSR3RUFJy7bg8EIQ6v7XTlRaVzznUq8MnNQRAgMngcyz7Vsyk6GIN1jk0tQZtmL2COnxKMUVTEUANOZyTgjGZafVAWxvK+g0dH0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dWGtAEC6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea6b37ed73so291193a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757705; x=1733362505; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GE+nsaGoUSmVv5bpLiK54rKpjY/C6noP2mbx374ZUDg=;
        b=dWGtAEC6+OEJUrNIGqvhKt0oucq7wDF4apoXW5+2RtlU/pjJh7CyDg6cHj3IDQvW/j
         MhnEpPJFfEPAk0Dmsf3ehl9rjxcjRl/ZVCyDFTrBethSjMjKWj2OmFdOBAsOyvcQOkdd
         3mxhWo35e9fwW6LxhEeNGMeRWPyxJk0kK7quJuAfthGiSx03wo2Qc6+KfOvuoJ37QMqt
         ME9YWlXvt6qb2mdVOxlOiW/SFla1qtj8fl7jzAaIjJP4chOaXWa45JkckE+76wf3Gwf5
         fJhuv81K6iC8zIFnPTRP8bonicBAWSQV/1XPqjUAB25ihpNmwPaS4YC+YrC8Bhs3zIOj
         1XHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757705; x=1733362505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GE+nsaGoUSmVv5bpLiK54rKpjY/C6noP2mbx374ZUDg=;
        b=ZJkslY8djLSitc/hk2sAHBfnY3ztxpv/TyxEWWP/e5KkjgP51iRxpq+OhAxP+AbLdq
         bbX+aECm0vsyiwrWMVVBWextY+y+60fp4q1l4sxZV9P+LNdTxI8kTd/PAJt4mCGEg+RR
         hvm2L0SXnx4n5cBFaEwdffh5HeIReKxAlu/f7dLwTu8XNy5RxLIeQFxACpGxVcbUKhSZ
         Xw+WW8rA7iyn47Oe3i3n6iE4+cx469LmwS2jrhXQR6SCLs2RiO1ikHP5MtiemtgEBIcw
         Trm2pHav7eMsiCpWPH4xlbpAJgXFnPsDB+5bKtcMUITHb/7tKZXBty1QlcGx7mhjf/Zi
         Q2vw==
X-Gm-Message-State: AOJu0YzOnGuxXCyOlrCpRtMvFcMTGo990Jr4PwCm8DWUl+4mcZ5v36Pj
	vckkR5FEvqflKfMJm7qX1j413qkfv4k00G7tsSZouzY4AKNh+L6qpR5QOk+CYNLO0RTVoiDQOBA
	irQ==
X-Google-Smtp-Source: AGHT+IHQqUAb/mhLk8prNSdxsBoo+ncLhik/eNKYfwllWFEg2POmaoaDrC7hl3wM1A0yRlWY9WaUNR6d3Rc=
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:2ea:8715:5c92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d80d:b0:2ea:9f3a:7d9
 with SMTP id 98e67ed59e1d1-2ee25abf591mr2226102a91.3.1732757705290; Wed, 27
 Nov 2024 17:35:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:46 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-20-seanjc@google.com>
Subject: [PATCH v3 19/57] KVM: x86: Don't update PV features caches when
 enabling enforcement capability
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 arch/x86/kvm/cpuid.h | 1 -
 arch/x86/kvm/x86.c   | 3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a94234637e09..bfb81e417bef 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -247,7 +247,7 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
 					     vcpu->arch.cpuid_nent, base);
 }
 
-void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+static void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index e51b868e9d36..d4ece5db7b46 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -12,7 +12,6 @@ void kvm_set_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
-void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b7f8047f896..9f0ffc3289d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5814,9 +5814,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
-		if (vcpu->arch.pv_cpuid.enforce)
-			kvm_update_pv_runtime(vcpu);
-
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.47.0.338.g60cca15819-goog


