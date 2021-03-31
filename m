Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9585334F6A1
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 04:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhCaCbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 22:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhCaCab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 22:30:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECD4C06175F
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o129so646823ybg.23
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uV4x6+EdkMXZhg7wMEUNEc/cXMhh5NFoJhoLXAZa4XA=;
        b=hyxAm79V1CoNeCcaWjPRj6j5vKrjB66hHPXwlccvH/3YB10lOq1utFmsZxYp8F3HpG
         WOVVmSaroJAJOzz4lNDIbz7ei9dCL3cKP4c17RXAj462cjZTMs8oecds+x1bGGRaLRVE
         vmKYsAvI44f3RBbPqlZk3+kcxA5yCOsa4zYDyKO9Y6bRuhE8JVlAQhJa+kJ+6Wv/2Ghz
         4xMYiQHQSD02fcexUHEgrkqc/uqoNUwmNr9s/ylUQx15EFvA2VaXTuppXEfG0Eg2XXWz
         B2M6KfrdkALt0ZTB/hRS7drJULF5z50LaOIqMSYoWDCtbYm31kQwZ7CcI9NMzcJM3792
         c7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uV4x6+EdkMXZhg7wMEUNEc/cXMhh5NFoJhoLXAZa4XA=;
        b=lmGLfYDLavfy7gaEUnAvl6FN7lABcK2nA2nNYGiNUR4XCd5TGgzGWclz4wicK/GRE5
         Eu+vGWFbW5TNpcnUrMLNMBoLf25pPt7FOO/smbztMc6LN3B+iuokijY2R7DX4b0lms9T
         NxABHKIjPWP0z+pzmQDAhU57OCOdYlyZDAGYB1yziHH03gBKVJPKLnFIM5+4m/RXgSD9
         v5daLAA77gXD3CVLxm84t9eqcdPbz8K9SYZJ/13KMDdDJGlTIe3jSP1QrfIuEWa1g+YS
         h8hZLeqoTI+zsif/98B0vRU8I/RFzgrUcL+XYe94HgaZ31agbc2yeBbXaNMMA9pjEGRw
         Dd2A==
X-Gm-Message-State: AOAM532bbf4YAueqHvJ+z4tDhIgJaTifb6+rtuRdYiciFs6vI/QIZAG+
        kgT3mLvyi5AnXPERdeFdG5IPVRIJ86E=
X-Google-Smtp-Source: ABdhPJyoJU2Rdi/to8R+u7+o3IMo1VtUs59XwyVJUPXLriy3TmcY1tCAqdD1U35l7io8CdK4mvxxJmJF+eM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:c588:: with SMTP id v130mr1592057ybe.312.1617157831002;
 Tue, 30 Mar 2021 19:30:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 19:30:24 -0700
In-Reply-To: <20210331023025.2485960-1-seanjc@google.com>
Message-Id: <20210331023025.2485960-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210331023025.2485960-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 1/2] KVM: Account memory allocations for 'struct kvm_vcpu'
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GFP_KERNEL_ACCOUNT for the vCPU allocations, the vCPUs are very much
tied to a single task/VM.  For x86, the allocations were accounted up
until the allocation code was moved to common KVM.  For all other
architectures, vCPU allocations were never previously accounted, but only
because most architectures lack accounting in general (for KVM).

Fixes: e529ef66e6b5 ("KVM: Move vcpu alloc and init invocation to common code")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..3884e9f30251 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3182,7 +3182,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_decrement;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vcpu) {
 		r = -ENOMEM;
 		goto vcpu_decrement;
-- 
2.31.0.291.g576ba9dcdaf-goog

