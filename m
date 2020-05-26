Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA591C88DA
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgEGLuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58967 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgEGLuT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=HpySo1fPq0F4Fe5nieQHEfTObO9AX94O/qzGxsIgTec=;
        b=EuXEDKyXkcsbch+mo96bh7IWx/osBnm7S2Llw+ksM6vDZ0Cx9x4Rs06AyJq5GSDQLMl5sP
        sK8xh+z6r76aSB8vF/1ih716ZBv8S/wryr6ZBfQXMr5FrbSG90wTzl4cH5SNV7xHrVnpor
        bOtZGIZ+3TCil6ug1vqghHaH3JPeCRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-vreDZiYOMKqkFon784JXFg-1; Thu, 07 May 2020 07:50:16 -0400
X-MC-Unique: vreDZiYOMKqkFon784JXFg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A080801504;
        Thu,  7 May 2020 11:50:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E24341C933;
        Thu,  7 May 2020 11:50:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 0/9] KVM_SET_GUEST_DEBUG tests and fixes, DR accessors cleanups
Date:   Thu,  7 May 2020 07:50:02 -0400
Message-Id: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new version of the patches improves the AMD bugfix where
KVM_EXIT_DEBUG clobbers the guest DR6 and includes stale causes.
The improved fix makes it possible to drop kvm_set_dr6 and
kvm_update_dr6 altogether.

v1->v2: - merge v1 patch 6 with get_dr6 part of v1 patch 7, cover nested SVM
	- new patch "KVM: nSVM: trap #DB and #BP to userspace if guest debugging is on"
	- rewritten patch 8 to get rid of set_dr6 completely

Paolo Bonzini (5):
  KVM: x86: fix DR6 delivery for various cases of #DB injection
  KVM: nSVM: trap #DB and #BP to userspace if guest debugging is on
  KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
  KVM: x86, SVM: isolate vcpu->arch.dr6 from vmcb->save.dr6
  KVM: VMX: pass correct DR6 for GD userspace exit

Peter Xu (4):
  KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
  KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
  KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
  KVM: selftests: Add KVM_SET_GUEST_DEBUG test

 arch/powerpc/kvm/powerpc.c                    |   1 +
 arch/s390/kvm/kvm-s390.c                      |   1 +
 arch/x86/include/asm/kvm_host.h               |   3 +-
 arch/x86/kvm/svm/nested.c                     |  39 +++-
 arch/x86/kvm/svm/svm.c                        |  36 ++--
 arch/x86/kvm/vmx/vmx.c                        |  23 +-
 arch/x86/kvm/x86.c                            |  27 +--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +
 .../testing/selftests/kvm/x86_64/debug_regs.c | 202 ++++++++++++++++++
 11 files changed, 281 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c

-- 
2.18.2

