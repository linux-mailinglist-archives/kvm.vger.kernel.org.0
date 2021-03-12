Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0FB338D3B
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 13:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhCLMi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 07:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhCLMie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 07:38:34 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545BEC061574;
        Fri, 12 Mar 2021 04:38:34 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 724822A6;
        Fri, 12 Mar 2021 13:38:30 +0100 (CET)
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
Subject: [PATCH v3 0/8] x86/seves: Support 32-bit boot path and other updates
Date:   Fri, 12 Mar 2021 13:38:16 +0100
Message-Id: <20210312123824.306-1-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

these patches add support for the 32-bit boot in the decompressor
code. This is needed to boot an SEV-ES guest on some firmware and grub
versions. The patches also add the necessary CPUID sanity checks and a
32-bit version of the C-bit check.

Other updates included here:

        1. Add code to shut down exception handling in the
           decompressor code before jumping to the real kernel.
           Once in the real kernel it is not safe anymore to jump
           back to the decompressor code via exceptions.

        2. Replace open-coded hlt loops with proper calls to
           sev_es_terminate().

Please review.

Thanks,

	Joerg

Changes v2->v3:

	- Added a patch to remove the check for the Hypervisor CPUID
	  bit for detecting SEV

Changes v1->v2:

	- Addressed Boris' review comments.
	- Fixed a bug which caused the cbit-check to never be
	  executed even in an SEV guest.

Joerg Roedel (8):
  x86/boot/compressed/64: Cleanup exception handling before booting
    kernel
  x86/sev: Do not require Hypervisor CPUID bit for SEV guests
  x86/boot/compressed/64: Reload CS in startup_32
  x86/boot/compressed/64: Setup IDT in startup_32 boot path
  x86/boot/compressed/64: Add 32-bit boot #VC handler
  x86/boot/compressed/64: Add CPUID sanity check to 32-bit boot-path
  x86/boot/compressed/64: Check SEV encryption in 32-bit boot-path
  x86/sev-es: Replace open-coded hlt-loops with sev_es_terminate()

 arch/x86/boot/compressed/head_64.S     | 170 ++++++++++++++++++++++++-
 arch/x86/boot/compressed/idt_64.c      |  14 ++
 arch/x86/boot/compressed/mem_encrypt.S | 130 ++++++++++++++++++-
 arch/x86/boot/compressed/misc.c        |   7 +-
 arch/x86/boot/compressed/misc.h        |   6 +
 arch/x86/boot/compressed/sev-es.c      |  12 +-
 arch/x86/kernel/sev-es-shared.c        |  16 +--
 arch/x86/mm/mem_encrypt_identity.c     |  35 ++---
 8 files changed, 340 insertions(+), 50 deletions(-)

-- 
2.30.1

