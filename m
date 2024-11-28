Return-Path: <kvm+bounces-32645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BAB9DB086
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 344B4B22C6C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC09F1DFCB;
	Thu, 28 Nov 2024 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uOTKb+Ub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4EB149DFA
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755373; cv=none; b=TBdCKVaYiJe1xXSYf70WxQm3aDl8z4INE8oUZ4zdowElVgyMW0PgvZuuY3spOvD4IV6nL6NtnzIngIeanZp4qm+ZM4nGxFEtv4rnJ+2EO3S0BSeNmTUhWnUN/M1tRbzBoRlRfRIjG6nWeZzn89W7KSfd0MffO+88Vd9TqTrvX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755373; c=relaxed/simple;
	bh=Pl/WDPJJFpEGoonemEpYTO8CqOvLteUalaJutLV+GEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=juz5h5sdYeUmerYkCLngDPqRoDbVmdRetSUgCTHN+CpSAq2D4CLagBvCa0ztdzLTv+YDEhDdaElebt0bBE0W4yXf1WLeOx5g4sIDEx7E9P5NSOPIJaOu9Vrv/goVMNhZfE9UveVTyAzP1i0/1Bc6WvI3HNmcEQ7L9wDey9TXlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uOTKb+Ub; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea28fcaad8so346573a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755371; x=1733360171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRtxUB7qEaUtLrlQ1xtfEnMmWvmcI3LuUmySZ8Q/Js=;
        b=uOTKb+UbcxVat1BTRDF5V9ggbfjlmpZ0OBVaMazd8wdph/IHUqaD65LuoEHySoEVmD
         1Hc5XTV2zhKDb2W9Sz/Cw9PeFAda/JDYOIIJwiS77sjbrWaq9OLblfy5j11AItqzCtal
         fpEx9tRnIcoa9PvLvyl25Om6Z6SmFqvKJnTpijJGSzIsuiazlNRwSmd1G/5z9Jvr7sOC
         NnboAYNkvkBFwkHZqaSW0zUMmUyzVmsj+Z+v0ZexOdIwIYARvbyumwDONvNJuIS2l3PQ
         ekFCmtBD5mb0wLtKLBXUuDmeVzbO41PTGqvl6DsNDb8DH8ce0SLk9Qv8BnDFoGYgQLzC
         nGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755371; x=1733360171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GWRtxUB7qEaUtLrlQ1xtfEnMmWvmcI3LuUmySZ8Q/Js=;
        b=ESSEu5JoKbyYaMM26IS61I14bFj/nPSqUfk3Upj8WL/PjclzSmMSDWtP1qNzeCqEzD
         hiKWvp5nQixGz5DX4Nzr6FNN9dD3oEZlSHsKiy6lnBmbYi8JEacvTqrBMbPrCy8A9qKb
         3vfNcpHYaaf+0pt29YwQCJFr729L9X3XWJ6GHu+N3oRP4unreEs4Oa35BD9OkQ/oVr2F
         eHpg9ZB8Ih/ndxs145ixlu4VHIje+Lhkht2VuTVTxu75LbFHmH5lkkGb5uxJqiY3z2Z9
         OeBJY0DOHf8dn3x4j/n05GnB7vJh+pcQMuvFLIGfgT8cfzOKijclHHsUF8bY91DGK10o
         VR/A==
X-Forwarded-Encrypted: i=1; AJvYcCXAVkxLwNgQZrMIgPsMiCJnLSwc15n/+Y1wkvsgsNU8QahmfsWdcYjdPdVbwfmrZgfbz4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxtMZ2kFfECUB4MHjMt+GwrUdB6lygU6sK+Rj3gLxM6jJMM0R
	BLyJOSvb4Qw6Eaz1yZQggqC6LMtSVf5a3lKkx2Avz+p9G09fC71qFoLpDxE2PiPlKO/WT3EpMjP
	2EA==
X-Google-Smtp-Source: AGHT+IFMaJnuqI9F/c4uFlh6+NRFxIyg9v4WX4blDwY4PB6trx1cbKx2cypM7Azi46JxvUwmbV0z2d3j/+0=
X-Received: from pjbqd8.prod.google.com ([2002:a17:90b:3cc8:b0:2ea:7fd8:9dca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2eb:140d:f6df
 with SMTP id 98e67ed59e1d1-2ee08e9bd21mr6479606a91.1.1732755370916; Wed, 27
 Nov 2024 16:56:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:43 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-13-seanjc@google.com>
Subject: [PATCH v4 12/16] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index c6bf18cb7c89..0918fade9267 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -28,6 +28,10 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 		GUEST_SYNC(i);
 	}
 
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		*((volatile uint64_t *)gpa);
+	GUEST_SYNC(2);
+
 	GUEST_ASSERT(0);
 }
 
@@ -95,6 +99,10 @@ static void *vcpu_worker(void *data)
 	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
+	/* Stage 2, read all of guest memory, which is now read-only. */
+	run_vcpu(vcpu, 2);
+	rendezvous_with_boss();
+
 	return NULL;
 }
 
@@ -175,7 +183,7 @@ int main(int argc, char *argv[])
 	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
-	struct timespec time_start, time_run1, time_reset, time_run2;
+	struct timespec time_start, time_run1, time_reset, time_run2, time_ro;
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
@@ -279,14 +287,20 @@ int main(int argc, char *argv[])
 	rendezvous_with_vcpus(&time_reset, "reset");
 	rendezvous_with_vcpus(&time_run2, "run 2");
 
+	mprotect(mem, slot_size, PROT_READ);
+	rendezvous_with_vcpus(&time_ro, "mprotect RO");
+
+	time_ro    = timespec_sub(time_ro,     time_run2);
 	time_run2  = timespec_sub(time_run2,   time_reset);
-	time_reset = timespec_sub(time_reset, time_run1);
+	time_reset = timespec_sub(time_reset,  time_run1);
 	time_run1  = timespec_sub(time_run1,   time_start);
 
-	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 =  %ld.%.9lds\n",
+	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 = %ld.%.9lds, "
+		"ro = %ld.%.9lds\n",
 		time_run1.tv_sec, time_run1.tv_nsec,
 		time_reset.tv_sec, time_reset.tv_nsec,
-		time_run2.tv_sec, time_run2.tv_nsec);
+		time_run2.tv_sec, time_run2.tv_nsec,
+		time_ro.tv_sec, time_ro.tv_nsec);
 
 	/*
 	 * Delete even numbered slots (arbitrary) and unmap the first half of
-- 
2.47.0.338.g60cca15819-goog


