Return-Path: <kvm+bounces-42746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52C2A7C419
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C58147A7070
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF692505DE;
	Fri,  4 Apr 2025 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IsVNqCQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16761221F3D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795692; cv=none; b=WGNR5BIVkADxTd2At2Y/wCxqD4tvlytfD7BeRzNTSgWOAnMDexjt//+DvuoihDfmOqR0QDO7Vho2KGtVngHJTb3vdXc33J3JL2B6XqMLa3eRy7EKhZ4kREAx+0Kwoy5X4S1nr3DLjE1POH3v6Sc1ob7+BLvaBXmjk01Isx4j3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795692; c=relaxed/simple;
	bh=LM/a78fswUxarIaB9yJdchQ9AVFZwyJ7vf9uPLLFAxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LlaKd25FrQklQGf2xkCyU/aX25BiYgJjCgsgwu7ZigLImGb5XP7iSchQ51VeBGRh9sJmCB6YcCCY5iy/GpF8oVY1ovIcdjJAXgxmVYpCQmah+mTsqH8VfV3g4ACPWsSfMOKuctWbWOSDGdV81ySmpTQldnzz7Th911N61AvcksU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=fail (0-bit key) header.d=google.com header.i=@google.com header.b=IsVNqCQr reason="key not found in DNS"; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-739525d4d7bso1907968b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795690; x=1744400490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WUo/P/nbSyKSB7hDI08Ajk4szbLYpfhAgRQ1J5OUkMU=;
        b=IsVNqCQr+F3fdQUnityMBvVU2Jl2S0/RjIgEADXtzlT7I5ZvpQ3e81+BbkKJJZSMEc
         8/5i4ww2Af+xLJ2JWrryZoHNYNR+CWuZZbw5yU/9kR/cIF/xEm9tnKB5EbB/m7eOM+Zr
         t9Nbx1KR3I8D9c9a/gUJ0nvge/qq3kC3t0UR5MadRoDgwaZhDDgwBAG5rIACDRzqL5GB
         FtUA/C6LugbqUQ8Trgw/KhwQ2Vvozcro2VqHe47vecLWKfkhvMULWEdMCCBncTfDsDCQ
         wDhQ+PAbSECCAxTlRKN1ZXXqLvWf/5LCK1J74ZF7S1/K9sBFpJsOT/JDwxT+OBUOA5FN
         OXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795690; x=1744400490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUo/P/nbSyKSB7hDI08Ajk4szbLYpfhAgRQ1J5OUkMU=;
        b=wvgr5PeNPUIgCqWxqQbJRQAn9oholYle/pxEGZwLB1i3FuBCu6RQD6LjddmwtHk0Z2
         VmxUhFG+t4cA4E3JQfhNfbMLOGLEPJGTntGEbtSGJ3jFURhJcSYcfJ8kyBmVlIG81xi0
         Yol9qryirx1fOVfGEFpKupK+WvNURMArqMLzO1hX6Jkrzf2z047RLWt5hWFUbKAGZCLe
         3PpApt0BVXhp82/nN7wX2wKfd8mDFP1pCxDob0uqafySH7SjiBIUGkKF8DcVZSl/P9+z
         tm4pMrbDi2WNLGCisDIagv8kWoLe4LR7b4jTceUiNJdieB3pSw9dYFMBjSxFg2eHyW+9
         3t6g==
X-Gm-Message-State: AOJu0YxAeUiFk/iJje1UMWlJmRGN4xYKDYYGEn4V5P3oVw/ITfZBjbbq
	MnRwCqWvM0fd88nFIV1uCjpwFh+Vmi8BdHG4rM0P5f2EUpXRSctAqdFwez3cSSgYwFNstmiG1dm
	2bQ==
X-Google-Smtp-Source: AGHT+IFrffkAJKPjpzU/UB+RZgd+9eYfpIMh5YaMNutNyipzajp2Id7VaNjJc8C8Wc5drn94Lg1LW0x5Xkw=
X-Received: from pfbld6.prod.google.com ([2002:a05:6a00:4f86:b0:737:30c9:fe46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:130a:b0:725:96f2:9e63
 with SMTP id d2e1a72fcca58-739e4b7b2bdmr6930633b3a.24.1743795690483; Fri, 04
 Apr 2025 12:41:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:15 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-61-seanjc@google.com>
Subject: [PATCH 60/67] iommu/amd: WARN if KVM calls GA IRTE helpers without
 virtual APIC support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if KVM attempts to update IRTE entries when virtual APIC isn't fully
supported, as KVM should guard all such calls on IRQ posting being enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/iommu/amd/iommu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a881fad027fd..2e016b98fa1b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3793,8 +3793,10 @@ int amd_iommu_update_ga(int cpu, void *data)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	if (!ir_data->iommu)
@@ -3813,7 +3815,10 @@ int amd_iommu_activate_guest_mode(void *data, int cpu)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
@@ -3842,8 +3847,10 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct irq_cfg *cfg = ir_data->cfg;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || !entry->lo.fields_vapic.guest_mode)
+	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
+		return -EINVAL;
+
+	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
 	valid = entry->lo.fields_remap.valid;
-- 
2.49.0.504.g3bcea36a83-goog


