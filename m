Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41B533967
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbiEYJGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiEYJEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE2619EB5F
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ry63xFrwO6O2lt3NumR064ix6uPD5MMi+epdiiFne5w=;
        b=Z14VQoT4c+SvXFHzbNkYth54p9URrH+0lo7XH8pbu6wEA89gEv1MPDPcGKJMq8zhsW5fcy
        xgnYTidRHZBKHZcNYGlVuJJaa79m2IL7Yv3Tp/uF3WMjf7DBEywFCAobl6YHDYlxZ378EP
        m8ZLeIYDjXCF2EwgnHeCHoADmGnAZtI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-GoX2hHSvPSqiz4xr-fkiHg-1; Wed, 25 May 2022 05:02:33 -0400
X-MC-Unique: GoX2hHSvPSqiz4xr-fkiHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB7ED1C161A3;
        Wed, 25 May 2022 09:02:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B23A40CFD0A;
        Wed, 25 May 2022 09:02:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 27/37] KVM: selftests: Fill in vm->vpages_mapped bitmap in virt_map() too
Date:   Wed, 25 May 2022 11:01:23 +0200
Message-Id: <20220525090133.1264239-28-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to vm_vaddr_alloc(), virt_map() needs to reflect the mapping
in vm->vpages_mapped.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..936be9c9f870 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1445,6 +1445,9 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		virt_pg_map(vm, vaddr, paddr);
 		vaddr += page_size;
 		paddr += page_size;
+
+		sparsebit_set(vm->vpages_mapped,
+			vaddr >> vm->page_shift);
 	}
 }
 
-- 
2.35.3

