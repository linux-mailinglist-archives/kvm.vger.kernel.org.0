Return-Path: <kvm+bounces-35145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA51A09F36
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B17B1188CBA5
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8DF24B24A;
	Sat, 11 Jan 2025 00:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Voj7EdZN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EF280BEC
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554835; cv=none; b=TeQYopl4V/rBbZsron4VTwoteT3LaYUJI5mXmN8g2ZnxPjzm9c6E2AxULGb8uR1gvia5+nAFp7SbuEYu1QmImIE/4WZpNVzn4gpl7rzlioyab0vYOKN29gtr2Npoh9cygexTimb7AGoQh/L48ByaxfcfbVodV/FSChY2hrfvFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554835; c=relaxed/simple;
	bh=kRQEs5EcMwZCxgmlCwNEQYT3iaJsSfh9i/u7XBtRt2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fFU6Le1u9IKBzJM+BA7ibKDn3pIaaMgMHR4xRoLk+zXmFR5LUMVmCFCKPRcla3D9XXA1uU3RkE05i2ajtySDWFUSrDXrEJw+fThIY7RZhnChR5Wo6pHupokayIaQZUepb1ybeYXCQzOVnqx5/OAvs3slP+8W/VdaTZMcQj9NSzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Voj7EdZN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163dc0f5dbso49682185ad.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554833; x=1737159633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OdVnAyDt165LR+waupi1EXnTBJ4UpDIfS7w0uoWpBks=;
        b=Voj7EdZNk9C17Ts9aIiBgSWs4X++4RnelQ7knR/vyGTky5JRlkewnVRU1Y6ki57gdc
         kGvtDIHs7laaes681IcWLZcHnKerbgnmWLAo8G7PfUcCsTa5yDF8150ykJQ7U3DbNy1h
         FwdcuJnb/csxTWuSGqoieHxPn20QdQdjbNL2XXc6ovajspLy6DJNb3R8UFD9Re7XtXCA
         7RDPYquzrNn8+lxhrJBBABGdA+AtQSgWbS78i+PfF40e/NjC/pcUJa/VXsdm3nVTEIlo
         P8hnoIR/Xm+Sk3Yg1LXuKd3IV5JCNusPVY9KxTHiYdR2GHJAbaE2DDbNTiLvwqDImgt1
         Ad8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554833; x=1737159633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OdVnAyDt165LR+waupi1EXnTBJ4UpDIfS7w0uoWpBks=;
        b=n26toyc3eOvoJP7BPDrXkcwNbC7jiMuoOyFNfantdbzA/baOkF/aosfU6TQc1+ETEi
         dwzP3Q/KJuTS3TKyT7fW6ORHG5KKOtOR+pSfSnq77GRQUWv3jR1dGVGDLworj1WpyZbj
         hiTTBjy4ndOQEvFuCsoUke3b/Vh/iZPPX73fUF1WQJAQxywmIlG3oo9FR0ptRwchOOHU
         sz0wJgRIwc0ya+6tL7t/CI/nq1w8qXbu+Wk1Bs3nx2rJjGeDaeJDCVLVGPfZjFMhAzTH
         nCyM+j1DyTIg6/ZcB9gn5EUBgflULZWduTC6uXiBTGVEjB+WeHoRCbJ4vPRtDzotWh8q
         JB4w==
X-Gm-Message-State: AOJu0YyHUJ6vM/JYjO6U/5KJQV2DA77DtmXiykFMG3MtZDlCOzV45KFt
	cWc1aMejvHS6Qm57DCmG2xp//VqTfHAo3Idi0+7ntHm4CW/lPCcGxtKWSuruuxQbTkJWqm5UjEd
	RJQ==
X-Google-Smtp-Source: AGHT+IH+/qlBvGc3CjvrIEEaolrvw2YpHtzofLqwTRvUtZ1gocbkP6ns6eR/fLbBFKKAUO79Mci9eOI/HTQ=
X-Received: from pfgu31.prod.google.com ([2002:a05:6a00:99f:b0:725:ceac:b481])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928c:b0:727:3935:dc83
 with SMTP id d2e1a72fcca58-72d21fb1e07mr17528652b3a.10.1736554832973; Fri, 10
 Jan 2025 16:20:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:22 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-6-seanjc@google.com>
Subject: [PATCH v2 5/5] KVM: Disallow all flags for KVM-internal memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Disallow all flags for KVM-internal memslots as all existing flags require
some amount of userspace interaction to have any meaning.  In addition to
guarding against KVM goofs, explicitly disallowing dirty logging of KVM-
internal memslots will (hopefully) allow exempting KVM-internal memslots
from the KVM_MEM_MAX_NR_PAGES limit, which appears to exist purely because
the dirty bitmap operations use a 32-bit index.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ecd4a66b22f3..a8a84bf450f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2057,6 +2057,9 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(mem->flags))
+		return -EINVAL;
+
 	return kvm_set_memory_region(kvm, mem);
 }
 EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
-- 
2.47.1.613.gc27f4b7a9f-goog


