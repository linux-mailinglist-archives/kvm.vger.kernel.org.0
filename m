Return-Path: <kvm+bounces-55011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED92B2C999
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 210E5189BDDB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79CC25A352;
	Tue, 19 Aug 2025 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aXDDHoan"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE8D258ED2;
	Tue, 19 Aug 2025 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755620699; cv=none; b=alFZ2FvKVoRFT400OFeAS1OGN6WlW34MhZd0RXTtw5GvCJd46IkV+CAcsSAUEizcdNTeHIkLVHl5K0TjqvqW1jVuTdYaXrQ0kVCF/xFOtEL9+cGegFcmeRHiLvtlo+eM6eNN1LKK5ckHF5NBvA2esUfhTquVHDq8dQMkaCUWPZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755620699; c=relaxed/simple;
	bh=8pVEV6oITofEjYeY+xm9jxWRganabhKV6CxEQcgo0LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpGt451T/m/2Mg8ADIrhrLddJlYIsmC8T9NUR8cHaJGa/7H8nSY3JvqqS1J38r7hz93TJ8JK14j2x1IXHqcgzDjtrB+JRdHf+COHV5m0S8Hs+8JVk9lbHIqVhdxmVbkkBl8KuOdNQC0LXm/mawTXdNYf1lmP3GTLqhdn3rEHaHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aXDDHoan; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755620699; x=1787156699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pVEV6oITofEjYeY+xm9jxWRganabhKV6CxEQcgo0LA=;
  b=aXDDHoanZ2HqrIR6j0hHgAJNeC7ZgiJI4hp8kdeVXGjriqbKSGiBBt3x
   bbllC1W5kyS8L4GOGDu2Iq2npwT3kMpGtNsimVG4t6M98aM30TG76Iwtd
   uOF7qqK9PIYYSF8Jnn0oEO/9Q61MGJ8l8WEre2H3m7z6mOF37q0tJxo+6
   MSQD0LmNQoX8vHvO7BrEF/5h2eLwWXAcjTSTPMHpgSv3gjJVWW1+fgaS8
   2vCIUcM2dcxKcsARgB2oTpJ+ZC1H5E++jmRMROKzwogb3abupzmFRZcnr
   DQHDIC4/l0AQuMUOWyXTIKcr6fuVsi0DSc6fpnTS0RgLU8QtlkbobtE97
   g==;
X-CSE-ConnectionGUID: PZYJHxfCR4uOMe2ClNHCQA==
X-CSE-MsgGUID: EGYmt5+eTIyqzSSH2ue5rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="60499966"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="60499966"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:24:58 -0700
X-CSE-ConnectionGUID: g0L01IFbQ0CEtUKGmGsupg==
X-CSE-MsgGUID: 4cTtyWDoQX+GIRj8lZD5EQ==
X-ExtLoop1: 1
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.66])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:24:52 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM non-root mode
Date: Tue, 19 Aug 2025 19:24:34 +0300
Message-ID: <20250819162436.137625-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250819162436.137625-1-adrian.hunter@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
valid physical address bits within the machine check bank address register.

This is particularly needed in the case of errors in TDX/SEAM non-root mode
because the reported address contains the TDX KeyID.  Refer to TDX and
TME-MK documentation for more information about KeyIDs.

Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
non-root mode") uses the address to mark the affected page as poisoned, but
omits to use the aforementioned mask.

Investigation of user space expectations has concluded it would be more
correct for the address to contain only address bits in the first place.
Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com

Mask the address when it is read from the machine check bank address
register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
later patch.

It is assumed __log_error() in arch/x86/kernel/cpu/mce/amd.c does not need
similar treatment.

Amend struct mce addr member description slightly to reflect that it is
not, and never has been, an exact copy of the bank's MCi_ADDR MSR.

Fixes: 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine check bank")
Fixes: 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM non-root mode")
Link: https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

      Mask address when it is read
      Amend struct mce addr description


 arch/x86/include/uapi/asm/mce.h | 2 +-
 arch/x86/kernel/cpu/mce/core.c  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/mce.h b/arch/x86/include/uapi/asm/mce.h
index cb6b48a7c22b..abf6ee43f5f8 100644
--- a/arch/x86/include/uapi/asm/mce.h
+++ b/arch/x86/include/uapi/asm/mce.h
@@ -14,7 +14,7 @@
 struct mce {
 	__u64 status;		/* Bank's MCi_STATUS MSR */
 	__u64 misc;		/* Bank's MCi_MISC MSR */
-	__u64 addr;		/* Bank's MCi_ADDR MSR */
+	__u64 addr;		/* Address from bank's MCi_ADDR MSR */
 	__u64 mcgstatus;	/* Machine Check Global Status MSR */
 	__u64 ip;		/* Instruction Pointer when the error happened */
 	__u64 tsc;		/* CPU time stamp counter */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4da4eab56c81..deb47463a75d 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -699,6 +699,9 @@ static noinstr void mce_read_aux(struct mce_hw_err *err, int i)
 		}
 
 		smca_extract_err_addr(m);
+
+		/* Mask out non-address bits, such as TDX KeyID */
+		m->addr &= GENMASK_ULL(boot_cpu_data.x86_phys_bits - 1, 0);
 	}
 
 	if (mce_flags.smca) {
-- 
2.48.1


