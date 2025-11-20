Return-Path: <kvm+bounces-63780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E68C7255A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 875724EA559
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F04A3002B4;
	Thu, 20 Nov 2025 06:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VkbgvXpE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9C2E719B;
	Thu, 20 Nov 2025 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619609; cv=none; b=d22VtDTHpH7w8tKwr7FMRn0cR793hmscyaR84TaYT9Hg7qFICGLA4ck8PCK1kOWdnHQ8z1htCarbMqncjmg4CUEX/DAR+63hUmbkfNBwT0ySILcYAad/CUCllUK1ENNFd/5nVx//awi81BMFT6gTEZ00ZjNJ1wwVjqiKapvk7NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619609; c=relaxed/simple;
	bh=IO/M7Bwqr9leiXpGsKiN4bu0IMpZ39ScvP/BSECK4QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyZJnuaVfy9M3LKuQIn+e8WxUItg7Y6XPEN2xeQBektlSYW1vyQJdQuAErKG0QJs4qRfzQNWjbPqpxVQlhcYUwQcE7Ax/SSWemIN9idG52sT8zt/7tThUO8a3htS75w1tUsXzpOJoTNsaDYwkphd6J3ZCGdSDMpAhGbc29aqoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VkbgvXpE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619608; x=1795155608;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IO/M7Bwqr9leiXpGsKiN4bu0IMpZ39ScvP/BSECK4QY=;
  b=VkbgvXpEqaBUD2xG1weRsXbcd80rS9l4UUj8E8pV/iJ1ltq4yg7oEs5x
   kqHL+Jvc/eYGEZyJDFp5eUHKDVKYQrJluaQTODRmwU8K43dRiLZSnL55B
   e5dkvk9khYLLVIT/Pg4b/DO2NOjabtvpjz6v1OYkPygoDRJRrhBzcOHd0
   Q+YPmXH8AkcMWzk1iP1TBc6fH7o0p9G7VGTzE3NWdSUfWtCcYF6OUQWta
   d5CyhR+1ND4TuEhbuszBeCD8k641Og8S34axPMnxXoXNKdXEnzLbJXdwY
   vy+JjxZXJXo11qjH5DY0hSy3FlgG1A3+phVMZHH/Od/8xF4ImAMlIwreI
   w==;
X-CSE-ConnectionGUID: YZBTu1LiRN+/lsYn3rnraw==
X-CSE-MsgGUID: rwEuckU4QZyVnySXASCrmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69529246"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="69529246"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:20:07 -0800
X-CSE-ConnectionGUID: EJGWwmTIQROSc6JjREdW9g==
X-CSE-MsgGUID: 2PGNOXGsROyYVw5FQugdSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="195395121"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:20:07 -0800
Date: Wed, 19 Nov 2025 22:20:06 -0800
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
Subject: [PATCH v4 10/11] x86/vmscape: Override conflicting attack-vector
 controls with =force
Message-ID: <20251119-vmscape-bhb-v4-10-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

vmscape=force option currently defaults to AUTO mitigation. This is not
correct because attack-vector controls override a mitigation when in AUTO
mode. This prevents a user from being able to force VMSCAPE mitigation when
it conflicts with attack-vector controls.

Kernel should deploy a forced mitigation irrespective of attack vectors.
Instead of AUTO, use VMSCAPE_MITIGATION_ON that wins over attack-vector
controls.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d12c07ccf59479ecf590935607394492c988b2ff..81b0db27f4094c90ebf4704c74f5e7e6b809560f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3197,6 +3197,7 @@ static void __init srso_apply_mitigation(void)
 enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_NONE,
 	VMSCAPE_MITIGATION_AUTO,
+	VMSCAPE_MITIGATION_ON,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
 	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
@@ -3205,6 +3206,7 @@ enum vmscape_mitigations {
 static const char * const vmscape_strings[] = {
 	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
+	/* [VMSCAPE_MITIGATION_ON] */
 	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
 	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
 	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
@@ -3224,7 +3226,7 @@ static int __init vmscape_parse_cmdline(char *str)
 		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
-		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
+		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}
@@ -3259,6 +3261,7 @@ static void __init vmscape_select_mitigation(void)
 			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		break;
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		/*
 		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
 		 * clear sequence. These CPUs are only vulnerable to the BHI variant
@@ -3381,6 +3384,7 @@ void cpu_bugs_smt_update(void)
 	switch (vmscape_mitigation) {
 	case VMSCAPE_MITIGATION_NONE:
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:

-- 
2.34.1



