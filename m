Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFF29EDD4
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 15:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgJ2OFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgJ2OFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 10:05:04 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A0C0613D3
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 07:05:04 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l24so3140840edj.8
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 07:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/zaI+f/txWOZ0xKOmo7GdxyYlTLY1JVfc3R7UeR/0Es=;
        b=NUtVMLv4Bw7ze5Ck+7us9te0gtcg1z4NRTZNEWPgyk/T2jMCyV9AUI9YICZITwZxxa
         DZCM/DQum2kGGYx33N9OA3m5cVXOLukr9kIsetNG3I5duYRuOsXVHkooHjCQMQMZpb6S
         QPkgTI8WqqSJEU4Oit1abBpgv4Sp700qQd0df/zuLN2VL4wEOhIOZPe/8M0FduGQlHJA
         Yu3D7Fhke592NYsAxHlsKNDyFMaQVNrEdMcw/PCVr5fmMMt79nBeW47sixhNSgCZ335A
         9KLETq/nTN9Z6AiBWV0D80IjXDkubykVmZXT2+t/GcpMu81ANSQN3i0MnbLrdaHn4bVl
         MZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/zaI+f/txWOZ0xKOmo7GdxyYlTLY1JVfc3R7UeR/0Es=;
        b=btWhCh14fq2nkK8WUPXXF30WsJ47G4V0qALoY7ze+C2ffa/rBvBkGhac/GEeeHucr9
         qENMBrfpryhMpai8FOMwq2u4EsQ6fYiJRPTD+QcZpyrlplbDEu/KWBmpkPu4fHP5nRVl
         37Gp2FSZEHP593uhjmB7euJlxPDh8L0NLU+4efCZRoejdPkeSPBrRJQ+PCOToZxR1iSh
         swJY+y9SvVoblLVdpTOIbLkK19PJI/jk+uB8YXGsdP/xqr39jTIU8Ow1uHNLM8DS0/Ld
         9xOp5zWD4geP2gGcWPo7rcTuiP6fCBOfb7Jt4i+KQu/N/a7tNguh1co9yubk4ww6f+5/
         PLJQ==
X-Gm-Message-State: AOAM533ZY7C5JN6vTuFetD36Je/FZgp0HcGDqeepzCOCgQxeld0FEBj/
        Lh5815xC9y9nQB5BSgyCrg9OKmxviCZ2eQ==
X-Google-Smtp-Source: ABdhPJxwb7oKIvHT9vRy1RoHHsA6AkMv8uH5TUVNJM0gxmq1bUNDVbeL243iCPUrY6wPUDId2h7F8g==
X-Received: by 2002:a05:6402:207c:: with SMTP id bd28mr4016747edb.316.1603980302527;
        Thu, 29 Oct 2020 07:05:02 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id u23sm1531809ejy.87.2020.10.29.07.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:05:01 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S
Date:   Thu, 29 Oct 2020 15:04:57 +0100
Message-Id: <20201029140457.126965-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Saves one byte in __vmx_vcpu_run for the same functionality.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 90ad7a6246e3..e85aa5faa22d 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -132,7 +132,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	cmpb $0, %bl
+	testb %bl, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-- 
2.26.2

