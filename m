Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC14E611DF3
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJ1XKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJ1XJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:09:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B181237F8F
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666998474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A2c8ymd1GFvLBVMNdJ9tI50soRavZnzeQUSNcQq0dMs=;
        b=ePc6SZ1CM9f7BAnoXR1kI9Jlt3YrihtbSkgTjMfZCCtQyoG1eqD1M0btP8eMTJGbjo+Exf
        sed/o6jXX4RHhJ/1MvIKYN9UuA3IKI6+Kduz1fg1xj4DzkfdD0ejpifE2cYObZrbHlNYxY
        6GuFuYfNP4qHneiSt3F+rdMQWvinj60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-LZJSepqpOAikHMAm8TLHDg-1; Fri, 28 Oct 2022 19:07:50 -0400
X-MC-Unique: LZJSepqpOAikHMAm8TLHDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9579857D0D;
        Fri, 28 Oct 2022 23:07:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7CC540C6EC3;
        Fri, 28 Oct 2022 23:07:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, jpoimboe@kernel.org
Subject: [RFC PATCH 0/7] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
Date:   Fri, 28 Oct 2022 19:07:16 -0400
Message-Id: <20221028230723.3254250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On the Intel side, restoration of the guest's IA32_SPEC_CTRL is done
as late as possible before vmentry, with the comment:

* IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
* there must not be any returns or indirect branches between this code
* and vmentry.

On AMD, there is no need to avoid returns or indirect branches between
wrmsr and vmrun because Linux doesn't use IBRS; however, restoration
of the host IA32_SPEC_CTRL value is definitely way too late. With
respect to the user/kernel boundary, AMD says, "If software chooses to
toggle STIBP (e.g., set STIBP on kernel entry, and clear it on kernel
exit), software should set STIBP to 1 before executing the return thunk
training sequence." Assuming the same requirements apply to the guest/host
boundary, KVM does not respect this recommendation: the return thunk
training sequence is in vmenter.S, quite close to the VM-exit, while
the host's IA32_SPEC_CTRL value is only restored much later for hosts
without V_SPEC_CTRL.

In the absence of clarifications for AMD, move all the SPEC_CTRL
handling to assembly code and, in passing, also make the Intel and AMD
code a bit more similar to each other.

Patches 1-2 are the Intel side, which is just a cleanup.

Patch 3 prepares for adding asm-offsets.c entries in arch/x86/kvm/svm/svm.h,
and patches 4-5 are a similar cleanup to the earlier VMX ones.

Patch 6 is the bulk of the change, and finally patch 7 removes now
dead code in asm/spec-ctrl.h and arch/x86/kernel/.

This is RFC because I haven't tested SEV-ES or 32-bit yet.

Paolo

Paolo Bonzini (7):
  KVM: VMX: remove regs argument of __vmx_vcpu_run
  KVM: VMX: more cleanups to __vmx_vcpu_run
  KVM: SVM: extract VMCB accessors to a new file
  KVM: SVM: replace argument of __svm_vcpu_run with vcpu_svm
  KVM: SVM: adjust register allocation for __svm_vcpu_run
  KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
  x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
    callers

 arch/x86/include/asm/spec-ctrl.h |  10 +-
 arch/x86/kernel/asm-offsets.c    |   8 ++
 arch/x86/kernel/cpu/bugs.c       |  15 +--
 arch/x86/kvm/svm/avic.c          |   1 +
 arch/x86/kvm/svm/nested.c        |   1 +
 arch/x86/kvm/svm/sev.c           |   1 +
 arch/x86/kvm/svm/svm.c           |  39 +++---
 arch/x86/kvm/svm/svm.h           | 204 +-----------------------------
 arch/x86/kvm/svm/svm_onhyperv.c  |   1 +
 arch/x86/kvm/svm/vmcb.h          | 211 +++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/vmenter.S       | 164 ++++++++++++++++++------
 arch/x86/kvm/vmx/nested.c        |   3 +-
 arch/x86/kvm/vmx/vmenter.S       |  92 ++++++--------
 arch/x86/kvm/vmx/vmx.c           |   3 +-
 arch/x86/kvm/vmx/vmx.h           |   3 +-
 15 files changed, 419 insertions(+), 337 deletions(-)
 create mode 100644 arch/x86/kvm/svm/vmcb.h

-- 
2.31.1

