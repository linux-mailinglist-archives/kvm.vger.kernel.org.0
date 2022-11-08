Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620356217D4
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiKHPQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiKHPQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:16:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA82186F8
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 07:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aRoW2KDTlPczcWc8dhQ47w2ukmwsbIo1VAXAXMn1Vjg=;
        b=hIw5KLeYKnHufwqZk2rsEw7AJMRzT947dVWTDcr66/kxWr2LERSoKY1V/uijU2tPsf8A8z
        F5KOEeN5ZbfFDwbmZnDQqNFTcCC7LpcHLIcrFpX370BWpABOEs4Hd3GXu3woSb53fehDtO
        iWkonIsjNArh4+cx0y9g9K9HsIUi7TE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-gksRGa3sMWyj62g8sVug9w-1; Tue, 08 Nov 2022 10:15:33 -0500
X-MC-Unique: gksRGa3sMWyj62g8sVug9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E1CD8001B8;
        Tue,  8 Nov 2022 15:15:33 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7D1A40C6FA3;
        Tue,  8 Nov 2022 15:15:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com
Subject: [PATCH v2 0/8] KVM: SVM: fixes for vmentry code
Date:   Tue,  8 Nov 2022 10:15:24 -0500
Message-Id: <20221108151532.1377783-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
  (patches 5 and 6).

- because AMD wants the OS to set STIBP to 1 before executing the
  return thunk (un)training sequence, IA32_SPEC_CTRL must be restored
  before UNTRAIN_RET, too.  This must also be moved to assembly and,
  for consistency, the guest SPEC_CTRL is also loaded in there
  (patch 7).

Neither is particularly hard, however because of 32-bit systems one needs
to keep the number of arguments to __svm_vcpu_run to three or fewer.
One is taken for whether IA32_SPEC_CTRL is intercepted, and one for the
host save area, so all accesses to the vcpu_svm struct have to be done
from assembly too.  This is done in patches 2 to 4, and it turns out
not to be that bad; in fact I think the code is simpler than before
after these prerequisites, and even at the end of the series it is not
much harder to follow despite doing a lot more stuff.  Care has been
taken to keep the "normal" and SEV-ES code as similar as possible,
even though the latter would not hit the three argument barrier.

The above summary leaves out the more mundane patches 1 and 8.  The
former introduces a separate asm-offsets.c file for KVM, so that
kernel/asm-offsets.c does not have to do ugly includes with ../ paths.
The latter is dead code removal.

Thanks,

Paolo

v1->v2: use a separate asm-offsets.c file instead of hacking around
	the arch/x86/kvm/svm/svm.h file; this could have been done
	also with just a "#ifndef COMPILE_OFFSETS", but Sean's
	suggestion is cleaner and there is a precedent in
	drivers/memory/ for private asm-offsets files

	keep preparatory cleanups together at the beginning of the
	series

	move SPEC_CTRL save/restore out of line [Jim]

Paolo Bonzini (8):
  KVM: x86: use a separate asm-offsets.c file
  KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
  KVM: SVM: adjust register allocation for __svm_vcpu_run
  KVM: SVM: retrieve VMCB from assembly
  KVM: SVM: move guest vmsave/vmload to assembly
  KVM: SVM: restore host save area from assembly
  KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
  x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
    callers

 arch/x86/include/asm/spec-ctrl.h |  10 +-
 arch/x86/kernel/asm-offsets.c    |   6 -
 arch/x86/kernel/cpu/bugs.c       |  15 +-
 arch/x86/kvm/Makefile            |  12 ++
 arch/x86/kvm/kvm-asm-offsets.c   |  28 ++++
 arch/x86/kvm/svm/svm.c           |  53 +++----
 arch/x86/kvm/svm/svm.h           |   4 +-
 arch/x86/kvm/svm/svm_ops.h       |   5 -
 arch/x86/kvm/svm/vmenter.S       | 241 ++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmenter.S       |   2 +-
 10 files changed, 259 insertions(+), 117 deletions(-)
 create mode 100644 arch/x86/kvm/kvm-asm-offsets.c

-- 
2.31.1

