Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B40E494557
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358037AbiATBHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358053AbiATBH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:29 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D55BC06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d6-20020a170903230600b0014a7ecc7f05so725120plh.8
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7/mr3VAZ+GGwhFCFeDChGtplD3crV8sSPlyeJQ/WW78=;
        b=h/W8byg/FWcCNjEgb8CsHlM5dZ+jci1WvPkSRhZu+0zijU22D1Ea30LhYvfuHFqhf2
         XPJYrAjjfiNdXe4hxqzf07LF0Gsp+2SGewdv2xfH9/WY5gpNeaEGrznxKQgdvMaETJUF
         vTG9FTPG4ill1PYBj1T3xmwg0sI1HGrWhcSAy3Dg4/gDrlZzDQ7ev4hMEx4+xiFBzfJ0
         GQWtqnz+VVaF5rbEVyFoj+Sg9aTTwahg3TAb3GQcb9iN+XGdDL0/YEIhjkkqpUO9wn0r
         JGncI/1jztmotAHVBnnfGo3GpunEJ14Mi92O2IBP6n8H6h/dBPSU3DCaWfzfL9q889q1
         AdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7/mr3VAZ+GGwhFCFeDChGtplD3crV8sSPlyeJQ/WW78=;
        b=V1u11oit9fCD3R2ECauLtnPbmgxydHNfDHiinNvZA5yPYJHndZB25KZOwYey6xG3Bx
         O95FZiSvhJylxU8wo/dynzO9Oqm+1KFjQypJr0THADQr/WohSW40S8Iw0LxphMSX83e/
         bG4kiJ2r7U+nKfGw0MatJ6JkrKgNi+txwAKYaF0u9jZmmSZd+R7ztqWjxz0SUQyhNx3v
         D3CX2UVEvMysKqFY4YXvppXWfMKY6pPsc37/8vt0eIyYLKVMW1I/ndE/cuKK2zncwVkj
         RhsKjwidMpfSmXhizynCkSrS6h1SvzGWr7i0FHJQ/sxaNIEtoOv+S+848PFlmVPkiOek
         sIIg==
X-Gm-Message-State: AOAM5325r8nahxslJwZ8H3BUzLFj+8LxwsjOIEBfc543s13h/ZjSamY8
        G/hvGX6Jm2fco3Xen9YB+8YW4he5BGo=
X-Google-Smtp-Source: ABdhPJxpIFaRY6m9RVeY2dlkSROIH2RV6i5rE15nHnu+I39Q/AeGO617waVxL2cl4tvEFjn1+pqmufrUJA0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:13aa:b0:4c1:e99b:2084 with SMTP id
 t42-20020a056a0013aa00b004c1e99b2084mr31574313pfg.19.1642640848679; Wed, 19
 Jan 2022 17:07:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:13 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 3/9] KVM: SVM: Don't intercept #GP for SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Never intercept #GP for SEV guests as reading SEV guest private memory
will return cyphertext, i.e. emulating on #GP can't work as intended.

Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 85703145eb0a..edea52be6c01 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -312,7 +312,11 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 				return ret;
 			}
 
-			if (svm_gp_erratum_intercept)
+			/*
+			 * Never intercept #GP for SEV guests, KVM can't
+			 * decrypt guest memory to workaround the erratum.
+			 */
+			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
 	}
@@ -1010,9 +1014,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
 	 * We intercept those #GP and allow access to them anyway
-	 * as VMware does.
+	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
+	 * decrypt guest memory to decode the faulting instruction.
 	 */
-	if (enable_vmware_backdoor)
+	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
-- 
2.34.1.703.g22d0c6ccf7-goog

