Return-Path: <kvm+bounces-41406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765D2A67911
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 988B717534A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C300D212B0D;
	Tue, 18 Mar 2025 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zKmkfUED"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94D52116E1
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314728; cv=none; b=MYzyGjdE6Ap6NJz9KZ62OhpgXxkpV8b/Z3eCiVq/A5ScIlhU3baZi3K8g2AhvKsE6OKEC2zQ4qSBNxxmnDxB7wSzZ580p95+dkf96otqhcHSEvYp/AXcqnaAp32mEo0vd6OR/nWtkGfTPi8Nj/MTuuX7T4Yc+xRO7pMYNTKPlmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314728; c=relaxed/simple;
	bh=e/hFSvnnEwwRtWQXyhisvgF+/9sPbRgWQ8oxDFZaz28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QvMAl6Gd6iuoFmi5PPPHNTFGHP4iCNTt61JhDGISXxlCrSumcVwzhWEQooewx/sCvuxII/POM7itNt+JN1DoDGNBfVKkxBsJDSaXYeRepvqK9uD27srplBrRqbc2ju/jMs60HaoZthCWJD2t0ijV3Yb1QaIjewqekOsOiN+m9Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zKmkfUED; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43947979ce8so17875105e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314721; x=1742919521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UnXOtT0FQ4/1eHnhIJ4TPfV0aGXMBiS31afCbN7dx5I=;
        b=zKmkfUEDPUs1CBSMwSwTNICWLQyiIg/BkYTT+SwTd0ymwwiVsYL7Ey1zmLHahtOrv4
         0FgVPBOMMb4n4vs9nqbGeLVzoquCdEMs1VQPNJUpI0LAcXvmtVHIK/Rnaqv5nXcMTCXt
         ehQ5+Cbnwm7H5rZ2QVQjvlLFDvYBRnnxo43q7U00FBNWbWqbeS2PW8ylhSu0+4/zpvZo
         vt1qTZ6BNQqXhga57pNwA0DUt7GNTPDkq/DgT/hkw84TYBAxNxaCT9K3BlzMlmuCmxrt
         vg0M889gn/FZrJ6vj+M6CqzZM0La+SrDxd4F5KIsnZp2GVfEoT8RIVmI6jP8cAJ6j9+G
         6CxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314721; x=1742919521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnXOtT0FQ4/1eHnhIJ4TPfV0aGXMBiS31afCbN7dx5I=;
        b=Z+Ci2WUyJPBEFzWJnoqvajDMshWjXjCtaxo06zEaPMjX3UGyPELxjRQn7UWRDVT40/
         NbUwezgBhuXkuK8WB5vMmmwzBxN8HEHjMy+0M2C7wo13r4u6NnEY882fgPLxPGY4b4+h
         hzM0f7/alwND5miqEukrcjxSTrb8dkYsTskJ3wPM79GCIaegGvSDmvYlewXbxxJkDn5h
         gXVumkG+z7EwCVF5ALWYw+sg85IpA3W3xHtZY5aOyE3fT0UyEcD+yKNK1sk/7mAskz85
         50Jhy6cQjCPC0gibYQg9UWI5VyuAZkPX9deeHjFMy3c+rsPb55nNfFb4VIXy2DLfftkk
         I7Ng==
X-Gm-Message-State: AOJu0YyFI7sxLdn4wmuvZYulNuNCiNS7k/fZfVz9fXF6xyXMZX9VA8Ew
	wWPd3LuoS33XxqXXFcN0xI+0L6XMg/ywrDX3rzF2Tm6Qvsjed76xbKOq4QxWGb9pB85eb8bRU+R
	fdqsK1CoGT4Rf4gTpRwnP2qOfVC1AD7wj/esdBjHxV4OiDPIEp30UZhuQGWOgHaqVcgQ5E+xA15
	zEjxL9osSOh+crtJ0/jSsTUFw=
X-Google-Smtp-Source: AGHT+IF9uTFjzpmaEzCIpQhbB++4V0kLzKxiQ3A1PdNJXhx/vKrnJQ5sz5qzaE8mmmXqSH2KhxB8aRlH6w==
X-Received: from wmsp26.prod.google.com ([2002:a05:600c:1d9a:b0:43c:fcfd:1ce5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310e:b0:43c:e478:889
 with SMTP id 5b1f17b1804b1-43d3b7c9e1bmr28564975e9.0.1742314721054; Tue, 18
 Mar 2025 09:18:41 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:22 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-9-tabba@google.com>
Subject: [PATCH v7 8/9] KVM: arm64: Enable mapping guest_memfd in arm64
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Enable mapping guest_memfd in arm64. For now, it applies to all
VMs in arm64 that use guest_memfd. In the future, new VM types
can restrict this via kvm_arch_gmem_supports_shared_mem().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..4440b2334a05 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1543,4 +1543,16 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM);
+}
+
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
+}
+#endif /* CONFIG_KVM_PRIVATE_MEM */
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..4830d8805bed 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


