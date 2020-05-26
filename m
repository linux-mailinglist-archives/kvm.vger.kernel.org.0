Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B281E2882
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbgEZRXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34437 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388740AbgEZRXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PT+9sIc45kDpdRXOEm8Xg9MAFO/U8LI2utirVVEKJpA=;
        b=UtbtMzCf/GlpWZvKAeIx2YBa/y6AOO88GH/AsSKC6al5qgINlkBYl2HhyU+YEv/eF3FUqN
        d0kNPD+SbfEwDTn4q3GYdUwoPpPhixNtPnYmCscgm5+rrbuc4vjj2psxUOaqhQW1FlaYKR
        NFEZBmM592Bpow2omBRwYgoJlrMY44A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-lZL-I7WRM1i5yn5yU8gw6w-1; Tue, 26 May 2020 13:23:11 -0400
X-MC-Unique: lZL-I7WRM1i5yn5yU8gw6w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82845108BD0B;
        Tue, 26 May 2020 17:23:09 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5C321001B07;
        Tue, 26 May 2020 17:23:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 00/28] KVM: nSVM: event fixes and migration support
Date:   Tue, 26 May 2020 13:22:40 -0400
Message-Id: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compared to v1, this fixes some incorrect injections of VINTR that happen
on kvm/queue while running nested guests, and it clarifies the code
that handles INT_CTL.  The most important part here is the first three
patches, which further cleanup event injection and remove another race
between inject_pending_event and kvm_cpu_has_injectable_intr.

Two other important patches are "KVM: nSVM: restore clobbered INT_CTL
fields after clearing VINTR" and "KVM: nSVM: synthesize correct EXITINTINFO
on vmexit", which fix various hangs that were happening with v1.

Nested Hyper-V is still broken with these patches; the bug is only
marginally related to event injection and the fix is simple, so it can
go into 5.7.  And it's Vitaly who heroically debugged it, so I'll leave
it to him to post it.

Paolo

Paolo Bonzini (28):
  KVM: x86: track manually whether an event has been injected
  KVM: x86: enable event window in inject_pending_event
  KVM: nSVM: inject exceptions via svm_check_nested_events
  KVM: nSVM: remove exit_required
  KVM: nSVM: correctly inject INIT vmexits
  KVM: SVM: always update CR3 in VMCB
  KVM: nVMX: always update CR3 in VMCS
  KVM: nSVM: move map argument out of enter_svm_guest_mode
  KVM: nSVM: extract load_nested_vmcb_control
  KVM: nSVM: extract preparation of VMCB for nested run
  KVM: nSVM: move MMU setup to nested_prepare_vmcb_control
  KVM: nSVM: clean up tsc_offset update
  KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
  KVM: nSVM: remove trailing padding for struct vmcb_control_area
  KVM: nSVM: save all control fields in svm->nested
  KVM: nSVM: restore clobbered INT_CTL fields after clearing VINTR
  KVM: nSVM: synchronize VMCB controls updated by the processor on every
    vmexit
  KVM: nSVM: remove unnecessary if
  KVM: nSVM: extract svm_set_gif
  KVM: SVM: preserve VGIF across VMCB switch
  KVM: nSVM: synthesize correct EXITINTINFO on vmexit
  KVM: nSVM: remove HF_VINTR_MASK
  KVM: nSVM: remove HF_HIF_MASK
  KVM: nSVM: split nested_vmcb_check_controls
  KVM: nSVM: leave guest mode when clearing EFER.SVME
  KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
  selftests: kvm: add a SVM version of state-test
  KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE

 arch/x86/include/asm/kvm_host.h               |  12 +-
 arch/x86/include/asm/svm.h                    |   9 +-
 arch/x86/include/uapi/asm/kvm.h               |  17 +-
 arch/x86/kvm/cpuid.h                          |   5 +
 arch/x86/kvm/irq.c                            |   1 +
 arch/x86/kvm/mmu.h                            |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |  14 +-
 arch/x86/kvm/svm/nested.c                     | 624 ++++++++++++------
 arch/x86/kvm/svm/svm.c                        | 154 ++---
 arch/x86/kvm/svm/svm.h                        |  33 +-
 arch/x86/kvm/vmx/nested.c                     |   5 -
 arch/x86/kvm/vmx/vmx.c                        |  25 +-
 arch/x86/kvm/x86.c                            | 141 ++--
 .../testing/selftests/kvm/x86_64/state_test.c |  69 +-
 14 files changed, 687 insertions(+), 424 deletions(-)

-- 
2.26.2

