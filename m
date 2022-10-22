Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8ED608E33
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJVPse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJVPsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD424F7AA
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+xYh4ED8NY+eSwwcDjW7bMv+eHis2lS261cJxu7qzg=;
        b=WlgAi6m0eZv6v4inzbAUpTsYY2Ls6oedU3zW6RkTciAYrj7twGDKVR9NIgX7F8X6HfuX28
        e8YdTwgbHeGCWWeGoKpatNbaw2UwlYaEuERFfgT/MMPYrcV+jh2wbn4uS+4MVjBlvW5L5d
        0SntYgIOZdQHsUJtTysrcXsjt48ABvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-cSLsb5qPObusKCwipu1UWA-1; Sat, 22 Oct 2022 11:48:23 -0400
X-MC-Unique: cSLsb5qPObusKCwipu1UWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3122F85A59D;
        Sat, 22 Oct 2022 15:48:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C65FD4A9279;
        Sat, 22 Oct 2022 15:48:22 +0000 (UTC)
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
Subject: [PATCH 3/4] KVM: introduce memory transaction semaphore
Date:   Sat, 22 Oct 2022 11:48:18 -0400
Message-Id: <20221022154819.1823133-4-eesposit@redhat.com>
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

Right now the semaphore is only used to signal that a vcpu
entered KVM_RUN (not necessarly in guest mode, could be also
blocked/halted).
Later it will be used by specific ioctls (writers) to wait that
all vcpus (readers) exit from KVM_RUN.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c080b93edc0d..ae0240928a4a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -119,6 +119,8 @@ static const struct file_operations stat_fops_per_vm;
 
 static struct file_operations kvm_chardev_ops;
 
+static DECLARE_RWSEM(memory_transaction);
+
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -4074,7 +4076,19 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+		/*
+		 * Notify that a vcpu wants to run, and thus could be reading
+		 * memslots.
+		 * If KVM_KICK_ALL_RUNNING_VCPUS runs afterwards, it will have
+		 * to wait that KVM_RUN exited and up_read() is called.
+		 * If KVM_KICK_ALL_RUNNING_VCPUS already returned but
+		 * KVM_RESUME_ALL_KICKED_VCPUS didn't start yet, then there
+		 * is a request pending for the vcpu that will cause it to
+		 * exit KVM_RUN.
+		 */
+		down_read(&memory_transaction);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
+		up_read(&memory_transaction);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
 	}
-- 
2.31.1

