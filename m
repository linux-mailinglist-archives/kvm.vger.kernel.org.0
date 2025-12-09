Return-Path: <kvm+bounces-65608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C86CB114E
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2632030CFC1F
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9183101C4;
	Tue,  9 Dec 2025 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTA237n3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE07308F2E
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313572; cv=none; b=jkBHEaZ7iGzsRBgQ2SMBgld5N6HGh9bYGkiHOB5Y8ECRvyhlGFP+sCu2YXqOGlCMIaAoeVm5kNSsE0QYLZQoWoUzA08yhYUzJSYMDD4wdZXjfueemhzZpugGiet7BGqlbvKSveMnOpyL76REmapeCvUcHi8HPI92i1wXkeK5w8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313572; c=relaxed/simple;
	bh=L6JRHNao9Dv2st9IstObJcFX6EfxZz6LafDaZCOeTJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XDYELUyE4JVS0sWlAcTxZ0CNIBmsTgQBu8PwcgsnTYnbOMQw4PunP8XD7wDjn7+Tj5Hm0GSX8Bo2vJhFFJDIg5byBiOEsXSBerAjbI4nFcgFRp8zO4HFYHzotfZeJ0LjNPcHZfp7xrNd6oGzLdzQyOC1QPbwYmlLKFnqu+oORBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTA237n3; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-3e88de1d93aso7193460fac.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313562; x=1765918362; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zQsEiABUjsdMkMEnByRoAgIWKd7GLr6DjLwzP+aDHY=;
        b=tTA237n3Vh+t0TIlK504bUJ84TNu3JyywoJOfI6da3cEuIcPDmvEBP055LtGPDiUQ8
         sPg87QSnOrZGUAD5KqTXFD1MV/+XIws2NjpIHidBrZcuyDlxl1+sre2N5ziwwb1/1j0s
         VgOAOJwCdAjDOTXYYcBhKOyJg2dwDqlxKUxgBK/dO0JQvyLFjDg53pk2EcHxDennl1im
         X1AKM4Tq2abZFcxxHKHvGPl/fpODydG/lhq/GDqLkYg0l8qYXxOVobanLKjGkLyQDUzZ
         MRFr3hkKh3qTeFVJZo5YeSzETycwsB/7Tq4ABxzdfZq/2trtFT/PF/m3QhsdODZbyJdE
         awSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313562; x=1765918362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zQsEiABUjsdMkMEnByRoAgIWKd7GLr6DjLwzP+aDHY=;
        b=vM0kFeGHkMArowd8EygBsaMJl4SuTgZmd1B5DtNfOYn5IXYUAPMTD7MoZHBGxj+acY
         TifPC9RxB7FER4DyBf5de2skoEa05vbV+7RGswevUueFEj5QUm6DkPMhXpdwReyUIWVY
         lKH+twP+ZeNmSL3zI4+USMX4ypei7zjqoVji3pJTlgbTCf2ZZwOGVt9waHZHGVdZP2T/
         CdQ0gvhbnQ6XjAc8CGLKCoiyMeAzmSwTLnfXCv7+chVRR5uovxvve6zX59EkL+kmBipY
         va60OgdU0O4PDjpbpCCgOMMvERm0ueb9RWNkLRsHvuA4wgolEU23wSfRr1DGkQpOoxA+
         TlPA==
X-Gm-Message-State: AOJu0YzuWgCCQlq+o8f/zbNIs8bT1q+C7hupYeIUCneB9bkvTK4NQm3m
	npzYakhEtGGEM6GQuHCcotO/OMYqmlu3LK11D+zO+DNxyIkY96OhDpiL5O8Ol5gXKqaRv707PVM
	FExQV6Bofvl7BVK007aHIixhKeQ6o5rA0A5i9U8H84dPimZueAlwwvOBYhH7Qm2f+fMKob/GvCT
	U+kpyohionGIisE2x9cz8GQpO07RFaykvEbg1B6pKB8nf3C3td/DGdoP+Qsbc=
X-Google-Smtp-Source: AGHT+IFRKHeoUmjGuNFSlsmzEp/JswAlPAyHOqJKqkJs0+bQVeMX9v3ykC4h/RUbKQXV9XNTVLE12IZWXk6mEzWBCQ==
X-Received: from oahn5.prod.google.com ([2002:a05:6870:3485:b0:3ec:4657:83cc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:8208:b0:3ec:3b3e:4f38 with SMTP id 586e51a60fabf-3f5bdbe25e0mr227516fac.36.1765313562359;
 Tue, 09 Dec 2025 12:52:42 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:13 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-17-coltonlewis@google.com>
Subject: [PATCH v5 16/24] KVM: arm64: Account for partitioning in PMCR_EL0 access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Make sure reads and writes to PMCR_EL0 conform to additional
constraints imposed when the PMU is partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 1fd012f8ff4a9..48b39f096fa12 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -877,7 +877,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 70104087b6c7b..f2ae761625a66 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1360,7 +1360,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    new_n <= kvm_pmu_hpmn(vcpu))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.52.0.239.gd5f0c6e74e-goog


