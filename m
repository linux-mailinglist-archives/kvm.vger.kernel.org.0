Return-Path: <kvm+bounces-50150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D4CAE2242
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F10C5A6A76
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CC22EBBBB;
	Fri, 20 Jun 2025 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkckGEZa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762036BFCE
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750444403; cv=none; b=f1vmcp3CUEumcpDq+jcBSO1IrbZI/AIFjfIiuEhn2TyvQWW9igVCDg/tjSPgvN+c84J4khQBa0cyjN2+XlNDbofhhiXRem1HgDuvBBXEKMY519QVoFI2EqCtGUG1sxFYObQBMKfUA+dBnV37GHznL5bcN5m2sOh99Rnvg4BF2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750444403; c=relaxed/simple;
	bh=sIMco8OZdRKD0PESP1248SY+C1rI3eIxgXz4pXFO21A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uAKxfLImW745mQLgLuyhNYsF0a4tlulndcLN3nAAgl8W1Wrh+IkTXzO7BwHtkiZsOhPiRbyL78DCJO4BtfYf3pM5y13n4LveTfVhAElMJ9OX1JkrrPqyXUVfFLw8giY8VDI6PCKhk00xx1dtxHJCJZHr/wjBOX38JTTgSCkNdOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkckGEZa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750444400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qFCxvPemuwsmy2QbSvDCCNSay81IMpoZXa9WMQ9tskg=;
	b=gkckGEZaIkyzqjTWtUC2Sd6on0+31f2p++EEmJkzuyX44+9vioCJxpU6rNd6OW43DCrm/k
	QlLyaqRQ5aL+60L5EzV2lpW1VYXwoLQAuXzpJo8HxYw568Wk3aJvzhknX71v62AabyqTSl
	BqB91HYP5FtML9J9wj7LNM3xcI0zHjU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-US2x4_1XNZmhusfqhFmbcw-1; Fri,
 20 Jun 2025 14:33:17 -0400
X-MC-Unique: US2x4_1XNZmhusfqhFmbcw-1
X-Mimecast-MFC-AGG-ID: US2x4_1XNZmhusfqhFmbcw_1750444395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D811C19560B2;
	Fri, 20 Jun 2025 18:33:14 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A878C1800285;
	Fri, 20 Jun 2025 18:33:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	mikko.ylinen@linux.intel.com,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH 1/3] KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
Date: Fri, 20 Jun 2025 14:33:06 -0400
Message-ID: <20250620183308.197917-2-pbonzini@redhat.com>
In-Reply-To: <20250620183308.197917-1-pbonzini@redhat.com>
References: <20250620183308.197917-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Binbin Wu <binbin.wu@linux.intel.com>

Add the new TDVMCALL status code TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED and
return it for unimplemented TDVMCALL subfunctions.

Returning TDVMCALL_STATUS_INVALID_OPERAND when a subfunction is not
implemented is vague because TDX guests can't tell the error is due to
the subfunction is not supported or an invalid input of the subfunction.
New GHCI spec adds TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED to avoid the
ambiguity. Use it instead of TDVMCALL_STATUS_INVALID_OPERAND.

Before the change, for common guest implementations, when a TDX guest
receives TDVMCALL_STATUS_INVALID_OPERAND, it has two cases:
1. Some operand is invalid. It could change the operand to another value
   retry.
2. The subfunction is not supported.

For case 1, an invalid operand usually means the guest implementation bug.
Since the TDX guest can't tell which case is, the best practice for
handling TDVMCALL_STATUS_INVALID_OPERAND is stopping calling such leaf,
treating the failure as fatal if the TDVMCALL is essential or ignoring
it if the TDVMCALL is optional.

With this change, TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED could be sent to
old TDX guest that do not know about it, but it is expected that the
guest will make the same action as TDVMCALL_STATUS_INVALID_OPERAND.
Currently, no known TDX guest checks TDVMCALL_STATUS_INVALID_OPERAND
specifically; for example Linux just checks for success.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
[Return it for untrapped KVM_HC_MAP_GPA_RANGE. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 2f3820342598..d8525e6ef50a 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -80,6 +80,7 @@
 #define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
 #define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
 #define TDVMCALL_STATUS_ALIGN_ERROR	0x8000000000000002ULL
+#define TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED	0x8000000000000003ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..5d100c240ab3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1212,11 +1212,13 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	/*
 	 * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
 	 * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
-	 * bit set.  If not, the error code is not defined in GHCI for TDX, use
-	 * TDVMCALL_STATUS_INVALID_OPERAND for this case.
+	 * bit set.  This is a base call so it should always be supported, but
+	 * KVM has no way to ensure that userspace implements the GHCI correctly.
+	 * So if KVM_HC_MAP_GPA_RANGE does not cause a VMEXIT, return an error
+	 * to the guest.
 	 */
 	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
-		ret = TDVMCALL_STATUS_INVALID_OPERAND;
+		ret = TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED;
 		goto error;
 	}
 
@@ -1476,7 +1478,7 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED);
 	return 1;
 }
 
-- 
2.43.5



