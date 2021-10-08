Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B35342673B
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 11:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbhJHKAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 06:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbhJHKAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 06:00:20 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DC6C061570;
        Fri,  8 Oct 2021 02:58:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kk10so7172516pjb.1;
        Fri, 08 Oct 2021 02:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=r9j8e1y3uJ+lIEwImYYJrXBxHGgDtZ3NYM0TMNrxFbA=;
        b=cyry4K/KEs9uirUsUkL7wug+KwTpCxYMrGecNeCt0QxlVLui5NkKDInhO0dmkCpDfB
         Zwb0ngiWguJBxDaCDaWY/rtKykXbbx+gLQuHRaA/g6HG0POEvdqZ7hDP2T0mMeq6Ewhb
         eZehx1ZpKnkJXLrZBbNEGWmuN/cCFbALCgtvp9dDW63JO1oVOjb81poC1BRM2L9jSgtl
         6eT3TJo5PX8njvXWlNAUjx2ob91Ogt/TgUWmexzyVd+D8R1gdSiz59Ues3X8y2kiN0BS
         ZRMRCNaNCLzFimg6jADZwK1hQpDnX64jXHPMJ6/6TwcEig8U7eDEjrkWzYXBsE5Fwl00
         mAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r9j8e1y3uJ+lIEwImYYJrXBxHGgDtZ3NYM0TMNrxFbA=;
        b=QIXxljvnACf79+VfreT5bIE2M+FQQEBpAfQ8M+EHzDPPqBNbE35Xx3EbLACTT7tNfZ
         bNOw0xSEEJ+7imBPxJwtQrP8DF28p48LlCy50usg6ifwhO3O44zvY08AZWnR4SVDQeC8
         BS/dhxv4KiAWvQnk+odLZuUzO9IIMXWym6pcxYNHDgkAJmr/2p8R1bvV04YzqEKyhzR2
         y7HuTbSkVhm8DgssM61lzFM8CgVUrOlud6IpB/zxKUaHvA+3pNFS8O8vryt7R2buovmG
         zXu5AcBGj7VMOzG22eBVn3yE6QfnyRMqxx3NGU6E/wOVnzibGe3hXPLxRjgWpcFFkoV2
         8E7g==
X-Gm-Message-State: AOAM5303shKk8voTi0AeqEWo9g9rfQIpYqGwR0+hkukD9TFWduJmjdRd
        zwA2AkN2lDq1Xft1YuLpHEApdvjT+c5Epw==
X-Google-Smtp-Source: ABdhPJx5ahU8H2UL3OF3xIRqooBLoO1q2olQTEE6gsxXVx7kLAac3xJ5LyoD4zr5xFbXT7tyFH6LPg==
X-Received: by 2002:a17:902:bd45:b0:13d:b4d1:eb39 with SMTP id b5-20020a170902bd4500b0013db4d1eb39mr8450908plx.53.1633687104832;
        Fri, 08 Oct 2021 02:58:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.googlemail.com with ESMTPSA id mu7sm2121148pjb.12.2021.10.08.02.58.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Oct 2021 02:58:24 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/3] KVM: emulate: #GP when emulating rdpmc if CR0.PE is 1
Date:   Fri,  8 Oct 2021 02:57:32 -0700
Message-Id: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM mentioned that, RDPMC: 

  IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter)) 
      THEN
          EAX := counter[31:0];
          EDX := ZeroExtend(counter[MSCB:32]);
      ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
          #GP(0); 
  FI;

Let's add the CR0.PE is 1 checking to rdpmc emulate.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9a144ca8e146..ab7ec569e8c9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
 static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 {
 	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
+	u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
 	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
 
 	/*
@@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
 		return X86EMUL_CONTINUE;
 
-	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
+	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||
 	    ctxt->ops->check_pmc(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
 
-- 
2.25.1

