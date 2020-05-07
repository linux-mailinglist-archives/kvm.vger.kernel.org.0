Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A043B1C88ED
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgEGLvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:51:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgEGLuT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=h2l3KOMDutolAkEtGy6K6Owvl6fNHONxFxSaO2J+VP4=;
        b=hMF7qf6xYyIH6PqiJSsC9KDNQP/GynhJYPwF1hioypRNTDT33Jjp+2PrSEFGIIV5N8tXHH
        /+sg97hiLvcj/+M5kUFteoMXN0q4hYT99hR+JS936tkHe9eipOM+WZIxjk4waKsflrZAnD
        d59rUIjM2KVxIUGTyKcAcOWHhf/Vses=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-BuECpVyTNryiHOA58JYFOQ-1; Thu, 07 May 2020 07:50:16 -0400
X-MC-Unique: BuECpVyTNryiHOA58JYFOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 807B51895A29;
        Thu,  7 May 2020 11:50:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24DF62E041;
        Thu,  7 May 2020 11:50:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 1/9] KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
Date:   Thu,  7 May 2020 07:50:03 -0400
Message-Id: <20200507115011.494562-2-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

KVM_CAP_SET_GUEST_DEBUG should be supported for x86 however it's not declared
as supported.  My wild guess is that userspaces like QEMU are using "#ifdef
KVM_CAP_SET_GUEST_DEBUG" to check for the capability instead, but that could be
wrong because the compilation host may not be the runtime host.

The userspace might still want to keep the old "#ifdef" though to not break the
guest debug on old kernels.

Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20200505154750.126300-1-peterx@redhat.com>
[Do the same for PPC and s390. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/powerpc.c | 1 +
 arch/s390/kvm/kvm-s390.c   | 1 +
 arch/x86/kvm/x86.c         | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e15166b0a16d..ad2f172c26a6 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -521,6 +521,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5dcf9ff12828..d05bb040fd42 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -545,6 +545,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_AIS:
 	case KVM_CAP_S390_AIS_MIGRATION:
 	case KVM_CAP_S390_VCPU_RESETS:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d296e3d0d56..d786c7d27ce5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3372,6 +3372,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
-- 
2.18.2


