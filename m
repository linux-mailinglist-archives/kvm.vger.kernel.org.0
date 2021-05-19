Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732E0388F83
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353794AbhESNye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:54:34 -0400
Received: from 8bytes.org ([81.169.241.247]:39974 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239473AbhESNyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 09:54:32 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id EF587104;
        Wed, 19 May 2021 15:53:07 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
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
Subject: [PATCH v2 0/8] x86/sev-es: Fixes for SEV-ES Guest Support
Date:   Wed, 19 May 2021 15:52:43 +0200
Message-Id: <20210519135251.30093-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is the second version of my pending SEV-ES fixes. The most
important patches are patch 1 to 5, as they fix warnings and splats
that trigger with various debugging options are enabled.

Patches 6 to 8 fix a correctness issue in the instruction emulation
part of the #VC exception handler.

Please review.

Thanks,

	Joerg

Link to v1: https://lore.kernel.org/lkml/20210512075445.18935-1-joro@8bytes.org/

Changes since v1:

	- Documented why __get_user()/__put_user() are safe to use in
	  the #VC handlers memory access path.

	- Merged the revert into patch 3

	- Refactored code in the instruction decoder and added #GP
	  reporting when getting the instructions linear address fails.

Joerg Roedel (8):
  x86/sev-es: Don't return NULL from sev_es_get_ghcb()
  x86/sev-es: Forward page-faults which happen during emulation
  x86/sev-es: Use __put_user()/__get_user() for data accesses
  x86/sev-es: Fix error message in runtime #VC handler
  x86/sev-es: Leave NMI-mode before sending signals
  x86/insn-eval: Make 0 a valid RIP for insn_get_effective_ip()
  x86/insn: Extend error reporting from
    insn_fetch_from_user[_inatomic]()
  x86/sev-es: Propagate #GP if getting linear instruction address failed

 arch/x86/include/asm/insn-eval.h |   6 +-
 arch/x86/kernel/sev.c            | 127 +++++++++++++++++++++----------
 arch/x86/kernel/umip.c           |  10 +--
 arch/x86/lib/insn-eval.c         |  52 ++++++++-----
 4 files changed, 129 insertions(+), 66 deletions(-)


base-commit: a50c5bebc99c525e7fbc059988c6a5ab8680cb76
-- 
2.31.1

