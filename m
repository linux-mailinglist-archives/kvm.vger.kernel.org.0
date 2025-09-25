Return-Path: <kvm+bounces-58710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFD8B9D483
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 05:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B624A167FBE
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 03:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429472E6CC8;
	Thu, 25 Sep 2025 03:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fafSIXu2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C82A2E5B0E;
	Thu, 25 Sep 2025 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758769774; cv=none; b=C/G88qjitOgoGWZzp3sLsbbIsj50sAQ+1hf/K5t0AnYtDzKVVR1A/eUpR7+WjdcdQxsDmi/Hdrc4J2YdRg+LM782p1HtkD7wct6S+rjqA+xIbcQoPjdN8cSvRDgYEVjdLe7o3QMeY+a7vX/3PCy4lPYW8ZR48UT5FlgnLZ9pqYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758769774; c=relaxed/simple;
	bh=7RLxyX/YqC4IwCteU4/Lvp1B0zyCqaI9p16WZF75tEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=t2qgTgiluXzAIbGAF/QFJtWk95szYY4NFlkU5lLh+gR2LXd5PJWZg6/CIOD1lJDb41Bf+0NVP9TAW1XTXN52A722FQ0qgcOTPJhDNRFIU91AFYW4l6uv67scRRCVH/qC+1ObYE2uCnEHiXNZnWJnIKm+YNm0xD4IRC+6M/0RTsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fafSIXu2; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758769772; x=1790305772;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7RLxyX/YqC4IwCteU4/Lvp1B0zyCqaI9p16WZF75tEQ=;
  b=fafSIXu2mPCrefd2NUH42goAe+enjfNrwDNOUN28t3b4OpDkASkIXWMw
   iL3JF/kJXjFWgNGmRvxahFns9Aut5Is1DtwU8HBzx+uo+qlMccjHf/Wq0
   LHWGNnmdSgNxuljUzDMHLQWw0ELVtv6qOYSHGRItD4BFpljQpqOYrgFSW
   STZHfVQGDIuB6cMLX9Ylp0PYXsSPXHTK+9KCnl7hXFsTBbJWujztUEvcy
   eKlRXxsLcAL+SlqYxN2PNCOy/5LfxHmzI6ZSPVhKbWSz+Bmg/+vAl8Rrn
   mXget5xhUylzmQITpcH7y4+JpQ8oPFIQu0q5TD20F6XXU5evwjH0Iqtbv
   Q==;
X-CSE-ConnectionGUID: UyCA8R5sRrmwgs4hsYfDAg==
X-CSE-MsgGUID: 2BUKOb1jR/CdDj7JXI9Ytw==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="61129740"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="61129740"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:24 -0700
X-CSE-ConnectionGUID: 3XEKF5w+QF2quu6sNpukmg==
X-CSE-MsgGUID: OIHeV5LvT9Ku8DTMY/vDdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="207955386"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO desk) ([10.124.220.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:23 -0700
Date: Wed, 24 Sep 2025 20:09:21 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH 0/2] VMSCAPE optimization for BHI variant
Message-ID: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIACKx1GgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDS0Mz3bLc4uTEglTdpIwk3RTzFBMzS0tz8zSjNCWgjoKi1LTMCrBp0Uo
 BjiHOHkqxtbUAfXXXh2QAAAA=
X-Change-ID: 20250916-vmscape-bhb-d7d469977f2f
X-Mailer: b4 0.14.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi All,

These patches aim to improve the performance of a recent mitigation for
VMSCAPE[1] vulnerability. This improvement is relevant for BHI variant of
VMSCAPE that affect Alder Lake and newer processors.

The current mitigation approach uses IBPB on kvm-exit-to-userspace for all
affected range of CPUs. This is an overkill for CPUs that are only affected
by the BHI variant. On such CPUs clearing the branch history is sufficient
for VMSCAPE, and also more apt as the underlying issue is due to poisoned
branch history.

Roadmap:

- First patch introduces clear_bhb_long_loop() for processors with larger
  branch history tables.
- Second patch replaces IBPB on exit-to-userspace with branch history
  clearing sequence.

Below is the iPerf data for transfer between guest and host, comparing IBPB
and BHB-clear mitigation. BHB-clear shows performance improvement over IBPB
in most cases.

Platform: Emerald Rapids
Baseline: vmscape=off

(..._pN below mean N parallel connections)

| iPerf user-net | IBPB    | BHB Clear |
|----------------|---------|-----------|
| UDP 1-vCPU_p1  | -12.5%  |   1.3%    |
| TCP 1-vCPU_p1  | -10.4%  |  -1.5%    |
| TCP 1-vCPU_p1  | -7.5%   |  -3.0%    |
| UDP 4-vCPU_p16 | -3.7%   |  -3.7%    |
| TCP 4-vCPU_p4  | -2.9%   |  -1.4%    |
| UDP 4-vCPU_p4  | -0.6%   |   0.0%    |
| TCP 4-vCPU_p4  |  3.5%   |   0.0%    |

| iPerf bridge-net | IBPB    | BHB Clear |
|------------------|---------|-----------|
| UDP 1-vCPU_p1    | -9.4%   |  -0.4%    |
| TCP 1-vCPU_p1    | -3.9%   |  -0.5%    |
| UDP 4-vCPU_p16   | -2.2%   |  -3.8%    |
| TCP 4-vCPU_p4    | -1.0%   |  -1.0%    |
| TCP 4-vCPU_p4    |  0.5%   |   0.5%    |
| UDP 4-vCPU_p4    |  0.0%   |   0.9%    |
| TCP 1-vCPU_p1    |  0.0%   |   0.9%    |

| iPerf vhost-net | IBPB    | BHB Clear |
|-----------------|---------|-----------|
| UDP 1-vCPU_p1   | -4.3%   |   1.0%    |
| TCP 1-vCPU_p1   | -3.8%   |  -0.5%    |
| TCP 1-vCPU_p1   | -2.7%   |  -0.7%    |
| UDP 4-vCPU_p16  | -0.7%   |  -2.2%    |
| TCP 4-vCPU_p4   | -0.4%   |   0.8%    |
| UDP 4-vCPU_p4   |  0.4%   |  -0.7%    |
| TCP 4-vCPU_p4   |  0.0%   |   0.6%    |

[1] https://comsec.ethz.ch/research/microarch/vmscape-exposing-and-exploiting-incomplete-branch-predictor-isolation-in-cloud-environments/

---
Pawan Gupta (2):
      x86/bhi: Add BHB clearing for CPUs with larger branch history
      x86/vmscape: Replace IBPB with branch history clear on exit to userspace

 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++++
 Documentation/admin-guide/kernel-parameters.txt |  4 ++-
 arch/x86/entry/entry_64.S                       | 47 ++++++++++++++++++-------
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/include/asm/entry-common.h             | 12 ++++---
 arch/x86/include/asm/nospec-branch.h            |  5 ++-
 arch/x86/kernel/cpu/bugs.c                      | 44 ++++++++++++++++-------
 arch/x86/kvm/x86.c                              |  5 +--
 8 files changed, 92 insertions(+), 34 deletions(-)
---
base-commit: 4ea5af08590825c79ba2f146482ed54443e22c28
change-id: 20250916-vmscape-bhb-d7d469977f2f

Best regards,
-- 
Pawan


