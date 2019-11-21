Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA2210546B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKUO3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:29:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33540 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfKUO3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:29:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so4714810wrr.0;
        Thu, 21 Nov 2019 06:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Uhe0Kiej1ea14TSjH1b0KQtAZR+V5aq929XhPTnEBZY=;
        b=XmX+M2GobM70kadqAmo9GOL17ztsH0GKJ5KTHDFedGV61V2IUJdyokp+KxbRsg2GeU
         DJ1fVP8goSFoZw2bUx+jeFX9Vfmgt/G7SEsUb5pBsifz9ugl77e6an8znqwXjOaDtlO6
         +r6iiWlNslbq//tbT/Htm2a8l7+bU+drRu156E2BrQWVDgSQ5ceHwA89BnwyQuNC+kSH
         r+gse+qnBhvQp5AaWbNhxILJdaQoumTGqyEZrcK0OKC0m8IgUJTE9DTTWFwhOLbAYPXD
         /FAoBMVBKseLxwg6tS897YWkyq2KAUoNEg3kyJwct+pCjlG/s4SDanqeHYIomgG7APHN
         qrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Uhe0Kiej1ea14TSjH1b0KQtAZR+V5aq929XhPTnEBZY=;
        b=Aap2lZtw5OGLMVKFzmRhS5Whc9i8rkfszs84/4Vd3hyJH1/wNpLq0YiO7FVB8iRixW
         m8jGpkEgdShLi/3v3MbsagMfwvKLQq1ilSS9/uuBueL7wtZ696B3MmyRR337bNpP0Qjg
         qZIN03yU3USzENAA2TSwc05hLCB6PTMwqxA9YXH8Z4Ul2hXlkCANgzq5jl9Jz7HzNEaA
         BHeMaKo9KXHwVg65G6Uidp3ImAc/jjo5NT1OMg8/ZIJJnJ5G9aAjbciJzbVHBwui0ElV
         N3KoWyMQRPfxR1fdnA1wn5JDgKUY0i9GeKf1kSN0pqDRh2vtsDCZhaNav3IniryXsVYE
         3lbQ==
X-Gm-Message-State: APjAAAX6JzkZ7AKBflnSPO99pPcArO01pT56Li/YgayAEGjb1NE0jsWQ
        czVycE+SWEoJoCVfTKGPM9CjfPdw
X-Google-Smtp-Source: APXvYqzE1Zl12m5/a5jql/gn02/XLRwp+3vetVbJpXY7FMZ8c6BKw9yg6j3FfBzLYAWx9MvZqqnyBg==
X-Received: by 2002:a5d:5224:: with SMTP id i4mr11101374wra.303.1574346559451;
        Thu, 21 Nov 2019 06:29:19 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b15sm3408693wrx.77.2019.11.21.06.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 06:29:18 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>
Subject: [PATCH] KVM: nVMX: expose "load IA32_PERF_GLOBAL_CTRL" controls
Date:   Thu, 21 Nov 2019 15:29:17 +0100
Message-Id: <1574346557-18344-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These controls were added by the recent commit 03a8871add95 ("KVM:
nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control",
2019-11-13), so we should advertise them to userspace from
KVM_GET_MSR_FEATURE_INDEX_LIST, as well.

Cc: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..4b4ce6a804ff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5982,6 +5982,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
+		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
@@ -6001,6 +6002,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 		VM_ENTRY_LOAD_IA32_PAT;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
-- 
1.8.3.1

