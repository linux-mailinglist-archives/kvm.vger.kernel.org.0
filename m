Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF16563848
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiGAQux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGAQux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:50:53 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D5D3ED20
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:50:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j5-20020a170902da8500b0016b90578019so1655429plx.5
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jiCbfvBKJiHEBlhpaNZGJF4HgSeCbeiVR31YCzi16jI=;
        b=jCtTNYHwSgzz1NowKJ5IEgRPVBNFutMo51n4JUE+pFkEFVKaKLN5IbmWCJCvxXwOkX
         2ElO6d+BOPrf3nAQmBznyQHZGKFWB3CVARiF9yAO559PE485r3u2Dp8t4zoo+Q/WQSdJ
         3UQRufrmsr69RU3r7X7obEoH2C/Fl4Ri8xEGRgtxz1FRD0kVqexL0+T3aLSlqXAd7UVw
         FzSkdqZVEL70tCCQO5vMoRmOGEqu2E3T4TcC3efPfdMVZIIs01DLLL4GEu+VfgqeB3V3
         xWP9esZOKT22sWoPNRCDC0WjFpxO0RZ78x9SIXFRPfquCzNu7gwa1vni0oftsVI4OgNk
         FiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jiCbfvBKJiHEBlhpaNZGJF4HgSeCbeiVR31YCzi16jI=;
        b=3a2WVfSu9SpD+XhPxeC9mvMlHEsCvThpbdFeUUQHPFYov0rhBpMkuaKblE/FqMyk+P
         T8hYX/OIZbbAhTiKt+DnPkclJj7q3StgKHoQjYG8UDjALsdq9JljxuuOCSXYNGNVYgIm
         e2lgMqSG//m7MqfmovOi6KimRnamrJGpmkTT1aWRWN4OF5l2Kp0aKkoOf1+3Cos6DuuM
         KuhX8SNLINrS1y/YZZMtN79zjeNyGVIgFjQeXTJUW2dvGyuRqRudcGjxacjBQIeIE0Xm
         419pAqp4XzdH4TvlGj3Io2poaS9G9kBHKwk8iEPW3dA5DQS/r1vPrOQiAXM4db+Oh2xc
         4s8g==
X-Gm-Message-State: AJIora+53iHJ97SO4mLs8TDl5pEE20iShhbIbQIOQoTyUAhsKwU9dLwO
        OuaUe1E45IN4Wao3x2IfoGgVrdyI
X-Google-Smtp-Source: AGRyM1u7m4XrfjDCZ74m2pBz9xr/zDLFcbOI3IJRU0JefiEXZXjPidifknjGF60DpJeX2tSmC9httumR
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:7200:c2cb:2999:20c])
 (user=juew job=sendgmr) by 2002:a05:6a00:22d6:b0:525:74b3:d020 with SMTP id
 f22-20020a056a0022d600b0052574b3d020mr20664091pfj.80.1656694251211; Fri, 01
 Jul 2022 09:50:51 -0700 (PDT)
Date:   Fri,  1 Jul 2022 09:50:44 -0700
Message-Id: <20220701165045.4074471-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 1/2] KVM: x86: Initialize nr_lvt_entries to a proper default value
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the default value of nr_lvt_entries to KVM_APIC_MAX_NR_LVT_ENTRIES-1
to address the cases when KVM_X86_SETUP_MCE is not called.

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8537b66cc646..257366b8e3ae 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2524,6 +2524,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
+	apic->nr_lvt_entries = KVM_APIC_MAX_NR_LVT_ENTRIES - 1;
 	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
-- 
2.37.0.rc0.161.g10f37bed90-goog

