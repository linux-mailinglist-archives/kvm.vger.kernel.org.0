Return-Path: <kvm+bounces-57446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC712B559FF
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CFDDAC6B99
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BDF1296BB3;
	Fri, 12 Sep 2025 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCh65ll4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DF4287515
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719412; cv=none; b=dVlTQHOuXedEj9Qz0GNnFHd/q3fwrwLTstZ9+2ohC8a1tiKuwfFooe0FOuQdLD/sMPliWNp0p62IE7TJ2tvES8qLaG2f6ZvOYWR1elKlpjQn0R+R/bvWMLuxhs3tew+QGSFbH9FzNE7qUsszIGxn6fXMIVYDn2KD0pKjA7fIKEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719412; c=relaxed/simple;
	bh=JgMtGiipAvsajCHzQDSZlw/ojgwsGzJlvzMoyoDNyyg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TplPEEDFmyJK/dgB4pyWi10f+PB+DkfhOFchMtHoUoGcKIsA82dxz+r8Ck5hTEE6sdTw+hr4PNl8BpghkLLcnrj8laWxh19Ejnks91Ffz2S/mCAvatK6+3xn3kN5vby8/ar0y0Q4OAQjfdc3yWzqWQfa2zU4UQB1Bu5+JyxIDWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCh65ll4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b57b0aa25so2525195a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719410; x=1758324210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xbwuOXbdUPdZ5BP99ZPo3T836Bd3RtRn8p0/DAva41U=;
        b=NCh65ll4DkCqeilv8w6DodpJfy4mCJB9opuy9Z4hl+QRh1+aXk8sL6tO11PKzLfLMY
         c8zDT8ZiIc7nyRMk61Do7OARIHO1MMvpbp0azadLqki1Zm3G1RcIHfOd1FE7E5LAUQ5L
         6r8FE33dtGcA0si2u92o4kSTP2uQRDB1rmXCZZ8O+f3KfXln2JD0rNllbUjQqebitQoJ
         oAdt49nCVT6xH5dcAqIvKhUgjVjS3SqLvbofv/cxqkZn6byldDly5HSYbiPSdps2QU3q
         QtfgzZmVG3NLCVaSZfxARJhGnv5u4eNDT91WeeAFwx5hxyrOJ6Le34iPrNqSYynbdQm/
         hR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719410; x=1758324210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xbwuOXbdUPdZ5BP99ZPo3T836Bd3RtRn8p0/DAva41U=;
        b=jHSCJMWlzKjCWmPeJ6iWJOsJnTLJ4YwTVT0gA4b/Sv+1YAKxlVolpVT9X9QQda7I7z
         wpvGQE4z+DPW4pmUou8Bpgy+eKZlOe9g39B9VPgknHkUIPHqosD/z13lhXwNUNCNBQIF
         nTuHgMGShDT5RsXwU6r4SQaO6/jiCDAqtQyorOQkewotFLVYRGwk/IyDl5Z/A3dYzGDK
         SN/S742SSMYvAaeUhpjGX5pHIAR0azsouB3haPukUN2cmWZDUmefiMZ+NBsugtU4U/+P
         qAlB8k9kO5DeERnPl5orDPCm73Q2mi0qw90/MYwhgF0mrjJKk8n6wQkSP+9VBdP4JOCg
         35cg==
X-Gm-Message-State: AOJu0YwdJLKSqhcBjj1Bij5GH7lmLuvORkvw6RMgND+aduLd8hwsDFvc
	9qOihFs7aG2sWTQsP9SrsvI121skKgczY5xxzCLxfUPwEGOrkFHQTVK8nNw19Ny3yBatp6mvfeK
	NTtELuQ==
X-Google-Smtp-Source: AGHT+IHq85FsVL5SmVTxL4Oz8O98fzC9mI2W/V9vx9QRJVTsUxxO380i38buUnmI9GAor06pwr2mJlmrR9Y=
X-Received: from pjk12.prod.google.com ([2002:a17:90b:558c:b0:327:e7c3:1ffe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3883:b0:32b:8582:34be
 with SMTP id 98e67ed59e1d1-32de4ec9af7mr4786721a91.13.1757719410251; Fri, 12
 Sep 2025 16:23:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:41 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-4-seanjc@google.com>
Subject: [PATCH v15 03/41] KVM: SEV: Validate XCR0 provided by guest in GHCB
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Use __kvm_set_xcr() to propagate XCR0 changes from the GHCB to KVM's
software model in order to validate the new XCR0 against KVM's view of
the supported XCR0.  Allowing garbage is thankfully mostly benign, as
kvm_load_{guest,host}_xsave_state() bail early for vCPUs with protected
state, xstate_required_size() will simply provide garbage back to the
guest, and attempting to save/restore the bad value via KVM_{G,S}ET_XCRS
will only harm the guest (setting XCR0 will fail).

However, allowing the guest to put junk into a field that KVM assumes is
valid is a CVE waiting to happen.  And as a bonus, using the proper API
eliminates the ugly open coding of setting arch.cpuid_dynamic_bits_dirty.

Simply ignore bad values, as either the guest managed to get an
unsupported value into hardware, or the guest is misbehaving and providing
pure garbage.  In either case, KVM can't fix the broken guest.

Note, using __kvm_set_xcr() also avoids recomputing dynamic CPUID bits
if XCR0 isn't actually changing (relatively to KVM's previous snapshot).

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/sev.c          | 6 ++----
 arch/x86/kvm/x86.c              | 3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb86f3cca3e9..2762554cbb7b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2209,6 +2209,7 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
+int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37abbda28685..0cd77a87dd84 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3303,10 +3303,8 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
 
-	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(ghcb);
-		vcpu->arch.cpuid_dynamic_bits_dirty = true;
-	}
+	if (kvm_ghcb_xcr0_is_valid(svm))
+		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
 
 	/* Copy the GHCB exit information into the VMCB fields */
 	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d85fbafc679..ba4915456615 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1235,7 +1235,7 @@ static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 }
 #endif
 
-static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
+int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0 = xcr;
 	u64 old_xcr0 = vcpu->arch.xcr0;
@@ -1279,6 +1279,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__kvm_set_xcr);
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
-- 
2.51.0.384.g4c02a37b29-goog


