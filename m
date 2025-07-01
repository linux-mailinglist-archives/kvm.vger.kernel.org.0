Return-Path: <kvm+bounces-51134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3CFAEEC12
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A3D53E026C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 01:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1127B1922FD;
	Tue,  1 Jul 2025 01:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTu0RpTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130094C97;
	Tue,  1 Jul 2025 01:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751333094; cv=none; b=fwGLsCTn80SJjylxm+O5tR/QNHV50sdKZWZtR8wqoGYR//pFjCrlVBQSX393FZi1xM7DMJC8CHjtIOUORsy2udskZhZ3aKz1bKPVH57PCSQvE+W2RAhykmRxVdMv3XmYkwLTGomo2xd7Ofc54/rUioLFfPuLD4yIwkYWLaKrDik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751333094; c=relaxed/simple;
	bh=Mb1v2xak7UyBtCzZCdehsNqtQQX38Vfh8VcEH6S2pk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fcuQxnPspGumJQm9WUYfQCcbJ7AyuIRu7nk/LalutfWLzmtbDXagMNyyVLHN+ZYD6uKM/n+n/x/HcQTm8nShlbwRDIJU5fI+HI4xBdkxgr/9u8aeebC/Drx2lMa+VFTtpjLKhlhHvUAkSAhjbHh1+DxxROtuCHW/+SwhDou4WHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTu0RpTE; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751333092; x=1782869092;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Mb1v2xak7UyBtCzZCdehsNqtQQX38Vfh8VcEH6S2pk4=;
  b=jTu0RpTEsD9xd0M4uiP5rtETRBetLJPSFjEItx+lnqs96+2ln03wwZ2Z
   +mxg63fz2aL95NbIKJkXt9LAsJcLwG9ztX7drjOmsMVcuVKNXsVBb1Cw2
   omrq2DuG7WceRU9exHV1o04qw0EXE6QhPjagd5fjx+iuTTZ6SehTrVi+l
   NX+mS4nx3gX8dFObKqkRvRHXKFI3xF7K0RoxlZvgUsP2plX08KcqVdc49
   J6dTN9/0BIjJF1QOGFgMZn6ZVgOpLn0GSgnMaquUk12w0OkWVfutkoWMD
   qalX51YCPjexv1G6RtMtTcoyJoikyLclXzmtEn94BCo3KLbiTblUay/5M
   w==;
X-CSE-ConnectionGUID: xnS6VOfDT2+d6EQa0bQHHQ==
X-CSE-MsgGUID: +faKAyFNQ724avNx4hd9Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="41203091"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="41203091"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 18:24:51 -0700
X-CSE-ConnectionGUID: Xauj1Xu3TU6gU9z3sSOa1Q==
X-CSE-MsgGUID: FI/2PDSsRm+aM6eLiJ+fBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159130714"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 18:24:49 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH next] Documentation: KVM: Fix unexpected unindent warning
Date: Tue,  1 Jul 2025 09:25:36 +0800
Message-ID: <20250701012536.1281367-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add proper indentations to bullet list item to resolve the warning:
"Bullet list ends without a blank line; unexpected unindent."

Fixes: 4580dbef5ce0 ("KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes:https://lore.kernel.org/kvm/20250623162110.6e2f4241@canb.auug.org.au
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Fix the remaining one on the next branch. The other two are handled by
https://lore.kernel.org/kvm/20250625014829.82289-1-binbin.wu@linux.intel.com/
---
 Documentation/virt/kvm/api.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..6ab242418c92 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7230,8 +7230,8 @@ inputs and outputs of the TDVMCALL.  Currently the following values of
    placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
    field of the union.
 
-* ``TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT``: the guest has requested to
-set up a notification interrupt for vector ``vector``.
+ * ``TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT``: the guest has requested to
+   set up a notification interrupt for vector ``vector``.
 
 KVM may add support for more values in the future that may cause a userspace
 exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,

base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
-- 
2.46.0


