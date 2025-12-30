Return-Path: <kvm+bounces-66886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E0ACEAD44
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 620A33042FCA
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC6932C33A;
	Tue, 30 Dec 2025 23:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dt4nNH9g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADD63218BA
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135744; cv=none; b=tbca6zEf6Z0S2x5J6pKY6vEpfONv1oC+kU5ubLJBzMKTFs40xpTeqEHfLx4VVmRtg6XCfldTNn/06R1sdkvoENTlsHYXpulmubmuwscR2leJkxH6ViaKjeZ4YaBeCiSMHyzw1Con4IcHdELB/l5Szf0aQJbR9ASvglzML/bOZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135744; c=relaxed/simple;
	bh=urAFT6EJOW1W5qRLVZla3ZmDxnhGkG5YJibpWY0+6OQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c7FQ5H0F8R4BxpKvqagNitM96Z1Bqobiy/NTrc2ef3sdYLs5vMp4BgLZRic3oFuolkusUjkzgZZtEnwsibYlk7K619ZAtiYOU8pGsYTDy3wAhzl6rbOTFtRJulAAhTyyM3uZOedSnV24xWMSNu/m2nqYomcnc3eaQIvTdUSEyWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dt4nNH9g; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so9755248a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135739; x=1767740539; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=huRdRK/iPbU8RR9eXbhBU7huR1SivgrOj8/wOFgY0o8=;
        b=dt4nNH9g0idbSJAGh3JcAgXjqAuhC0/fSR/0PFd5PI5YoErvrN48GL136WPjYfGtWI
         kv3yIGhIrJlYaEY+gyMwwUeDrO2yrOdyrJSYDXLhhNmPHObYqCBPkdveosnKtUdEppYM
         DA03fmEatVqi9PRRLSE/7k21zL0nXwKAzXKcJl5t9ky1W8Yb8eodKa5p4buCAsx4GPCM
         FSeJuGEkcoBMdK4nQU8HykGAws/9+VbUmy6VqhBm9xG9l4JueqWHu97mibpZyI6nCVPl
         92Kyzp6MJPAmWAjI0GLVXejDOhaHoMZoze6e4mT4wgrQUXgoHyoy6FmKfnpML9Qh+Wpz
         M/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135739; x=1767740539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huRdRK/iPbU8RR9eXbhBU7huR1SivgrOj8/wOFgY0o8=;
        b=oCPaxG6xLnfRfCDAMP61gDi74OX5+DgdYgG0oai2oHoSrjZXgnZiVAi5bYuUel7iua
         ay7uQVbucSfYPZD6askEOkbcfhEFfAiJFDz+TvdFEhJ5otjHNVk89JKyUITE6aTgYtFA
         rpZavxWEL1w2Sh3NxDCYUAz9OjlRf3C7PV1KuIyvR0rcfQgDaM9oi/dnfApYn8u6zFHF
         JvmulZu4h8ei0KRHcBm9xUQ3HQ4O/+s9KvwVpWz8cHEj1RY0ZBHyf/7nXtWaENnJjT1P
         imRgBohA764FvCN66z7VGKDCe3yOnCliZ2nVoOJkstrIfcjOJXJH9NUWqQa081aKSlaz
         8T+w==
X-Gm-Message-State: AOJu0YztKh8tx8kf9gsVbK9uKy96Fhy9CHGuyIPh/3v+aggCANf70ABL
	Ajjbce2tKxGRBx0ZnRLhhM9TcmwrtrbRoOnJ+Ib/mCcT9mdyVfSeWZQqwUhD7djAF7jiHfE6sW3
	R0QeCFA==
X-Google-Smtp-Source: AGHT+IGZKtBCYgVUD+NyJMek1FLHVR3iv8QadOzR34XMxVrGwi8alAagMVcgqb3s54atcYK8jGvrWX49Hsw=
X-Received: from pjwt5.prod.google.com ([2002:a17:90a:d145:b0:34c:7437:183d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:580e:b0:34e:5516:6655
 with SMTP id 98e67ed59e1d1-34e92143ca1mr27682847a91.9.1767135738632; Tue, 30
 Dec 2025 15:02:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:44 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-16-seanjc@google.com>
Subject: [PATCH v4 15/21] KVM: selftests: Allow kvm_cpu_has_ept() to be called
 on AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

In preparation for generalizing the nested dirty logging test, checking
if either EPT or NPT is enabled will be needed. To avoid needing to gate
the kvm_cpu_has_ept() call by the CPU type, make sure the function
returns false if VMX is not available instead of trying to read VMX-only
MSRs.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 448a63457467..c87b340362a9 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -377,6 +377,9 @@ bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
 
+	if (!kvm_cpu_has(X86_FEATURE_VMX))
+		return false;
+
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return false;
-- 
2.52.0.351.gbe84eed79e-goog


