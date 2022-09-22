Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA44C5E65CE
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiIVOhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiIVOhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:37:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FA9F686C
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663857422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EHTba5sUbwuMPAyhkuX+6NFvptUjl6B5PiqYo1GVbUw=;
        b=CCAA2gw40xDudIh2EONITesrviBZQ9Ukq8fSMju3oj9dVkjnqQgMbMj7rTA6KcZQccyksa
        MHiViGwaM2HfG7TZsAlacLPRYrbz+KgBtDrSd1Bt35gsSRjD7FtVDlbNcwheGc7ZkWHT9l
        xj96XfuCOzgM8nuMAhYkSRmj4/GB6uU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-LVipNUU1P8-IeP79bfqv6g-1; Thu, 22 Sep 2022 10:36:59 -0400
X-MC-Unique: LVipNUU1P8-IeP79bfqv6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC6BF3C0F360;
        Thu, 22 Sep 2022 14:36:58 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 886EC40C206B;
        Thu, 22 Sep 2022 14:36:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] KVM: x86: Hyper-V invariant TSC control feature
Date:   Thu, 22 Sep 2022 16:36:49 +0200
Message-Id: <20220922143655.3721218-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v3:
- Use cpuid_entry_override() for the newly introduces CPUID_8000_0007_EDX
  leaf in __do_cpuid_func(). [Sean]
- Add comments and reshuffle check in kvm_hv_invtsc_suppressed() [Sean]

Original description:

Normally, genuine Hyper-V doesn't expose architectural invariant TSC
(CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
PV MSR is set, invariant TSC bit starts to show up in CPUID. When the 
feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.

Note: strictly speaking, KVM doesn't have to have the feature as exposing
raw invariant TSC bit (CPUID.80000007H:EDX[8]) also seems to work for
modern Windows versions. The feature is, however, tiny and straitforward
and gives additional flexibility so why not.

Vitaly Kuznetsov (6):
  x86/hyperv: Add HV_INVARIANT_TSC_EXPOSED define
  KVM: x86: Introduce CPUID_8000_0007_EDX 'scattered' leaf
  KVM: x86: Hyper-V invariant TSC control
  KVM: selftests: Rename 'msr->availble' to 'msr->fault_exepected' in
    hyperv_features test
  KVM: selftests: Convert hyperv_features test to using
    KVM_X86_CPU_FEATURE()
  KVM: selftests: Test Hyper-V invariant TSC control

 arch/x86/include/asm/hyperv-tlfs.h            |   3 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kernel/cpu/mshyperv.c                |   2 +-
 arch/x86/kvm/cpuid.c                          |  11 +-
 arch/x86/kvm/hyperv.c                         |  19 ++
 arch/x86/kvm/hyperv.h                         |  27 +++
 arch/x86/kvm/reverse_cpuid.h                  |   9 +-
 arch/x86/kvm/x86.c                            |   4 +-
 .../selftests/kvm/include/x86_64/hyperv.h     | 144 ++++++++----
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/x86_64/hyperv_features.c    | 212 +++++++++++-------
 11 files changed, 295 insertions(+), 138 deletions(-)

-- 
2.37.3

