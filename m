Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F6D3B0C31
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhFVSDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhFVSCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:50 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31AEC0617AF
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:05 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id es19-20020a0562141933b029023930e98a57so10827805qvb.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ylpxsJVZqQHxCprlfV+E9MmLtYIbNcUZULCnv1BFgJI=;
        b=rcY3HHbecxnEiFCqLojmywKuoaLKVAuXKbtUoVUOvKUNNepltkBW7wdfYnc20myoXE
         K/LzfMBHLYxNcc/MyC7m/JFMPxGZE/kFQqlfR3bhZf2z6aukTiZ/8oT3bNAR3xag3dWW
         7Pw5m1NohI5cVu+tdtbaO79J7rQaY++6PUWcymh7wMBU6mYG1EzJcppXg1nB5vmBqKup
         /eikxs+Ow+H0iuv1nRHcGVRBRacilJbLxXMB8mvk11jS20FqDHt9h19XlKZ4HRjqpmhK
         r2dn1PKU9Cr9R79gJojIQfPl4Gi09Yw6aZvBwAv5nK1oLE8PlV/YT3FX9vLcWO4z4STm
         yTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ylpxsJVZqQHxCprlfV+E9MmLtYIbNcUZULCnv1BFgJI=;
        b=tH3TiM0TvbwWb5S3bP71HrVzxWYbcn2hBdwJcV29TnqvrmiVDqNQiO4qFURN8rTdoZ
         z/8KeqNNfxGuo2o5CJ8RKovGOsGYHX6AizduokpDr9R/Qx748m6DwnZdKnOtbNSg8XSI
         LRoltGlUJeiHGQzsCwGLT03EOJY/RlThuBWIFVvALeaZ39vov+cgAPCj3fjtIz1+1wD2
         Pl71PZ9hTp6GAOEsdNh+fbQLCpbl2mZmA8QZV+nDhatgAr9YZcb9xkSvaxpqjcz8vRlH
         j1fanYqrfiqfxgkHuyR7/ZpSviQOXD9bvCNAS/bkHi8eBvNYSZlo1rH4tFGc1zq+UumH
         vq6g==
X-Gm-Message-State: AOAM530dL93dEJdGj9JDsSFqKio1lilZtaeJSa4NS/3BAD3NevY2RvSQ
        g93d2K05zmuNGNbDCmjIvy2SMQOv+ZA=
X-Google-Smtp-Source: ABdhPJy86ED/Y4SC0aZmOaWshiCQsGt9u3jeW/uIQb9VsZgmX8MEPWpFhtoiRUhTvFl3ZCOes71q838ZLA8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:bcd0:: with SMTP id l16mr6673381ybm.55.1624384744928;
 Tue, 22 Jun 2021 10:59:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:15 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-31-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 30/54] KVM: x86/mmu: Use MMU's role to get CR4.PSE for
 computing rsvd bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the MMU's role to get CR4.PSE when calculating reserved bits for the
guest's PTEs.  Practically speaking, this is a glorified nop as the role
always come from vCPU state for the relevant flows, but converting to
the roles will provide consistency once everything else is converted, and
will Just Work if the "always comes from vCPU" behavior were ever to
change (unlikely).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ffcaede019e4..e912d9a83e22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4216,7 +4216,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				vcpu->arch.reserved_gpa_bits,
 				context->root_level, context->nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
-				is_pse(vcpu),
+				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
 }
 
-- 
2.32.0.288.g62a8d224e6-goog

