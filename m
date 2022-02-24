Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53574C2C0A
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiBXMtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiBXMtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:49:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FF41D8AA1
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FKZviunFbFF99AL1erQXB92t53XqZFsK0IHWzyOGzzU=; b=nxZCKlRJIS/NQ0jhM6CpNJzpXA
        eX72U8SubS/ToCrOQUpLjDshBFHSKJGGooAxmQpNvF+hkqyeGtOJh7muKE39AFsBqRfNMBSwY4WbR
        xgtsbPQuQILUK8veSyLAwWYP8/FFC+eQ/m02CgJtXVhg0V4ceKXQ8VrvRx/e8np/jAzTTdwR7dzic
        PWsW5M3tdCmlmeHKbb5JSHhqo0l3Ea4Gz3WPn9CBs3oWYlumQfow4CaeKBLXQS/44iyFzmYdSaq+v
        KCp7H3rnMvY9PqY22wF+AeSmZHhGZwE4uZuKnvPBLypUFWyV+q7FM2y4Skeu9WWAL27NPQU6/y+7i
        2ynvOBww==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXk-00CcPo-Hl; Thu, 24 Feb 2022 12:48:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXj-0000tt-CG; Thu, 24 Feb 2022 12:48:23 +0000
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
Subject: [PATCH v1 00/16] KVM: Add Xen event channel acceleration
Date:   Thu, 24 Feb 2022 12:48:03 +0000
Message-Id: <20220224124819.3315-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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
the places the guest can have a pvclock. There's a slight wart there,
in that we now need to explicitly *clear* the dirty flag in the cache
in kvm_xen_destroy_vcpu() to prevent the page being marked dirty from
that context when there's no active vCPU — otherwise it would trigger
the warning I added in commit 2efd61a608. That's actually OK for the
Xen case since the VMM will always know where the regions are and it's
reasonable to declare that they should be considered 'always dirty'.

I want to give that deferred dirty marking a little more thought for
the general case of the gfn_to_pfn_cache though.

Changes since my 'v0' proof-of-concept series to invite early heckling:
 • Drop the runstate fix which is merged now.
 • Add Sean's gfn_to_pfn_cache API change at the start of the series.
 • Add KVM self tests
 • Minor bug fixes

Boris Ostrovsky (1):
      KVM: x86/xen: handle PV spinlocks slowpath

David Woodhouse (11):
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
      KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND

Joao Martins (3):
      KVM: x86/xen: intercept EVTCHNOP_send from guests
      KVM: x86/xen: handle PV IPI vcpu yield
      KVM: x86/xen: handle PV timers oneshot mode

Sean Christopherson (1):
      KVM: Use enum to track if cached PFN will be used in guest and/or host

 Documentation/virt/kvm/api.rst                     |  129 +-
 arch/x86/include/asm/kvm_host.h                    |   23 +-
 arch/x86/kvm/irq.c                                 |   11 +-
 arch/x86/kvm/irq_comm.c                            |    2 +-
 arch/x86/kvm/x86.c                                 |  123 +-
 arch/x86/kvm/xen.c                                 | 1257 ++++++++++++++++----
 arch/x86/kvm/xen.h                                 |   69 +-
 include/linux/kvm_host.h                           |   14 +-
 include/linux/kvm_types.h                          |   10 +-
 include/uapi/linux/kvm.h                           |   43 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  340 +++++-
 virt/kvm/pfncache.c                                |   14 +-
 12 files changed, 1700 insertions(+), 335 deletions(-)



