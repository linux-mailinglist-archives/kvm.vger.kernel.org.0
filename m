Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DAE1AF96
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 06:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEME6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 00:58:25 -0400
Received: from ozlabs.org ([203.11.71.1]:47453 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfEME6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 00:58:25 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 452T9B6rBDz9sBb; Mon, 13 May 2019 14:58:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1557723502; bh=gUgthbd3p894VRleHOuf7GpbbyH7Yyda3mxXmgGT80A=;
        h=Date:From:To:Cc:Subject:From;
        b=nMMD/msqyzunID0tUOEcLrqsp7hlGH2v2ESRmDUfvLM0bjB9aianK20iGtSsV2fwe
         IpKVmQtAoBSJe4BXfEUgR/mJEt0xRsAE18yi0QBzKzCjDeCnAjg7gc11ygXHanm1yg
         9hj0Ocf+JrRgi/ramt0ViK/5i9OraMIYXDhB0IWCcveCR0UpdUquzBraDpgsO1G91t
         rvtz0b6mlot7iP7tKA578WqaEe0byc084Gf+jyjrl1Cy1tl92MYji9Hl1XTNB/x6Nj
         nGZ5oiHCYRBD83iqhM7QKiwEqll3kdPl1yUEUN0VhambtH62HExw6/g252ln0M3Qny
         hpc4B5QDaGGbQ==
Date:   Mon, 13 May 2019 14:58:18 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S HV: Make sure to load LPID for radix VCPUs
Message-ID: <20190513045818.GA10318@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 70ea13f6e609 ("KVM: PPC: Book3S HV: Flush TLB on secondary radix
threads", 2019-04-29) aimed to make radix guests that are using the
real-mode entry path load the LPID register and flush the TLB in the
same place where those things are done for HPT guests.  However, it
omitted to remove a branch which branches around that code for radix
guests.  The result is that with indep_thread_mode = N, radix guests
don't run correctly.  (With indep_threads_mode = Y, which is the
default, radix guests use a different entry path.)

This removes the offending branch, and also the load and compare that
the branch depends on, since the cr7 setting is now unused.

Reported-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Fixes: 70ea13f6e609 ("KVM: PPC: Book3S HV: Flush TLB on secondary radix threads")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index ad1fc01..ad7bee9 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -581,11 +581,8 @@ kvmppc_hv_entry:
 1:
 #endif
 
-	/* Use cr7 as an indication of radix mode */
 	ld	r5, HSTATE_KVM_VCORE(r13)
 	ld	r9, VCORE_KVM(r5)	/* pointer to struct kvm */
-	lbz	r0, KVM_RADIX(r9)
-	cmpwi	cr7, r0, 0
 
 	/*
 	 * POWER7/POWER8 host -> guest partition switch code.
@@ -608,9 +605,6 @@ kvmppc_hv_entry:
 	cmpwi	r6,0
 	bne	10f
 
-	/* Radix has already switched LPID and flushed core TLB */
-	bne	cr7, 22f
-
 	lwz	r7,KVM_LPID(r9)
 BEGIN_FTR_SECTION
 	ld	r6,KVM_SDR1(r9)
-- 
2.7.4

