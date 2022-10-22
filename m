Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2760B608E2D
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJVPsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJVPs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C122D24F0F
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1V0vMZpfXGyU72nQJGgurcWjMWd4+DUDDvGesYkw+w=;
        b=C9iw/DLWjETkVxiVskUR7Ulb7jZS0nHZPoMUewURbMicxjWda64fyHnbE3Fk4HGTgEcfH/
        BWyzbjG0v74zbfLkbE4MZDdJtfARFY9Io8rQ37r/n8kxlUw/vnBU0/y1VbdGCI7XfNIVR+
        UNuM74jZAsS3aZdZmYCNKzKCvVNu3NE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-_KyNeSWwMFydFnCfRiW-Lg-1; Sat, 22 Oct 2022 11:48:24 -0400
X-MC-Unique: _KyNeSWwMFydFnCfRiW-Lg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 980EC800B30;
        Sat, 22 Oct 2022 15:48:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A31F4A9268;
        Sat, 22 Oct 2022 15:48:23 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 4/4] KVM: use signals to abort enter_guest/blocking and retry
Date:   Sat, 22 Oct 2022 11:48:19 -0400
Message-Id: <20221022154819.1823133-5-eesposit@redhat.com>
In-Reply-To: <20221022154819.1823133-1-eesposit@redhat.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once a vcpu exectues KVM_RUN, it could enter two states:
enter guest mode, or block/halt.
Use a signal to allow a vcpu to exit the guest state or unblock,
so that it can exit KVM_RUN and release the read semaphore,
allowing a pending KVM_KICK_ALL_RUNNING_VCPUS to continue.

Note that the signal is not deleted and used to propagate the
exit reason till vcpu_run(). It will be clearead only by
KVM_RESUME_ALL_KICKED_VCPUS. This allows the vcpu to keep try
entering KVM_RUN and perform again all checks done in
kvm_arch_vcpu_ioctl_run() before entering the guest state,
where it will return again if the request is still set.

However, the userspace hypervisor should also try to avoid
continuously calling KVM_RUN after invoking KVM_KICK_ALL_RUNNING_VCPUS,
because such call will just translate in a back-to-back down_read()
and up_read() (thanks to the signal).

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              |  8 ++++++++
 virt/kvm/kvm_main.c             | 21 +++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa381ab69a19..d5c37f344d65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -108,6 +108,8 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_USERSPACE_KICK		\
+	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c47b41c264..2af5f427b4e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10270,6 +10270,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_request_pending(vcpu)) {
+		if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu)) {
+			r = -EINTR;
+			goto out;
+		}
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
@@ -10701,6 +10705,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			r = vcpu_block(vcpu);
 		}
 
+		/* vcpu exited guest/unblocked because of this request */
+		if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu))
+			return -EINTR;
+
 		if (r <= 0)
 			break;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ae0240928a4a..13fa7229b85d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3431,6 +3431,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 		goto out;
 	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
 		goto out;
+	if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu))
+		goto out;
 
 	ret = 0;
 out:
@@ -4668,6 +4670,25 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_enable_cap_generic(kvm, &cap);
 		break;
 	}
+	case KVM_KICK_ALL_RUNNING_VCPUS: {
+		/*
+		 * Notify all running vcpus that they have to stop.
+		 * Caught in kvm_arch_vcpu_ioctl_run()
+		 */
+		kvm_make_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);
+
+		/*
+		 * Use wr semaphore to wait for all vcpus to exit from KVM_RUN.
+		 */
+		down_write(&memory_transaction);
+		up_write(&memory_transaction);
+		break;
+	}
+	case KVM_RESUME_ALL_KICKED_VCPUS: {
+		/* Remove all requests sent with KVM_KICK_ALL_RUNNING_VCPUS */
+		kvm_clear_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);
+		break;
+	}
 	case KVM_SET_USER_MEMORY_REGION: {
 		struct kvm_userspace_memory_region kvm_userspace_mem;
 
-- 
2.31.1

