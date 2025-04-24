Return-Path: <kvm+bounces-44150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6FEA9B063
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CB247B130B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B3B1A255C;
	Thu, 24 Apr 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YyLEy0uC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548622DFBB
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504035; cv=none; b=mO84cjkhROsOOADj3IIiIc+ZkUrUrq3odvs9XDJz97l0Sv1Q2xwVvy/rk4iMVJwUv11yaiGCUdQ68qtHkM/JXvvK+SqNK3dstHBy7YqRqQXPMlOB91rAqORR50NByAqUSnaxQjCuZ7pz5sDqjLhjFIUyZc0jxmVRilEuIcSnL4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504035; c=relaxed/simple;
	bh=62G1u7Mmcj0LoLg/GsZOxRpsdU6hf0LcgEiDACKmXjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pMddNGTmWH9m647r/cv6eLVl/3eJw7BU94310aXghLaCdHqrk7YM+WCEh+uWlxGwbe1On7XdaJKfQqwqshx8Hb7lmMnf3VivkaH0E5cXRMvujNh1Z+S6MGmsu8tmKi/8pM7tRAGPO2cAOTsiAuhEiIocbefSlUrNE9Ap4EmjEZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YyLEy0uC; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso1551271f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504031; x=1746108831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvSif0ZiFcbo45REElIUdI7xtRbISNuAr1Y97HbCqdI=;
        b=YyLEy0uC+aKHIkM4oaNNOOvTEZxl/5B4cXMJWSiA5CH0VKETdRs1XxMP9euG6CgE2e
         Z23rgG1SUAKMC/rdVHWjNbC+XWmyfueGcOirkOcsGMCQPLCujAKCkPge1SHWgctMolRg
         VsK7AbhITHdDJZ/mZTkqKU2opmMA5akZbn1I1JWbXeLTDgeuLCR+bqweC7o3r8fqG0JP
         rvxIZ6AW6JAFEQIIudhQnHCQgdgEg6zG4+kSRQJN8FbIPXzyGwglOHS25g10OTkEfunL
         lbyuyS6pqq7X1Q8tQ/K+fZGkXN0vkHcZtBXrR60SkIIevTg4zC9iJj8ScVY3BHkXRwUW
         mzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504031; x=1746108831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvSif0ZiFcbo45REElIUdI7xtRbISNuAr1Y97HbCqdI=;
        b=kM7dAZp+ZsbGplPyCpetMwTqYOG3As5ZVkfvgoNOzPSAKUaDlBwGOzQV9tE/DknSCk
         a1Kb25tK5HP55YPLwdss7Wyv7YWnEDhjm3yumALyWV3zCYvZwztQ+xV/XWOMSHEKeUc1
         cgLDHzJY57cJND8XqvYmXCRqHDgJWEE1RfPCR0sQBM4q4ivxosSGlswWtpmZ+48Q8iNn
         eLJe4ERkXnsJ3b2eXDiqDdgQU3spl7/HaYC1rPp/+XrxEwVSW/a2CQ26NW5bgz6IuUS1
         BVXjlekRDIORxugnm11kwAHpotKJtNTUdSufWc0isrFBYdumcIei7rg6PSnFrFA5RJJB
         vHqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsuwnl8AyAqckfA4yeZcW3+lxc2o7Zl8rg8ScdMDFLFsEdqApZXwi7kV1fhzwFXdffiEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlJorrh+GXsDbEdELh7bXyXcJHAXOyqwICoVAnTL4lEirD/45R
	dY3OOXoi6Lgo7O0Ovg9eW4+2EdUecDnturN1vJwF7pgc0t1TJxM8XRVRpF47Udw=
