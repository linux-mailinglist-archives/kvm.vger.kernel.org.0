Return-Path: <kvm+bounces-7176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E94283DE6F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B18A928410F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907BF1DA22;
	Fri, 26 Jan 2024 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMo5XXVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7604C1D53E;
	Fri, 26 Jan 2024 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706285847; cv=none; b=TVXFVkAmSoAKley3bTdyEdcE41oEO7WKsIaHR/nYyNfzYwPJlNS1E5zEz3gcLoSQc2Zh34qMY9RNiM+2dRJWQVczNdE9WnzMDqPOB/cNESF++4zYiswAk0FrxPtICeOZFihgzNHeyHvSVRejvEIFfp/qttRZUtdcnV8SnGlYOYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706285847; c=relaxed/simple;
	bh=DYWVrLkbvnVV9kxczQSiMqM4FDXcGI57c3LQ06PvT+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CGT4o1xn0E9p3kFe2sVzdYVtdQ5pwmx14Mq5uhoHH6pKsCcPvc5YnYw4O5mp7tv7tiQuWZWVZg5g/nTmuQPYyHwbavWn9zoOhCs5yOvFi17RVh3klMjKbQ82bhBml8WXFk6v05E9uMctOQ/l5vP7Z1Z6wnBuKeD1SEp+YTdrdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMo5XXVV; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29036dc3a63so319768a91.3;
        Fri, 26 Jan 2024 08:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706285846; x=1706890646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IH0Z6gqEjq9Etqgb5EuNK3/R5ZZnLBR/umD5N+ZaEUM=;
        b=lMo5XXVVzcm6tZg3nXslkb+mw2cq051wDBQ+XRSuI8vy6kg0OzVtCpO5+IOuR5Fp1C
         BdwQCR8bGl7NHeboRGoKBskMk+UzoQE9sEjNQZxKk1yxL7uit9HqmlD8k6efu6JqNRhA
         rUcv5HGfmxH9dQZhWmRrW3WP05xrMZV2f3H/dLi7oL6oPq2Vq14HLDNzs1bvCzekSrNn
         Kn0RTA3Sp50ARHW93GlFU8DLGFgZrDj8Ih0JWn9vHAem9Kn7A8Rsb25qmYMbK/c0VX7L
         BXp92GGb9S693IBQ9nq9/ycRcWx2nSpBN7nd/Q4WMPMCEOz1hWNJB7Q533uAttFQ195D
         rz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706285846; x=1706890646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IH0Z6gqEjq9Etqgb5EuNK3/R5ZZnLBR/umD5N+ZaEUM=;
        b=GEj1u5Ajh2EICJp8HCYaHik2UlgPo+Y82D7QifGhsa/cXo+s0I7yD3xO6Pl6gS7E/p
         IVx5dAeIJGTiwKsdlHEZsHEAsV4aSd1DNlicVlk7wkepg4GnYVld48709avM2hyxgbH/
         tW7EHBvT4bznC/rqKvaw3D76Owu9UOSSYhAe441gr41P2F3QJdRA4aOUOeN0T14aDuJ0
         9fhNU/+5p+s/JE/rFdjRxw7fe68c3sbVW9VZ2RYZf1xs6AbwCyesv8tuEtf8S16BZzSo
         m03BAOFZxzGJ+SXHALMLaVDUVyZzprEpg8AvbAqMSNtSmvdfrmcg5IyQyXw+V3opOEIT
         y1+Q==
X-Gm-Message-State: AOJu0YyiyqvhOS31pzxeMnWGH/nKB1yj6io4gmT8uOnQ1nLtP5NM5kij
	wAWh82B4eSuK6t9+mwLdfQni7SQC7pd3XLMV9qlSNG/MY0Ur2+8h
X-Google-Smtp-Source: AGHT+IFg2reFZ61M4UuBoF52IdIYH7ZP+oGCvisAptiOGkJhoHxr/m/SK2qnztDSC2/etm5B9DcnGw==
X-Received: by 2002:a17:90a:d14f:b0:28f:fe38:aa59 with SMTP id t15-20020a17090ad14f00b0028ffe38aa59mr123012pjw.24.1706285845631;
        Fri, 26 Jan 2024 08:17:25 -0800 (PST)
Received: from wuhaoyu-Nitro-AN515-57.lan ([125.41.201.75])
        by smtp.gmail.com with ESMTPSA id px12-20020a17090b270c00b0028c8a2a9c73sm1346096pjb.25.2024.01.26.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jan 2024 08:17:09 -0800 (PST)
From: Haoyu Wu <haoyuwu254@gmail.com>
To: seanjc@google.com
Cc: pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zheyuma97@gmail.com,
	Haoyu Wu <haoyuwu254@gmail.com>
Subject: [PATCH] KVM: Fix LDR inconsistency warning caused by APIC_ID format error
Date: Sat, 27 Jan 2024 00:16:33 +0800
Message-Id: <20240126161633.62529-1-haoyuwu254@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Syzkaller detected a warning in the kvm_recalculate_logical_map()
function. This function employs VCPU_ID as the current x2APIC_ID
following the apic_x2apic_mode() check. However, the LDR value,
as computed using the current x2APIC_ID,  fails to align with the LDR
value that is actually set.

Syzkaller scenario:
1) Set up VCPU's
2) Set the APIC_BASE to 0xd00
3) Set the APIC status for a specific state

The issue arises within kvm_apic_state_fixup, a function responsible
for adjusting and correcting the APIC state. Initially, it verifies
whether the current vcpu operates in x2APIC mode by examining the
vcpu's mode. Subsequently, the function evaluates
vcpu->kvm->arch.x2apic_format to ascertain if the preceding kvm version
supports x2APIC mode. In cases where kvm is compatible with x2APIC mode,
the function compares APIC_ID and VCPU_ID for equality. If they are not
equal, it processes APIC_ID according to the set value. The error
manifests when vcpu->kvm->arch.x2apic_format is false; under these
circumstances, kvm_apic_state_fixup converts APIC_ID to the xAPIC format
and invokes kvm_apic_calc_x2apic_ldr to compute the LDR. This leads to by
passing consistency checks between VCPU_ID and APIC_ID and results in
calling incorrect functions for LDR calculation.

Obviously, the crux of the issue hinges on the transition of the APIC
state and the associated operations for transitioning APIC_ID. In the
current kernel design, APIC_ID defaults to VCPU_ID in x2APIC mode, a
specification not required in xAPIC mode. kvm_apic_state_fixup initiates
by assessing the current status of both VCPU and KVM to identify their
respective APIC modes. However, subsequent evaluations focus solely on
the APIC mode of VCPU. To address this, a feasible minor modification
involves advancing the comparison between APIC_ID and VCPU_ID,
positioning it prior to the evaluation of vcpu→kvm→arch.x2apic_format.

Signed-off-by: Haoyu Wu <haoyuwu254@gmail.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2..16c97d57d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2933,16 +2933,16 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
 		u64 icr;
 
-		if (vcpu->kvm->arch.x2apic_format) {
-			if (*id != vcpu->vcpu_id)
-				return -EINVAL;
-		} else {
+		if (*id != vcpu->vcpu_id)
+			return -EINVAL;
+		if (!vcpu->kvm->arch.x2apic_format) {
 			if (set)
 				*id >>= 24;
 			else
 				*id <<= 24;
 		}
 
+
 		/*
 		 * In x2APIC mode, the LDR is fixed and based on the id.  And
 		 * ICR is internally a single 64-bit register, but needs to be
-- 
2.34.1


