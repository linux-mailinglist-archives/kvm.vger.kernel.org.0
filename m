Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3545E5F17C7
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiJABAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiJABAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EC22BC7
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z16-20020a17090a015000b00205e74e7402so3389497pje.8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=0E11MpL6SGTty3WKUuaZinB/c2Ize2TmmIc0ubmGHxI=;
        b=QgihTGnwFiYnFKRuH+UiepjpjJg4APHcd1IGU17rqdVZSYwxxTkSk2beb1FwD6KrGK
         JubLFWX96s+DzWJ8mRm2AVVniuBn7ZekEBnyDiN3TvLDmDXYaEYFagtTjqvVaW/WrmUF
         kZRYCPx2+/qIDiEgT4wgjMqrsKJzBFpJAfNTRY4Fy0BI1VNy090DPOBuSJ2I+3+SdIlY
         dqmcpYSEx3xRFwZq0S2Tfnc0i4jw97xMt6dnnbdh+TUnS9BlPLkE4SY2YaRm1r8Fu6Rt
         0fZvjwEJxn6b1gloDMaJHyZYdqnobIGmBeOrHL5wICGMzOYu1bEAk46rPmq7zSv/XbXQ
         aWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=0E11MpL6SGTty3WKUuaZinB/c2Ize2TmmIc0ubmGHxI=;
        b=UFm+bjXPmYIoEaOh5BorXOZWlsjk+5IuW55Mhnn7jTkg3lMDs8d6X1PZxzx8YOrr5g
         TAqKStWcwdmCw9TQ5yMlz54RMDDaOH2Ck0gUgwmeLaJ/DwfHEq695hwZc+nkoJ5kF0Ay
         KX3Q973rMJuJZVPQm8V/SP+z3vlOWLBtbwxDoVEe8mZJqeOhP8HBJhq9dHiSH7kxQq1s
         3HoztY+o4hx2RL1NFeXEbwcIjVv5kHs2oMYgDS1pQtvZAGwYo0Q27Lr3zS50vxsLdQnN
         QVMZuYkJgunA9qXzWgOrqsPTrw+7MouofXUjIo5iI78a+vk+W0jbhfiNpo9r+XmYKLrs
         o/Ig==
X-Gm-Message-State: ACrzQf1qGD2b+nqaYv0ZGCtD9VPtL4gjZnwf/+RBqe4kGkAnPmRP+R92
        1Bh29sxqPvq50tu7mRunTXhBou2zTps=
X-Google-Smtp-Source: AMsMyM5xd4LpP4RpJnL1ZlZz+D8f72c6fcZYgwlUZ+UVAQHly5Xs2TUx4gtmjHL6k4DVTKF3UcUTTpr0qeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1684:0:b0:554:cade:6970 with SMTP id
 126-20020a621684000000b00554cade6970mr11617488pfw.11.1664585973738; Fri, 30
 Sep 2022 17:59:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:52 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-10-seanjc@google.com>
Subject: [PATCH v4 09/32] KVM: x86: Handle APICv updates for APIC "mode"
 changes via request
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM_REQ_UPDATE_APICV to react to APIC "mode" changes, i.e. to handle
the APIC being hardware enabled/disabled and/or x2APIC being toggled.
There is no need to immediately update APICv state, the only requirement
is that APICv be updating prior to the next VM-Enter.

Making a request will allow piggybacking KVM_REQ_UPDATE_APICV to "inhibit"
the APICv memslot when x2APIC is enabled.  Doing that directly from
kvm_lapic_set_base() isn't feasible as KVM's SRCU must not be held when
modifying memslots (to avoid deadlock), and may or may not be held when
kvm_lapic_set_base() is called, i.e. KVM can't do the right thing without
tracking that is rightly buried behind CONFIG_PROVE_RCU=y.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2503f162eb95..316b61b56cca 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2401,7 +2401,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
-		kvm_vcpu_update_apicv(vcpu);
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
 	}
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

