Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78A60FD6B
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiJ0Qt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiJ0Qtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:49:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1A932BB4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UmKsvDZphX6Q2tq3GUESuxV/7Plhh3YGmQbqJMgGeiE=;
        b=ZXDvimmUVJ0gYc7GxXEsomC/TWc17HWkGYaOjXP6MVdKFjZgjm9iC9jZ5HFHlO3ifQhdzE
        7Wg6cRk2KcEiL7AT4MH9KT9DAArpYIP3gRkNuxqWpbAM91tQ99NO7gSZzHDjlvWfuU+ZxA
        Xv1p8ZBYrX+KVUe5lNoNW26zDTYGr5A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-lUlGhf5GPOOeyy2scPubRw-1; Thu, 27 Oct 2022 12:49:45 -0400
X-MC-Unique: lUlGhf5GPOOeyy2scPubRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C6AE85A5B6;
        Thu, 27 Oct 2022 16:49:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCCFB1121320;
        Thu, 27 Oct 2022 16:49:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 0/10] KVM: x86: allow compiling out SMM support
Date:   Thu, 27 Oct 2022 12:49:34 -0400
Message-Id: <20221027164944.3031588-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
symbol and key smm.c's compilation off it; patches 6-10 instead
eliminate other bits of SMM code that remain outside smm.c.

Paolo

v2->v3: remove kvm_smm_changed stub as well as more code in KVM_GET_VCPU_EVENTS
	leave kvm_apic_init_sipi_allowed inline
	change placement Kconfig to generate the right menu hierarchy

Paolo Bonzini (9):
  KVM: x86: start moving SMM-related functions to new files
  KVM: x86: move SMM entry to a new file
  KVM: x86: move SMM exit to a new file
  KVM: x86: do not go through ctxt->ops when emulating rsm
  KVM: allow compiling out SMM support
  KVM: x86: compile out vendor-specific code if SMM is disabled
  KVM: x86: remove SMRAM address space if SMM is not supported
  KVM: x86: do not define KVM_REQ_SMI if SMM disabled
  KVM: zero output of KVM_GET_VCPU_EVENTS before filling in the struct

Sean Christopherson (1):
  KVM: x86: do not define SMM-related constants if SMM disabled

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +
 arch/x86/include/asm/kvm_host.h               |  25 +-
 arch/x86/kvm/Kconfig                          |  11 +
 arch/x86/kvm/Makefile                         |   1 +
 arch/x86/kvm/emulate.c                        | 355 +----------
 arch/x86/kvm/kvm_cache_regs.h                 |   5 -
 arch/x86/kvm/kvm_emulate.h                    |  47 +-
 arch/x86/kvm/lapic.c                          |   8 +-
 arch/x86/kvm/lapic.h                          |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |   1 +
 arch/x86/kvm/smm.c                            | 576 ++++++++++++++++++
 arch/x86/kvm/smm.h                            |  37 ++
 arch/x86/kvm/svm/nested.c                     |   3 +
 arch/x86/kvm/svm/svm.c                        |  11 +-
 arch/x86/kvm/vmx/nested.c                     |   1 +
 arch/x86/kvm/vmx/vmx.c                        |   7 +
 arch/x86/kvm/x86.c                            | 371 ++---------
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 +
 18 files changed, 741 insertions(+), 724 deletions(-)
 create mode 100644 arch/x86/kvm/smm.c
 create mode 100644 arch/x86/kvm/smm.h

-- 
2.31.1

