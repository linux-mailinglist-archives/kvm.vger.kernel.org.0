Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B90674BA3
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjATFDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjATFDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE0ABF894
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674190131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=YYXmdZgI3lB6sQY5MXDCGBbOIjoGEI2fjlTYFq/yTec=;
        b=QbjqlQc/Ee+LxChPkJJZRh0OqRXmKtO6gfEKyh0hpyVVvam90t0x+R5jtwishWfy3dJWg6
        63QyWD6wRnQXESnskBQ/7h3yopwQC9SXJzd0IUe0O7Oq9C0Osmmy2l7LBJWEmL+n2Y8NWd
        dvUnDmQ9CZeGtoitQKzdgLid4GuJQCc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-ABWqjFONPf2yDnTj_rMZSQ-1; Thu, 19 Jan 2023 23:48:50 -0500
X-MC-Unique: ABWqjFONPf2yDnTj_rMZSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C4DA811E6E
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 04:48:50 +0000 (UTC)
Received: from tpad.localdomain (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2C664085720;
        Fri, 20 Jan 2023 04:48:49 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
        id EE86B404F37BD; Thu, 19 Jan 2023 22:06:05 -0300 (-03)
Date:   Thu, 19 Jan 2023 22:06:05 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: add bit to indicate correct tsc_shift
Message-ID: <Y8no/eAQi0QkIJqa@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Before commit 78db6a5037965429c04d708281f35a6e5562d31b,
kvm_guest_time_update() would use vcpu->virtual_tsc_khz to calculate
tsc_shift value in the vcpus pvclock structure written to guest memory.

For those kernels, if vcpu->virtual_tsc_khz != tsc_khz (which can be the
case when guest state is restored via migration, or if tsc-khz option is
passed to QEMU), and TSC scaling is not enabled (which happens if the
difference between the frequency requested via KVM_SET_TSC_KHZ and the
host TSC KHZ is smaller than 250ppm), then there can be a difference
between what KVM_GET_CLOCK would return and what the guest reads as
kvmclock value.

When KVM_SET_CLOCK'ing what is read with KVM_GET_CLOCK, the
guest can observe a forward or backwards time jump.

Advertise to userspace that current kernel contains
this fix, so QEMU can workaround the problem by reading
pvclock via guest memory directly otherwise.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..61c5876cfd87 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2160,7 +2160,8 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
-	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC | \
+	 KVM_CLOCK_CORRECT_TSC_SHIFT)
 
 #define KVM_X86_VALID_QUIRKS			\
 	(KVM_X86_QUIRK_LINT0_REENABLED |	\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..142a53d06100 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3014,6 +3014,8 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
+	data->flags |= KVM_CLOCK_CORRECT_TSC_SHIFT;
+
 	put_cpu();
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..7b94d7bd03a6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1301,6 +1301,9 @@ struct kvm_irqfd {
 #define KVM_CLOCK_TSC_STABLE		2
 #define KVM_CLOCK_REALTIME		(1 << 2)
 #define KVM_CLOCK_HOST_TSC		(1 << 3)
+/* whether tsc_shift as seen by the guest matches guest visible TSC */
+/* This is true since commit 78db6a5037965429c04d708281f35a6e5562d31b */
+#define KVM_CLOCK_CORRECT_TSC_SHIFT	(1 << 4)
 
 struct kvm_clock_data {
 	__u64 clock;

