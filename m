Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC54174E01
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 16:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCAPVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 10:21:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgCAPVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 10:21:45 -0500
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8016424672;
        Sun,  1 Mar 2020 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583076104;
        bh=Zmxtyc2Ly2BT+MGlU2PSSqLEt0tOokrlUuZZn0yxQag=;
        h=From:To:Cc:Subject:Date:From;
        b=gvBpnDE5UHb1rV3Xfn1negz9pAcrja8axdigDTcmtPa089m7ingiy+0FWzZzrRxvL
         H+d9JJv7id9aK94oKXQdlUhHpoup8ic/Fbl/rrIWZtVdOpiAmXfSZZFK8ArR2PCKus
         zw8++5rQ9eETMSGaYXegJacYX6anMtBHt5cFKgG4=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] x86/kvm: Remove the rest of do_async_page_fault
Date:   Sun,  1 Mar 2020 07:21:37 -0800
Message-Id: <c42751308a39630e76fb0a159e59db230b384cce.1583076033.git.luto@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I failed to remove the 32-bit asm stub, causing a build failure.  Remove
it.

Fixes: "x86/kvm: Handle async page faults directly through do_page_fault()"
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---

This should probably be folded in to avoid breaking bisection if that's
still convenient.

 arch/x86/entry/entry_32.S | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 7e0560442538..9b5288268aee 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1698,14 +1698,6 @@ SYM_CODE_START(general_protection)
 	jmp	common_exception
 SYM_CODE_END(general_protection)
 
-#ifdef CONFIG_KVM_GUEST
-SYM_CODE_START(async_page_fault)
-	ASM_CLAC
-	pushl	$do_async_page_fault
-	jmp	common_exception_read_cr2
-SYM_CODE_END(async_page_fault)
-#endif
-
 SYM_CODE_START(rewind_stack_do_exit)
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
-- 
2.24.1

