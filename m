Return-Path: <kvm+bounces-13781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEDCB89A7B7
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9954E2812D8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE22182862;
	Fri,  5 Apr 2024 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T3s+Y8Sq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A146B74BEC
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361389; cv=none; b=hyTUk28zoKO6cXGyPPFB6HEK6nA4hltdg9TU418VigXt6kj4biSflx+KKQGmRP0YA8FmJu4+Mpz1iguctgQDS1VHczVYr/gK0DRSStdnyiXIwCbaLUe+R+Q2umIIZ9rsD0ZhLJ4LZqLn9j6WfyZ9GaCzuPKpaWticnS96ORkJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361389; c=relaxed/simple;
	bh=5RDlYnCWS4ayQasdUGV2EFJf2g/5sa2I9izwXCuUezI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dBAEDnGjAOTY0AMcHldM3r8bz4PbYF1yIOZj4XTanDdgDEoaUwTf2K6aWhYgta/PPJtNX5rrp8wlRdoqBSKX5FwB6THDnXIew+8NfJ8I8wBI+TmeqyDE13wCggTI+aDt7c7xl6ctwG4dGxig9HvNQ5osluaLa4VIyBdGv7ypbyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T3s+Y8Sq; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-610c23abd1fso47693677b3.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361386; x=1712966186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GbwikEYWbQPXHEM5/lws4KQQn5EqaCgsUvoAMFf6UNk=;
        b=T3s+Y8SqupuAdHuqAourmoM0WiRcDm/9RvAI+UhLOgJaCvTEX38tD20PUzelLg9CCM
         Evf9MLKH+Ccd3gqgomBYmBjuGNzvV+Q3p3CzNNG31V8eR4lLo9QC1KaNdA8qf5Iu6ZG5
         VGRuxMiNrr/+CBYYCeCjL86cVLdu8T+a6YH7I0HGlfXFOAuiN3l+SpjsdEUsUm8jICqP
         OHGNDG1M9bVqmTJXA++UM2afd3wAF3ayrmHVmiANJh5DLCGsLKROencvAGLd56Tugp+q
         +2s/ROuQNzHkmqVeiPHGIEYX3MKQsR+6yCOPSi37czkRMXvmKbcFdE0HL+tGWM6vFmdt
         djWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361386; x=1712966186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GbwikEYWbQPXHEM5/lws4KQQn5EqaCgsUvoAMFf6UNk=;
        b=vkqIkftAHbDYsfD21SfqFJEde5OBXPM0xC02juin+VhLns0j4YxJB6RIVjvc0wNZcD
         CIx1mw6RHAkXfS57LkHNDBMTsWGNTSj7g64hPF8YNTdnnVDlRwLAy4SF3cwrn4Q9jwTE
         eYMXbh0awX11pK/VQi1WGC8c3j66VRWZAHbstnnNk4TxnNH5bbCptbVp6B5+UuuHl8/V
         xSEyIxJ97Jj1ajCM+G3ecYqArPRv7Cjr6MIqMuaioCEYNIg9ZcI8wXwapkDM+52a/ToS
         FZMyLYUQwuZinAW4XK85A1aP8xc1+gChLQadky6Lwe/ZoUfNYN7tQLfVAqBeDk+kUD/b
         8crA==
X-Gm-Message-State: AOJu0YxEos0We3rrn+yh77K+I6MbfVIRga2AmvbtOtGqaD/xsTBVjkQR
	EcbLBwhB2oFVj16UWo2hE+76Sq90Mf3y2l70ipHWYN4/+1HJIQqJ3/YwJmO2L9UNrxxFRY26OGX
	QLA==
X-Google-Smtp-Source: AGHT+IE8jGFCNdnvcQoFiWg4slvFmL6J7M5uI9g+aVjoREsOBmGh3S15qyummmRu81lWYixJYoV7vfpkwtw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d0c:b0:617:cbcf:8233 with SMTP id
 cn12-20020a05690c0d0c00b00617cbcf8233mr712182ywb.2.1712361386753; Fri, 05 Apr
 2024 16:56:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:56:03 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-11-seanjc@google.com>
Subject: [PATCH 10/10] KVM: x86: Bury guest_cpuid_is_amd_or_hygon() in cpuid.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Move guest_cpuid_is_amd_or_hygon() into cpuid.c now that, except for one
Intel quirk in the emulator, KVM checks for AMD vs. Intel *compatible*
vCPUs, not exact vendors, i.e. now that there should not be any reason for
KVM at-large to care about the exact vendor.

Opportunistically refactor the guts of the helper to use "entry" instead
of "best", and short circuit the !entry path to make the common case more
readable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++++++++
 arch/x86/kvm/cpuid.h | 10 ----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 77352a4abd87..c5fb39930213 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -335,6 +335,18 @@ static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 #endif
 }
 
+static bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry(vcpu, 0);
+	if (!entry)
+		return false;
+
+	return is_guest_vendor_amd(entry->ebx, entry->ecx, entry->edx) ||
+	       is_guest_vendor_hygon(entry->ebx, entry->ecx, entry->edx);
+}
+
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 03d015e9ce33..41697cca354e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -102,16 +102,6 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
 		*reg &= ~__feature_bit(x86_feature);
 }
 
-static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = kvm_find_cpuid_entry(vcpu, 0);
-	return best &&
-	       (is_guest_vendor_amd(best->ebx, best->ecx, best->edx) ||
-		is_guest_vendor_hygon(best->ebx, best->ecx, best->edx));
-}
-
 static inline bool guest_cpuid_is_amd_compatible(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.is_amd_compatible;
-- 
2.44.0.478.gd926399ef9-goog


