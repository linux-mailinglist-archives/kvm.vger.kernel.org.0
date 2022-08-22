Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E47A59C4A8
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiHVRHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiHVRHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E707242AC9
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OZupmRZtcUtlH4659i6zFhdu2zNlFDA9+3SfaNsY/Ro=;
        b=e/7NtnVV0FM0u6EUyWMIhXw/I+35v+LseFcqxyZj7AAzlPiKJ/9VE/XDdlNv1jx4Yy6jTI
        MqdaP4ArErfYFWqf0a9481vZvLp+IIITzSpsVxvzi0hxJqA2g1V5CMNt2dZjiJpRWznxfH
        GNtSBVVwd6c0xAiEClxFEfPe8dOl5kc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-NqFD413gOXqFk3OTVAUTbA-1; Mon, 22 Aug 2022 13:06:59 -0400
X-MC-Unique: NqFD413gOXqFk3OTVAUTbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6671485A585;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44529945D0;
        Mon, 22 Aug 2022 17:06:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH v3 0/7] KVM: x86: never write to memory from kvm_vcpu_check_block
Date:   Mon, 22 Aug 2022 13:06:52 -0400
Message-Id: <20220822170659.2527086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following backtrace:

[ 1355.807187]  kvm_vcpu_map+0x159/0x190 [kvm]
[ 1355.807628]  nested_svm_vmexit+0x4c/0x7f0 [kvm_amd]
[ 1355.808036]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
[ 1355.808450]  svm_check_nested_events+0x97/0x390 [kvm_amd]
[ 1355.808920]  kvm_check_nested_events+0x1c/0x40 [kvm] 
[ 1355.809396]  kvm_arch_vcpu_runnable+0x4e/0x190 [kvm]
[ 1355.809892]  kvm_vcpu_check_block+0x4f/0x100 [kvm]
[ 1355.811259]  kvm_vcpu_block+0x6b/0xa0 [kvm] 

can occur due to kmap being called in non-sleepable (!TASK_RUNNING) context.
The fix is to extend kvm_x86_ops->nested_ops.hv_timer_pending() to cover
all events not already checked in kvm_arch_vcpu_is_runnable(), and then
get rid of the annoying (and wrong) call to kvm_check_nested_events()
from kvm_vcpu_check_block().

Beware, this is not a complete fix, because kvm_guest_apic_has_interrupt()
might still _read_ memory from non-sleepable context.  The fix here is
probably to make kvm_arch_vcpu_is_runnable() return -EAGAIN, and in that
case do a round of kvm_vcpu_check_block() polling in sleepable context.
Nevertheless, it is a good start as it pushes the vmexit into vcpu_block().

The series also does a small cleanup pass on kvm_vcpu_check_block(),
removing KVM_REQ_UNHALT in favor of simply calling kvm_arch_vcpu_runnable()
again.  Now that kvm_check_nested_events() is not called anymore by
kvm_arch_vcpu_runnable(), it is much easier to see that KVM will never
consume the event that caused kvm_vcpu_has_events() to return true,
and therefore it is safe to evaluate it again.

The alternative of propagating the return value of
kvm_arch_vcpu_runnable() up to kvm_vcpu_{block,halt}() is inferior
because it does not quite get right the edge cases where the vCPU becomes
runnable right before schedule() or right after kvm_vcpu_check_block().
While these edge cases are unlikely to truly matter in practice, it is
also pointless to get them "wrong".

Paolo

v2->v3: do not propagate the return value of
	kvm_arch_vcpu_runnable() up to kvm_vcpu_{block,halt}()

	move and reformat the comment in vcpu_block()

	move KVM_REQ_UNHALT removal last

Paolo Bonzini (6):
  KVM: x86: check validity of argument to KVM_SET_MP_STATE
  KVM: x86: make vendor code check for all nested events
  KVM: x86: lapic does not have to process INIT if it is blocked
  KVM: x86: never write to memory from kvm_vcpu_check_block
  KVM: mips, x86: do not rely on KVM_REQ_UNHALT
  KVM: remove KVM_REQ_UNHALT

Sean Christopherson (1):
  KVM: nVMX: Make an event request when pending an MTF nested VM-Exit

 Documentation/virt/kvm/vcpu-requests.rst | 28 +------------
 arch/arm64/kvm/arm.c                     |  1 -
 arch/mips/kvm/emulate.c                  |  6 +--
 arch/powerpc/kvm/book3s_pr.c             |  1 -
 arch/powerpc/kvm/book3s_pr_papr.c        |  1 -
 arch/powerpc/kvm/booke.c                 |  1 -
 arch/powerpc/kvm/powerpc.c               |  1 -
 arch/riscv/kvm/vcpu_insn.c               |  1 -
 arch/s390/kvm/kvm-s390.c                 |  2 -
 arch/x86/include/asm/kvm_host.h          |  3 +-
 arch/x86/kvm/i8259.c                     |  4 +-
 arch/x86/kvm/lapic.h                     |  2 +-
 arch/x86/kvm/vmx/nested.c                |  9 +++-
 arch/x86/kvm/vmx/vmx.c                   |  6 ++-
 arch/x86/kvm/x86.c                       | 53 ++++++++++++++++++------
 arch/x86/kvm/x86.h                       |  5 ---
 arch/x86/kvm/xen.c                       |  1 -
 include/linux/kvm_host.h                 |  3 +-
 virt/kvm/kvm_main.c                      |  4 +-
 19 files changed, 63 insertions(+), 69 deletions(-)

-- 
2.31.1

