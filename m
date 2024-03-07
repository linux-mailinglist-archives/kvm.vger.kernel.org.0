Return-Path: <kvm+bounces-11326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A599875765
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 20:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5988E1C20B2E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E9E137C44;
	Thu,  7 Mar 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2zoBdR0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA31369BB
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 19:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709840603; cv=none; b=I6Fmo5nT59KVglsOvNNJsw8vLpYIQ1wSW6Tk0Ot+PE95RclCb2vbD/93sC6JxSJq88ZwuoSJrMCYuxhxGmx2tYpu0P85Zjr3MfjDnEpKZOlEfhaU1wu0EuzAT78S3oshYdqYZeSc/6xt21zRqKMHkj2XDjWSxLGYeHCIhj5ZBLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709840603; c=relaxed/simple;
	bh=V5E4NzO07aa5S4gs3SV2JHwGbgx/er14+hYh0RYUCV8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bbXouRLqpewZaGcB7+O32zFhigkC2ZsJSeoeWchBjwXgnhnHDeBouH+cxBmlvqDLOrajghrRHZsHUdazMIEbku8TLch1vxBc5xi3WtsE1njbQUgm9+4n+YfSAh/oLDXZIatCFZykt67IhRloknMcG85CUV8WxRbuHgETCK7/bOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2zoBdR0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fe93b5cfso2555557b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 11:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709840600; x=1710445400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R/CxQ8IXJwQYxLbYdax/leKLs8+bGoPDvy/xmVenJg4=;
        b=x2zoBdR0h2s7eqI+SgaGqkgA9N6dew+K3Mdtdx4eISO2osgu2WvkkkFPjP+1pubSse
         Z6klmnl9VbbB7eVU2Q0Z5QSgcKnE1LeB+tGge7mgR1dGmxmUN/D4PzusTW0YJLiWb/t8
         PgPZkb7jSuVk0IV4OP3y9YZ8qAjEFywnKTidPO7o6iyTL/iwv69bhvzLkgPNLR7bmw1u
         esxmlU0FPWwUPv4HVqdTAU4vLaIAZ+vm5RFmjnj/uv+sfbAnAC5oeQ95ST34MdIc0SRz
         Vo2FxOoanPC0xXHkbK6YIjHa0psvC/G+XGYStgVbMC8RFDEYGFuFrV67GE63pM3Q89Fm
         s9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709840600; x=1710445400;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R/CxQ8IXJwQYxLbYdax/leKLs8+bGoPDvy/xmVenJg4=;
        b=TKIcR3YaBNUg1vUluhqMHTqYL+jJInELPa9QVgwXSPK0wjw/tLJ53j30/JUP4zXqW8
         OJ1bfONZ9YUhcaFnkPRcMMk3tq+s0VnXd3aM9isAhEPYSeMScBfcWv+rSzPUi7AmF98P
         0CYLP+Js4nhqShFzVwwSTKxHFKkpPgkymFzmPPW3ZOPfeds7cosTP+z6ZhH187YvUPYc
         MQgEdGhAcJ03+CG2hyVAszbQ3pCcU2I7rPPzIbdY8lW52Kc9pcEfXK3t1ZThrWCim6B4
         e78PcOcKODG7LRKiivhXrTCFuiUh/z0nbSyMHEO9e7UjXFh7HAkZ/Q9mY1RZCKNwLScq
         sZeg==
X-Forwarded-Encrypted: i=1; AJvYcCWmkso1JEl9i5ELEcG1zviuCWO3qRc/CIohl2//S0xqUhOoqwqApso1bLvoQYsLBbF2PW/TmVNUbzYiqDn1MNJ0Y6bx
X-Gm-Message-State: AOJu0YztItXv8mgbbafopPehfEnkkwyiR0h8AlIyE8z1DcDmxi5OMt+c
	IIJTwLgc6lIMe0XgDdiFX9whgyFYtRZw5CsONfC3F6GPidL9AGlTiNYiHRMatAVimy2Hk1Xu1tC
	cC/LY72Kvgg==
X-Google-Smtp-Source: AGHT+IGOeyLE/MrHK3FEqNITKGuFyefy3d3MUFlLE34QrA2ka8F5EmNVbX4BHcU3p77e0xt/2kB0LuQ3O2aGzQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:157:0:b0:dcf:f526:4cc6 with SMTP id
 84-20020a250157000000b00dcff5264cc6mr685643ybb.11.1709840600651; Thu, 07 Mar
 2024 11:43:20 -0800 (PST)
Date: Thu,  7 Mar 2024 11:42:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307194255.1367442-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Michael Roth <michael.roth@amd.com>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping with
KVM's private memslot for the APIC-access page.

Without this change running large-enough selftests (high number of vCPUs
and/or guest memory) can result in KVM_CREATE_VCPU failing because the
APIC-access page memslot overlaps memslot 0 created by the selftest:

  $ ./dirty_log_perf_test -v 256 -s anonymous_hugetlb_1gb -b 4G
  Test iterations: 2
  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
  ==== Test Assertion Failure ====
    lib/kvm_util.c:1341: vcpu->fd >= 0
    pid=53654 tid=53654 errno=17 - File exists
    (stack trace empty)
    KVM_CREATE_VCPU failed, rc: -1 errno: 17 (File exists)

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 6 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c             | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 3bd03b088dda..ee33528007ee 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -20,6 +20,12 @@
 
 #include "../kvm_util.h"
 
+/*
+ * Create memslot 0 at 4GiB to avoid overlapping with KVM's private memslot for
+ * the APIC-access page at 0xfee00000.
+ */
+#define KVM_UTIL_MEMSLOT0_GPA 0x100000000ULL
+
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..c8d7e66d308d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -20,6 +20,10 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
+#ifndef KVM_UTIL_MEMSLOT0_GPA
+#define KVM_UTIL_MEMSLOT0_GPA 0ULL
+#endif
+
 static int vcpu_mmap_sz(void);
 
 int open_path_or_exit(const char *path, int flags)
@@ -418,7 +422,8 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 
 	vm = ____vm_create(shape);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    KVM_UTIL_MEMSLOT0_GPA, 0, nr_pages, 0);
 	for (i = 0; i < NR_MEM_REGIONS; i++)
 		vm->memslots[i] = 0;
 

base-commit: 0c64952fec3ea01cb5b09f00134200f3e7ab40d5
-- 
2.44.0.278.ge034bb2e1d-goog


