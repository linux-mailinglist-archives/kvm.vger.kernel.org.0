Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5275D1C40E6
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgEDRIX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 4 May 2020 13:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730004AbgEDRIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 13:08:22 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207551] unable to handle kernel paging request for VMX
Date:   Mon, 04 May 2020 17:08:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207551-28872-CSaG1fmToc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207551-28872@https.bugzilla.kernel.org/>
References: <bug-207551-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207551

--- Comment #2 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Ugh, I forgot much of a trainwreck the inline VM-Enter asm blob was in 4.19. 
Fixing this isn't nearly as straightforward as it should be, i.e. it'll take a
while to get a proper patch sent.

In the meantime, you should be able to avoid this by deleting the zeroing of
%rcx, e.g.

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index adccdee76520..79a2b64c5971 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10864,7 +10864,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu
*vcpu)

                "xor %%eax, %%eax \n\t"
                "xor %%ebx, %%ebx \n\t"
-               "xor %%ecx, %%ecx \n\t"
                "xor %%edx, %%edx \n\t"
                "xor %%esi, %%esi \n\t"
                "xor %%edi, %%edi \n\t"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
