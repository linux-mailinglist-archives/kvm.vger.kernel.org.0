Return-Path: <kvm+bounces-42711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5E3A7C44B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C70F81B62A10
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C4B221576;
	Fri,  4 Apr 2025 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2npXXXri"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A7E22A80D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795632; cv=none; b=SoL+w7e2++a6ZSifqzFloSRRcMoErJmZC2wUvtvO9wviZK2T6zwat8OCGFJuQ7rojv7tyDOuoY0mdcJiOflVXhL4TxW4QcWgZdU6j3NGa54aEvrzyZ9Qoq9Egtg/GB5nUyYpp6Nbj7WG5vKRSdiW6RK1F6sCNy5a8BSoVvu9EUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795632; c=relaxed/simple;
	bh=GcrLyi9xBIguGpiJMp1JCAHPfFvSGIO53FCtS2La3bs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cHC3nqomU6Y66Sf4x/6JoKELNGYw/vq0Jmo6+HHR6NaLyHovtzhFda9l3rFSkaTUWfemjed5/tGBZhMS7WznWXc28KdPyMqCPCD5+ESXxH9c6Ei+StkCPTUYIVb13B9o83ylkAjTP/tzr2W0fC1HYjp1TthQKpv+4ru3iSUa+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2npXXXri; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7398d70abbfso3440142b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795630; x=1744400430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jTJa+0GMh1FOB5V2QWRVxqPwy6X90M/TcdXJcK5fQGI=;
        b=2npXXXriy13TgtYdd+uu8SmyQNRvbfZAncgrfct1dygmRAAvZ1xLEsrZReYpYDk1Fj
         /MDxfX/KX+n6Pfya2UFpE+V413pM1Gyq0Z6u4PeRXDDVKZcGvF4JFbkgk3toBGKtGCzF
         dej/+5VkXUYLbiTyALOfzs7uCATCWubEdloYuFDP7RcQ96hvfXch1T4QG25D88IxqME0
         iGBrY/4Y7Y7/7Hsn1bwAfbXjjrZ/YD8vcLjdRQLqj+8bWU/B73mSXcOQrigYjvu2MPA7
         z3hxXh4nzPKFWFH8DLMYu0VcXxUmK/8R3gM0ZFioJErxH4icLPBcw3bR6UMv/SUfbgci
         7hpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795630; x=1744400430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTJa+0GMh1FOB5V2QWRVxqPwy6X90M/TcdXJcK5fQGI=;
        b=JZvcmEozU/tlVDss3F4wKnknAFK/V1VzWi6u+n+tX/akcavsl6nO4sYCzrW0heUr87
         MzkK3rj+Se9GL5nzMNK92KKv9HWwm9BKo8d2/qm6nSXUWYWEV4G0OmeJZXEjcOTXsymV
         ejh0mYLej/5VfM5O/rwtQBhVj7olriCaYQUvc1eQnziVGWTB1io5a1autz8LX+OV72fk
         EjylbHj+ad/Q65mFsUv8q3IEEBgzxKtR2DHOJlKQpWVqeAkLEwtI4vRRfuUYiDHbYNg9
         +gXTjWce5PeFVGv3fi2R0dBkoOi45crzr3OI5j3cHw27/3FGwz5I033VZC29lFLN5YJG
         fZjA==
X-Gm-Message-State: AOJu0YxbBm5IkYw81Mo/YrGzLJOKUj6yhysHNhQa/PmJIKTlhxGZvGuY
	rTbNj6Zw4YIJ/+tZ1jOQcIC/UWXslquhcWotc46440MmEWfaFPldHOvnTp/e/LnE0dbcECzxkbz
	JFw==
X-Google-Smtp-Source: AGHT+IGhg+PLOqwTVlNOH/ZHSestonJxLIS9XPyg7d4ccwd3Cs3DaoNuv6SgS+NEw0wff6EG1vq5naWWQyE=
X-Received: from pfxa29.prod.google.com ([2002:a05:6a00:1d1d:b0:736:a983:dc43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888c:0:b0:736:4644:86ee
 with SMTP id d2e1a72fcca58-73b6aa72dedmr737441b3a.14.1743795630419; Fri, 04
 Apr 2025 12:40:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:40 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-26-seanjc@google.com>
Subject: [PATCH 25/67] iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_data.pi_desc_addr instead of amd_iommu_pi_data.base to get the
GA root pointer.  KVM is the only source of amd_iommu_pi_data.base, and
KVM's one and only path for writing amd_iommu_pi_data.base computes the
exact same value for vcpu_data.pi_desc_addr and amd_iommu_pi_data.base,
and fills amd_iommu_pi_data.base if and only if vcpu_data.pi_desc_addr is
valid, i.e. amd_iommu_pi_data.base is fully redundant.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 7 +++++--
 drivers/iommu/amd/iommu.c | 2 +-
 include/linux/amd-iommu.h | 1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 60e6e82fe41f..9024b9fbca53 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -902,8 +902,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 			enable_remapped_mode = false;
 
-			/* Try to enable guest_mode in IRTE */
-			pi.base = avic_get_backing_page_address(svm);
+			/*
+			 * Try to enable guest_mode in IRTE.  Note, the address
+			 * of the vCPU's AVIC backing page is passed to the
+			 * IOMMU via vcpu_info->pi_desc_addr.
+			 */
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4f69a37cf143..635774642b89 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3860,7 +3860,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 
 	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
 	if (pi_data->is_guest_mode) {
-		ir_data->ga_root_ptr = (pi_data->base >> 12);
+		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
 		ir_data->ga_vector = vcpu_pi_info->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
 		ret = amd_iommu_activate_guest_mode(ir_data);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 062fbd4c9b77..4f433ef39188 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -20,7 +20,6 @@ struct amd_iommu;
 struct amd_iommu_pi_data {
 	u32 ga_tag;
 	u32 prev_ga_tag;
-	u64 base;
 	bool is_guest_mode;
 	struct vcpu_data *vcpu_data;
 	void *ir_data;
-- 
2.49.0.504.g3bcea36a83-goog


