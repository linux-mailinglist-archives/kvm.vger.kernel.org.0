Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B759575D57C
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjGUUTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjGUUTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D307B3A86
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a7735231so12725575ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970758; x=1690575558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xl/21nVHjxj9H71udXldkW3KRDjTiiyAWxQB92FBmLk=;
        b=Z9kjVXVGPt914xe9fLgGWQ7njz6z0IpDO/S9kHemlYQXnKLvSITcv91xTIWcVJtv4m
         CbGJMGVWN0Jx7yI0SSDzh5WgyereyRUc/tEyDpGT6MLizJYYxihqtQBSefCIu/1aboBj
         0pFG/ifvnhuy1V3QTj222F9L3dkjAm/fM+mZ5LvJsm2PGxEdi2yFpOUZ6DMSDNxMm4DI
         o/VS8q8UCReLs1GvOJfJFGFkGBUim2JZRxl8RuCfyBdOzDRbkrsJk1z5x/ZIP4GwZ4+o
         3wsH96lRHH20QOA7RyxWEHtNxRZlo33VGObc3zEeEV5ho06ifM+g9OcDd0QadVn+P/E+
         TuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970758; x=1690575558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xl/21nVHjxj9H71udXldkW3KRDjTiiyAWxQB92FBmLk=;
        b=GdqQmUrD5uCX5f8kANkvM2axTlq/3EjUc9yasLZz1JbSrNraN7xkmggQKl4fF5b7py
         yxqDQb/G/Dq7fBA3O9cPR4Nf/QqGEmjQ2ytrFqf2cBj3UOK1fidfoj7ynXqlhud6+EUB
         qmpate973ThB4Iuq5eVW2tvqzpnz7QksBCEwe2EafCqkwNKigvpOKUw9iCJgWT5QfVeT
         cjTLIJRv2T98eFBT+1dO2H7LsXtEkiXDFMBqv2O5hbZgG1hpLmaUdim0t2Z1yzTYRSKd
         HSZvQQ14Q6JxvPFo6/aBN96oHS2JDRXI331lrUF2Wz6pDJvI3o+JtYQcTAJhXcV12E2f
         kwiA==
X-Gm-Message-State: ABy/qLZwJ4oFCmTVDonHQ3hvWINj+72JxK8XLqJecDNOfyuOF+cPSv4k
        riu6oedaBuTEgdDB8gaPkTvi0I74IRA=
X-Google-Smtp-Source: APBJJlEzwu5ChQyLGT+FTc9q1c52pU5AreTLyPoJzZDa1ixxgiv0ygl5+KZatUpkRn4shtsG7YxA8qtZsN8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc1:b0:1b8:95fc:d0f with SMTP id
 a1-20020a170902ecc100b001b895fc0d0fmr13723plh.7.1689970758296; Fri, 21 Jul
 2023 13:19:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:47 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-8-seanjc@google.com>
Subject: [PATCH v4 07/19] x86/reboot: Disable virtualization during reboot iff
 callback is registered
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attempt to disable virtualization during an emergency reboot if and only
if there is a registered virt callback, i.e. iff a hypervisor (KVM) is
active.  If there's no active hypervisor, then the CPU can't be operating
with VMX or SVM enabled (barring an egregious bug).

Checking for a valid callback instead of simply for SVM or VMX support
can also eliminates spurious NMIs by avoiding the unecessary call to
nmi_shootdown_cpus_on_restart().

Note, IRQs are disabled, which prevents KVM from coming along and
enabling virtualization after the fact.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 85cb2dfcb67b..98e5db3fd7f4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -22,7 +22,6 @@
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 #include <asm/pci_x86.h>
-#include <asm/virtext.h>
 #include <asm/cpu.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
@@ -589,7 +588,7 @@ static void emergency_reboot_disable_virtualization(void)
 	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
 	 * other CPUs may have virtualization enabled.
 	 */
-	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
+	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
 		/* Safely force _this_ CPU out of VMX/SVM operation. */
 		cpu_emergency_disable_virtualization();
 
-- 
2.41.0.487.g6d72f3e995-goog

