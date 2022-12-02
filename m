Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51D0640569
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiLBLAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiLBLAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:00:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC27793A5D
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669978748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hJSM4gVvibFGELZBTl77hUPT9yZlZqQ7ZzM552mEWO0=;
        b=aY3Hc0cW7u518tdQ/tk/5qDi4RucLiCK87Dt/+vdKqxBAU1HTNCBb1A3uXzFdsxLfEuB1b
        USibcSXQ2sPR+3qGZzoBrifiNDjrW2eBr85UFXmrdU0c2w0mzbC+Zlj++Vsn7Brtlh1qxe
        i9IFejhbE2TUKnn006Vd3gyvD39mz+Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-Q0X0gSc_PSy_bl-R3uZVhA-1; Fri, 02 Dec 2022 05:59:01 -0500
X-MC-Unique: Q0X0gSc_PSy_bl-R3uZVhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F4E729324B7;
        Fri,  2 Dec 2022 10:59:01 +0000 (UTC)
Received: from ovpn-192-33.brq.redhat.com (ovpn-192-33.brq.redhat.com [10.40.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89580C16922;
        Fri,  2 Dec 2022 10:58:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        coverity-bot <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: hyper-v: Fix 'using uninitialized value' Coverity warning
Date:   Fri,  2 Dec 2022 11:58:56 +0100
Message-Id: <20221202105856.434886-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_hv_flush_tlb(), 'data_offset' and 'consumed_xmm_halves' variables
are used in a mutually exclusive way: in 'hc->fast' we count in 'XMM
halves' and increase 'data_offset' otherwise. Coverity discovered, that in
one case both variables are incremented unconditionally. This doesn't seem
to cause any issues as the only user of 'data_offset'/'consumed_xmm_halves'
data is kvm_hv_get_tlb_flush_entries() ->  kvm_hv_get_hc_data() which also
takes into account 'hc->fast' but is still worth fixing.

While on it, drop the unneeded 'consumed_xmm_halves' initializer. In
'hc->fast' case the variable is always initialized and is not used
otherwise, 'data_offset' is not being initialized either.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527764 ("Uninitialized variables")
Fixes: 260970862c88 ("KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2c7f2a26421e..dee4961ad8ff 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1926,7 +1926,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
-	int consumed_xmm_halves = 0;
+	int consumed_xmm_halves;
 	gpa_t data_offset;
 
 	/*
@@ -2021,8 +2021,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		 * consumed_xmm_halves to make sure TLB flush entries are read
 		 * from the correct offset.
 		 */
-		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
-		consumed_xmm_halves += hc->var_cnt;
+		if (hc->fast)
+			consumed_xmm_halves += hc->var_cnt;
+		else
+			data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
 	}
 
 	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
-- 
2.38.1

