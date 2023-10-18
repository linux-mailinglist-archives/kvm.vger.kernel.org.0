Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895C77CE7ED
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjJRTlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjJRTlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:41:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CB0AB
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9b9f56489fso5652390276.1
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697658071; x=1698262871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ofuuq8OnXnBwuNBiWtVLb1NEzqrH7XwtOSMnrh73sd8=;
        b=KQUyfewpiZDgHKhuBlxHffQ0dmFuq14bplh/X97tRzsZ1J4IVFw9LgSRusq4uePP7p
         I2fWrJB20gGOcn5OK3sPVx1Cws82eApx0yayMcRBTHMuag8ieLn/2rpiqGl3vYU4HPMP
         plDRDLUy8748Fghanx4KRrDiuZHDMRky8F4wOa8TUtlosUPPrnt8TW2Km2mHMOe1rfJT
         aNFAX76iUsrGF5vygVrg4yh/zpC/grDHqg9iEFeZfNT7U1Y0o/YXZDFBZvUTTCpBtV2t
         ZuO/MR0PUS/H22Pu5+Tp47+t0h+q8nJwrIqvaJ1iEY8W14kWB6immkZlwC+AABSEmehm
         PINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697658071; x=1698262871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ofuuq8OnXnBwuNBiWtVLb1NEzqrH7XwtOSMnrh73sd8=;
        b=PRKOH9ukV0504k3WI3r5SlfLGfVm82eEZ4pTlrpl5fslNdMiMGeJKI2kR9ZsxbpspA
         I8zbevtlGYr9cejldEP/NXQrpJHYdYq5+z4hbX0TpgN1gsqtaB+bfIdgfaZrtIC/9J8q
         Zz2gxD22tWbH447cWBXOg7mbCQgUH6i7v7fb61NhunwJp/JaQYpvywocuJgC+qpAIyAb
         60/ocboslsYSAeK7ZOCMyFvIuHewOlMQXU/CEqdRkkncudsHLfAuDUjT7nOsd5yLSf4G
         1HG2GsBZbPwwISbxgTKzXXWTLvnvO6uUWHN390MlhJPN1mwe9ImoFVEqwFLWAHcx2bWK
         KkVw==
X-Gm-Message-State: AOJu0YwUC5fcFU1ZKg1cEZi4qAu9xvPY21wVqWWBVSoiH387g7Pka7R8
        WaDiZeyCiL3gUQq4R6lipzt4qD1yzHo=
X-Google-Smtp-Source: AGHT+IGW0vvt2l55+JL2+bM3VOgMoxB7qvHv720MxhQbccRQ4nqpX0a4NV57+RPdy39vplncxaNMVHs5grk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1825:b0:d9a:d272:ee58 with SMTP id
 cf37-20020a056902182500b00d9ad272ee58mr7884ybb.9.1697658071068; Wed, 18 Oct
 2023 12:41:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:41:04 -0700
In-Reply-To: <20231018194104.1896415-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231018194104.1896415-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018194104.1896415-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: nSVM: Advertise support for flush-by-ASID
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Sterz <s.sterz@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advertise support for FLUSHBYASID when nested SVM is enabled, as KVM can
always emulate flushing TLB entries for a vmcb12 ASID, e.g. by running L2
with a new, fresh ASID in vmcb02.  Some modern hypervisors, e.g. VMWare
Workstation 17, require FLUSHBYASID support and will refuse to run if it's
not present.

Punt on proper support, as "Honor L1's request to flush an ASID on nested
VMRUN" is one of the TODO items in the (incomplete) list of issues that
need to be addressed in order for KVM to NOT do a full TLB flush on every
nested SVM transition (see nested_svm_transition_tlb_flush()).

Reported-by: Stefan Sterz <s.sterz@proxmox.com>
Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1785de7dc98b..9cf7eef161ff 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5083,6 +5083,7 @@ static __init void svm_set_cpu_caps(void)
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
 		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
+		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
 
 		if (nrips)
 			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
-- 
2.42.0.655.g421f12c284-goog

