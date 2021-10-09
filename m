Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D22F427845
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhJIJLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Oct 2021 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhJIJLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 05:11:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D6DC061570;
        Sat,  9 Oct 2021 02:09:44 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 21so1515973plo.13;
        Sat, 09 Oct 2021 02:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=M1+1Yip8GFzyYIhL8WE/3+73lyzOVhHwNfK4uPgNVUA=;
        b=TxSfJMqva34WyinV6SrFZjI5WJv0mm07cxZh6lItXh62PrHp4Bkd98w8qgxkp+rjbG
         HYRbyRgaJhwbNknvStXuWi1LiAzfeCL79jsYMS8idExfOSZuGhCWBgzxK2fEqJi3WLmS
         uwr9/WTrtCwB6tszb4RsLpi9Wq+4pwkGY9pASkRbGJiKbwMBkmT2VWa7UYSouOXDvBo4
         5wLAy4i7jN0q315/BmUWl07SWi6OO7VmVAOmuk8Mr/CmTZExrQFAulRzxCZiLvAa2xyr
         W57aXDUYj/9q3b1QXDaRGNGj1iLHftBuwujKOLkzzJP66QLIKc18VBGqlUT35xtQut3y
         0LoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M1+1Yip8GFzyYIhL8WE/3+73lyzOVhHwNfK4uPgNVUA=;
        b=cdxnXG2dFEVZ3y0hlNh/tqOzB/DEGZ/HlBGUefEPkDMQnV8H35FKw07Nxs1N+OH+xR
         xj70oe8RzzOn4jrskWM/fJ8HuTRdsVGHS3XzdqWer6qa6RAiqrOI7PhE0UTnTqoY0lFC
         OFp3y1NtYBwIZB8e4fJFQIw+RzJHTYC7zXMtKnRRH2K1kJVgpnK8LiiYcQCfKAE436N+
         0WGZfYQH2TruvJJFhnCzLtrpqLkZr5RZhnYKRDcR6AUbnmBhXVtW1Cd1d3ZmFjzPlq+R
         hjFI8w+B0mnbGQHYbyyflgTZ68P/S8dsBfnNfXGmfAZjdRtLn0GHxwGSADowZWaTHlY5
         aFkg==
X-Gm-Message-State: AOAM530g0/smLwdSuO5PNrpUyZWVzJa4v41L/kvQwwFyEnPFY2QjLGsv
        3bNazWc4h4vhMRDQ8gnxD+sqtOG5xKe7hg==
X-Google-Smtp-Source: ABdhPJyXHBkNsEKax9+c6M7O7P32Le6wJOSQyZb+99ByoVuaqqf2Uj+vgntwbdGdKhQMza9tc2lVaA==
X-Received: by 2002:a17:90a:1a06:: with SMTP id 6mr17862330pjk.150.1633770583346;
        Sat, 09 Oct 2021 02:09:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id u2sm13607217pji.30.2021.10.09.02.09.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Oct 2021 02:09:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/3] KVM: emulate: Don't inject #GP when emulating RDMPC if CR0.PE=0
Date:   Sat,  9 Oct 2021 02:08:50 -0700
Message-Id: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

DM mentioned that, RDPMC: 

  IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter)) 
      THEN
          EAX := counter[31:0];
          EDX := ZeroExtend(counter[MSCB:32]);
      ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
          #GP(0); 
  FI;

Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch description

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

