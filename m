Return-Path: <kvm+bounces-48931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4891DAD4752
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49D4A17D1C6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C1C14AD2D;
	Wed, 11 Jun 2025 00:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FBdYXLxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73870825
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600656; cv=none; b=mCUsuWR/2rxLA2/9r0fDWnPFBLRVpVhFWfbmMbdR/zG9+2Re2vMCbIPKpiSiubn3yrh9g92PPT2UNyQi3t6IjCspifnUls79kYtjyNqczKZskki84grabKFQpwi7ZWKGRldbJfbn+8HS5h/WVGOWmvHKAxoWYwUcZvNR5pFgYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600656; c=relaxed/simple;
	bh=fi0POvxipHtqzuBmBtdO+vOuVF1CdKjDHYYgzms+PmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OXrkaM0Jnfb0RK78J/k3x54fdajhMAc9LG5HQ4HbE4qARdzNgH+cEcgRwVBtct268A62NT8D16Q3JJIn2NBFjLASfil4GcHycRIxNZu2GC/9QxXZ3SaoXMaBB+DxLSFggjetYPg/Fri9nInFeGgWIvUwu9+RmHUV3Fkb0v8PruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FBdYXLxU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25163so5171471a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 17:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600654; x=1750205454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hBjwKNBikKgFeXvQ1q5Ivd9CecF6t6Q9MZtjOeYYky8=;
        b=FBdYXLxUjexGN9WeKSZ2ecIhfrizQ6wveOJNH+ZsAaIruwbgxCgjpsI0flq2xKfa98
         11YaX4jgJfHh8uJMrMsyNQHFsguJvECRAOPURFonmQJOzrdqGH7IbAUN3c1UV5p4xGbF
         YyiYr5Pwb2S8XRcEHx5JjCk6sezF8NekBnj0Iu+KzCpULI2FnN0HuOfJaXNvYMIjepqF
         wh2EEpzu2IFPwVaFYTHP3l1QmLdszH/S7jMlItgsL8dWe917fSFxrYXJ6DKB6Ci/TkEh
         FxbREDhH/swhMb1LhQdHhjUYvmScvms3rSJz+YBCQ4+FZWCnHmSLLKe85WFCRT6Z0yia
         j4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600654; x=1750205454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hBjwKNBikKgFeXvQ1q5Ivd9CecF6t6Q9MZtjOeYYky8=;
        b=IJrIq+VXTMHrAJRqhxEV+E2qTh2p2BkLgG2O8Ck53DI5vveksSgJqP+UVPeI0Oyo55
         tfb8ZV3uT+/S5uD2Q6vtwHU2OM2OfNyI92pxa8kHjLlylUA3nMalHGkIoM3v2+mIBmyu
         6fspmlEtiHtqO6FIu4oyjj0NldbvhK93faZoZibkOTqc6QGJiPdV6fatDNzDKmRlHeDG
         12SmRRdqZBr89E/tEXhxJj6B4vDTnHvOt/pb+lt+GKF6bHuLG0ho8Y8jPPJrQkML+9YR
         LaGD8ar7WCsqfGiBzxJLY5xEKLO3yHx/yhN5CkKBvOhFYXx8oMIA6RejeOPNYNMY+831
         3tag==
X-Forwarded-Encrypted: i=1; AJvYcCVCvCDg/g8OkjpPuHT96SXmvdN8GtDyk21+JbTEaVo1sfNdFyUXyoaNBFsKhAK4nnSpBmM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtw0UeYgTJL0TUxTg9q7rcnsahda8Jh2eNoc9R4o55O0iZnzhW
	swgO+mXf3vxAgyh8sJg+FLL5TRDIy3MDXtPBi+wcDMR4oi8zs1xmprerZGv2AxusuFfVnFWbs+a
	eOBboKA==
X-Google-Smtp-Source: AGHT+IED4B4s7Ytoor8mnhgXxSS0ZKiCE28nENLHgtxurTVkQjPNLlNungxBpASYaT+z3Y4fvBlDrrKUUDc=
X-Received: from pjh3.prod.google.com ([2002:a17:90b:3f83:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc4:b0:312:26d9:d5b2
 with SMTP id 98e67ed59e1d1-313b1d9c310mr956755a91.0.1749600653718; Tue, 10
 Jun 2025 17:10:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:39 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: MIPS: Stop adding virt/kvm to the arch include path
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Don't add virt/kvm to KVM MIPS' include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that MIPS *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when MIPS support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 805aeea2166e..96a7cd21b140 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -4,7 +4,7 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
+ccflags-y += -Iarch/mips/kvm
 
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


