Return-Path: <kvm+bounces-28272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C489970D0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E0831F2272B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C187205E34;
	Wed,  9 Oct 2024 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XGyWBYQv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A8204F91
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489024; cv=none; b=IUB0vmDWg6MgE9VFn7HGEK5jd6FZkHMK0fUF4S4o6g7HP8nfUGdGqdg1ZpIP/pmbb8p+irPwk6grKmoRF8xIwJdxJnVbeOqCIyRzj2KTmeK7DUZ2K3r5HRY8HQbv5bx9k/CDN3dtjwaY4UQQcDenoNfay0DfqG1bagJNcE+9Mac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489024; c=relaxed/simple;
	bh=L+zYpIw4P5/gRa37oTXv0c2QuaS7Yn3cq9MWxsxRKK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l2kG8erQ8FkO59uUGTyPuDu8onczyVuW602/FqlMLVaFniJ9p64Ja7SKsOBqYl86rvmIx7QUyxn5CYyuOD4YANWvEajNjhJgdFIn8u0xXGqli2LzRJOxH5VE3iv31eqlUIphP9gKp+CALtMjfztAHuJvLfPokGHe7knPw4NZyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XGyWBYQv; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7e9fe0a21a7so3418842a12.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489023; x=1729093823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EGuxTu/doK/WQ641h0uZhH1HM6LHjGgjZS75tNbw6SU=;
        b=XGyWBYQvcXRzOlkMt5LWPfjY3zmFTgna2TUiC1AeU65mDr2oJAWv2Q2DXshHtSlPYz
         z0VKn6qloPeO3PP3JvgH2byIkO7k1vknjYmM0HotPanr/A5AjPrQlZUvH+Om+EGtItUn
         JKdjSUUvcGxQw5Io0ydrmstWc9TKLdlhL+x+Gad52ArG5zG5ng7tF9XBcoP1wrfvAnHZ
         ICPEuzXjq+Gx/M1QvB91F1rgFJ6Mn4J8wrFK1FUKbXS92getUy0KkTa/cJn4pS4vgWXc
         hIPkic7pbrXRnPiMggAXcUsLPihADnwi8BBkCfiRw0aNM5C+t4OIiIXs7UyRA22I4DgB
         re7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489023; x=1729093823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGuxTu/doK/WQ641h0uZhH1HM6LHjGgjZS75tNbw6SU=;
        b=CZJ1Cvahcc4rBMIGRGvCB4RBM9CfImJ1oPXHSG6IhmQwWlgOCEF/10T5vi0H+w53bv
         KcVckfVIutXnNkxkqGkXHWW69oMtyxzH+0oSQFhKrv5hyZcE6A781kO9fq9/qityReyD
         3leaeYuM8U/9IMTwQzKD1DM8oxiDw3Zv0R6/NwDdKI026hDcC8018k9vGlAsfdxl8NG+
         EaMb6L7mKXl6id/HXXzciWsalA03TKtKj2qWMJcJrVOQv604eBWlkZxOmp1hefU0zcHW
         zpCQZ4b3oSXkc7uwhLV6uIouL0xm3V9HLEQcMLay83DDD4+4OvpaqTGA37ln71VDm79v
         0wCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJFN+UL3LKlPoeyw1C6XYrre6Pfts1OEeiJzxZXk3yhKxoufI7PVIXYbYYqx9j2qC5RJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzkSjci1HSjIpo7SEhHyc9daranYpNUm+D7XLhxdR9kHsy4lJa
	Z/lE/HjmwThClID3IPGi3D1jidsKgt5wviZ/l1JAIRsDhWKZqfSXqQ4D99Rg5zLUMZgyWTEtJhy
	9ew==
X-Google-Smtp-Source: AGHT+IG8czWnoykzOejAJo4GJw9hcMcaR/sDDZx+5vRUFyaEmI5qH9Oe9i56gZjLIllNwEPwjpmEWoICf38=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:704c:0:b0:7cd:8363:9f29 with SMTP id
 41be03b00d2f7-7ea320345ffmr3164a12.2.1728489022361; Wed, 09 Oct 2024 08:50:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:52 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-14-seanjc@google.com>
Subject: [PATCH v3 13/14] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Reviewed-by: James Houghton <jthoughton@google.com>
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
2.47.0.rc0.187.ge670bccf7e-goog


