Return-Path: <kvm+bounces-52402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F0AB04CB7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01DFF3BD650
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928812B9B9;
	Tue, 15 Jul 2025 00:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A8M+xmuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D7367
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752538501; cv=none; b=OOt+MJabg0MLAGk1eMd5wn0uQuwFz0CxUZtH4E5FfOE24OPfhAEBvouK0zCcydmpBizPrTFZ2d4yyH0NsrRzM6BrWf2ulzyLltmfuIkTwZbSXxN1QXt8YaEaqSsEAPiNwXbdFEP86zTEOGEKKUi7TmE3tfVOUMTlVmzCMbDQ3/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752538501; c=relaxed/simple;
	bh=K+yzklUu5KYgsSYBisw2NKMLnKNSaciXhxGKP8+4y/8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VLvsNlwz+rsnn7eHm7o9Ocn4IJp2MRJrP7XkAuwnrOAvwEXFPvGezWzR9mzs3Ya3xik/zu0bm+HN1ia7i+HXwRkUQVUzHZj/EiSvSjmGuROdpz+iEfnWBtDyKM8/Ok+8aIOE+l2kyXayeW8bY5ud6pYdin6a+F8IKxzTu3BqD4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A8M+xmuQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752538500; x=1784074500;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K+yzklUu5KYgsSYBisw2NKMLnKNSaciXhxGKP8+4y/8=;
  b=A8M+xmuQprmoNfpFErq3DlYcHH6cB5rnkzmsXaE6zAvk8kfIbFS7uMdj
   NI/D/Cu8WVV8QdUQe1NwPXl4Y0qtPdERgPrm+2oYmMlpk6VKieDxai+Ey
   j/D/rzkoHHfR8GCPQo985sFXH4wOjPiiswIVLgpbQZcr+IrOmuGZaJOKB
   FauQeoCaeeuCQJOVsmpghJmjV83OX6FP9Gmc2kLBBd1VrE//kAkkRyrBp
   +e/k1MZe6YPbxRrvnna1+zI5OLwEVCswPy2pA4cC6WC1lN56Jzb0Sdmyi
   yJSbuNS7YMPoez5PYbHkW5uMSgsx1kBH2yNWjxfZqlb4XAvkQz7oHxYfR
   Q==;
X-CSE-ConnectionGUID: UOZNve0HTPG+GpSRq2ZAyQ==
X-CSE-MsgGUID: TeCPoq3QS8GnL1HQSiBifg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54899807"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="54899807"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 17:15:00 -0700
X-CSE-ConnectionGUID: FYwD1QMgQMSXwoF6YG+i9Q==
X-CSE-MsgGUID: 7k722W19SIKYjjPLQ1biAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157422103"
Received: from qat-xinzeng-256.sh.intel.com ([10.67.114.211])
  by fmviesa009.fm.intel.com with ESMTP; 14 Jul 2025 17:14:58 -0700
From: Xin Zeng <xin.zeng@intel.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	qat-linux@intel.com,
	giovanni.cabiddu@intel.com,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH] vfio/qat: Remove myself from VFIO QAT PCI driver maintainers
Date: Mon, 14 Jul 2025 20:13:57 -0400
Message-Id: <20250715001357.33725-1-xin.zeng@intel.com>
X-Mailer: git-send-email 2.21.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove myself from VFIO QAT PCI driver maintainers as I'm leaving
Intel.

Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fad6cb025a19..886365433105 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26090,7 +26090,6 @@ S:	Maintained
 F:	drivers/vfio/platform/
 
 VFIO QAT PCI DRIVER
-M:	Xin Zeng <xin.zeng@intel.com>
 M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
 L:	kvm@vger.kernel.org
 L:	qat-linux@intel.com
-- 
2.21.3


