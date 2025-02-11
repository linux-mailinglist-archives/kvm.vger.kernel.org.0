Return-Path: <kvm+bounces-37850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F88BA30B73
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4773AA425
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BA922E410;
	Tue, 11 Feb 2025 12:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eh/om10r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DFF221DAE
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275901; cv=none; b=rgogI2UR7X/d6PU2RSfPapHkQYHV8L7Vo3B3wsJMHIwAcfQP7LQ1FlxGbIZNnbr/dAHEASi+9PSdfZz1/LI+NsOVkG6FlE5njSRpnRcu+BL1ep/RJzlXim1p70/mK3lNaIh6AxoGH7PxxaUZKnOAKQ2uPQxPfdRmaefAQPgzl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275901; c=relaxed/simple;
	bh=wJDNPUbPulY91yymWFntWwTBzvEsNR4qKkxfhIjiVic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mem5aI2Vt5rdlyt2b/+i0X5yJvZJUst0whdNz/PEdAkIt6hjVhxbbYKCiJCLW87iyL35v+YbG1CmdCJBEiBtNT5sRH+lEN9OcoQquUDZkmaQEHiEZG+AobtFRnsSq21YQeERZdoWlm1ie6LYijj+ZJgL9MpIRDZXWd8Wm0esIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eh/om10r; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43935bcec0aso22508605e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275898; x=1739880698; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VoOoWnCPGl4HcCb1I6zbkoc8AjEeP+ezJ3rNmGf66Z0=;
        b=Eh/om10rNOyPf1rZj5bOSADDW6rp513VI8ghX/5Lh/CyYC3eAb0mrBrDGzwVoyNms1
         mcTIB2/mcctIix85Sc6P40zxRqhpwThnEvCUBcFLda7pfvqHk6N2fyenKyJ2Vjraaa7C
         uBILh73D40yhtDO2721bDpNgXdmxXqVrAmrmhIno7qadJta2H3YfQkTT211VEnn36Kcd
         WXDrrTzWdajZOveq7bdagToOyddOPn+mFWn79ZuAbADFpgeefu9kEW49kkrA82wvs7lY
         xe/S6OVQL04TkRPc2la01be+6pmGm3cRkGsy8OfwhPKwIAsRhmljeUpU1wzgObaJVPUH
         lexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275898; x=1739880698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoOoWnCPGl4HcCb1I6zbkoc8AjEeP+ezJ3rNmGf66Z0=;
        b=SE6/Jfu0+VHm/LyaG9UDITIE5GDkSnKsc7x72SZ7oTOhbJ4wwAr1AEa1T/tAF+KM4J
         7AjPyGZuGvTwF8XZ874rcDKfXGrjKLyzzLBGkzpeyDc3VkgARH3kQZd97g4m+/RZIGbj
         IsAi2qDlaOUOz15pjO5d4kXP6TaXsgofTkQY39QCFHpphtt7s0w7j6H7OY6mhvgW6JIT
         vT4UVxKe2jAXkBtzsZB+WyEPZGJQ1g+Wfnn37Kca5UQMcSZZ9psYjmCy/NSHOHaL0PDE
         11ldY5WfdTcsnrgcMW0Ncwrxys+2XtLj6NIcSOYToaNm3cd1kY/vYXldf5MNsVXjP//J
         N6rA==
X-Gm-Message-State: AOJu0YwZMxJeWvVS63hysfv/2sUnwzYB3GZUnqsEanUU4Cw6axjll1hc
	tG5QcXhvbOWHMqydVezHh1W7ArPd/S3Y62P8QoeNyQa9JmLVwl8R6tS5UEhjO9L4rW8MYlAfO0x
	OL3GFNjinE60zyS87nqGpI3wfgP/Zf2O3vYeLIVrYbNQeVZaJkI0ez4mKoJag/pza5PK3K9kAEl
	T/Mk+OVzTSw2/tSH0Zah7CVzs=
X-Google-Smtp-Source: AGHT+IH0eOMmKp8sDSfZvGefzukx2BbOVxp2ECFy0DQe4p4PevxPpr9NYmFYN4kr9FPJEdUBhdy96NX0RQ==
X-Received: from wmbfm6.prod.google.com ([2002:a05:600c:c06:b0:439:40af:60e9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c03:b0:439:4df5:5d41
 with SMTP id 5b1f17b1804b1-4394df55f1emr27500045e9.11.1739275898177; Tue, 11
 Feb 2025 04:11:38 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:20 +0000
In-Reply-To: <20250211121128.703390-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-5-tabba@google.com>
Subject: [PATCH v3 04/11] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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
2.48.1.502.g6dc24dfdaf-goog


