Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3991C4640
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgEDSrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727799AbgEDSrJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 14:47:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EECC061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 11:47:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x4so654515wmj.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 11:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgCs0wkVJtVHte9mm7xQ9ul/9fE/hpJWdtuiVOjQk7o=;
        b=gsTMd9LifTAISFhc6cN82h70sRdFoOz/zSiSbTjT/DpfUMiMAb/oYemkZG+pA6Swy0
         qO9Hb+DTok5EYTsfmcNL/B4ZO2KiWr6Q2B9kscHkmP+OM4g7c5Xd/vV/8M5swSKV0clJ
         9Qsrn/ZoD1sv2lw0iISCqnFq5nqIQosaJPdiaByycbnVcXACO1PA5BSnFxg4vkfgFYcK
         LdYRCTq2wfXVeyAUgQ8f2o2kAIm9bFGGOc+qyfj6pXK94MwSpbHdSFAOlHuKQ5QVA4am
         H39L2E40UFeKvBmncGs0EPPq50hU+usoVxmlEnskw1UUkKsfBYytYjzmpbG8od55HfKx
         /y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MgCs0wkVJtVHte9mm7xQ9ul/9fE/hpJWdtuiVOjQk7o=;
        b=XonbQcEMT1KfC4SNzeFKWsu7NM+WLuQQSk1g1UsVvRUhnDi/a1azVknMqvIiya6MrL
         +ky3oF7X9VZeSyE6pmpg/wpgMd/R/Zi77+gnWICXKxWZYvtc6U+3ruWICLzGcXAf530R
         TYMsI/HlL0OlYCzXKZ0tDwE07ZJT/ke0/cnr/ehaDWLqeSf7XsXVZVzXCYCUZu74NSuC
         HD4yQ6M9+sGj+8IAQCip6UGwzmj8Sv9bwO/tQd57kal/XJAIBxOMx2DxqkYU678LVjAX
         928KGRWI7zNXSbQ6fbZdvxxzteDJlegjgo0wk4+QsMczRYWlh6cotR0IifxZYGz72hz0
         Y8Yg==
X-Gm-Message-State: AGi0PuZrB17tHgRBRmY5jt5h4x3ep/GJkMD44tjRlvFh4icK3T69FfwY
        EFO50zpdM29hm2HBOlkbaLXcS3c8G5Y=
X-Google-Smtp-Source: APiQypL+ZUWqwyqa9k4GbCajREHbBcPh5EauxpvUjaZvLpKERGfUgLegtliUFDSPMUj65kur6eXbtg==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr15395855wmh.47.1588618027914;
        Mon, 04 May 2020 11:47:07 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id y18sm470842wmc.45.2020.05.04.11.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:47:07 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: VMX: Fix operand constraint of PUSH instructions
Date:   Mon,  4 May 2020 20:47:00 +0200
Message-Id: <20200504184700.3078839-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PUSH instructions can't handle 64-bit immediate operands, so "i"
operand constraint is not correct. Use "re" operand constraint
to limit the range of the immediate operand to a signed 32-bit
value and also to leave the compiler the freedom to pass the value
via a register.

Please note that memory operands are not allowed here. These
operands include stack slots, and these are not valid in this
asm block due to the clobbered %rsp register.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22f3324600e1..56c742effb30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6299,9 +6299,9 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		:
 		[thunk_target]"r"(entry),
 #ifdef CONFIG_X86_64
-		[ss]"i"(__KERNEL_DS),
+		[ss]"re"(__KERNEL_DS),
 #endif
-		[cs]"i"(__KERNEL_CS)
+		[cs]"re"(__KERNEL_CS)
 	);
 
 	kvm_after_interrupt(vcpu);
-- 
2.25.4

