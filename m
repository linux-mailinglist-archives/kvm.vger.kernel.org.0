Return-Path: <kvm+bounces-32640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC409DB079
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8D8CB230F3
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CE813B7BC;
	Thu, 28 Nov 2024 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwFi3Vqg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B57135A53
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755364; cv=none; b=tIfwufx5959X+bYFpRfKNt22EkgZ+kO6J9XZ0HFdRJHXmBNw5DHkc6pl/mTbK48G2a4nOfkjq3rhNaXu6/WokXdXZd29zlhnr7Kv2nKLfXeT7VIlVYTH/uMz+oskE+ikk5GecN0tcNDswFFbftv+jR5KIpG9YBm7NgRHeTGFh+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755364; c=relaxed/simple;
	bh=EYB3L6b74MhfJrPzvb7T9WOOU7QX9pbOjbRmtOdicCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPL0eiqUciC5U5phs/cBSTQJJSCwaV/uv/hhP/09WFBz+iBc3NBkFAp2vdtzi5HtFJ7U4ekg4aCnND811sQV5WyYEdLDCVbvyt9Cze+T0i/4cnsu1c2FX7XDdbjHO0BAx0KEz6/YxvVRfspvpkWXsLzmGjbJymGzzDOEi8MCkh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwFi3Vqg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72535e4b30aso337401b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755362; x=1733360162; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7/2VfJdiek5/ConUN3oh8Dq9U963aWvO6yCMgPFkp+8=;
        b=cwFi3VqgyVT749tieMTXYIF/Qk/99w7cG45MGFJ6SGQOGQe1tLYt/xlslTyqVNAkM3
         ByhjIRaFW47AJXqt7Ez04Tf7AWTU2iKYHlQQRiEPVfrQOe8Z54dRpg/0pygVlpS+A+BN
         CaPGnEr+TwOqgDe/wTwAmfS2ddQ5EW81ZQImfCzQW+SwKTQQmhN9TBL6mUXg77JaeJrk
         9iFxCPFxQ45sE5J9RGWBlbMzDQMA5C1IGTHjC+SAonEI9Y1ulFWAKMp7P58MCxbMfDuE
         GTDIfVMGlsai311I7VfLiW3L6CZFr7eAHLPTc50Ng9bpjFa292ZyMTAIutyw0mgCqDgz
         /cZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755362; x=1733360162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7/2VfJdiek5/ConUN3oh8Dq9U963aWvO6yCMgPFkp+8=;
        b=g1S9N00tUHX4c265XBA2lvch7zS9FtuB00LkvvDywldV8qlSKAi2x5u5H3iAOJ9mwH
         WSkPtxhIeoH8/hK6Ha62IIrGv55vMz1uWkl7z55X96EW+U8Wnp1h2F11encEuYNuu6qg
         B4Gjpjf3//v9Djv3rHTienp8bX33fQhDlKX/P13wOPMBpdG8MLHmtx1MNrjSbe/2Fgx8
         uXKXmI2q6cjmaCJa5p8tah2EbCDDQFWidqdTsTIfZnMCs94vXxXAtcRWMgTUXdZwNRm3
         8sbXMDsFscd2Dog7XW7s2hZi6YPuAi0BZO9UdF4v82JTijNw4HGMgOMgt9ugl7UQDm7n
         5d6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmebIJDGul7pDnCkh3pIhbsvCo51FyHURpPKlm9YbKRnivI0/reXHX1SykbF2m59mxep0=@vger.kernel.org
X-Gm-Message-State: AOJu0YylSTyeKN/HeD7BiT9VsuCR/66rP+0TcR/SvAQX8/SW+B17LkuP
	lshERqNqqfXFu+r+6iP70UhAKpm03cPIxNS+wqEZVBYGHtuxVTSW32qtwhIoFgSGMGn6Ir1k0PL
	4OQ==
X-Google-Smtp-Source: AGHT+IH/oCUXOezhQ0A565EEmfthxQY0rCc4VbVmqRSwagA0iA03VskT3jIu5Z1zmAcsnP7ZOJe6QkUN4cI=
X-Received: from pfbeb15.prod.google.com ([2002:a05:6a00:4c8f:b0:724:e5a7:e33d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4654:b0:71e:6c3f:2fb6
 with SMTP id d2e1a72fcca58-7252ffd753emr8477585b3a.8.1732755362168; Wed, 27
 Nov 2024 16:56:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:38 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-8-seanjc@google.com>
Subject: [PATCH v4 07/16] KVM: selftests: Compute number of extra pages needed
 in mmu_stress_test
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

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.338.g60cca15819-goog


