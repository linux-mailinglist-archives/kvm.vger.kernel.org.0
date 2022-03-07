Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76384D0207
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiCGOxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiCGOw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:52:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 536E48EB5A
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3smDROMP8QMSLDecB2DTW8XgUBKKv8Df2PL4vzKcmzw=;
        b=HMaBMImGvGESe1rKmQE2bHnqylQ+ey9Z7tvI9iRJhI/FwtaUrHs+tqgZlSpFRYcaWL+Z6j
        SlurozSUrDYLmq9C7rNoqQpeCURdBfScBn9Ub/AXzz3v7mKvtmldYFV7RCp+xOC21PuIwR
        tzQNy4DyTfp3A2vUrgDTxshq8UbViVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-IbXWloJJNCO6R6dPZ7MaZA-1; Mon, 07 Mar 2022 09:51:21 -0500
X-MC-Unique: IbXWloJJNCO6R6dPZ7MaZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44BEF1854E27;
        Mon,  7 Mar 2022 14:51:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 176A07FFEF;
        Mon,  7 Mar 2022 14:51:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 19/19] KVM: x86: Expose Hyper-V Direct TLB flush feature
Date:   Mon,  7 Mar 2022 15:50:23 +0100
Message-Id: <20220307145023.1913205-20-vkuznets@redhat.com>
In-Reply-To: <20220307145023.1913205-1-vkuznets@redhat.com>
References: <20220307145023.1913205-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With both nSVM and nVMX implementations in place, KVM can export
Hyper-V Direct TLB flush feature to userspace.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 31acc08a6b23..d52de033ce36 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2815,6 +2815,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
+			ent->eax |= HV_X64_NESTED_DIRECT_FLUSH;
 			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
 
 			break;
-- 
2.35.1

