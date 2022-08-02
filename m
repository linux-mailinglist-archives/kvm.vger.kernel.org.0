Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135F85884AA
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiHBXH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiHBXH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:07:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A833FA3A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 16:07:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y20-20020a170903011400b0016f06421a83so1713295plc.12
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+GFkeGjcI/kh+1Shtb4fxwNaREiAkX51PnmuuTAQK8A=;
        b=pOA9GnOT+nlyPEzAnIBAEih/PaG2I2w7V5WKhUFU6eQ5B8Fat2GYPJqmqhXHVNcxD6
         p5gHVxB9cHa4DgK6uwW1wU7YMKq96dAGSpshNoelsEaVP8QTaC9nbRgsIuedG5zlB7tG
         FVzSMiSEhcVzUllG6do3/SuOGAgIAjcZtEyV2p0GSZ6K9IEn8eC9Zg7oKYOy14SYdaxE
         5rcFsnxepDGJs6twRR4oVInr447mpWXw7X07CRek7XK3CuZBdqxq7nFH6EACkRWmDGiA
         GfX+aIHWEONmpu/l653qLK1m6bIr3LKBn7nj6H+cyd8EQdIA/Q6pJcXe16m84E59370q
         XvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+GFkeGjcI/kh+1Shtb4fxwNaREiAkX51PnmuuTAQK8A=;
        b=xVCxUujl3pB4Jyr1Vy0CkO2ItAfr61djBXTumheJGQ3CuEpBIT/etBkzHfOTCbsj6A
         VWPjAXLuP/jBQtmu/qarPaDhPcFJbW3BmIaZEHi6aY1Dp3nd7XZIJjPT+Qpr+eLhAXLV
         5bM+iQqERS+2VHMtQku/x2Tr9L6yGbLt/mdcJ5M9KGpDP+sSGLkMn9v0hZz+ou5vkMF7
         m+dGOxmoqVCLVLiCBfY/BTNZot9CeljkZrsfKfRVvD8dsUZDyt4F8obpPtkD+mVbsu87
         d21wjQDBsps1fUGvYEKb/vKsWivv4nm+Bg340vyelnTex3tv3lsO153dCGoDhJwu9vGB
         X0Mw==
X-Gm-Message-State: ACgBeo1ZOP3NbLngR30QqK61X439SvjJiMMFe3FY3HGJ9/9I+PhXBz0x
        uakGxs6qacIEsPzYK6xbwELtiO3P0E5q
X-Google-Smtp-Source: AA6agR7baxuoDiumlwxT8og4KDOAqwSDO43YIdTmYpk4I7uSGbhlRnMu5fP0gocL3tClU2CNLVv8GL0cxZwz
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90b:3e84:b0:1f0:3f92:8c91 with SMTP id
 rj4-20020a17090b3e8400b001f03f928c91mr1904559pjb.112.1659481646348; Tue, 02
 Aug 2022 16:07:26 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  2 Aug 2022 23:07:16 +0000
In-Reply-To: <20220802230718.1891356-1-mizhang@google.com>
Message-Id: <20220802230718.1891356-4-mizhang@google.com>
Mime-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 3/5] selftests: KVM: Introduce vcpu_run_interruptable()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Introduce vcpu_run_interruptable() to allow selftests execute their own
code when a vcpu is kicked out of KVM_RUN on receiving a POSIX signal.

This function gives selftests the flexibility to execute their own logic
especially when a vCPU is halted. Note that vcpu_run_complete_io() almost
achieves the same effect. However, it explicitly disallows the case of
returning to caller when errno is EINTR.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c          | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index ac883b8eab57..cfb91c63d8c3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -398,6 +398,8 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 	return __vcpu_ioctl(vcpu, KVM_RUN, NULL);
 }
 
+int vcpu_run_interruptable(struct kvm_vcpu *vcpu);
+
 void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..aca418ce4e8c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1406,6 +1406,17 @@ void vm_create_irqchip(struct kvm_vm *vm)
 	vm->has_irqchip = true;
 }
 
+int vcpu_run_interruptable(struct kvm_vcpu *vcpu)
+{
+	int rc;
+
+	rc = __vcpu_run(vcpu);
+
+	vcpu->run->immediate_exit = 0;
+
+	return rc;
+}
+
 int _vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int rc;
-- 
2.37.1.455.g008518b4e5-goog

