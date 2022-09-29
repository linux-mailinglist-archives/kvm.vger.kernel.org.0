Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1E5EFBC7
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbiI2RUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiI2RUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:20:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8936D101958
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664472019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FmyEedCC+EL9I+qlzq1lN9CZWGu+SVJgbuQF5LzXs9Y=;
        b=VqpIt8Mkz+Mug3TI3032WpvIdn9UcWfc36BNDAheDmuSkLYPIMgteYFYOI3+erajTx3/ex
        zhk2nn1kYOSkUg2npwpnuUq6WJC1u6fNziPqN6PwN7r14FCJKijt7Z3MHL2lVQN4tJiyVL
        EhYp63bal0Xxxc8GTIUK7EvPHN3QzEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-CXm2IjFmMIWbtSNBv4ONFA-1; Thu, 29 Sep 2022 13:20:17 -0400
X-MC-Unique: CXm2IjFmMIWbtSNBv4ONFA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A92C9857F90;
        Thu, 29 Sep 2022 17:20:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B524221F;
        Thu, 29 Sep 2022 17:20:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Subject: [PATCH v2 0/8] KVM: x86: allow compiling out SMM support
Date:   Thu, 29 Sep 2022 13:20:08 -0400
Message-Id: <20220929172016.319443-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some users of KVM implement the UEFI variable store through a paravirtual device
that does not require the "SMM lockbox" component of edk2; allow them to
compile out system management mode, which is not a full implementation
especially in how it interacts with nested virtualization.

In order to limit the number and especially the size of the #ifdefs,
the first 4 patches move most SMM code to a completely new file in
arch/x86/kvm.  Patch 5 is the main change to introduce the Kconfig
symbol and key smm.c's compilation off it; patches 6-8 instead eliminate
other bits of SMM code that remain outside smm.c, the last one being
"optional" as it is a bit into diminishing returns land.

Paolo

Paolo Bonzini (8):
  KVM: x86: start moving SMM-related functions to new files
  KVM: x86: move SMM entry to a new file
  KVM: x86: move SMM exit to a new file
  KVM: x86: do not go through ctxt->ops when emulating rsm
  KVM: allow compiling out SMM support
  KVM: x86: compile out vendor-specific code if SMM is disabled
  KVM: x86: remove SMRAM address space if SMM is not supported
  KVM: x86: do not define KVM_REQ_SMI if SMM disabled

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +
 arch/x86/include/asm/kvm_host.h               |  24 +-
 arch/x86/kvm/Kconfig                          |  11 +
 arch/x86/kvm/Makefile                         |   1 +
 arch/x86/kvm/emulate.c                        | 355 +----------
 arch/x86/kvm/kvm_cache_regs.h                 |   5 -
 arch/x86/kvm/kvm_emulate.h                    |  47 +-
 arch/x86/kvm/lapic.c                          |  14 +-
 arch/x86/kvm/lapic.h                          |   7 +-
 arch/x86/kvm/mmu/mmu.c                        |   1 +
 arch/x86/kvm/smm.c                            | 573 ++++++++++++++++++
 arch/x86/kvm/smm.h                            |  38 ++
 arch/x86/kvm/svm/nested.c                     |   3 +
 arch/x86/kvm/svm/svm.c                        |  11 +-
 arch/x86/kvm/vmx/nested.c                     |   1 +
 arch/x86/kvm/vmx/vmx.c                        |   7 +
 arch/x86/kvm/x86.c                            | 353 +----------
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 +
 18 files changed, 737 insertions(+), 718 deletions(-)
 create mode 100644 arch/x86/kvm/smm.c
 create mode 100644 arch/x86/kvm/smm.h

-- 
2.31.1

