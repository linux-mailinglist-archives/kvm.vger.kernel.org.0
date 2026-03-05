Return-Path: <kvm+bounces-72949-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKODM27kqWl1HAEAu9opvQ
	(envelope-from <kvm+bounces-72949-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:15:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3727221811C
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A9BD30607B7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 20:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073D62D5922;
	Thu,  5 Mar 2026 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jch17xj+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4EA145B27
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772741735; cv=none; b=guuT0SQlUPwYcVvkvTgfmSqkHPJ0in9LjatNpvRcvVWNn2decJ9CWGxVaSI8gpCFHF2j0XkkjhG1eroABL6O9Ny2T4j0Ybe3cs8EfBbgVkmVuXKS7DwcjvsVORzUKq6+m6AsM0GyhhLhIvpR9En/vcdiS3LJEkYoczNGqtGFf6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772741735; c=relaxed/simple;
	bh=UNkfBWoKxhoF1oDNewD87BNjfD5wAIKwW/8SEt4F0KU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E5IJoPIew7EFDGh8dCoQAgGdeLkQho7xYtlg3o9rHhS7dBualM08DKEBC2AjLxbaQ8MiqwAYEF8LuOrqdHfhYUd9V1TWC/kj7PB+BHDe18YiWdnJ83H5kPRCYWdxWpW7tdjIDWoo/p7erIXyPoEvifanP8iDE+q6PQV27N8gUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jch17xj+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e425c261so7521578a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 12:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772741733; x=1773346533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q5GQ+iLBA7Lk6r8UZZlNI7qBsJqloLBwP6g5inHdZV0=;
        b=jch17xj+YowXAg2YA4xFUQQqHcEaiTIL3zrX6XrKIXsGaMaLSiigUJDIl5NR0U+SuD
         b7iKZkT58UbbkzdxTgHwTAeTOsDdIM7ZD/eimTYiMf3LYi81WO0C8Q/qpEKps97MHcmo
         nwsN/h3aoDlOT5/GUqpQmWCmm+cXM4smW33sqsU9gCB5pBn3aB8J7t5uAptMt/THssKW
         6RNtgXv2pDYOihAyHYYEsosBgEtGR8PKRQHGVwPeIeISk7kl5oDraNzaOnyQuAnDxWLo
         P1io4ItBli450ESVh1a7y4FmJrcX0qsjVflKmHf+Ehg42oiaidPGFByYqQRa5HvYZN6J
         3NbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772741733; x=1773346533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5GQ+iLBA7Lk6r8UZZlNI7qBsJqloLBwP6g5inHdZV0=;
        b=OAKvhol+/vGA1TGwLpXNTEiQ5XPdfVGYZC4883birS0JMdwPVzZTpI5nIsz/JSX0aC
         47zVP/B1ScDrvKam3gEoTV2F9Q2OxT/o6YO5/Cb24SGJdOrpcvJKyEJxFQ6x1wvYF+uj
         zD996L3sHctB5ieU9kXJHi5cK8wQBwZ1F6Ys6YMAyLWOSxkDlmOHubef+jtclzssyitq
         lF2/V2qsxrBMoBAAAwy1LTerE7++gHrRWRJVvS+7Hdxr8E+LisNY4zdYDYrLsxDV3AyX
         T7YCXZ4ylbABY/JXhqQCYwuO8Cu9QQyCX5aVn4wOR1PSn6M4lLZyStlJvrpjI5NyZk5O
         BDpA==
X-Forwarded-Encrypted: i=1; AJvYcCVKYiJvTkXgD/1XkWXccZywFGejKEWK0mCRt8zXn+har9gBNTDmxigMrJOPBKLatI7p/Uk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbekoZ2uCRPQbsDtDXivpYH/IXvEVpFEljalyz8bZ+GNbQD/5P
	z3aG27h0/DmY1ox9Bn3gfOr1S2G5+VH/VnwbSV3NaCfLQ6pnNDs3QocB4Kk0JNZmEaSDr5D5Mj2
	tT72esA==
X-Received: from pjwx4.prod.google.com ([2002:a17:90a:c2c4:b0:358:e87a:c86b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:518e:b0:359:9cb8:db5
 with SMTP id 98e67ed59e1d1-359a6a6f4fdmr5719092a91.26.1772741733417; Thu, 05
 Mar 2026 12:15:33 -0800 (PST)
Date: Thu, 5 Mar 2026 12:15:32 -0800
In-Reply-To: <20260207012339.2646196-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com> <20260207012339.2646196-4-jmattson@google.com>
Message-ID: <aankZK5IAdB6GmDy@google.com>
Subject: Re: [PATCH v3 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only
 eventsel at nested transitions
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 3727221811C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72949-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Jim Mattson wrote:
> Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel_hw for
> all PMCs based on the current vCPU state. This is needed because Host-Only
> and Guest-Only counters must be enabled/disabled at:
> 
>   - SVME changes: When EFER.SVME is modified, counters with Guest-Only bits
>     need their hardware enable state updated.
> 
>   - Nested transitions: When entering or leaving guest mode, Host-Only
>     counters should be disabled/enabled and Guest-Only counters should be
>     enabled/disabled accordingly.
> 
> Add a nested_transition() callback to kvm_x86_ops and call it from
> enter_guest_mode() and leave_guest_mode() to ensure the PMU state stays
> synchronized with guest mode transitions.

Blech, I'm not a fan of this kvm_x86_ops hook.  I especially don't like calling
out to vendor code from {enter,leave}_guest_mode().  The subtle dependency on
vcpu-arch.efer being up-to-date in svm_set_efer() is a little nasty too.

More importantly, I think this series is actively buggy, as I don't see anything
in amd_pmu_refresh_host_guest_eventsel_hw() that restricts it to the mediated
PMU.  And I'm pretty sure that path will bypass the PMU event filter.  And I
believe kvm_pmu_recalc_pmc_emulation() also needs to be invoked so that emulated
instructions are counted correctly.

To avoid ordering issues and bugs where event filtering and guest/host handling
clobber each other, I think we should funnel all processing through KVM_REQ_PMU,
and then do something like this:

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 14e2cbab8312..a2a9492063f7 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -227,7 +227,8 @@ static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
        vcpu->arch.hflags |= HF_GUEST_MASK;
        vcpu->stat.guest_mode = 1;
-       kvm_x86_call(nested_transition)(vcpu);
+
+       kvm_pmu_handle_nested_transition();
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -240,7 +241,8 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
        }
 
        vcpu->stat.guest_mode = 0;
-       kvm_x86_call(nested_transition)(vcpu);
+
+       kvm_pmu_handle_nested_transition();
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0925246731cb..098dae2d45b4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -244,6 +244,18 @@ static inline bool kvm_pmu_is_fastpath_emulation_allowed(struct kvm_vcpu *vcpu)
                                  X86_PMC_IDX_MAX);
 }
 
+static inline void kvm_pmu_handle_nested_transition(struct kvm_vcpu *vcpu)
+{
+       if (!kvm_vcpu_has_mediated_pmu(vcpu))
+               return;
+
+       if (vcpu_to_pmu(vcpu)->reserved_bits & AMD64_EVENTSEL_HOST_GUEST_MASK)
+               return;
+
+       atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);
+       kvm_make_request(KVM_REQ_PMU, vcpu);
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);

