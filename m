Return-Path: <kvm+bounces-23050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 447EE946018
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE3EB1F2430F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE5C21C19B;
	Fri,  2 Aug 2024 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NH4fM93l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B421C16E
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722611787; cv=none; b=jGnym7WyJ/dg5rta+pr7jCtxzqRl8vAlBaKb4Q3B2EkjwYIiys7tWAjKf8pLm18rbcgh5Dkr5pbRq6JmEBu8GTkrn6pNjgag8aFEU0Kzz+RUJSl0YHiGfY3itXt4lRSIx+twm0Ujjx/EuSW4t7oZnUaeZ3v4A3i7ECnti1R3nRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722611787; c=relaxed/simple;
	bh=7RzWm4TVAza6SKjenqIEuJ97Sb8DDWQkvSq/IOSwezw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fonAFTLxa9HjSjv9KOMWv5jl6gzIXe6vmKTU37eM8ApWVwK85WNLlXija32792bRW8Po9BsC8EjtvoWpvP6QK0cPkoln22H6VYdZPvQzDXcKILBcJJM7vU8oj1sXj3zOC+d1bmpvDEG2oXh1Mx8TLqRt1Sb89bGrZ/E2l6Hcqog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NH4fM93l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722611784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikT1XcHCFVzQ6kf/Q0zvP0r3BIvuRrjrVEasPutpHds=;
	b=NH4fM93ldbhoKNhO+VWd9s7FAhagrjT3iha+yXpXU9BYmKFVmEgUA3OA04mKa8wBLdq1HE
	X9Q8MlyIKWNSrkRfkPm+DEeU1PX2L0np8idUW1f5ycrAKyQkSl86y5DEE2pPWGBL28Mw/j
	BQL1Te+cAP9/1y+j3BNTX5+2HYUBgNo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-a903dtmwMDuLrwaGtfwyTQ-1; Fri,
 02 Aug 2024 11:16:21 -0400
X-MC-Unique: a903dtmwMDuLrwaGtfwyTQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CC9B1955D53;
	Fri,  2 Aug 2024 15:16:19 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.47.238.37])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94D441955E8C;
	Fri,  2 Aug 2024 15:16:14 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 1/2] KVM: x86: relax canonical check for some x86 architectural msrs
Date: Fri,  2 Aug 2024 18:16:07 +0300
Message-Id: <20240802151608.72896-2-mlevitsk@redhat.com>
In-Reply-To: <20240802151608.72896-1-mlevitsk@redhat.com>
References: <20240802151608.72896-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Several architectural msrs (e.g MSR_KERNEL_GS_BASE) must contain
a canonical address, and according to Intel PRM, this is enforced
by a #GP canonical check during MSR write.

However as it turns out, the supported address width
used for this canonical check is determined only
by host cpu model:
if CPU *supports* 5 level paging, the width will be 57
regardless of the state of CR4.LA57.

Experemental tests on a Sapphire Rapids CPU and on a Zen4 CPU
confirm this behavior.

In addition to that, the Intel ISA extension manual mentions that this might
be the architectural behavior:

Architecture Instruction Set Extensions and Future Features Programming Reference [1].
Chapter 6.4:

"CANONICALITY CHECKING FOR DATA ADDRESSES WRITTEN TO CONTROL REGISTERS AND
MSRS"

"In Processors that support LAM continue to require the addresses written to
control registers or MSRs to be 57-bit canonical if the processor _supports_
5-level paging or 48-bit canonical if it supports only 4-level paging"

[1]: https://cdrdv2.intel.com/v1/dl/getContent/671368

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6968eadd418..3582f0bb7644 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1844,7 +1844,16 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
-		if (is_noncanonical_address(data, vcpu))
+
+		/*
+		 * Both AMD and Intel cpus allow values which
+		 * are canonical in the 5 level paging mode but are not
+		 * canonical in the 4 level paging mode to be written
+		 * to the above MSRs, as long as the host CPU supports
+		 * 5 level paging, regardless of the state of the CR4.LA57.
+		 */
+		if (!__is_canonical_address(data,
+			kvm_cpu_cap_has(X86_FEATURE_LA57) ? 57 : 48))
 			return 1;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-- 
2.40.1


