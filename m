Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F155BAE8C
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiIPNwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 09:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiIPNwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 09:52:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BD6A1D55
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663336331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=STa3m/SN/zOoXoH1ru4rDHwLG5hTaFTMqwsGVhThwTk=;
        b=L//6OzolOETmJZ2O3yYf7sXb/qcehL2u6Z/stIlLIBKWvn69w26m/vsWpKwbiWlJFupcbP
        VP+X7iNufbY2W5x97oUkPw3QasGWKvVENuWcmNsZJLIwJo9BbnuHsLzLsJ8Rs+HSzHldKu
        pvzZ+Xz3wLAPMhPu0ouOHFKTuO0JJUU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-11F00p7fPBCi4Tw1NfV-eA-1; Fri, 16 Sep 2022 09:52:10 -0400
X-MC-Unique: 11F00p7fPBCi4Tw1NfV-eA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D527D38041DD;
        Fri, 16 Sep 2022 13:52:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81E0F2166B26;
        Fri, 16 Sep 2022 13:52:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] KVM: x86: Hyper-V invariant TSC control feature
Date:   Fri, 16 Sep 2022 15:51:59 +0200
Message-Id: <20220916135205.3185973-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- "x86/hyperv: Add HV_INVARIANT_TSC_EXPOSED define" patch added [Sean]
- "KVM: x86: Introduce CPUID_8000_0007_EDX 'scattered' leaf" [Sean]. 
  Hope I got all that magic right...
- s,hv_invtsc,hv_invtsc_control, [Sean]
- s,should_not_gp,fault_expected, and invert the logic [Sean]
- "KVM: selftests: Convert hyperv_features test to using
  KVM_X86_CPU_FEATURE()" patch added.
- Switch the newly introduced selftest to KVM_X86_CPU_FEATURE [Sean]
- Other minor selftest adjustments [Sean]

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
 arch/x86/kvm/cpuid.c                          |   7 +
 arch/x86/kvm/hyperv.c                         |  19 ++
 arch/x86/kvm/hyperv.h                         |  15 ++
 arch/x86/kvm/reverse_cpuid.h                  |   9 +-
 arch/x86/kvm/x86.c                            |   4 +-
 .../selftests/kvm/include/x86_64/hyperv.h     | 144 ++++++++----
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/x86_64/hyperv_features.c    | 212 +++++++++++-------
 11 files changed, 281 insertions(+), 136 deletions(-)

-- 
2.37.2

