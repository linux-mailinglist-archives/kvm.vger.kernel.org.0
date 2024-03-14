Return-Path: <kvm+bounces-11821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5B287C323
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23068287383
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5441A762F8;
	Thu, 14 Mar 2024 18:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u/efeT/8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D825E762E5
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710442511; cv=none; b=vACsj/wht8a5OpcnyLO70ijr3fxhmkTAGQyHPJ7SrbPPfxWZhAqgpjdI343/Qp00bnKrjM/0s3g1+zMoqOG80JP4TKY5XUzUWXqDt7A3+wYNGt2wv8BTLHsN1fZqiQOZrXtaQm+hm03sA0wAZGW+LNiu/wyLvY9VAbUuvnWEywM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710442511; c=relaxed/simple;
	bh=tB5vCpIDawJ2Zn4FC4jcvXThVZF9ir69az8ODScDTto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iCcLITxg0/nVhCM1Dir+4mkCsmCnT0GXADHO7vl6aUiKEvMG4XGF2PHRywa9enygrW397wndibMyJFtpyi429kdehmU4AXMhELJD+vKaHTQ4cF8zWXIqN/XTla6/yjIC3nIDW8DLhjCCr9gj2Ex3BO6rPNj8WHaFUoXAeaGk1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u/efeT/8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc647f65573so2187724276.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710442509; x=1711047309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=47LgpMdPt6+0tTjJu46B3a8kb1KpMWWpVGbXQ15D2KA=;
        b=u/efeT/8yYhrqQANmjQ364UC3bwKLszKZFvp2uiVJTQ56QdbnR7Ds4plt4zOX+312V
         YuLvkdmdy5S2rm9gfZHMl667xt8g0Q6IDsbviZFB8whvOUjRiQTIU6XoUxZpACgn+PXR
         HsYw2BduettdbDDXzcxPfF788y/E2tzsaWoDx8tsGgiBQZYZ2oqr2XKcC4nhfWIrVnN4
         RQnTlQppRnkXH4r+c/+XMIleOaRuIMzq6lAkGHUbLTHk8YAJD/UdjrGAj47nvaiPSLoD
         llWPrNEeqrMVlLWTISO/aaoeUy3oKReuxPKsOyjRMlAGofhMHvkBw4RGsDf7NWfqLB33
         u7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710442509; x=1711047309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47LgpMdPt6+0tTjJu46B3a8kb1KpMWWpVGbXQ15D2KA=;
        b=B8n+gXf/ZLHLM+hBrP7xaJfwoZ9vRetGTywj/Y9Nm1p2m/iG/mGFcyO7UjP1KnOdF1
         GOBVQi7m1Ql3ivDtjp4eIauXtyq/mGG5EnOAw+sQFVYB7Gf+tQM0FWMylNUWwgJxAkYO
         A1Gijt8c0chLotupblIBQG6bnWslkhmzp87s5wmBt/u9/x+nfKjFmTlPSMJav1T+ByG/
         Pzpi+5TTYsdt4h7tbszbW96NC1U3RAkUO3cwkHZ6B8WFRjv20V5dTdomtVRbDJ5OrCQn
         BnE9kKHS4Md/7h5zECKwPkh7ThwUftkrchRCkfYaTlEAk3bVCqCzjQsZdCkE2Rgd0cAR
         y3Wg==
X-Gm-Message-State: AOJu0Yy/wX/l+aGQIkrkt0cpjPpYkbYWTn1YZpxx1E4g+slabZJ+ovyP
	F+REwOedL6jGvicoVDdUqP0kt5y7EdIKEENDdX1+X1KUp9pZUlBHfn8Ml/lx5+i2uliaPKq4Sb7
	Kkg==
X-Google-Smtp-Source: AGHT+IFG1gwNWejmEeXNYIbGT5+ffFKp9NP8xWrD+Xcx7i4gHHpwj3Qo+aaK7DVPCOkh88w9LweM7mdd1S0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2848:b0:dcf:b5b8:f825 with SMTP id
 ee8-20020a056902284800b00dcfb5b8f825mr743146ybb.0.1710442508932; Thu, 14 Mar
 2024 11:55:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 11:54:57 -0700
In-Reply-To: <20240314185459.2439072-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314185459.2439072-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314185459.2439072-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Add vcpu_arch_put_guest() to do writes
 from guest code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a macro, vcpu_arch_put_guest(), for "putting" values to memory
from guest code in "interesting" situations, e.g. when writing memory that
is being dirty logged.  Structure the macro so that arch code can provide
a custom implementation, e.g. x86 will use the macro to force emulation of
the access.

Use the helper in dirty_log_test, which is of particular interest (see
above), and in xen_shinfo_test, which isn't all that interesting, but
provides a second usage of the macro with a different size operand
(uint8_t versus uint64_t), i.e. to help verify that the macro works for
more than just 64-bit values.

Use "put" as the verb to align with the kernel's {get,put}_user()
terminology.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c         | 5 +++--
 tools/testing/selftests/kvm/include/kvm_util_base.h  | 3 +++
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 525d92dda646..e3f67f4584fb 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -108,7 +108,7 @@ static void guest_code(void)
 	 */
 	for (i = 0; i < guest_num_pages; i++) {
 		addr = guest_test_virt_mem + i * guest_page_size;
-		*(uint64_t *)addr = READ_ONCE(iteration);
+		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
 	}
 
 	while (true) {
@@ -117,7 +117,8 @@ static void guest_code(void)
 			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
 				* guest_page_size;
 			addr = align_down(addr, host_page_size);
-			*(uint64_t *)addr = READ_ONCE(iteration);
+
+			vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
 		}
 
 		GUEST_SYNC(1);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3e0db283a46a..9110efa1bc12 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -610,6 +610,9 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+#ifndef vcpu_arch_put_guest
+#define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
+#endif
 
 static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
 {
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index d2ea0435f4f7..1ba06551526b 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -171,8 +171,9 @@ static volatile bool guest_saw_irq;
 static void evtchn_handler(struct ex_regs *regs)
 {
 	struct vcpu_info *vi = (void *)VCPU_INFO_VADDR;
-	vi->evtchn_upcall_pending = 0;
-	vi->evtchn_pending_sel = 0;
+
+	vcpu_arch_put_guest(vi->evtchn_upcall_pending, 0);
+	vcpu_arch_put_guest(vi->evtchn_pending_sel, 0);
 	guest_saw_irq = true;
 
 	GUEST_SYNC(TEST_GUEST_SAW_IRQ);
-- 
2.44.0.291.gc1ea87d7ee-goog


