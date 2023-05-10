Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300AE6FE3C7
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 20:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbjEJSQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbjEJSQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 14:16:28 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA516A78;
        Wed, 10 May 2023 11:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683742584; x=1715278584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4+PLDXIuLS7zMNKmQgEeIqDX/trfOpS2kPwFzqSrpDg=;
  b=Co3hos0ytHdk5iywIE6+f50Xn1SiQSYKXnWJz8XWKvhHggewBarIn/Bn
   1q1T+IKChA0rpAruyx0gm+nzwmcBc/HgLjprDEGkAEfb+G3s3rPXjRC0z
   +nU3Np7hqAjXCr+6oxpYm8saHtL+mkkPbr9J0KGqLykOAbU0hm1sonxx+
   4=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="212881562"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:16:22 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id AC81E81F07;
        Wed, 10 May 2023 18:16:18 +0000 (UTC)
Received: from EX19D002UWC001.ant.amazon.com (10.13.138.148) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:18 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D002UWC001.ant.amazon.com (10.13.138.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 18:16:17 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Wed, 10 May 2023 18:16:17
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 53F66BF6; Wed, 10 May 2023 18:16:17 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lee@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>,
        <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 0/9] KVM backports to 5.10
Date:   Wed, 10 May 2023 18:15:38 +0000
Message-ID: <20230510181547.22451-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series backports a few VM preemption_status, steal_time and
PV TLB flushing fixes to 5.10 stable kernel.

Most of the changes backport cleanly except i had to work around a few
because of missing support/APIs in 5.10 kernel. I have captured those in
the changelog as well in the individual patches.

Earlier patch series that i'm resending for stable.
https://lore.kernel.org/all/20220909181351.23983-1-risbhat@amazon.com/

Changelog
- Use mark_page_dirty_in_slot api without kvm argument (KVM: x86: Fix
  recording of guest steal time / preempted status)
- Avoid checking for xen_msr and SEV-ES conditions (KVM: x86:
  do not set st->preempted when going back to user space)
- Use VCPU_STAT macro to expose preemption_reported and
  preemption_other fields (KVM: x86: do not report a vCPU as preempted
  outside instruction boundaries)

David Woodhouse (2):
  KVM: x86: Fix recording of guest steal time / preempted status
  KVM: Fix steal time asm constraints

Lai Jiangshan (1):
  KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior

Paolo Bonzini (5):
  KVM: x86: do not set st->preempted when going back to user space
  KVM: x86: do not report a vCPU as preempted outside instruction
    boundaries
  KVM: x86: revalidate steal time cache if MSR value changes
  KVM: x86: do not report preemption if the steal time cache is stale
  KVM: x86: move guest_pv_has out of user_access section

Sean Christopherson (1):
  KVM: x86: Remove obsolete disabling of page faults in
    kvm_arch_vcpu_put()

 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/svm/svm.c          |   2 +
 arch/x86/kvm/vmx/vmx.c          |   1 +
 arch/x86/kvm/x86.c              | 164 ++++++++++++++++++++++----------
 4 files changed, 122 insertions(+), 50 deletions(-)

-- 
2.39.2
