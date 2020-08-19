Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9CF24953E
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHSGtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:49:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:36074 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbgHSGrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:19 -0400
IronPort-SDR: pO8ndbghVJoe1FLlvGWO00kXqfbiMPYLCgQ/b4T4mn6Xg7gDZvZaDv4BK+ObQJg9tjfCryDxHH
 sMCkgQuqM0YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873177"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873177"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:19 -0700
IronPort-SDR: GVEWlcFU9flCiI3moU0WeDVGivQ+vVlF9D7vvSy+zD7wV+VENc+QzlvDW3JKc+Rc9MegzaMef5
 Ly8cLXK8Eo+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679268"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 2/9] x86/split_lock: Remove bogus case in handle_guest_split_lock()
Date:   Wed, 19 Aug 2020 14:47:00 +0800
Message-Id: <20200819064707.1033569-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bogus case can never happen, i.e., when sld_state == sld_off, guest
won't trigger split lock #AC and of course no handle_guest_split_lock()
will be called.

Besides, drop bogus case also makes future patch easier to remove
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
index c48b3267c141..5dab842ba7e1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1104,9 +1104,8 @@ bool handle_guest_split_lock(unsigned long ip)
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
2.18.4

