Return-Path: <kvm+bounces-32302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 896109D5318
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E6D828004C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675461E22FB;
	Thu, 21 Nov 2024 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oCmsRzS5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A481E0E0D
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215226; cv=none; b=aH/erC2brYVVvOZ355KjhjmxWyA2iT/yasEh5dzJ1fERmu8sReW4VxGr/OLd2g/8sJjbXpFdnn5yqMWnqDFKuKzkZkh3+BSEVOcEjKTYUzBYHWdMVCbqe1vINn4m82JSxl9TzkPXrNSy33tPwagqMUKiD9zsZrM3wAImRExcyF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215226; c=relaxed/simple;
	bh=E9JI3Pd2om4q8RKGN7/yj9E3VkNXyoDn/zNLNHrykuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TuUc1YAha589eBipo+wSOvxYGfFX1MUNgkUNe1rn9k32Z5tIl6p5BjfHeuwEFIGKfXKyOmrW3aUdJcPICk7wAzttgT/MIUZ2IvyZqZrfxYjS9ETwaMGshsfT73CEnuIfbFHcOhMrl0PJRVHYJ+l+IAmHlR5v7QhCrgDuNrbQ4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oCmsRzS5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72459f94af7so1370982b3a.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215224; x=1732820024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SnSGQmraT80AADBF0uMReh/30q4TRUP6V5ySJUvAAIk=;
        b=oCmsRzS5dt2UE7gkJk1GB7BUosxs5Hyb/g1ZGI4fCoWSqXPokVndRZVLWWERDKa9ru
         +l2DR0IllkhPdrvH/xS08qHJZjIE68yE0jpT/j1zt2araBGF3O4mpteRVMkUWJBE68yU
         /aWkmvhUykH0AdcOjCnGJYLSyYU2vWAAtazmqVqr6NI4r8gCZev7LkmHupXuSZsWSH0P
         EopJtRgVuha2OgmFLGYwOfEfU0QWygQ7S02evEL+iMkRvLqFnwLrRORCRa1ZaYkZNlp1
         pMzCWbcLq5d3LWGwu1sZDt0SfsQJQS9TqQFnUiMzZyw/taj3AOkqGxkhyN1bXADHqmF/
         N8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215224; x=1732820024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SnSGQmraT80AADBF0uMReh/30q4TRUP6V5ySJUvAAIk=;
        b=aCVlZtsPlcAvvGuOWZonCACpCGEHwd4pBNMrnZNYaoLLQ4Jfvm5rz8NdSkpF2jdbJh
         /jCTbMZs+4awtcvI5y841y0MseV6+meOD3KaZBkXRSVQBdqBkbup0K0V2Jzyva1Na8he
         FFLtjAlCaj06z/8OVJkABkoFrb8MusM+k3SbE8wnGAcrtosIOL62X7s7FK7VYkmBCWS3
         +2UX+JO+R8DcOfB5O+hF/NKAN5f18DeyO91z62NYYWa1pOvcgp8kwVPSgaLl1sxc1QKH
         xjXa33+CFPmz39Ix++Q31JuM1FsUfBtWqp7jeNqjUmxo5KEmYwotHG6xtQK7a+axaTnK
         AMbg==
X-Forwarded-Encrypted: i=1; AJvYcCUKyyaA4xmdg6tWEQwLzeo83bstuslbXVlJqCjPmfLVmt6R4QbvJ/VW+aHiY6DaTs/ekrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM6bkJey/bePkftW/mNlMSwETEPrz52qXZCUJWPHJUDsE+tpfh
	DdNC2jUHYPSK3DA8hLOICainXcflmJ3fG4Y9fsJr4SnVQI6U961f+zvACzAHVURGo8qavd1EpPE
	dJk3wJA==
X-Google-Smtp-Source: AGHT+IGyVXzczMNxhGjYz9B0YSQ0wD+pGCEGi8sb3RmGy5Whzw9pkoB0H3zOHOP/5JzV1UzbqMu+KUIB6p/E
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:d4cf:b0:212:6061:251c with SMTP id
 d9443c01a7336-2129f2717c3mr535ad.7.1732215224004; Thu, 21 Nov 2024 10:53:44
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:07 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-16-mizhang@google.com>
Subject: [RFC PATCH 15/22] KVM: x86: Restore host IA32_[AM]PERF on userspace return
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

Add support for restoring host IA32_APERF and IA32_MPERF values when
returning to userspace. While not strictly necessary since reads of
/dev/cpu/*/msr now reconstruct host values, restoring the host values
maintains cleaner system state.

Leverage KVM's existing user return notifier infrastructure but add a
separate flag since these MSRs require dynamic value restoration
rather than static value restoration. Restoration is only performed
when guest values have been loaded into the hardware MSRs.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6df8f21b83eb1..ad5351673362c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -207,6 +207,7 @@ module_param(mitigate_smt_rsb, bool, 0444);
 struct kvm_user_return_msrs {
 	struct user_return_notifier urn;
 	bool registered;
+	bool restore_aperfmperf;
 	struct kvm_user_return_msr_values {
 		u64 host;
 		u64 curr;
@@ -571,6 +572,11 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
 	 */
 	local_irq_save(flags);
+	if (msrs->restore_aperfmperf) {
+		restore_host_aperf();
+		restore_host_mperf();
+		msrs->restore_aperfmperf = false;
+	}
 	if (msrs->registered) {
 		msrs->registered = false;
 		user_return_notifier_unregister(urn);
@@ -5003,6 +5009,7 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 static void kvm_load_guest_aperfmperf(struct kvm_vcpu *vcpu, bool update_mperf)
 {
+	struct kvm_user_return_msrs *msrs;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -5011,6 +5018,9 @@ static void kvm_load_guest_aperfmperf(struct kvm_vcpu *vcpu, bool update_mperf)
 	set_guest_aperf(vcpu->arch.aperfmperf.guest_aperf);
 	set_guest_mperf(vcpu->arch.aperfmperf.guest_mperf);
 	vcpu->arch.aperfmperf.loaded_while_running = true;
+	msrs = this_cpu_ptr(user_return_msrs);
+	kvm_user_return_notifier_register(msrs);
+	msrs->restore_aperfmperf = true;
 	local_irq_restore(flags);
 }
 
-- 
2.47.0.371.ga323438b13-goog


