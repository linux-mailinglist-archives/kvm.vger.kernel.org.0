Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53E468943E
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 10:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjBCJp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjBCJp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30759AFD0
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675417447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/oxBv4GyMlmg4LCOb2+pqMxLhVHvEGbOFN4G7DG1xk=;
        b=CTtUQEQww0u+PShsySYCy4VfkwtdhlXxsjT+7lj2MDxOHTwZbLhPmuyjmirZni7ZWgqcv/
        vCtsuky/2D/cgk+kCREdUMYp0A9MQzGXxMVsNJBcHXfyYOogtO51OWp/kz5udtRZfI3Fzz
        8C/ct8R7WPJejdtMn7lmKxZuCFSVHpc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-UD1PGtHHOTCTHRED0JEgqA-1; Fri, 03 Feb 2023 04:42:44 -0500
X-MC-Unique: UD1PGtHHOTCTHRED0JEgqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FA2929AB3F9;
        Fri,  3 Feb 2023 09:42:43 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B902140168BF;
        Fri,  3 Feb 2023 09:42:40 +0000 (UTC)
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
Subject: [PATCH 1/7] KVM: Standardize on "int" return types instead of "long" in kvm_main.c
Date:   Fri,  3 Feb 2023 10:42:24 +0100
Message-Id: <20230203094230.266952-2-thuth@redhat.com>
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

KVM functions use "long" return values for functions that are wired up
to "struct file_operations", but otherwise use "int" return values for
functions that can return 0/-errno in order to avoid unintentional
divergences between 32-bit and 64-bit kernels.
Some code still uses "long" in unnecessary spots, though, which can
cause a little bit of confusion and unnecessary size casts. Let's
change these spots to use "int" types, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..cd46467252a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4475,7 +4475,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	return 0;
 }
 
-static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
+static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
 	case KVM_CAP_USER_MEMORY:
@@ -5053,7 +5053,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
-	long r = -EINVAL;
+	int r = -EINVAL;
 
 	switch (ioctl) {
 	case KVM_GET_API_VERSION:
-- 
2.31.1

