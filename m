Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F961F6DE
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 15:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiKGO5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 09:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiKGO4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 09:56:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5A11DF30
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TlMjd/2CU7uAhpVg7cB+yVdFYGEY40Ps8qhqieVo7Po=;
        b=iTvFg8DjtXWtXV876KX/X4En+HTs9jtKpnaO24PI3J+9uVg6nR5KtR5wUYV5eGEALPZdMA
        zSkvAUBt4/LvCr8TVVypThzIV+3A88Bv1kPA5qZ/gWv9+uFec6nSrfoUhD4vlE8ZDdJwAq
        YWbA6XFF6z6Vgx5qDI55B6lVTRvhC6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-UTqozkQ5NdyG5uvXMHhq8w-1; Mon, 07 Nov 2022 09:54:38 -0500
X-MC-Unique: UTqozkQ5NdyG5uvXMHhq8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77F7685A59D;
        Mon,  7 Nov 2022 14:54:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40AF62028CE4;
        Mon,  7 Nov 2022 14:54:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/8] KVM: SVM: fixes for vmentry code
Date:   Mon,  7 Nov 2022 09:54:28 -0500
Message-Id: <20221107145436.276079-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series comprises two related fixes:

- the FILL_RETURN_BUFFER macro in -next needs to access percpu data,
  hence the GS segment base needs to be loaded before FILL_RETURN_BUFFER.
  This means moving guest vmload/vmsave and host vmload to assembly
  (patches 4 and 6).

- because AMD wants the OS to set STIBP to 1 before executing the
  return thunk (un)training sequence, IA32_SPEC_CTRL must be restored
  before UNTRAIN_RET, too.  This must also be moved to assembly and,
  for consistency, the guest SPEC_CTRL is also loaded in there
  (patch 7).

Neither is particularly hard, however because of 32-bit systems one needs
to keep the number of arguments to __svm_vcpu_run to three or fewer.
One is taken for whether IA32_SPEC_CTRL is intercepted, and one for the
host save area, so all accesses to the vcpu_svm struct have to be done
from assembly too.  This is done in patches 2, 3 and 5 and it turns out
not to be that bad; in fact I don't think the code is much harder to
follow than before despite doing a lot more stuff.  Care has been taken
to keep the "normal" and SEV-ES code as similar as possible, too.

The above summary leaves out the more mundane patches 1 and 8.  They
are respectively preparation for adding more asm-offsets, and dead
code removal.  Most of the scary diffstat comes from patch 1, which is
purely moving inline functions to a separate header file than svm.h.

Peter Zijlstra had already sent a similar patch for the first issue last
Friday.  Unfortunately it did not take care of the 32-bit issue with the
number of arguments.  This series is independent of his, but I did steal
his organization of the exception fixup code because it's pretty.

Tested on 64-bit bare metal including SEV-ES, and on 32-bit nested.  On
top of this I also spent way too much time comparing the output of
the compiler code before the patch with the assembly code after.

Paolo

Supersedes: <20221028230723.3254250-1-pbonzini@redhat.com>

Paolo Bonzini (8):
  KVM: SVM: extract VMCB accessors to a new file
  KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
  KVM: SVM: adjust register allocation for __svm_vcpu_run
  KVM: SVM: move guest vmsave/vmload to assembly
  KVM: SVM: retrieve VMCB from assembly
  KVM: SVM: restore host save area from assembly
  KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
  x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
    callers

 arch/x86/include/asm/spec-ctrl.h |  10 +-
 arch/x86/kernel/asm-offsets.c    |  10 ++
 arch/x86/kernel/cpu/bugs.c       |  15 +-
 arch/x86/kvm/svm/avic.c          |   1 +
 arch/x86/kvm/svm/nested.c        |   1 +
 arch/x86/kvm/svm/sev.c           |   1 +
 arch/x86/kvm/svm/svm.c           |  54 +++-----
 arch/x86/kvm/svm/svm.h           | 204 +--------------------------
 arch/x86/kvm/svm/svm_onhyperv.c  |   1 +
 arch/x86/kvm/svm/svm_ops.h       |   5 -
 arch/x86/kvm/svm/vmcb.h          | 211 ++++++++++++++++++++++++++++
 arch/x86/kvm/svm/vmenter.S       | 231 ++++++++++++++++++++++++-------
 12 files changed, 434 insertions(+), 310 deletions(-)
 create mode 100644 arch/x86/kvm/svm/vmcb.h

-- 
2.31.1

