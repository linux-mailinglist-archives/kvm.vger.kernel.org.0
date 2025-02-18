Return-Path: <kvm+bounces-38465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8FEA3A42E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B4F37A1BD3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BA4270EDE;
	Tue, 18 Feb 2025 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MdXWdj4+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAB6270ECF
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899514; cv=none; b=WnXyHmmPzCteUz04HWMuCAAzURV5kuH02J32BCI3hnEGTSm8KtdjUf7EUXYn+L5r+uDVlNudKBLUBf9Qw6jaCLZyW0ySlbFDOEE/QLH9maxq2o6drWXUIfB6OKALFRntM073e6lAEDd8Qr6kYoMt5k3XulaT/8huYlRdYJHO78s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899514; c=relaxed/simple;
	bh=3ODvDdD/WM55UKWf+HAM2o9bsLV2oxTsA5di8myj3xk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TdpJP6QgjQ1zXcUU+a/Nxw+vFvj2bEw+pRpR+L/CozgMiupGz92w+AqytT/8u9ag2qPk4z7AGpq/L159RIGlcgXFayqiWEA5hbFfRfkGcOt/g6oP7ZnHsjKMtVCVgRk+loOFiJMjI/Vg3FLCQSJuAB8Ww4vGg42pWE13rnHIbXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MdXWdj4+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c747c72so30192435e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899511; x=1740504311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTW5My6K2OM+Dzwm+PfBz15qR/KnyXT0mlOIBk4Z2/A=;
        b=MdXWdj4+zOwRmNiIE/H9YcfqVCC8Fu8DdaMmJNwslKuUdOzcM8fPE/bSxEHA9+v8jN
         DifjfVhpQ8OyKY1fxOjHme0CsbIZT5VJ/JhxvBMJ0ROFlE72klMXu6WEjBTtS6xvvB/G
         7ewLOu33btX068oeaWu7M+R6wN0qPPZDtx4ehooUuGEMCE3uzvtWbaX73tgYpE2LJG1X
         VMNN5efD/SbU1c3+hFK7le/QVkbn5bsRBF3eiJsjYsZbhR12On8e72HutDiPtE/svWwk
         YaO2Z+U8Ww6GEdhiuf3EM4de01YmnZpbsGcaCSxeOJYkEXzO7q/TTmKuHzFMKEY85w6d
         xa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899511; x=1740504311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTW5My6K2OM+Dzwm+PfBz15qR/KnyXT0mlOIBk4Z2/A=;
        b=hr8G+FcZSPJBI2Hy7Var82I0dqZoOXtlNZKe4XdnqJ2XhaIKo8kaUdwQhCAMIpdw8s
         Hl8GV2mYzp39tmRKECwSV2bNNoxMAbwYq6WJjjMC/dVNbRstw9HjEcMwOCqZsTA7uG9u
         tb9N4234NTmzPF6dZVc/8sh/2H8jbRcgOC6UE+ObJtd85M4MTPzCinNRJvb3/eAqatTj
         rwYaChdH0MHz86rGrkAn7o4/XIhhIEHgVifL+wO1AgZnuYrtJeG7ZK7wNZb4ISTMjtWH
         zrJdAuCQ6ee2pHj7rswfC3Sk2GG1UtGtk38xZC4AdrYuv2v8M5qTT+CgwfPFhdNV9Upp
         rf2Q==
X-Gm-Message-State: AOJu0YyqKdUSVgO5EOkVyVcP6limuEUEYHU96bVOW0F/2/Y719XrLTtV
	01k1oHY8fvVMn+9JIs8NY8KW9Mvw61T0DggfqkC5i0Utw7A3wJrnMKJuB8uZQOab8ntcpr/nlxp
	p5K5wkfSr4Pg6SpyGFquky6S5GMoO0UFfaaEeENxMw/VlhQsMupf8qvtZKi2IavBNlnVVIYswaD
	geAIQknwdhzWzqO5uKq0DWlkM=
X-Google-Smtp-Source: AGHT+IHuQgBmWKLX/iaLAIhwX+Ygl7SCrjQmYq5mlPdxwxv1m1H3cuEySvE1kherBoZWNYm/GzLxu4kvpQ==
X-Received: from wmsd12.prod.google.com ([2002:a05:600c:3acc:b0:439:3df1:f296])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1550:b0:439:9377:fa17
 with SMTP id 5b1f17b1804b1-4399377fb82mr36630915e9.18.1739899510991; Tue, 18
 Feb 2025 09:25:10 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:54 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-5-tabba@google.com>
Subject: [PATCH v4 04/10] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
that the VM supports shared memory in guest_memfd, or that the
host can create VMs that support shared memory. Supporting shared
memory implies that memory can be mapped when shared with the
host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..117937a895da 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_GMEM_SHARED_MEM 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..38f0f402ea46 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4830,6 +4830,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_gmem_supports_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.48.1.601.g30ceb7b040-goog


