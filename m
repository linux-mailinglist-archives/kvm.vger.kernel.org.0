Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638FF18E404
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 20:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgCUTiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 15:38:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:55983 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgCUThz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 15:37:55 -0400
IronPort-SDR: +Rx1ZYW07g0Ptr3eTy5pTl/0VFKi5XxeGN/1roJVNf32H7zeMrc4a2WpQARhhWP33u4enAmQH0
 jxK197J7eBYw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 12:37:53 -0700
IronPort-SDR: WXb3xou5Qmr5WW8ex0hNZM+Ew9D7J/HSFYceqXfQGAiXC65lJSoEKuSP40uZ6LHZkD582big0+
 tsz1jHfT/rrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="445353676"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 21 Mar 2020 12:37:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
Date:   Sat, 21 Mar 2020 12:37:48 -0700
Message-Id: <20200321193751.24985-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 fixes a a theoretical bug where a crashdump NMI that arrives
while KVM is messing with the percpu VMCS list would result in one or more
VMCSes not being cleared, potentially causing memory corruption in the new
kexec'd kernel.

Patch 2 is cleanup that's made possible by patch 1.

Patch 3 isn't directly related, but it conflicts with the crash cleanup
changes, both from a code and a semantics perspective.  Without the crash
cleanup, IMO hardware_enable() should do crash_disable_local_vmclear()
if VMXON fails, i.e. clean up after itself.  But hardware_disable()
doesn't even do crash_disable_local_vmclear() (which is what got me
looking at that code in the first place).  Basing the VMXON change on top
of the crash cleanup avoids the debate entirely.

v2:
  - Inverted the code flow, i.e. move code from loaded_vmcs_init() to
    __loaded_vmcs_clear().  Trying to share loaded_vmcs_init() with
    alloc_loaded_vmcs() was taking more code than it saved. [Paolo]


Gory details on the crashdump bug:

I verified my analysis of the NMI bug by simulating what would happen if
an NMI arrived in the middle of list_add() and list_del().  The below
output matches expectations, e.g. nothing hangs, the entry being added
doesn't show up, and the entry being deleted _does_ show up.

[    8.205898] KVM: testing NMI in list_add()
[    8.205898] KVM: testing NMI in list_del()
[    8.205899] KVM: found e3
[    8.205899] KVM: found e2
[    8.205899] KVM: found e1
[    8.205900] KVM: found e3
[    8.205900] KVM: found e1

static void vmx_test_list(struct list_head *list, struct list_head *e1,
                          struct list_head *e2, struct list_head *e3)
{
        struct list_head *tmp;

        list_for_each(tmp, list) {
                if (tmp == e1)
                        pr_warn("KVM: found e1\n");
                else if (tmp == e2)
                        pr_warn("KVM: found e2\n");
                else if (tmp == e3)
                        pr_warn("KVM: found e3\n");
                else
                        pr_warn("KVM: kaboom\n");
        }
}

static int __init vmx_init(void)
{
        LIST_HEAD(list);
        LIST_HEAD(e1);
        LIST_HEAD(e2);
        LIST_HEAD(e3);

        pr_warn("KVM: testing NMI in list_add()\n");

        list.next->prev = &e1;
        vmx_test_list(&list, &e1, &e2, &e3);

        e1.next = list.next;
        vmx_test_list(&list, &e1, &e2, &e3);

        e1.prev = &list;
        vmx_test_list(&list, &e1, &e2, &e3);

        INIT_LIST_HEAD(&list);
        INIT_LIST_HEAD(&e1);

        list_add(&e1, &list);
        list_add(&e2, &list);
        list_add(&e3, &list);

        pr_warn("KVM: testing NMI in list_del()\n");

        e3.prev = &e1;
        vmx_test_list(&list, &e1, &e2, &e3);

        list_del(&e2);
        list.prev = &e1;
        vmx_test_list(&list, &e1, &e2, &e3);
}

Sean Christopherson (3):
  KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
  KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
  KVM: VMX: Gracefully handle faults on VMXON

 arch/x86/kvm/vmx/vmx.c | 103 ++++++++++++++++-------------------------
 arch/x86/kvm/vmx/vmx.h |   1 -
 2 files changed, 40 insertions(+), 64 deletions(-)

-- 
2.24.1

