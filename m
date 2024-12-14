Return-Path: <kvm+bounces-33801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A8A9F1BBE
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F12131630C0
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C8112E5D;
	Sat, 14 Dec 2024 01:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kj/Z0Pmz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE23189B8B
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138461; cv=none; b=sgKgGLbDDt6hkSGmAOmkxAUjnyi4fOku0+aMzuaLs+zM52yL0FiVpQWifLdvT4r758fuaaMdJ/6vALxTZnNCQo8mSSLTUDdpzvhinczM13S52Esco1JLKgUKzKsyZxz3l4DowqCyB1m1UVU8VB/7gZZRv/6pQ4e9ZPdxKzDtat8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138461; c=relaxed/simple;
	bh=OgTTk595VIyjaFheqBqRfYqIoPT5CZ9K1t127fuPGa4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b4DY+rqsYLff6S56QIzFbs3QhXVd/MgFoX9v8zjrQ5B+vcuUPIeyBd3e1UXdehvj6T77GDfFhA/awQJNa7mY+I5DKa8mjVCLcEM1QI576oXA1wFalSOzK4DnEtb6YoYGdmggBtZcddiTA+srZYU815rLFxaJ3TcGzJJhzbIDgsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kj/Z0Pmz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2162f80040aso20220595ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138460; x=1734743260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FAzPo3qg+GcWGQlv0+FYKxHsP1523EqIgag6kKt+kTY=;
        b=Kj/Z0PmzldV5EsrSdmlgEl3jWCkgez3RBbLXjpSLtjzXHU11QUAQbPcFW+o4RA4JGu
         BopPNu7GSdoSCPgJkOVL3WkKZLUWrjo5WH9P2Dnh6vtWmW7ZhYonpCMUcMEkwEBi8rEa
         4Plr2MVpg9q3hWEhCbw7PZQZkc0q2vX21/omy+f7sO3KFbd3PZ04jpnpHKVJm9Hevymu
         QsgY7bRrb8nCrv/Q6xBc1+w0+2VkzHzZsDRzXh4CUUSzkDQu+hN8aBgMFbjRTIZcXSJG
         r0srUFcYfQQcYsifZz0RWCytyMW19mF8QTsiF3EG45Craq3yCQ2hh9WBI7rWMzwItHlD
         2Ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138460; x=1734743260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAzPo3qg+GcWGQlv0+FYKxHsP1523EqIgag6kKt+kTY=;
        b=WRivsoO1aEiv3umme6IKueGetSCqGRgwZaGXcHK3PwLzjyRHjecI3F2Ig6wKduD5Sv
         Z/mBEbZg67w55CNUIgY3FaD8Oi/J/rTDxYiUUc2aVqRMiWzJjqPMuzGVOWq4yHgzMehY
         YmQfw/FLjrzI5sQ/S/M3KKY5yLMg748nAJLM/0tu5MqCGYzti4BZ2ksnn1WBlg2Oxnnu
         42PG/N0uUaSDSHhPW1O5SCUE3z1qrEbva3bnuNX5CQ0alfZRCVf6iHPqwBdVu/vd+A63
         rvO0UINoiy8mJ3xUOKqJ/J1e771bPspEfo24sGrcFESiW1OJtlsNPCiHw0mh1U0RM48R
         uCrA==
X-Gm-Message-State: AOJu0YzmA70z6SE4d/FjSF+XZgGSh+FOQe9mNcussp7Xq7GNi5jXTTWb
	hlwQ/H/KvT+XC/5g1vfWoefe0Bv5UOF3zc15q8UYEICm8b8Q6ZhsJsdp3OLZyiNi3Iihti6+BhB
	sYg==
X-Google-Smtp-Source: AGHT+IEx6xV8z10SAfTW31+ni8NBIZeIzTyZ6UR4kfmgK36HNJYqi0QxFoc4iypAwYbfX3m4FftoXPhh3r8=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef49:b0:20c:9821:69af
 with SMTP id d9443c01a7336-21892a40599mr66605485ad.45.1734138459850; Fri, 13
 Dec 2024 17:07:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:10 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-10-seanjc@google.com>
Subject: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty ring test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the vCPU doesn't dirty every page on the first iteration for
architectures that support the dirty ring, honor vcpu_stop in the dirty
ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
periodically exit to userspace just to see if it should stop.

Add a comment explaining that marking all pages as dirty is problematic
for the dirty ring, as it results in the guest getting stuck on "ring
full".  This could be addressed by adding a GUEST_SYNC() in that initial
loop, but it's not clear how that would interact with s390's behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 55a385499434..8d31e275a23d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -387,8 +387,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* A ucall-sync or ring-full event is allowed */
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
-		/* We should allow this to continue */
-		;
+		vcpu_handle_sync_stop();
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
 		/* Update the flag first before pause */
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
@@ -697,6 +696,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
+
+	/*
+	 * The workaround in guest_code() to write all pages prior to the first
+	 * iteration isn't compatible with the dirty ring, as the dirty ring
+	 * support relies on the vCPU to actually stop when vcpu_stop is set so
+	 * that the vCPU doesn't hang waiting for the dirty ring to be emptied.
+	 */
+	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
+		    "Test needs to be updated to support s390 dirty ring");
 #endif
 
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
-- 
2.47.1.613.gc27f4b7a9f-goog


