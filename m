Return-Path: <kvm+bounces-16041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6178B3491
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05C611F223AF
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808F01428EE;
	Fri, 26 Apr 2024 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="auqREDhS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FA714265F
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125212; cv=none; b=FXJoYh0YhYowavj+SNcgua+ytaeMckKaUf2riNl8g5RUZu04233lyQIcoKRsSZdAKsYJlz76u/rweqXeBi9GO+wDpxiALyP7ikpuPnU6SxIixYUHhbrXX2x36Accr4zNDo1BLbMWNvFLAsLyNyOLwys7/clofFRfNQmAEUyXJfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125212; c=relaxed/simple;
	bh=7R08FKECIPjQbStAmaj758BPN/jbNEye6fo49Yfk9yA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HAqIPer7182cFjcbgFa2IwNq/B32KAjdNYAUNC3/3b1lY2HlD3LCwWPT7G/M8Kus7xZCm1byk1JICeM/Zd518Ou25mZRMKRA5/1XdP8VKVH9SvE9scR4iAJGM+fyysE4nhpuD0ThyGjo5DzG8njT7yOrdaVCwfeC3uMaWWmyAZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=auqREDhS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714125211; x=1745661211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7R08FKECIPjQbStAmaj758BPN/jbNEye6fo49Yfk9yA=;
  b=auqREDhSN25/AWVoN3sN5Hfz3jKFXRQyCFpUkXkGX7otlTis5+KDca+E
   CovsNmBVup1Kpb9m+BJPcUmZNxzjjqia6KThvv2sTtHCQgzXyNUQPtMsr
   jmEB9bJzN/TiaMBkL0f3cWbA3TbzDXC6JmM12IlEvFOb7lflUDUxlB9y1
   y5fCHCtIJ+D64sQCJoPMYR3Pk968cTebo+8d+Vy3tDYr3Z80n4VDpt9hp
   3q0HxPF1DgzcTSUamUH0RtvgbBkzQ60Hb1QNHw2Ir7fTnangRBO41CWDM
   hqn6u69UrQMbQcXaMvlG78GgaY+37KJ+YDDpaS8N28uAd0vwAfnEK61Oa
   Q==;
X-CSE-ConnectionGUID: H36GkS2FSca58cMa52OwDw==
X-CSE-MsgGUID: 75ZwLD/JRo6EXsa/lcq+AA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9707446"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9707446"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:53:31 -0700
X-CSE-ConnectionGUID: mKE73GDjSNKXvKTYLA0w8g==
X-CSE-MsgGUID: bjFA5tHjQ9yU0UwwawPoHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25412346"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 26 Apr 2024 02:53:29 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 6/6] target/i386/confidential-guest: Fix comment of x86_confidential_guest_kvm_type()
Date: Fri, 26 Apr 2024 18:07:16 +0800
Message-Id: <20240426100716.2111688-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426100716.2111688-1-zhao1.liu@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the comment to match the X86ConfidentialGuestClass
implementation.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
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


