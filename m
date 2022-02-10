Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B8F4B025B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiBJBb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:31:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiBJBbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B79BA6
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FGDzU3a8ZgSo+EyChyw8OQoA90/x+KFn1Dqr157D384=; b=PUcZzppEKjiSSvOMPawtUumi1q
        /pQpXFsRdgTigC1yrxlhef8IyQsCWVyiLbeAU+DsZxjSIF7seWLh45/BdWvrv9397W7r2XgU6CDy4
        ZhKtfu/51xB8A+jEQ0wgbCQ44rysxln683yYvbm4V0rR0HHCBFNhdBNLsrUy6FsLB/Tkj029eeayX
        DXsjNNTPqjtAPcdF215EZY1Ecb4nDUUdJoSFWogxzXDmbcnZgO6H/IeDvNNQ75MvzN72dskaa4cxt
        tnDfPraM/XQ0QyAj8dwen2TD51NnBi3grm+xJRcg1yNqDg2n5AeP5iLFxsmE44D0EdmvZjHtc4tBv
        KbaE+law==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl0-DA; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIx-0019Cg-Ts; Thu, 10 Feb 2022 00:27:23 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 00/15] KVM: Add Xen event channel acceleration
Date:   Thu, 10 Feb 2022 00:27:06 +0000
Message-Id: <20220210002721.273608-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds event channel acceleration for Xen guests. In particular
it allows guest vCPUs to send each other IPIs without having to bounce
all the way out to the userspace VMM in order to do so. Likewise, the
Xen singleshot timer is added, and a version of SCHEDOP_poll. Those
major features are based on Joao and Boris' patches from 2019.

Cleaning up the event delivery into the vcpu_info involved using the new
gfn_to_pfn_cache for that, and that means I ended up doing so for *all*
the places the guest can have a pvclock. And the runstate too, having
rediscovered a bugfix I'd been carrying in my internal tree that got
forgotten upstream until today.

I'm calling this v0 because there's a little bit more work to be done
on documentation and especially self tests for these, but it's basically
ready for review and I wanted to post a version as a fixed point while
I backport it to our environment and do some more testing with actual
Xen guest VMs.

With this, I think the Xen support is as complete as it needs to be for
now. There were more patches in the original set from Oracle, which
allowed the KVM host to act as a Xen dom0 and the Xen PV back end
drivers (netback, blkback, etc.) to communicate via the KVM-emulated
event channels as if it was running underneath true Xen. I haven't
done anything to deliberately break those, although there's been a
certain amount of refactoring as I've merged the other bits so far.
But neither am I planning to pick those up and work on them any
further. I'm OK with the VMM emulating those in userspace, with a
VFIO shim to an underlying NIC or NVMe device.

Boris Ostrovsky (1):
      KVM: x86/xen: handle PV spinlocks slowpath

David Woodhouse (11):
      KVM: x86/xen: Fix runstate updates to be atomic when preempting vCPU
      KVM: x86/xen: Use gfn_to_pfn_cache for runstate area
      KVM: x86: Use gfn_to_pfn_cache for pv_time
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info
      KVM: x86/xen: Make kvm_xen_set_evtchn() reusable from other places
      KVM: x86/xen: Support direct injection of event channel events
      KVM: x86/xen: Add KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
      KVM: x86/xen: Kernel acceleration for XENVER_version
      KVM: x86/xen: Support per-vCPU event channel upcall via local APIC
      KVM: x86/xen: Advertise and document KVM_XEN_HVM_CONFIG_EVTCHN_SEND

Joao Martins (3):
      KVM: x86/xen: intercept EVTCHNOP_send from guests
      KVM: x86/xen: handle PV IPI vcpu yield
      KVM: x86/xen: handle PV timers oneshot mode

 Documentation/virt/kvm/api.rst                     |  129 ++-
 arch/x86/include/asm/kvm_host.h                    |   22 +-
 arch/x86/kvm/irq.c                                 |   11 +-
 arch/x86/kvm/irq_comm.c                            |    2 +-
 arch/x86/kvm/x86.c                                 |  123 +-
 arch/x86/kvm/xen.c                                 | 1191 ++++++++++++++++----
 arch/x86/kvm/xen.h                                 |   69 +-
 include/linux/kvm_host.h                           |    3 +-
 include/uapi/linux/kvm.h                           |   43 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |    6 +
 10 files changed, 1315 insertions(+), 284 deletions(-)



