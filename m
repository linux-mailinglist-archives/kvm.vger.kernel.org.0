Return-Path: <kvm+bounces-61238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B127C12151
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 884821892E43
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5BF32E69A;
	Mon, 27 Oct 2025 23:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQ8PzH3i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D118313E36;
	Mon, 27 Oct 2025 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608589; cv=none; b=igJhNxPb7PjxUuE8FRI3akQ2J1z5HYEvRQjSOxGHtqY5ZC5cgovwauWHA74mZKX+SagMBTUDW9iJDMeLXk/G8qmiglPpCna7GBD/9QnwZwDSZyGJZsTRuUmY4STqsLoRigR3wlMgIwPXFISc4yzu+zJ6ttBR7ITMpkRc6DUN7aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608589; c=relaxed/simple;
	bh=8PRSZOz3OHjeA+6W6Lo45QLVMwA5TUUX9b5Mwbql8Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IqOL6yGCszf5gq4k2HXjirUhVgeVIwyBzHG+5/Us6pRqLDME6EMYQfcIrcfOu1VYT1c5rp4Jd390lnJnuqSfOzFuCLqsedwZBFbVm4105177YqK4CqTw3ygiyQJUXMolweqT0qLgcJdqO5trqlMP89gTMr9Pf81dDefXtx4jsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQ8PzH3i; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761608588; x=1793144588;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8PRSZOz3OHjeA+6W6Lo45QLVMwA5TUUX9b5Mwbql8Uw=;
  b=YQ8PzH3iIOa4X/cictbrCgtpgxNddzUgNWRjhB5S5ieyqOzBZLyxHFQc
   9Sm0hS9u8ndLu9cmRjTXLBOWLXwHkeQWmv0CPRlFluOMDGKZyGl3zUvZn
   eWV8s22vcRjfuid38etIi7lCw5xKvM/KcO4SeuGwJdSKNIWRmeQ4zCxkW
   5MYuE+rx55GAx6HT5rmdiTFFImvbqyu5+DvMf6xpF2UZNhwqm6UG0OOAG
   ab8mQ60GnW9sFI9KimPstHbrbUeA5pVKVipEY4gWfxEmu0X7ASPKE97P4
   3GnwZ2V+PLr6pf/HDH7jz9W1oPr0J0fmvpRnLs9/kJqWQfia9utYfD3Z4
   A==;
X-CSE-ConnectionGUID: I7x+TO67TrOTbx9LCA25Gw==
X-CSE-MsgGUID: eRJTTxcaQoKePKuqDbH6NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63738218"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="63738218"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:06 -0700
X-CSE-ConnectionGUID: h/cpjumCT8aP81cn0/PXhw==
X-CSE-MsgGUID: ibRSYSv2SeKJ5NYRSgod4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="184366016"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:05 -0700
Date: Mon, 27 Oct 2025 16:43:04 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v3 0/3] VMSCAPE optimization for BHI variant
Message-ID: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAKvr/2gC/2XNvQrCMBQF4FeRzKYk6R9xUlwcHdzEIU1ubKBNS
 1JDpfTdDRGE4nju4X5nQR6cAY8OuwU5CMabwcaQ73dItsI+ARsVM2KElYTTCofeSzECbtoGq1o
 VFed1rZlG8WN0oM2ctDu6nm7nC3rEc2v8NLh32gg0lV+OFRsuUEywEiXVBCjPC3XsjH3NmbETd
 Jkc+qQF9hMooeVWYFHgVDZKcZkLXv0L67p+APjxREb1AAAA
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

v3:
- s/x86_pred_flush_pending/x86_predictor_flush_exit_to_user/ (Sean).
- Removed IBPB & BHB-clear mutual exclusion at exit-to-userspace.
- Collected tags.

v2: https://lore.kernel.org/r/20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com
- Added check for IBPB feature in vmscape_select_mitigation(). (David)
- s/vmscape=auto/vmscape=on/ (David)
- Added patch to remove LFENCE from VMSCAPE BHB-clear sequence.
- Rebased to v6.18-rc1.

v1: https://lore.kernel.org/r/20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com

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

(pN = N parallel connections)

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
Pawan Gupta (3):
      x86/bhi: Add BHB clearing for CPUs with larger branch history
      x86/vmscape: Replace IBPB with branch history clear on exit to userspace
      x86/vmscape: Remove LFENCE from BHB clearing long loop

 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
 Documentation/admin-guide/kernel-parameters.txt |  4 +-
 arch/x86/entry/entry_64.S                       | 63 ++++++++++++++++++-------
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/include/asm/entry-common.h             | 12 +++--
 arch/x86/include/asm/nospec-branch.h            |  5 +-
 arch/x86/kernel/cpu/bugs.c                      | 53 +++++++++++++++------
 arch/x86/kvm/x86.c                              |  5 +-
 8 files changed, 110 insertions(+), 41 deletions(-)
---
base-commit: fd57572253bc356330dbe5b233c2e1d8426c66fd
change-id: 20250916-vmscape-bhb-d7d469977f2f

Best regards,
-- 
Pawan


