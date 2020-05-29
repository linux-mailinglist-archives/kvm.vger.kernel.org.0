Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961861E8249
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgE2Pjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:39:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726838AbgE2Pjj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Epmn3nYr/N8EeZcVRj2tMv+zsjPgz0Zj5jT0wPI9k18=;
        b=OuzTJwLJ/gRUd+XXuuGOGOgWt+ARRTmzoGsWPIyVCtq/OA5P9N9jImDlomIwDvdGafo9ji
        9XMoiru0UmjU4XHS0u+cBVvY4j+j0yDP4tMouF2/c6zNI3lrfmnn06V427r7eqipF/i8eb
        JupSoSpxKM2T/Nrcl1fiJMxpvhzxd/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-PRPaYUAxOfmdd1dwkdvrdA-1; Fri, 29 May 2020 11:39:36 -0400
X-MC-Unique: PRPaYUAxOfmdd1dwkdvrdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F031460;
        Fri, 29 May 2020 15:39:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3622F5D9EF;
        Fri, 29 May 2020 15:39:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3 00/28] KVM: nSVM: event fixes and migration support
Date:   Fri, 29 May 2020 11:39:04 -0400
Message-Id: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is basically the same as v2 except that it has a small fix to
"KVM: x86: enable event window in inject_pending_event", where
a second pending interrupt or NMI was not enabling the window-open
vmexit (caught by apic.flat).  In addition I've renamed
inject_pending_event to handle_processor_events.

The series now passes kvm-unit-tests and various nested hypervisor tests
so now it's *really* ready for review!  (Thanks Krish for looking at
it so far).

I'm quite pleased with the overall look of the code, though the
INT_CTL arbitration is a bit ugly.  I have plans to implement nested
vGIF and vLS, and then I will probably clean it up.

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

Vitaly Kuznetsov (2):
  selftests: kvm: introduce cpu_has_svm() check
  selftests: kvm: fix smm test on SVM

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
 arch/x86/kvm/x86.c                            | 146 ++--
 .../selftests/kvm/include/x86_64/svm_util.h   |  10 +
 tools/testing/selftests/kvm/x86_64/smm_test.c |  19 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  62 +-
 16 files changed, 708 insertions(+), 430 deletions(-)

-- 
2.26.2

