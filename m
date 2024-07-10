Return-Path: <kvm+bounces-21328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 390A792D798
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3B621F24B3A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25951195B28;
	Wed, 10 Jul 2024 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9w47WVO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB8E194C74
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633241; cv=none; b=Aw/DUCCDMR51EghJR8Ucyt3xXqYbJhKkvgGgcpeH7bkMTZAhy7R1GDbm8yMtT37WDlUHTbl8uF+TabzObM8Tw8XRFvsXzzBV95/iWcY1890v6AtZXYzpD5VIuoqaqmimwFLanGTIAEv+eegdCVJo4rLH9Pz3xLxgsk5/aQUjGAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633241; c=relaxed/simple;
	bh=O5fkNYW90Wbdotw+MGBf7JGRJHJViDgfqTY7qfYr4cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iksnlDqQvB9fqUVtdOIS/WxgV5yloQ7AXdLv8QkKX1Sr5oijz0MTboHR0u37PxMkNEOY1Zm9IG9Ju7DTaDXS9HNzmFtYRb6WK9YOEKCW6NqRH8aYDE9onw4rgShjlPgRm7ODzrIkmzCOppzvZMUALoDlQTsVOc1vgq78xQvx9NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b9w47WVO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720633238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VC6O1ODSdNCPRz9J31yr+8G9GiK5eqw1fLmRqqf2BpE=;
	b=b9w47WVOimypyiTRCg97rD/288BD7qQcZZ4mWFW+HbjqhdhUXxluuq6vQ07XabGzl7HH1V
	eqKqB6MYJJbQQDyHtqxsadvR9oKNtHI7rNKSA2h/gOHVi6Ggw8T7WqCcfBaLgWs6USi+hY
	MOj+4WbKwxmzi7dz9uNSAbGYhs2kCP0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-Yl3u8ay9OvSBus7AniuOsw-1; Wed,
 10 Jul 2024 13:40:35 -0400
X-MC-Unique: Yl3u8ay9OvSBus7AniuOsw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1113619560B0;
	Wed, 10 Jul 2024 17:40:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11FAF1955F3B;
	Wed, 10 Jul 2024 17:40:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	seanjc@google.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v5 1/7] KVM: Document KVM_PRE_FAULT_MEMORY ioctl
Date: Wed, 10 Jul 2024 13:40:25 -0400
Message-ID: <20240710174031.312055-2-pbonzini@redhat.com>
In-Reply-To: <20240710174031.312055-1-pbonzini@redhat.com>
References: <20240710174031.312055-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

Adds documentation of KVM_PRE_FAULT_MEMORY ioctl. [1]

It populates guest memory.  It doesn't do extra operations on the
underlying technology-specific initialization [2].  For example,
CoCo-related operations won't be performed.  Concretely for TDX, this API
won't invoke TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific APIs
are required for such operations.

The key point is to adapt of vcpu ioctl instead of VM ioctl.  First,
populating guest memory requires vcpu.  If it is VM ioctl, we need to pick
one vcpu somehow.  Secondly, vcpu ioctl allows each vcpu to invoke this
ioctl in parallel.  It helps to scale regarding guest memory size, e.g.,
hundreds of GB.

[1] https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/
[2] https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 55 ++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..d543a5b71d1a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,61 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_PRE_FAULT_MEMORY
+------------------------
+
+:Capability: KVM_CAP_PRE_FAULT_MEMORY
+:Architectures: none
+:Type: vcpu ioctl
+:Parameters: struct kvm_pre_fault_memory (in/out)
+:Returns: 0 if at least one page is processed, < 0 on error
+
+Errors:
+
+  ========== ===============================================================
+  EINVAL     The specified `gpa` and `size` were invalid (e.g. not
+             page aligned, causes an overflow, or size is zero).
+  ENOENT     The specified `gpa` is outside defined memslots.
+  EINTR      An unmasked signal is pending and no page was processed.
+  EFAULT     The parameter address was invalid.
+  EOPNOTSUPP Mapping memory for a GPA is unsupported by the
+             hypervisor, and/or for the current vCPU state/mode.
+  EIO        unexpected error conditions (also causes a WARN)
+  ========== ===============================================================
+
+::
+
+  struct kvm_pre_fault_memory {
+	/* in/out */
+	__u64 gpa;
+	__u64 size;
+	/* in */
+	__u64 flags;
+	__u64 padding[5];
+  };
+
+KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
+for the current vCPU state.  KVM maps memory as if the vCPU generated a
+stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
+CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
+
+In some cases, multiple vCPUs might share the page tables.  In this
+case, the ioctl can be called in parallel.
+
+When the ioctl returns, the input values are updated to point to the
+remaining range.  If `size` > 0 on return, the caller can just issue
+the ioctl again with the same `struct kvm_map_memory` argument.
+
+Shadow page tables cannot support this ioctl because they
+are indexed by virtual address or nested guest physical address.
+Calling this ioctl when the guest is using shadow page tables (for
+example because it is running a nested guest with nested page tables)
+will fail with `EOPNOTSUPP` even if `KVM_CHECK_EXTENSION` reports
+the capability to be present.
+
+`flags` must currently be zero.
+
+
 5. The kvm_run structure
 ========================
 
-- 
2.43.0



