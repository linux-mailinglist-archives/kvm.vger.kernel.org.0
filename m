Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04EC5226FA
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 00:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiEJWks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 18:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiEJWkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 18:40:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C2422BD3
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:40:46 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso234509pjd.6
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GasP4zSpz0wP+Fxdc2/cSx85LEMPDIqCeAffi631kMw=;
        b=CojvtVn+H1DP+OIBOULCieyIdvKK7oaBOVuwoF3G4Tvt48IpKfA6mRckqqofQof9QS
         gSxFQbS378GbVKlwHRl92tM0vXOpECDVZKQAC/5mVG7O4Nl2Z/B7jgpS1oTEUAI2eBFe
         AOWfHNT6krhPCDIutWK9mfb5EjwH+QXVPNeG+1N99uxfNpRuHj/qac00RlPg2Frtn+VK
         p0p0aBMTzmSHvsHGIXiyzyhIJtsXlqEdf3Imd58me5/bBtj5W8/TWKHuWH0E+uDKZbrl
         bZi6v71FjpDRGOXDriwTDf2X68WGrib3Uk5+F+Tw8rmq/shUl8KvffF0UfBinVBtzgZq
         RRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GasP4zSpz0wP+Fxdc2/cSx85LEMPDIqCeAffi631kMw=;
        b=O+rPfLMkH1vWxiz6f+9O926ndiRi0IKuTx007ONrKtCmcupfGDwDiFv8VesEcLZAo3
         k6j81GNKYJiqrTpHDoEvrrYoqKKGAc/9k7hcYI9cPgPzZqhbNkA4eJVCdw79hyjcwDVN
         8i15ivjqSU/wef2qL363c791LAlXgSX88bDs4epq7QCS6bGs1LQT1Kwmg4gqHMfTSVub
         BPdGEyJId3Wgiii9cmRyeH19pT6pq0sCFqC8QKeoCzviwwhUTFk/0Fp5r7kW3lJ3Zh3J
         mcOhFX7IA3jRwpD0RLaRNU2OuINi95C46Du2eXGje4YetkMZAm/OemJnc7K5jBvbxqAg
         WK5Q==
X-Gm-Message-State: AOAM532iEyooKx1D1E2fffqxt77RNY5SyfD3YkEEFJs6vONy7cTNureK
        pyGr5YLfhiM3Yw/HzXMVPLY5iB0+iwiKK/QP0POREFz/h7edxZPwmYamCLZkEuRnAMeHBB3usLc
        0W8IC9dPuOvJufSBtN3YcNj6W+eQBQtU5DOEwBhxsb0OUQVrEP6Wsq/NiBMuZCZ4=
X-Google-Smtp-Source: ABdhPJxxYWZcyeW//dWNNqL7i1joaNi4D/67a+mIVmdUJaKD8CwIqgkT5KaNii+nW7VQv89TuZ1k6ZU0nWpYOw==
X-Received: from hawksbill.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:55dc])
 (user=jmattson job=sendgmr) by 2002:a17:902:ce8b:b0:15e:c249:1bf0 with SMTP
 id f11-20020a170902ce8b00b0015ec2491bf0mr22269935plg.125.1652222445684; Tue,
 10 May 2022 15:40:45 -0700 (PDT)
Date:   Tue, 10 May 2022 15:40:34 -0700
Message-Id: <20220510224035.1792952-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 1/2] KVM: VMX: Print VM-instruction error when it may be helpful
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

From: David Matlack <dmatlack@google.com>

Include the value of the "VM-instruction error" field from the current
VMCS (if any) in the error message for VMCLEAR and VMPTRLD, since each
of these instructions may result in more than one VM-instruction
error. Previously, this field was only reported for VMWRITE errors.

Signed-off-by: David Matlack <dmatlack@google.com>
[Rebased and refactored code; dropped the error number for INVVPID and
INVEPT; reworded commit message.]
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 v1 -> v2: Dropped changes to invvpid_error and invept_error.
 v2 -> v3: Changed printf format character from 'd' to 'u'

 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..3a76730584cd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -392,12 +392,14 @@ noinline void vmwrite_error(unsigned long field, unsigned long value)
 
 noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmclear failed: %p/%llx err=%u\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmptrld failed: %p/%llx err=%u\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
-- 
2.36.0.512.ge40c2bad7a-goog

