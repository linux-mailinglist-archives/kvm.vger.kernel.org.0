Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F362F5ABBB4
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiICAXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiICAX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DC9F72CD
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:25 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n28-20020a63a51c000000b0042b7f685f05so1875591pgf.13
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=rrxOj6R3JsP7X4wJ2mvKJ8fJICeKlQtKiWhKFMrI/6A=;
        b=NBi9qTeOVZwGZ2FRXHHFz8I1zP6pGuyNlhLOF624Zr12agQ9NWuXfFJij00PH/7VVj
         1h6YB+Rez+4fdqYZhPmUEiz0HYfEUOgNFUiiq7ZdodUOzlCDYJKhShfmNGxCgsDeCgA9
         tScO/gj2x9FsBgLZI/X1cuWxXWneOffco610sof+4hKLLG9dxyNs8ZaWIm5HEEDqGZ1V
         VG2ik8ozpsdYJ6CUZfhpPqEYCA0jgtW8hNx+HwYVCFKiKL6FBosXy9yZ5kjY5MU6+mC9
         pbgnE1U68KC3L4+8V1TvP9vPuD+BT730kswD2IEVHR1HS6AI9IcD3LWWgsXOUq70LLZZ
         PPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=rrxOj6R3JsP7X4wJ2mvKJ8fJICeKlQtKiWhKFMrI/6A=;
        b=NkYOgb1EIzP0uQCX7jc9r2w3vHRlyKICnOte369HmCEW44jKH97F9lqV3jSG0QiJXi
         cPNPsbgBcSm/mkslRc9X/v2m1QSEcIZ+LoVy3F/N/V4DghGRDuJ4HWcls1BO+8c3lSXq
         OiiTd7Hkrl1Ul3wHnxJPMHDhdP0SQzhIwhvMlz437ukTqjPg8FN5iCAEfZBDpH89ta4t
         eElRcaA5oRnEkcklTdz5328e28fmvarSkbRLUWqS05/zqxrO79kVcSQ9Kbt4K8HfAB/G
         MyVV5PPnMMwWALTZ179NVvAxejWqM/lzvhFEOymNuRN5+2lSIoQBz0dh7HlSAx7X92H/
         KhVA==
X-Gm-Message-State: ACgBeo0XoXqNrykF7oLVPHZuJ+Rq4q9iZpIdM+ASaPp9/9byIehfiZVz
        lGLAt+kaIEVRnTFpaZOnfMh1mE/DMV8=
X-Google-Smtp-Source: AA6agR7p3xJPJyvc0VRdWacDfZgNOR5e2m+iY8o4EhTdk4RsPO6f24uT0PUztUqNwwZPfym5fpn++e/VXkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10c7:b0:53b:5eb3:4648 with SMTP id
 d7-20020a056a0010c700b0053b5eb34648mr3677753pfu.67.1662164604937; Fri, 02 Sep
 2022 17:23:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:46 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-16-seanjc@google.com>
Subject: [PATCH v2 15/23] KVM: x86: Explicitly skip adding vCPU to optimized
 logical map if LDR==0
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Explicitly skip adding a vCPU to the optimized map of logical IDs if the
the vCPU's LDR is '0', i.e. if the vCPU will never response to logical
mode interrupts.  KVM already skips the vCPU in this case, but relies on
kvm_apic_map_get_logical_dest() to generate mask==0.  KVM still needs the
mask=0 check as a non-zero LDR can yield mask==0 depending on the mode,
but explicitly handling the LDR will make it simpler to clean up the
logical mode tracking in the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4c5f49c4d4f1..80528d86f010 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -318,10 +318,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			continue;
 
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
+		if (!ldr)
+			continue;
 
 		if (apic_x2apic_mode(apic)) {
 			new->mode |= KVM_APIC_MODE_X2APIC;
-		} else if (ldr) {
+		} else {
 			ldr = GET_APIC_LOGICAL_ID(ldr);
 			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
 				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
-- 
2.37.2.789.g6183377224-goog

