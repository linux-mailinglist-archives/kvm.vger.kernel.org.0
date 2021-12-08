Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FE246CAA3
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbhLHB7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243659AbhLHB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:07 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5ECC0698CB
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z4-20020a656104000000b00321790921fbso449722pgu.4
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VCkxR8iIoNYN3L1RJkz/btGuEUMw40noTB+y7+zqLJ0=;
        b=LHBsLMi3udo6BrUeQlkY0pT4Oc4Ew+wh9tNDgI5U1zVhU/K0iQ3l6PitAe/In7no9G
         OXT3y7uz44mqs4JDXqIHQ7BK0RaSWSDltzRyPHd0OyFaaR3vrpx63cneXeF3DTx93b9g
         F2/KpKN4IMYf61J/Il7a3FpMeSlYTvqPqK3MgdLFbpzQb7rQbMFPHsRQvt8Ph6dTV4nC
         MW/pjtPm8rI9cn9uQZFXTuJxhW36O6IqgaBHmFE+cCoTQkTPNd5oVzxa6qMc527PBa6Q
         kGs0fFfa+c8qKWopEJ+pQD8z9ov9+LAS3ZGWNB92YYF6/oohgLIDMWPUTgJwXVZpYg95
         K0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VCkxR8iIoNYN3L1RJkz/btGuEUMw40noTB+y7+zqLJ0=;
        b=w7dv+TtmwdRl5WSlrItjZe1GN+0ob9VcHpmeSjR15BTitFzJd28fhu1/fHZ6c6JFzX
         7fZnpm/9ZR2Zzu1jT+dXeXk31iNypCeybVtDWORCoxFOaAhWwBx4TKUxKnenTJogH+5c
         7Ktp+l3ATe1LMvm+LSMQInGo7f8q+tDIqDWC3Q4xlDfUAv0SCdCmwAMtYLCXiw8T744g
         TrmIGMj8V9QZzNNZGRvNM6mLCQCBb1WVrYbShnyqttJWq5KvFBDnB4EeJUoKirr3r63q
         5DGvmkgBy9eLpS1PsVNRPKVTyjcj9zPoi/d9spQzb8+r5ciDb9r455NNVDQATmfA1cu8
         bs8Q==
X-Gm-Message-State: AOAM531dbNzSsLM7WA/3ifYLE1nTqRz173bZmB/BqRSh0X4dsxmhDMzh
        N/0MR8vSFDj7BXeka1OF4eLRXwmXWZg=
X-Google-Smtp-Source: ABdhPJyQ9IDS5uYE2qNrBofLqK0XEq3FDd5eSHH0h+fuqLKFddQUMDjOnZnO89YNMResi94warafDO7Gz7o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:124e:b0:143:a388:a5de with SMTP id
 u14-20020a170903124e00b00143a388a5demr55869342plh.73.1638928530566; Tue, 07
 Dec 2021 17:55:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:36 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-27-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 26/26] KVM: x86: Unexport __kvm_request_apicv_update()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unexport __kvm_request_apicv_update(), it's not used by vendor code and
should never be used by vendor code.  The only reason it's exposed at all
is because Hyper-V's SynIC needs to track how many auto-EOIs are in use,
and it's convenient to use apicv_update_lock to guard that tracking.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc52b97d6aa1..0774cf4ccd88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9597,7 +9597,6 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	} else
 		kvm->arch.apicv_inhibit_reasons = new;
 }
-EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
 
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-- 
2.34.1.400.ga245620fadb-goog

