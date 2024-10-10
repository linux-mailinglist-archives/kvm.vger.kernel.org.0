Return-Path: <kvm+bounces-28404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6025998171
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1153A1C261BD
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AB11C9B70;
	Thu, 10 Oct 2024 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vvToz+XL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946C1C8FBD
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550804; cv=none; b=goXC4OD93ZWkdc7/Mdc689UIy1/Cs44DVHdbUckET8Nt5qHyMeMnVeHsCJWRW/n7TM4uWPqj2v0ZB93iKCwdovPUHZIlejUEuOM3Q16e+oM8ZUWZzAItFoPl6Kzv9Um6xAMSxPrpY5LDsfgHfMc9vcctbI1vJJ6dGfGAEEqcdGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550804; c=relaxed/simple;
	bh=rWEgzpXZhYi9ydWJUmAbpEPiQxbIlQmYae02y98HGc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E0ljND48IFXYEtlcebAQE231QfzevPneyYkXrYzhZVn3ie1cn4VmdCnWj8PP4WpYl+dc2ZPbsxa1AHT9H5RlV6z1RoLfrnQb6LPaq/Ll7+Yof39u4LiB3Igk6ENMHs/8VsRVLcY8VQe06iRygG8aF+xZFulNiNzLWdj7TxP1yso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vvToz+XL; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso1001905276.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 02:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550802; x=1729155602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vRqRt9/OdUuC94QGlx1b3LLfUnzhlvtZvk9uJQuMY0s=;
        b=vvToz+XLxU4qQ2xNs4TzBZvDr7wvQItOmn/yvLr1BG5RTgEmsdQhI50eFOD/YMDT5h
         DmQqv1TUrklXG/OpYEHCu83pghQO1p1b01aXx2JvG//Z3STT+aE1sN/+l7Q/qe7PyDqt
         +tPivGY5NbrwhDTjr/h6AvSEbI3Rsq5jmMD0LlTVap3pGYJJU0zh3I+RvIFfJ23BD+fF
         DK0N3SrwooBIPeZlzOLoIhdPC6LVbCxcl4d5msMjaX1A5A4MwuK7yo4EZlWmemA/mWcv
         o0QmQhP/c1hXeQrI+KCsgzPM/bNt+7ZCjU2r+GZS+7tBc02T4WArhZfurXPlXqfhCo9F
         M9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550802; x=1729155602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRqRt9/OdUuC94QGlx1b3LLfUnzhlvtZvk9uJQuMY0s=;
        b=G30ALNbhhJiUOylFRgeTuu7JOYbmNMNU/TR0P4uuCiX1itm+KGZGFeSMykiBf23GHT
         rNObh3atbscR4kTatY0sUSkGtVO0XwOXY+h7pj8yNXsUooBUf/2fT+dZbF007j91Z6HI
         GUl38/Xv31io8pgkROA3FFpwVeWC1OjYtqObgZt+UjsZzmAI0NAmzMLAUJv8Z2YLlqAP
         GRe0RQiNNnAsF5/qMnR+aJLzZM4wj2+Id3G1ZNLRnJJonejrXgGaIzhqeSPfUXDhfOzS
         x79tZCJqKv1uSxbLEMQMqfWRSPPWDi6IALowP0F9un4JdeoDx+YwtzzezIHctS5Kquu1
         m+tQ==
X-Gm-Message-State: AOJu0YwCHYd0QVuIJs7g0waA9kxcUbiTga7NlMnUigfHHUWptSZi/et/
	rTMATPulfpGkzyh9ksROtEh5e5KpvOtY/gJDCj9C5Z6rQgNXD7tRpPHiYulCQf1uyeNebfrtrB/
	qHL0kTIqnANCgIK5/ee+Pe/zCM1qdwVDk+hROmYf2rERwy+wz8oTgLSfEmpd8rf0f7lBR/MUkvl
	gRP+rllyEbOOPRtwghP4FUfOQ=
X-Google-Smtp-Source: AGHT+IHKOC7WKTbH/ijVUTH38hxdU+Ou0RoKl5cARtWTF5vqoihO6BtV+q30wvio57rQ24Dl8KyceyokuA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1812:b0:e24:9f58:dd17 with SMTP id
 3f1490d57ef6-e28fe32f042mr55663276.1.1728550800731; Thu, 10 Oct 2024 02:00:00
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:30 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-12-tabba@google.com>
Subject: [PATCH v3 11/11] KVM: arm64: Enable guest_memfd private memory when
 pKVM is enabled
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_has_private_mem() in arm64 when pKVM is
enabled, and make it dependent on the configuration option.

Also, now that the infrastructure is in place for arm64 to
support guest private memory, enable it in the arm64 kernel
configuration.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/Kconfig            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94cff508874b..eec32e537097 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1496,4 +1496,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(system_supports_fpmr() &&			\
 	 kvm_has_feat((k), ID_AA64PFR2_EL1, FPMR, IMP))
 
+#define kvm_arch_has_private_mem(kvm)					\
+	(IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..fe3451f244b5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog


