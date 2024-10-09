Return-Path: <kvm+bounces-28267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D059970C4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0492826C2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446E22040A2;
	Wed,  9 Oct 2024 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuaRRkWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2C62038CF
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489014; cv=none; b=C77CEymplDrJlkL0WrTPgVfzp3L9ABipthNPUPcppbD5wxc/JtbCM7UkAVDsxU4/BgUjIkOxgr4zz2StH0VdbvkQy3+zh4y3+wlkNhtWZwu14h7ZxNLXnGaAHCXNhGEd0bXb7B0MNR4HI8kDCGosX9y0/4qctkwyegJrrxo4yBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489014; c=relaxed/simple;
	bh=go2nSUoOu7DLGf2G03lp2uqdBfC+a2fqniLkbFG5GlI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g5NtKlcyFQKmdq5fQGe7/S25tDFQd10SPuBfsEzmWE07Nk5h9bEdGpqDqHbZ5rT7HRUXnap4ch76JRLIgpsg69kdhFwI3DeC3cfO/tT2Fsfben6fcMHEyUIaB4ywmkyNUpjpF8qH9w/sULN7IGGHvUM3lFWzkofsnkQL5XWun3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuaRRkWH; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so9598714276.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489012; x=1729093812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BR1gG58gw5F7E+LpSzoPu+wX+wiyja7ptJ1fl5K+zYE=;
        b=yuaRRkWHUpaQW6R1zC8KmVLk7LZ4KoXDgjH+7DhZZjo84iFhsXvBBB79W7zRaP80Ip
         NLCqRZtX3ue3+a9NZUgmp3fLL4+W7oEb8I+SI3PCnSj6ROXc5jYiyW0TggvtinpLCROC
         M2YllRT7zAUFeharTgVDn6boRcIM5SRusunlNhfVmbn0EDgmgU657KATjNKspJYTN171
         52wJBxY7gVldYw/EHt8Y/seBGyNRdCjXUxtnCl9pG6Vt1f3jBvCuEnneXNEvghIQHqjZ
         AiNqZLIFNi7fE0V+JlXdaj8M87POruZqgTn8pfFbRhapZjgg5BCdGNphVITLmNXqQm2H
         rs/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489012; x=1729093812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BR1gG58gw5F7E+LpSzoPu+wX+wiyja7ptJ1fl5K+zYE=;
        b=sRYBg0nTBrBoiCPHJUCf315IrDgXqAvWp4tjgx6A3DV4M+O6ZZIFeQlfpj38L4GLHH
         kdNXYDU0ZN+ZdVnoDREve31br5EjfdvWhDWbsE452Xhj9QEVxgd4W37R1H+Mwajn4oC9
         tlTNOCrqssPQE2gMXOv+IFDnwRlisAz7jFgDrXW2cZeTWOFttEvzcM5qdkG//0mjYZY4
         yGs7JkUNDlSBT29DMRpWDcFgT3sUDw3/jaEsl7B8FarKd7RHS3dRcryxYk9BNw8vINYO
         Pl0XCcmrG6cA47iAallIy1hGSpWFqRr5zO1BEPSQrXXKYqeBo4sdTs7JOAFxOPQ+CMzZ
         ZCAw==
X-Forwarded-Encrypted: i=1; AJvYcCW4RJlPFaucVaTrpkIrisWAqKPJj2f50iip4Qkt3cjFfoQO6KUGAIbCtl6ibVaK8qqrKlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjRSHs1WgAObeOz33CtwtoSMT+xbSsqGgWdpj+t77Q7AjbMQrj
	ppF8Ir5Fihq1W0+za8G34vcAlZxOEG5sSx2WpFcT8iGhYor7fzd7PR1mrXeggiW1+HTG+Cw7qTy
	ZvQ==
X-Google-Smtp-Source: AGHT+IHLwQuTuSKn2K83jzMORxhmnJG2QJIDSetKispH+vrqgQjqJfiOQ3+gOO6ZQgZWYqSyd9aEi5B6J6c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:6948:0:b0:e29:6a6:ed83 with SMTP id
 3f1490d57ef6-e2906a6f043mr903276.11.1728489011277; Wed, 09 Oct 2024 08:50:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:47 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-9-seanjc@google.com>
Subject: [PATCH v3 08/14] KVM: selftests: Compute number of extra pages needed
 in mmu_stress_test
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

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 847da23ec1b1..5467b12f5903 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -209,7 +209,13 @@ int main(int argc, char *argv[])
 	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
 	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm = __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
+#ifdef __x86_64__
+				    max_mem / SZ_1G,
+#else
+				    max_mem / vm_guest_mode_params[VM_MODE_DEFAULT].page_size,
+#endif
+				    guest_code, vcpus);
 
 	max_gpa = vm->max_gfn << vm->page_shift;
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
-- 
2.47.0.rc0.187.ge670bccf7e-goog


