Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18235A7964
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiHaIuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiHaIuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:50:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF95A1A61
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661935816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tiSY5YpavkPocYXmlQRCYmBcbTZ5BJRKWc15iYlx39A=;
        b=GdQhdhVcwfcgEVLaoIyhxtagJ/lsVxc/2cQWOD4TrOkp5jqd+JXNQkwkXH/Ge/k8Rozyiz
        YsrQMcSIz4cghJpUsU9xecca8y9R7xQ7l0qqSJH1ml222v6WwW7R87R+jDGuix+e0VykYH
        +HgDg7a84I+SHJB4fK0pOdRL+f6cCXw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-PnQE8m_vM22MkNlXmu7NOg-1; Wed, 31 Aug 2022 04:50:13 -0400
X-MC-Unique: PnQE8m_vM22MkNlXmu7NOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEFC98032FB;
        Wed, 31 Aug 2022 08:50:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56FC3C15BB3;
        Wed, 31 Aug 2022 08:50:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: x86: Hyper-V invariant TSC control feature
Date:   Wed, 31 Aug 2022 10:50:06 +0200
Message-Id: <20220831085009.1627523-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Drop "KVM: selftests: Fix wrmsr_safe()" patch as it is already merged.
- Add 'KVM: selftests: Rename 'msr->availble' to 'msr->should_not_gp' in
 hyperv_features test' patch [Max]
- Rebase selftest to the current API.

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

Vitaly Kuznetsov (3):
  KVM: x86: Hyper-V invariant TSC control
  KVM: selftests: Rename 'msr->availble' to 'msr->should_not_gp' in
    hyperv_features test
  KVM: selftests: Test Hyper-V invariant TSC control

 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/cpuid.c                          |   7 +
 arch/x86/kvm/hyperv.c                         |  19 +++
 arch/x86/kvm/hyperv.h                         |  15 ++
 arch/x86/kvm/x86.c                            |   4 +-
 .../selftests/kvm/x86_64/hyperv_features.c    | 159 +++++++++++++-----
 6 files changed, 158 insertions(+), 47 deletions(-)

-- 
2.37.2

