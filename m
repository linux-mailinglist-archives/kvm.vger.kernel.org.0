Return-Path: <kvm+bounces-39435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1084A470BF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B541716D9EB
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC06839F4;
	Thu, 27 Feb 2025 01:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BhA9oCje"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC57E1494D9
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618815; cv=none; b=A0+ODoKe3slnz4/RX4aqQb1zyDjTC3E3WPPbJQAq5ETj9TNp+0BhOJX4Pik/up7TGkCXIT5c2+Fpm7IIZGnF9uIpXUXcrympeAxSDZdCiKaHjY9jzldWd606vS0CHolv0EzlUrEhvwiGPkJWYZrAQmMLWFRrN7kbPhsIfnkKa2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618815; c=relaxed/simple;
	bh=uaIIITJgUawWH54PuijoRuV64Rx6tfBFy6BV8graBMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aHNOHlAhOGlxLSZ8RW+eAoucUjP23/elDD1Mukwqyum4UibvFkAE1Fhd54EBkkloAN2PuUdedSAaV2JvMkJyF/6JWkohDmn39dsWzbJSJ7sxndJEPs4pJvg9rFJGjA9LJ83jqEEBN0XNfqyxUTP3tLsqiPpbIp8gdyuQ/wpVk30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BhA9oCje; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8c697ec3so1794925a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618813; x=1741223613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4G+4qHSVJnaTG8aqakqnf5oS6XZxipCyWxhYCrPdMqU=;
        b=BhA9oCjehr15kGno0LTWWgc4p7eaPwWB3ylKyIhJDsPOoSSo+zFz+AK/6AZyNeXRSr
         Pvg74JXDg0cn3tvXX735xyTlfWjdwe7UvTYmoXPuf7TokuwufxBJWYmw5M3OJpJdNyEi
         qdtsE0yIaY55kKiJeQvv67xopm8b8bUpRyQM0nA5vAqD2uTsFYJMHz0Ov5ddi+YV8Ain
         KGphSBeyL7WEvWFE/1rFUhsCKQQwFz9H5rs50jooEh92bZsw7nz8C4tf31U5Xj7cP1Hi
         6f12bz4MsVgGethfBv2hMQkd/YW6Z5OzIi0rvto4jGsR3gVb2EJKwngdRqes3SLd09X4
         hC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618813; x=1741223613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4G+4qHSVJnaTG8aqakqnf5oS6XZxipCyWxhYCrPdMqU=;
        b=VsSCiKsQVnelas6gxxhKNOdbFEwur7VaYve+TwxcEhZXko9liKJYTMqQzu2hm2ak9w
         BmuEmUUsOwmEq+1VVsGkrmyD2NKgkRI43/B7wxKgkvvuo/akWLUHqntPOZQwxmhccEp5
         nfpQbdehIacsWilJ5A5ECXpyhLTst/34r31vO/g+HrylmJLZLvPgMQC3phPZUKxZIq0/
         dyh4oRPBZE5VficbP/sQ1pwl+Fw2Znu4u83b0niN0QRvlFfFe9D0JNdGYYnN5p/7dhaU
         HijJKaCXOoIYjlOndpjxe7UKl0hmbdkfoYXjiIwoh1PFhGs/RtrNjpNPKeXAF58uN5/O
         PgiA==
X-Gm-Message-State: AOJu0YxXtNQpxZ8uc97c8aeNe6LEQbsQZVoHiLXR6S1ugU2qgFTSKTsD
	0uGSF2hFN2gx88bL8KGoPzu+CzvXSV+QFzxVLnjgD/l621JPABD/JR+WhEGhoY7aPVnFSYOp0CQ
	DuA==
X-Google-Smtp-Source: AGHT+IF/0LojBvPM/mubJWQkN9zSmVziqMW9oNei9YATA6U+yuMtYGUbUTWyWB3moXPOEe6/3bNIOyIL5jQ=
X-Received: from pgbdq17.prod.google.com ([2002:a05:6a02:f91:b0:ad5:418b:c301])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:8402:b0:1ee:b5f4:b1d7
 with SMTP id adf61e73a8af0-1f2e387ef46mr2042905637.7.1740618813467; Wed, 26
 Feb 2025 17:13:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:13:20 -0800
In-Reply-To: <20250227011321.3229622-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227011321.3229622-5-seanjc@google.com>
Subject: [PATCH v2 4/5] KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09c3d27cc01a..a2cd734beef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4991,7 +4991,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10984,6 +10983,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.48.1.711.g2feabab25a-goog


