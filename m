Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5256350A7D2
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391245AbiDUSHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391214AbiDUSHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:07:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 782264B1E6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RmDy0KiOypH0ED0Pq5HN43KAHX+Fo77jYIn7zRippJk=;
        b=TVOt/CBL4nzSMM31xnuEkuXs3f7hesW6zLat/eoagrX/tI9JnnCRER4Vzo+8MQX1XLqbV5
        7ElBOjyW0dTwziBb0KvDc/kSOG18MxvCHpaR4i9ZXbTrglXMI5wFdrKC4sY2Co3/+Q+qp5
        RpfnywMkzSi6tsTkLVVVaEy6jBzABpA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-7Kl_lm7ZNimdk-Y0n1Mn8Q-1; Thu, 21 Apr 2022 14:04:45 -0400
X-MC-Unique: 7Kl_lm7ZNimdk-Y0n1Mn8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA1FE101AA42;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A555940E80F5;
        Thu, 21 Apr 2022 18:04:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, maz@kernel.org, apatel@ventanamicro.com,
        atishp@rivosinc.com, seanjc@google.com, pgonda@google.com
Subject: [PATCH 4/4] KVM: tell userspace that system_event.ndata is valid
Date:   Thu, 21 Apr 2022 14:04:43 -0400
Message-Id: <20220421180443.1465634-5-pbonzini@redhat.com>
In-Reply-To: <20220421180443.1465634-1-pbonzini@redhat.com>
References: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all architectures are fixed, introduce a new capability
so that userspace knows that it can look at the ndata and data[]
members of run->system_event.  Adjust the documentation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 29 ++++++++++++++++-------------
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            |  1 +
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 72183ae628f7..fe5805ab0d75 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6089,21 +6089,18 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_SEV_TERM       4
-  #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
                         __u32 ndata;
-			__u64 flags;
                         __u64 data[16];
 		} system_event;
 
 If exit_reason is KVM_EXIT_SYSTEM_EVENT then the vcpu has triggered
 a system-level event using some architecture specific mechanism (hypercall
 or some special instruction). In case of ARM64, this is triggered using
-HVC instruction based PSCI call from the vcpu. The 'type' field describes
-the system-level event type. The 'flags' field describes architecture
-specific flags for the system-level event.
+HVC instruction based PSCI call from the vcpu.
 
-Valid values for bits 30:0 of 'type' are:
+The 'type' field describes the system-level event type.
+Valid values for 'type' are:
 
  - KVM_SYSTEM_EVENT_SHUTDOWN -- the guest has requested a shutdown of the
    VM. Userspace is not obliged to honour this, and if it does honour
@@ -6117,16 +6114,23 @@ Valid values for bits 30:0 of 'type' are:
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
  - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
-   The guest physical address of the guest's GHCB is stored in `data[0]`.
 
-Valid flags are:
+If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
+architecture specific information for the system-level event.  Only
+the first `ndata` items (possibly zero) of the data array are valid.
+
+ - for arm64, data[0] is set to KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 if
+   the guest issued a SYSTEM_RESET2 call according to v1.1 of the PSCI
+   specification.
+
+ - for RISC-V, data[0] is set to the value of the second argument of the
+   ``sbi_system_reset`` call.
 
- - KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 (arm64 only) -- the guest issued
-   a SYSTEM_RESET2 call according to v1.1 of the PSCI specification.
+ - for x86, KVM_SYSTEM_EVENT_SEV_TERM stores the guest physical address of the
+   guest's GHCB in `data[0]`.
 
-Extra data for this event is stored in the `data[]` array, up to index
-`ndata-1` included, if bit 31 is set in `type`.  The data depends on the
-`type` field.  There is no extra data if bit 31 is clear or `ndata` is zero.
+Previous versions of Linux defined a `flags` member in this struct.  The
+field however was never written.
 
 ::
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5a57f74b4903..f76ffecda38a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1147,6 +1147,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
 #define KVM_CAP_VM_TSC_CONTROL 214
+#define KVM_CAP_SYSTEM_EVENT_DATA 215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfb7dabdbc63..ac57fc2c935f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4333,6 +4333,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 0;
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
+	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
 	default:
 		break;
-- 
2.31.1

