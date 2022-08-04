Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2FA58A401
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiHDXuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiHDXue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:50:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36113E27
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:50:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w18-20020a170902e89200b0016eff609594so641233plg.11
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to:from:to:cc;
        bh=oy6h1dP3SvYtRyYZ4ufO2gPmn5HL77YkRDjgUecCeHs=;
        b=gKNxN/3/a8zeFxraeErk9leW17wtygqv43Lsb1/i0DwwN4W3bCHGYn9S6fOaUbkAZI
         JgaCrlUOUpzp7A3mL7RHHXiqgflW31pv4/n9075W1jw6ioZsTYYkvHXCIQvzsh2kwAfa
         0+poQHr2JsnhfnwON8CcuDSqxO7cTGfbVXTfcSFL9JwC6u0vjWEbfSR56OJxBpqLman6
         uJ84/FqgAAnbS5hlm0ApFrNKn/33njsdP6Fz+NuQCSD5g/afKxTDAW4FerIB0JfRKPhW
         7ktE7f+y7nC0j/hMfTa/OKnmyhfGvQbDv1lV8lVLfKKDBbiLOsOA+u7VAb36jgq4UWsV
         UEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=oy6h1dP3SvYtRyYZ4ufO2gPmn5HL77YkRDjgUecCeHs=;
        b=IMk/LzUiALjZO8AakQQuQhRKV1CsDE48Ln9x0QpBeLyDJeA1EmES5hPKPaVApOwFxh
         RJ/Hj/n/x88d95j1EgHnEUITAhbwh8nmV3dWRVgFkQ1FWzcWzPGhdpqjXWdoo8WungJ2
         T2mi1GmHikR24G3A6FbsSdAd43XS+Ke39IsnS1z4o55vE/shOvqKILysnp+0z0c5kxCO
         ol8NbM9mFO712u/omFsZXkAP4ge1OHjmh3wjqOritXWkCFCgKJl6RQjNd1xspfhx3r8I
         le37XxsYAx2A7N8CnSsXxRE1F8/E2Kyy9q03tZOrR7OYc4ZYaQP4fm1/14DcXG4h4jl9
         LyxQ==
X-Gm-Message-State: ACgBeo0xuEVraeYDPEI4jRU4iHEKXzn4sjjYZvbArnFFfGKjcw7ZYikn
        cBal3JZDI4tKL3VseXHcav+BIYKvz8g=
X-Google-Smtp-Source: AA6agR511SS21Ee6V1g4M7SEWOr+6FGj2uU4QiBlt0ii0pTgIG2XIwTe8wxu9CPu27tjXD+oyko18PLi2ps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:350b:b0:1f0:23d9:57eb with SMTP id
 ls11-20020a17090b350b00b001f023d957ebmr12545340pjb.17.1659657030897; Thu, 04
 Aug 2022 16:50:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Aug 2022 23:50:28 +0000
Message-Id: <20220804235028.1766253-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH] KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on
 a "bad" reg
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bug the VM if retrieving the x2APIC MSR/register while processing an
accelerated vAPIC trap VM-Exit fails.  In theory it's impossible for the
lookup to fail as hardware has already validated the register, but bugs
happen, and not checking the result of kvm_lapic_msr_read() would result
in consuming the uninitialized "val" if a KVM or hardware bug occurs.

Fixes: 1bd9dfec9fd4 ("KVM: x86: Do not block APIC write for non ICR registers")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e2ce3556915e..9dda989a1cf0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2284,10 +2284,12 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;
 
-	if (apic_x2apic_mode(apic))
-		kvm_lapic_msr_read(apic, offset, &val);
-	else
+	if (apic_x2apic_mode(apic)) {
+		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
+			return;
+	} else {
 		val = kvm_lapic_get_reg(apic, offset);
+	}
 
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy

base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.559.g78731f0fdb-goog

