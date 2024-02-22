Return-Path: <kvm+bounces-9421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D06B85FDD6
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:15:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A074FB2B5C2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7DA157E90;
	Thu, 22 Feb 2024 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3zpILMvg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F0157E72
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618313; cv=none; b=iBzc4dUKH0Y6P5ZqbI+glXGhibhNRHmtZE7tx+3hUZUrr7I0RE4lTk98RxTi3VNYLbCnvR0yR3asb7/IW/PZldlKon3zLUmXbf1J+jS5YxHYeSsCzNI0c4b8bGNjH4n+C4P4QyvdYOq4OuGQFl9qJaYg/NBA3CQFVCyBhL8V6Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618313; c=relaxed/simple;
	bh=TUyoIAvN6Obzks9YjN2BA6l8SNXm7pOIcGDdO7heG78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dITprpLUZoxlO6B+7L4gqumLU1QqD9FrXRmxrpx9TgNvrvaebjOFTRDd81OrKXSNGL5Q8pcGyN9iU68rjxRKa+foQL6x9zlp9qO3N6kxpONdizCZ72pXluXZcrewbg+I+jLVmvMEQLSOcLCxriGR5vdUYQ/FCL91Oa/vbbwndvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3zpILMvg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4125670e7d1so4900995e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618310; x=1709223110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/q45XBasvpokurDmrqajFJwCgekoEBMYCvgW9GhGQo=;
        b=3zpILMvgSgMMYiXB5eVXXqnjNoRBS6ECEdN6LnoJ20MYT5+QtvOlQpBW/tjwGUryW3
         jfTLs3acLAueDqcyxHqLQ791x62azqHJZC0PzWk3LACdP6bNFkN7oSSLUga8GXaHY2T+
         9AfmfARTW3Oecn/FH5lkUnt5QSX1leSUjNQbAV1PEmDMz+0f8JrLMQ9py19CNxvJnHsO
         l8+XiMBjyRx9LVR1spuzhs8pXW7k/jAnojHsPKWapYirvpb1HOR3/yJwrg1/qI8NnK0l
         /45cUDSaZaCAFi+z9n0Qdp0bdLtJSl9Y+CDMGiaU2fl0Ua3xhxske4hXqpdjVUl6cB5Z
         73jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618310; x=1709223110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/q45XBasvpokurDmrqajFJwCgekoEBMYCvgW9GhGQo=;
        b=YNKjbpEqih6OBNHAo7FqL5zSCX4fIHHBrSu8C9gn6JGJjgfFyLK7JTbulvjrAca/wI
         j1Vl4c/b2pz0DhSuTMidQO9711PQtN/7+bINcK19Gb4qSCr6rF2IdHwE7Reg9X6U1vXn
         hujjFE+07Sn9Bd+BEuH8lmrF+8QJehlv9Jmf0xcroflfRxjeE17A0x3Hc38hW+dZi+Wh
         XWO712nwE+1hHxYt15vaBzMFfX8gdK/5iE/RJKpDmxj+q0E0Q1Ak7Wu8B0mrZGTMzNEl
         r0u4BS77WOsfbrQAF/KOqbitFLm+S5grbsG46xQJ68hdskKYiWTbwAYd3Vx+NKFNjRVM
         UGPQ==
X-Gm-Message-State: AOJu0Yzx44bqIovMKYRYa/R8tvxvW2rRGvutmEe2dlx4OAndm/jbuUFQ
	8MV80UWYBdYvRRBWtjDYHaCqbu4acfZlKd7KuxVN0zfxQilk/O5HwDgFLK4arGv6XFDlQfoiYML
	YSM++KPF5/MqB4qgAjO0G8HoxZEkEN4qjRSc7aAFzU9+C1mrWS3gEaRfLj8GOxqgdB6HEOMmEXS
	GYrEGr0dUmObO7YmhLSsGudUE=
X-Google-Smtp-Source: AGHT+IH2AJdryfzgBjtwoYEiaqYJq05TPCfxK/pLtpWJryi75TzpSiXs2AMbdpb+STC1Oqvl/vDFO15AKg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:a399:b0:412:7677:3e4f with SMTP id
 hn25-20020a05600ca39900b0041276773e4fmr136786wmb.4.1708618310147; Thu, 22 Feb
 2024 08:11:50 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:46 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-26-tabba@google.com>
Subject: [RFC PATCH v1 25/26] KVM: arm64: Enable private memory support when
 pKVM is enabled
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

Mark the support for private memory in arm64 as being dependent
on pKVM for now.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ab61c3ecba0c..437509b5d881 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1263,4 +1263,10 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+#define kvm_arch_has_private_mem(kvm) is_protected_kvm_enabled()
+#else
+#define kvm_arch_has_private_mem(kvm) false
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.44.0.rc1.240.g4c46232300-goog


