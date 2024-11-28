Return-Path: <kvm+bounces-32693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C97539DB11B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B496163D5E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814821C7B75;
	Thu, 28 Nov 2024 01:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYU/UifD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565413AD22
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757747; cv=none; b=flrwaXEP5mumus4lmoKfLgkF587p8d+G7mkFDV59wUKcGyWFnsYqiOd4Vnian8BrKqAHYPP9LltXiYgmupATy0fb2d2/4uFHEr8G1EOZYKG2f2uFB3s2PzXereL4SHUs+zNdSjFa7S9dp3LWuboHz8EEEmzxSDsaY9kSYABuJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757747; c=relaxed/simple;
	bh=N0jpzgpDVGDVdYSAga/+/UOxB/D8WpjPpvJqspM+rEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tBI6O7hXy5x/0fQo6/PaCDmTlyuOqWHTto/exoJ3B+ADRibiMbB6vpm0PZxnCQMvIeMjwMD1fU077nPi7nG8cWA/Ve0PFBMRGmS/4/36Y1mJYBFRlMvOy+On6WEE7dsZPC+H2aKZRos8RgLEkFOiCcCt8FoaEQ1m+tGce5Tb5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYU/UifD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so360512a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757745; x=1733362545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LQdNVoeKSGGjB98KPAh0ULz3SFWlc3gHAqK/jbG3+GY=;
        b=bYU/UifDwTvGWIc9DqcScSCbI5jH+S+5vz261dSr6Y1MkBY5jSB4NZ9E52gtwhfD34
         ySI25sh1jJMk95UZal+4/Q2oJojJQJXOczToSeSQcJEsnyt2qwxeQtNWGQOZGCCD+6Zl
         gi/8bdq6qFS8/85thoNUDHcJoUuIT+UHaCHfgYbjzCsKgBOJW836peJJOdm/EshApZXl
         R3tmiA6iVJJrMhXkm4Oj/6J68SvP2H6ZkTH2Ec6T7HSHgJlfjdbypCCujsepjNTktMjd
         PIkMEeDY7AyCUpvm+5+g1FruOjMrHOyxfCvZUVASq2xH7RRqPFRU+rYRv32z0uDWWoWS
         LGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757745; x=1733362545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQdNVoeKSGGjB98KPAh0ULz3SFWlc3gHAqK/jbG3+GY=;
        b=D210y9L08QjYUonHuYyVB7nKB+Q0Ml6kRrDu0VCNBvM8wJnOlYoH/SWEdS12HDVtke
         lpx7nqQgXLZ9jtK7ooICD9wjxgCMY6d2cJ3amqO05uF2eKss2k9H1p8RM+mUl+36JmlU
         qP6l0HTW9R4ZwJr18kVzOGS5xRpDGlf0dS10YF5ZlSKkPyirHuI9INRMIdg7Vkc83JFC
         6qhI+DvBKuF9561+C+AuWy18k1gFAFTju6l/xQIHeiplX6cotjDUNUxALWyO25Cl2ZSX
         yDtvtjRm4T7l8Xrz7qVwRJXXLYnS2tM3OtcnsPSVpEXcioS2aRDZlFSaQHGzdCjzZCuf
         vsmA==
X-Gm-Message-State: AOJu0YxMKZFqR5BpgrVEy0BKCySnXMo40idoYoVEY+dSNp2G6eoLpffL
	BGplTH6q+FLIw3LI35zMGs25WcMu2HWQQv8IhcbKqeaMsvtA7n3HfDaBbFYwtlSqeURq0cEfpPt
	R1g==
X-Google-Smtp-Source: AGHT+IFlkq9MMdFSKUul4GQoN1KnM44hUUTz4mhw5LrBQTyUE/VFwuZ91Pk4S+UJWRbkromXKR6FuSHOEpY=
X-Received: from pjbsc12.prod.google.com ([2002:a17:90b:510c:b0:2ea:479a:6016])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b47:b0:2ea:49a8:917b
 with SMTP id 98e67ed59e1d1-2ee08dab307mr7739102a91.0.1732757745355; Wed, 27
 Nov 2024 17:35:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:09 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-43-seanjc@google.com>
Subject: [PATCH v3 42/57] KVM: x86: Extract code for generating per-entry
 emulated CPUID information
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

Extract the meat of __do_cpuid_func_emulated() into a separate helper,
cpuid_func_emulated(), so that cpuid_func_emulated() can be used with a
single CPUID entry.  This will allow marking emulated features as fully
supported in the guest cpu_caps without needing to hardcode the set of
emulated features in multiple locations.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 803d89577e6f..153c4378b987 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1192,14 +1192,10 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	return entry;
 }
 
-static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
+static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
 {
-	struct kvm_cpuid_entry2 *entry;
+	memset(entry, 0, sizeof(*entry));
 
-	if (array->nent >= array->maxnent)
-		return -E2BIG;
-
-	entry = &array->entries[array->nent];
 	entry->function = func;
 	entry->index = 0;
 	entry->flags = 0;
@@ -1207,23 +1203,27 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	switch (func) {
 	case 0:
 		entry->eax = 7;
-		++array->nent;
-		break;
+		return 1;
 	case 1:
 		entry->ecx = feature_bit(MOVBE);
-		++array->nent;
-		break;
+		return 1;
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		entry->eax = 0;
 		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 			entry->ecx = feature_bit(RDPID);
-		++array->nent;
-		break;
+		return 1;
 	default:
-		break;
+		return 0;
 	}
+}
 
+static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
+{
+	if (array->nent >= array->maxnent)
+		return -E2BIG;
+
+	array->nent += cpuid_func_emulated(&array->entries[array->nent], func);
 	return 0;
 }
 
-- 
2.47.0.338.g60cca15819-goog


