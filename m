Return-Path: <kvm+bounces-8841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8B8857209
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A295A1C22928
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB101474B2;
	Thu, 15 Feb 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1orvqaH7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDF8146906
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041263; cv=none; b=arREXqkWRe7M8bZbuHA/HiQV57+AqfqU8ZOSii/BoJVOreNU9m5DLWVPGtNBDDhhZbFMjdatmrVt2qWLg4opaftNzY0TBQi2Ojz8GPhfr6S3yye5vBBiU8g7hRWUIsbQVLT2OM5iJer2w7oDQpktcpxa1EuaONQaqoIQhIcgG3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041263; c=relaxed/simple;
	bh=eLQTZ0Bt1CIZ9NPrKNRT5DeFFxc1SAR3qmaE7o5Oe8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p27KsoqDv0MtUIRzwRjlfP/tIaPiTrEfNBhygTD49G+ab+out0YBfMCjBHwrJ5M/WcWZNbtRToOuGzqS6Qw/BcgjrlinxZwt8LSc+eYbVPZHRqshfZt0v0Lp3cSPTQz80aE2IAVHFFldy/g59sFadIvWRQYcOKq1VEqWFPOT314=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1orvqaH7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so2328080276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041259; x=1708646059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=APWWApm07v+Ii9pzK+6vOaw3uMIWE5cbc20AIdxyhTk=;
        b=1orvqaH7D0VAgaSmAG25GBOpX/DlzFTxUaZqNGuCRmSCnPbvlMnVJkhIg85bqzMhQn
         aXI6rM3MHGV049b/gog5nipGJB3Cgm8EZd9YauvWYsSEpFhVvIVPU1vpPu+fMdwkI1hx
         47BLkt4ZixC4GRbad/SrHyg2lKY+q2uwh6vDueSHfUyN7ptSH9yg+rYW24p1zuk2Y3XT
         M5sSPpyJ9K6cNiyvqA2MErFDcrppkpGLf+QVLp56qkdqiM9BGgD9pCSwZF1kRfS1JNgc
         vxk47MtEaIJK0djgMEtPjfJcIoJ7h9vxXaMmM++qm/7rKwFkkFt7XkRv2G14wXOWxZ/C
         5MkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041259; x=1708646059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=APWWApm07v+Ii9pzK+6vOaw3uMIWE5cbc20AIdxyhTk=;
        b=pvMSJVKPJu8XOshgENq3gHS2wSweRlHPlfhjM2z0tf3gRazkxg71uFR726Fts7A9CG
         mY9qDxbjBCc7O4WC5byPQ0cxDLGX8+2NmGbkwHy1tdplRxn9DjrWpJK/PL2cW5uw6h8G
         P7ahAX5zO06lHXC73Y5KmXDpx+peOJmO/JdRhMhrP++C2XCzY9VtrrABxbUvVnAwWs3K
         +rAb7zGX4ted/Bw09eb8pxJxgkuuYgn/xUqzCJO6xM70m0syi5UN4a8dddZ+qbVQpqMv
         H8C5r/Kp/AwT+59JWv6DloWTECU+myP/C0s6x/1dNKm/GdBHpKpEVOfDAFzabdexo7j9
         uPDg==
X-Forwarded-Encrypted: i=1; AJvYcCUxCWiypNNncue7XbXnlMUy42z0zN9x39gL44UFm6wR7W+RxbHDQbJ5EMYJ9IxcKp+I6NO5coUjTEQeR+xo/cNrAkAz
X-Gm-Message-State: AOJu0YzPYz9w5TO8MvV/rvlL1YAH5U7Oy1gaurzWQtLNsND5V1+hU5MX
	EeDZPUqUigCvOCTRxj2nI9wdG1WF9XF1bMAod+NYAsjSpLsTxxUsm//WRxgPkqQwslpg+y1gVvs
	PC+/FNN45FQ==
X-Google-Smtp-Source: AGHT+IHPEJ59b8BXtnY8f7wKfLDM6BJPxRmmBDQPm7EUmwopjvKfjeWa/RaVSEDv68ZZb+Tit0/u/eoxIpod4A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:2487:b0:dc2:466a:23c4 with SMTP
 id ds7-20020a056902248700b00dc2466a23c4mr725257ybb.4.1708041259622; Thu, 15
 Feb 2024 15:54:19 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:59 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-9-amoorthy@google.com>
Subject: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

At the moment the only intended use case for KVM_CAP_MEMORY_FAULT_INFO
on arm64 is to annotate EFAULTs from the stage-2 fault handler, so
add that annotation now.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 arch/arm64/kvm/mmu.c           | 5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d52757f9e1cb..7012f40332b3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8031,7 +8031,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN will fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..ca4617f53250 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -240,6 +240,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dfe0cbb5937c..5b740ddfcc8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1492,8 +1492,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.44.0.rc0.258.g7320e95886-goog


