Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9772B16B395
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgBXWJZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Feb 2020 17:09:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:09:25 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 24 Feb 2020 22:09:24 +0000
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
Message-ID: <bug-206579-28872-b2sR0q7frK@https.bugzilla.kernel.org/>
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

--- Comment #17 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287597
  --> https://bugzilla.kernel.org/attachment.cgi?id=287597&action=edit
Success! Working dmesg output.

Okay gentlemen, I looked at the other code and it seemed to me that the
condition should be an "or" instead of an "and" so I changed the patch again
and my host system and VM both booted and are running perfectly as far as I can
tell. However I have no idea if avic is actually working or whether what I've
done is correct or not.

In any case, I attached the working dmesg output to this comment, and here's
the final code I ended up with for avic_init_vcpu:

```
static int avic_init_vcpu(struct vcpu_svm *svm)
{
        int ret;
        struct kvm_vcpu *vcpu = &svm->vcpu;

        if (!avic || !irqchip_in_kernel(vcpu->kvm))
                return 0;

        ret = avic_init_backing_page(&svm->vcpu);
        if (ret)
                return ret;

        INIT_LIST_HEAD(&svm->ir_list);
        spin_lock_init(&svm->ir_list_lock);
        svm->dfr_reg = APIC_DFR_FLAT;

        return ret;
}
```

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
