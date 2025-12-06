Return-Path: <kvm+bounces-65443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC832CA9C4B
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4421317A4B7
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CCF3191D4;
	Sat,  6 Dec 2025 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rZWn5fP9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33330EF76
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981807; cv=none; b=sJCgV+401LiE0sz4Dsq/hVWi/BoA+VtzD0au9qjBPpAje06Fau9/l4qU8D6npCpRo7aiv8etD7vLrMOEDqQlk3bVMMKLtbTftJBXZtaFgomza6WJO7HqgHeQAPYlj4z9RJWDCU//VPtn+EHg61C0p/1GHn/MtovMEr/sfHPtlaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981807; c=relaxed/simple;
	bh=pbeH8LNWRQpzMlEyGGkl5S+63BtJtdh0+VAu1sigjKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6LwEEVV8s7LXoZxpIEWGgcSEM//qDVGDbRMs7+7cA8y61BZqCm55W6GwBiUMX1+wEpUiRdxx52+xP+NZv4vGGmCe3/P3qyjlPxGkWwWYAB8EbAqc+HhmZpefV3hrAIwbwrIcrP19hrzIpZYjXSU3OV/nFUlyn8/trp0j/yPe0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rZWn5fP9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7ba9c366057so6737876b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981805; x=1765586605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YksvQLfy9DrR8CZlxz8+Z/GImZx6Zf2V5Uv3+ubIzfc=;
        b=rZWn5fP9SV/PkLnb1sbdUUP7MBnwS9xWa2YKO1qrrnrtpQ9R5u2+hl+vfaqCz0IHL5
         kwYRX5XY5qLoT6rcR33nd/VBzU5JtnHuRZnAq2pZM38HhCr/rr3WkAMOX0SPFcf6340Q
         lcCJJlTOXQnSsIFnqDCZPWVweSkIWfsWsKWFiWxWCU4q2XNeVN46WhpZN6CUMw2cm+5/
         eJI4arhDi/07QjCkotMRebPe1wprogVHNgd6g10+ICFoNRdP8Tv9WMNY5bVIsQfz+Lak
         mPwp88jkxpkby7tg7TUaLlZhM0cRhJaTdcGAucYMEMiH/kDfrfPhXUHSrhdGsistCZrk
         9Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981805; x=1765586605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YksvQLfy9DrR8CZlxz8+Z/GImZx6Zf2V5Uv3+ubIzfc=;
        b=qjOJqnlcvmIL8h+lkUIfWZw1iHmSSh6YsThph+nPgFTrBc9I53sbHP6wz+F8wRTvGo
         H5FymxoC26P5DUv/OC/y6iGwZ6sizTxku42SRDb1lTqln/tdOQLzoxpf3vjZD0nEJpBx
         Fzoz+heikKx8gU7hFOejVXOfQbRKSlzXKt200daI91qZscD+RRvwrVSD4shkad0GPFW4
         J0ehjSQy3Mh/NZPo5j23tjAQgwe5pmLhfPYMS0xJYIucYEkQ1oE/PAFA5DocUVjdnN7X
         6HaJNt0EyDMwOKgo9cagkdsqTW99lfOjN4tVV2w2pmWaOf7w7uQW6WpphOiWB3dSyC7Z
         5IYw==
X-Gm-Message-State: AOJu0YyG2nPoJVByb8KLyKXZOtTC7pCPHKqeSB/keXyLM+l4eX7GzEOp
	m5xNoXr4Mus5Cas3ok7tcY5JTgOuzQGhJol92dr8eTsmDxcEJcCEoUV4ORSiI9DJnG62wiG3XXs
	v+pQ5AA==
X-Google-Smtp-Source: AGHT+IFGmCgdoD3o05gboaUqgsQyf8ofZu37EtjQefmfWM4sVLelG6+BNA+RyWO2uLV8uFYufmr7arrMW5I=
X-Received: from pfbei18.prod.google.com ([2002:a05:6a00:80d2:b0:76b:f0d4:ac71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:849:b0:7e8:450c:618b
 with SMTP id d2e1a72fcca58-7e8c6dabd9emr791597b3a.34.1764981805043; Fri, 05
 Dec 2025 16:43:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:07 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use
 KVM_MAX_IRQ_ROUTES directly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Directly use KVM_MAX_IRQ_ROUTES when checking the number of routes being
defined by userspace when creating a split IRQCHIP.  The restriction has
nothing to do with the I/O APIC, e.g. most modern userspace usage is for
routing MSIs.  Breaking the unnecessary dependency on the I/O APIC will
allow burying all of ioapic.h behind CONFIG_KVM_IOAPIC=y.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.h | 1 -
 arch/x86/kvm/x86.c    | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 913016acbbd5..ad238a6e63dc 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -10,7 +10,6 @@ struct kvm;
 struct kvm_vcpu;
 
 #define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
-#define MAX_NR_RESERVED_IOAPIC_PINS KVM_MAX_IRQ_ROUTES
 #define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
 #define IOAPIC_EDGE_TRIG  0
 #define IOAPIC_LEVEL_TRIG 1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..f582dac9ea0c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6717,7 +6717,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	case KVM_CAP_SPLIT_IRQCHIP: {
 		mutex_lock(&kvm->lock);
 		r = -EINVAL;
-		if (cap->args[0] > MAX_NR_RESERVED_IOAPIC_PINS)
+		if (cap->args[0] > KVM_MAX_IRQ_ROUTES)
 			goto split_irqchip_unlock;
 		r = -EEXIST;
 		if (irqchip_in_kernel(kvm))
-- 
2.52.0.223.gf5cc29aaa4-goog


