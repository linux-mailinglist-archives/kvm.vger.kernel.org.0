Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37458551A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 20:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbiG2Sqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 14:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2Sqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 14:46:49 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906005A8A0
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:48 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y13so2840682ilv.5
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=n9k2YMAlV+e8e432QUJ2PyPKup021wpFALKoUT5LbfA=;
        b=t8xemHbMEOFF8aIZYKKQUu/GtHy43f3Fqg86S8UanB4LEb84lG9couq0EXyiscKOfM
         vCmBKRhkZZtyGzmbMzuTeGjkAFGdp7rbh9+8ds5DjoILSUOTJGi6YLs1sNpGuZzbUEZH
         10iSC8S7U1sRfpantRGB8LOKZN+UfLRp+uJHFQo0q7uiaN5bWWZooFq+yCWCmv31FnDm
         v7teJTYMhnqt81hUFBaVeJ2NurQ6NaDdiQF5Hl/oHKELjczbj7Odbf59Om4/wVI7kheC
         eHxwbTXv3982ju0Rm16EYWrRG4XfUdqDanShbkp9Li0zMPdkSh9WLWyx/8scNJsMnA5V
         NcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=n9k2YMAlV+e8e432QUJ2PyPKup021wpFALKoUT5LbfA=;
        b=qxCHr7Vp92anlBmCzKM0DvZ5GqEC27vG3NXWbpduUJHz6e3DFfdi9+sppFqN5ugc5e
         drWMwPMqp9YfzqGdcKVQyyNcUWydImZPtdf7uQxUNSLtEJQ5rL7BVT1QajuHBDHBe33a
         IeLWjprB8T0+AoU0bAR6koJf4+ZPuWuE+mSfZGakK/WfDKOfUseS4b2KO8BjstV7EsWD
         vbw7o9tNIbKuj2lowKHsK387MsF9J+RxVjxWKmzJR572rHbFjNY3jfkxQDSBR1EdZhz8
         C7V3Q6ezghHNPXDUeNVZg9Bu/F+uAe/Kd9hY+SKimBGAYEoRH6Ak123MxRmzE2DKpKlc
         uzkw==
X-Gm-Message-State: AJIora/IoXu3nlKzE/liYCWYYIZZvSXzxtLcOagdV7swcSbH5lenmpuW
        v+3LJ4HLGlySWW2OcLC+kSr+5A==
X-Google-Smtp-Source: AGRyM1tMybxHnE1PTpdbKjHoSc/38FzbC7CdYsABqDMQN8d/mR8rV/1QXfGZp0Nt9aj937GQq6ocFg==
X-Received: by 2002:a05:6e02:160a:b0:2dc:12db:121 with SMTP id t10-20020a056e02160a00b002dc12db0121mr2026813ilu.117.1659120407979;
        Fri, 29 Jul 2022 11:46:47 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id f24-20020a02a118000000b0033f7d500749sm1949399jag.128.2022.07.29.11.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 11:46:47 -0700 (PDT)
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
Subject: [PATCH v2 1/2] KVM: x86/xen: Initialize Xen timer only once
Date:   Fri, 29 Jul 2022 13:46:39 -0500
Message-Id: <20220729184640.244969-2-dietschc@csp.edu>
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

Add a check for existing xen timers before initializing a new one.

Currently kvm_xen_init_timer() is called on every
KVM_XEN_VCPU_ATTR_TYPE_TIMER, which is causing the following ODEBUG
crash when vcpu->arch.xen.timer is already set.

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
 arch/x86/kvm/xen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 610beba35907..2dd0f72a62f2 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -713,7 +713,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 				break;
 			}
 			vcpu->arch.xen.timer_virq = data->u.timer.port;
-			kvm_xen_init_timer(vcpu);
+
+			/* Check for existing timer */
+			if (!vcpu->arch.xen.timer.function)
+				kvm_xen_init_timer(vcpu);
 
 			/* Restart the timer if it's set */
 			if (data->u.timer.expires_ns)
-- 
2.34.1

