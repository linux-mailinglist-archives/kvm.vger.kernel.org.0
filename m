Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D81CBCB0
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgEIDDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:03:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:55091 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbgEIDDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:03:46 -0400
IronPort-SDR: /Q6YsntqP573q4KiBkWmK+RqpaxxOipyzClw/iojjnQMNor5tdxGqRxTpDkMTovl0pii1jESFA
 4bwOWqHztB1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:03:46 -0700
IronPort-SDR: w81V+znp4HRxnQs0OiYVBqqj8WnqelGP6vV18yP9ihv1aue482DOxxu9XQnfYQ5G8r0MuljAVz
 Az3chD+dCYXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311025"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:40 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 2/8] x86/split_lock: Remove bogus case in handle_guest_split_lock()
Date:   Sat,  9 May 2020 19:05:36 +0800
Message-Id: <20200509110542.8159-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bogus case can never happen, i.e., when sld_state == sld_off, guest
won't trigger split lock #AC and of course no handle_guest_split_lock()
will be called.

Beside, drop bogus case also makes future patch easier to remove
sld_state if we reach the alignment that it must be sld_warn or
sld_fatal when handle_guest_split_lock() is called.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
  The alternative would be to remove the "SLD enabled" check from KVM so
  that a truly unexpected/bogus #AC would generate a warn.  It's not clear
  whether or not calling handle_guest_split_lock() iff SLD is enabled was
  intended in the long term.
---
 arch/x86/kernel/cpu/intel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 0e6aee6ef1e8..4602dac14dcb 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1088,9 +1088,8 @@ bool handle_guest_split_lock(unsigned long ip)
 		return true;
 	}
 
-	pr_warn_once("#AC: %s/%d %s split_lock trap at address: 0x%lx\n",
-		     current->comm, current->pid,
-		     sld_state == sld_fatal ? "fatal" : "bogus", ip);
+	pr_warn_once("#AC: %s/%d fatal split_lock trap at address: 0x%lx\n",
+		     current->comm, current->pid, ip);
 
 	current->thread.error_code = 0;
 	current->thread.trap_nr = X86_TRAP_AC;
-- 
2.18.2

