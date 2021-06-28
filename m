Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECFF3B5C9F
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhF1KrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:47:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231935AbhF1KrA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624877073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kkyZUt9nND83AIpLRJe3+5UbB9XD72UfzYzdBlyp7l8=;
        b=ITbkZLxqFvVqhi3mX5xVI/NqyvTTECsE+tKt+fcu3Xk/Lwg6AGlf/5UqeQVUN4KSBtQezQ
        +FEHxzoBfN+kAw0at+L5578CQHJ9xQ/Zn8YHT/n0oqwBWe5ODkS/FuNakHZSsgEiJvu+WE
        b2/pWad5SxbuRygWWu5B0dYrlTN/64I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-YTeA5EsSPvGS7rYIMrJnug-1; Mon, 28 Jun 2021 06:44:32 -0400
X-MC-Unique: YTeA5EsSPvGS7rYIMrJnug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF1AF804146;
        Mon, 28 Jun 2021 10:44:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C188C5C1CF;
        Mon, 28 Jun 2021 10:44:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] KVM: nSVM: Fix issues when SMM is entered from L2
Date:   Mon, 28 Jun 2021 12:44:19 +0200
Message-Id: <20210628104425.391276-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of "[PATCH RFC] KVM: nSVM: Fix L1 state corruption
upon return from SMM". 

VMCB split commit 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the
nested L2 guest") broke return from SMM when we entered there from guest
(L2) mode. Gen2 WS2016/Hyper-V is known to do this on boot. The problem
appears to be that VMCB01 gets irreversibly destroyed during SMM execution.
Previously, we used to have 'hsave' VMCB where regular (pre-SMM) L1's state
was saved upon nested_svm_vmexit() but now we just switch to VMCB01 from
VMCB02.

While writing a selftest for the issue, I've noticed that 'svm->nested.ctl'
doesn't get restored after KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE cycle
when guest happens to be in SMM triggered from L2. "KVM: nSVM: Restore
nested control upon leaving SMM" is aimed to fix that.

First two patches of the series add missing sanity checks for 
MSR_VM_HSAVE_PA which has to be page aligned and not zero.

Vitaly Kuznetsov (6):
  KVM: nSVM: Check the value written to MSR_VM_HSAVE_PA
  KVM: nSVM: Check that VM_HSAVE_PA MSR was set before VMRUN
  KVM: nSVM: Introduce svm_copy_nonvmloadsave_state()
  KVM: nSVM: Fix L1 state corruption upon return from SMM
  KVM: nSVM: Restore nested control upon leaving SMM
  KVM: selftests: smm_test: Test SMM enter from L2

 arch/x86/kvm/svm/nested.c                     | 45 +++++++-----
 arch/x86/kvm/svm/svm.c                        | 51 +++++++++++++-
 arch/x86/kvm/svm/svm.h                        |  4 ++
 tools/testing/selftests/kvm/x86_64/smm_test.c | 70 +++++++++++++++++--
 4 files changed, 144 insertions(+), 26 deletions(-)

-- 
2.31.1

