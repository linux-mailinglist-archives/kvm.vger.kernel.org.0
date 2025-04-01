Return-Path: <kvm+bounces-42382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B786BA7811C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78C0916C271
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D119321147A;
	Tue,  1 Apr 2025 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RF37Idfk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC42E20E005
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527170; cv=none; b=laTCtOa0rDi9MnLXH+Nr8q4moU7A8/qx5oB5Ln5LBg/ge5NmEUp0a/cw2XYKIg7ZheIxdWbiYOFyXQnMKbSUohO3e0u4t5bUPjS8EeHJtq7XA7J1g+KPZ2IdGNf/rh0+KPEJSMx9yly0ULji2/qNWTkxv/qyOnsmugV5Qj+iu00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527170; c=relaxed/simple;
	bh=Rw2iroImYquTfYTUaIXKUvTb6nsAifYMwZfzyDLbF+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMo1jsbeqGmOA6fh/In6Rbkv+6Tx8xvvBEWo4VJyrwC05w6UJZcj3qaZtrVeN+9pb2TkjwyL/ZHD7+EWsS0Dn/mBrWZNZ3bpb3/XPS96I1bfdJ0oK8MmHZysQ4CoaW9CDmeeZf4l3A5kuxSW/OxcKnCSMGiM+SrGyLGZEQ6U/S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RF37Idfk; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-227d6b530d8so106540275ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527168; x=1744131968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPTaf4AvEp4o/nHIyBvUFwkL4QhKCenH5rmcz21UYa4=;
        b=RF37IdfkOi/sgDSBaq2f87zakYV9qAa8Oj1LP45UBm9/+I5En5vYD2HGzk4rPe7+sd
         SCtuhGThoJD+/Wqf9uSKyKJnUbrW8dq9v/f2a85SxoKuoqxEpHHFAiQ+34yb3vBvbisN
         D0MNeTuEgiwb3Zaka86zjYV9D77dsKk2ZtJ84cajalzY+bVxzc0WggxNOWI1uZ8v/XUa
         4x8agvMifipzXiRUh9qAgV32AC7Z4lrAc7bVB041ZU4lBPODNM8eJYk1f1wyjzTKO88o
         IOhAsTBiotmekkWEFc879lBzYtC98rwnGuoxJAyKVGGoN+e3joJu1AFJQYVVmJcWNia6
         Iy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527168; x=1744131968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPTaf4AvEp4o/nHIyBvUFwkL4QhKCenH5rmcz21UYa4=;
        b=DuL/lzw7zRw3bpGABNx5pIuDa4FZZzNdX0whbRcaR/639KoO+zEas9VTAgo2pA1EKG
         LlOfmorbySj3mjVUfYH4oG/v1cehZ+C6W9zr69EZu7g3SzxR7CUTFo6Od7U1aDCxYf/e
         s6xvWHLhif01hpq37piIyjnx9wxO4PM66LjTALcQu2KSb/BYeRHQNpUB9iOxEWjGL3cS
         e/tAFLvKDmnHXg+0fKM6hy4/MYm3OIxuefNtpkiYII/7BVr8lvefVvG78pakvtkDpfL3
         8BIl/pibahTws4fey9F1TgE+0BL390lGvkt1rasS7dugi5QncSEtO+nPxeQoz4bxhxYs
         2syw==
X-Forwarded-Encrypted: i=1; AJvYcCWe8SJjy8bJgebuoFRD2Kmap2vYFrgoKgcoUdmjov6P9lCGxohCphNHLzR4/gCKA4VveRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUGkoSQphB0MjOyQVWKjiSc54y7pGSHL1OG1nTrccYXPYRLsn6
	HZTMSGZl7bG8zJPAiCvrSh2tgAYcZN4cUTSMrns95Bei2Hzuy1Mk
X-Gm-Gg: ASbGncuQc7SeOlGl7ENV5OGq+N0CceNtMyw5YGA7qWL4DeSkDAwwlESEF6RmHDR3s+b
	dulTxyeae+imHw/HUWUX7vLJ/+xC/KiEAhT3lOExuMH4WNkn0qh5A9/3UQynm1LNlYI06eX36Xh
	FJngamtEfdR4mTTgJJ/9LQgknw2h/pFDs69Wem3kvyK+l1T6ZtBjRbyhxf15n0MLLOrYPcIjjMQ
	Nj2Vc8ugKnwgsbaNG1t6GHSGuK7kuzxmtVVqVU46P2/CZVt6eceaQLxxOI7zZBchAp2Bxxih8RV
	aU/znstn6WxZ8DbeNVHmW/nrFLYHWB4F97oJZCCx
X-Google-Smtp-Source: AGHT+IEjsBLuez7vDqzanq2HadS3lU0vRC6ZaIOd+CRj0E+wgUGCYo6tCeZNUN+1jjah0vIuS2C9pA==
X-Received: by 2002:a05:6a00:1306:b0:736:65c9:9187 with SMTP id d2e1a72fcca58-739b5ff8a4bmr5231754b3a.9.1743527167748;
        Tue, 01 Apr 2025 10:06:07 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:07 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 3/7] KVM: Notify TEE Mediator when KVM creates and destroys guests
Date: Tue,  1 Apr 2025 22:35:23 +0530
Message-ID: <20250401170527.344092-4-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TEEs supporting virtualization in the rich execution environment
would want to know about guest creation and destruction by the
hypervisor.

This change notifies the TEE mediator of these events (if its active).

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 virt/kvm/kvm_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..65f1f5075fdd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
+#include <linux/tee_mediator.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -1250,7 +1251,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 {
 	int i;
 	struct mm_struct *mm = kvm->mm;
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		(void) tee_mediator_destroy_vm(kvm);
+#endif
 	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
@@ -5407,7 +5411,10 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * care of doing kvm_put_kvm(kvm).
 	 */
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
-
+#ifdef CONFIG_TEE_MEDIATOR
+	if (tee_mediator_is_active())
+		(void) tee_mediator_create_vm(kvm);
+#endif
 	fd_install(fd, file);
 	return fd;
 
-- 
2.43.0


