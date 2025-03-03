Return-Path: <kvm+bounces-39909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CEDA4C980
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1D6E17E36E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68602500D4;
	Mon,  3 Mar 2025 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pqS6A9aS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B42724FC03
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021836; cv=none; b=u3+JjIk5GfMO718bnPgtXw/IEF5deTp3tf1wiUyfzf5ifR5POftjTm9vzgH8HdAXpeGmM+tnP/mihjsfCXDew00rc3N1vCM6aKdfEcxh1rwwTeQ46EQhzxXynwrAZKYDppxWn7B9ZJg6/hDgDMHIqn/qA7M7d2OinCFlQH6z1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021836; c=relaxed/simple;
	bh=UYRA4bHY9NpuOeOv9r+U7mqBEHtesYiSfuqijojqAkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HX0lJD3MYPk0AGAXA+3qrW+1WznBXNmzvTEGQta08j2AOP3UZ6efcWyi9WbiKsiu/X9Cl+z1RrP/xayQUEj4fbEA09pdav8Zq9+NbwvWfxYzL8GDr+vtjUq9Vy6g9YPelfj/LhvGnbkVo1sYumPXefoc25x9Tj+VtcTWN1VPOLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pqS6A9aS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43943bd1409so34245295e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021832; x=1741626632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RV6G8AsPpZM1XsfZjeI6zZRAfM93BJc0/BH0p1ZFFrU=;
        b=pqS6A9aSOfZNQa2YJbEpRQecb5/N/Fg3GafAHOsUXbZLdRq6DKNQly/Wyxi224WBVF
         NSBoZyDTfTvxoq3CjVYWcx3/uwpISGrzFy8pOwm9pSn7k8sJ6NlMHCfOZG3bJKlql7z4
         0lG8YzljpsGJotwrgGZB8kMV3UJr5/fu1DjvL2J1UGGylbWqjOMVSsqeBDrtiyM1hW4O
         YnDmXbAnlhqy57SUpJhrVA94tw4p6UhGboREm5MyRFPVEPzFCBdekQEpmdvolFCixvNI
         GN8XF+5epSP+0vtGUCtz3G0nx+c/K7mbwOLB70p4I0asZ7Cx6WvsR2uLUSIDxwcUPl5A
         +h4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021832; x=1741626632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RV6G8AsPpZM1XsfZjeI6zZRAfM93BJc0/BH0p1ZFFrU=;
        b=CYE9OuN2oC/c8w59pfweL64TIWFX0CaxO41KNEz0YwljBnGXFI99s91julXWhFkUeX
         N9xq2Nj+JpWDx6d3ooWPHo45v2oqJJs4qnCjco3RLwHds7XCpzf5CyyOwc2uVOJAVm5F
         8YdDl97Gm03gTnKQtg0yn5o4uRiapj79ErV4ThFxcc6ltwz6mcsla0+9GSsxRWNgq6KK
         tp9UzjdP+x06u0VKMrxNiuW9YO0CBXIoN2y9aygfBCcgqUeDg2u24GOc6e7jieFm4S1i
         q3ueJR6YjPu5axdPmVXhp57Se3Yp4Ko16xuYqTtV6iTmPSaloGe7l0Qh8CfB9vhkGLxk
         UvGA==
X-Gm-Message-State: AOJu0YysFLqAkySx0K1Z113T9cjb5Z9l9W6WjLCPGXFXsLbImCIGCw0R
	+IhygM/tm8Yu6pwD7UTHa2QAQABxwP9t3NcjLZUDykJCpy0kuKvmtcB5Llm3mBewnxmhsVqoAy1
	qvu+m+pE1YQk58Lfsao+3Mgo/welRQPnsUkF6MmkjAeQWlXtMe0RAqjsuoPlT+0L6WTwtoaNmSd
	vjncqSZ7prMfyHqeysWWPusAk=
X-Google-Smtp-Source: AGHT+IEPkwrqgZz9F0LOCGix+An6bf7Do2qKk7ux4Yk25RiEez6hyNid1EwZjrwsbgErCWJs0vQG+9fB+w==
X-Received: from wmbep24.prod.google.com ([2002:a05:600c:8418:b0:434:f1d0:7dc9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:478a:b0:43b:c7bb:84ee
 with SMTP id 5b1f17b1804b1-43bc7bb85bfmr22679895e9.2.1741021832556; Mon, 03
 Mar 2025 09:10:32 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:12 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-9-tabba@google.com>
Subject: [PATCH v5 8/9] KVM: arm64: Enable mapping guest_memfd in arm64
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
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..b3b154b81d97 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1543,4 +1543,14 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM);
+}
+
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
+}
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
2.48.1.711.g2feabab25a-goog


