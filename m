Return-Path: <kvm+bounces-54624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69F4B257F7
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3F207B99DE
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 23:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBE72F99B1;
	Wed, 13 Aug 2025 23:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VZwdUYNe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D13301ABA;
	Wed, 13 Aug 2025 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129593; cv=none; b=mOuCFPM1b5vFscP6NiRDVenFOVPBDlyBNGLyCC8zKncQXfgRyKs0oT33kClwSMJpDEu16aYzQJX1xIkKUZLwK+T3CZvAjiyOXivjeHGPDJLQzSi7DRPllK/MJRTWd4L6pYaGpDK6JpZxZ40frHQ78RJgx0eacdvQTGCkruAvw4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129593; c=relaxed/simple;
	bh=ObPUqNlIio++VGV8CmQ4YDrJyoIrTWqqB4hd4548ko4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su8Z+TeadqTymyU7WadU0IyChqfklgxALLns5ozdVRFnP1wG277Z89zc/FAEIZfs+dGYbCBG3KXm9CzV9wpC/Yvuqj/utwIMkvY2FcC8hZDx7kN5IZsJU4mQ300GTgOhOR+tgRh+JNlAOgRQnErMlEDYA5uKri6HVGa+KUcuH3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VZwdUYNe; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129591; x=1786665591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ObPUqNlIio++VGV8CmQ4YDrJyoIrTWqqB4hd4548ko4=;
  b=VZwdUYNeslKQhzAgGENmfjbB1RJMQ/IwUW2LnuYHyHyHsYUPJFwJN4fd
   AdyUgSEgEs6FBwkIWftyHvK1+5sTc1EXTtDYvAAryDCuGiIzK0nmUTE+Y
   HXIr0zEJ9HMQ7cgsqpry7RTAInShidS8/B+YWwju8VDORmjkwHTvAoJ6g
   J1ZsI/l7Kl35JRdMSrd5mZe/6mBVmqMt9YlSprASv1ZdfbS+zvqSfEL6T
   qfWhbyIT9BrcbFIM2G6r/6/fl7rrHooM/D87hVcsD2wXGju2XRNSVqOrc
   w8qlcOoOK5wHHizUR9CqI61sG2xW8Ot89Vo6XONANUiKtwA0dqYbbDp8y
   g==;
X-CSE-ConnectionGUID: sZs1+CtpTOW2vIMzLLf4gg==
X-CSE-MsgGUID: zqek1qAYQ4elrUCoc4NmsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014725"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014725"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:51 -0700
X-CSE-ConnectionGUID: B8Hw4YhmSfmRDWDk7SR/BA==
X-CSE-MsgGUID: 0SLtXStxR9OvIxjimvo8Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105149"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:46 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH v6 5/7] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Date: Thu, 14 Aug 2025 11:59:05 +1200
Message-ID: <c94874f886ea826bacc80cfb4bd77eb6bcede233.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755126788.git.kai.huang@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During kexec it is now guaranteed that all dirty cachelines of TDX
private memory are flushed before jumping to the new kernel.  The TDX
private memory from the old kernel will remain as TDX private memory in
the new kernel, but it is OK because kernel read/write to TDX private
memory will never cause machine check, except on the platforms with the
TDX partial write erratum, which has already been handled.

It is safe to allow kexec to work together with TDX now.  Remove the
!KEXEC_CORE dependency.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100..e2cbfb021bc6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1896,7 +1896,6 @@ config INTEL_TDX_HOST
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
 	depends on CONTIG_ALLOC
-	depends on !KEXEC_CORE
 	depends on X86_MCE
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
-- 
2.50.1


