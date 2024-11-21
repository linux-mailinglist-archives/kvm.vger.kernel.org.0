Return-Path: <kvm+bounces-32305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 049269D5321
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB8A72814D3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDD71E32BA;
	Thu, 21 Nov 2024 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uC6XDDIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954DA1E2607
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215231; cv=none; b=FEc+LJHkQjoxX4DklfdGk+113fk4oTKLIUzLxRfe78rdolRkORCC1+APfAQ+a6wBy2SuRTGuT9XAXnXmYFFnd10/eWWmhAjEp8khf+ZHemRGw8oS7KD4D6ESRCrX5qAPLCsGZLN6QqD+3BCmmeQEalHrU+Tkx8ojwu4ufqcvCoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215231; c=relaxed/simple;
	bh=qemrFZ+DR3sCl7VG4GKYwVD8L8FwjlVxsp3WJhJHwXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=njUy9Mu9Gtven9p4pyYFKSXyh8GdxMg3jcfq96oVeZRtBtHwn88LtB+PJ8lvoGBxCg0z2GttihvlZ5sRjQEXGBixSE1gwAL5YmIVVUbT2E9DqoBpPtIF19RX6uovnElurmSMSGRUIccXRM/E/1R8l+HPvCvK9lafvNj2Jer2VfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uC6XDDIa; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eeab4be015so21619667b3.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215229; x=1732820029; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sh4pMBblHn1VD2N9Y2lp4abB6oxAsUcAPAYEWiOVGrA=;
        b=uC6XDDIamI6lGnwNA6gWzfVX+QGACb4lytpRAYWk3pyND8yI3nGZ0+RV/UsoOxUdrT
         1aP2aR3KJD4xok2SZLsolRHCoGqR0d0Ne8NavIDLJ0Q0GRsSkYeI/eL6OhT1BMWXBcW5
         v7xi7ulDRvFQmZKC4qC7KQ5vx0aZaYDTG7qZApDlgJtOVrWkxRppfTmFQ3WEcnrp71Yv
         lyH77bY2Qt/006ClS1xB7SV/w51EmhXaMSv6+e3z2/oDFVd44d5uM6cIFQrWvJjcqJ9u
         YTzfHN/AQE6G/wLrmaolXadstknKakMTLYvZtQedyF+/EW+P8sGqF1rhUHap1QgeMpBw
         AqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215229; x=1732820029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sh4pMBblHn1VD2N9Y2lp4abB6oxAsUcAPAYEWiOVGrA=;
        b=f5THv4/EeFHKwuBBy25gyVpvdlPOp3pm3kvP6/bsz0/HhB13r2OLbwKjut/Re+D1rw
         FI4l85rS7Gk6s1KMTJTh1fBjxlg2mReLkiZV/hN8QMUqv/s/mIY2DZOaJv9aIdQPiFjz
         XZaDSTTWxv6tRj2urromQOXEq+DA6A88/sL/iFsIB9BBIb3CN0WFEWekv3XfQI6Ggh6z
         ZEJIKWu0nRb+dWMbETOyTEsaeMUxc1E+/EqwnAdaay+aJiU7BjvEC9JniIOMgGJ75EJ0
         9AXmIYXR11A0liRmR0J/FGcdqTHAftckXCVQLFMHqV/WwuhNbVsJfOoEa2LjsARg4imL
         G/Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWchxZEfJtfJyk+sAGazimho72vsQvrg+37G1mzNFmAxdjhQOTxmX6DNs21bcs6P5NHoKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuPFOPPjNuaKfDFPSQIAee2cnbBLdQVq5bbxop1m3PljCRiotL
	fT/mwnJBVPW73pVkrYu0KtjQvPsUuLWvOS81s+ubHaixG5DboCHFdZymwwwqR08oTef4RWmOJkm
	bZY1w1Q==
X-Google-Smtp-Source: AGHT+IEJaYc97wodeOZjWOswXnwDACandNWSXkgUJpIhOpYXATvfyTkw2S5hqwBp9Sei4x4azZY6rZTmf+9J
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a25:c581:0:b0:e30:d61e:b110 with SMTP id
 3f1490d57ef6-e38cb5fbd2fmr9499276.5.1732215228789; Thu, 21 Nov 2024 10:53:48
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:10 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-19-mizhang@google.com>
Subject: [RFC PATCH 18/22] KVM: x86: Update aperfmperf on host-initiated
 MP_STATE transitions
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

When the host modifies a vCPU's MP_STATE after the vCPU has started
running, maintain the accuracy of guest aperfmperf tracking:

1. For transitions from !HALTED to HALTED, add any accumulated
   "background" TSC ticks to the guest_mperf checkpoint before
   stopping the counter.

2. For transitions from HALTED to !HALTED, record the current TSC in
   host_tsc to begin accumulating background cycles in guest_mperf.

This ensures the guest MPERF counter properly reflects time spent in
C0 vs C1 states, even when state transitions are initiated by the host
rather than the guest.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c22bda3b1f7b..cd1f1ae86f83f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11904,6 +11904,18 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	     mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
 		goto out;
 
+	if (kvm_vcpu_has_run(vcpu) &&
+	    guest_can_use(vcpu, X86_FEATURE_APERFMPERF)) {
+		if (mp_state->mp_state == KVM_MP_STATE_HALTED &&
+		    vcpu->arch.mp_state != KVM_MP_STATE_HALTED) {
+			kvm_accumulate_background_guest_mperf(vcpu);
+			vcpu->arch.aperfmperf.loaded_while_running = false;
+		} else if (mp_state->mp_state != KVM_MP_STATE_HALTED &&
+			   vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
+			vcpu->arch.aperfmperf.host_tsc = rdtsc();
+		}
+	}
+
 	if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
 		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 		set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
-- 
2.47.0.371.ga323438b13-goog


