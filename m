Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAFC31D909
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 13:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhBQMDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 07:03:31 -0500
Received: from 8bytes.org ([81.169.241.247]:55946 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhBQMDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 07:03:00 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 2E8D9246;
        Wed, 17 Feb 2021 13:02:08 +0100 (CET)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/3] x86/sev-es: Check for trusted regs->sp in __sev_es_ist_enter()
Date:   Wed, 17 Feb 2021 13:01:40 +0100
Message-Id: <20210217120143.6106-1-joro@8bytes.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here are some changes to the Linux SEV-ES code to check whether the
value in regs->sp can be trusted, before checking whether it points to
the #VC IST stack.

Andy Lutomirski reported that it is entirely possible to reach this
function with a regs->sp value which was set by user-space. So check
for this condition and don't use regs->sp if it can't be trusted.

Also improve the comments around __sev_es_ist_enter/exit() to better
explain what these function do and why they are there.

Please review.

Thanks,

	Joerg

Joerg Roedel (3):
  x86/sev-es: Introduce from_syscall_gap() helper
  x86/sev-es: Check if regs->sp is trusted before adjusting #VC IST
    stack
  x86/sev-es: Improve comments in and around __sev_es_ist_enter/exit()

 arch/x86/include/asm/ptrace.h |  8 ++++++++
 arch/x86/kernel/sev-es.c      | 27 +++++++++++++++++++--------
 arch/x86/kernel/traps.c       |  3 +--
 3 files changed, 28 insertions(+), 10 deletions(-)

-- 
2.30.0

