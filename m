Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6A1C6EFA
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgEFLKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:10:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24267 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727917AbgEFLKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=8lay/dHAY+Hj4ui8V65Mg/+aXrRPwt7ABhu7lPQIaEk=;
        b=boGLhLOjEWylyGfJMzqL6mKomaRTic6DhiZM+Bkve21cVVx2DmBGfMIpMezKRuGQ/gddNc
        Ctph8AQJWVzbulHkuOsxVe4ijjvTZRRErOg5mdGTAWTl1a8LH5rkvK3Le8AS+B61GKO98l
        zToiSBGVMxX8XPKI8Fe6gq+/RkuMX/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-HffpQwpoMsGJtGIwkE-JxQ-1; Wed, 06 May 2020 07:10:38 -0400
X-MC-Unique: HffpQwpoMsGJtGIwkE-JxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB4101899520;
        Wed,  6 May 2020 11:10:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9732C5C1D4;
        Wed,  6 May 2020 11:10:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 0/9] KVM_SET_GUEST_DEBUG tests and fixes, DR accessors cleanups
Date:   Wed,  6 May 2020 07:10:25 -0400
Message-Id: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am posting all the pending patches as a full series because I found
another issue on AMD, which is easily fixed with the last patch but has
dependencies on the patches to keep DR6 synchronized with vcpu->arch.dr6.

Paolo Bonzini (5):
  KVM: x86: fix DR6 delivery for various cases of #DB injection
  KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
  KVM: x86: simplify dr6 accessors in kvm_x86_ops
  KVM: x86, SVM: do not clobber guest DR6 on KVM_EXIT_DEBUG
  KVM: VMX: pass correct DR6 for GD userspace exit

Peter Xu (4):
  KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
  KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
  KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
  KVM: selftests: Add KVM_SET_GUEST_DEBUG test

 arch/powerpc/kvm/powerpc.c                    |   1 +
 arch/s390/kvm/kvm-s390.c                      |   1 +
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/svm/svm.c                        |  11 +-
 arch/x86/kvm/vmx/vmx.c                        |  23 +-
 arch/x86/kvm/x86.c                            |  28 +--
 arch/x86/kvm/x86.h                            |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +
 .../testing/selftests/kvm/x86_64/debug_regs.c | 202 ++++++++++++++++++
 11 files changed, 243 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c

-- 
2.18.2

