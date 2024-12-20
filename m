Return-Path: <kvm+bounces-34199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2E89F89A5
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95E2C7A5040
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D67185E7F;
	Fri, 20 Dec 2024 01:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rv9gcxLG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6FD157A48
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658760; cv=none; b=WjDZLiSkiKCCv0az2xMVGO7Gd4RdMR/O+6V2Fajbh+ugkPB+cdmJ3+7z3Yy6BqDozqGFIh+mioKIaQSfiG2XtY/hmtHBVQZ1h/a6w2keeSzjucO6nx8FBm/50M/uafpW5BE8K8EEsJwLt7qTnVNgVesLfoOKurHU44Xg4zbQ8Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658760; c=relaxed/simple;
	bh=eeF/zKkticJHl5FU2ydo7jdEXM5cm9h9vTJoDSn8JMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=On9vv87OGJdmClewz0uJ17HlchyjVXU4zla/VTnRcFYYv4WSvlyj7SuvNVxM6fCwafJT5qIwBDrgN0ocW8+wm5vcY5RpryxmtRoFQ8w3jnVEBSHex3nLGGUg50BBgQUjtrcqLUcBIT2H/dGWOy7F6G9Rdl/ZZvd77JJmPLFRO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rv9gcxLG; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72907f58023so1663559b3a.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658757; x=1735263557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lQGXs4fRzhUjC9h6471rkcBzWgIFKg5z0MpBCPWHmMU=;
        b=Rv9gcxLGjoh1H6qINvmeWbMrOsPPYUnz9QHnoTc8YJBDEHXZ8yw3INwCMWG5gPMKLF
         qH4/ClaEAGx7fMkxmQOZdkUezeVW1x+lpCVEutgt5zb3yzJWMsi5cIDXK0MuefwLEhNV
         O7rldiQIcB+NZDKgW1sGjfy9FWaZPMjkKy1zesMLYL6kfJs1atpoS+VdTLEIVk6ZgMbO
         GIDRYoC9mAZbTpyoI4+Rs+9gnPPGwSS/CefwJD3hp0jTKmGGbqmO278l9mv6dWWN3Ad3
         EGSWxTSydM3abhVXoK1tESznXf2b4iinwqMhdfNVPW7GUiGATAAKvcOmWofbdHu4yKKf
         osKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658757; x=1735263557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQGXs4fRzhUjC9h6471rkcBzWgIFKg5z0MpBCPWHmMU=;
        b=bBGCOv06kAGc7UcTmw0avdTM9c9jxBzEulfTC0pn1aEZfdd/0aCjeImUN45bU8xMu8
         78llMVWOipZR0pjgDidWJcJ1y2z165PtS4Pxkf7VJBXXpyYuv74/Fi0DF3KbtPJIK8Yx
         eYvpPYuBIBa/ocnqyWebNAEnKElisC43Yfmdef/Or+2gUokBRWgUz+7S/F1qhdnF3V3t
         r4H4xYrnW4iJJR3mmR64hgtnJXsHx7en2hQTPffsuNvAfKZhX8jz7JyhX6tXWpMrZxa8
         WH8Etm0q/TA0dpmSuYgNZ3Ewr5NoTH1EQ+ofMO1rCVW7TzoxS74KHvAR0Op4TruiFGPA
         ixqw==
X-Forwarded-Encrypted: i=1; AJvYcCXpaaTi9qxBe/WCxj0M2YL1oJpXz7CvHK5tVWt7IAQBrr4D4JtHZdY1R7J+UASE0B1VLKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHK3/P1RoZNcXzfrbdEvue2UfoSnOBm23U/uZFq+svkIPqHSwx
	WPscnKH5itQRePjM0K87llfvIgAcX4aghZ28rYIpuAB0oZScCGaoHz6CPUKYSzAtXdpSvCPR7Hr
	nkw==
