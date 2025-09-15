Return-Path: <kvm+bounces-57583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DE8B57F9F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DEDA7B2F9F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AFB343204;
	Mon, 15 Sep 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V39dvToy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3AC341AD5
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947786; cv=none; b=gRW+N0toaiN+gTsIr3itbYoeijZY5YdvTidT8hikqaDBq3nnGp8+FmaiX02hsmL2ftv1P1nTULnb0gQmG8pyqpIRHFRVHUTFzeelYadnkVoYB6/6cJIORBq/otb3Wr0IpJhDcyFOd+LF7Hd95LMcVkQ8nBf9gRQam2cMmy7Ky9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947786; c=relaxed/simple;
	bh=WVJWNIx5QwaMow+MsmCeCuAKp4rZN4PFTSRjQcopJDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHFfvqxuMNrliYvH6eYrdNHEr4Ls2srwm7lQdZNaJlzku7DGoLRj8zaTE9E+4p2CGXls5go5YRc/NiRrKSgjnBHF+kskfIW1yEP5VPivAFJSnHST+An4YoPLpgMEJCCPqzsB4FF6LuKDABglujA5WNfKD01RILHFpxo6sAwrPPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V39dvToy; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757947786; x=1789483786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WVJWNIx5QwaMow+MsmCeCuAKp4rZN4PFTSRjQcopJDw=;
  b=V39dvToysSHJwk8sib3EfF2ORjA/MLVx3r0kepfiNCITgYBEEjN4gBD9
   meY1cimcVjbJb9NYZkJpM2N6J8VxjpzPV8o0jdeQ68BJEIh2vSYTE/oEQ
   m6VKKMYtNNjPHK//OCniEtrbKYl4sIm4B8O0Kj4u3Qgxu00tueLKfhnB0
   V96AggfWhswRxXkxP9cHVL3W4bpx/05lxy2E0ogn/U9BcFQBkHxXKabDj
   K+bJLH6V1mIye8G6RRDe07jEzNuOtvcbW5JGKYTpu7df9BExE3sIxVh7u
   ulgxUl7I8bsuoDwRtbyEnLAq4M1YQD8YaXobXOWaFbNzG9wub52FUNbdu
   g==;
X-CSE-ConnectionGUID: uAUIU9k7SSySoZ19DIjlkw==
X-CSE-MsgGUID: NAvX+4WWRL+5Od8dCkLMeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59247135"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="59247135"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:44 -0700
X-CSE-ConnectionGUID: SAzO2mkwR5Cxhk7TCKF+8A==
X-CSE-MsgGUID: EWZjaIpkTmC2swDtrqD+Zg==
X-ExtLoop1: 1
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 2/2] x86/eventinj: Push SP to IRET frame
Date: Mon, 15 Sep 2025 07:49:36 -0700
Message-ID: <20250915144936.113996-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915144936.113996-1-chao.gao@intel.com>
References: <20250915144936.113996-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the current stack pointer (SP) to the IRET frame in do_iret() to
ensure a valid stack after IRET execution, particularly in 64-bit mode.

Currently, do_iret() crafts an IRET frame with a zeroed SP. For 32-bit
guests, SP is not popped during IRET due to no privilege change. so, the
stack after IRET is still valid. But for 64-bit guests, IRET
unconditionally pops RSP, restoring it to zero. This can cause a nested NMI
to push its interrupt frame to the topmost page (0xffffffff_fffff000),
which may be not mapped and cause triple fault [1].

To fix this issue, push the current SP to the IRET frame, ensuring RSP is
restored to a valid stack in 64-bit mode.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/
---
 x86/eventinj.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index ec8a5ef1..63ebbaab 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -153,6 +153,7 @@ asm("do_iret:"
 	"mov 8(%esp), %edx \n\t"	// virt_stack
 #endif
 	"xchg %"R "dx, %"R "sp \n\t"	// point to new stack
+	"push"W" %"R "sp \n\t"
 	"pushf"W" \n\t"
 	"mov %cs, %ecx \n\t"
 	"push"W" %"R "cx \n\t"
-- 
2.47.3


