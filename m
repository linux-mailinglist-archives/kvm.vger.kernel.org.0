Return-Path: <kvm+bounces-37856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8E2A30B7A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B699E1611CB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A63E24C66D;
	Tue, 11 Feb 2025 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kUNzIIwq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024212512E7
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275914; cv=none; b=g963REXjFBc2i4erJNok77//D1RzXwgQQG2puXhK9H46RYC3cL8yHbtsGLoj8kx+yqSrngb7+BphkhDYQlXgOlZetaoxc9oCFofKrI4YocyQppUn1STB2DNUdxVsSPBe2yPV9oJKo/keef3FMVgG7Ty/fvWRzXcBOoUqLzXJxtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275914; c=relaxed/simple;
	bh=Xjz8ZI7LqjSb0qALmI99DAbNRCMwGMVjteTHHYQ4dJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QL9n92iyMdsAMuFzPxW5RakyGhA6lAwWruLC/UcuDnDZk4sYAxGzPrUOY/YMSp+OBFXOkM+yAEgOOI9XLe2/2/ep22j5yunCTzKZo98I7D1anVtzoesKj3KRx4CE+u+ERnGtMUv14BtmcpwoUZ8zvGT8rh6svp1kqCPtIvqx+jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kUNzIIwq; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38dbdc2926eso245f8f.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275911; x=1739880711; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SmIo8QGaSGW4O/nm3ipq/SJW3NddPOH9GGmfIatxcE=;
        b=kUNzIIwqnbluC+H7Brm6hqJsAfIUzWP0idHXR+zDdKcBDeeU+vZbCNZkmSBPWrMQWK
         TTd9UZkwjGWBzkm5v9w3nHQU0/RnKNgOllust1F5/Opq9oWeOR+l2Zkoq5TPRy1TpkpN
         dCUBY8i9gMt68aiSIwPq6A0Httw+sqxjz9FeX9l8sjIE75UrEFvX+hDYe4MEn+ljvcGT
         0t3Oia28httljmZbpcFuLujRfVxyNRTQfEqfxqXy/UDeFV0dXKzyzoPaOZNY5IlLZeB5
         i08GKfc7d+vTb8a/KjkT1YIvoE4/YbzebixwG0aTFO7WtLcem4hHW18f9bSP8jDJk26N
         wkTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275911; x=1739880711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SmIo8QGaSGW4O/nm3ipq/SJW3NddPOH9GGmfIatxcE=;
        b=ePZ59aBSt0WbWgM1+xXqaIAOPrTjiCvkKDIitN2NCGn5uHGvUW0WzjYZVAuDNpEVoS
         jubZBBEJD8gPEz2+F1b0jCeULRiQ1bgeCkr1rkpQHRkW1EZY17wJcRQw3OLR8O/e63eN
         tMPjMESspr83uiN0J9G20u/aaS6mT99hMI8D/dcViQaoUqzCbqra0TDjEMT94MGMVHBJ
         vQyVI+hvb9WNkRdm2NGaONU6fPOEY8wl/XuhBt/EY3yaVJ/UaiDZ1rGfVcyO+jI9Wlnj
         3b8eeVS+wlZJUS0f6KZmdDRUKW5apcF7sci1XsYoQwN1PHeG6tY4MOvOx5+PZPYVuCjo
         VrbQ==
X-Gm-Message-State: AOJu0YxzIM/Edx8WzlmxiTANalqfdpFfMbZZIMnhTCAUbCnq+X9lEy5C
	VbVMsSzMu7HG+sHZ/2kGdP5VQVwaVEgmQh4cokem37RwBA16h8NUBFKddpeVpIbiGDR7qmMKAyF
	/VM01ZdpESEysufShA2sHs+p3y59cXgM88jCIAgvTXU4xENRa6RpV1t6XF++ZAY2/Gm7AblWH5M
	0UfWmDndPjYYHQtxxqz3qoX74=
X-Google-Smtp-Source: AGHT+IH0xuxWTGEs9x087sQRaUuSBVW+q25VqdZB2aOt6dDiT4Tp+EMY0I0pqw4sShmqWhjrTgxeK/obMw==
X-Received: from wmbay40.prod.google.com ([2002:a05:600c:1e28:b0:439:3e30:957a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:47c3:0:b0:38d:e166:8dc2
 with SMTP id ffacd0b85a97d-38de1669178mr6366905f8f.16.1739275911124; Tue, 11
 Feb 2025 04:11:51 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:26 +0000
In-Reply-To: <20250211121128.703390-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-11-tabba@google.com>
Subject: [PATCH v3 10/11] KVM: arm64: Enable mapping guest_memfd in arm64
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

Enable mapping guest_memfd in arm64, which would only apply to
VMs with the type KVM_VM_TYPE_ARM_SW_PROTECTED.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

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
2.48.1.502.g6dc24dfdaf-goog


