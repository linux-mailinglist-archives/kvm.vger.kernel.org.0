Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5683AF858
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 00:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFUWTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhFUWTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 18:19:10 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C2CC061574
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 15:16:55 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b6-20020a05620a1266b02903b10c5cfa93so10502268qkl.13
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 15:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=14YR4j3wm+WFwCwAzU9jjWpQD0gBqyihkTkX9DHyyhQ=;
        b=c8K6T2fD39XaoC8xls+GOdYG0RILwXSl/1G3cmhiiT2Auxs/Vkp/l5IAjcRcTSgmUM
         LSBYtB27KsJIigHC33mLmByoscnHzMgz61Yx2t3gE6AiQbYk9JBKwQBPpBBiecC7bVXu
         9YWoEYmv5t005ELnt4qBL8Udwq+nonICy+RjRWUIEsmjgAJv051kkAhH91k3VzPxZt/d
         6yheeh2/QLAUgmtIApVc+5JS28JGZH8xnaIukjQHaxlsZv+HMNV9HuKr8cRpP/2PRjHd
         QyMZalm4e/Prg+DQlBXDor+ogeCEwSqTAst22ZWzrJubX0HMihnsLsUzDcntk52iXDsy
         6FGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=14YR4j3wm+WFwCwAzU9jjWpQD0gBqyihkTkX9DHyyhQ=;
        b=l0ipCUdOEqX+3l48l45QZ2Sj0++tZsyyi9o2iqprGiuwCKV6rlgr3+HlnDk1T11YAL
         mGXpc3Iq2RyLtsC6Acp9ya3d3cVleNqjqaa84JvjiQkSyNzqD0vcf0sCiNB+2pp4zX2e
         dNSwtLpJrYlt4ShZyECiKA5AbPGknIaUkNzj1jZo+CIXyxJCNSVV+1hZaxVzvlCwWL2W
         2ftwqeqEf6Lk0MK5G45sWRZZgChC23XrcPd5LZ1iRM/QNincub+GgmBOxam2lxNkV/sL
         ghOYXG3Oprw4cM1PslfJ6n9/bkmW4fReKtmRKGw/rtuFFVVESsWxq5lwsL2Irz85G2jp
         1fLA==
X-Gm-Message-State: AOAM530H/xmZfXFDObXzmckx9FCzzlvFlC8o3NBjbdGsywMEDgJesZ1w
        yQkwVlVemz6OvSCJdG2ScZLcZ6R3k8ehablmqeoXbiqbOrupmM2xsWXyCuoT3IbHSv6Fhf027TL
        kbqjvFuwPqQCI89zmbDq4y0IhyyvOC8fJZ+nBkxezoHpHw/wTuh9LEJyfSWR+5JA=
X-Google-Smtp-Source: ABdhPJx46bMfe5AFNgOJEkTtIk4R7ro7zbM42U+24A15Y4b35fy5fc4Yo7IVPY1pKW5VY4W6CdcDndxkpY3Wzg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:4805:: with SMTP id
 v5mr549117yba.4.1624313814053; Mon, 21 Jun 2021 15:16:54 -0700 (PDT)
Date:   Mon, 21 Jun 2021 15:16:48 -0700
Message-Id: <20210621221648.1833148-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH] KVM: x86: Print CPU of last attempted VM-entry when dumping VMCS/VMCB
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Failed VM-entry is often due to a faulty core. To help identify bad
cores, print the id of the last logical processor that attempted
VM-entry whenever dumping a VMCS or VMCB.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/vmx/vmx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12c06ea28f5c..af9e9db1121e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3132,6 +3132,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	pr_err("VMCB %llx, last attempted VMRUN on CPU %d\n",
+	       svm->current_vmcb->pa, vcpu->arch.last_vmentry_cpu);
 	pr_err("VMCB Control Area:\n");
 	pr_err("%-20s%04x\n", "cr_read:", control->intercepts[INTERCEPT_CR] & 0xffff);
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[INTERCEPT_CR] >> 16);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab6f682645d7..94c7375eb75c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5724,6 +5724,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
+	pr_err("VMCS %llx, last attempted VM-entry on CPU %d\n",
+	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
 	pr_err("*** Guest State ***\n");
 	pr_err("CR0: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
 	       vmcs_readl(GUEST_CR0), vmcs_readl(CR0_READ_SHADOW),
-- 
2.32.0.288.g62a8d224e6-goog

