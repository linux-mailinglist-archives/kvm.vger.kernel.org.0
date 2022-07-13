Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C55739AE
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbiGMPGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 11:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236886AbiGMPGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 11:06:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2CA24A83E
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657724750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xM8OhCYdzL1TI8hxF7mEbs2A7snNMwd69ycLkAbKVa4=;
        b=XpDLf4Y7+VjZ/ConNdr/wsjMUqViEi/yZwPws6/+jGPS9qdy6mBGDhYWAE2SrZTY3wl2+5
        i7C5kulpKRWbRsE0ToC54mjsgxg6XqtwrMYgFZ01rWl/sRM4CsHHrsLg1UDCtT/3a0xOnD
        dHs6rzkeFAo8c3OC1pUm9pLGJ44USrQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-SF1orYL9PVW9VHXTjmbEgQ-1; Wed, 13 Jul 2022 11:05:45 -0400
X-MC-Unique: SF1orYL9PVW9VHXTjmbEgQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5472684AC69;
        Wed, 13 Jul 2022 15:05:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3243492C3B;
        Wed, 13 Jul 2022 15:05:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: Hyper-V invariant TSC control feature
Date:   Wed, 13 Jul 2022 17:05:29 +0200
Message-Id: <20220713150532.1012466-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
  KVM: selftests: Fix wrmsr_safe()
  KVM: selftests: Test Hyper-V invariant TSC control

 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/cpuid.c                          |  7 ++
 arch/x86/kvm/hyperv.c                         | 19 +++++
 arch/x86/kvm/hyperv.h                         | 15 ++++
 arch/x86/kvm/x86.c                            |  4 +-
 .../selftests/kvm/include/x86_64/processor.h  |  2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    | 73 ++++++++++++++++++-
 7 files changed, 115 insertions(+), 6 deletions(-)

-- 
2.35.3

