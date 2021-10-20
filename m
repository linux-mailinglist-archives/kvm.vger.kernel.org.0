Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB994348C2
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTKRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTKRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 06:17:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C4C06161C;
        Wed, 20 Oct 2021 03:14:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id np13so2118972pjb.4;
        Wed, 20 Oct 2021 03:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=kwhgTQM7yJPqYSZytxRhjSzhbEEhPX7aZJHqv9N3EnM=;
        b=mKlSDrWkaMBgDhNoMtyQvQ402sSzlosG74BkTOq+si0LQwmESj0dmcnFTdHYdKJm8f
         qa1N9NwSOTns+q2m/BYvG1v9OZyR5E8210hsJYIX4+Uy4LOhJgYXSjM9vtWuep8Fcx+N
         CBNzyQe2Obr5uvOjBMuSofZ5YABEILj0M89FJYCspmzsNQYuLby8iBwC/xFc7ifR+iV6
         DvcuT6i9/zAurfK0ru0jVscumLYPWL+kcdAcGpHbukBgy72VLzl3h6MvmXrXxsMIJYOT
         e7h/pOH01AXNS3SPUn8lSgIS3ZMUh5nP5763CJc5dcghr5ThBQ0UZH+cYnJ7AWEyYIGK
         HXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kwhgTQM7yJPqYSZytxRhjSzhbEEhPX7aZJHqv9N3EnM=;
        b=1cylSS0dg/bvKT+2Z3GJzGQ4bV6m3BXhYKVQtOkh3vCwcFv9Iexbzyp4ATElc66ESp
         Pm6GudvHpzWbcnU/kku5yOUWwuOF46dhJ8pYfVpwWhsHw9vvxjpBGSlLWfWCDzbdyXa1
         +t6k0vQJJtA2C1TzN/0AObGs25oc5Z1EH7zSfMImsdNeELiv6n6tmqpQOrFkeCCqLBxI
         pj0Fzai9C85889Uh4BWuSJtqSOXly7fpMmJlCBcYZbiYakM2l1qwcNrWQouRIZD7CTwX
         pPx2rv/rc5jZuXAHxq50sVBiZiicn+7k938GBtKhRlxxbscOoxMfG/WAu4QG4R7ciIVq
         oHbg==
X-Gm-Message-State: AOAM533XgiEN625KvaZ9LrFv/PZ8PBkyvypvVxSpHF6Cr/DfzzAx5aKD
        Hv4FXH72dMpOQCVWvZcaypWmwfKEATaCZQ==
X-Google-Smtp-Source: ABdhPJx+eqvLlSJuWiU/yf3YCYGMkodBNE6HENsOdJozwRx2RsZCR4Fc5Q6fXay8W1lUKbKPAQGF9w==
X-Received: by 2002:a17:90a:5d89:: with SMTP id t9mr6088497pji.21.1634724886709;
        Wed, 20 Oct 2021 03:14:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.googlemail.com with ESMTPSA id y3sm1770692pge.44.2021.10.20.03.14.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:14:46 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v5] KVM: emulate: Don't inject #GP when emulating RDMPC if CR0.PE=0
Date:   Wed, 20 Oct 2021 03:13:56 -0700
Message-Id: <1634724836-73721-1-git-send-email-wanpengli@tencent.com>
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

Let's add a comment why CR0.PE isn't tested since it's impossible for CPL to be >0 if 
CR0.PE=0.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v4 -> v5:
 * just comments
v3 -> v4:
 * add comments instead of pseudocode
v2 -> v3:
 * add the missing 'S'
v1 -> v2:
 * update patch description

 arch/x86/kvm/emulate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9a144ca8e146..c289809beea3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4222,6 +4222,9 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
 		return X86EMUL_CONTINUE;
 
+	/*
+	 * It's impossible for CPL to be >0 if CR0.PE=0.
+	 */
 	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
 	    ctxt->ops->check_pmc(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
-- 
2.25.1

