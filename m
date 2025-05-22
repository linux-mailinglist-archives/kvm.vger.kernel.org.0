Return-Path: <kvm+bounces-47433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C386CAC187A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 986254A32A8
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159F02D29D8;
	Thu, 22 May 2025 23:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FO48EHXM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A54E2D1F4B
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957961; cv=none; b=V9aOVBb1j+dfLIjjEzOF9MUwFKljyfsfD97u71MlQBRVdqH2igSr+xr4ojDM+RdPniB4L3mI4+NRFzCWgCm5dBlSeeA3ao+B2Nwh4CIOmsAQICHLJwd4K05jiSmBcZdjBOWwstbd27nXsSIlWRZgUfKJlz+SHQQsVPMjmP9vpgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957961; c=relaxed/simple;
	bh=FDCJRuUBom6tgSithRuLUJxsTxJG1RjcxbgGSLyCb6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ajGise06IS3FfvKnvC/hzgkSh3/6wuboRnDJXgEixdJDW0eijifSgpgQ5ZA0lrj6SXoJ/opTHp/9C8OEwvca/ZANLjE7ibHqjhAFLv5mj743Y/HlNlY15yvurRDPq2In46EDMNm1Tm7p+epPq78DTjyhjqV5NBA5Rft56Fx+zL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FO48EHXM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e8425926eso9457271a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957958; x=1748562758; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tVNl4A6Kx8naMJGZ1E0eQITkQbAsVFllM1f24lX+kzQ=;
        b=FO48EHXM3g4ZCLKZEK3LbIF73cPjmm7e7Liu+jQ4qHBcU9RASxWUpo24FrXLalqjZo
         zNrmjloD79YSVN/3ylTp49dIRs+LCFLNOr2ctT0sR8xG6WC0EHRQE6QrV1yLul/NyJha
         3DeoBzeUuezIpkgWc/kCAZMEt6p7C1Hfxg+Om1l7uw+CrpTU+WWizv/SKvJsgXwutFsr
         58w7q7qULVR90RZFRLcKzqul4S8Rli0v4wUTm75SfNUqhKgISaRsaXGG+v8K3SD/MBbQ
         nWH48Pk5iOLXz3t13TqeOXhdd6NCgYNciT2daZq7gOjci9JB+lcAlpuHknarcHQLguu4
         wNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957958; x=1748562758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tVNl4A6Kx8naMJGZ1E0eQITkQbAsVFllM1f24lX+kzQ=;
        b=YJJ0l5DKg3ST8X9IHzTq3kS9SB2HdD84Uk//RMTquDXThVw23dFSbi3vykX8Ih9TYh
         kfRsN3k1qQZ56kgZFRUBKTWsHg8xpgIwWI1sZe+yZ6RtRHYH49RsTDI1jORQaSj8V4td
         Y0DQkKmGzMyWPpidkcLf6ptK7Fp3PCFsnSyFkQkzhD6xLi08QeGxXToCLGZBm2E+xPoI
         Foa/FGUMpjZmWEdty3HIRq5iVCmYHu1y6iH9bQcphkOKaJMuN8Xos4OO47rLxqShL3JA
         EiL0DwdnDSb7Ny7YHoVEsYeNyvUnPrpKDHF9rJk/Gb5qjEU6/fvxwQX8Bf5MsHPwNdN5
         HJDw==
X-Forwarded-Encrypted: i=1; AJvYcCVUMs+oLl/ru3P4QFvRvaypqeUzZwpAGZ5iaWD7b3xtItn6BYzUP+8TbLFDu1fg3utGV84=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDja0TVTqjvQMXuLR/y1TamNPIvkw6tUDAlSYDrNEpSPwTg3b9
	mGUBefztteLuzW2Pgedd0Mv2c6evt0s4XDPAQfDy3IYiImuXRP4Ydwx4AVYB0r3AUhnAQ7MNllJ
	omRE6vg==
X-Google-Smtp-Source: AGHT+IE81WM2WL+8EnB/6FCP5IRyDnOFUDXq+HJraLf558ghdMXYLyDo9m5RHDzKNMgflX319IgqoMhIQGU=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70f:b0:30a:2173:9f0b
 with SMTP id 98e67ed59e1d1-30e8322596bmr38028577a91.28.1747957957818; Thu, 22
 May 2025 16:52:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:12 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-3-seanjc@google.com>
Subject: [PATCH v3 02/13] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Acquire SRCU outside of irqfds.lock so that the locking is symmetrical,
and add a comment explaining why on earth KVM holds SRCU for so long.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 39e42b19d9f7..42c02c35e542 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -401,6 +401,18 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Set the irqfd routing and add it to KVM's list before registering
+	 * the irqfd with the eventfd, so that the routing information is valid
+	 * and stays valid, e.g. if there are GSI routing changes, prior to
+	 * making the irqfd visible, i.e. before it might be signaled.
+	 *
+	 * Note, holding SRCU ensures a stable read of routing information, and
+	 * also prevents irqfd_shutdown() from freeing the irqfd before it's
+	 * fully initialized.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -409,11 +421,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		goto fail;
+		goto fail_duplicate;
 	}
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
 	irqfd_update(kvm, irqfd);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -449,6 +459,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
+fail_duplicate:
+	spin_unlock_irq(&kvm->irqfds.lock);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
-- 
2.49.0.1151.ga128411c76-goog


