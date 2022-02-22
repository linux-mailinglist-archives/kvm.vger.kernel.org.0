Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706964BFD6B
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiBVPsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiBVPrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:47:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F1F14506B
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645544846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=slU7kmLgi9hHo0A6oMVoxmg690et1EYZZoJX475KiWk=;
        b=DGkBXyPDJiOsE2vsDeu9NIaALsg0Pafdsfqrh7vjUs1i95ep6+HsalAD6mLLNCoJT0RWkq
        4KRaClfSEJy9yFdsMuMx/sx0LVwKyJ0abKClV5ZW88PavCov9eVdU8Y9fVT2RGREF/OMJ9
        0YZBCrHmG30kYv8LHgrfFFElx2Sop60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-rKvo3pPCNtyStVz8b7kFig-1; Tue, 22 Feb 2022 10:47:23 -0500
X-MC-Unique: rKvo3pPCNtyStVz8b7kFig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9157580D6AC;
        Tue, 22 Feb 2022 15:47:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E92FE1086475;
        Tue, 22 Feb 2022 15:47:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls
Date:   Tue, 22 Feb 2022 16:46:41 +0100
Message-Id: <20220222154642.684285-4-vkuznets@redhat.com>
In-Reply-To: <20220222154642.684285-1-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
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

When TLB flush hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}_EX are
issued in 'XMM fast' mode, the maximum number of allowed sparse_banks is
not 'HV_HYPERCALL_MAX_XMM_REGISTERS - 1' (5) but twice as many (10) as each
XMM register is 128 bit long and can hold two 64 bit long banks.

Fixes: 5974565bc26d ("KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 714af3b94f31..6dda93bf98ae 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1820,7 +1820,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 
 		if (!all_cpus) {
 			if (hc->fast) {
-				if (sparse_banks_len > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
+				/* XMM0 is already consumed, each XMM holds two sparse banks. */
+				if (sparse_banks_len > 2 * (HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
 					return HV_STATUS_INVALID_HYPERCALL_INPUT;
 				for (i = 0; i < sparse_banks_len; i += 2) {
 					sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);
-- 
2.35.1

