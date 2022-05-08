Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4C951EB56
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 06:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiEHEGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 May 2022 00:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiEHEG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 May 2022 00:06:28 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758386433
        for <kvm@vger.kernel.org>; Sat,  7 May 2022 21:02:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 204-20020a6302d5000000b003c273168068so5508312pgc.21
        for <kvm@vger.kernel.org>; Sat, 07 May 2022 21:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sg/z9wB+vuIltpOFgQrtfFOQSbXlfQQ5hBqOLh7V1Jk=;
        b=b4jc7kmScT4Ward96t4GFjs4dBw2N1zFStFtKFmKzWkWUrUQFbIsdfAD7RhNjDHm1Y
         soUARU1O/AnrB6O246nB7OihifDay9dNBgKXVly7Pk19kB+HKIu+KlPuxXpDW5XbgY+s
         7gqBbiYKIRnmMGdGPNXqILogjEiDhdIqYdi+dbT8Fq5Tb4VMSbHPAO10wPFdEM8mq2iq
         0DJB3hNOZVdD+pmqOFdHo9Vaw+jCuao6IMy/1N+32vPQ4wUYEqmicH5ikIPwE2RqnI3i
         o72ulceC5ZAvILHC4ejqyoWmjfuxcFmEVSGdxcyAwo64tTULY5oQorRv7g6y9zxIPgU9
         p3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sg/z9wB+vuIltpOFgQrtfFOQSbXlfQQ5hBqOLh7V1Jk=;
        b=OZvIasO6kOlacFHwzwJRLbPwXNBjLkgx/c9N62oQfVT790BuvfQmhmhL7u00O70j8h
         ZKuy3uvSW6iXcfIwbHl8idCDIfD3dpZtpXd94xtdnGemMoyscl/w8kgSGiVVFWEVPl83
         6tuT0hHBQnlstixluzpp6Tc0g19lR1eNuLvGGIRZWE6eK2/6CIK4YCpePtbcBCpy6YCZ
         tYFwR2meB8iQLexQ+YC+5234uUUZVRgbvgcoKtIWF4DnReRdhItYMth+cWpiVfh6xw4O
         ejR1LdUZ1dvJlW0XlSl0tOipk3pL3BezLPLHiDxKXbdA9PNPVQLYYyDftre6Q61tA9Va
         tReA==
X-Gm-Message-State: AOAM531+vmIG/HpO9GyO27C97Z+f8Tozgt6LzyueV/cArRgB9JnZ7MXO
        Je5icKTm+4g/+TNciRFo7dfRISppq/fpD3cfU7GQ9yYQfAeBroxEYY0nQIglYUpxfYCiV6HZ2gY
        UKLgw4Xhboss27bIG8zGQ7PMdU0pHCIoQ3vD/Ls5VDDYs5ZEncIVQHuWUsSRoLNc=
X-Google-Smtp-Source: ABdhPJwdnalMGVHkJEDJUjc5fIke7pFOOWp383/wyMZy2tp84cotFm9Zz96OPK7hxrL3+D67Z6DCkhiJAmmALA==
X-Received: from hawksbill.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:55dc])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4b51:b0:1dc:9172:f344 with SMTP
 id mi17-20020a17090b4b5100b001dc9172f344mr12048358pjb.130.1651982557849; Sat,
 07 May 2022 21:02:37 -0700 (PDT)
Date:   Sat,  7 May 2022 21:02:33 -0700
Message-Id: <20220508040233.931710-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2] KVM: VMX: Print VM-instruction error when it may be helpful
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
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d58b763df855..a25da991da07 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -392,12 +392,14 @@ noinline void vmwrite_error(unsigned long field, unsigned long value)
 
 noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmclear failed: %p/%llx err=%d\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
 {
-	vmx_insn_failed("kvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
+	vmx_insn_failed("kvm: vmptrld failed: %p/%llx err=%d\n",
+			vmcs, phys_addr, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
 noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
-- 
2.36.0.512.ge40c2bad7a-goog

