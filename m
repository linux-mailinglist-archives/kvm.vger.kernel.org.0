Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77A34F75F
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 05:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhCaDUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 23:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhCaDTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 23:19:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1820AC06175F
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k189so773577ybb.17
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3Xa1OKEIcZ5edRwAMZLibB+Ad1pcD0ADTTrJiSO76FU=;
        b=U0dDAMw5AWHxlOqCtiXJpoymuGVxzLFXL1A4mlfI9uLaMbLLGk45tLAgKX1qjOccmR
         cTevpLRzVJqNmfwPQFzh9m2DRDgvyV3sxKLBL7DGw0tBxNZU1FmmCrBGRaxm+XeF9GhC
         Hwe2L+EpDVfyH3o2QCwSMd12qVhUUklccyj9paEDibFrU+0bp42pkhunV4PyqQJqGCCY
         lDKuGej38L4ReQUgV+4kMcPpL8C5+/EMh7xgg98CsQBhDcKL9WWhhvb8H9cbfufK/VfC
         IkdR/BrdtTxnTKbkHjjcbWTKDtDWNRmft5OnlBUgBnLeNFPVsA6t6+1wUWKw4E/Jv7Wj
         rXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3Xa1OKEIcZ5edRwAMZLibB+Ad1pcD0ADTTrJiSO76FU=;
        b=b1UGm8QkQi0YZxyMQntZ2d8rVu+eQD9zB5DItho1m1MrxIwkTpFfipOujvGPA9gaKW
         eh09m2vBF954YolROVwFmZ1ltZ2kIgLN6smpGVwDm+PndHOk5QyvY8dX8JVkAYvCNg9r
         YQmQ4lUr1nQbJ3SSrGBZZzh8VqaLMfdBuCwkEnZQ7qPIrbAyoT58uiUIV1I4e/4RRk6V
         pD+19R2yMFBJ+cQcq6UFZKSB3tOcRMqJxMHYhojdt2sZ489pqIdURVT0phYgvRvThOOj
         0gx4ngeBHDNXVwdg5uAQMwoy0betvRGqR3ovEpukg6dHqUg+sHNDTLU8c8v6eXOzFg0x
         XGJQ==
X-Gm-Message-State: AOAM5310oAULsUuubs+iz1EYsDXYWIIj9R6NvBHzvJC7FK8eXuTtvweb
        u5QirzbXbCPlz6ZanIvowT5Xum9Iy3I=
X-Google-Smtp-Source: ABdhPJzBx7uD+67poCDf2QYRxAznyzYMGF0Hynxyll63eq1q/oZtnzx23zwvh/FRi1trMJENU/uX+ZtWzOA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:268e:: with SMTP id m136mr1876235ybm.220.1617160789338;
 Tue, 30 Mar 2021 20:19:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 20:19:36 -0700
In-Reply-To: <20210331031936.2495277-1-seanjc@google.com>
Message-Id: <20210331031936.2495277-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210331031936.2495277-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 3/3] KVM: SVM: Do not allow SEV/SEV-ES initialization after
 vCPUs are created
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject KVM_SEV_INIT and KVM_SEV_ES_INIT if they are attempted after one
or more vCPUs have been created.  KVM assumes a VM is tagged SEV/SEV-ES
prior to vCPU creation, e.g. init_vmcb() needs to mark the VMCB as SEV
enabled, and svm_create_vcpu() needs to allocate the VMSA.  At best,
creating vCPUs before SEV/SEV-ES init will lead to unexpected errors
and/or behavior, and at worst it will crash the host, e.g.
sev_launch_update_vmsa() will dereference a null svm->vmsa pointer.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 97d42a007b86..824bc7d22e77 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -182,6 +182,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	bool es_active = argp->id == KVM_SEV_ES_INIT;
 	int asid, ret;
 
+	if (kvm->created_vcpus)
+		return -EINVAL;
+
 	ret = -EBUSY;
 	if (unlikely(sev->active))
 		return ret;
-- 
2.31.0.291.g576ba9dcdaf-goog

