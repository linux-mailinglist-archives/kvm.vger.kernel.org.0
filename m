Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221DD4BFD63
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiBVPrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiBVPra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362F734BA3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645544823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h6bvUsV6MbZQFLU1kqZl5+6UhvWNXTn9F3aBGMueqc0=;
        b=CEIUDLvaZtXmqKbfl2e/JcshD93jnQTpGTmPzJWDZbF0llqeJA903VXSS5ed5X+3CH6CCM
        1pWxXHqoZsrGMhtopgHXPYuzBUIdQxCWXSAbxLB3qbgRMSKfednD8K2PLWtz2ZEdZNbI+q
        TC3R2IULHVIG0H4Vy/UK5k3Gv8eVgZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-dOIWsxczPcentJ9ujF71hQ-1; Tue, 22 Feb 2022 10:47:00 -0500
X-MC-Unique: dOIWsxczPcentJ9ujF71hQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD213FC81;
        Tue, 22 Feb 2022 15:46:58 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6E79106D5DC;
        Tue, 22 Feb 2022 15:46:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
Date:   Tue, 22 Feb 2022 16:46:38 +0100
Message-Id: <20220222154642.684285-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While working on some Hyper-V TLB flush improvements and Direct TLB flush
feature for Hyper-V on KVM I experienced Windows Server 2019 crashes on
boot when XMM fast hypercall input feature is advertised. Turns out,
HVCALL_SEND_IPI_EX is also an XMM fast hypercall and returning an error
kills the guest. This is fixed in PATCH4. PATCH3 fixes erroneous capping
of sparse CPU banks for XMM fast TLB flush hypercalls. The problem should
be reproducible with >360 vCPUs.

Vitaly Kuznetsov (4):
  KVM: x86: hyper-v: Drop redundant 'ex' parameter from
    kvm_hv_send_ipi()
  KVM: x86: hyper-v: Drop redundant 'ex' parameter from
    kvm_hv_flush_tlb()
  KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast
    TLB flush hypercalls
  KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall

 arch/x86/kvm/hyperv.c | 84 +++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

-- 
2.35.1

