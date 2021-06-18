Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1FB3ACA71
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 13:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhFRL4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 07:56:31 -0400
Received: from 8bytes.org ([81.169.241.247]:47052 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhFRL43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 07:56:29 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 59DD61E9;
        Fri, 18 Jun 2021 13:54:17 +0200 (CEST)
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
Subject: [PATCH v7 0/2] x86/sev: Fixes for SEV-ES Guest Support
Date:   Fri, 18 Jun 2021 13:54:07 +0200
Message-Id: <20210618115409.22735-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

please find here the next iteration of my pending fixes for SEV-ES
guest support in Linux. This version addresses the comments I received
from Peter on the previous version, in particular:

	- Removed IRQ disable/enable calls in the ap-hlt loop code
	- Made __sev_get/put_ghcb() noinstr instead of __always_inline
	  and put instrumentation_begin()/end() calls around panic()
	  to fix an objtool warning.
	- Split up #DB handling in the #VC handler into a from-user
	  and from-kernel part as well.

The patches are again tested with a kernel with various debugging
options enabled, running as an SEV-ES guest.

The previous version of these patches can be found here:

	https://lore.kernel.org/lkml/20210616184913.13064-1-joro@8bytes.org/

Please review.

Thanks,

	Joerg

Joerg Roedel (2):
  x86/sev: Make sure IRQs are disabled while GHCB is active
  x86/sev: Split up runtime #VC handler for correct state tracking

 arch/x86/entry/entry_64.S       |   4 +-
 arch/x86/include/asm/idtentry.h |  29 ++---
 arch/x86/kernel/sev.c           | 182 ++++++++++++++++++--------------
 3 files changed, 113 insertions(+), 102 deletions(-)


base-commit: 07570cef5e5c3fcec40f82a9075abb4c1da63319
-- 
2.31.1

