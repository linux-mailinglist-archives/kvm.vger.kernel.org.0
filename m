Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA1526256F
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 04:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIICze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 22:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIICzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 22:55:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CED5C061573;
        Tue,  8 Sep 2020 19:55:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so851952pfc.7;
        Tue, 08 Sep 2020 19:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Ci4JG02FAd7t2hb7z9AKMELCxudpUg5ze3327gd91Y=;
        b=r8CTKqpaLBY3mZnJ/X8JSZYOpbVdOwFekVGnWFHDPvuTzgk/WsWW2/kCNd5HoKbdTc
         Mi+mK41dSPl81/ufP5pX9NDTJBbzN6o4sX8hMe92WWodmj2rv27HB1WhRkR4JeBUI4aI
         qXzoCpJaaqDtEXlEhAbNU/Ft//GpoFkjI3kUHremiUZMSqdYwZs0CANPGE2aLYEIcpY5
         JZvyKomo1m4gLhOUmgVQWybpVTODU36LAZO+ohSYJVvA+UiKfjfS/qMMWcqJZR4WNCCJ
         +hgqHL463CVBGXW6G3Dc+ivsiY3FeKBUDYJ10O6b+G0J2TygF3/USssyQhfy/UUSusjQ
         0WyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Ci4JG02FAd7t2hb7z9AKMELCxudpUg5ze3327gd91Y=;
        b=DQB5GuyDprvjcHWY+A0hV2lccbrohN9bOjpmeno29FZL+Hr+moKEOkgEfW5/pnaAxK
         VtqzVEcEYC2jSfaGnZNJDB0841t7jrMgUf5ifUwRo78Y/w6KzcFvirvTy9FDZHFIZ5xm
         H7mf5LebopY8wFLPs0srRca98VdKHk+HZorLO0WnqWfWLZ9CKTaqHzIBtunqCtTgpr2+
         3wMdUB2SsjEJfvXSELQ2TaNU7Qzvom6/s9A7gQTIGki4WlP3uUOtswaA78rZhce3M7Jx
         ujqxL9nLjKjCZAscbpNXbKq4FgWaus3GAkSJ8XvHpGeibQE/GeaZ3C6A6ym8tyMkFm0X
         ntPA==
X-Gm-Message-State: AOAM530cVhu22+iC82CKQlQE0bklcoU3zxY8cZVCfJOO1pyNbFqHWZL2
        vnR2oLzweqyg2csFFnF/kL7xXMYB2+c=
X-Google-Smtp-Source: ABdhPJwDCCzOAGM0fWOQjOoswdk2GpVcipF9gMnYhUQ6AmmqJYthvTIqcsBRL1sg+DgqxUCLMH+8RQ==
X-Received: by 2002:aa7:9edb:0:b029:13e:d13d:a059 with SMTP id r27-20020aa79edb0000b029013ed13da059mr1909936pfq.31.1599620129846;
        Tue, 08 Sep 2020 19:55:29 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id a23sm523256pgv.86.2020.09.08.19.55.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:55:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: [PATCH 2/3] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
Date:   Wed,  9 Sep 2020 10:55:19 +0800
Message-Id: <1599620119-12971-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Moving svm_complete_interrupts() into svm_vcpu_run() which can align VMX 
and SVM with respect to completing interrupts.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c61bc3b..74bcf0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
 
-	svm_complete_interrupts(svm);
-
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
@@ -3530,6 +3528,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
 
+	svm_complete_interrupts(svm);
+
 	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
 }
-- 
2.7.4

