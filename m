Return-Path: <kvm+bounces-42422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86042A7857C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A34F516E0D5
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A909FC1D;
	Wed,  2 Apr 2025 00:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="evzWyLH/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B748FD299;
	Wed,  2 Apr 2025 00:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743552886; cv=none; b=dsXUn2zL5ByHJccncUwp/+J3QHg1h0CWnSh5MhobPIEYGr8vAVp20rNH8mIw65LkaMafoV2XJerUoXz9eBLVrxY+ar3e3drULVVzqLcxySQvto5dbGINB5TeBrglMn7ZdUeCHY5wK9wvNvzoG6Tul8lBkqppbJDLp0UUAEvlKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743552886; c=relaxed/simple;
	bh=hUu4erfW+ZiEvDkdXZ3B9e9R73Dq0czvJdocU9VCsBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM2Yec5+9D0wrS95swkHjvOpPfRr63peKlLK6Ijtcm9KDB9JapaOqnXRjazyG6dQ2xuOIiLKaoBeDLsJVqEUe3YxJt54HVVa7kH6v6lCaHEz/Zrntfosgac9/IhjhBmlbWrifR3huHhscfOd+IRvahpdbg3iXILtF0V0+uy+uMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=evzWyLH/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743552885; x=1775088885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hUu4erfW+ZiEvDkdXZ3B9e9R73Dq0czvJdocU9VCsBM=;
  b=evzWyLH//X9db9i/dp1EW4NAwbvZufcdec3nh1oJozZiYQ1dpqfVbe1M
   4aHZShI0y3QPVNHoXnHrUg0G8RfJCKzcyxJKgyta6hZl5Tt8BjN+zvEGR
   io29nh2RRsWm1b67Bn0ak8LSs8KzHsRM3rRYQuDdafJyekbgb7Nz+CBbZ
   vQ0iyidavS4n/vueOWYkXLkgIkKnCXP+iG+yXs2Q2jJZjABP0rPcaucCK
   Pva9+3ZJIh3D4O8Sn/NGJrdhdjyo0aBwfCmD0SQOfgFMDZw5Ph/yqyFYt
   whIXSyQoaIKIuzqjSE0Inf9TVL3UVPD0bxUz77X754p7I1QJGnu/qc94V
   A==;
X-CSE-ConnectionGUID: fpxcYdNXSd6xBf1T19VJKQ==
X-CSE-MsgGUID: emnfDKncTuuHeHBsGSPsOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="44148837"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="44148837"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:44 -0700
X-CSE-ConnectionGUID: wmdeQkMDTwCzLWj8MWgE1A==
X-CSE-MsgGUID: HUj/ozpPTfWc8XEIydR/jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="131673952"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:41 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 2/2] KVM: TDX: Handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>
Date: Wed,  2 Apr 2025 08:15:57 +0800
Message-ID: <20250402001557.173586-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250402001557.173586-1-binbin.wu@linux.intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle TDVMCALL for SetupEventNotifyInterrupt to set up an event-notify
vector.

TDX guests can make a request to host VMMs to specify which interrupt
vector to use as an event-notify vector.  E.g., for GetQuote operation,
which may take several seconds, if a TDX guest has set up the event-notify
vector, the host VMM can inject an interrupt with the specified vector
to the TDX guest on the completion of the operation.

KVM itself doesn't use this mechanism.  Add KVM_EXIT_TDX_SETUP_EVENT_NOTIFY
as a new exit reason to userspace to forward the request to userspace VMM
(e.g., QEMU) after sanity checks, so that userspace can inject an interrupt
with the event-notify vector to the TDX guest when the operation completes.

Since there is nothing special for SetupEventNotifyInterrupt beyond setting
the return code in the complete_userspace_io() callback, the code reuses
the version developed for GetQuote.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 Documentation/virt/kvm/api.rst    | 22 +++++++++++++++++++++-
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 25 +++++++++++++++++++++++--
 include/uapi/linux/kvm.h          |  6 ++++++
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 90aa7a328dc8..16e15f151620 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7179,7 +7179,27 @@ TDX guest passes a TD report. When completed, the generated quote is returned
 via the same buffer. The 'ret' field represents the return value. The userspace
 should update the return value before resuming the vCPU according to TDX GHCI
 spec. It's an asynchronous request. After the TDVMCALL is returned and back to
-TDX guest, TDX guest can poll the status field of the shared-memory area.
+TDX guest, TDX guest can poll the status field of the shared-memory area. Or TDX
+guest can register an event-notify vector by TDVMCALL_SETUP_EVENT_NOTIFY, so
+that on completion, an interrupt can be injected to TDX guest.
+
+::
+
+		/* KVM_EXIT_TDX_SETUP_EVENT_NOTIFY */
+		struct tdx_get_quote {
+			__u64 ret;
+			__u8 vector;
+		};
+
+If the exit reason is KVM_EXIT_TDX_SETUP_EVENT_NOTIFY, then it indicates that a
+TDX guest has requested to specify an interrupt vector used as the event-notify
+vector. E.g., for GetQuote operation, which may take several seconds, if the
+TDX guest has set up the event-notify vector, the host injects an interrupt
+with the specified vector to the guest on the completion of the operation. The
+'vector' field specifies the interrupt vector, with a valid range [32, 255], to
+be used for the event-notify. The 'ret' field represents the return value. The
+userspace should update the return value before resuming the vCPU according
+to TDX GHCI spec.
 
 ::
 
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 606d93a1cbac..eddc3f696b38 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -71,6 +71,7 @@
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
+#define TDVMCALL_SETUP_EVENT_NOTIFY	0x10004
 
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 535200446c21..48461520cb44 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1463,7 +1463,10 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
+static_assert(offsetof(struct kvm_run, tdx_setup_event_notify.ret) ==
+	      offsetof(struct kvm_run, tdx_get_quote.ret));
+
+static int tdx_complete_tdcall_common(struct kvm_vcpu *vcpu)
 {
 	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
 	return 1;
@@ -1491,7 +1494,23 @@ static int tdx_get_quote(struct kvm_vcpu *vcpu)
 	vcpu->run->tdx_get_quote.gpa = gpa;
 	vcpu->run->tdx_get_quote.size = size;
 
-	vcpu->arch.complete_userspace_io = tdx_complete_get_quote;
+	vcpu->arch.complete_userspace_io = tdx_complete_tdcall_common;
+
+	return 0;
+}
+
+static int tdx_setup_event_notify(struct kvm_vcpu *vcpu)
+{
+	u64 vector = to_tdx(vcpu)->vp_enter_args.r12;
+
+	if (vector < 32 || vector > 255) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX_SETUP_EVENT_NOTIFY;
+	vcpu->run->tdx_setup_event_notify.vector = (u8)vector;
+	vcpu->arch.complete_userspace_io = tdx_complete_tdcall_common;
 
 	return 0;
 }
@@ -1507,6 +1526,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_get_td_vm_call_info(vcpu);
 	case TDVMCALL_GET_QUOTE:
 		return tdx_get_quote(vcpu);
+	case TDVMCALL_SETUP_EVENT_NOTIFY:
+		return tdx_setup_event_notify(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eca86b7f0cbc..1a9397e8997b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX_GET_QUOTE    41
+#define KVM_EXIT_TDX_SETUP_EVENT_NOTIFY 42
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -454,6 +455,11 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} tdx_get_quote;
+		/* KVM_EXIT_TDX_SETUP_EVENT_NOTIFY */
+		struct {
+			__u64 ret;
+			__u8 vector;
+		} tdx_setup_event_notify;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.46.0


