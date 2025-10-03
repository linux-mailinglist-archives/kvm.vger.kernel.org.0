Return-Path: <kvm+bounces-59480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C950BB8625
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84E3D19E2EEE
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D52F2D46BC;
	Fri,  3 Oct 2025 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XzJmGkOR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C328D84F
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533982; cv=none; b=TsGpEqnfqo3SPj5ROGVaXgH5+/krRnG/XBf6K6fjJqyHF0MvrpPUmqV1eJ1+KHZBs+XJHQ+WZbprdNxtrgAu6gAyHngyi3UPw++24ekel/lqidKit8mKj3Z4ENT+bvZsdQp4KomuBhpLdpl0d9Jp+r6lJxfP9dGyfmzjECkbUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533982; c=relaxed/simple;
	bh=eekP/dx3x8jqekvGeoDTkRGaGODTC4nEEgFN30UFNN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JHuBP1IhpvXJZKbn4vbQCGAURRp6ccgiMbFFGp8baxglxsrmBceOekS8JNOilbyfpuG/tVkdNQaoqE+cWD/yXKMcRQBuLTkx3UCECB57uvH3tiV08ySXM5GLq9wWPqwQJ0pEz+wGj6BkiyK71lK4KT/AQukp+YUv9fsVOFReZTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XzJmGkOR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-780f914b5a4so2668689b3a.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533980; x=1760138780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9k0A/wIlTiMIkK4NIRv5JkCn3UX2zyXw07XNqkpaasU=;
        b=XzJmGkORhOa6aGhus8ckD2NNPUfKdrr0e2j3SKKb2cmjpFPxwTl4MamyXKLRuNHWbf
         5lx97KFvPjtCSG7NNcfEc2Ds04NafrD6nahjKY0ZaU7kkzw18spJaVwLzef2OQRxOsSn
         nB969vqE54rrwI9DBIPuifITsglVZnGOI3AsGK4g0KPOMbAQOPpEOz9dble5HTBTmKHl
         VpNYS/RNQWOdgRQDBVUOoSRsSQFbI5Ofwgfa/aME+h6yO2nNzL82eke8HsUL3Lkyg0PK
         LUJR9DOCTxuTpUQ60h3+YB6wH8uBWJ0sItG2YQrjg9zrNR3ktcWITcOG+zAzEnWjRWdQ
         Y0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533980; x=1760138780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9k0A/wIlTiMIkK4NIRv5JkCn3UX2zyXw07XNqkpaasU=;
        b=pFVCgSLm2jyTx0PIDSRFPK8CRugYckJOGnU3AnQtGwygZzXGf+XoFtAhl2E4kWf1oy
         D2JIVI2ymRchlE3ZOrotCw9WzkO3Qq60Dm5+F5Ri6rnPLh1pAJeHFMQlnt9pcKRKKJCb
         fqvCl+7aBCJtUYv5Zii23z+0cgnTUT2ivoQmwtUPOLBbKItNwOvds8H8IeQEExed/A5T
         5sAh044geVb4rWPVsCFEpCA/ZfW5vY5lstDOS+m0C2QnzrcRkMJ6ads74um6kwomlHcF
         F6hHEVY3AFSb2vKGX0CLUBqRPD+jsoTmJ7ktQFTBrQquezFE8nmhwTFHFNTGBFT28zsM
         T3aQ==
X-Gm-Message-State: AOJu0YwdE8wH62p4iDQP7yRTDk1NS2KfaRFHQ2DIn7y3+CuIPMy0Nmm5
	kEoW5d+zKSOUoChozg+7vYpnnk1GH9I9kJuE6ZvbCLFRq0u3feEYlncAbIvvJV32MVVj96Lldqo
	j7eqEIg==
X-Google-Smtp-Source: AGHT+IH4nZpvTnjztjJocS+gtKNwmiitFnPO1cCK3pCOnqgiERq2oUPG+XolQgX15umxzn7SATNJ8PGMQ+s=
X-Received: from pfux39.prod.google.com ([2002:a05:6a00:be7:b0:77f:6432:dc09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d51:b0:781:2320:5a33
 with SMTP id d2e1a72fcca58-78c98d5d5a9mr5435952b3a.9.1759533980009; Fri, 03
 Oct 2025 16:26:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:57 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-5-seanjc@google.com>
Subject: [PATCH v2 04/13] KVM: Explicitly mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM_GENERIC_MMU_NOTIFIER as a dependency for selecting KVM_GUEST_MEMFD,
as guest_memfd relies on kvm_mmu_invalidate_{begin,end}(), which are
defined if and only if the generic mmu_notifier implementation is enabled.

The missing dependency is currently benign as s390 is the only KVM arch
that doesn't utilize the generic mmu_notifier infrastructure, and s390
doesn't currently support guest_memfd.

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1b7d5be0b6c4..a01cc5743137 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -113,6 +113,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
+       depends on KVM_GENERIC_MMU_NOTIFIER
        select XARRAY_MULTI
        bool
 
-- 
2.51.0.618.g983fd99d29-goog


