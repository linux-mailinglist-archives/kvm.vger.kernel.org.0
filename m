Return-Path: <kvm+bounces-8718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88281855887
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F09B11F27F86
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25D779DF;
	Thu, 15 Feb 2024 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYlYTTS6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464653D6D
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707958816; cv=none; b=sd5pRDUQu1RE1FUm2bwS0ySMgeZNSO8yGZSmy7dszNnG37yKCzA20PCYvjzE2i4phuVUM/TZZUqkQnqLGkQ+oDMsSRzV6pM3YA7MPltx1zO6r38fn2YzR71hl0hejVisCaIg6BGlltrMO/7urtXQFjskgpfNX9E5WUgZc4kir1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707958816; c=relaxed/simple;
	bh=Wf4UDyoxn2kT2aM4troTO93XPUaqMcnsOBDPFbW/SkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TnQ6LmD/V1wPM3pmOvzV5C0LlJR210OGIQ4BLQ0AB8VL1J+GFWgqsekadu6/zwMRxxbFoSBrTShdZcYKpsKFh0D/zowyQ6N+m5Rv5JMxiHVfrV2E+6zG3o+vF30g40zcDjdvdIC4ObBw3XoDplF/cwbW3GevlwaFjKdoGXpJOzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYlYTTS6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0f6e2a44bso400111b3a.3
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707958812; x=1708563612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=THBGYEvhQX0rLSUutlty+Y9Xa/noirUlucPH6YPlG7k=;
        b=LYlYTTS61aYDoyYVk1Rn6qB7AKtPQbPvtdiVI5xm5zO+MfFVFNETmY3NT5HDAvMoJ8
         20ndF524d/cg50tNvpxafVHuzqzMBOMmbhyEzMUJcDZkgQLcdUQcumyxp+LYqnRWzT25
         psfq5vAPudyTDzYt/FowvBXyHCRprh3AZthk0DODfeaSNnE2AqL+WB4M4y++57sl1C6l
         XLQ2Quzy6iwpxNO2efCIEogsJa2jU4bIvWi64D/Sf7Wkdm1lJAVHmF0YRhtbVf8WmXmE
         QefMR8Mjx+yh8UvAUVvIlGopJbgD2MgyiztVvV5gAliZp8l0CM8CfMt0/+mTqZQv0/GZ
         AZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707958812; x=1708563612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=THBGYEvhQX0rLSUutlty+Y9Xa/noirUlucPH6YPlG7k=;
        b=Dnp/qC2ql/++i8M60fihbHXQYMkAze6hkrCFOzl1AOoH4gxu1I7V+k9ri5BqG4CIRu
         5yUoLIP30g8DFs91yy9ZaxQOMrVwCyFdnC/GPNwmzmhC/LfCCdVAuJKwpdYJ11AhMA38
         UEsOGxI1cz0gjoO2ZXlrMlTRPPiVcV1uDnF6AKso/TwqGEhkmZ87IywKXopGchLj8P7Z
         jRAyPBNYavRKM0G6uKfxhOEeO+Ws7LHhWKM1o//6dEygnOmhKgjm+I+7vBtcOKYxpKQ/
         7gJCljShZmjMaYLGXBodnps4MRVimgwcqiEl8BbOxeWbPlks/efRQyovtxma/ThLPpKb
         9hvg==
X-Gm-Message-State: AOJu0YwVm1gT+cGS+9dbnEFcQwwue+SCV5m7JTPC0APBATpMGXN7Mi4q
	+Bh+lXGuPIPIQCQpeLVyonIhXmxBZwWUpnTzdJQmfJSjfX4wMrStAyA5gdynd0v8YwyfiwQAInZ
	HYA==
X-Google-Smtp-Source: AGHT+IEStBd+icuQ7JfYkpal9lHt3H+yQK5HyweUIHDTPfNjaxBHmFup6/mXtTX+KtrfCtylz5irAboczJA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1898:b0:6e0:e2f8:cf30 with SMTP id
 x24-20020a056a00189800b006e0e2f8cf30mr36898pfh.0.1707958812693; Wed, 14 Feb
 2024 17:00:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 14 Feb 2024 17:00:04 -0800
In-Reply-To: <20240215010004.1456078-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240215010004.1456078-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="UTF-8"

Add forced emulation of MOV and LOCK CMPXCHG instructions in the dirty log
test's guest code to verify that KVM's emulator marks pages dirty as
expected (and obviously to verify the emulator works at all).  In the long
term, the guest code would ideally hammer more of KVM's emulator, but for
starters, cover the two major paths: writes and atomics.

To minimize #ifdeffery, wrap only the related code that is x86 specific,
unnecessariliy synchronizing an extra boolean to the guest is far from the
end of the world.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 36 ++++++++++++++++++--
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index eaad5b20854c..ff1d1c7f05d8 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -92,6 +92,29 @@ static uint64_t guest_test_phys_mem;
  */
 static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
 
+static bool is_forced_emulation_enabled;
+
+static void guest_write_memory(uint64_t *mem, uint64_t val, uint64_t rand)
+{
+#ifdef __x86_64__
+	if (is_forced_emulation_enabled && (rand & 1)) {
+		if (rand & 2) {
+			__asm__ __volatile__(KVM_FEP "movq %1, %0"
+					     : "+m" (*mem)
+					     : "r" (val) : "memory");
+		} else {
+			uint64_t __old = READ_ONCE(*mem);
+
+			__asm__ __volatile__(KVM_FEP LOCK_PREFIX "cmpxchgq %[new], %[ptr]"
+					     : [ptr] "+m" (*mem), [old] "+a" (__old)
+					     : [new]"r" (val) : "memory", "cc");
+		}
+	} else
+#endif
+
+	*mem = val;
+}
+
 /*
  * Continuously write to the first 8 bytes of a random pages within
  * the testing memory region.
@@ -114,11 +137,13 @@ static void guest_code(void)
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
+			uint64_t rand = READ_ONCE(random_array[i]);
+
 			addr = guest_test_virt_mem;
-			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
-				* guest_page_size;
+			addr += (rand % guest_num_pages) * guest_page_size;
 			addr = align_down(addr, host_page_size);
-			*(uint64_t *)addr = READ_ONCE(iteration);
+
+			guest_write_memory((void *)addr, READ_ONCE(iteration), rand);
 		}
 
 		/* Tell the host that we need more random numbers */
@@ -772,6 +797,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_page_size);
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
+	sync_global_to_guest(vm, is_forced_emulation_enabled);
 
 	/* Start the iterations */
 	iteration = 1;
@@ -875,6 +901,10 @@ int main(int argc, char *argv[])
 	int opt, i;
 	sigset_t sigset;
 
+#ifdef __x86_64__
+	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
+#endif
+
 	sem_init(&sem_vcpu_stop, 0, 0);
 	sem_init(&sem_vcpu_cont, 0, 0);
 
-- 
2.43.0.687.g38aa6559b0-goog


