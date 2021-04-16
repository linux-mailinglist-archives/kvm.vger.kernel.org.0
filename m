Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC0362438
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243404AbhDPPmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:28335 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343976AbhDPPmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:09 -0400
IronPort-SDR: vd+KVI7AyPpE0REhN8NACwSZDg0YLMktVidU4geP6OQ4tl+TfYVKcHkiqulWZsN6N7eoe/MVML
 6HC1ptSRRsiw==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="195082429"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195082429"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:44 -0700
IronPort-SDR: 3HYELYXhQ0Mx8RIPOamGTgbBRpB0AncsovXkZNC/8m2JSdrcRS+o6IlhQliG1Z6k8LBgLQ4zTa
 Vj7+eJtHfebw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453378493"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2021 08:41:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id F3CE424D; Fri, 16 Apr 2021 18:41:49 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 05/13] x86/kvmclock: Share hvclock memory with the host
Date:   Fri, 16 Apr 2021 18:40:58 +0300
Message-Id: <20210416154106.23721-6-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hvclock is shared between the guest and the hypervisor. It has to be
accessible by host.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..3d004b278dba 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -252,7 +252,7 @@ static void __init kvmclock_init_mem(void)
 	 * hvclock is shared between the guest and the hypervisor, must
 	 * be mapped decrypted.
 	 */
-	if (sev_active()) {
+	if (sev_active() || kvm_mem_protected()) {
 		r = set_memory_decrypted((unsigned long) hvclock_mem,
 					 1UL << order);
 		if (r) {
-- 
2.26.3

