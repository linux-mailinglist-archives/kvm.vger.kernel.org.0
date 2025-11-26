Return-Path: <kvm+bounces-64766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDC8C8C2D2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D2C14E3581
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F062FB977;
	Wed, 26 Nov 2025 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZev+MpK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B761096F;
	Wed, 26 Nov 2025 22:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195404; cv=none; b=MdGDMww3FPImLpLpx+mBe9cit/Zu0GQL8t1Ex2rdZaAc0nGHtovOTjl0qfRrzrpvP9hYo7V7HraEiYGFj+E1HoIkTxw8o+dtqFQKte40yLL/cHboLCRGJSEO1skEYAKd1on+vNGqjUc8jbBpDtLyWoazO5jGOj5ouMLhLcvynSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195404; c=relaxed/simple;
	bh=rNGnWgki6HSzJfX1shDtnCtuaOxz1l7ANVL1kEbENQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnuNXVM/qGFIV79vPYXMVtoGdqBzp7yv19HOBnEKsAVbc68zwREcvLlQ+ZgiL8iJYwTYz0J4O5/YZpinmbmEQRu5S/zBh0YbLhwIuouR/+qHhnAhGUHbVlJrny/KUklMHl3TAPPTaQyhVyMauwDViFlVF4/OXytF74IPxZzOihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZev+MpK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195403; x=1795731403;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rNGnWgki6HSzJfX1shDtnCtuaOxz1l7ANVL1kEbENQk=;
  b=DZev+MpK9E8SyB3id9BK151HSn/iLn9MwkM+O5myiKHoMA8qsJ0W7jc8
   0sF2RXpUOZCUtSiVT13Chrhe1xILipCLThRYabRw/teJCF98puz71hWET
   ffJSz9eVAB80as8JIgQHW8U/KwuwItvuhuBZ3joxYYP9WHJZMKVSBY4Dq
   s7JWN2t3Cl0+25huVQ3YqalKOqMwKHnvznKbQuWW2hzev0Qqnz3SsBs8a
   stB6T6o8Y5wx80iYpRrLNa0iO5idNd5XTqXufzJ0DJ9K3lbkVNYAmME9k
   oaxO6whPudY0CbOW1NUaRO7EPzMbIcW9HK+t4tcOzlBx7CuFMiVOx0Tyc
   A==;
X-CSE-ConnectionGUID: VXuEk9EYTgOOLVpgv8z/KQ==
X-CSE-MsgGUID: FfQHmMWEQCK46ufgU4LuHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="70108520"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="70108520"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:16:42 -0800
X-CSE-ConnectionGUID: hqhoMKahQp+ic9oHL8spxw==
X-CSE-MsgGUID: vh0DOPpJSCeWZ4C9leTw7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193286896"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:16:42 -0800
Date: Wed, 26 Nov 2025 14:16:41 -0800
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
Subject: [PATCH v5 8/9] x86/vmscape: Fix conflicting attack-vector controls
 with =force
Message-ID: <20251126-vmscape-bhb-v5-8-02d66e423b00@linux.intel.com>
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

vmscape=force option currently defaults to AUTO mitigation. This is not
correct because attack-vector controls overrides a mitigation in AUTO mode.
This prevents a user from being able to force VMSCAPE mitigation when it
conflicts with attack-vector controls.

Kernel should deploy a forced mitigation irrespective of attack vectors.
Instead of AUTO, use VMSCAPE_MITIGATION_ON that wins over attack-vector
controls.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 16e54e18cb4e7e9e28c5bee9048886ab685ae5a6..3b9b1f27cc19d3de061814067a5d8797dfa3858b 100644
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
@@ -3254,6 +3256,7 @@ static void __init vmscape_select_mitigation(void)
 		break;
 
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		/*
 		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
 		 * clear sequence. These CPUs are only vulnerable to the BHI variant
@@ -3378,6 +3381,7 @@ void cpu_bugs_smt_update(void)
 	switch (vmscape_mitigation) {
 	case VMSCAPE_MITIGATION_NONE:
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:

-- 
2.34.1



