Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E3558551D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiG2Sqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 14:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbiG2Sqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 14:46:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4F065821
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:50 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id l24so4236181ion.13
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u9UDEya58Yn4eaL4Ab+cCmUC7ZdMS6RpOm/buj/Q9kM=;
        b=LiPSLwJZL5dU61oddu6kmisyqSQRKJ61a+GXtpwW5q1wMCl9/YovV5FcE0XLWrrcDT
         iZ2j88B/wbooCWgqtsgK83DOJOFY4gN8kCJ/C3SwcQp9xpaH9J3gq+TfXAWUEtcB8yv3
         nO4KoydFqc1vNjRcFNP48x7Wh2l6mMY4qgFNH7uX9zCJPyd6jbOky6sL1yiKNwk6bakC
         TsZamQeqAizxF6HByHeGVd1YKYZ2xSuZ5WrR0rkFYcVRhqpzU+g+w1TAzQwBrX7BMjpX
         aLXrfBmzurxiqnBNI2zLYSK9y0MoKc4lKhAHDX6Bxvn2vxpmyeMw1Q+KYgIdpItrkik9
         HFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u9UDEya58Yn4eaL4Ab+cCmUC7ZdMS6RpOm/buj/Q9kM=;
        b=3s1Msjgc1qsvWwwhc2hQh1twBIhwh3HZoae6YnoQzEncYVzDGsPbi8hU8KCv+ZRgHH
         4N0+vG72h/6zN/vsiDmSq4VAPNybHzcLg0hiT/oNslK8+Ts6IPRVkryaZNqUhw6H6bv9
         SSGe0XhsAJV4ibwpB5yI32V0IbQZvaY0J6sM+ft73e62P/pQ1sa+t2ZnAidaKaGsWWdp
         WBD6eFQFaLPTtQ1JNbF+kuOUwKMxsnyqVCy5w7WaL5LYyDFKQWRVuKvUaMZ3r5ng+BlA
         C2nEYcdZwlqWozVMByQjLbW+JUyUPfXD8bAUWWxBNBI2H1BgEPtrw0ZSnhIaMRzia0ka
         RlDA==
X-Gm-Message-State: AJIora/znEYLT0XyGx42EBErib2Amtluv0pyN0RZ1IPlv4Z4J24qVSnW
        qOiQP3ehi7hxXl8Yn/Sx1vUC+g==
X-Google-Smtp-Source: AGRyM1t8c8mcZk2k+Inli2l2P+kqzB6u5o9yb+NDRDNwfhnQ7nvRPfZ+WiCwtTOLu/HspYyoERLtVQ==
X-Received: by 2002:a05:6638:238f:b0:33f:774f:5252 with SMTP id q15-20020a056638238f00b0033f774f5252mr1888123jat.216.1659120409992;
        Fri, 29 Jul 2022 11:46:49 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id l21-20020a0566380d9500b00339e2f0a9bfsm1973517jaj.13.2022.07.29.11.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 11:46:49 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     kvm@vger.kernel.org
Cc:     Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] KVM: x86/xen: Stop Xen timer before changing the IRQ vector
Date:   Fri, 29 Jul 2022 13:46:40 -0500
Message-Id: <20220729184640.244969-3-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729184640.244969-1-dietschc@csp.edu>
References: <20220729184640.244969-1-dietschc@csp.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves the stop xen timer call outside of the previously unreachable
if else statement as well as making sure that the timer is stopped first
before changing IRQ vector. Code was streamlined a bit also.

This was contributing to the ODEBUG bug in kvm_xen_vcpu_set_attr crash that
was discovered by syzbot.

ODEBUG: init active (active state 0)
object type: hrtimer hint: xen_timer_callbac0
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Call Trace:
__debug_object_init
debug_hrtimer_init
debug_init
hrtimer_init
kvm_xen_init_timer
kvm_xen_vcpu_set_attr
kvm_arch_vcpu_ioctl
kvm_vcpu_ioctl
vfs_ioctl

Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
---
 arch/x86/kvm/xen.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2dd0f72a62f2..f612fac0e379 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -707,27 +707,26 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
-		if (data->u.timer.port) {
-			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
-				r = -EINVAL;
-				break;
-			}
-			vcpu->arch.xen.timer_virq = data->u.timer.port;
-
-			/* Check for existing timer */
-			if (!vcpu->arch.xen.timer.function)
-				kvm_xen_init_timer(vcpu);
-
-			/* Restart the timer if it's set */
-			if (data->u.timer.expires_ns)
-				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
-						    data->u.timer.expires_ns -
-						    get_kvmclock_ns(vcpu->kvm));
-		} else if (kvm_xen_timer_enabled(vcpu)) {
-			kvm_xen_stop_timer(vcpu);
-			vcpu->arch.xen.timer_virq = 0;
+		if (data->u.timer.port &&
+		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
+			r = -EINVAL;
+			break;
 		}
 
+		/* Check for existing timer */
+		if (!vcpu->arch.xen.timer.function)
+			kvm_xen_init_timer(vcpu);
+
+		/* Stop the timer (if it's running) before changing the vector */
+		kvm_xen_stop_timer(vcpu);
+		vcpu->arch.xen.timer_virq = data->u.timer.port;
+
+		/* Restart the timer if it's set */
+		if (data->u.timer.port && data->u.timer.expires_ns)
+			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
+					    data->u.timer.expires_ns -
+					    get_kvmclock_ns(vcpu->kvm));
+
 		r = 0;
 		break;
 
-- 
2.34.1

