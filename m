Return-Path: <kvm+bounces-73062-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CgUDQ3gqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73062-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D265D222554
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72902305E36D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1165F3AE702;
	Fri,  6 Mar 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WUpBec95"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020F3AA1B0
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805764; cv=none; b=djFVX2ORzdJvndbu3e8mM0dXppqWBI2zhAvC2R5jsm3qJ/i7y6WRCQOLO34bvVIkwRqPM101HUKyhwbOb5331ql1/yEADrU2qpq2jfZU5GllwhqtPC1Ex0SPMi6YmSNJ68lVXLwDGg6L3RgG7umvXKLGDkPOMitTOizkmUv6u/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805764; c=relaxed/simple;
	bh=wU7LY+l8eziTdyiYMOjRIU0DPbURQ3YWdDdcLC7ERsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UsvD0q4yvU529rdfch0hEZ/9uW4hXbIjkfTxMnPDcO4hiC6q00fxUYRKkUfbQDbYm/B7Qzjm1wjqeN+dnXbdTP2eJ5HR2eYOI4GLQblgevDWghLucDvgoLEO8Xah3uJuq0np8d3T/YxgFoljc0OuvfWBxEOptpfIHlXpwS+M8QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WUpBec95; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so99520545e9.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805759; x=1773410559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sHiziDrbrII1tYwtdt9uLufHtIuF7NAMU9T1cNEOC3I=;
        b=WUpBec95apozYufzwKblT1Sp6IpqdWl+Zg5mikq+Ye1wTRtJMeS/7+8icsKVrh1mec
         qsTTRAUoHkRIq+ua8LvqLWsd8xX1F72fqMsLiSWVoiqGzkciw930GYQeTpno1idT1LAA
         1bdE9ivZTa7rjXuoMoCGXAIMMgwWpAZfDZFyEQCWKxXd3LxZqJ5VlNfW4LlkjGrgJJbC
         6B6Du89ZFq31OOp/rBElUZGr1jbfxLovRWVz4mAwfIXj7wkguLyp6d9NPmAO0tbYTcam
         ikGvOYmupzIS+AF9Lmc60w5gJEN/0YaW7wZzdcFySsyBxvnjdPjn4oeRRHeKTbQ2qnII
         KIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805759; x=1773410559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHiziDrbrII1tYwtdt9uLufHtIuF7NAMU9T1cNEOC3I=;
        b=MEb59rZmoYC8lZFVivYvX2z0gWwGbMc7vMgpW/Jx/xfCZqAGTiJpfICz06JGNuqXt8
         sL9ORjv1b2aDFEF3yz3Mzay6EmiTKS+yhSiMIUSBgy+iPmaOaZt3yqMsrEp22NsEDdV2
         tBN6+aBAdaHO6EJPqOIe8lUtxEIJdHfRbpTD20ZM1HYvIBiTZFAgmVi3I8GMrXaW2IOJ
         0UBPnKhmuZceZtVt5KoBzchPTeZF6rH2kEbUHWZx0x8+v/77WhW8WI3OUBbUY0VzYh5x
         fwtd7DrD7RUsgK8jNQY5t6bG9AgZWJ5kMClGiXy8Rvmb3ZM+WubeIT/fQzPOGmnhN8kA
         yxCQ==
X-Gm-Message-State: AOJu0YwUHyBpNExJBtWI7qFQ+rndk1pdJt1xzsV+ZuR0uwsw7A40Ba/2
	zrft1KwBHT9QpG+5ookFNIqd6/Qv9ratz2JrE3/cXlqODM0yZBtv7Rzo41ckOcP7cOWVPZCDzvv
	L/+3MO6Pd1HQ8SrFHIHnRS97gmHPeEhdj6G7O10IrHWUjc95ouH/FlChMql6EVtNW0MTxBJRHRx
	ZTI28qDMlyxmPPWDrLn9RnPQJHC6Q=
X-Received: from wmjk6.prod.google.com ([2002:a7b:c306:0:b0:483:7b48:cd99])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a0d:b0:485:1878:7b8c
 with SMTP id 5b1f17b1804b1-4852695b6fcmr34660805e9.18.1772805758953; Fri, 06
 Mar 2026 06:02:38 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:23 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-5-tabba@google.com>
Subject: [PATCH v1 04/13] KVM: arm64: Isolate mmap_read_lock inside new
 kvm_s2_fault_get_vma_info() helper
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D265D222554
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73062-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Extract the VMA lookup and metadata snapshotting logic from
kvm_s2_fault_pin_pfn() into a tightly-scoped sub-helper.

This refactoring structurally fixes a TOCTOU (Time-Of-Check to
Time-Of-Use) vulnerability and Use-After-Free risk involving the vma
pointer. In the previous layout, the mmap_read_lock is taken, the vma is
looked up, and then the lock is dropped before the function continues to
map the PFN. While an explicit vma = NULL safeguard was present, the vma
variable was still lexically in scope for the remainder of the function.

By isolating the locked region into kvm_s2_fault_get_vma_info(), the vma
pointer becomes a local variable strictly confined to that sub-helper.
Because the pointer's scope literally ends when the sub-helper returns,
it is not possible for the subsequent page fault logic in
kvm_s2_fault_pin_pfn() to accidentally access the vanished VMA,
eliminating this bug class by design.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d56c6422ca5f..344a477e1bff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1740,7 +1740,7 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 {
 	struct vm_area_struct *vma;
 	struct kvm *kvm = fault->vcpu->kvm;
@@ -1774,9 +1774,6 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
-
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
 	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
@@ -1788,6 +1785,17 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	fault->mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	return 0;
+}
+
+static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+{
+	int ret;
+
+	ret = kvm_s2_fault_get_vma_info(fault);
+	if (ret)
+		return ret;
+
 	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
-- 
2.53.0.473.g4a7958ca14-goog


