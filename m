Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EAE60FCF7
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiJ0QVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiJ0QS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C2D19637E
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUVijSFivcu94lUnkyEd2RGaEvfXWEp1CBYc7P4eIz8=;
        b=hzxbjAfIOMPquyixUyancew306vmijNqcLSo2LWa/9CF9XQADrRgOmbGAn9i0x0zmCeF4F
        DM2dOFuKBy0VZnGhqJD6zpTBBiXal0lN5Iz1/PZ/v4ggVOeKz9u9gX+SZwUpWeURi1wNnB
        JBnOSHYZzgEc50eOV/aLDCDLRuhdkdk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-mg8LLvftPvWJXbuX6Lw-5Q-1; Thu, 27 Oct 2022 12:18:51 -0400
X-MC-Unique: mg8LLvftPvWJXbuX6Lw-5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFC311C0896E;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD54E1415117;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently with VM word size
Date:   Thu, 27 Oct 2022 12:18:36 -0400
Message-Id: <20221027161849.2989332-4-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM unconditionally uses the "full" size of the Xen shared info page when
activating the cache in kvm_xen_vcpu_set_attr(), but using the current
mode matches what Xen does.  While KVM did always use the 64-bit size
when activating the cache, what matters is that Xen does not look
beyond the size of the 32-bit struct if the vCPU was initialized in
32-bit mode.  If the guest sets up the runstate info of a 32-bit
VM so that the struct ends at the end of a page, the 64-bit struct
size passed to kvm_gpc_activate() will cause the ioctl or hypercall
to fail, because gfn-to-pfn caches can only be set up for data that fits
in a single page.

Nevertheless, keeping the Xen word size constant throughout the life
of the gpc cache, i.e. not using a different size at check()+refresh()
than at activate(), is desirable because it makes the length/size of
the cache immutable.  This in turn yields a cleaner set of APIs and
avoids potential bugs that could occur if check() were invoked with
a different size than refresh().

So, use the short size at activation time as well.  This means
re-activating the cache if the guest requests the hypercall page
multiple times with different word sizes (this can happen when
kexec-ing, for example).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/xen.c | 47 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b2be60c6efa4..512b4afa6785 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -198,6 +198,37 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 	vx->runstate_entry_time = now;
 }
 
+static inline size_t kvm_xen_runstate_info_size(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		return sizeof(struct vcpu_runstate_info);
+	else
+		return sizeof(struct compat_vcpu_runstate_info);
+}
+
+static int kvm_xen_activate_runstate_gpc(struct kvm_vcpu *vcpu, unsigned long gpa)
+{
+	size_t user_len = kvm_xen_runstate_info_size(vcpu->kvm);
+	return kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
+				NULL, KVM_HOST_USES_PFN, gpa, user_len);
+}
+
+static int kvm_xen_reactivate_runstate_gpcs(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.xen.runstate_cache.active) {
+			int r = kvm_xen_activate_runstate_gpc(vcpu,
+					vcpu->arch.xen.runstate_cache.gpa);
+			if (r < 0)
+				return r;
+		}
+	}
+	return 0;
+}
+
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
@@ -212,11 +243,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	if (!vx->runstate_cache.active)
 		return;
 
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
-		user_len = sizeof(struct vcpu_runstate_info);
-	else
-		user_len = sizeof(struct compat_vcpu_runstate_info);
-
+	user_len = kvm_xen_runstate_info_size(v->kvm);
 	read_lock_irqsave(&gpc->lock, flags);
 	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
 					   user_len)) {
@@ -461,7 +488,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 			mutex_lock(&kvm->lock);
 			kvm->arch.xen.long_mode = !!data->u.long_mode;
 			mutex_unlock(&kvm->lock);
-			r = 0;
+			r = kvm_xen_reactivate_runstate_gpcs(kvm);
 		}
 		break;
 
@@ -596,9 +623,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
-		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
-				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct vcpu_runstate_info));
+		r = kvm_xen_activate_runstate_gpc(vcpu, data->u.gpa);
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -843,9 +868,13 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	u32 page_num = data & ~PAGE_MASK;
 	u64 page_addr = data & PAGE_MASK;
 	bool lm = is_long_mode(vcpu);
+	int r;
 
 	/* Latch long_mode for shared_info pages etc. */
 	vcpu->kvm->arch.xen.long_mode = lm;
+	r = kvm_xen_reactivate_runstate_gpcs(kvm);
+	if (r < 0)
+		return 1;
 
 	/*
 	 * If Xen hypercall intercept is enabled, fill the hypercall
-- 
2.31.1


