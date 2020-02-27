Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BCC17218F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 15:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgB0Ott convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 09:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgB0Ott (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 09:49:49 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Thu, 27 Feb 2020 14:49:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: suravee.suthikulpanit@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-pjq6BvjJrG@https.bugzilla.kernel.org/>
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

--- Comment #26 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) ---
There are several reason that could inhibit the AVIC from being activated even
though it is enabled during module load (i.e. modprobe kvm_amd avic=1).

Could you please try the following patch:

---- BEGIN PATCH ----
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0f..fb7e5a6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -995,6 +995,7 @@ struct kvm_vm_stat {
        ulong lpages;
        ulong nx_lpage_splits;
        ulong max_mmu_page_hash_collisions;
+       ulong apicv_inhibit_reasons;
 };

 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64e..2c968a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -222,6 +222,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
        { "nx_largepages_splitted", VM_STAT(nx_lpage_splits, .mode = 0444) },
        { "max_mmu_page_hash_collisions",
                VM_STAT(max_mmu_page_hash_collisions) },
+       { "apicv_inhibit_reasons", VM_STAT(apicv_inhibit_reasons, .mode = 0444)
},
        { NULL }
 };

@@ -8051,6 +8052,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool
activate, ulong bit)
                        return;
        }

+       kvm->stat.apicv_inhibit_reasons = kvm->arch.apicv_inhibit_reasons;
        trace_kvm_apicv_update_request(activate, bit);
        if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
                kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
---- END PATCH ----

Then, while running the VM, please run "cat
/sys/kernel/debug/kvm/*/apicv_inhibit_reasons". This should allow us to see why
KVM deactivate AVIC.

Trying your XML file in the description, I also noticed that AVIC is
deactivated for the VM. However, when I tries specifying EPYC-IBPB model in the
XML, then it creates the VM w/ AVIC activated. Could you please give it a try?

Thanks,
Suravee

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
