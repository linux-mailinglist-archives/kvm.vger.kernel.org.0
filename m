Return-Path: <kvm+bounces-64763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CC47FC8C2C0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 16C7D3542F0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D866B2EDD70;
	Wed, 26 Nov 2025 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qe54myhW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3836B;
	Wed, 26 Nov 2025 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195357; cv=none; b=EVaIj6s+c2SfyF7sDKzZijqLTw3YK/5eNRGO8NVq+gUA3PeZuSEv43osYSw/MCnaHvgpFmzum6mH8bxOukGcRJCuZbVTROZnNcJnpzKrmJrLZbkYTQEyotnOymAI1Q4o+Bcx+wKDP8EII6+j+wd9wKFBg6y5UdXSmyQ/eGY5GKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195357; c=relaxed/simple;
	bh=E6xCR9bLpamxJsQ0brS4ODlqWxsh/fFZQVosRkMhOPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dke0lLRZ/ndAzKCggT3DOIXfqLE/9A8JubCU18taEceF1qqmFGFtWBLHbSr9oDchIEXaBzu02wlKnY/Sd8ltR+HbMttSg71gqCUmHn1GejOfeve+qkODJY0QnsWB7ctaGYcr1oEwk/2Lxay5ot2A6smVuRWF8DSpeNOi6m5tBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qe54myhW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195357; x=1795731357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E6xCR9bLpamxJsQ0brS4ODlqWxsh/fFZQVosRkMhOPo=;
  b=Qe54myhWFWGeRQpRiA96gV2Zg5MW+phlUFQuEiKvgwFo5donX2C2yjHR
   Twt1gYZ5SuQkgSzEbuqnq3B91YzWkN7XLXhlwBmtGmFiCKOrMGqLnWhLW
   4Pxx3/pQEe/9RSlu45qZfGFq1Fi0oQHWpeC+46P/fUi1lbbuaUj2KjH3U
   ZR7UNwaC5LlbEkX7oL+nh1d+YCnPszNVfrKdVSlIJd1jVPxTANC71OMmE
   nnmM7dKbMINR9C9oMhLBxJytJHPletKp+vslPz6gPB3x5hvuSVgh98YZx
   RgGVpEiVjAt1X0AfT3UgGDXc0V8UXvyJAf6MP0ZA9d+edPq9yRVOPpyYo
   w==;
X-CSE-ConnectionGUID: ZmbwuuhnQOKoPvRH0/KURw==
X-CSE-MsgGUID: uPWbnRgqSSyaV3rjbiUMrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="77716060"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="77716060"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:56 -0800
X-CSE-ConnectionGUID: FZfYrmftTxClgr9UTkNvIg==
X-CSE-MsgGUID: CwGHdC6STk63IkW7hvBwOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193084854"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:56 -0800
Date: Wed, 26 Nov 2025 14:15:55 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v5 5/9] x86/vmscape: Use write_ibpb() instead of
 indirect_branch_prediction_barrier()
Message-ID: <20251126-vmscape-bhb-v5-5-02d66e423b00@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>

indirect_branch_prediction_barrier() is a wrapper to write_ibpb(), which
also checks if the CPU supports IBPB. For VMSCAPE, call to
indirect_branch_prediction_barrier() is only possible when CPU supports
IBPB.

Simply call write_ibpb() directly to avoid unnecessary alternative
patching.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index c45858db16c92fc1364fb818185fba7657840991..78b143673ca72642149eb2dbf3e3e31370fe6b28 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -97,7 +97,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	/* Avoid unnecessary reads of 'x86_predictor_flush_exit_to_user' */
 	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
 	    this_cpu_read(x86_predictor_flush_exit_to_user)) {
-		indirect_branch_prediction_barrier();
+		write_ibpb();
 		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
 }

-- 
2.34.1