X-Google-Smtp-Source: AGHT+IGUByijU78nvHemXzOEaAQQDSmObXI7NYnb4v2toowk5S9287aNHUtx84WY5rqumwN+j1k67ZUHOWo=
X-Received: from pfd7.prod.google.com ([2002:a05:6a00:a807:b0:727:2d74:d385])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d1f:b0:1e1:b1e4:e750
 with SMTP id adf61e73a8af0-1e5e04717a2mr2014875637.18.1734658757426; Thu, 19
 Dec 2024 17:39:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:03 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: selftests: Add struct and helpers to wrap binary
 stats cache
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a struct and helpers to manage the binary stats cache, which is
currently used only for VM-scoped stats.  This will allow expanding the
selftests infrastructure to provide support for vCPU-scoped binary stats,
which, except for the ioctl to get the stats FD are identical to VM-scoped
stats.

Defer converting __vm_get_stat() to a scope-agnostic helper to a future
patch, as getting the stats FD from KVM needs to be moved elsewhere
before it can be made completely scope-agnostic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 11 +++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 47 +++++++++++--------
 2 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 044c2231431e..9a64bab42f89 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -46,6 +46,12 @@ struct userspace_mem_region {
 	struct hlist_node slot_node;
 };
 
+struct kvm_binary_stats {
+	int fd;
+	struct kvm_stats_header header;
+	struct kvm_stats_desc *desc;
+};
+
 struct kvm_vcpu {
 	struct list_head list;
 	uint32_t id;
@@ -99,10 +105,7 @@ struct kvm_vm {
 
 	struct kvm_vm_arch arch;
 
-	/* Cache of information for binary stats interface */
-	int stats_fd;
-	struct kvm_stats_header stats_header;
-	struct kvm_stats_desc *stats_desc;
+	struct kvm_binary_stats stats;
 
 	/*
 	 * KVM region slots. These are the default memslots used by page
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 21b5a6261106..c88f5e7871f7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -657,6 +657,20 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 	return NULL;
 }
 
+static void kvm_stats_release(struct kvm_binary_stats *stats)
+{
+	int ret;
+
+	if (!stats->desc)
+		return;
+
+	free(stats->desc);
+	stats->desc = NULL;
+
+	ret = close(stats->fd);
+	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+}
+
 __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
 {
 
@@ -711,13 +725,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
 	/* Free cached stats metadata and close FD */
-	if (vmp->stats_desc) {
-		free(vmp->stats_desc);
-		vmp->stats_desc = NULL;
-
-		ret = close(vmp->stats_fd);
-		TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
-	}
+	kvm_stats_release(&vmp->stats);
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -2214,34 +2222,33 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
  *
  * Read the data values of a specified stat from the binary stats interface.
  */
-void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
+void __vm_get_stat(struct kvm_vm *vm, const char *name, uint64_t *data,
 		   size_t max_elements)
 {
+	struct kvm_binary_stats *stats = &vm->stats;
 	struct kvm_stats_desc *desc;
 	size_t size_desc;
 	int i;
 
-	if (!vm->stats_desc) {
-		vm->stats_fd = vm_get_stats_fd(vm);
-		read_stats_header(vm->stats_fd, &vm->stats_header);
-		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
-							&vm->stats_header);
+	if (!stats->desc) {
+		stats->fd = vm_get_stats_fd(vm);
+		read_stats_header(stats->fd, &stats->header);
+		stats->desc = read_stats_descriptors(stats->fd, &stats->header);
 	}
 
-	size_desc = get_stats_descriptor_size(&vm->stats_header);
+	size_desc = get_stats_descriptor_size(&stats->header);
 
-	for (i = 0; i < vm->stats_header.num_desc; ++i) {
-		desc = (void *)vm->stats_desc + (i * size_desc);
+	for (i = 0; i < stats->header.num_desc; ++i) {
+		desc = (void *)stats->desc + (i * size_desc);
 
-		if (strcmp(desc->name, stat_name))
+		if (strcmp(desc->name, name))
 			continue;
 
-		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
-			       data, max_elements);
+		read_stat_data(stats->fd, &stats->header, desc, data, max_elements);
 		return;
 	}
 
-	TEST_FAIL("Unabled to find stat '%s'", stat_name);
+	TEST_FAIL("Unabled to find stat '%s'", name);
 }
 
 __weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
-- 
2.47.1.613.gc27f4b7a9f-goog


