Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD85B356E
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiIIKp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiIIKpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603DF41983
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5USZdofT3b7rr0YzPxgVn0M8YXPxXCyJIOd7HvwaYnU=;
        b=Iaodoauu/qntVzYUZmQkXu5bAGEtV1pSZQ39SJy6H7fkh7lYcnlJHXe1gx3NjUaVtJQ+5d
        2ju/eQZwryDlGxcbylM1Q4PR72mq2t82RBDOJG/pN1hsA5nx/Zrwy9Fs4n3ofbTjJ2m49c
        U+p47aqI0fqnDZbE9RGLGfE340z1cmk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-3yjYgqGqN4ePcQJ31JTu2w-1; Fri, 09 Sep 2022 06:45:10 -0400
X-MC-Unique: 3yjYgqGqN4ePcQJ31JTu2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3A09811E81;
        Fri,  9 Sep 2022 10:45:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4111F40D282E;
        Fri,  9 Sep 2022 10:45:09 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 1/9] kvm_main.c: move slot check in kvm_set_memory_region
Date:   Fri,  9 Sep 2022 06:44:58 -0400
Message-Id: <20220909104506.738478-2-eesposit@redhat.com>
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And make kvm_set_memory_region static, since it is not used outside
kvm_main.c

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 11 +++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b40f8d68fbb..1c5b7b2e35dd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1108,8 +1108,6 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region *mem);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index da263c370d00..339de0ed4557 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2007,24 +2007,23 @@ int __kvm_set_memory_region(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region *mem)
+static int kvm_set_memory_region(struct kvm *kvm,
+				 const struct kvm_userspace_memory_region *mem)
 {
 	int r;
 
+	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
+		return -EINVAL;
+
 	mutex_lock(&kvm->slots_lock);
 	r = __kvm_set_memory_region(kvm, mem);
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_set_memory_region);
 
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region *mem)
 {
-	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
-		return -EINVAL;
-
 	return kvm_set_memory_region(kvm, mem);
 }
 
-- 
2.31.1

