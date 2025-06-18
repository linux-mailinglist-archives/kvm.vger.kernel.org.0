Return-Path: <kvm+bounces-49868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2CFADEB7D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C488A3B0838
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B672DFF08;
	Wed, 18 Jun 2025 12:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4WOmZNw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875E27F01C;
	Wed, 18 Jun 2025 12:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750248585; cv=none; b=K4waRVLcf1nypn/GmALhkm4GrbUwI9XGTfJZcsbW9kHoXFaY8loUM9t4l8C5a4YZZwh8Oln8s3/md7kowbap93onzgvqh2banhXXP1T8TJmAXI2XvQWenwRETzcwjt4bMawRwmSYsWYDuZqt2Gs52lJyx3kWgiRf9SHm4Fd1o0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750248585; c=relaxed/simple;
	bh=ooN+5DOAbIB//yUp1QwQYQ1MPZBGCi4L/+lApGnR54c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S8nLzTEtPagcGvBuxRHCD9BzF+KKB9sfbBai6qC31H0cPBoubLQ/eLGX2W9NVN9KK9pfo5mSlJFa8w9QcXUFimnBH9UT1WurDan67SATFIWvveLRmWH5ud4SGfVHrpH26ktyYHsGjqZ16YrVVfGrDNBoDjd8GNdbMwfSjHngRok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4WOmZNw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750248584; x=1781784584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ooN+5DOAbIB//yUp1QwQYQ1MPZBGCi4L/+lApGnR54c=;
  b=E4WOmZNwCJTDsLJJDlWutNBCUAuv84v9Xh1o9BL1ID3TEYIx0aS+PNQ7
   9qFLultQs4EAEM+X2wrDnDJFgIlrYfAPUUhZ36tATWVBeslHoZL0SYNQ7
   kaFbj64AtnJeuwoX1yr2ZCF/9j413z0XY4jJSvDQ4p9If06mMyPcy+NGW
   A9RAhMsk+igAQPr+cMNQNCvjhFdTfhQ5woxZotlEwRw/ucv5zBy3S0UBl
   Tv6adXlgSlTdVaUr+wls+58WM0ca+/kiAvdfnGzNwWzsCX8syXXigeTnq
   MKSdNks/1lLLL52WxnAE/tNkWoVQEFTjtfKZgt4s2b1+BUfr9OTgi0gKp
   w==;
X-CSE-ConnectionGUID: BvBDFbzfQU2n6MCo9fJzfg==
X-CSE-MsgGUID: rfcZ0EQrRvCbHWbz6gCorQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="77869033"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="77869033"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:34 -0700
X-CSE-ConnectionGUID: u6VDnyBNSTWBpqy6wp9oCA==
X-CSE-MsgGUID: /JtHlLBrQVCQnhDIwXFAQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154213048"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.234])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:27 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH 0/2] Fixes for recovery for machine check in TDX/SEAM non-root mode
Date: Wed, 18 Jun 2025 15:08:04 +0300
Message-ID: <20250618120806.113884-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Here are 2 small fixes related to recovery for machine check in TDX/SEAM
non-root mode.

The issues were noticed as part of work to determine the conditions under
which TDX private memory needs to be cleared after being reclaimed.
For guests with a large amount of memory, clearing all private pages during
VM shutdown can take minutes, so we are looking at when that can be
skipped.  A future patch will deal with that.

One thing that was investigated was the effect of deliberately corrupting a
TDX guest private page by writing to it on the host, and then reading it
on the guest, which results in a machine check as expected, but revealed
the issue addressed in patch 1.

Patch 2 follows on and ensures the poisoned page is not touched.

There are 2 outstanding issues:

1. It is assumed that once the TDX VM is shutdown that the memory is
returned to the allocator.  That is true at present, but may not be in the
future.  Consider, for example, patch set "New KVM ioctl to link a gmem
inode to a new gmem file" :

      https://lore.kernel.org/r/cover.1747368092.git.afranji@google.com/

2. Currently, KVM TDX does not cater for the TDX VM to enter a FATAL error
state, where the only operation permitted is to tear down the VM.  KVM just
carries on, hitting various errors, but in particular, memory reclaim fails
because it is not following the teardown procedure, and all guest private
memory is leaked.


Adrian Hunter (3):
      x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM non-root mode
      KVM: TDX: Do not clear poisoned pages

 arch/x86/kernel/cpu/mce/core.c | 3 ++-
 arch/x86/kvm/vmx/tdx.c         | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)


Regards
Adrian

