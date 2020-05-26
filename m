Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3159D1E10CC
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391005AbgEYOll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:41:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390921AbgEYOlg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K70tf3jYnNdVjDRvfEDwL8NY4vBMlniBrKknRBAKsXU=;
        b=G2bxfNn/cTATA6nyaUrFhR1ArDMmY0l+N6f/1cDwRbDzvp3zQ9RuUlNgS1sHhYrtwP8Chg
        jbvOmfyfb333bkvwhFzL4xB0PI4LyqqTm7yRDbmjwh5GW595YQJn6KX2WtLznUz/VgfP1x
        mAeMgNtfuqCqyRgRoqSFKzGpOdKobj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-nFF1I69QNRqKWgF8nam1Jg-1; Mon, 25 May 2020 10:41:31 -0400
X-MC-Unique: nFF1I69QNRqKWgF8nam1Jg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1FB31005512;
        Mon, 25 May 2020 14:41:29 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8501B5D9C5;
        Mon, 25 May 2020 14:41:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] KVM: x86: Interrupt-based mechanism for async_pf 'page present' notifications
Date:   Mon, 25 May 2020 16:41:15 +0200
Message-Id: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism,
it seems that re-using #PF exception for a PV mechanism wasn't a great
idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
not present' events and normal APIC interrupts for 'page ready' events.
This series does the later.

Changes since v1:
- struct kvm_vcpu_pv_apf_data's fields renamed to 'flags' and 'token',
  comments added [Vivek Goyal]
- 'type1/2' names for APF events dropped from everywhere [Vivek Goyal]
- kvm_arch_can_inject_async_page_present() renamed to 
  kvm_arch_can_dequeue_async_page_present [Vivek Goyal]
- 'KVM: x86: deprecate KVM_ASYNC_PF_SEND_ALWAYS' patch added.

v1: https://lore.kernel.org/kvm/20200511164752.2158645-1-vkuznets@redhat.com/
QEMU patches for testing: https://github.com/vittyvk/qemu.git (async_pf2_v2 branch)

Vitaly Kuznetsov (10):
  Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and
    "Page Ready" exceptions simultaneously"
  KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
  KVM: rename kvm_arch_can_inject_async_page_present() to
    kvm_arch_can_dequeue_async_page_present()
  KVM: introduce kvm_read_guest_offset_cached()
  KVM: x86: interrupt based APF 'page ready' event delivery
  KVM: x86: acknowledgment mechanism for async pf page ready
    notifications
  KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
  KVM: x86: Switch KVM guest to using interrupts for page ready APF
    delivery
  KVM: x86: drop KVM_PV_REASON_PAGE_READY case from
    kvm_handle_page_fault()
  KVM: x86: deprecate KVM_ASYNC_PF_SEND_ALWAYS

 Documentation/virt/kvm/cpuid.rst     |   6 ++
 Documentation/virt/kvm/msr.rst       | 120 +++++++++++++++------
 arch/s390/include/asm/kvm_host.h     |   4 +-
 arch/s390/kvm/kvm-s390.c             |   2 +-
 arch/x86/entry/entry_32.S            |   5 +
 arch/x86/entry/entry_64.S            |   5 +
 arch/x86/include/asm/hardirq.h       |   3 +
 arch/x86/include/asm/irq_vectors.h   |   6 +-
 arch/x86/include/asm/kvm_host.h      |  12 ++-
 arch/x86/include/asm/kvm_para.h      |  10 +-
 arch/x86/include/uapi/asm/kvm_para.h |  19 +++-
 arch/x86/kernel/irq.c                |   9 ++
 arch/x86/kernel/kvm.c                |  62 +++++++----
 arch/x86/kvm/cpuid.c                 |   3 +-
 arch/x86/kvm/mmu/mmu.c               |  19 ++--
 arch/x86/kvm/svm/nested.c            |   2 +-
 arch/x86/kvm/svm/svm.c               |   3 +-
 arch/x86/kvm/vmx/nested.c            |   2 +-
 arch/x86/kvm/vmx/vmx.c               |   5 +-
 arch/x86/kvm/x86.c                   | 149 ++++++++++++++++++---------
 include/linux/kvm_host.h             |   3 +
 include/uapi/linux/kvm.h             |   1 +
 virt/kvm/async_pf.c                  |  12 ++-
 virt/kvm/kvm_main.c                  |  19 +++-
 24 files changed, 344 insertions(+), 137 deletions(-)

-- 
2.25.4

