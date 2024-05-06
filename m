Return-Path: <kvm+bounces-16696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 503BB8BC9B2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E54001F2274E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583681428F7;
	Mon,  6 May 2024 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MaXbqvrY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA451420D4
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984685; cv=none; b=ZQL6CK7vtr5PfnlpgfuxQVcNqZDGompdwu6feERFzM1PKohUUI51rjJ1aeggvPIBqt6eSEsveXjoK18zX+t6/oT8mkg5+MG/tD4mzWqBIhGVLmozjnCUkEv3vyQvLOQS7AvhFTamHRloqmzqSCsf4ppHahanIlhPYybOtZNhUgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984685; c=relaxed/simple;
	bh=R4trk+H0mPF/t62AN97t8+Kv8Yiy7IDTzo4yU4vF/s4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZazHZuoKq4hersEDVh0CsbLhAMqceM7BEYgHfhVVEGOA3ppCy0N6GMteQQeX3H0ykOy8aHpfDXm45KAlR8HMqpoKt+uNMk278VJ+qdZmUDw4Nl0cy9LRWTNSQ+5+gfqW/q8YHbwY8L4fXjzOJwd1hA2U4joq130L1nNpnOaEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MaXbqvrY; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984684; x=1746520684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R4trk+H0mPF/t62AN97t8+Kv8Yiy7IDTzo4yU4vF/s4=;
  b=MaXbqvrYdm0d6tqIeI7xWFOJ90AThERVIejsClmBOXY7pDTXyv2ig1fS
   RmsvWINIBcCP9kKJOR1CvZKss5aI8nfJ5XI4CCljlrHSUeZ/DNcMIjpVi
   J3iPhlT76KWqammKI1+EU5N0co3MlorwUB07ASUMXgQG6Joi06hSYriQZ
   v0cHb0Gexd3CDSDwEG48pMYqgb7qNnnhwKR2rKkVXIfTNSipqSqjJFV7i
   kjuRZhZ+EbTvu+pu0Qtbim9MwU5q1nhKEFFhY9FmWFuJrIVDaUb5UASYc
   NLs7uJxRKnKflUSItwXeYTRFgk48ZrhqHKNXcW1veU82bN8fBVXTBc2Ya
   w==;
X-CSE-ConnectionGUID: oEHgjjzjSLWQFNCn9uCPGg==
X-CSE-MsgGUID: VqlNtjkjSXqOZLSr6DPa4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14533376"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14533376"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:38:04 -0700
X-CSE-ConnectionGUID: psUkXkENSL2KfBdKRk4RKg==
X-CSE-MsgGUID: 3HDy4qf6SWOs6ysskfFemw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28186755"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2024 01:38:01 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 6/6] target/i386/confidential-guest: Fix comment of x86_confidential_guest_kvm_type()
Date: Mon,  6 May 2024 16:51:53 +0800
Message-Id: <20240506085153.2834841-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240506085153.2834841-1-zhao1.liu@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the comment to match the X86ConfidentialGuestClass
implementation.

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/confidential-guest.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 532e172a60b6..06d54a120227 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -44,7 +44,7 @@ struct X86ConfidentialGuestClass {
 /**
  * x86_confidential_guest_kvm_type:
  *
- * Calls #X86ConfidentialGuestClass.unplug callback of @plug_handler.
+ * Calls #X86ConfidentialGuestClass.kvm_type() callback.
  */
 static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
 {
-- 
2.34.1


