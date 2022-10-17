Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01C6601690
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJQSqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJQSqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:46:09 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB76BCC6;
        Mon, 17 Oct 2022 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666032368; x=1697568368;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EqMS78BqaEgrJ8n2idqb2fjfwDUFuedeNdX3iH6Y4sU=;
  b=CAj0Hz/mCUYDWD0eCN8fma5/hVBruDPFOfM2P0P0EKvDAAH61VgnQ9Yz
   o7vC0ahEB4ZERJq8ZFAms4gDXR/t1Yc6EFCxDN2buupCvOSt27vkHUBVd
   QqlpJTLkr1B+kHm3PC5A+e4SRCYXtwL5uGX6UuJfBfrupcAomxa2jWuQ8
   U=;
X-IronPort-AV: E=Sophos;i="5.95,192,1661817600"; 
   d="scan'208";a="252884879"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:46:05 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 5300145CA7;
        Mon, 17 Oct 2022 18:46:03 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 17 Oct 2022 18:45:50 +0000
Received: from f02f4b0103c5.ant.amazon.com (10.43.162.35) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Mon, 17 Oct 2022 18:45:48 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Andrew Randrianasulu" <randrianasulu@gmail.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 0/3] KVM: x86: Add KVM_X86_SET_MSR_FILTE compat handler
Date:   Mon, 17 Oct 2022 20:45:38 +0200
Message-ID: <20221017184541.2658-1-graf@amazon.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit 1a155254ff937 ("KVM: x86: Introduce MSR filtering") we
introduced a new ioctl to handle MSR filtering. However, this ioctl
passes a pointer to kernel space in an ioctl struct - which breaks in
32-on-64 bit compat situations.

This patch set introduces a compat mechanism for architecutre spacific
VM ioctls and implements an MSR_FILTER wrapper in it.

Alexander Graf (3):
  kvm: Add support for arch compat vm ioctls
  KVM: x86: Make filter arg for set_msr_filter()
  KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

 arch/x86/kvm/x86.c       | 87 +++++++++++++++++++++++++++++++++-------
 include/linux/kvm_host.h |  2 +
 virt/kvm/kvm_main.c      | 11 +++++
 3 files changed, 86 insertions(+), 14 deletions(-)

-- 
2.37.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



