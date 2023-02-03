Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D659689431
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjBCJnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjBCJnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013A428235
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675417370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DqDRH/0lCXChL6lF9FhJdEI9fG4ptLvUYJEw5ZtLX0Q=;
        b=eieaYC6CuZQYmtSR0OIyqGzJNmQjsWQpX1qdtK8jkouDcCZv1Ujg/CQnyBZWRzefl/6Mzj
        NuWqMBISA1V8dVdQuipX/a5X+OPCx3oeocLPnEz418pOFutQ/ld4lT7kMmqQTgFJHPt04U
        mdIgwEEkWBqYebV3kFB/7TqRQkE/WBA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-55hyVc76NsCFjAV8PUgtUw-1; Fri, 03 Feb 2023 04:42:47 -0500
X-MC-Unique: 55hyVc76NsCFjAV8PUgtUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D6DB85CBED;
        Fri,  3 Feb 2023 09:42:46 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B417340C1423;
        Fri,  3 Feb 2023 09:42:43 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/7] KVM: x86: Improve return type handling in kvm_vm_ioctl_get_nr_mmu_pages()
Date:   Fri,  3 Feb 2023 10:42:25 +0100
Message-Id: <20230203094230.266952-3-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-1-thuth@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vm_ioctl_get_nr_mmu_pages() tries to return a "unsigned long" value,
but its caller only stores ther return value in an "int" - which is also
what all the other kvm_vm_ioctl_*() functions are returning. So returning
values that do not fit into a 32-bit integer anymore does not work here.
It's better to adjust the return type, add a sanity check and return an
error instead if the value is too big.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..caa2541833dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6007,8 +6007,11 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	return 0;
 }
 
-static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
+static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
+	if (kvm->arch.n_max_mmu_pages > INT_MAX)
+		return -EOVERFLOW;
+
 	return kvm->arch.n_max_mmu_pages;
 }
 
-- 
2.31.1

