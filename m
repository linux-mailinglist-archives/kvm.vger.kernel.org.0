Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6266A4CE6
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjB0VOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjB0VOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:14:38 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70E23D85;
        Mon, 27 Feb 2023 13:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677532476; x=1709068476;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2KiKvFK2pjl8jx0HGi3QbZP7fKXFC2HYLTg5JQbTjrI=;
  b=SND8uTU4z93mnunsWeyCUw+sFXFoEPzgWKhmLRCcIAb3XsEeR0uVLUuw
   SCJ9d4IZv2qEsc9inQSOJGyZ9/vW7T/e1OwIkDRuuiXcGdhjG5nREqis0
   zWmj+llWVQUNKcnMksg0T+5G2rE4ug/FRMYijSXBXd8rRX0QrylAwgRD7
   k=;
X-IronPort-AV: E=Sophos;i="5.98,220,1673913600"; 
   d="scan'208";a="187220727"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 21:05:49 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id A4C7140D3F;
        Mon, 27 Feb 2023 21:05:47 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 21:05:47 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.130.142) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 21:05:42 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>, <x86@kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        "Takahiro Itazuri" <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Mon, 27 Feb 2023 21:05:24 +0000
Message-ID: <20230227210526.83182-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.130.142]
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMMs retrieve supported CPUID features via KVM_GET_SUPPORTED_CPUID to
construct CPUID information to be passed to KVM_SET_CPUID2. Most CPUID
feature bits related to speculative attacks are propagated from host
CPUID. But AMD processors have AMD-specific IBRS related bits in CPUID
Fn8000_0008_EBX (ref: AMD64 Architecture Programmer's Manual Volume 3:
General-Purpose and System Instructions) and some bits are not
propagated to guests.

Enable propagation of these bits to guests, so that VMMs don't have to
enable them explicitly based on host CPUID.

Takahiro Itazuri (2):
  x86/cpufeatures: Add AMD-specific IBRS bits
  KVM: x86: Propagate AMD-specific IBRS related bits

 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.38.0

