Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABB4496DE6
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiAVUOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 15:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiAVUOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 15:14:02 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B21C06173B
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 12:14:01 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id n8so754993lfq.4
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 12:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Jz8LmKaqAHX096dZGonDtmyNqqUFk4vvjZ0kHB8KOfo=;
        b=lboDjDcoZxEHwQaMXmFR0PbqMnzUBRy+voqOhyO3Qf5vtulzMjykH93gaq3yJXCw/Y
         bdrbizZwylT5XA5VImV1C1G4ECkYtgYjJhKtlAgx/iQYe82yl2Go3UdGri+2cL1hodZ3
         QRxgJPjKWN2TH4YUGe1n66b25YzNsuMAalAJFTvOeGJSXZ7h/UpsFXPCTvC8/QFzkarH
         7CMaN2NgjD/2HsxTy6R8YhG8x3rmdMTC8IZP4BmVEUO/g8Kr2DWzyRWpZ6aPDs3oSrZO
         ufQKPiC3g886PB5tpQzjMY3898+H5mcv6QL45jGm4eHVfgOmzCbXeXyszbhGy3GFFL7u
         quRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Jz8LmKaqAHX096dZGonDtmyNqqUFk4vvjZ0kHB8KOfo=;
        b=cjjNu8wyZwfaiHUHRUIq4q/HivsM7gaKPU5ttGhNUXEu6pU4t6ShH9rP+B4oztLgwY
         auBm+BVtilSe/lvnkXj3OwfryYm3Fv+pHCKPudZXoWyiZJbs3reUW7bzYIsUR8E9IZ1w
         XsSPRkBX5n9M/wwT0Bz7WvsXK7Zg/qnHloBXwLQnPfuk7Bsg14b7PmjdTWFLvVuxFvRw
         sXh1a0V2px8IeXA+LxEAcYbh2IJbJYeFTOgDmlN2+3ky62gA1KWmq9b28DIYA8J20xjh
         cSY+tisSomfu7T1Av3n+lCHMZsroMVc/g1r9Kddu0bmMjJRa/cGXKN+doZS1g1I7Hjky
         T73g==
X-Gm-Message-State: AOAM532/Uw8MZUT3Rm5OU4BVSFU8j+zp7vcOp7RvfM+Ea7kCEsNZ1KYY
        ALSPJY90Ci0Y6XAsJrZsjyjsfyMx0kc=
X-Google-Smtp-Source: ABdhPJwIkAMZayg8M3gHSjPp5WERFnHTB/LPDRQyqfXSt4hb/wbbRRZCSzzqmYcKsnHfstibBMEZXg==
X-Received: by 2002:a05:6512:280a:: with SMTP id cf10mr7760339lfb.539.1642882440046;
        Sat, 22 Jan 2022 12:14:00 -0800 (PST)
Received: from q ([46.39.55.190])
        by smtp.gmail.com with ESMTPSA id j25sm656737lfm.16.2022.01.22.12.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 12:13:59 -0800 (PST)
Date:   Sat, 22 Jan 2022 23:13:57 +0300
From:   Denis Valeev <lemniscattaden@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: nSVM: skip eax alignment check for non-SVM
 instructions
Message-ID: <Yexlhaoe1Fscm59u@q>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bug occurs on #GP triggered by VMware backdoor when eax value is
unaligned. eax alignment check should not be applied to non-SVM
instructions because it leads to incorrect omission of the instructions
emulation.
Apply the alignment check only to SVM instructions to fix.

Fixes: d1cba6c92237 ("KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround")

Signed-off-by: Denis Valeev <lemniscattaden@gmail.com>
---
This bug breaks nyx-fuzz (https://nyx-fuzz.com) that uses VMware backdoor
as an alternative way for hypercall from guest user-mode. With this bug
a hypercall interpreted as a GP and leads to process termination.

 arch/x86/kvm/svm/svm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e64f16237b60..b5e4731080ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2233,10 +2233,6 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 	if (error_code)
 		goto reinject;
 
-	/* All SVM instructions expect page aligned RAX */
-	if (svm->vmcb->save.rax & ~PAGE_MASK)
-		goto reinject;
-
 	/* Decode the instruction for usage later */
 	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
 		goto reinject;
@@ -2254,8 +2250,13 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
-	} else
+	} else {
+		/* All SVM instructions expect page aligned RAX */
+		if (svm->vmcb->save.rax & ~PAGE_MASK)
+			goto reinject;
+
 		return emulate_svm_instr(vcpu, opcode);
+	}
 
 reinject:
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
-- 
2.34.1

