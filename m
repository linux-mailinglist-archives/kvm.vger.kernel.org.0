Return-Path: <kvm+bounces-34957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCA1A081AA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 872EA188C813
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219872063D6;
	Thu,  9 Jan 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mcF52Ldy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD002054E9
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455802; cv=none; b=N2UY92YjBcE+wDXcxGYzA0V7m4/MSPpC439OZ38LJ+3xsHobhlMPU9UhYtZHi5UO4rf7gg7Cxfd0V06G60def4IS9OoD/+gXyZKleKh5f+U/iEPp1fEacLstfZ0KtO9cfq11c4zGAj4c94FL+vYF0WpqPQXa5aV9VgC7KdUE6hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455802; c=relaxed/simple;
	bh=tSVByeVc+YvO1YwpxO6WQbJnBeXOFHCPwH2YC78/pxw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BSpCw4PQDj70yQi4EKUv1KV+SMHIgsrS6+ppqvMSJhgvgMOATGV0oVVCL1Yer3Ee42B3UvMg6CboxY7HnAdkTbAkJHKxTX/K+qi+Wna+jvU4xJ0bncTmJm7XjQZeJUYEHk7CVjSSGEEpNODU0+KP+/nTbn4HnZBK4DZqDhCEG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mcF52Ldy; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-85ba1d9dcf8so359753241.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455798; x=1737060598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1DrcQjgptnhIcToWnmFksBp0MRaAX2CW6X5qNo+eD6A=;
        b=mcF52LdyaRfn8cLItO/k6gTIxPtxYCogEWTleb8jRHW5KCCfdg6b4Wxm6SdmctkCMX
         666H6Ru4TkG1aTe9t4Cx2NzHHduVFIL1s7ZFcPOhgwUIzhQVeJHbyt0aeS4j/Oapc5fu
         7WQ3Fgq27FPX/bljvQi0dHJd4D7DxZu8V4Adm4i7utDYAPDeC3sqkPvp9A+lDvOTQ/zV
         ffGQKir7iTjt/Et9/bvsItbKw6jxc+VOWSL9KKCaMOfpIEm9vfkeeUofLque5fwYuXoM
         U1gMtxRzhZkup6Zk6CeoK3meC4LYDukumG0Ay0mTX2jVcv+XULeQyFs+sfljBZPOEE/U
         C3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455798; x=1737060598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DrcQjgptnhIcToWnmFksBp0MRaAX2CW6X5qNo+eD6A=;
        b=Yij/1L1fGxxinO410GKapI/ZcLlBSZ6aKVTKu1HNZe0HgZ5UkWPOe3RppEXqr6nx3M
         wtjdn4wY2TZsLSpowUsPH+HRFVygVawmN2WhJ6ZPi1FQIfrlB3f/xDnUpLXtHfX4ImJw
         J/QIQbVo0cu9+4zCa8wCfnKpzdGIdBh0yttxyQhCLbAfqisDqEaNzLYIzzoFhMCBNN/c
         VjP9SX6qNXsKs/K25V0eLqSyPz4CdjLJXtJFxntds6EKX3JkHMk9WndciB7gDe3adw7r
         JeNpBNBf73gUA+Gzz1uQqW+lUbE+PAeYd7ysHbyZoRGnzChUBkimhf2aRKbTny297OCR
         9CpA==
X-Forwarded-Encrypted: i=1; AJvYcCXr9bqu/o0dAyeG5Wa8FVaC7YCqbi+ezWAGzewi7Y3c/5G3TwZN00zU6j+StgqYiHcw1tQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVqm0J7+lnkHMeH/BwO79vymqhjdmbhHRjG2+HjhHhUCZVRvQ5
	DPXtXlNLGZze4jhK01vTB0pvgP0o7L0os/18Y/SYAlV+GxlGMlmSASpKCd9bo+I3bjrZ5Nk/bGq
	/RsMHZDJDcvnNCnLE2Q==
X-Google-Smtp-Source: AGHT+IEK0449o9KbC3fWak3S16jydYyIqzxOV/2eZ44AIR7w7I0DQuvF+HeqMnZYowZ6lm/VqNUOgc0IX+KhZU1E
X-Received: from vscv18.prod.google.com ([2002:a05:6102:3312:b0:4af:df7b:f439])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:2c02:b0:4af:d487:45f3 with SMTP id ada2fe7eead31-4b3d0ffc73fmr8314563137.23.1736455798514;
 Thu, 09 Jan 2025 12:49:58 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:20 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-5-jthoughton@google.com>
Subject: [PATCH v2 04/13] KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Advertise support for KVM_CAP_USERFAULT when kvm_has_userfault() returns
true. Currently this is merely IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT), so
it is somewhat redundant.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c302edf1c984..defcad38d423 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -936,6 +936,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_USERFAULT 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 882c1f7b4aa8..30f09141df64 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4811,6 +4811,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_HAVE_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		return kvm_has_userfault(kvm);
 #endif
 	default:
 		break;
-- 
2.47.1.613.gc27f4b7a9f-goog


