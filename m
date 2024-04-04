Return-Path: <kvm+bounces-13622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 817A4899219
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B131C2163B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3168213C66F;
	Thu,  4 Apr 2024 23:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DG8BMGMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E318613C66C
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273220; cv=none; b=q05cKfn8wGr4HYtBsaTSJ4LHobW/AUvv1ctBgZFUr/vNy0Or2YVX2HJDl/pZlHS4kZcldB409OOJ8bfSLcoIT9ANRcCgCbrzBf98wL+pjiZZbmhGAY9F/YWlGjV5Ms9DCLJjBIo+US6IOe8N+wAPfGk1r5y+Ez35VZ7FO7fENts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273220; c=relaxed/simple;
	bh=pApRnIApq93h9Cy3wc/wQcyJx0jTe1lHgJq0pAHLXYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WS9/arkyjTAqLd1yIWbpFgAgjy+svPymhV6QjxTAGlAgVGk7mSIqTtkLu/3axYZ5SAeghbflBZE0K7S4wPkk36AIIg8x0R2NO/a3gatKZfTTTRb4Kc0veumyBkRoqVDpUSDdkAGTsDA9R1fMdFobVn5lfhwa8G0kRPEnzr5skzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DG8BMGMQ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e0d82c529fso15084545ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 16:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712273218; x=1712878018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zQPsKi1EUNEiCqGpPgkMCiGWAGgmZ9w2do96os4E514=;
        b=DG8BMGMQccHF4O4xQYChlHgegxH7bjlIJl20dZ8AZyCxO4tpt9IH/OSSioZ2YoJ11p
         WLFky5GkiQDztJ90gFfmicL2dayBw1kU6nYg3HMt0+wInO6gChAwRAYUKAH4tMz7SMeP
         dTl/NFhNbZY3Fg4co/DTWySe6iGshNu7P9mqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712273218; x=1712878018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQPsKi1EUNEiCqGpPgkMCiGWAGgmZ9w2do96os4E514=;
        b=u4KCkeD276EGis+J3samITMS7Niqm+BSPv0Bpysdn1xHEfJUuO6vlQDZk3SfL+QIMZ
         q80Bp7VVRwX8veP1Yu15FKzaBYmtW7N9Myz7F36DkZd5DbF08frvSvZyV6SV2gQgXIgh
         4yFCmhD0W7aFlxTJa5plvBRfl8/rLMKsFhIdcCADd8es54i9+tNQM+zgvULLZMnhG5sM
         IA8yko7bcWaoWrpDx+4OirFcchVKSbpOaaV+sJkRikRRNA/40nRtLIB3nSufCR7WMDCX
         Waa6+TNjQYovVb2sbCUBJjoUUtqsGcTQQ8zeiqcv1qVvFY3KQqQzgPuG6Tqm5szDyP0o
         uZuA==
X-Gm-Message-State: AOJu0YwgBGSIDGsSbkJpDzEhbKLkwy6Gr51RCCVfna+mDldj/q82acwT
	SWUZuTlmysr8PyHsTBi47QoutiL9uaDNB/y7CyJPSHe+9ErzeR+VFV4aYfsrovfIg68ZE5OA9fQ
	=
X-Google-Smtp-Source: AGHT+IFkKVgfOxZ8vVnQF9uKDN3Rutt+fQgpbh6NmeJWh0tmsTQoVXNIwz7ux4sZUWkldxLmnFzNLA==
X-Received: by 2002:a17:902:e5c3:b0:1e2:7e04:3ab1 with SMTP id u3-20020a170902e5c300b001e27e043ab1mr5081033plf.33.1712273217954;
        Thu, 04 Apr 2024 16:26:57 -0700 (PDT)
Received: from corvallis2.c.googlers.com.com (230.174.199.35.bc.googleusercontent.com. [35.199.174.230])
        by smtp.gmail.com with ESMTPSA id y20-20020a170903011400b001d8f81ecea1sm184934plc.172.2024.04.04.16.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 16:26:57 -0700 (PDT)
From: Venkatesh Srinivas <venkateshs@chromium.org>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	venkateshs@chromium.org
Subject: [PATCH] KVM: Remove kvm_make_all_cpus_request_except
Date: Thu,  4 Apr 2024 23:26:51 +0000
Message-ID: <20240404232651.1645176-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

except argument was not used.

Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 10 +---------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9807ea98b568..5483a6af82a5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -193,8 +193,6 @@ static inline bool is_error_page(struct page *page)
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
-bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
-				      struct kvm_vcpu *except);
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1fd9cb5d037..53351febb813 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -311,8 +311,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 	return called;
 }
 
-bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
-				      struct kvm_vcpu *except)
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	struct kvm_vcpu *vcpu;
 	struct cpumask *cpus;
@@ -326,8 +325,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 	cpumask_clear(cpus);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu == except)
-			continue;
 		kvm_make_vcpu_request(vcpu, req, cpus, me);
 	}
 
@@ -336,11 +333,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 
 	return called;
 }
-
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
-{
-	return kvm_make_all_cpus_request_except(kvm, req, NULL);
-}
 EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm)
-- 
2.44.0.478.gd926399ef9-goog


