Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04D3A20EE
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhFIXpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFIXpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C908C0613A2
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:43:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q63-20020a25d9420000b0290532e824f77cso33532500ybg.10
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JW6PtqG5EBBMLWfIzHJuPDSiGDz3QYcEpSpJG7r7k4g=;
        b=Wbx/J0n9iESf85d0G1L74LLD2eLDijf8SWts0pPqgG2Sh6Qt30OBZcAeexQRuv2Eic
         AdDdnF7Ylc2SOHlJdoC3UVNxMt/X7lyHmAFrIxYmvsssBjq2lE/qjMVC5Ywox/b4dmbK
         6Or2DNy9yEyhVAPfwLdxCSxfRL9wl/nJtSKM2e0/naTxCLKa7n1DZDteuLHsWHbSEP7k
         ywPmFqd7HCMdpm/KUzBcwG+HN20+uUH2hHynJtjnXjLJVRXqGxt9qgntherm675NlU2o
         tRNazhW5B1ioLVhGBf9yD6NY4i0tH3UR7T73lP+Sbzl2JFxhoSF4dnkXP/Slxro3GFgI
         eN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JW6PtqG5EBBMLWfIzHJuPDSiGDz3QYcEpSpJG7r7k4g=;
        b=tOezK+YmPKcfC7U9Pfy/cnJy6X5KFEIiqbiC07jEBIcdW4GpcZZ8mr6fNIEBGB1NYD
         OzUqNgstwJbrH+6TBz7P6ohY3c7ecvPGbeLvzey7QP7ECJ/R44eb9nJ8XGIrM2CXIyV5
         Zm6bK1Iq4zEmaQ1JzRRThoJPLLvpZ+7CW/g4I3QynQMrl3Ph/on1pSeU6t0aXJTJeH0O
         0EGf749xLlzhsnot3PGCKEJYSDuD3Vus4kAsRnKsQMJ2ZcfGtMqCtZVZPNmUvSHDlldg
         H5hHpKtgIWCDt/8ggKaf8NWbXxQ8VBNV239eMIT+lQxlcCFAWBtTCjS87kGhHcHoazz9
         +iEA==
X-Gm-Message-State: AOAM533Eehb3JT0cJ80OstV57oS0h3gqtPQFuiiZtQHBfRcsbsey1clu
        RF5prOrKb4YDdiaPsR1Pe/R5EAyuoBo=
X-Google-Smtp-Source: ABdhPJz/9YQGh8Mu2InFaNSyU2MwVQXomSR7fbxj6idTc8vdJENDrCVczbkCOzHIWvle3h2EcYAz7iWtxKw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a25:aa53:: with SMTP id s77mr3153575ybi.89.1623282197388;
 Wed, 09 Jun 2021 16:43:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:35 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 15/15] KVM: nVMX: Drop redundant checks on vmcs12 in EPTP
 switching emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the explicit checks on EPTP switching and EPT itself being enabled.
The EPTP switching check is handled in the generic VMFUNC function check,
the underlying VMFUNC enablement check is done by hardware and redone
by generic VMFUNC emulation, and the vmcs12 EPT check is handled by KVM
at VM-Enter in the form of a consistency check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0075d3f0f8fa..479ec9378609 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5448,10 +5448,6 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 	u32 index = kvm_rcx_read(vcpu);
 	u64 new_eptp;
 
-	if (!nested_cpu_has_eptp_switching(vmcs12) ||
-	    !nested_cpu_has_ept(vmcs12))
-		return 1;
-
 	if (index >= VMFUNC_EPTP_ENTRIES)
 		return 1;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

