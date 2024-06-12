Return-Path: <kvm+bounces-19517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4847A905E09
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7E01285986
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600BC12C468;
	Wed, 12 Jun 2024 21:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="NhoPPUrH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671A129E64
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229273; cv=none; b=XFOHK0uIZDxD8PfWg9kE24XH5XclBgxjUpJsvntUTswinsvBsVgPdrEzwJgyGZQSzYG2FiTo8+369ok6sKYhdYFBBn0KBrXxBW0pmag1K4a88ZCuDqyYAmmPNgtVqXaE8B6n1nepzl9w+I86zoku/zdTIHv8KLdPpMiIDYF3LuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229273; c=relaxed/simple;
	bh=onOJoJjekcC/jjF8nCYd2zIlx4A4Ov94vgOAn+tbB2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rw3mOaQV+TSO2oIwLLSyJ9GCHCISDg+qfywPNxmUoQKLCWJxpEpSmOiLxqaiGInMPOVzKUu725+g5XuYR/jSDvM/oiusmkPHsNJaD1g1kIRD4f16WH1Mf45l5q7CWikVafoo8N9XlUm30vlkYwCmW9Ra1eIKV0nArf777SKFKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=NhoPPUrH; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a6ef46d25efso47556266b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718229270; x=1718834070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPO/ZwCO10YSJSUceIlXnwl+dzkbujZyp0szmagKulg=;
        b=NhoPPUrHEPaTCSFAQR2o0zsuTuFIfydPJ/+2e1f71Zz2VKyhXWHuJK2IHYwELq6WEg
         ZtWAGRbgfkwbymcVkMN9PE2HXKse9ySSRLgoMwLfKDhsN8ZY+lZgvlP1XkkKYtPIiOv0
         IUg5wTSvGeuYZGx4SfLt06hly0a5zbKRN6cj9cnxQEHk1nC6MAr/ZAIX/7LRkhFX+P8S
         ba0juyWto9LE0s52urwpmHkWCHOjikxcv9kM8NQA0v41gI8qjSs7h0y7b/qc7bZqWyU8
         7bFhk4e/6pH/U0L4AXiQZkUlXRmXOscRqragH8hDZE1CloQ5x5bwCcsoKdX2xlm/FVph
         ARUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229270; x=1718834070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPO/ZwCO10YSJSUceIlXnwl+dzkbujZyp0szmagKulg=;
        b=vmcsM8tz4h4OMFhwvjMF95OolH0APxYlrbbzEBC9UAvyauS7UzirvZlWyGoDdXMxFr
         3AAHDd5LK+0VM5YyTTPtKD2sPwhkaAa7AGDl8mMNuEtycRbL1fou2fPx38oNcM+TThKC
         kuiMSYd/jWw5quGbm6ZkqgLowwb+7z5ZP8F3gtMZ4Rze1L+2sVIRd1O59CgqyN8I+W0+
         X2hGj6pQCXf3zFItoswVtqYq8uWkdzLXZvZ+fMDpW0k4xtamcM7TETphSl+Gc2uDK67t
         KWGc7jrZAetya/N3w0AYSM9/u7SK+88uyiMmdmzYg6zDtapHlU+OMcZwBwOynW8rqBB1
         7dBA==
X-Gm-Message-State: AOJu0YwGreZWy9DPsHw5n02W5aJDU8bH2OVz3NxurOOT6DqoilLrb1S4
	WQ+gH8C0hjLTzO9TCNtVCxZkMKZ/HEvn8ii5fGcPJJwVAaySMhtmpLuejsGLuwY=
X-Google-Smtp-Source: AGHT+IF/JLGPxcW9ZEYwXXV02cm5lOsBCHUeMRewjlFjt9i+Yecm3AVXuyheUACky2Ns0KiXre7iJg==
X-Received: by 2002:a17:906:3453:b0:a6f:4ef7:85bd with SMTP id a640c23a62f3a-a6f4ef78693mr99742366b.47.1718229270251;
        Wed, 12 Jun 2024 14:54:30 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6dff0247a4sm785359966b.147.2024.06.12.14.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 14:54:29 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 3/4] KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
Date: Wed, 12 Jun 2024 23:54:14 +0200
Message-Id: <20240612215415.3450952-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240612215415.3450952-1-minipli@grsecurity.net>
References: <20240612215415.3450952-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not accept IDs which are definitely invalid by limit checking the
passed value against KVM_MAX_VCPU_IDS.

This ensures invalid values, especially on 64-bit systems, don't go
unnoticed and lead to a valid id by chance when truncated by the final
assignment.

Fixes: 73880c80aa9c ("KVM: Break dependency between vcpu index in vcpus array and vcpu_id.")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 082ac6d95a3a..8bc7b8b2dfc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7220,10 +7220,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
 		mutex_lock(&kvm->lock);
-		if (kvm->created_vcpus)
+		if (kvm->created_vcpus) {
 			r = -EBUSY;
-		else
-			kvm->arch.bsp_vcpu_id = arg;
+			goto set_boot_cpu_id_out;
+		}
+		if (arg > KVM_MAX_VCPU_IDS) {
+			r = -EINVAL;
+			goto set_boot_cpu_id_out;
+		}
+		kvm->arch.bsp_vcpu_id = arg;
+set_boot_cpu_id_out:
 		mutex_unlock(&kvm->lock);
 		break;
 #ifdef CONFIG_KVM_XEN
-- 
2.30.2


