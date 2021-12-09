Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885246E247
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhLIGJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhLIGJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 01:09:41 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADACC0617A2
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 22:06:08 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z13-20020a627e0d000000b004a2849e589aso3041664pfc.0
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 22:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XwK2aAeo0fjHkfXaWz8Ty6BZAoD9TIYvMIly0IdtTNg=;
        b=glHYd3IfOdm/ruPB1ckcqVGmkTWoY14hms3x9IVRLhesxoBhtEvOUbt9GALZqioU9Q
         rir8X0BBlnuzO7TrsXpwZ8dI2ksTdUmgDfgAALNLc9cm89xjUOLICQm3VDSs8TUMXoK6
         +l095fs3AU0bSQW2EILAV3VAji+9CyTovjKHNbnOJOZLzUYBssAlXdqejp4c7iXP3v1G
         V/ySM6oKkOPBsYZqDJjkAcT2YpVmQVZhID7hS7q+uh06h1GN+HoNr0d2my7sDsbAbATL
         F4oeQWNnqv0gIWtTSKMjtSTRB4goVtUuqpfz44JrLg/QAAN/Bipdeum9vQyo/rWtGGWR
         72DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XwK2aAeo0fjHkfXaWz8Ty6BZAoD9TIYvMIly0IdtTNg=;
        b=W6uFBMEPqTgID5S+7iE7nAa7B32/PgX9+hF1NnR8C4sexrG0YNXCREH5V5JAe3Kdkl
         rs4jpZTcfuxuDD7ebN43L86Ygcn1SQzMCzZXPvZgHwGH4XxEOiW3+geP9HfkqHStr/CQ
         ju2PsS60hL18JrCqyY5K8WRzCZftwickC40QMpGMbRK/ExPoQsP/Qin2YfxFQIcgwejG
         J80ojAONPG7hrGnl2RlK/rxhJARrPUrMBv1/wHpbl9zO9sPtkHJUddrI6NjF32qqwDEj
         wAppwDyVszNnRquC8bo5uekC9MfCjnyWBfR5yMpfmhnOpo8FZLMl/qUTwBfy35R6bmjO
         zLHQ==
X-Gm-Message-State: AOAM5304u102VbEkv3UCdProWVq7++IUOxRrXmy9DhOmQjtXrZyCaVBX
        X3yVkCj0DSEbTX0YlihkXcEuXNJ/axI=
X-Google-Smtp-Source: ABdhPJwAxGMilsaKQMdRlY2eJvELfH4FCF3pawk1uAC6wXcbVHFPq6wxid7Lug8YvA98RvPMJfO3zNBqpJM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id
 k19-20020a056a00169300b0044c64a3d318mr10028797pfc.81.1639029967795; Wed, 08
 Dec 2021 22:06:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Dec 2021 06:05:51 +0000
In-Reply-To: <20211209060552.2956723-1-seanjc@google.com>
Message-Id: <20211209060552.2956723-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211209060552.2956723-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 6/7] KVM: Drop KVM_REQ_MMU_RELOAD and update vcpu-requests.rst documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the now unused KVM_REQ_MMU_RELOAD, shift KVM_REQ_VM_DEAD into the
unoccupied space, and update vcpu-requests.rst, which was missing an
entry for KVM_REQ_VM_DEAD.  Switching KVM_REQ_VM_DEAD to entry '1' also
fixes the stale comment about bits 4-7 being reserved.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/vcpu-requests.rst | 7 +++----
 include/linux/kvm_host.h                 | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index ad2915ef7020..98b8f02b7a19 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -112,11 +112,10 @@ KVM_REQ_TLB_FLUSH
   choose to use the common kvm_flush_remote_tlbs() implementation will
   need to handle this VCPU request.
 
-KVM_REQ_MMU_RELOAD
+KVM_REQ_VM_DEAD
 
-  When shadow page tables are used and memory slots are removed it's
-  necessary to inform each VCPU to completely refresh the tables.  This
-  request is used for that.
+  This request informs all VCPUs that the VM is dead and unusable, e.g. due to
+  fatal error or because the VMs state has been intentionally destroyed.
 
 KVM_REQ_UNBLOCK
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 636e62c09964..7e444c4e406d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,10 +151,9 @@ static inline bool is_error_page(struct page *page)
  * Bits 4-7 are reserved for more arch-independent bits.
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
-#define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
-- 
2.34.1.400.ga245620fadb-goog

