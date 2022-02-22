Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AA44BF241
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiBVGsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:48:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiBVGsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:48:07 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC9D10DA41
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:42 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i21so10997001pfd.13
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Yszb1VhW5vQuqMzk14SvDtmn04SSl+6GxkgNXsOtcc=;
        b=nTfxQGLi3zvpnCIzarK1KAHcr9OUbs6g4uz1ass4kLBNrNGLi6/vww8xDMkk7DhTWB
         YBMB5DKiT2n8CnwPJeqai5zUQTyH3WVIVVAUQ7BLSEMcf34G+Ek9LALCV5/ns+sFxIJ+
         8ZCGg+Zjd1OnwFBXJchPDB8GfjKVbzHHIf84DA3t9gX2BzzhugTuEiAAQir92Q+Pd0L3
         uhizVe0se+EP5skquxJb2+mdOIi66/uBZQNhYS/QNxFNz48MPZDCrw72cRZr5O0t3Dkn
         157ap6F4aEh2U6MVT3eCgyM3dxRUYLpI12S+dRKOwpwJzScJPEV4WZSQZux3zT73djji
         Pr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Yszb1VhW5vQuqMzk14SvDtmn04SSl+6GxkgNXsOtcc=;
        b=Plb1Tw/pYQx/o/jU1cYFNh6MuvdDOivzV8jHwQdtFNbZuYbD/8kAsSbhkwot4jHzJJ
         vJdFagaAQ9xUG5gyoFwHcYLrhHNAasI4gRETRKBDKpHRiPBUS+wtlGaxvN4FgsxlVGe2
         ezSXBSHqszfQ4qGuMUoeHGnIdLk3LpZYNCaJX5Gnw3nX81oEmyAC4NOFgW9fWAhJJQWl
         lxpLkYvAoCMK6bvSUYMFSRKU2hhK5WGWFvZM7kqnojlqcSfVRb5io7JJ9P9FV6PFIswz
         oe9vMUdL2cRzQK8KT8jnxrqKTuWXOFq260zqv9cBgRAf2uYUZkJBmgwSOPA5mJ2TIweN
         1ZuA==
X-Gm-Message-State: AOAM5325TYdH465bDfSqjpHIP6YPs/5p3mMn0ZdsJR5Ge5TeltDW1GXC
        uNKiKuW1a1Q+4/W/OAw4rAM=
X-Google-Smtp-Source: ABdhPJyKnQMMQNrOXDylnjffub+WBwYSjI2bbl4OUZPem1TdOXRxmNhHZnfjesuPU0PiWaDiIQnIXg==
X-Received: by 2002:a05:6a00:14ca:b0:4cf:1930:9d67 with SMTP id w10-20020a056a0014ca00b004cf19309d67mr23076612pfu.55.1645512462337;
        Mon, 21 Feb 2022 22:47:42 -0800 (PST)
Received: from bobo.ibm.com (193-116-225-41.tpgi.com.au. [193.116.225.41])
        by smtp.gmail.com with ESMTPSA id d8sm16346711pfv.84.2022.02.21.22.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:47:42 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 2/3] KVM: PPC: Book3S PR: Disallow AIL != 0
Date:   Tue, 22 Feb 2022 16:47:26 +1000
Message-Id: <20220222064727.2314380-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20220222064727.2314380-1-npiggin@gmail.com>
References: <20220222064727.2314380-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM PR does not implement address translation modes on interrupt, so it
must not allow H_SET_MODE to succeed. The behaviour change caused by
this mode is architected and not advisory (interrupts *must* behave
differently).

QEMU does not deal with differences in AIL support in the host. The
solution to that is a spapr capability and corresponding KVM CAP, but
this patch does not break things more than before (the host behaviour
already differs, this change just disallows some modes that are not
implemented properly).

By happy coincidence, this allows PR Linux guests that are using the SCV
facility to boot and run, because Linux disables the use of SCV if AIL
can not be set to 3. This does not fix the underlying problem of missing
SCV support (an OS could implement real-mode SCV vectors and try to
enable the facility). The true fix for that is for KVM PR to emulate scv
interrupts from the facility unavailable interrupt.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_pr_papr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index 1f10e7dfcdd0..dc4f51ac84bc 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -281,6 +281,22 @@ static int kvmppc_h_pr_logical_ci_store(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
+static int kvmppc_h_pr_set_mode(struct kvm_vcpu *vcpu)
+{
+	unsigned long mflags = kvmppc_get_gpr(vcpu, 4);
+	unsigned long resource = kvmppc_get_gpr(vcpu, 5);
+
+	if (resource == H_SET_MODE_RESOURCE_ADDR_TRANS_MODE) {
+		/* KVM PR does not provide AIL!=0 to guests */
+		if (mflags == 0)
+			kvmppc_set_gpr(vcpu, 3, H_SUCCESS);
+		else
+			kvmppc_set_gpr(vcpu, 3, H_UNSUPPORTED_FLAG_START - 63);
+		return EMULATE_DONE;
+	}
+	return EMULATE_FAIL;
+}
+
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 static int kvmppc_h_pr_put_tce(struct kvm_vcpu *vcpu)
 {
@@ -384,6 +400,8 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 		return kvmppc_h_pr_logical_ci_load(vcpu);
 	case H_LOGICAL_CI_STORE:
 		return kvmppc_h_pr_logical_ci_store(vcpu);
+	case H_SET_MODE:
+		return kvmppc_h_pr_set_mode(vcpu);
 	case H_XIRR:
 	case H_CPPR:
 	case H_EOI:
@@ -421,6 +439,7 @@ int kvmppc_hcall_impl_pr(unsigned long cmd)
 	case H_CEDE:
 	case H_LOGICAL_CI_LOAD:
 	case H_LOGICAL_CI_STORE:
+	case H_SET_MODE:
 #ifdef CONFIG_KVM_XICS
 	case H_XIRR:
 	case H_CPPR:
@@ -447,6 +466,7 @@ static unsigned int default_hcall_list[] = {
 	H_BULK_REMOVE,
 	H_PUT_TCE,
 	H_CEDE,
+	H_SET_MODE,
 #ifdef CONFIG_KVM_XICS
 	H_XIRR,
 	H_CPPR,
-- 
2.23.0

