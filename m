Return-Path: <kvm+bounces-65408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F4ACA9B9D
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2360324A9FC
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7385283C9E;
	Sat,  6 Dec 2025 00:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g7xckl+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A87A280336
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980279; cv=none; b=SW4PqsKfQz053jY+l8CNtT5g1RDdARMWuGjNf0saUm7luj5tYWzIY73i49rJpI8keuV4bGPtDV77czV7iXi2hor6ldOacY6KYAdOh603zzsF0si1tHJrwAZsGFM9vCal/Upqdiy49sMbnXBa2lNQo1itL6dQAhiVYntC+cFgIJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980279; c=relaxed/simple;
	bh=tj6t2t4Ed4eDjoeIXxejgP4HqHkh0nNCA/O27IqihCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rQTJg3dB37Inpb+Xyx3+KpunhJcalYzKWAIqaTFEYKfRuhrvbc2Ge/yjIsAoIEsezNML9n0a+txKcd5WefphqpcyXE6ZPf5RtABBLHKHJCtBxCA6RJN26bgAgyn2wryT0DJ3+SSQdphjx5mPBv3qW0QNCL8OHQ4VfWFg/LYlL70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g7xckl+P; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29be4d2ef78so54732605ad.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980276; x=1765585076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RvT5QOLTrPlZDM6KRmJviB3G20BHxxiuQcblXVA4XhQ=;
        b=g7xckl+P87b6HbODAOyT/O8Ipex0KWgqAc+ZzCIL9NjsLCFEDIRpfBYM9auy7pMQ5t
         VERXFbqzPC6PofStt7lVol1EdHMzHQCp9kT2JRovo5/3hbHsf8ttzfYqTRFK6TuBRAty
         Cu1XCTP1ut6Lb3EX2tlSoxtsd8Qke9ORXfEKFCmPRbxJVVq80Afom8vtxIQd9NOTti0t
         mCsRj+HiuWs/o8Vk7E3gcZuPygdMomU8BYMc+Faz0GzANqJuyWuK8OBumvj4uI7q48m0
         djTghDTCuIMJucbuy8EibimzuBejPSuhkXunuW6vjD1hCThXPeqpqUzE2EKmosC67SNU
         Aygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980276; x=1765585076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RvT5QOLTrPlZDM6KRmJviB3G20BHxxiuQcblXVA4XhQ=;
        b=PW6J9pb/KGyNisRu/uQB54GsCyaa+aL1fNl4F1jEzPkC3rVQ3ZJD0yuDroar+VUyvn
         DN3dWjy/dpdnnlg72iIn9xjI2aiws4M3oKXfCqKwHZzx4Ki5+REgWAxVn42xlULM+i25
         H7s1wuHtas1+nayl5nOlzzkDFJrfhJVH+iVK9O5usEwum3PJlzER7vz1jQcAHA8+FjtY
         LDrDB/9uM+UbUh/ef9KKrzxPcVuSkfx7HCxYR3qi5oEBkw+MBppcqiA6Y451Aa1oZZ0Y
         oq9Ev9hCBOhjDvWhEUwYIDc7I4wknPe+aknRHp+dBVkHO764WxxMZkabIrBVXyd2Sl6T
         t3Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUIUZTPXgc7eua5Ixp9RjCdvL76QtJ2C9WVb/jYqAyjVVk+RzdGQBR1Xr6kijprn7sus9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3u12CnVgX/WforYXlUwGJ+qkiv9YmlVAfSaGrY6CVD2Rr8xPu
	RjmdP8u/HCbUKuGwxQZ+RG5FnsZM8Q+dLF3xUf8KakoLCfBbB1ejPdvNNGMSeDSkMFkvhO7R3p4
	/UMhuPw==
X-Google-Smtp-Source: AGHT+IGYBlCmb/gXYXB/w+eLYeN/6lSsoZJHvJE9tm9YKGnjFm45dzt4nCYHuTcqC75ktumYKLC92IIPc9g=
X-Received: from plbko16.prod.google.com ([2002:a17:903:7d0:b0:29d:5afa:2c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:295:5668:2f2e
 with SMTP id d9443c01a7336-29df880d025mr4171385ad.37.1764980276326; Fri, 05
 Dec 2025 16:17:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:51 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-16-seanjc@google.com>
Subject: [PATCH v6 15/44] KVM: x86/pmu: Snapshot host (i.e. perf's) reported
 PMU capabilities
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Take a snapshot of the unadulterated PMU capabilities provided by perf so
that KVM can compare guest vPMU capabilities against hardware capabilities
when determining whether or not to intercept PMU MSRs (and RDPMC).

Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 487ad19a236e..7c219305b61d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
+	perf_get_x86_pmu_capability(&kvm_host_pmu);
+
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
 	 * configuration by userspace, and KVM's APIs for reporting supported
-- 
2.52.0.223.gf5cc29aaa4-goog


