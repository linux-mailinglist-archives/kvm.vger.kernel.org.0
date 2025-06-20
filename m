Return-Path: <kvm+bounces-50190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E203AE2559
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7F5E189DDB9
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C5925BF0B;
	Fri, 20 Jun 2025 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gt7J+bX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AABD256C81
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457939; cv=none; b=s69KPvzk5xK6d+WdMt4tVh95t4fm1GJhdd6SVQs6NJ4YmrSHa9wKAtOFhqtjdhUolDWdfYtgfQuU6EMC/gJeirj9JjyrmHpOki3F3WmRVyPLjMQyfoY6y3jr2bfrvOBcKEU5YEt5YpB5uuc7A2emBzNWdZQHuR47jNSX5s84NSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457939; c=relaxed/simple;
	bh=y1VZ87bDMvhFxKKb8KOnkNsslQVDRlVgHyTOA2XQMHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ONMuJumqS0yg39lMT4eytj7qmEGMPSlnk4jiRbbQ0NHDUgax8rsAAtmAZzIL2p5wl27AmT3Iu4dlF0GN3kYrxZVuW87WCxJM7qpA2NHET5pXtPtu/4pHqgbNWfzvQVeb73qSWl1DoNfTvDGm228Uw5UfM+2tQqYqdeX4EgjuVXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gt7J+bX; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc6d66787so32551955ab.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457935; x=1751062735; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lCeKccnUmGK0t6piLYL2X+QAR4eGmRxuwVO46fLii9o=;
        b=0gt7J+bXZsmFNHsm/F54vSpepp6/EUdA0ClcoHg+lAPPgvxhRJgk6DvVT/M1jwGEuj
         2YiNfomAX3Y7MLDW2mndyrlxpKChvWVz6stq3XXi2qfe9smH18Rna15x+fGAjo8EWNTV
         dnEiyaZm7kBaYRR3xGRIcJd9K2zrwM2m5qWHIJ8mVQ83jqVmjZIrHb00eYBWNez0IWfa
         jx3ZmMkvdFGspLLbwPzsVw/gYEEO1Ztumzoon8c9HDTgj7qkU6e7bzB+UuU/GfC9SD7S
         3OWlSol3iC6tcZ/uD4oUE8aIQu4QFcG5GbW4yCFni1pIHyLYV9UeauWjUFZjWjycBhMn
         PgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457935; x=1751062735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lCeKccnUmGK0t6piLYL2X+QAR4eGmRxuwVO46fLii9o=;
        b=L2CjvOZcpnsKrd92EfJ2sxgCNmxTpot0HtCkUvSwy4Xom0jpSzQwfQ+5JhHUKttumD
         yYXf1ClCroNRIB1zCHr/yjUVPp42yxBsIO8JBTMy34hW8XFaHcgCScvQ2N8hYIZk0Dgr
         ou94wtW0RUVeiDR6hDZoZZtw6Jv7CFccwYCCQkzdOA1kQQGIkzu6AE8k43Msp7krQd2V
         YWKlygPWYOkLh2YdZM/ftYOA7iHBB2RM+JLrh5gF1adodpxiq8VF+j8qz/MVBLl+rxq1
         Hu29J7cPngPW3dVBWao9rj68RuulGfuw1xEeekGtlT9nKEITOTpnUf3oNLY7v9cpSjLv
         V6Gg==
X-Gm-Message-State: AOJu0YwpmbJPxRv2P5gdPvIQ9SGcOkBTFrFqF6W7pEC2GpfaRLkih46d
	fSOSy51cx9/egzY1z6MaDjuxmraTDNIjzExf0f+G22hV5MM78BNtRyZUfMEReHWIqjBjwnhZjD/
	GXpMnBvyqR9hH+o+srHJ4nwzGTtOm1xgbMRa1z08NJbUjRtECli11Di7fBhO650FOjqh4+oSnkZ
	XF495WeAtik6+4u2dup1lISaSrYZKU5VUnjBCMXNnJYNGZYiNfwt0603jz/R4=
X-Google-Smtp-Source: AGHT+IGAgAXt4VAt9nwcok51fvIV/dFkwYe009yCTofFAGBTMKz3erZRuxZTNNWRigmqT+1olC2QwZa0BzFYekCXXQ==
X-Received: from ilbdi5.prod.google.com ([2002:a05:6e02:1f85:b0:3dd:754f:1dc4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc9:b0:3dd:edef:894c with SMTP id e9e14a558f8ab-3de38cc04cfmr43152805ab.14.1750457935204;
 Fri, 20 Jun 2025 15:18:55 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:18 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-19-coltonlewis@google.com>
Subject: [PATCH v2 17/23] KVM: arm64: Account for partitioning in PMCR_EL0 access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

For some reason unknown to me, KVM allows writes to PMCR_EL0.N even
though the architecture specifies that field as RO. Make sure these
accesses conform to additional constraints imposed when the PMU is
partitioned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 90fc088ce3d3..5f0847dc7d53 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -884,7 +884,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = kvm_pmu_hpmn(vcpu);
+	u64 n = kvm_pmu_guest_num_counters(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1ea7d092ec59..b64b60e297bd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1266,7 +1266,9 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
+	    (!kvm_vcpu_pmu_is_partitioned(vcpu) ||
+	     new_n <= kvm->arch.arm_pmu->hpmn_max))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.50.0.714.g196bf9f422-goog


