Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D37622E73
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 15:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiKIOyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 09:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiKIOx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 09:53:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA51115
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 06:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rDPg823+ssgoo9QOHHChyrv6cfKJarSq3LFy2v+O4Og=;
        b=ScyWOiS1AtWZK9oMYhUN7CVUfIts4/P9BquUT4kZCPMiJuUnxcW9GofDEDrN6qWLZQz6hH
        Yu4c+d29IbfLXKQ+s9vl8zOi0gS9mv2TJoZT+YZfS7zwIdIoLINZx0jZA4TE5S4jbtKrgT
        jyA1kOCKEB6BqK4gBuiwr5cVEGFaas4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-nGbcBkZFMwmsKOgK8rOuFg-1; Wed, 09 Nov 2022 09:51:58 -0500
X-MC-Unique: nGbcBkZFMwmsKOgK8rOuFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95DC72815216;
        Wed,  9 Nov 2022 14:51:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B43E1401C2E;
        Wed,  9 Nov 2022 14:51:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH v3 00/11] KVM: SVM: fixes for vmentry code
Date:   Wed,  9 Nov 2022 09:51:45 -0500
Message-Id: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
  (patches 8 and 9).

- because AMD wants the OS to set STIBP to 1 before executing the
  return thunk (un)training sequence, IA32_SPEC_CTRL must be restored
  before UNTRAIN_RET, too.  This must also be moved to assembly and,
  for consistency, the guest SPEC_CTRL is also loaded in there
  (patch 10).

Neither is particularly hard, however because of 32-bit systems one needs
to keep the number of arguments to __svm_vcpu_run to three or fewer.
Therefore, patches 2 to 7 move various accesses to the vcpu_svm struct
and to percpu data to vmenter.S, cleaning up various bits along the way
to keep the assembly code nice.  I think the code is simpler than before
after these prerequisites, and even at the end of the series it is not
much harder to follow despite doing a lot more stuff.  Care has been
taken to keep the "normal" and SEV-ES code as similar as possible,
even though the latter would not hit the three argument barrier; even
the prototype is the same.

The above summary leaves patch 1, which introduces a separate asm-offsets.c
file for KVM, so that kernel/asm-offsets.c does not have to do ugly includes
with ../ paths; and patch 11, which is just more dead code removal.

Thanks,

Paolo

v2->v3: store SME-adjusted save_area physical address in svm_cpu_data,
	access it with PER_CPU_VAR instead of an argument [Sean, sort of]

	split out-of-line spec-ctrl restore macro in two parts [Sean]

	adjust comments to point out clobbered registers [Sean]

Paolo Bonzini (11):
  KVM: x86: use a separate asm-offsets.c file
  KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
  KVM: SVM: adjust register allocation for __svm_vcpu_run
  KVM: SVM: retrieve VMCB from assembly
  KVM: SVM: remove unused field from struct vcpu_svm
  KVM: SVM: remove dead field from struct svm_cpu_data
  KVM: SVM: do not allocate struct svm_cpu_data dynamically
  KVM: SVM: move guest vmsave/vmload back to assembly
  KVM: SVM: restore host save area from assembly
  KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
  x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
    callers

 arch/x86/include/asm/spec-ctrl.h |  10 +-
 arch/x86/kernel/asm-offsets.c    |   6 -
 arch/x86/kernel/cpu/bugs.c       |  15 +-
 arch/x86/kvm/.gitignore          |   2 +
 arch/x86/kvm/Makefile            |  12 ++
 arch/x86/kvm/kvm-asm-offsets.c   |  29 ++++
 arch/x86/kvm/svm/sev.c           |   4 +-
 arch/x86/kvm/svm/svm.c           | 105 +++++--------
 arch/x86/kvm/svm/svm.h           |  11 +-
 arch/x86/kvm/svm/svm_ops.h       |   5 -
 arch/x86/kvm/svm/vmenter.S       | 260 +++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmenter.S       |   2 +-
 12 files changed, 305 insertions(+), 156 deletions(-)
 create mode 100644 arch/x86/kvm/.gitignore
 create mode 100644 arch/x86/kvm/kvm-asm-offsets.c

-- 
2.31.1

