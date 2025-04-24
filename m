Return-Path: <kvm+bounces-44146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F243DA9B055
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37DAF4A1CA1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A73219C558;
	Thu, 24 Apr 2025 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AA30G/zS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6657919E7D1
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504030; cv=none; b=jWkErLJxCQdQ0+MvW84YvW2gNnErgkLIG31AsJAXdSw9xkkNlF3xwKQFrTaUfFX00xyz5kf/3YA1g4yMRbicBwFLp/jOCHMeQDgliC2lMoV72E130TflB545eUUlxLJf1BLrg+sPZ8Ou4h6mWGqxIjk2AHUhEBllxnciOUDE3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504030; c=relaxed/simple;
	bh=g59SsG0N84wb4f6piJJJcigRQ9wXVyh8p4R6BkHSxiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5kFjecHTJr3xP2COsbnIBAu68og4eusBJ+P4DU53LVfwEHYvd0Ciuu3DXoVu+xtlHtlYrsPyqqjuC6PKQkJh2wvTDbQk/0Uw2RUvEt30YwTNhknMFzsSVFfg8KDEcIF9XC31/yVQa3KCjhFN/xA2bUSG0vMREClPbINEK8o36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AA30G/zS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so8024395e9.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504027; x=1746108827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pJfw58KOVJlcvsi2YwD0da6h5VnpsCyDZ/he/rc1kk=;
        b=AA30G/zSiOtqtVnxkLa0X8k1r1pZp/3eUWrFn/EE5oQUpM7AosmhBC2MyM75dSYlbO
         DRm2U3G/6g//VIxHosWcE4Lalv2/+waCweY4hZxmTsu2u02tyR15flcUple6GuLoBGq9
         GrwLEfePZN8SwTIzN9BIQ9F1IZ4SJjKdg4myB1SQWWT8GIuwyNruHG3zQvacLy2mn6L3
         TtfLWdsVlIUwzwkfuBDS+Hbb8d6wibe0MDkbhEhLnt2BmXOkZcBAKbK/qinhxWSr9di7
         t39Xxhy6PuvNNby9/C7SXgQsRacwr8oWl+sL1/1uC1EhlkZoUaFmI85JDn5F+IXSj1QN
         mDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504027; x=1746108827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pJfw58KOVJlcvsi2YwD0da6h5VnpsCyDZ/he/rc1kk=;
        b=kITzX7N4GgbNx6FQd09fCUNwcvPRm7GAjxDcmmkeixW/HfKKsTyicXgwaPWAYBbojV
         FUs0gLktW5+aaBEV8wsxrHnmj21oYZpN3OOdZdDiBxLsUU18oEpFCy1Dz3eVMnv8Db5K
         fyCrPGmKktJm87lwutiVnM0DyoDNZbZvVyJUJ+lSdWadrJ1treMFs1eUyZaoANPoMiF9
         3LoakQ61svQOS78P1HJkQaUzX8edEG6w8/ek3h9mOac4ljA/s1MaJztlVgkPuSvDIjyE
         of8PfkDWNkjYX2Sx2eI7nO8l5sZthNVXZEh89xZINeE+Ja4s0BMbU0yGzIfGucGLcLLB
         A6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCW27PR5NIrMYeiXz5YHYjS+l+N2xbDIa2EvKC+xVzyfWZ8UBePcwdH2Gf/VN1utkS5i4Qw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN/mAV1neaXhVdxttFhJO52O4MH2rlNjmnA3gSzZs2chM4XStM
	Xctkig8SJHZzJGuMsk4NViarL9Zu9DPn2Q6ojBG8Pu6vCjrda8ucvFSqx/Aw+fw=
X-Gm-Gg: ASbGncui2zATgKuyfih0asLj7v3T2CWXRInaDZmL6oTLmry7m0gNfI8/VsO/sa2S8lb
	AxRDj6Us4jAMARqPtekfQWT1NFMi/KAIg16vu5b8H7ouJF8MhIc2B0Rj/0jPxV7C2LXoOI1zHZg
	Dx3ebKUUOXdYE6pR37uoTSUQbt1WtXNfo1+0/qqO+CuC31n3OIWO6STXDTeIkg/bYEPuOiuaNR5
	CbVE4o7FiiL9zYoFF7NGK1Xf1pe/g7aum7oylOEmmVawYqsZq4VtQRo0kQwd1eT59MhXE7EePfz
	nVoCzeCEOFQZjcFPFe+p4ZQVfOFieI52nFT9pfgbANpXAT0BKm3rMbWKYm0m5ukCNzSx1HkHuHJ
	pqDpJck9eSohmtZvy
X-Google-Smtp-Source: AGHT+IGfRrIJRrexUH30juVxzQxuzQYHkS7hGTbMmJLV2Lp0+vmOpc/tkASkqUk2GbTXQepziYNH6A==
X-Received: by 2002:a05:6000:2510:b0:391:304f:34e7 with SMTP id ffacd0b85a97d-3a06cfab9abmr2560733f8f.44.1745504026564;
        Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 01/34] KVM: Allow arch-specific vCPU allocation and freeing
Date: Thu, 24 Apr 2025 15:13:08 +0100
Message-Id: <20250424141341.841734-2-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Gunyah KVM backend [1] requires custom vCPU allocation to associate
architecture-specific state with each virtual CPU. The generic KVM
core currently allocates vCPUs directly using the kvm_vcpu_cache slab,
which does not allow architecture code to intervene in the allocation
process.

Introduce two weakly-defined functions, kvm_arch_vcpu_alloc() and
kvm_arch_vcpu_free(), which default to using kmem_cache_zalloc()
and kmem_cache_free() respectively. Architectures can override
these functions to implement custom vCPU allocation behavior.

Replace all direct allocations and frees of vCPUs in kvm_main.c
with calls to these helper functions to allow arch-specific
substitution.

This change is required to support architectures such as Gunyah
that must allocate architecture-private state along with the vCPU.

[1] https://github.com/quic/gunyah-hypervisor

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1dedc421b3e3..3461346b37e0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1581,6 +1581,8 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
+struct kvm_vcpu *kvm_arch_vcpu_alloc(void);
+void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..dbb7ed95523f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -476,7 +476,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	put_pid(vcpu->pid);
 
 	free_page((unsigned long)vcpu->run);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	kvm_arch_vcpu_free(vcpu);
 }
 
 void kvm_destroy_vcpus(struct kvm *kvm)
@@ -4067,6 +4067,16 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 }
 #endif
 
+struct kvm_vcpu __attribute__((weak)) *kvm_arch_vcpu_alloc(void)
+{
+	return kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+}
+
+void __attribute__((weak)) kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	return kmem_cache_free(kvm_vcpu_cache, vcpu);
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -4103,7 +4113,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm->created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+	vcpu = kvm_arch_vcpu_alloc();
 	if (!vcpu) {
 		r = -ENOMEM;
 		goto vcpu_decrement;
@@ -4182,7 +4192,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
 vcpu_free:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	kvm_arch_vcpu_free(vcpu);
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
-- 
2.39.5


