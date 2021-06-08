Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58D39F2F6
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 11:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFHJ4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 05:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhFHJ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 05:56:39 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90136C061574;
        Tue,  8 Jun 2021 02:54:46 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0B5D2222;
        Tue,  8 Jun 2021 11:54:44 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v3 0/7] x86/sev-es: Fixes for SEV-ES Guest Support
Date:   Tue,  8 Jun 2021 11:54:32 +0200
Message-Id: <20210608095439.12668-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is the next revision of my pending fixes for SEV-ES guest
support. Changes to the previous version are:

	- Removed the patches already merged
	- Added a new fix to map the EFI MOKVar table encrypted
	- Disabled IRQs when GHCB is active
	- Relaxed state tracking by using irqentry_enter()/exit
	  instead of irqentry_nmi_enter()/exit()
	- Changed error reporting from insn_fetch_from_user*() as
	  requested by Boris

Changes are based on tip/x86/urgent. Please review.

Thanks,

	Joerg

Joerg Roedel (6):
  x86/sev-es: Fix error message in runtime #VC handler
  x86/sev-es: Disable IRQs while GHCB is active
  x86/sev-es: Run #VC handler in plain IRQ state
  x86/insn-eval: Make 0 a valid RIP for insn_get_effective_ip()
  x86/insn: Extend error reporting from
    insn_fetch_from_user[_inatomic]()
  x86/sev-es: Propagate #GP if getting linear instruction address failed

Tom Lendacky (1):
  x86/ioremap: Map efi_mem_reserve() memory as encrypted for SEV

 arch/x86/kernel/sev.c    | 61 +++++++++++++++++++++++++---------------
 arch/x86/kernel/umip.c   | 10 +++----
 arch/x86/lib/insn-eval.c | 22 +++++++++------
 arch/x86/mm/ioremap.c    |  4 ++-
 4 files changed, 59 insertions(+), 38 deletions(-)


base-commit: 009767dbf42ac0dbe3cf48c1ee224f6b778aa85a
-- 
2.31.1

