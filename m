Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2EE19F8A8
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 17:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgDFPRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 11:17:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37569 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgDFPRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 11:17:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so18002930wrm.4
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 08:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXVE8TJv8F5tSrNhTDcrkaDZncqpLUWAn9zSrKTq+Rs=;
        b=IXf8uYc2495Ce3Pryp+hxFpjucYXIdeiXfFSgZ+BeqWbChU2v2dlfUlAHr3Gxv33P/
         jJCfIKllRcEdPCv3Id3+NHpTJbXEeL8svWkidAdVn51Vdbuxa0krexall1u7QrqmLq6Z
         uXTrFxudDWs9UBNPTJQEdOYBk6NnAQ0HKmPK0DGOWfGiGUYW6A5JJezjqEvyNATFX30P
         pHS+T0loG1DqptK2U1y3lXfCDk39cO7nAqBbuqltZz7DnpKLsgtaXjumW668PBd/Oq7s
         71xFr/RYLP33FEb8XvwxIdCbOAHkPRvkih3qZ4i1XePf6zXeMqx0yXSKFmiwXWZlLces
         Pa2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXVE8TJv8F5tSrNhTDcrkaDZncqpLUWAn9zSrKTq+Rs=;
        b=ghccHwis8DCP2yMfJwJtJbzs5n22lx2tWpk8ksUODBgJCjfrR8Pv6g7bMGHmlt77Pk
         ehdunsSm3zj3hTgwIUG1u50Nx1/2ROalrTOePXloHPzz+p+1eQwydSlX1w7J7gbuDBMS
         fVsW8EpU+DsDKmRGdEYhOzU2hgys6/xN/zrBG+L57vRIjc8BkHEwPHL4UH33R2u0vHTZ
         odijcRwhoK3Yqwb3iQGP4/AuF1YI6WyAPbK08PzuYtyL45LNVAav5KcnVyMZqtVm5MX7
         kP+JI0uD9VnDWPZzmIjz1AZdpmNKGNzVj1fGn60Nx8Oa43t8DBOMyFB1nanpZ+p2BVKS
         Ds5Q==
X-Gm-Message-State: AGi0PuaFM+V96uPUtKpFlEjow7EZkwGa6kQaNtemDQVBhTbLaCTUF8vO
        qgwwK7M5PHDGAOVf4lsydkekXio67JM=
X-Google-Smtp-Source: APiQypIcsiUD4IAYFBpjg+1gEtKg+PRRjyye3ImkoxaMZm2XaPbmvjxQftm1/UxreyxjYP9ARYdEfA==
X-Received: by 2002:adf:9d8a:: with SMTP id p10mr23210621wre.190.1586186228688;
        Mon, 06 Apr 2020 08:17:08 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id t16sm27939410wra.17.2020.04.06.08.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:17:08 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: VMX: Remove unnecessary exception trampoline in vmx_vmenter
Date:   Mon,  6 Apr 2020 17:16:41 +0200
Message-Id: <20200406151641.67698-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The exception trampoline in .fixup section is not needed, the exception handling code can jump directly to the label in .text section.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmenter.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 81ada2ce99e7..56d701db8734 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -58,12 +58,8 @@ SYM_FUNC_START(vmx_vmenter)
 	ret
 4:	ud2
 
-	.pushsection .fixup, "ax"
-5:	jmp 3b
-	.popsection
-
-	_ASM_EXTABLE(1b, 5b)
-	_ASM_EXTABLE(2b, 5b)
+	_ASM_EXTABLE(1b, 3b)
+	_ASM_EXTABLE(2b, 3b)
 
 SYM_FUNC_END(vmx_vmenter)
 
-- 
2.25.1

