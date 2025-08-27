Return-Path: <kvm+bounces-55931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C55EB38A64
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 21:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 000033AE4FF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 19:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6D12FC011;
	Wed, 27 Aug 2025 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSvNYN3N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9512ECE8C
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756323681; cv=none; b=aYiiyYyAnZSMxsyUaXdDV2/82LoPxiEcVhenExNao/OK5XEqtYCpVlVUs8oOoZWI3+0HF81rW5qJTRopKfXOIQ4i8nZaFjWubtM6N6jxz0Kag0a9K+6Ls+wmV55OO/xf7S0o2gscg1su7dlE39BX5xUuqAf5PfNNU/glKAgvemk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756323681; c=relaxed/simple;
	bh=lTJBUXa731wmAEkf8x8Aq275GNYxHtJHPWm/QJRsZcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjiJQYKoINz9Qzj377o2DfjEr+MnCiJs1AAQ4DxcgNnC7FbdKyPDDMaBMs93g3OpVTNfkbwzKOYcgyKX2N8jhNF+VUssWGCfq/2Xm6CtO1neCuZUhXWpsUcpZthQPgigKh/o8gC6TjqrMjtTQ97+o9Ri6K8+8TtZfqhOz4zwUy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSvNYN3N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-771f28ed113so179158b3a.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756323679; x=1756928479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CAjH9n8kkSU88PuzJQYl+lvrDTSiqH/ka8e0rLGYB4Y=;
        b=XSvNYN3NiHj7sEVZF3XAAW0ZkXOrTD9c+GLnwNP4+LOAp7J1KZDqNfegtCsNb5xY2v
         ERt8u0/Yet6Au4WQs1H/LiIZLDwYtI5+1dQ6ZzgNT4qFuNqCo9oHX91Tp95Us4HXejMR
         DhjHr1hVNc6KiUNC5p3GA3tmGgzZv8bQNrGt3LRoc5vzbaEYLxGLfsNIuYYYzT/cNa+2
         4BeKfoAruzWVEyIcLW8VLpkHp3DXVkRx23v27AKV+FALcvd3bpXrIcSsXqaYRFi/KdNY
         R+eOMYe+PgYeZI4Pzwl7VQwHRa7SsmukCI2o0qn9ED8j75g4ExuM0JpWo+faw+uwQK12
         SahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756323679; x=1756928479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAjH9n8kkSU88PuzJQYl+lvrDTSiqH/ka8e0rLGYB4Y=;
        b=XaN7aiT42GzY3G9wtCNbiqHIS5L267wLHXVFk48Rm4m2BAHfldLVfbfZ8mQm4t52o1
         /8PqxbuRzFcAc983DYgUjU2KIAE+pWkW94luW427BnHxfN9Pxp6/qB+CQRwiWp4fXeWl
         AeUic8uKA51WmGlCy6QdxaRIclBE8+3FgQM507UYFE6ZZ6PNGqRVgDWfid1kYdRRVQ3S
         S282X5Njh1e0RzblT0EK2gtbv9pDFIvFkpA2PvMZSrZFdgwbyv4AzbXEGWn1DIFlkqxW
         S2tHQsTBDqvRKosWu9YCofRTj1W5fassVJ5RC0/CZ54y8QKemZFnywyJ3nk1ZX3qnare
         ZJfg==
X-Gm-Message-State: AOJu0YxuJ4xE9+94WLY6Nk6hgD2GNiXTfAQUjaHQ8hkl/CNN9siRLDOp
	2gQ8p3V1Xio/DajJZv0nP29BgG1B/nM+14snPdUxUZMOtOb3TPbJbzVBpI2MAfseLxxVwCpISg8
	rvL6KKA==
X-Google-Smtp-Source: AGHT+IGn5ya0kUr/fIdsXYaCYO+ay+bA4LFPlBe/3Tzu+o9LmKU3qy0T5mYaH3gAWJMuIZiqZ0SiVacudbw=
X-Received: from pfbk11.prod.google.com ([2002:a05:6a00:b00b:b0:772:77e:bc4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1399:b0:770:5544:dc0c
 with SMTP id d2e1a72fcca58-77055544aabmr20236423b3a.32.1756323679372; Wed, 27
 Aug 2025 12:41:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Aug 2025 12:41:07 -0700
In-Reply-To: <20250827194107.4142164-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827194107.4142164-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: x86/mmu: Don't register a sigkill callback for NX
 hugepage recovery tasks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Don't register a sigkill callback with vhost_task when creating NX hugepage
recovery threads now that said callback is optional.  In addition to
removing what is effectively dead code, not registering a sigkill "handler"
also guards against improper use of __vhost_task_wake().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..ace302137533 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7677,10 +7677,6 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static void kvm_nx_huge_page_recovery_worker_kill(void *data)
-{
-}
-
 static bool kvm_nx_huge_page_recovery_worker(void *data)
 {
 	struct kvm *kvm = data;
@@ -7713,8 +7709,7 @@ static int kvm_mmu_start_lpage_recovery(struct once *once)
 	struct vhost_task *nx_thread;
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
-	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
-				      kvm_nx_huge_page_recovery_worker_kill,
+	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker, NULL,
 				      kvm, "kvm-nx-lpage-recovery");
 
 	if (IS_ERR(nx_thread))
-- 
2.51.0.268.g9569e192d0-goog


