Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F86B16AE3F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgBXR5Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Feb 2020 12:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbgBXR5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:57:16 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 24 Feb 2020 17:57:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bonzini@gnu.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-bCp5tS1Fl1@https.bugzilla.kernel.org/>
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

--- Comment #12 from Paolo Bonzini (bonzini@gnu.org) ---
Comment on attachment 287579
  --> https://bugzilla.kernel.org/attachment.cgi?id=287579
Patched rc3 dmesg crash output

Based on the crashdump the failure seems to be at:

        if (!svm->vcpu.arch.apic->regs)
                return -EINVAL;

in avic_init_backing_page.  This suggests refining the patch to look like this:

-----
        if (!avic && !irqchip_in_kernel(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(&svm->vcpu);
-----

muncrief, please in addition to testing the patch can you include the qemu
command line (from "ps aux")?  I see nothing in your libvirt XML that suggests
disabling KVM's in-kernel emulation of the local APIC (and the fact that
EPYC-IBPB disables x2APIC also suggests that it's disabled), so we might have
two bugs here.

What is your QEMU version?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
