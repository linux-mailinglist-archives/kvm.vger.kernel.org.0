Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2767F4E7415
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354224AbiCYNXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353248AbiCYNXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:23:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAB5CC6834
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648214507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jHB6BR0YbApCBzRoAgSeCurDpGlWHsYv9gOGQx13pb0=;
        b=Al5Jj0HXFw2Uw9Vm+GAcsXO6SY61XlNdJk+lQ+6iMbQRN6Yvz7UIN1gYBCCUjvPKN/BST2
        mWr6Lq0nsk/xfTMfGu/xoZRxzlf/eVhgvcvzSGvHjAq1ZlpBlIVV8fYZnWj5E3Eus+qEif
        5jFmd53EnQ3mGHvaGydXX0Jn0OnBsyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-pQDQAainO_GMcwUfculRtg-1; Fri, 25 Mar 2022 09:21:43 -0400
X-MC-Unique: pQDQAainO_GMcwUfculRtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 772D3866DF1;
        Fri, 25 Mar 2022 13:21:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FA622166B16;
        Fri, 25 Mar 2022 13:21:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: Prefent NULL prointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Fri, 25 Mar 2022 14:21:37 +0100
Message-Id: <20220325132140.25650-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Syzkaller found the following crash:

general protection fault, probably for non-canonical address
0xdffffc0000000013: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
CPU: 1 PID: 679 Comm: syz-executor210 Not tainted 5.17.0-rc8 #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1ubuntu1~cloud0 04/01/2014
RIP: 0010:kvm_irq_delivery_to_apic_fast+0x3dd/0x670 arch/x86/kvm/lapic.c:995
...
Call Trace:
 <TASK>
 kvm_irq_delivery_to_apic+0xb8/0x860 arch/x86/kvm/irq_comm.c:54
 synic_set_irq+0x169/0x340 arch/x86/kvm/hyperv.c:463
 synic_deliver_msg arch/x86/kvm/hyperv.c:770 [inline]
 stimer_send_msg arch/x86/kvm/hyperv.c:793 [inline]
 stimer_expiration arch/x86/kvm/hyperv.c:817 [inline]
 kvm_hv_process_stimers+0xe85/0x1210 arch/x86/kvm/hyperv.c:849
 vcpu_enter_guest+0x37cb/0x4070 arch/x86/kvm/x86.c:9947
 vcpu_run arch/x86/kvm/x86.c:10261 [inline]
...

The immediate issue is that kvm_irq_delivery_to_apic_fast() dereferences
'src' while in some cases it can be NULL. A sentinel against this is added
in PATCH2 of the series, however, the condition should not happen in the
first place. synic_set_irq() should not call kvm_irq_delivery_to_apic() with
'shorthand = APIC_DEST_SELF' and 'vcpu->arch.apic == NULL' and this is also
'fixed' by PATCH1. The root cause of the problem, however, is that VMM was
allowed to  enable Hyper-V synthetic timer when IRQ chip wasn't created.
This is fixed by PATCH3.

Vitaly Kuznetsov (3):
  KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
  KVM: x86: Avoid theoretical NULL pointer dereference in
    kvm_irq_delivery_to_apic_fast()
  KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't
    activated

 arch/x86/kvm/hyperv.c | 12 +++++++++---
 arch/x86/kvm/lapic.c  |  4 ++++
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.35.1

