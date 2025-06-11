Return-Path: <kvm+bounces-48928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECA9AD4746
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ED313A87A1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76AF288CC;
	Wed, 11 Jun 2025 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YHmd2QqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C264A02
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600650; cv=none; b=eDHEUErbuUv2rAKEa+bTIqFUe5F03JwMLgwkxJgmp59r/p2ERb286uHgM3OL7/gmpcDFmd1xulk+UqNkIIjjP9+YF55xszFFYC6P9tTs0BJXazv0GPU2B6JTi/Sfnkz1GAXd/l6015w+P+hrFKkfxqvvI0Q7IhBTHQYuWO6rR34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600650; c=relaxed/simple;
	bh=PdsO7KmCqCXh1u0m3hplmJorUCeZc5tHsh93uffqrb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mcGWXzV1T4aUi6Ez1AXiuJ1uJj8jE5x74GUiKGnR0NxYbOedOLh6Uwj3O+weV4qsz6Le2Q6hB7O1NT50zR7yN92VSpNMupvODzXA3TVK6IIZgI+0/HAx+XFyoSOlVvIt2B9GyW15BTP3uB45dCbosoKyIIjCJKKIR69vqgsIGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YHmd2QqU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so2369160a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 17:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600649; x=1750205449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6JPxC6M/8C78oUmZk1MgMr9DeqlObfjqst+28w3sGNI=;
        b=YHmd2QqUlhUDunt+zqNDaAmvpE7XLaovrTC/HxZU0HcdaS39edc5bh6ep24AYAxGfF
         wEtBH4rvgKI0UzgNCA/jBNzvqon3jZoV4rgci3RS1LBa+x7M1pmfu8vU9PuTnXunexKT
         tqkrVQcbNSyRL7bxqRd1DdVnKYf5rzTyBXoNg1/anqmF2odvBjGTDe06tJDdncoYNLvn
         teEExX1lkFxqMDGCqnIS7Lkmz/zCzpn9iIiKUqrkhiliJ1GqzIPwTiYltOkuLr3k3Rc9
         187Y81pdQbmGkpS8PIRUKPUHLk1dagJT7X58npykdHB+v+SmjlodgSZ94w3Yf5c/QCST
         Fqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600649; x=1750205449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JPxC6M/8C78oUmZk1MgMr9DeqlObfjqst+28w3sGNI=;
        b=MOwIN04mhjxmiGALGXiq3ttwZ3pMqBb8DHAuYqyPhlx4vyTQz+wXGt2FM1VYbw3820
         YiO+mItL7yICENvtL/mqEozEvxSMuL8drncWY7B6vI2v2FhB423xWpUUMEV5MN7Qc0ft
         xB3LZeqbk0CIunv68yTxduxr/gJ5uO/LVmIWTNlzXmf+7gU6WOUHt1zWheFk2aBkPv4D
         IqCZaj8m6iQQ8a4pSoOii0u8FWXuOL/EQKdDS2Zfbi1oU53VvxhoGKmrc/9fm19FWt9c
         55TGm/dlSIMmfDBr5lWhTGZUZqrPAfFZXe1w8Q+HbLC4UuV9FWsldcZQsoaojo2eZpkY
         AI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXPcdLExWerD3FM+RxvQ1voFjkoDlOntUgGkA27SBzkqnfH6upSEQuqAItQ6Kea5st7wNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjjn8w9qdoK1QtPjRJSLdLuRsZTWSjD1/DxXiRM8VpyUTVKARJ
	w6SGn9LXks2Qc09ASPY6vSWW8q+epmj3Zv8dJo4cMtj50QG6WwasHX/6hyjBEtV0B47Y2Yz+KoT
	2rIY+iQ==
X-Google-Smtp-Source: AGHT+IH8G3icYEi+L3rUhxMgi7kY7xVjk4t0ltvPAXoSgaLu6NXS+iOsy9Z0A/wrYNq1F2Q9c5lqhoRbAbQ=
X-Received: from pjbsm18.prod.google.com ([2002:a17:90b:2e52:b0:311:c7f9:ca1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52:b0:311:b0ec:1360
 with SMTP id 98e67ed59e1d1-313b1ff8de6mr923707a91.29.1749600648794; Tue, 10
 Jun 2025 17:10:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:36 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: arm64: Include KVM headers to get forward declarations
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

Include include/uapi/linux/kvm.h and include/linux/kvm_types.h in ARM's
public arm_arch_timer.h and arm_pmu.h headers to get forward declarations
of things like "struct kvm_vcpu" and "struct kvm_device_attr", which are
referenced but never declared (neither file includes *any* KVM headers).

The missing includes don't currently cause problems because of the order
of includes in parent files, but that order is largely arbitrary and is
subject to change, e.g. a future commit will move the ARM specific headers
to arch/arm64/include/asm and reorder parent includes to maintain
alphabetic ordering.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/kvm/arm_arch_timer.h | 2 ++
 include/kvm/arm_pmu.h        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 681cf0c8b9df..22cce6843e9a 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_ARCH_TIMER_H
 #define __ASM_ARM_KVM_ARCH_TIMER_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b411..baf028d19dfc 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


