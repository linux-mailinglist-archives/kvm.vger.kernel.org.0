Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBB7C010D
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbjJJQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjJJQDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:03:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E348CF
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5AesHVAQUxcR1GAtYtYzOkU6c6/CTxsVJcL3ikJVYAI=;
        b=gt3I2Q+cKd7Wd/nZtuk/oFUnxFnSSKkUTKdfFiF5CbRGgr9PeKFZG1jcX91mF+DXaZr/rH
        9A750s9NhNAUA0vmEuFO3ZARar6hAtLADvqcPW+erdjbtScO7AcX0rPFDXzRyYYXcUtVNa
        jCa3oCTE6QRzu12PuqELtxzk9nMnxy4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-x0HiwtMcPpWoaVmCvGtVbA-1; Tue, 10 Oct 2023 12:03:03 -0400
X-MC-Unique: x0HiwtMcPpWoaVmCvGtVbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 512A41C11712;
        Tue, 10 Oct 2023 16:03:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F386158;
        Tue, 10 Oct 2023 16:03:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 00/11] KVM: x86: Make Hyper-V emulation optional (AKA introduce CONFIG_KVM_HYPERV)
Date:   Tue, 10 Oct 2023 18:02:49 +0200
Message-ID: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ideas to make Hyper-V emulation by KVM optional were expressed in the past
so I've decided to take a look at what would it take us to implement it.
Turns out it's quite a lot of code churn but the gain is also significant.
Just comparing the resulting module sizes, I can see:

    # CONFIG_KVM_HYPERV is not set
    # CONFIG_HYPERV is not set

    -rw-r--r--. 1 user user 3612632 Oct 10 16:53 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 5343968 Oct 10 16:53 arch/x86/kvm/kvm-intel.ko

    CONFIG_KVM_HYPERV=y
    # CONFIG_HYPERV is not set

    -rw-r--r--. 1 user user 3925704 Oct 10 16:51 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 5819192 Oct 10 16:51 arch/x86/kvm/kvm-intel.ko

    # CONFIG_KVM_HYPERV is not set
    CONFIG_HYPERV=m

    -rw-r--r--. 1 user user 3928440 Oct 10 16:40 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 8156464 Oct 10 16:40 arch/x86/kvm/kvm-intel.ko

    CONFIG_KVM_HYPERV=y
    CONFIG_HYPERV=m

    -rw-r--r--. 1 user user 4245440 Oct 10 16:37 arch/x86/kvm/kvm-amd.ko
    -rw-r--r--. 1 user user 8583872 Oct 10 16:37 arch/x86/kvm/kvm-intel.ko

While code churn is certainly something we can survive, adding more CONFIG
options always comes with a risk of a broken build somewhere in the future.

Early RFC. I have only compile tested these patches in these four
configurations and I'd like to get your opinion on whether it's worth it or
not.

The first patch of the series is not Hyper-V related but as I hide Hyper-V
emulation context under CONFIG_KVM_HYPERV I think it would make sense to
do the same for Xen.

Vitaly Kuznetsov (11):
  KVM: x86: xen: Remove unneeded xen context from struct kvm_arch when
    !CONFIG_KVM_XEN
  KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V
    emulation context
  KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
  KVM: x86: hyper-v: Introduce kvm_hv_synic_auto_eoi_set()
  KVM: x86: hyper-v: Introduce kvm_hv_synic_has_vector()
  KVM: VMX: Split off hyperv_evmcs.{ch}
  KVM: x86: Make Hyper-V emulation optional
  KVM: nVMX: hyper-v: Introduce nested_vmx_evmptr() accessor
  KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
  KVM: nVMX: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV
  KVM: nSVM: hyper-v: Hide more stuff under
    CONFIG_KVM_HYPERV/CONFIG_HYPERV

 arch/x86/include/asm/kvm_host.h |  11 +-
 arch/x86/kvm/Kconfig            |   9 +
 arch/x86/kvm/Makefile           |  19 +-
 arch/x86/kvm/cpuid.c            |   6 +
 arch/x86/kvm/hyperv.h           |  39 ++-
 arch/x86/kvm/irq.c              |   2 +
 arch/x86/kvm/irq_comm.c         |   9 +-
 arch/x86/kvm/lapic.c            |   5 +-
 arch/x86/kvm/svm/hyperv.h       |   7 +
 arch/x86/kvm/svm/nested.c       |  22 +-
 arch/x86/kvm/svm/svm.h          |   2 +
 arch/x86/kvm/svm/svm_onhyperv.c |   2 +-
 arch/x86/kvm/svm/svm_onhyperv.h |   2 +
 arch/x86/kvm/vmx/hyperv.c       | 447 --------------------------------
 arch/x86/kvm/vmx/hyperv.h       | 191 ++------------
 arch/x86/kvm/vmx/hyperv_evmcs.c | 311 ++++++++++++++++++++++
 arch/x86/kvm/vmx/hyperv_evmcs.h | 162 ++++++++++++
 arch/x86/kvm/vmx/nested.c       |  94 ++++---
 arch/x86/kvm/vmx/nested.h       |   3 +-
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/vmx/vmx_onhyperv.c |  36 +++
 arch/x86/kvm/vmx/vmx_onhyperv.h | 125 +++++++++
 arch/x86/kvm/vmx/vmx_ops.h      |   2 +-
 arch/x86/kvm/x86.c              |  60 +++--
 25 files changed, 885 insertions(+), 689 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
 create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
 create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h

-- 
2.41.0

