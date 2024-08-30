Return-Path: <kvm+bounces-25448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B65965679
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2442D1C21DA9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5100F16C85D;
	Fri, 30 Aug 2024 04:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uM4sb9YC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AB71649C6
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 04:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992585; cv=none; b=E/ohtv8efRG9MtnGaaDRVxXXQ+HxKIPRBK102F30bwykdiK7wdCocAvVK8QMSn8HOd3fK0bFaX7dDYUrA0oxEfxKnVArfUjc3rkrneLZzcRtsiz3aETO+aFrfdHuT07XLG1GQ6OiVl/WZfpdWpY81MdK65l/ee17YziDoBzTyNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992585; c=relaxed/simple;
	bh=91b6MHuQTYrC/IH7LI/hDXxUWGMJ9NnNXDEb5najA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmLcX903WL75NkQ8ztDzlR65Tp0p2vuwDvwwUMbDeQVso8Gg0Udor0N8QECIo98r3+I5LVC6fHCX684feFMiwCsR7AYuzw1bG2kszZNtJiYZpQNO0qLq2ISAJCTEzk/1fZc3aku2tSkHJ6rxJgR6Qb/uCVBEccM84w1JhDOWzEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uM4sb9YC; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4629210f2so727247b3.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 21:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992583; x=1725597383; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TE+5gi+Y5s2UjnUAG5iU9KHZtarmS/zpW8eo5VQ9zdI=;
        b=uM4sb9YC62KVfp4ZuIcYAVG5FurDa5l/OTG43w5oL4vpxaVgbp+FoMsLbNmIyXHnf4
         Vyq608V8gf7a2Sy99U6DXLa55BUWP+zm/HPJmXFmPDKChFwXC0ClCHWutiuttyGsV+7o
         0fKjSnCx+JwluHqEYNycuNiVG+Yd2+h4wqgyPSPvOpW9jtxjOFRCxuMy61m+gYwTzkDu
         BKx82KpNf/dlG6Z0KWqC4pStQc3McEMgqQb5C+aHQ2FvIN39mz9RoZCvQre4ZFQtp4Y4
         0680e6zRYxEKrF0fW2XnulhUUqn8lfcSd3cP0MLu8IAX/zTTVTyNIxEdRJ2FU/OO7biX
         WMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992583; x=1725597383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TE+5gi+Y5s2UjnUAG5iU9KHZtarmS/zpW8eo5VQ9zdI=;
        b=EQv7xDL3JFvB8E8ndfkvpOqxNGnLpM40kpeJ02l/5XQBLrOw09Bpxdr/KXB+1R9suE
         /AMoe3zBd/msL/FleQWZ1TiDsZin1a5NfU89rgmYUtU/ybKWvzDHNicPn8CLcfLyguAl
         hAgrkObG73ycocsvv7ui7b9V+ks1S8VeYMcejNJAA4k99Y98SpH1NhkvSp+hetr2Je9d
         L59fxqWDEYoH99lF75i2FHLCZVVBykWZe4AtBDyEBjRzfyOJBHtMwyAOXRV9cmKj/DSm
         g9gNb7YH+Q1TY3AbMAFCy/o60hYhXmarOZVyMbtuuiJmQYo0bliU0xqDFpXzxwyKwpJC
         DhtA==
X-Gm-Message-State: AOJu0Yze4J/u1Gvhspa4ncZ1WjDOKdZo5m2fKvgX9ZydSD4mMoFbKzyW
	wXnRKajfnuGkrxi4PaKMUKdYXH0Bwmg2/X4U2VE2Px9+X95sVBDCjiLUvR9uUBlVvLrcmajS98I
	vUA==
X-Google-Smtp-Source: AGHT+IEXYjrPpdSD9GCwnZ0KjOxH9R7+gkyemXpF0saWXSC27VIOQKo5mk3or2G4Gxywo/W1sZdwv4+QKmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:dce:b0:6d4:30f0:3a74 with SMTP id
 00721157ae682-6d430f03e05mr846777b3.6.1724992582796; Thu, 29 Aug 2024
 21:36:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:59 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-10-seanjc@google.com>
Subject: [PATCH v4 09/10] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Define cpu_emergency_virt_cb even if the kernel is being built without KVM
support so that KVM can reference the typedef in asm/kvm_host.h without
needing yet more #ifdefs.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 6536873f8fc0..d0ef2a678d66 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
-- 
2.46.0.469.g59c65b2a67-goog


