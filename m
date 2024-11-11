Return-Path: <kvm+bounces-31444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A23129C3C40
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBAE5B221AC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889CD19E833;
	Mon, 11 Nov 2024 10:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VqKTBahC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377E419E7E0;
	Mon, 11 Nov 2024 10:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321633; cv=none; b=B/cWpp3Qy76AwdRQE4JN02XlW15AXC8uZD0Txtc6P4Ov8LFcaOlaYYUQ6lrVPgtkCq67D8gxFk7JYXgqE+CLWjRM6B4NfgQtwGuD6QwV4Jk0h9hSlavcs2fYLGg54A4Jjzciaz6eD//u8Df/FdN7xu1JNrssn8a0EEdp61sYTgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321633; c=relaxed/simple;
	bh=l/tx6drXiAgelgHqBNwM3hv3iSO7tz9rpGpCDs4Ltsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYHlXK5I5oIiKJf1CuHrvuBzC3AcJGLl7q0GJkmI5QNxEC5B2jxIsaMvvmTk0R54BEUFgTfyUJYUgz2fvRFs2cVBfZ7yeRVKdJMj/FbTb7vqrOeOWpMRh8DbhUHz6SPD5KmaNpUwGB5qinalCcfUkQCnJVhSb1fHNDFrXUP1fH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VqKTBahC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321633; x=1762857633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l/tx6drXiAgelgHqBNwM3hv3iSO7tz9rpGpCDs4Ltsc=;
  b=VqKTBahCvnofaBi5/GEItgh/mUyaPIXPfh8nTH777GyBNckg7jAjDgQf
   sC0vAj5XJQRhr4EAP3Bi1rmZCCoYRGdggrKCFMNVjN+tBmHbtjucy+tTz
   p4lj++w1TgA4PkRQedXDgYanERUi6pbem8sK4Wcf0gLD0yaNzj/FDfnWQ
   HrAKrgWz8xnsJRPWUB9Zsw7IaKlvpgbXEKJ0psB2+zju9Qzcn0LP1iAKN
   MtLKT245/yVeTJVi+tkQCyXgilvFCVwY9UDkdFtLU4FwZZekK0/s6vAA3
   77GRj7u4YgtVOwp+M7fFH0x1fPn6TReqWd2zPbuMtKD3RUyVGcOFmcQSy
   Q==;
X-CSE-ConnectionGUID: pLHLFac7TzqloeIhAbVbpA==
X-CSE-MsgGUID: A5mpHm2XS4anom5712Ud8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682685"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682685"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:33 -0800
X-CSE-ConnectionGUID: OgUpB0wVQ2SR9+VPqqn6eQ==
X-CSE-MsgGUID: 2icPPM8WRBuYG87YlPfnyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667411"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:28 -0800
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v7 05/10] x86/virt/tdx: Add missing header file inclusion to local tdx.h
Date: Mon, 11 Nov 2024 23:39:41 +1300
Message-ID: <d345fd627f93f23bb621ac4bf40c349ec31b9073.1731318868.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731318868.git.kai.huang@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiler attributes __packed and __aligned, and DECLARE_FLEX_ARRAY() are
currently used in arch/x86/virt/vmx/tdx/tdx.h, but the relevant headers
are not included explicitly.

There's no build issue in the current code since this "tdx.h" is only
included by arch/x86/virt/vmx/tdx/tdx.c and it includes bunch of other
<linux/xxx.h> before including "tdx.h".  But for the better explicitly
include the relevant headers to "tdx.h".  Also include <linux/types.h>
for basic variable types like u16.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index ec879d54eb5c..b1d705c3ab2a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,9 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H
 
+#include <linux/types.h>
+#include <linux/compiler_attributes.h>
+#include <linux/stddef.h>
 #include <linux/bits.h>
 
 /*
-- 
2.46.2


