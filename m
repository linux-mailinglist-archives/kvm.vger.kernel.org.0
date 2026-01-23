Return-Path: <kvm+bounces-68990-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFdDOwWOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68990-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D94E177741
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0AB2B302678B
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D033559E0;
	Fri, 23 Jan 2026 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFLyRaKo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C1F352FB7;
	Fri, 23 Jan 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180433; cv=none; b=IjoWkmCKDu8wLXdQiFyZVYR6VPXf9HhwxsaMeYPhjYk5HQmwjBskB8YmXFse9Ge+ZHpVLaOJI41nw3wgXu0m6GKrFxXf8bZ3XZjO3sIgQDW9X19FSFhl4/IwK7skePk0SaPsbeF1IzVyoOtEboRAZiG66W7NTrsmcw5EUvnRyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180433; c=relaxed/simple;
	bh=a3gRMZp+tq9HMVyIh/sGo+Ksja88/ptZZkRDwyCC7Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1l+1yYjYgNTYpxHeAZXrJDyT6m8uC+jQ6a8Q8GmUF/avdDtLo0nFQ9pO8ENA+0W7g4pTHdbK2p/DhAuKAYGqgImJ2dhgDIFVbwc0f1Uo7FoGlINaFOzf0mcKRqRDKVwQ43z1l4iFtazIs2sFV6yLIyvOLbmsp37wTnyy8EP+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFLyRaKo; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180431; x=1800716431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3gRMZp+tq9HMVyIh/sGo+Ksja88/ptZZkRDwyCC7Tk=;
  b=VFLyRaKotoleROn3GXF6R76gfnr38iMSirec32Qa44nXxSVSZoxZd+Ag
   JW5Mo+9YKN+7KoQQq+/skEew57ip6kKw6QirypvoV7wnDQ/8ahmkNqgyG
   8hE0ivtX9SZdHNeikxFDTHkjJacOZsRdoCEmYyT2m01H4rQ5b5yo6LN7F
   lvEfYe3jPxEPz3zDhFOusLGlsFZJva3BZwGSMwy7cVzsMdWLJF6MpQKev
   Wx/U1Jbwe+TzHv2Qtdj1tyeyIKjYeuEfTpV5D2Rynv7nM6XWJXkdl8Kch
   GP9uY9xh4gF4TZPqPw2kGYIp5gpZ6X+wve3mp56y0YGg064ygxyO5N3lK
   w==;
X-CSE-ConnectionGUID: jEf/q4uBSduqE8nLqpHf3Q==
X-CSE-MsgGUID: /16jzDCYSPWAsfvu6zdysw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334449"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334449"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:16 -0800
X-CSE-ConnectionGUID: kmAe1EgEQ5O/iDp+Qpefww==
X-CSE-MsgGUID: grWDjCIcQ9WFEeV6fbbRmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697156"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:16 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 15/26] x86/virt/seamldr: Abort updates if errors occurred midway
Date: Fri, 23 Jan 2026 06:55:23 -0800
Message-ID: <20260123145645.90444-16-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68990-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D94E177741
X-Rspamd-Action: no action

The TDX Module update process has multiple stages, each of which may
encounter failures.

The current state machine of updates proceeds to the next stage
regardless of errors. But continuing updates when errors occur midway
is pointless.

If a CPU encounters an error, abort the update by setting a flag and
exiting the execution loop. Note that this CPU doesn't acknowledge the
current stage. This will keep all other CPUs in the current stage until
they see the flag and exit the loop as well.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v3:
 - Instead of fast-forward to the final stage, exit the execution loop
   directly.
---
 arch/x86/virt/vmx/tdx/seamldr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 06080c648b02..a13d526b38a7 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -239,6 +239,7 @@ enum tdp_state {
 static struct {
 	enum tdp_state state;
 	atomic_t thread_ack;
+	atomic_t failed;
 } tdp_data;
 
 static void set_target_state(enum tdp_state state)
@@ -277,12 +278,16 @@ static int do_seamldr_install_module(void *params)
 			default:
 				break;
 			}
-			ack_state();
+
+			if (ret)
+				atomic_inc(&tdp_data.failed);
+			else
+				ack_state();
 		} else {
 			touch_nmi_watchdog();
 			rcu_momentary_eqs();
 		}
-	} while (curstate != TDP_DONE);
+	} while (curstate != TDP_DONE && !atomic_read(&tdp_data.failed));
 
 	return ret;
 }
@@ -323,6 +328,7 @@ int seamldr_install_module(const u8 *data, u32 size)
 		return -EBUSY;
 	}
 
+	atomic_set(&tdp_data.failed, 0);
 	set_target_state(TDP_START + 1);
 	ret = stop_machine_cpuslocked(do_seamldr_install_module, params, cpu_online_mask);
 	if (ret)
-- 
2.47.3


