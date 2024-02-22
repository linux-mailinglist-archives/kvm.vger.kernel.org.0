Return-Path: <kvm+bounces-9420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82EE185FDD1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEAF4B24F5C
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35872157E73;
	Thu, 22 Feb 2024 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MV/lUdyO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC53157E64
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618311; cv=none; b=CGFZsuac3SfyFSZsiWhm11pZ5AA01xRzyRoSCxuC0ZdSAvEz2o477MCbvrT3oxgHTusVHdcVUYITjTQirvGiRzaSAUwjFcgqv3ioUY2idLvRLNSmfIUJN6BtYjvAbN8a8RZbjV2tPZ2e9+PktptweJINbFyPk9GGtY4zp9wQqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618311; c=relaxed/simple;
	bh=YBrnDawp6bZyspGI2hQIDfJydD0jLTVmORqgm+VO2Dc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BHN9Lz5NiuatszXEfkJ0Zir1pxNyBViHr0gK9Damw56nI9dvDf72STD0/B90jp4H/C+Yge7JCoHzy4RJSxEFY7DaFCn8c0XalCqmfdd0q2OCH3RrOtUwn1kdv5z0SG6H3L9uobft9BgQDkexLoX8sr6vyizryFPgZRPnpWRkMWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MV/lUdyO; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-412565214c3so34802025e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618308; x=1709223108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5VlGMXUi+EcDrZF93FlIfCnuiGyO6s7T7F5mtKL+TKk=;
        b=MV/lUdyOTjLV/nFpyDq1M9APodDFXZCdkJBtk+kgSm735gWgPg4UzWXgfa4f5cKzjp
         EkSrzJU7VbiGP/k+8lUch2H3LAizmYxtmb33tgNhQNjOLzb0F6oNnCJk1mJVKsMklYeW
         KA6lQWaVjBYN8L5WzRUh02KqDeAO/hE2Knf61K6cJ0idy97jbKDkKVRowvi8llfMbeWI
         Ipdv+4E2WK78fSKYPBA/bNNx5oay3HT2lOtXhPP2Roo3c3tbT7q5RQPkpn3STyUNctHl
         PSpeoZ9x3PCkMjXqkAjBC48nAMabkPACBBcbsjSDRfL25PAUZJ/4PEjZSFEIE+McV9tW
         F9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618308; x=1709223108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5VlGMXUi+EcDrZF93FlIfCnuiGyO6s7T7F5mtKL+TKk=;
        b=OPaEKVFiAeS9RF/sNZ2Flu7T+9QgdwLc4naA1KB0V16MudajzxtMsZMkuIBU/FNXnE
         nm+OvqFxWeJEa/ELZXp0v1QU1YQmf4NFCefmpiQQwaAlxJ7Yxkh92BqMlo3TGFOjqJwu
         fYBEavlrA64gZbSF1evwimtVzIFN2YXhv1Nn1QTjKUOnGmU2R9HMQQ8wqs9hYWBJQ2rt
         zRqVHfgxasRNkgH+al2hTehmxwuQiCuGJ0Sl40jScLiHJj7sNXtOXMFCFLiVXycstYGS
         aJt8VA6eJ29RDCBew4kgDP6qxkUNTFJAJR7xPv8vbXdF7eOdsvqw73RQBXmfcKeR5bHW
         jrTA==
X-Gm-Message-State: AOJu0YwgOpCNEeSBnO7XEuKsPjKRxlh7IyQUFPqaCkUci436PGjgGgiH
	JHicI8l9T8U4HW89jQRpElbCi/BUjeNYe+h9CLAP6Ot/JyR8WT+tjUFD6X6fWUk8rPbKoSreiY+
	ob94ULL1PQim1kjiDUm7Bxg41QTS7gghqqSu6B5lyxmaK2NZRpZ4vST5cp032NaoodAi3HpdQpj
	mKlPGA4GFNOOQH8+RJxwukvnY=
X-Google-Smtp-Source: AGHT+IEZh2i3xVzr5RH5C6aQFHYNaDDdKkTq/43Sh9IabnzDwlWzdxlyZWTjikkcJwda9jyKXlIPkxXZ7w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:11:b0:412:5cf8:4d81 with SMTP id
 g17-20020a05600c001100b004125cf84d81mr157882wmc.1.1708618307680; Thu, 22 Feb
 2024 08:11:47 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:45 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-25-tabba@google.com>
Subject: [RFC PATCH v1 24/26] KVM: arm64: Add handlers for kvm_arch_*_set_memory_attributes()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM doesn't need to do anything specific, but the functions need
to be implemented since guestmem expects them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 570b14da16b1..36de5748fb0a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2386,3 +2386,19 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
-- 
2.44.0.rc1.240.g4c46232300-goog


