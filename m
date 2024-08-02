Return-Path: <kvm+bounces-23149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9B19464A4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68E941F22880
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF771369AE;
	Fri,  2 Aug 2024 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eTt1onKw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA001304BA
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631813; cv=none; b=QRXK12RZctBIUVH2KjY7bh/ZnQ49KEiWuQ35tAUAoVb7x0tUlol+2NzEhgg2ZOsEwcVDToa754J5rM/UyoJ3Q8MlCZXAlk++BDCHz/UAo4UebAlneSJLPSpWBa1w2GM2RC+sqnWpJmrQ4rre/0/Nz2TUgTBfJMxglC/R9wTOKjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631813; c=relaxed/simple;
	bh=ryVUMI2g0m5dQwWIHvd3/K7VFFhleb/XIi+fC2p2RwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=udEv7gtZDXeALpYBBwHmoxGU7LT9nvAUCSMEReJ21xOIeye2yhiH26rWfXhLf3PUQlB3BNNFAM1UDS011A6jihhpGwq9WKaw1QrgAx725E5QJsEPY7ihCGQorLOmqlkZnBwmX2s8SH+n8R2jqj9D46y2d9LNqr+Z1WJ66v+GUXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eTt1onKw; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-688777c95c4so50252307b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631811; x=1723236611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cNufUBVkEFtXyyJFRWhFP/HQuDK1gq9WLgQ7TUopaSE=;
        b=eTt1onKwprdYca0HS/2aoQgL1qcZHnLaADOYW31SCv1QRWhyqXAsOhVFnScDPoV0/y
         EEelP2CqjJbFlpDq0ywyW29rgkjnjWpZdlavEFPeb2RRrh6O22sLV00cqvT7KicxCYwv
         sWdJeSbaS51zFbyexNYRcWUuDsHWSVE+koaDiThmYZBR54b35GB6ocBm6ca0++2L4LCl
         VxTxl+9K1QQfl+xMnzFHaJFiNJX3/EZ/L7ydSN5zLha44GQntOj9BICEdKkigmsHJq6w
         7oahG+preuaNXGUlV93UaDiyFP6XfQ7SW9YDD4+5DSiszCFWGE9vHSUbV+qzc3uHj2XX
         4y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631811; x=1723236611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cNufUBVkEFtXyyJFRWhFP/HQuDK1gq9WLgQ7TUopaSE=;
        b=rQSAYAYthJ79iVYQo/2jDJvcsQX95gUdQlqlqiNQ0c/UblOKZwW5tZFnW9nfgzdqcg
         FKPbqp2N8Az5+W+kq9vk4590RkRS4lSJMrUg1Mu4KUI0O8xuZwjG+TYmKfhYlcMHs8wF
         LIbeo4UPzxk2o8KnSiAj/0r/NWEbG+GnTu2kk37v4iqO1pGFHTfyAF19PjzWqmLWhNQr
         7EJcQbxHjk40T5Ovw98Z5WRRn/aFKmLDNrnRsrlmgNQziVkYB85pK1ozPz6yuP3Q3v8L
         T9OrK5Njubo7wkGkHdMdRrHD1R5Hf4Bf6ecirnzaqSaJZ45fakzf/viAs1sYXIayhMoP
         NF7Q==
X-Gm-Message-State: AOJu0Yx9BKeyYQGSQZ8atpwgWst2y8hcMxz+HO/Diyj47tjtJC8yYbb+
	DSE6JPfQhDUNmwUJOBPyDt1gDQdylnNFNp76igmlWTQrAJ0WDr6YWffTas0arkxPUgAjeKA2BwO
	FWQ==
X-Google-Smtp-Source: AGHT+IEVd++gjv5JjjXYdrIQrBE6X+Wf+379il6l16mOh+D6tVdPpj/zSVq1nLbIYd7hetKBqRUwhCVXO90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:112:b0:62c:fb55:aeab with SMTP id
 00721157ae682-6896458f799mr3223987b3.8.1722631811375; Fri, 02 Aug 2024
 13:50:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:50:00 -0700
In-Reply-To: <20240802205003.353672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: Add a dedicated API for setting KVM-internal memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a dedicated API for setting internal memslots, and have it explicitly
disallow setting userspace memslots.  Setting a userspace memslots without
a direct command from userspace would result in all manner of issues.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 15 ++++++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..77949fee13f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12794,7 +12794,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 		m.guest_phys_addr = gpa;
 		m.userspace_addr = hva;
 		m.memory_size = size;
-		r = __kvm_set_memory_region(kvm, &m);
+		r = kvm_set_internal_memslot(kvm, &m);
 		if (r < 0)
 			return ERR_PTR_USR(r);
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b341d00aae37..cefa274c0852 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1179,8 +1179,8 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
-int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region2 *mem);
+int kvm_set_internal_memslot(struct kvm *kvm,
+			     const struct kvm_userspace_memory_region2 *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f202bdbfca9e..63b43644ed9f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1973,8 +1973,8 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region2 *mem)
+static int __kvm_set_memory_region(struct kvm *kvm,
+				   const struct kvm_userspace_memory_region2 *mem)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -2097,7 +2097,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	kfree(new);
 	return r;
 }
-EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
+
+int kvm_set_internal_memslot(struct kvm *kvm,
+			     const struct kvm_userspace_memory_region2 *mem)
+{
+	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
+		return -EINVAL;
+
+	return  __kvm_set_memory_region(kvm, mem);
+}
+EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
 
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region2 *mem)
-- 
2.46.0.rc2.264.g509ed76dc8-goog


