Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE8F65F8C2
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbjAFBNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjAFBN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:29 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BC471FF5
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:28 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id h2-20020a170902f54200b0018e56572a4eso128401plf.9
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vMUnRQfVbAJv33RqxFDNJJJTw+ranbI7U0SAs08XATU=;
        b=G0S4DPyFrd2Oopyroqh9Cz+8c5WqAKldFy75kkimMEIxV5yGuhY63/jc5SSl8Gm6ow
         h5k5dfPgQ6cySfnnFTdy3suRsCkubzhnft2Qb4DNgZ1K1z0/K4m86z1Olk1zTNEn+vcb
         Vvlp7boDP/jU4GYiHSbAB3/mC9kpQZp+L4sF80R2yV45vQnY3+3593a/0icBu71baSWr
         d2cGicwM/cN95qmenJDi+9o+Y3+/tOjD9WduMIyXiwssF32BUmqVMegBR+dcwcb7po3U
         7ZqHfbVAX+YJKOPNoAaqKvi7dAO1uVxczzvvi+hh2CIBiLRoQ6u1fALpCpM1WolSrWs9
         1Ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMUnRQfVbAJv33RqxFDNJJJTw+ranbI7U0SAs08XATU=;
        b=PT8vTGbem4gITXo40Ub0dSrCiVitJk2pF9QU62o2AuUnXiTKpdg/Y/iEOnGTV4ix/3
         RzuCKG1yjbOgNqdMmD1bwVc1ize2i/NnflTooBLoXsBsFJ/bHPi0JG4GvFuavsSSWICH
         0QdNs7tAc3Ja5PODEFWtXf8VXO5tRBQH4MzyJFiudpqT0mfiRdpc4+WwIgYSZS7Z/FAs
         CEPiJpu4lCFuLxa1nHXvTUWlp889B6x+K/CzTWem8LVLIYDc4stZJFgF4tmwQ9mMm2lQ
         NbvBYl4QlGEqzjUyBxHJR7ik26NCXITQ/W2muePCNecyrzpCgWOov4ZYbqfTQJaPz3bF
         rmmg==
X-Gm-Message-State: AFqh2kq8vL8YCDsQfEQFBr+HnlB5iJOf3lpL6aAoxtdupW8LbiUP6r5z
        QXTzyVVMfyc6FjER4TZOE9oUrUroNbs=
X-Google-Smtp-Source: AMrXdXuudHup8qpImaQf0/5abeg0Y+xEfxUzUer6fZO+gAvhbkcBPXjm11rIZkOPqnYsqI6yl/Ume75/0NA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2451:b0:580:9b0b:4fde with SMTP id
 d17-20020a056a00245100b005809b0b4fdemr3392591pfj.49.1672967608513; Thu, 05
 Jan 2023 17:13:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:41 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-9-seanjc@google.com>
Subject: [PATCH v5 08/33] KVM: x86: Handle APICv updates for APIC "mode"
 changes via request
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2183a9b8efa5..3ed74ad60516 100644
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
2.39.0.314.g84b9a713c41-goog

