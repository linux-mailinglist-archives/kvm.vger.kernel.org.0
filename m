Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE4761046
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 12:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjGYKIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjGYKIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 06:08:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A2E56;
        Tue, 25 Jul 2023 03:08:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b9d80e33fbso30057265ad.0;
        Tue, 25 Jul 2023 03:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690279733; x=1690884533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fyvH5/CqXN2xyIltDVXkOjkKF/iLXy53dgSSuhLOAj0=;
        b=YzqQe3D8pCqYp1GOmHXRmyHUkXI+PS2UV8t3/udD3RhcjGpjMtNSNrzkVpZPX8o+Jp
         KbeWYm9Dtpp5+RScDGaL7uEl9Gv0Tnkx/GrGloyUfpWiU4zchTFN6Q357gRLPxz8nszG
         GbxGgI4p26caGRCEqlepRRoZJuvwrAeoJUsHtZE4Sb/p8IMCKDRLqCkIHhcVbdSAXQ47
         whSID3+yfSYGaac+jqgZDF37Fa8rlIdM8m0N0nz4lh8sd69wQahMvECTVkEO56o+bcHF
         7URIOkg9tjHQuuH54ZISEl2MYhK9czkO122yenNFzqx9+iYw9PTJh9H5sUZq8zKzChR4
         cxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690279733; x=1690884533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fyvH5/CqXN2xyIltDVXkOjkKF/iLXy53dgSSuhLOAj0=;
        b=EqHCcK7GV65XXR98KCEaGGkpWODFNp4xDQGsXJhr01OAusnY+IlGH7TLFQjgEoLoMZ
         jr41DTyQBLaIcDgsQicm0Bh4w9+OFIulQH0bZiUXbj2y85cRLfB8SMNsGWhyRnSiGeNr
         D/Cywv4ZCMRmP2zQtYrpXg/SgWH5RRxiKUTI5iJPF/04d3nUmWhOHLWo1rgTjR1gbwG+
         0KWT4fcnuZcV8wFv3AkQIU4PUYzBZzrPT2pYDxbeFwz36wlCuO5x/LKYiSHHnOHsM+cK
         S+FyDY+SacykfXujDI7lbF3TNUWwc4LO8PMl0k5iFZYtKAxPM6F6w5NXtR1eYdO9Pwqr
         LLcg==
X-Gm-Message-State: ABy/qLbmUA9aRRAazM8ZcaPLGx6UEbTF/y2/wanytYwK8DgtW3fKjc4+
        LTM8HBy6y4MqP/SpKlaVH1Y=
X-Google-Smtp-Source: APBJJlHBgLCInRfOhlF5JhOCJk8tS5ZZ29zhyCkWr90Y7UZ/fxc51EGqVF/cGuzWZNclLL4BhbXvrQ==
X-Received: by 2002:a17:902:e88d:b0:1b3:ea47:796c with SMTP id w13-20020a170902e88d00b001b3ea47796cmr11866307plg.29.1690279732998;
        Tue, 25 Jul 2023 03:08:52 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.35])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090274c300b001b80b428d4bsm10649940plt.67.2023.07.25.03.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 03:08:52 -0700 (PDT)
From:   Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>
Subject: [PATCH] kvm: vmx: fix a trivial comment in vmx_vcpu_after_set_cpuid()
Date:   Tue, 25 Jul 2023 18:08:44 +0800
Message-Id: <20230725100844.3416164-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
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

The commit b6247686b7571 ("KVM: VMX: Drop caching of KVM's desired
sec exec controls for vmcs01") renamed vmx_compute_secondary_exec_control()
to vmx_secondary_exec_control(), but forgot to modify the comment.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..26d62990fea7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7722,7 +7722,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
+	/* xsaves_enabled is recomputed in vmx_secondary_exec_control(). */
 	vcpu->arch.xsaves_enabled = false;
 
 	vmx_setup_uret_msrs(vmx);
-- 
2.39.3

