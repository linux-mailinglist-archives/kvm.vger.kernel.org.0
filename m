Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1B7367C9A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhDVIfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhDVIfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 04:35:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B334BC06174A;
        Thu, 22 Apr 2021 01:34:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nk8so7740493pjb.3;
        Thu, 22 Apr 2021 01:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XPeASqzaMJ7Yo0kPhHuSWWnsg8QRwXioVRRRxxovsUM=;
        b=Yi05U8POcqAcJG1vqL+nMp1O7giLcji3FL66Zwkwr+j7LVAiJwHKC8v/WiGpB04nmy
         VgpUEK3CcRW8E7RBuZRWYADruImVGY5v8+V/mQvhHlV4FJJBzrmfMl8CcpC11C6OEEet
         sm6LnWUFDsJB1Cs7X3spzpVCzTdQB3UQxhgJnDfD/kr9fm8uNWYjhPFC3RXv+JteXd5d
         WUJcZNtUjxTiuxfoMMG2E4INMil/QWh1q3wFV1JPg/eazNh3xm7hNudh4/asuYguoznf
         I+Ieq/oca20j681cEv5NdE62Y8zFSyBU7oxR+CQJmCAQnimeCQ0xMQqWML4JdUkkFB4v
         nL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XPeASqzaMJ7Yo0kPhHuSWWnsg8QRwXioVRRRxxovsUM=;
        b=W6KnPoxky2/PVgdJufSqhZQb+YgxvAJDtKD07dKKZQLlKe6F0JeK76j+WQogVQbsno
         zZ630OrjJMW1sR77xMgUYZaukqpR+qo/ctUcX9IF7Hx2dtKrOV/fcvbDpMuWFNymmFBN
         yOL7kEu2+Wh1PQne3W5mW+smqgfZSFKW5yUlBTnsWc99wBLBZXY5ZXvfkN1j6QUx3hw+
         tCyHGvUTtxuiAq+cFMiaPUxnue+YbjzKsK5gNqlSa6LlK+iKJxoWx6Oe/pD63gpFhJv0
         CRGUcXnzUCIuLKDWBMbQB9BulX8vwKXeYN5eqh31AsSOF4zX5N74oYz0VgAhVfDaMaVe
         +aWA==
X-Gm-Message-State: AOAM5316NpeY0ElNavSi9Wex6ORPAhODTcffe+WDl9cCROpbDN5IMzWe
        KgAl6J5rERD3PtXok3P44I+O9DbpELY=
X-Google-Smtp-Source: ABdhPJxvaOlO/fw+TXx7l4G7hUQJopQWzgDQMY+xZBAllPOdu44N1Qmff7QYS79eHap77JHljdrscw==
X-Received: by 2002:a17:902:7203:b029:e6:a8b1:8d37 with SMTP id ba3-20020a1709027203b02900e6a8b18d37mr2569664plb.44.1619080472080;
        Thu, 22 Apr 2021 01:34:32 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id a20sm1445908pfn.23.2021.04.22.01.34.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 01:34:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Fix always skip to boost kernel lock holder candidate for SEV-ES guests
Date:   Thu, 22 Apr 2021 16:34:19 +0800
Message-Id: <1619080459-30032-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under 
SEV-ES") prevents hypervisor accesses guest register state when the guest is 
running under SEV-ES. The initial value of vcpu->arch.guest_state_protected
is false, it will not be updated in preemption notifiers after this commit which 
means that the kernel spinlock lock holder will always be skipped to boost. Let's 
fix it by always treating preempted is in the guest kernel mode, false positive 
is better than skip completely.

Fixes: f1c6366e3043 (KVM: SVM: Add required changes to support intercepts under SEV-ES)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d696a9f..e52ca09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11151,6 +11151,9 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.guest_state_protected)
+		return true;
+
 	return vcpu->arch.preempted_in_kernel;
 }
 
-- 
2.7.4

