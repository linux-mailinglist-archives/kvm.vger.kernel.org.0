Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEBC32B59E
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381782AbhCCHSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835964AbhCBTfW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Pm8U7783eTBzracU7yO9O6aG+pKK1KJodZl/TS24CJM=;
        b=emoBSSQnUEeoeUV0NLPBYC2YFb31AaAmgCnhwc+cMRDF7GSAA+wzS0zZTZ6hgCUgy/fSNT
        0mUuqegOD4SsR0zhCrgFqhdlMqc/L7IbLVx8ZCj47MoCG5swAfbD0Km5gU231UdCZfRs9W
        /RkH3akoPKHQmON5F+tsGw+kabUwLW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-A4GQGkZbPjiQ0LdTJtkftA-1; Tue, 02 Mar 2021 14:33:46 -0500
X-MC-Unique: A4GQGkZbPjiQ0LdTJtkftA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD916804023;
        Tue,  2 Mar 2021 19:33:44 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E8F960BFA;
        Tue,  2 Mar 2021 19:33:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 00/23] SVM queue for 5.13
Date:   Tue,  2 Mar 2021 14:33:20 -0500
Message-Id: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This includes:

- vmcb01/vmcb02 split.  Unfortunately this is a wash in terms of
  nested vmexit speed, which I did not expect.  However, keeping
  the code more in sync with VMX is useful anyway.

- move common VMX/SVM emulation to x86.c (Sean)

- support for vSPEC_CTRL (Babu)

Paolo


Babu Moger (1):
  x86/cpufeatures: Add the Virtual SPEC_CTRL feature

Cathy Avery (3):
  KVM: SVM: Use a separate vmcb for the nested L2 guest
  KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
  KVM: nSVM: Track the ASID generation of the vmcb vmrun through the
    vmcb

Krish Sadhukhan (1):
  KVM: nSVM: Add missing checks for reserved bits to
    svm_set_nested_state()

Maxim Levitsky (1):
  KVM: nSVM: always use vmcb01 to for vmsave/vmload of guest state

Paolo Bonzini (8):
  KVM: nSVM: rename functions and variables according to vmcbXY
    nomenclature
  KVM: nSVM: do not copy vmcb01->control blindly to vmcb02->control
  KVM: nSVM: do not mark all VMCB01 fields dirty on nested vmexit
  KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit
  KVM: nSVM: only copy L1 non-VMLOAD/VMSAVE data in
    svm_set_nested_state()
  KVM: SVM: merge update_cr0_intercept into svm_set_cr0
  KVM: SVM: move VMLOAD/VMSAVE to C code
  KVM: SVM: Add support for Virtual SPEC_CTRL

Sean Christopherson (9):
  KVM: x86: Move nVMX's consistency check macro to common code
  KVM: nSVM: Trace VM-Enter consistency check failures
  KVM: SVM: Pass struct kvm_vcpu to exit handlers (and many, many other
    places)
  KVM: nSVM: Add VMLOAD/VMSAVE helper to deduplicate code
  KVM: x86: Move XSETBV emulation to common code
  KVM: x86: Move trivial instruction-based exit handlers to common code
  KVM: x86: Move RDPMC emulation to common code
  KVM: SVM: Don't manually emulate RDPMC if nrips=0
  KVM: SVM: Skip intercepted PAUSE instructions after emulation

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   9 +-
 arch/x86/include/asm/svm.h         |   4 +-
 arch/x86/kvm/svm/avic.c            |  24 +-
 arch/x86/kvm/svm/nested.c          | 409 ++++++++------
 arch/x86/kvm/svm/sev.c             |  27 +-
 arch/x86/kvm/svm/svm.c             | 843 ++++++++++++++---------------
 arch/x86/kvm/svm/svm.h             |  51 +-
 arch/x86/kvm/svm/vmenter.S         |  14 +-
 arch/x86/kvm/vmx/nested.c          |   8 +-
 arch/x86/kvm/vmx/vmx.c             |  74 +--
 arch/x86/kvm/x86.c                 |  62 ++-
 arch/x86/kvm/x86.h                 |   8 +
 13 files changed, 777 insertions(+), 757 deletions(-)

-- 
2.26.2

