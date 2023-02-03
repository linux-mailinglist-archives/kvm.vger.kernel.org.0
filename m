Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006C0689436
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 10:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjBCJoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjBCJnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C01793F3
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675417380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tHFJYodS+GlZliPPBpSywnTgXG8QiYZdzMEcCQFBMZk=;
        b=PSotc3wpmxH7nvfBTN+zjM4Hi3S5WVx6xbywTPXlX/6IDPytf0mycIfLJN+eVT8iZsEVns
        knaJ0/yRwTOWzxEecn2aE3kpMZ32HsgVMAt+7funxuCQAzs9ULrPE+fsuoisJSdGuO/8gg
        IhC8486BOVfSVOd7lEgnb7bVkJDWnJQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-JjRiMZkKNgqIaOgbneMQ2A-1; Fri, 03 Feb 2023 04:42:56 -0500
X-MC-Unique: JjRiMZkKNgqIaOgbneMQ2A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3DB029AB3F7;
        Fri,  3 Feb 2023 09:42:55 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9C46408573E;
        Fri,  3 Feb 2023 09:42:52 +0000 (UTC)
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
Subject: [PATCH 5/7] KVM: s390: Use "int" as return type for kvm_s390_get/set_skeys()
Date:   Fri,  3 Feb 2023 10:42:28 +0100
Message-Id: <20230203094230.266952-6-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-1-thuth@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two functions only return normal integers, so it does not
make sense to declare the return type as "long" here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e4890e04b210..8ad1972b8a73 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1992,7 +1992,7 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
-static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
+static int kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
 	uint8_t *keys;
 	uint64_t hva;
@@ -2040,7 +2040,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	return r;
 }
 
-static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
+static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
 	uint8_t *keys;
 	uint64_t hva;
-- 
2.31.1

