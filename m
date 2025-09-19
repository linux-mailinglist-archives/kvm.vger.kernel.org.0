Return-Path: <kvm+bounces-58254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5BDB8B826
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C460179B16
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2063B2FC014;
	Fri, 19 Sep 2025 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOK0S79l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C185D2FB0BF
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321233; cv=none; b=TDY0V75tvMihUnrvvIO2r9oF1IBQ5NTae5r8yALHHjD5Up4gNKLO9hTB67opw1dKpg/XZI2ylD0mRZTMqsPkG6eCB7zAolPhlt8oPguq8ZrEGKCLjKZufemceW1PYw7R8heabfjU9Hg/DoQLjcFpmL5OM5L312ZpUryZxGnXqQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321233; c=relaxed/simple;
	bh=/tqPBTeDuMrFe1AL4FE5D/cKrgiWfqZL6tyxrCfO6SU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m9fnw8b55Ba7CMtE5OATsKq4FdWX8FvRu8ZBBH324gQ+0VRmnG1Qt3Qrg+y5ZyFt7Afa3DNNmehY1qF4C4iGnvMs5wx/wwJLfJ5M9HIi0NllSJgkJzvN509fkN2j6v0jhLESYTqwEdFo7nGINX1+BJtKYr5+Voyx9QNVB2QC4lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOK0S79l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244570600a1so31399525ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321231; x=1758926031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HedB0vqjCe4vRRpTggbdQsycmWfrhYSfaZmK+vmSq88=;
        b=fOK0S79l7H4WA0EbcTcovTJcXBa49hpS1Wv3uL0TCmgk9opC+S0z8AEMnaCnhFRppp
         onmPslFCJ0MLZDZ9Whpoxw8/gZ3iHL4hFEhYFKW/9pIGj/ruq10gNIYXrk24Vr+u32z0
         MRVuMlX/IKx80+nhdLmd/v5gces8fbRgZJinAXVpzzRzGtsQmYRJcklirdgh8wDH4eWn
         ViWdW+hx0OqzqGw9nmWtK6pQn4//unZNqsl02pLgB/aT4PUguupPQosgBhuAbaSUqEL1
         NdvkPTz3im3ProQD4aNTnokbiLzL53+k3Yo/zr7mTuYe5ti1tYUh8fKTM2f4nnqJ+C3u
         MqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321231; x=1758926031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HedB0vqjCe4vRRpTggbdQsycmWfrhYSfaZmK+vmSq88=;
        b=EIV751poS00ffAJtWPaVQ3BdDByg/KmSRhoFLlsoygu0S3Sf4O+3HGrRwgaYg+rC8d
         KRsreTHCn9HAU55IaQpWh/msXlVlQ9CdynVaGb/y02dWZSOfEhpLQjPq8KTxoKji49U9
         jtdxVlPY3BygHQzQZoGQ1sLcWmnyGm2aFGRzAzm7OhGQrVTJ5d9PE8zEh/+C+uedo00h
         8XL64KU9nWoMMZqEHQSpZvgAY02H0BeiGhIXWyeoQb22FZbjt7JxFeVB1zqVc5G2asTs
         ZHe3pyOVRVbeNkr2EI8shWN/f4YgfoIUFvrTilhwps68gVPyoSzyWqcuJgaWV63YtTG5
         X20w==
X-Gm-Message-State: AOJu0Yz3ux1crTsjLXa4MpMm5aHU+EUph84KT4ULumfLvxxUALZoxzu0
	gjKabR0aiKgF/JNK13OVJcB4EGqDFReIYRAv30Xgmt5ylHOseF8pGyInF8t9pKtn7QKFa4GTBWu
	PLTuxcQ==
X-Google-Smtp-Source: AGHT+IEljnIzRoy1UyE5BtCbUU4Z9ZtjJtcURZf7n7UmCN9hEURvx8fd1jTPH7oZwx5u199EJlJyB4GvKnY=
X-Received: from pjbsw8.prod.google.com ([2002:a17:90b:2c88:b0:32e:e155:ee48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec8:b0:267:99be:628e
 with SMTP id d9443c01a7336-2697c7ea3c2mr109901915ad.2.1758321231052; Fri, 19
 Sep 2025 15:33:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:33 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-27-seanjc@google.com>
Subject: [PATCH v16 26/51] KVM: x86: Disable support for Shadow Stacks if TDP
 is disabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Make TDP a hard requirement for Shadow Stacks, as there are no plans to
add Shadow Stack support to the Shadow MMU.  E.g. KVM hasn't been taught
to understand the magic Writable=0,Dirty=0 combination that is required
for Shadow Stack accesses, and so enabling Shadow Stacks when using
shadow paging will put the guest into an infinite #PF loop (KVM thinks the
shadow page tables have a valid mapping, hardware says otherwise).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 32fde9e80c28..499c86bd457e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -955,6 +955,14 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
 
+	/*
+	 * Shadow Stacks aren't implemented in the Shadow MMU.  Shadow Stack
+	 * accesses require "magic" Writable=0,Dirty=1 protection, which KVM
+	 * doesn't know how to emulate or map.
+	 */
+	if (!tdp_enabled)
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+
 	kvm_cpu_cap_init(CPUID_7_EDX,
 		F(AVX512_4VNNIW),
 		F(AVX512_4FMAPS),
-- 
2.51.0.470.ga7dc726c21-goog


