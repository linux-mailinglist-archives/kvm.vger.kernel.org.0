Return-Path: <kvm+bounces-9417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A5185FDCA
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCA4E1F217A1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9929615696E;
	Thu, 22 Feb 2024 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="seCL5QQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EADC15531C
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618303; cv=none; b=Ujaee9G2C2AT6ZEHgd1QJMqoNqAA1/n9H7Hv3Sg6iiBGK3gDsm7laIVLNgIhggsilPVXXy17dgFO59OIqIp98kRO4azIG4ZP4wazU5//b+DpLBHiBQqrPIK3fyoJkiLWQfqS2WChcWjPR1f9ALOJAsBYzANoVnCjh5Gk90lzmhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618303; c=relaxed/simple;
	bh=npvYxmnOW8D70NS3ig9HnMx9N7r0Z+HXJuDOX7EAoRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HS68a1nr0BRXsOooiDxVjFhMzF86SklZvUssDuzC1zTEYJnK6qVWIpRNJQcEKJIMO6wNpKTwB6ia40YXWyw0g4GomnYNCrr46zmgkAHOvVngOpA3UvfzNkaKUaX+2Ogc0jX4+Tnbz2axISFkpaLqBbaHy74wSDR8fI50h7OSMrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=seCL5QQ2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso5312845e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618301; x=1709223101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rSm6/qgBZCczn9Ke4uZTyz+5iwS2nAcQPMledMHWGz8=;
        b=seCL5QQ2tYGGoFPLQxzu6TbhMU2DjHxfqV++HwJDh6gOj+mD3hSysXZ6PJkkG8g+75
         zO5CQCehh2JdwCIYjozYshFJG4OiWCnElmc+MSh8NTnWAZ9JMygKcWCTgEHGzihDhlVz
         3opZwsA8++fjLmWgRLw6sNcfu4RXiCP5Yw6RBbOvFoSx4X/AxJBhBLEltl3TpxZYcCZL
         ju50YUpXW3H5Uh2vXkq8W+Fo45r9ppier/CAs1E3TYOR5Ap1/FzXZvg71c2JGFFm0GsU
         ay75I4nyxpLQwWrXboO2yOOdIHrgBJHc+JxxzZOLMk5m4kecC1yL7RmHjCtZlM89oggW
         ZeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618301; x=1709223101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSm6/qgBZCczn9Ke4uZTyz+5iwS2nAcQPMledMHWGz8=;
        b=tLOxDf9XCba/LZ2GfeC9KvoPDRm07B9uKtTGYcBQIsIf7jIbDfRbUMBAsskY4gEnMM
         /3oW+7K7usb4i3VdCmHIa971zhT7+KK1Rx4858RYdv3AaB8Bdb6QXZpOCBRPdayG3i6+
         L/Kk0i1Iit8MkZFT1l+kAZEXmw2PrlSJsILPvJ6ekROgtOw/EEBvHQdC9x5pxw2d6JHu
         Auq53VfAG7fpPv6oJY39z+P+u8AHpVywujow6qYw8hcy7J8L+3LvPSKKDB1taF1W190Q
         mjIDf1PpU4EtbpcZqqVBuMLyej1yAtC0nmp4NtkYNt8OgT4fFQ2/cHEC1z+VqC6uHQFL
         ZMAQ==
X-Gm-Message-State: AOJu0YzIxIeCrWtkIJvRIi0/umAWyGaHJ7Oli4PQO+pNFFSyX7O+Y0g0
	or9SkQq6mssBrYdVO+8DwLPAQsGhLLKNrl47wPiPj/No9inteJ0JdYfNsMI0HR6kVUI+XgnQSst
	8akhFf/zPSPjfBP21VMuPvtbB8lrud2DF6BhAIg6b8bnuoOofJ77KYGQIJ29fbP8EoBpe723GAh
	ql73rdyfHoJW6wa0hfzobYCWI=
X-Google-Smtp-Source: AGHT+IG/y8W3lb3JZO83cjx58GKuU0Lq2tsDnMqCffsClUcUdbIHBL/G3lXuTAChtYt/zyPvFkyCvnNNLw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1e8c:b0:412:8816:3723 with SMTP id
 be12-20020a05600c1e8c00b0041288163723mr76370wmb.3.1708618300751; Thu, 22 Feb
 2024 08:11:40 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:42 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-22-tabba@google.com>
Subject: [RFC PATCH v1 21/26] KVM: arm64: Mark a protected VM's memory as
 unmappable at initialization
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

A protected VM's memory is private by default and not mappable by
the host until explicitly shared by the guest. Therefore, start
off with all the memory of a protected guest as NOT_MAPPABLE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index bfd4858a7bd1..75247a3ced3d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -220,13 +220,41 @@ bool pkvm_is_hyp_created(struct kvm *host_kvm)
 	return READ_ONCE(host_kvm->arch.pkvm.handle);
 }
 
+static int pkvm_mark_protected_mem_not_mappable(struct kvm *kvm)
+{
+	struct kvm_memory_slot *memslot;
+	struct kvm_memslots *slots;
+	int bkt, r;
+
+	if (!IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE))
+		return 0;
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, bkt, slots) {
+		if (!kvm_slot_can_be_private(memslot))
+			continue;
+
+		r = kvm_vm_set_mem_attributes_kernel(kvm,
+			memslot->base_gfn, memslot->base_gfn + memslot->npages,
+			KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
 int pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&host_kvm->lock);
-	if (!pkvm_is_hyp_created(host_kvm))
-		ret = __pkvm_create_hyp_vm(host_kvm);
+	if (!pkvm_is_hyp_created(host_kvm)) {
+		if (kvm_vm_is_protected(host_kvm))
+			ret = pkvm_mark_protected_mem_not_mappable(host_kvm);
+		if (!ret)
+			ret = __pkvm_create_hyp_vm(host_kvm);
+	}
 	mutex_unlock(&host_kvm->lock);
 
 	return ret;
-- 
2.44.0.rc1.240.g4c46232300-goog


