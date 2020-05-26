Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F401B7C9C
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgDXRYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:24:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42060 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726698AbgDXRYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587749073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GYFwWH6/BVn1OIKUezAa/Z7+8Oz/hFSaieEazSypgrY=;
        b=By9raioncsbAKwA35r4lnwAszPw9nvcj+m1UAHpQR6kxJGjYmhCOlEgcgBZsMZmPyiD1Rw
        20n8b9vTA/aDxFSmUquy5Hmifg8HTZ9ROjJG/A4MZGh+5GJ8xTPnjcxmkITXhfmCMikuZi
        zfQajh8hILTkBYhx2q4Xk2saWWuHNAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-mEkFw_AbPIqqDggtBGfHpw-1; Fri, 24 Apr 2020 13:24:31 -0400
X-MC-Unique: mEkFw_AbPIqqDggtBGfHpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D86EA48DA;
        Fri, 24 Apr 2020 17:24:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77D2D25277;
        Fri, 24 Apr 2020 17:24:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 00/22] KVM: Event fixes and cleanup
Date:   Fri, 24 Apr 2020 13:23:54 -0400
Message-Id: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v2 of Sean's patch series, where the generic and VMX parts
are left more or less untouched and SVM gets the same cure.  It also
incorporates Cathy's patch to move nested NMI to svm_check_nested_events,
which just works thanks to preliminary changes that switch
svm_check_nested_events to look more like VMX.  In particular, the vmexit
is performed immediately instead of being scheduled via exit_required,
so that GIF is cleared and inject_pending_event automagically requests
an interrupt/NMI/SMI window.  This in turn requires the addition of a
nested_run_pending flag similar to VMX's.

As in the Intel patch, check_nested_events is now used for SMIs as well,
so that only exceptions are using the old mechanism.  Likewise,
exit_required is only used for exceptions (and that should go away next).
SMIs can cause a vmexit on AMD, unlike on Intel without dual-monitor
treatment, and are blocked by GIF=0, hence the few SMI-related changes
in common code (patch 9).

Sean's changes to common code are more or less left untouched, except
for the last patch to replace the late check_nested_events() hack.  Even
though it turned out to be unnecessary for NMIs, I think the new fix
makes more sense if applied generally to all events---even NMIs and SMIs,
despite them never being injected asynchronously.  If people prefer to
have a WARN instead we can do that, too.

Because of this, I added a bool argument to interrupt_allowed, nmi_allowed
and smi_allowed instead of adding a fourth hook.

I have some ideas about how to rework the event injection code in the
way that Sean mentioned in his cover letter.  It's not even that scary,
with the right set of testcases and starting from code that (despite its
deficiencies) actually makes some sense and is not a pile of hacks, and
I am very happy in that respect about the general ideas behind these
patches.  Even though some hacks remain it's a noticeable improvement,
and it's very good that Intel and AMD can be brought more or less on
the same page with respect to nested guest event injection.

Please review!

Paolo

Cathy Avery (1):
  KVM: SVM: Implement check_nested_events for NMI

Paolo Bonzini (10):
  KVM: SVM: introduce nested_run_pending
  KVM: SVM: leave halted state on vmexit
  KVM: SVM: immediately inject INTR vmexit
  KVM: x86: replace is_smm checks with kvm_x86_ops.smi_allowed
  KVM: nSVM: Report NMIs as allowed when in L2 and Exit-on-NMI is set
  KVM: nSVM: Move SMI vmexit handling to svm_check_nested_events()
  KVM: SVM: Split out architectural interrupt/NMI/SMI blocking checks
  KVM: nSVM: Report interrupts as allowed when in L2 and
    exit-on-interrupt is set
  KVM: nSVM: Preserve IRQ/NMI/SMI priority irrespective of exiting
    behavior
  KVM: x86: Replace late check_nested_events() hack with more precise
    fix

Sean Christopherson (11):
  KVM: nVMX: Preserve exception priority irrespective of exiting
    behavior
  KVM: nVMX: Open a window for pending nested VMX preemption timer
  KVM: x86: Set KVM_REQ_EVENT if run is canceled with req_immediate_exit
    set
  KVM: x86: Make return for {interrupt_nmi,smi}_allowed() a bool instead
    of int
  KVM: nVMX: Report NMIs as allowed when in L2 and Exit-on-NMI is set
  KVM: VMX: Split out architectural interrupt/NMI blocking checks
  KVM: nVMX: Preserve IRQ/NMI priority irrespective of exiting behavior
  KVM: nVMX: Prioritize SMI over nested IRQ/NMI
  KVM: x86: WARN on injected+pending exception even in nested case
  KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
  KVM: VMX: Use vmx_get_rflags() to query RFLAGS in
    vmx_interrupt_blocked()

 arch/x86/include/asm/kvm_host.h |   7 ++-
 arch/x86/kvm/svm/nested.c       |  55 ++++++++++++++---
 arch/x86/kvm/svm/svm.c          | 101 ++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h          |  31 ++++++----
 arch/x86/kvm/vmx/nested.c       |  42 ++++++++-----
 arch/x86/kvm/vmx/nested.h       |   5 ++
 arch/x86/kvm/vmx/vmx.c          |  76 ++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |  53 +++++++++--------
 9 files changed, 256 insertions(+), 116 deletions(-)

-- 
2.18.2

