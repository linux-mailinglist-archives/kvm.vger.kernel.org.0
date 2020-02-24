Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DCF16B101
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 21:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgBXUgo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Feb 2020 15:36:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgBXUgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 15:36:44 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 24 Feb 2020 20:36:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-XJSDGdR1za@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #13 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287585
  --> https://bugzilla.kernel.org/attachment.cgi?id=287585&action=edit
dmesg crash output with Paolo's latest patch

Hi Paolo. I changed the patch, however it doesn't compile with exactly what you
suggested. You said "!irqchip_in_kernel(vcpu->kvm)" but svm is what's passed to
the function so I had to change it to "!irqchip_in_kernel(&svm->vcpu.kvm)" or
compilation failed. So to be clear the new patch I applied was:

\-      if (!kvm_vcpu_apicv_active(&svm->vcpu))
\+      if (!avic && !irqchip_in_kernel(svm->vcpu.kvm))
                return 0;

        ret = avic_init_backing_page(&svm->vcpu);

However kvm still crashes at boot with the patch from Comment 4 and the new
patch applied. I've attached the dmesg output to this comment. The qemu command
is coming up because I don't see how to attach two files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
