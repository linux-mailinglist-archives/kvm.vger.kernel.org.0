Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69495FD774
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJMJ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJMJ64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:58:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6052F9846
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gYxJpUZHmyKC80uPxIoHuIFfPUSzpQt5TX3nlakaHIg=;
        b=KO9tkM5JLJFKf8jt7BvGwr8jEX8pu59bKHT1oV+FYJUdDyrYPg1IzoZRITb8LJ0HGhGecI
        PCquQ8jMBDZYfJtLtkTzqSSh36Y92/e+CC/XXQjWCmbpTCUUttCNrMJ6PfH+fTyocive5I
        GRVsOI9helfv96eeuYgBgFC6QElbexo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-VHKHGMaUPeSTH3j1n_rTJw-1; Thu, 13 Oct 2022 05:58:53 -0400
X-MC-Unique: VHKHGMaUPeSTH3j1n_rTJw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26175858F17;
        Thu, 13 Oct 2022 09:58:53 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEA0347505F;
        Thu, 13 Oct 2022 09:58:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/7] KVM: x86: Hyper-V invariant TSC control feature
Date:   Thu, 13 Oct 2022 11:58:42 +0200
Message-Id: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v4:
- s,HV_INVARIANT_TSC_EXPOSED,HV_EXPOSE_INVARIANT_TSC, [Michael]
- Add Michael's R-b to PATCH1
- Use 'KVM-only' instead of 'scattered' in PATCH2's subject [Sean, Jim]
- Do not set CPUID_8000_0007_EDX to 'NCAPINTS + 1' explicitly [Sean]
- Use the opportunity and switch to 'true'/'false' for 'msr->write'/
  'msr->fault_exepected' in 'hyperv_features' test [Sean]
- Fix HVCALL_NOTIFY_LONG_SPIN_WAIT test breakage by setting 
  HYPERV_CPUID_ENLIGHTMENT_INFO.EBX.
- "KVM: selftests: Test that values written to Hyper-V MSRs are
  preserved" patch added [Sean]

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

Vitaly Kuznetsov (7):
  x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
  KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
  KVM: x86: Hyper-V invariant TSC control
  KVM: selftests: Rename 'msr->available' to 'msr->fault_exepected' in
    hyperv_features test
  KVM: selftests: Convert hyperv_features test to using
    KVM_X86_CPU_FEATURE()
  KVM: selftests: Test that values written to Hyper-V MSRs are preserved
  KVM: selftests: Test Hyper-V invariant TSC control

 arch/x86/include/asm/hyperv-tlfs.h            |   3 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kernel/cpu/mshyperv.c                |   2 +-
 arch/x86/kvm/cpuid.c                          |  11 +-
 arch/x86/kvm/hyperv.c                         |  19 +
 arch/x86/kvm/hyperv.h                         |  27 ++
 arch/x86/kvm/reverse_cpuid.h                  |   7 +
 arch/x86/kvm/x86.c                            |   4 +-
 .../selftests/kvm/include/x86_64/hyperv.h     | 144 +++++---
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/x86_64/hyperv_features.c    | 330 +++++++++++-------
 11 files changed, 366 insertions(+), 183 deletions(-)

-- 
2.37.3

