Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0D3A6878
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhFNNzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbhFNNzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:55:49 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63857C061766;
        Mon, 14 Jun 2021 06:53:46 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D562937E;
        Mon, 14 Jun 2021 15:53:41 +0200 (CEST)
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
Subject: [PATCH v5 0/6] x86/sev-es: Fixes for SEV-ES Guest Support
Date:   Mon, 14 Jun 2021 15:53:21 +0200
Message-Id: <20210614135327.9921-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is the next revision of my pending fixes for Linux' SEV-ES
support. Changes to the previous version are:

	- Updated patch 2 and implemented wrappers around
	  sev_es_get/put_ghcb() which will disable/enable IRQs when
	  needed.
	- Updated patch 3 to now call the from_user and from_kernel
	  functions of the VC handler directly from entry-asm.

The previous version can be found here:

	https://lore.kernel.org/lkml/20210610091141.30322-1-joro@8bytes.org/

Changes are based on tip/x86/urgent. Please review.

Thanks,

	Joerg


Joerg Roedel (6):
  x86/sev-es: Fix error message in runtime #VC handler
  x86/sev-es: Make sure IRQs are disabled while GHCB is active
  x86/sev-es: Split up runtime #VC handler for correct state tracking
  x86/insn-eval: Make 0 a valid RIP for insn_get_effective_ip()
  x86/insn: Extend error reporting from
    insn_fetch_from_user[_inatomic]()
  x86/sev-es: Propagate #GP if getting linear instruction address failed

 arch/x86/entry/entry_64.S       |   4 +-
 arch/x86/include/asm/idtentry.h |  29 ++---
 arch/x86/kernel/sev.c           | 207 ++++++++++++++++++++------------
 arch/x86/kernel/umip.c          |  10 +-
 arch/x86/lib/insn-eval.c        |  22 ++--
 5 files changed, 156 insertions(+), 116 deletions(-)


base-commit: efa165504943f2128d50f63de0c02faf6dcceb0d
-- 
2.31.1

