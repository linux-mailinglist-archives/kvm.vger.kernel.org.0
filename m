Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D9442071
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhKATGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKATGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:06:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8338C061767
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=+yzDbFfYmLFtjYGAkuTCXDCVi7NDZ2GiXhrJEXgz9w8=; b=Sj61DNQPOBUFwteXVctXffIwrB
        hcGOxav7UF+YWWoYI+KhwqNbdK/GuCvs++mb+/lIYNpk2WuvcWspGnX5wSRGTeP/NfmquJnhUXGAG
        LUPf9Hv43LpYyP0EYdnqKl3Kd01ZEEiwrqiXXDgN/od9TJIAY+xCq2im0fj1EhuGCZb90g4LnMNjh
        ro7T1iEDMxzdBWXKwnOk5xniNHhzQjXFCefheflobNDkPM5uwD8KzjPZuCpJJpp/InMB7GIZER5Vu
        DGNvDtOKtqUqDNdFEv/EZuXBmxx1gKCn6MdPi5FqNV5lOXMBoZTBuHZiM568xlPQJ4Af6X0hwnS6v
        pKBDHMbA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-00DcY0-HG; Mon, 01 Nov 2021 19:03:16 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hK-8E; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 0/6] KVM: x86/xen: Add in-kernel Xen event channel delivery
Date:   Mon,  1 Nov 2021 19:03:08 +0000
Message-Id: <20211101190314.17954-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement 2-level event channel delivery based on the original code from
Joao and Ankur. For IPIs and timers we *really* want to have a completely
in-kernel code path instead of bouncing out to the VMM each time. That
will come next, but this is the basis for it. With this I can wire up
MSI of assigned devices to PIRQs in the guest.

v2: Actually solve the problem of mapping the shared_info page, instead
    of merely declaring that I've reduced it to a previously unsolved
    problem. And having fixed up the broken KVM steal time stuff in a
    separately posted patch.

David Woodhouse (6):
      KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO
      KVM: selftests: Add event channel upcall support to xen_shinfo_test
      KVM: x86/xen: Use sizeof_field() instead of open-coding it
      KVM: Fix kvm_map_gfn()/kvm_unmap_gfn() to take a kvm as their names imply
      KVM: x86/xen: Maintain valid mapping of Xen shared_info page
      KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery

 Documentation/virt/kvm/api.rst                       |  21 +++
 arch/x86/include/asm/kvm_host.h                      |   5 +
 arch/x86/kvm/irq_comm.c                              |  12 ++
 arch/x86/kvm/mmu/mmu.c                               |  23 ++++
 arch/x86/kvm/x86.c                                   |   3 +-
 arch/x86/kvm/xen.c                                   | 340 ++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/xen.h                                   |   9 ++
 include/linux/kvm_host.h                             |  37 ++----
 include/linux/kvm_types.h                            |  27 ++++
 include/uapi/linux/kvm.h                             |  11 ++
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 187 ++++++++++++++++++++++++--
 virt/kvm/kvm_main.c                                  |  11 +-
 12 files changed, 614 insertions(+), 72 deletions(-)



