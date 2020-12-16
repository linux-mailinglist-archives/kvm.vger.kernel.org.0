Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CACB2DB926
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 03:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgLPC3G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Dec 2020 21:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgLPC3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 21:29:06 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Wed, 16 Dec 2020 02:28:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210695-28872-b4D0Lqj7rJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210695-28872@https.bugzilla.kernel.org/>
References: <bug-210695-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210695

--- Comment #2 from Richard Herbert (rherbert@sympatico.ca) ---
Hi, Sean.  I'm no programmer, unfortunately, but when kernel 5.10-rc4 was
released, this was the patch that I suspected had fixed the problem.  I don't
find this code is 5.10.1, so it must have been reverted or moved.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27e381c9da6c2..ff28a5c6abd63 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -49,7 +49,14 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 {
        struct kvm_mmu_page *sp;

+       if (!kvm->arch.tdp_mmu_enabled)
+               return false;
+       if (WARN_ON(!VALID_PAGE(hpa)))
+               return false;
+
        sp = to_shadow_page(hpa);
+       if (WARN_ON(!sp))
+               return false;

        return sp->tdp_mmu_page && sp->root_count;
 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
