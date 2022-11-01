Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EBA614D9D
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKAPB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiKAPBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE3F2BC0
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7puXFXv1DG8mFUtGfN+hbNIIoLLWZiDM4OzPtCAwHnA=;
        b=etYcSPKa/d9TChdgstJIHCqRymcRZnDlo+Pm/GovZnC95qAMJFWBu2N5BA+/8g6EdJ0qq5
        oaLfnTQyvAV88xZdRu0x0mF2Q0+E0Mxwe3m0f79xyyjzWiSk/LY/k3ez1iGJH0P8bhMYmX
        w0En9OpV1ftJDnIeVKtxOG0ZbKQZIrA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-tOQTKxiRP_uhix1cMQetdQ-1; Tue, 01 Nov 2022 10:56:39 -0400
X-MC-Unique: tOQTKxiRP_uhix1cMQetdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B5AF80600A;
        Tue,  1 Nov 2022 14:56:23 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68F8DC15BB9;
        Tue,  1 Nov 2022 14:56:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 34/48] KVM: selftests: Fill in vm->vpages_mapped bitmap in virt_map() too
Date:   Tue,  1 Nov 2022 15:54:12 +0100
Message-Id: <20221101145426.251680-35-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to vm_vaddr_alloc(), virt_map() needs to reflect the mapping
in vm->vpages_mapped.

While on it, remove unneeded code wrapping in vm_vaddr_alloc().

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3578b9a7cc2f..29f743086ecc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1256,8 +1256,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 
 		virt_pg_map(vm, vaddr, paddr);
 
-		sparsebit_set(vm->vpages_mapped,
-			vaddr >> vm->page_shift);
+		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
 	}
 
 	return vaddr_start;
@@ -1330,6 +1329,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		virt_pg_map(vm, vaddr, paddr);
 		vaddr += page_size;
 		paddr += page_size;
+
+		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
 	}
 }
 
-- 
2.37.3

