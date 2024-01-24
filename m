Return-Path: <kvm+bounces-6743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1A7839DB3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 01:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05B3128AA56
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 00:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37831FAB;
	Wed, 24 Jan 2024 00:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GZ1lBDwj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D337315BB
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 00:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706056752; cv=none; b=NzWY1mFaJHLWCPRYwWjz5cDjBNkZyos30JdcUpjUJPj0sLoqXBRWn5rFjt+VHFqQwJawUtBh72dRhHJEpEPVXumwB3ZKZd0k/7CTdsxvLDOs2TS5DDa2SWGP+6Ln/rzMW9/8aU5GLjQOZocczXH0kyNnzmcbQfZ4XwhUOCrygWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706056752; c=relaxed/simple;
	bh=tQzYCqIJlGScXwtS+O6x1VCReMd49PQ5WfpZOd7WlTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j72N1rroVt4Y1UaalAjSVczx0hg4UTNDUuxJegcVqpGGr5/pRCBWd2Uv3YxeBU8mp40yZt/f8wL8SmVoreX7KsEf/6TLaB0bGdb4kpCwdefkwNqD5hBlZPx7pVKYmfjP4zXyYjG6T5wDdxy//hmCwKk0w2+VlTX00YEirBqnV7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GZ1lBDwj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso6390312276.0
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 16:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706056749; x=1706661549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YABAD9MCJqjxVx7Kdqag9uuDZvgkIWsvnk7JYS6IBNE=;
        b=GZ1lBDwj0nqnmPFAqKgkNIhLh0LNdR84u1TeMO1wMfWYlFf+pAbTasBI0Zee7z/Y6H
         Zy/9wgD/AeyXUWD12b0uh5qcZEuh0ArkuT+DiIHDU6niqpnJSL/ZzCYTy6rip2BMdfeh
         fkMlGVGq2ibwE5jk/ALtrjKEtCYMPa+Tbu7xZ/rE1NFwYdxzpNwpvM97iE6QSMev7wX0
         BXca2IclZx0Sc1VI4C1K+xxQAhxmyL3Ia/QKEreA9HwN6Bq+m/tn93J0RH1jgR/dUgZl
         ksPDxmxrvpJFB93b9EqMNMaw0QpaAgwPc7HHrZIeZdvmI05bIRUwyQtcYSuBSD6roRl0
         gd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706056749; x=1706661549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YABAD9MCJqjxVx7Kdqag9uuDZvgkIWsvnk7JYS6IBNE=;
        b=jZiRgthFARCmx4DgvhNNXQOKjKuGRBe6fS+MODO0l3gNGxCRfkkN4kvru7R8NhyZiY
         ewLilcmXzeA27W+ac8TQEsbVk3xO2NYzFurwynWhUdNS3lXR/DFpIFfC8cyq/+mooyLV
         0dy5XUmu4F5P9nJTAqC1ctqYNGiLhssHhHwKo8KG2YAgN2DQNiI44E57WZcc7OE7YdR4
         HM+ttABwmfrYhyqPqJHxLI6jooh8AT9kUIw2l7qISAdSXJwoIA5pJL/L9gXXgDZbIsNv
         he92Bu3XxOGHh6mz/QE/ZggLAZYZJj838HwWO71RCoXqLX8bBwsoooujh/ielUjPdZ/n
         Bbuw==
X-Gm-Message-State: AOJu0YyHTSnDz/QyCADZSEbOdBON5dF7/G89ojBaqgHZoNWBJDmQovjg
	1oU52GnytGVdFcxikStCQ8wimF2FsFJ8ezkV7nWWLpZ9Dl0YmWonvJlbOd3T+60EYUkTujisYSU
	BOWLfLQ==
X-Google-Smtp-Source: AGHT+IFRrOnzGaBeilrzPlccQn0RE7GRlw/GD0pLWk8bt5Fpkbea37L+DpBruV6TqtRV1lxKnS02KLCkvA/a
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:152:b0:dc2:3268:e9e7 with SMTP id
 p18-20020a056902015200b00dc23268e9e7mr1388ybh.10.1706056748886; Tue, 23 Jan
 2024 16:39:08 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Wed, 24 Jan 2024 00:38:56 +0000
In-Reply-To: <20240124003858.3954822-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240124003858.3954822-2-mizhang@google.com>
Subject: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Reset vcpu->arch.perf_capabilities to 0 if PDCM is disabled in guest cpuid.
Without this, there is an issue in live migration. In particular, to
migrate a VM with no PDCM enabled, VMM on the source is able to retrieve a
non-zero value by reading the MSR_IA32_PERF_CAPABILITIES. However, VMM on
the target is unable to set the value. This creates confusions on the user
side.

Fundamentally, it is because vcpu->arch.perf_capabilities as the cached
value of MSR_IA32_PERF_CAPABILITIES is incorrect, and there is nothing
wrong on the kvm_get_msr_common() which just reads
vcpu->arch.perf_capabilities.

Fix the issue by adding the reset code in kvm_vcpu_after_set_cpuid(), i.e.
early in VM setup time.

Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..416bee03c42a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -369,6 +369,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
+	/* Reset MSR_IA32_PERF_CAPABILITIES guest value to 0 if PDCM is off. */
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		vcpu->arch.perf_capabilities = 0;
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
-- 
2.43.0.429.g432eaa2c6b-goog


