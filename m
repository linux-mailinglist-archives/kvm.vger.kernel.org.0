Return-Path: <kvm+bounces-32694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 171E89DB11D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9846B243F7
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E0D1CACD9;
	Thu, 28 Nov 2024 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NyqeEdNx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0AC1C68B2
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757748; cv=none; b=JL0yb1hbQTGpkuflNviWgcx7r5Ow9tiYVl20omh/nM89ZLpQYi+qy+xFxQ1gFvglmtgdXuk1ZUrGB/aC6STvMI5R1ySUcCUj3sxcgTL3rA7k/T8aci7XYv57DtcZsIeJPjelrWGK06e55eOsu27DoBc5WoQMZl/vxD3UbhYzf0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757748; c=relaxed/simple;
	bh=TB2Njr8V9gci+zAwKAzdTpYDyYSzzQCUHvTbCzkV3Hg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rh0O2RzVHFVrq8T9/TpiS/2iSe/4f16jtl0qciPLiBM1pv2N9mtkL7Riz1AXibllgPaU8ZaJFBKGEBMgNbFkiJIxAD953om47tqsWRzfaADffinnQ3a641KnOuFOcq6TTIHEeHYLTGxIFrqa8AATfSwy2OWFkXy94uwPk7IYzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NyqeEdNx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fc99b41679so279317a12.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757747; x=1733362547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Es0q4g30GZYN60Cs+30x4ZdeXkrOyT6BVfqdCAMrxSg=;
        b=NyqeEdNxr62JIS4wKhBkEYQfrYQNbJnMxePdve7093p+f5phOK5wxR2WWz0NnQZzJb
         qom2eTfHfVsuE8CIRxYc9XKVbWnFgttiyGWGVBNAz2m90wNJpfbTyi7agny9r55TLG94
         LNBVpOxjGuRL1+gqbmmXIKNHSRSWkwnERuJg5SPvOfymQ5BX8TaDXm0DB+wp+ryS1/J1
         A72lxqM7gCYQCtMEEBN8/SwumKyAtPMSyJR8hbX6ZLtnJ91AMMW6eGiOfsPo3XyqJgKg
         3V17z3ykuf8QoJ7remgNyYz45fkeI8WTwm+GLzvCcUiHJh48MnQzLqRuTaLvL06vHmls
         6wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757747; x=1733362547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Es0q4g30GZYN60Cs+30x4ZdeXkrOyT6BVfqdCAMrxSg=;
        b=ZgRgkYogq0klhNHnmW0AQ0eFwhVt9sHI18zIPs/2Qj6k+KquwplrlQPIWpl2huMD5P
         PoMn13r9EJ+FA2cP3tGGLuu51hLHkgP+OulCaXGmnjb/JjBoPCISM+i0prAbZmzM9K3k
         F6DwQhWn09OMaS93RzbIAR6Fwk151ljdIAU3+JliC5RiYm2f5DS3JVWPY/xPsE47IsUE
         GjTBpA7YerVHLnOG/Gbd17uN32hqy2EFP+PpbLCeJ7ZAozwwNoT8SuqEs5s+yLWoSfzR
         bb7O4Q6BgQkK/OrlwdR3qSwQ3PtYGjCBxfsX5Eq/J3UYUIWeGA0wTzMitmGuO7l5TIfo
         r79A==
X-Gm-Message-State: AOJu0YxagnKDhG+Dmvw+cPWquUjbZg7/Ik4rZNpXMeW2jEgtHw9MIw0O
	Y236CE5YH5g+OUnqEc/ppvvMhqae6eUmCSQ8YQ1DSmjJfWHHb1u+86ywx3R/ljLX8rvhk6wXqVP
	/rA==
X-Google-Smtp-Source: AGHT+IEw6weSthxvIraAPD0rAOQgIGwIWRbZouQyB9Vwv1JsmLlIKy5a1yr3A2u3ZRRwqrGTZTdXmZekq60=
X-Received: from pjbpd3.prod.google.com ([2002:a17:90b:1dc3:b0:2ea:543f:9b80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734a:b0:1e0:d1f7:9437
 with SMTP id adf61e73a8af0-1e0e0b80369mr6780795637.38.1732757746942; Wed, 27
 Nov 2024 17:35:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:10 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-44-seanjc@google.com>
Subject: [PATCH v3 43/57] KVM: x86: Treat MONTIOR/MWAIT as a "partially
 emulated" feature
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

Enumerate MWAIT in cpuid_func_emulated(), but only if the caller wants to
include "partially emulated" features, i.e. features that KVM kinda sorta
emulates, but with major caveats.  This will allow initializing the guest
cpu_caps based on the set of features that KVM virtualizes and/or emulates,
without needing to handle things like MONITOR/MWAIT as one-off exceptions.

Adding one-off handling for individual features is quite painful,
especially when considering future hardening.  It's very doable to verify,
at compile time, that every CPUID-based feature that KVM queries when
emulating guest behavior is actually known to KVM, e.g. to prevent KVM
bugs where KVM emulates some feature but fails to advertise support to
userspace.  In other words, any features that are special cased, i.e. not
handled generically in the CPUID framework, would also need to be special
cased for any hardening efforts that build on said framework.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 153c4378b987..0c63492f119d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1192,7 +1192,8 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	return entry;
 }
 
-static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
+static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func,
+			       bool include_partially_emulated)
 {
 	memset(entry, 0, sizeof(*entry));
 
@@ -1206,6 +1207,16 @@ static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
 		return 1;
 	case 1:
 		entry->ecx = feature_bit(MOVBE);
+		/*
+		 * KVM allows userspace to enumerate MONITOR+MWAIT support to
+		 * the guest, but the MWAIT feature flag is never advertised
+		 * to userspace because MONITOR+MWAIT aren't virtualized by
+		 * hardware, can't be faithfully emulated in software (KVM
+		 * emulates them as NOPs), and allowing the guest to execute
+		 * them natively requires enabling a per-VM capability.
+		 */
+		if (include_partially_emulated)
+			entry->ecx |= feature_bit(MWAIT);
 		return 1;
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -1223,7 +1234,7 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	if (array->nent >= array->maxnent)
 		return -E2BIG;
 
-	array->nent += cpuid_func_emulated(&array->entries[array->nent], func);
+	array->nent += cpuid_func_emulated(&array->entries[array->nent], func, false);
 	return 0;
 }
 
-- 
2.47.0.338.g60cca15819-goog


