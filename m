Return-Path: <kvm+bounces-29501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1D79ACA76
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C60501C23200
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB0D1B78E7;
	Wed, 23 Oct 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xj0Flzpt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5891AE018
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687521; cv=none; b=WJkWb0d/dK1HxTwFkFTTJQ+0A3OCXmO9kZmtpLMCwGsaAYdJ0YbAc4VBgwAFGagSq1z2MHoZbwxHG2zVR+v55vCYoghgxNhEKI9ArEDLgHqqNsXku/c/6XwRTBpVsH9msqJ3f5ZgvER4nOIRFs8h3zyQ0eA+kWORurkvzor/qOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687521; c=relaxed/simple;
	bh=wcnFMlPKB38pGPmcyUweJksVVSBd1q5ySa95xBfPZro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyS7jGdIx6YifHwOliKIaxzOSbN2TIJMlT2s6bz7kjQ/yrUOrRUMhIWr+gMBUoTu0EGp+QEWRL7/xR58syYSVW/+CAZ9dhsmXLGwR/Olzee2q/RwUo6v+1U35GC818SOSMdFmMIx1hmiAvocaW09jGp73elWaQ7UR9aosgtdrAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xj0Flzpt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729687519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JkyMAXuhji9sRwJ3VwBSUd2i/Ce99Dz+9EW9yh0eKi0=;
	b=Xj0FlzptBvUCK6vV9H0hEEzxXx2TxqXHVVpXYHPcA1GqcU8cpDDgd1SdoI2oN5zyHW4fmm
	zRzbPM37zchOiUSovAiPFOzc7NgKT8RkUGF1nLrdj/+Oke9a9WpbpX7YuqVZxT282CeOzo
	42AhiH03104UEbgT/vSR5X/qE78GOnk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-G8CjcVt3MXGRZzS3qaCaIg-1; Wed, 23 Oct 2024 08:45:17 -0400
X-MC-Unique: G8CjcVt3MXGRZzS3qaCaIg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43163a40ee0so41970245e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687515; x=1730292315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkyMAXuhji9sRwJ3VwBSUd2i/Ce99Dz+9EW9yh0eKi0=;
        b=kjNrURaE1caxI2c7BO9AN5sVoCDWYqfAfPD4BUwZ++oe+G8T/+XvRbv3bZ6vWVGwwF
         QBNn2xaI9wIKJLOdsAwvHrBBykZoV6AtSTtGflD9uuGSRK+VZiVQ6foPKvw7sD1zxjfi
         NGlbtoXM6MEuQO+rV/IctWzHfDtU8d10BwI82zJ5sd2qKhzYrVmD8+FsjO5hiR4EIZ3U
         TZsnIU394Qif1O9Q46qWfeMkoEtbZPWmamQIsYaX8n1UpibrzwU0fKDXyy/eJdg5MUjv
         /Jnq17K2ro7pKTe1gKja3NoNp0JtnhV6wyc95cp9ADRgZi/coHLcPsmZO8iTzRK2sbpi
         0i4w==
X-Forwarded-Encrypted: i=1; AJvYcCXQjuEjQWAbBtWCYYhiKZolOwwNO3TLmwsuiZBDsobqNoaYLTdWhybWpH+q1ZQsESo3wro=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfcoHhVL4Wq46ENwOygt0VFyPWoUzTv36fFSyK4RQfK0EqEfyU
	ry76DqDsaTPykENEHORWEYuWoJ1Yxb3Mnjq9LNOTC8b08Nm3DS9otdqrG49U0sJWSM3xUfgb7l1
	861HIulG1Aw086JYp4H9wrcLlywi32K1n7kcG0xTBdRnPfkrCeA==
X-Received: by 2002:a5d:58e9:0:b0:37d:5359:1ec1 with SMTP id ffacd0b85a97d-37efcfb1491mr1473827f8f.57.1729687515353;
        Wed, 23 Oct 2024 05:45:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtbNqS0ecvkDcNz7iJe7I/riHjsiQTeDSmBGIhAHtlSe5BNLZ7H2o+AIOEiWX20qdI1B3+xg==
X-Received: by 2002:a5d:58e9:0:b0:37d:5359:1ec1 with SMTP id ffacd0b85a97d-37efcfb1491mr1473800f8f.57.1729687514946;
        Wed, 23 Oct 2024 05:45:14 -0700 (PDT)
Received: from avogadro.local ([151.95.144.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b9432fsm8825149f8f.83.2024.10.23.05.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:13 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	michael.roth@amd.com,
	ashish.kalra@amd.com,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	oliver.upton@linux.dev,
	isaku.yamahata@intel.com,
	maz@kernel.org,
	steven.price@arm.com,
	kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	James.Bottomley@HansenPartnership.com
Subject: [RFC PATCH 1/5] KVM: powerpc: remove remaining traces of KVM_CAP_PPC_RMA
Date: Wed, 23 Oct 2024 14:45:03 +0200
Message-ID: <20241023124507.280382-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241023124507.280382-1-pbonzini@redhat.com>
References: <20241023124507.280382-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This was only needed for PPC970 support, which is long gone: the
implementation was removed in 2014.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 36 ----------------------------------
 arch/powerpc/kvm/powerpc.c     |  3 ---
 2 files changed, 39 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..85dc04bfad3b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2170,42 +2170,6 @@ userspace update the TCE table directly which is useful in some
 circumstances.
 
 
-4.63 KVM_ALLOCATE_RMA
----------------------
-
-:Capability: KVM_CAP_PPC_RMA
-:Architectures: powerpc
-:Type: vm ioctl
-:Parameters: struct kvm_allocate_rma (out)
-:Returns: file descriptor for mapping the allocated RMA
-
-This allocates a Real Mode Area (RMA) from the pool allocated at boot
-time by the kernel.  An RMA is a physically-contiguous, aligned region
-of memory used on older POWER processors to provide the memory which
-will be accessed by real-mode (MMU off) accesses in a KVM guest.
-POWER processors support a set of sizes for the RMA that usually
-includes 64MB, 128MB, 256MB and some larger powers of two.
-
-::
-
-  /* for KVM_ALLOCATE_RMA */
-  struct kvm_allocate_rma {
-	__u64 rma_size;
-  };
-
-The return value is a file descriptor which can be passed to mmap(2)
-to map the allocated RMA into userspace.  The mapped area can then be
-passed to the KVM_SET_USER_MEMORY_REGION ioctl to establish it as the
-RMA for a virtual machine.  The size of the RMA in bytes (which is
-fixed at host kernel boot time) is returned in the rma_size field of
-the argument structure.
-
-The KVM_CAP_PPC_RMA capability is 1 or 2 if the KVM_ALLOCATE_RMA ioctl
-is supported; 2 if the processor requires all virtual machines to have
-an RMA, or 1 if the processor can use an RMA but doesn't require it,
-because it supports the Virtual RMA (VRMA) facility.
-
-
 4.64 KVM_NMI
 ------------
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 961aadc71de2..a7e5bc0d969f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -612,9 +612,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 				r = 8 | 4 | 2 | 1;
 		}
 		break;
-	case KVM_CAP_PPC_RMA:
-		r = 0;
-		break;
 	case KVM_CAP_PPC_HWRNG:
 		r = kvmppc_hwrng_present();
 		break;
-- 
2.46.2


