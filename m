Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA724C4D9D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiBYSXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiBYSXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:35 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F8016F978
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:23:02 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mn16-20020a17090b189000b001bc2315d75cso3678771pjb.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=L4MqIEc/JbsQtnFnEaV173FD1GR2zeygOeGJKcIQHTM=;
        b=j/8rVgwYSLF3S4KclnS2WyxYGKq78Q2Pofky6B4ClrHiTlJMvAxQKPBPDGdnxYTHsb
         hWa5sLtrz+TbRfNlOWBc4U5GVLwtNNCOpckkzebNdjafWEgSepQR/Tx3PVA74hnePoYe
         xP/FJLDwab7dkTjeOQtTw4XYYbSSTdfn5l26SMVawmzCvxGn0PsUaQtrYTzTAf2eHRhv
         UHh/Fs9+sDwrPhDKZ8dAZ86rPtP+W71Tf2mhqhXbk+bdF02skbuCTWcGfkdJyOEd2qae
         vRIBLgSiv09yctbEh50CsDFVMftonFAzi5fVFFtJUei2H/ei/AK4uCh73Fj+BEMFRqMP
         WtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=L4MqIEc/JbsQtnFnEaV173FD1GR2zeygOeGJKcIQHTM=;
        b=bcQ0fQ91+t/+Rbs7v9K/MX+FwbXOJ3GmmUGusX+lVenXHUGObkp7BtJuSp0Mu+Z1dv
         4y2fnICywNjAjcamS+ff8wR6j7XIIxy3hPhWuGk2cZsFfXfCg/eSywGfOOEKGQ4k+Qqx
         VIvh8GDz9+WFcJZuNf0VNxRq7cD0RvC2kOIZvig0FA8kMmLRX7AqBq5xyjVry8r2ks15
         TBjvlNoGCc2MUBUc9Cc+4NCjxo0mmyVQ9sbISdQrVd0LAT28HRbW0L2p08Mzb+m6+iD6
         Bjy0jzHk83iu1FAXIC0WaH55SNPm5d+e+0wf5QQ12l9IenJPOd0Hv367l1vMItE8lx1g
         +pDg==
X-Gm-Message-State: AOAM533Qrhdyc5gMuUpI3quzUbpoKl1kBxGYQ3ZXDf9Py+8XXhU106Ih
        AFjtZ11kC68otq68j+D2yzesfsd7dBk=
X-Google-Smtp-Source: ABdhPJw93c17M/Wa7z94CmL+MMkOWMzcXaEGjy6d/i23LqFNc4Iax0+2elbEtSqmyNeMnzOh+XEeqm0YPKo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:84d3:0:b0:4e1:b5c:1dd4 with SMTP id
 k202-20020a6284d3000000b004e10b5c1dd4mr8798283pfd.20.1645813381710; Fri, 25
 Feb 2022 10:23:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:48 +0000
In-Reply-To: <20220225182248.3812651-1-seanjc@google.com>
Message-Id: <20220225182248.3812651-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 7/7] KVM: WARN if is_unsync_root() is called on a root
 without a shadow page
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN and bail if is_unsync_root() is passed a root for which there is no
shadow page, i.e. is passed the physical address of one of the special
roots, which do not have an associated shadow page.  The current usage
squeaks by without bug reports because neither kvm_mmu_sync_roots() nor
kvm_mmu_sync_prev_roots() calls the helper with pae_root or pml4_root,
and 5-level AMD CPUs are not generally available, i.e. no one can coerce
KVM into calling is_unsync_root() on pml5_root.

Note, this doesn't fix the mess with 5-level nNPT, it just (hopefully)
prevents KVM from crashing.

Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 825996408465..3e7c8ad5bed9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3634,6 +3634,14 @@ static bool is_unsync_root(hpa_t root)
 	 */
 	smp_rmb();
 	sp = to_shadow_page(root);
+
+	/*
+	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
+	 * PDPTEs for a given PAE root need to be synchronized individually.
+	 */
+	if (WARN_ON_ONCE(!sp))
+		return false;
+
 	if (sp->unsync || sp->unsync_children)
 		return true;
 
-- 
2.35.1.574.g5d30c73bfb-goog