X-Gm-Gg: ASbGnctANW/nsSAiuYsoDrPM47Xzy/2x1SBPFo1oo0Gbe77RrfYLdfT5pZwDooF/CFP
	9raCYSQlPygVQVggqgndYyfTllJri5djvCGQMeyY5A36PdwKmQPKNM5P2Iu3TLAHc5V7W4YQGzg
	K8M/2LRiFF/lNA3x2DFjlMXKh82dnoqPUxYCrynvuRhqKa1N4m3hhxzXZ2S8pnz+ayjI/4+sqSq
	lJU0teQMykF2hJkAxI8KTslvsb0/wI6bDE0QGT04xP50Mhg5gquLmMS0//oHYv7TGPb68q80Jjx
	GshML1VhSkEZEGVU+5WYYoxJHP85Ao+p2+eRbbVwElVcKJioMFdeDVGFzweRja4SKgB1FBxwsja
	HKhF0FIPupy+HG1tH
X-Google-Smtp-Source: AGHT+IGs6TOHidyOdLjO/aiH4v937+mffmDnW0sidZAyNfcPHTexYT+C0CxkEqdPf2DwJcaHqEXYnw==
X-Received: by 2002:adf:ebcc:0:b0:39c:1efb:eec9 with SMTP id ffacd0b85a97d-3a06d673778mr1956533f8f.13.1745504031472;
        Thu, 24 Apr 2025 07:13:51 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:51 -0700 (PDT)
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
Subject: [RFC PATCH 05/34] KVM: Add KVM_SET_DTB_ADDRESS ioctl to pass guest DTB address from userspace
Date: Thu, 24 Apr 2025 15:13:12 +0100
Message-Id: <20250424141341.841734-6-karim.manaouil@linaro.org>
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

Some hypervisors, such as Gunyah, require access to the guest's
device tree blob (DTB) in order to inspect and/or modify it before
starting the guest. The userspace virtual machine monitor (e.g. QEMU)
is responsible for loading the guest's DTB into memory at a guest
physical address, but the hypervisor backend must be informed of that
address and size.

To support this use case, introduce a new ioctl: KVM_SET_DTB_ADDRESS.
This allows userspace to provide the guest physical address and size
of the DTB via a `struct kvm_dtb`, which is now stored in `struct kvm`.

The ioctl allows platform-specific backends like Gunyah to retrieve
the DTB location when configuring the VM.

This patch also increments the KVM API version to 13 to reflect the
addition of this new ioctl.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/kvm_host.h |  1 +
 include/uapi/linux/kvm.h | 14 ++++++++++----
 virt/kvm/kvm_main.c      |  8 ++++++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3461346b37e0..4e98c7cad2bd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -862,6 +862,7 @@ struct kvm {
 	/* Protected by slots_locks (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
+	struct kvm_dtb dtb;
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..8f8161cd61a7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -14,7 +14,7 @@
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
-#define KVM_API_VERSION 12
+#define KVM_API_VERSION 13
 
 /*
  * Backwards-compatible definitions.
@@ -43,6 +43,11 @@ struct kvm_userspace_memory_region2 {
 	__u64 pad2[14];
 };
 
+struct kvm_dtb {
+	__u64 guest_phys_addr;
+	__u64 size;
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
  * userspace, other bits are reserved for kvm internal use which are defined
@@ -1190,11 +1195,12 @@ struct kvm_vfio_spapr_tce {
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
 #define KVM_SET_USER_MEMORY_REGION2 _IOW(KVMIO, 0x49, \
 					 struct kvm_userspace_memory_region2)
+#define KVM_SET_DTB_ADDRESS      _IOW(KVMIO, 0x50, struct kvm_dtb)
 
 /* enable ucontrol for s390 */
-#define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
-#define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
-#define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x55, struct kvm_s390_ucas_mapping)
+#define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x56, struct kvm_s390_ucas_mapping)
+#define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x57, unsigned long)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dbb7ed95523f..a984051e2470 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5121,6 +5121,14 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_set_memory_region(kvm, &mem);
 		break;
 	}
+	case KVM_SET_DTB_ADDRESS: {
+		r = 0;
+		if (copy_from_user(&kvm->dtb, argp, sizeof(struct kvm_dtb))) {
+			r = -EFAULT;
+			goto out;
+		}
+		break;
+	}
 	case KVM_GET_DIRTY_LOG: {
 		struct kvm_dirty_log log;
 
-- 
2.39.5


