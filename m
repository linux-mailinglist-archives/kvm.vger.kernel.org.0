Return-Path: <kvm+bounces-68424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C304D38B19
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 65885301D13A
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54FD2236E5;
	Sat, 17 Jan 2026 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJiwZa9I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84348145B3F
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612689; cv=none; b=QVHWhAPWg2X0kP9lZg62VHt/LSeWyYsDTCQFi6ElW/EmgJg7TfQjQbHtOErN3iioBlBk/J5KLEeRAhDts2izntPyV8qXra/iicKO/SG7vsfuO2RaVAShyhtxuS+iW9iTlYEXzvmNHyXlK5D4yVSxtTLuM/I687IXJ3o6/jtO5OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612689; c=relaxed/simple;
	bh=1YGD2m13b08g6ocSDICUbrUDqi3sC1hiqJxS0srsQNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3NoTK3RwFJT/3v6IxpNIC6TrK0NkNLw9DaTK9dLOiKq+6Ouz6Z1x1P6b97OV2ypJp1blYug8uJVqzUhKk6rqGdVpCalyffW3OMWK0BjsQDGyU9dHqc7nH38CtvuyHZhVI1iDGxfrdFW47AglA7JY4P1UnRcpYNvK78/6TEDSjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJiwZa9I; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612689; x=1800148689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1YGD2m13b08g6ocSDICUbrUDqi3sC1hiqJxS0srsQNg=;
  b=RJiwZa9IaeXHqToqKWWSGjZYEJudP3LFbAYlM4flN70hLCYOKyh6++rt
   nsHBOJ/FGve5LkrPl9rst89aGb6jfVIZ0+8yDIdTdg1LVE5McRfPA2Tac
   jqS1eXmf3S1+FnfNC02DytP3DB0rnjb2v4+MY6BhDKKMeAJ+6iZ5h9iO9
   bYW/bUWHMVBfmqNEna2+hG2TM1NdMnVKQ0IAHHcQfzgrvRPjdgm+sRFWC
   jIzrYj/DDRcI02e0CoU1vAAMBn7BFDW6TXY3cynWO2uyNE/SQvDDl1MK2
   bf4SY1pdNx+AIAUTcyZuXgiXuheUfz2IGfjVnDiHY9UDjd3BQwBu7RI0k
   g==;
X-CSE-ConnectionGUID: QsTIeF80TV+LjLj41EJ5RA==
X-CSE-MsgGUID: cXCFcqYzSqmvRFPEzaQkgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131146"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131146"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:07 -0800
X-CSE-ConnectionGUID: 3gTCIqKOQNaUvL1gCEEEKw==
X-CSE-MsgGUID: do0kuAd5TgW1OmLmWJblrA==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:07 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 1/7] target/i386: Disable unsupported BTS for guest
Date: Fri, 16 Jan 2026 17:10:47 -0800
Message-ID: <20260117011053.80723-2-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117011053.80723-1-zide.chen@intel.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BTS (Branch Trace Store), enumerated by IA32_MISC_ENABLE.BTS_UNAVAILABLE
(bit 11), is deprecated and has been superseded by LBR and Intel PT.

KVM yields control of the above mentioned bit to userspace since KVM
commit 9fc222967a39 ("KVM: x86: Give host userspace full control of
MSR_IA32_MISC_ENABLES").

However, QEMU does not set this bit, which allows guests to write the
BTS and BTINT bits in IA32_DEBUGCTL.  Since KVM doesn't support BTS,
this may lead to unexpected MSR access errors.

Setting this bit does not introduce migration compatibility issues, so
the VMState version_id is not bumped.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 2bbc977d9088..f2b79a8bf1dc 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -474,7 +474,10 @@ typedef enum X86Seg {
 
 #define MSR_IA32_MISC_ENABLE            0x1a0
 /* Indicates good rep/movs microcode on some processors: */
-#define MSR_IA32_MISC_ENABLE_DEFAULT    1
+#define MSR_IA32_MISC_ENABLE_FASTSTRING    1
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_DEFAULT       (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
+                                            MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
 
 #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
-- 
2.52.0


