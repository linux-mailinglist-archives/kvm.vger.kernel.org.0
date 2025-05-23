Return-Path: <kvm+bounces-47495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06EE0AC196C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95A57BB3D2
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E9721C170;
	Fri, 23 May 2025 01:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l3RnDaJ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3325D297B7D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962088; cv=none; b=U4/N2+wifXKUSorxVeRYeVbkz+Zxxl7721wqLpiUdOsRjxZK/cyaiguKiOiyATn4M3WCS1X5Dr+0JDBfUnnxUTMOXJoVaaGJDT9M5PgG1LUMMlh4HYfmtMv/ePGVPFYW8HijlQXjgXjrAB/sBfhygq3FLS23A5rb9c0C5Svdjsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962088; c=relaxed/simple;
	bh=55qjTgWoCAqQ0qlezLcudUP6UhJvdAn22WKHfJ6neN0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xvur8C7c+zF7H4JzexPUFruc2tCVCUGYE6dM4yqB5Zx1D4Zvh4sgD4iffJFZKs8CoVF5OMhHiGT4r4kpfcMvrl1x0WLNrvIM9nEFCkVb7gpUXfLxI4K8UHgGI/H2WO09WZTV3r1PJw9WSY9zObltifLrvd+Dl+sOSk0ocv9tz5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l3RnDaJ0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115fb801bcso9189163a12.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962085; x=1748566885; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gUhbzbIFz6N1ly0iEWpzNSdv8WcFPzr+G6Brn0aKnfs=;
        b=l3RnDaJ0U2CmZ3InJFdVHa45tJlR4YQJ7eBCdlgD070cHOGKmez8nSxSJ42Qtwmuen
         0wvJzzCVqMrAE8dbXZX8P2/oZuKwXAWtpxz1xxDCuyD8kPDqNwAM0m9f36RnlVR3Zp5X
         VAf6rIn3BQ7ImLioXMTrxpctxlNH43SLcyBzIA8ZFkdnjvfyRAf1wXoT3oR12MsOD16x
         ro2nPt4e8JnC/L848gkO4YhjVkuoTdy4sWrPi9HJ1uSRj2ekCaiDQxExDiFDN5+k+pOD
         4N4YxEgoT/cGjVsAiJV/TbN6sGQ4KJDEbvHqJW271KHBzcN3FHP6/59wdrBw+y9i1g0/
         jxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962085; x=1748566885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUhbzbIFz6N1ly0iEWpzNSdv8WcFPzr+G6Brn0aKnfs=;
        b=Fzh1E9vkzP8G+FoSgeX7WWwT6+dqZJ4rkRX9hQzZOFlWtMv/G0byePNF3zGwxIjVbb
         wSpUq+9l0Y7ANeZPMUIzyxCxATl4ZY9lPu+6LSJD2fUYvVtkwPH7AVsVncbrbGnJFGJQ
         L931deGQeXf4UROoyEZU+TfGUdFdPMy0AnIkD1sfZNrX70mvv0ovFK1/kSQ0f1AEjQjH
         ct87qU7VC/FMtyKcyC3Y0y3eiYt8NYvQ5EzF2fNitY0PqPpbVWdS7B3gLZ0qaYXfCD83
         Qm7y/wurMv9g9ALGBIsoel4iZZsjcFSy7+36ClAk+aRCzq4QODk5tZS5EfZf8IrTvmgu
         zFng==
X-Gm-Message-State: AOJu0Yw452qqKYsno87Xe3C7DzCPxBc6QByUpGY6+B3gIwmqnxE6xr6Y
	q4dRgI/wm0AkBO2qdxhQGErCPAiwr4UioDzxz6btxicmefjuwYe9lKepVxB5+8PtXUtWyconkWY
	gaHwoYg==
X-Google-Smtp-Source: AGHT+IFmNcRCVGsHwu2ASi0oy2rdhg/Fb0rUQuE9H39VclrV/Td0/+Bcwnto5U4Ohf9/HGIiubwzMKlglKw=
X-Received: from pjbnb5.prod.google.com ([2002:a17:90b:35c5:b0:30a:8ffa:9154])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17d0:b0:2ff:53ad:a0ec
 with SMTP id 98e67ed59e1d1-30e7d57f38bmr34769259a91.21.1747962084260; Thu, 22
 May 2025 18:01:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:49 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-45-seanjc@google.com>
Subject: [PATCH v2 44/59] KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if (de)activating "guest mode" for an IRTE entry fails as modifying
an IRTE should only fail if KVM is buggy, e.g. has stale metadata.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ab7fb8950cc0..6048cd90e731 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -724,10 +724,9 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+static void avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	int ret = 0;
 	unsigned long flags;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
@@ -742,16 +741,15 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 		goto out;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		void *data = irqfd->irq_bypass_data;
+
 		if (activate)
-			ret = amd_iommu_activate_guest_mode(irqfd->irq_bypass_data, apic_id);
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
 		else
-			ret = amd_iommu_deactivate_guest_mode(irqfd->irq_bypass_data);
-		if (ret)
-			break;
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
 	}
 out:
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
 }
 
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
-- 
2.49.0.1151.ga128411c76-goog


