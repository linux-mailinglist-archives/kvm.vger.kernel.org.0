Return-Path: <kvm+bounces-39383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F28A46BAA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A3E23AB486
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724AE271836;
	Wed, 26 Feb 2025 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFKCAl9z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B225A27182B
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599768; cv=none; b=tBbMwhDDhN29MWml0T2uZ3VOdEos4xu3f3KHdDI/blpsJAJX3SePvDPnpU/j5YUKBWIhKHUZhvidMVDkTrMYGItUX1ULrcAvJky4soEt2JEy1guGqhTRCjLPSJRqxfVhJ1EEojLtUnPJMEYArDpc9Xu7D5eYzNfbBta9K9poteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599768; c=relaxed/simple;
	bh=/XPldn7ZgVhJV/uqtLlh76ZEFcT9lBeODgTAYP8GdHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umpchcm6P4Ck3km6U2/bQzkwzmnZOCGPfQcF40IlXuxbje4VSlW37riqC2+l1ZfXzpyYpenI6RRXlN1rpp8SwGJruTTur0PqfdWBVAEFdEGTzgpi3JFPWiJYNWNyiPQ7Zz52XRzF1TTDwQxCK3V6fADCMcfyJ1YTTV7pgimBB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFKCAl9z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zLlWivfIr+fpiRMtVJ1u/lyBL3DWGusbfiE0ScUkL0=;
	b=QFKCAl9zXdLFycFDP2C9OXxhcM/qUPmECEOxsekitNRUtU76VfHawHXDAmlKSb29rQTUFd
	q+B121vJIY8e+xYi6cZgANArf7qMt8HDELLyuH353Ob5MNu/54Jda7Q6RJbfHRC5vCSYc3
	oH9uLYMlMCQyCUfMzTXox/GEZnyTy1U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-SYtEzonXN-WZqbmMBdPqRQ-1; Wed,
 26 Feb 2025 14:55:59 -0500
X-MC-Unique: SYtEzonXN-WZqbmMBdPqRQ-1
X-Mimecast-MFC-AGG-ID: SYtEzonXN-WZqbmMBdPqRQ_1740599758
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BF64180056F;
	Wed, 26 Feb 2025 19:55:58 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E05D19560AE;
	Wed, 26 Feb 2025 19:55:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 20/29] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
Date: Wed, 26 Feb 2025 14:55:20 -0500
Message-ID: <20250226195529.2314580-21-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Yan Zhao <yan.y.zhao@intel.com>

Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
fatal errors have occurred.

kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
regardless of the specific error code from tdp_mmu_set_spte_atomic(),
tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
in general cases where the only possible error code from these functions is
-EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
errors.

Since this -EIO error is also a fatal error, check for VM dead in the
kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.

The error -EIO is uncommon and has not been observed in real workloads.
Currently, it is only hypothetically triggered by bypassing the real
SEAMCALL and faking an error in the SEAMCALL wrapper.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250220102728.24546-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 48a7e6f32f7f..f4e18b33a21a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 	do {
 		if (signal_pending(current))
 			return -EINTR;
+
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
 		cond_resched();
 		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
 	} while (r == RET_PF_RETRY);
-- 
2.43.5



