Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9C1C75D0
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgEFQKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:10:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729505AbgEFQKy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pK8XLGVgtLQ7Wuz0EniH4HZPeCKMh3d83lQPtPWl3h4=;
        b=KZSIRiTfeG5+JQd21pzLmD5rvJSkgKExANGQGD6F7BeL+UpNWzMUxlkxV6X7owbyRBDgD0
        iSPOMheFXJeYKgEih73qDoxVK/YWM+mkkPgGrt+xsPFpZI3FYi7zJwFYexubvGex5UHGIa
        ijh/Dp2L43ZcRix3Xi4MmlIHrOGj6qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-fmYHDPn_MOGx2iku1zuVsg-1; Wed, 06 May 2020 12:10:51 -0400
X-MC-Unique: fmYHDPn_MOGx2iku1zuVsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 522021842D22;
        Wed,  6 May 2020 16:10:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04949165F6;
        Wed,  6 May 2020 16:10:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com
Subject: [PATCH v5 0/7] KVM: VMX: Tscdeadline timer emulation fastpath
Date:   Wed,  6 May 2020 12:10:41 -0400
Message-Id: <20200506161048.28840-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is my cleaned up version of Wanpeng's TSC deadline timer
optimizations.  The main change is a reorganization of the fast
path enums, removing EXIT_FASTPATH_SKIP_EMUL_INS (following the
suggestion of =E6=9E=97=E9=91=AB=E9=BE=99) and renaming EXIT_FASTPATH_NOP=
 to
EXIT_FASTPATH_EXIT_HANDLED.

Paolo Bonzini (1):
  KVM: x86: introduce kvm_can_use_hv_timer

Wanpeng Li (6):
  KVM: VMX: Introduce generic fastpath handler
  KVM: X86: Introduce kvm_vcpu_exit_request() helper
  KVM: X86: Introduce more exit_fastpath_completion enum values
  KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
  KVM: X86: TSCDEADLINE MSR emulation fastpath
  KVM: VMX: Handle preemption timer fastpath

 arch/x86/include/asm/kvm_host.h |  4 +-
 arch/x86/kvm/lapic.c            | 31 ++++++++++-----
 arch/x86/kvm/lapic.h            |  2 +-
 arch/x86/kvm/svm/svm.c          | 15 ++++---
 arch/x86/kvm/vmx/vmx.c          | 69 +++++++++++++++++++++++----------
 arch/x86/kvm/x86.c              | 45 +++++++++++++++------
 arch/x86/kvm/x86.h              |  3 +-
 virt/kvm/kvm_main.c             |  1 +
 8 files changed, 118 insertions(+), 52 deletions(-)

--=20
2.18.2

