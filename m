Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906E84C4D9C
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiBYSXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiBYSXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:33 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2D4104A79
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:23:00 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id c15-20020a17090a674f00b001bc9019ce17so3665730pjm.8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OKpSENCWyXwHBdjGJ3gByFACo60D6cjEVL83LoqsyAI=;
        b=b9RI+WDrYKbDwWxRpfBrGKJ+M0uWUYG/R9HMlU4/mEqPTWu7oVtS1VUBgFgWjZ++ZP
         qR7+DT+WJGieOarv8OsgBF6aZHUnul3W3dcki20lr/dtvbRybp2muAitL2U05f51Ishp
         6keyKWiJjZBWG/rIx5ewTqUShB0uvTvoNxYZOCz/NIiY5uOzPagL0MB+A1+anitssEbE
         NmT/DbUfJ8sAXFaBQmTOfpKmmqacNgBbRIxzbZPqI7vmHCB5kmBDot/QnQIzwiitk4ob
         cDTNizSkwp2Xg707XqCJDUTVTz0k3eXvcUkGGZ76FFJ+7R81vfgTkmat4/9b4wuNQGJK
         tPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OKpSENCWyXwHBdjGJ3gByFACo60D6cjEVL83LoqsyAI=;
        b=pqzGuU5pEMmRKLMI6xFwUbpRpnMnqumHYgJaF6RSQUZFP8BqBXtITj9Ah0l0prgtgo
         zrtkrKvjRu9W6/nCtS0MIjXC7iT6JVDq/flUzhEtfBowKDoiO02/+dRkIWz9K5HHDcI9
         CqtnCMDJEY/AUNKZEFsxgFslKIprwbiAj9WwHzPzLx/Qp+BhPNLQHDWQpNWYZ1oiskXU
         BClkppAwJvjGqChmqTEX4lkQS4Cva4IBh2oYGQdeiHQW6++xCHmJPHxlmpRZOori9E3J
         ss3UyFeaUZIZfqp8W00OdmhJswqichNRyYaS5ZjX4fV6izJPup8fPIr3ldsyhEmY+hUJ
         KkFQ==
X-Gm-Message-State: AOAM530EmduXZk64d3a+1SlSO5hR+tX2pdh8VGWIcSL0Or92BzYDBCTF
        +dXF+1h5YrQGVsz5YqEC1x4LtjjhJoo=
X-Google-Smtp-Source: ABdhPJwUNaTUFvmEZHBOnSpxwiw/lZ+XqgCu1OS+l26XAQ4480iv62UAgTn9TFAeEJvztnJGJ5LksjK+jVc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3c01:b0:1bc:b160:7811 with SMTP id
 pb1-20020a17090b3c0100b001bcb1607811mr4342903pjb.164.1645813379912; Fri, 25
 Feb 2022 10:22:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:47 +0000
In-Reply-To: <20220225182248.3812651-1-seanjc@google.com>
Message-Id: <20220225182248.3812651-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 6/7] KVM: Drop KVM_REQ_MMU_RELOAD and update
 vcpu-requests.rst documentation
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
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the now unused KVM_REQ_MMU_RELOAD, shift KVM_REQ_VM_DEAD into the
unoccupied space, and update vcpu-requests.rst, which was missing an
entry for KVM_REQ_VM_DEAD.  Switching KVM_REQ_VM_DEAD to entry '1' also
fixes the stale comment about bits 4-7 being reserved.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/vcpu-requests.rst | 7 +++----
 include/linux/kvm_host.h                 | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index ad2915ef7020..b61d48aec36c 100644
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
+  fatal error or because the VM's state has been intentionally destroyed.
 
 KVM_REQ_UNBLOCK
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0aeb47cffd43..9536ffa0473b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -153,10 +153,9 @@ static inline bool is_error_page(struct page *page)
  * Bits 4-7 are reserved for more arch-independent bits.
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
-#define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_GPC_INVALIDATE    (5 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
-- 
2.35.1.574.g5d30c73bfb-goog

