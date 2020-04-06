Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0419FEF6
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFUVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 16:21:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52977 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFUVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 16:21:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id t203so804584wmt.2
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yhwj6D9mEJdqER0Y+4AiroLmLQuuXCILZXzQy7B5ijY=;
        b=ACqNNwoCwtOw7PW2cCGb8J1kgPMCAdYA88tbwN+EqfySTWksWv981gCezwlKWHBnwD
         gW2LlWxvprQbAHJPIvc2i2HgMq/PHei1PWqd6cpjzi9/ycj2TIELJgjNnPcg8yoQMYXN
         DLztQ1RD5JoeDjo6UOIy5wtVWKOCRknsUhO+qLzNDrxYWZixBO+hKSkMig97rLXA/wBj
         FCSUqqwEmJAgDDJWFO+tYdH5iPyFLNzwK0LH2HKCkCOl/OrEqkiQhXPh88GBbxqJWibC
         CUOn0Z5/5orM5EzVMMjCvfVOKTt27kfy7kKBDZx6FD4fgHHQYatYI99QbhvQAhWYggNq
         dIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yhwj6D9mEJdqER0Y+4AiroLmLQuuXCILZXzQy7B5ijY=;
        b=q37yq2xzNjQlYT2tKzV8HbznqJ459KfqgQa46eBPxiTos13EqQy9yM9mOf0WgMAt1d
         Q1bhFXIxNcli8JQiGhMSrSmWhjaQDtNh35h9a6d2TqBcvUhMHpj80EAxr5gOMWhA8xe0
         unEvISyK66l4hamquR78Nv57Q0Jodu1RQuOpXtOrqHBaenSawVaIorPw6CnCysyPAmdv
         k46wBS6p19leW6LiExieJeyiuqZkXxUW08QHnb5ICoAZaSS06SWoCZqthYardixzUvBZ
         VK1deRFwPeJOkBnszGZA6+h7HBTMv/8wRJptP7Eoh+ZKpDr7SpvlQwwdQ+RGBLIJCRPu
         yUJg==
X-Gm-Message-State: AGi0PuaDTP/R6jfZmIF38x4o6LM3gR9TGCddxROf+vtRUsFxZDZmiKpE
        k7PEBMl2PYgVO4jb1P14/xZ+Sa5r+m4=
X-Google-Smtp-Source: APiQypJUR3jy69e2suq6XDuLwa2KcHWNlmXrIQ6i8GtJ2IoEk1IutQzq+s23dcZRkFDzYtshVZRFmA==
X-Received: by 2002:a05:600c:291d:: with SMTP id i29mr744288wmd.135.1586204489596;
        Mon, 06 Apr 2020 13:21:29 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id n124sm868544wma.11.2020.04.06.13.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 13:21:28 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2] KVM: VMX: Remove unnecessary exception trampoline in vmx_vmenter
Date:   Mon,  6 Apr 2020 22:21:08 +0200
Message-Id: <20200406202108.74300-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The exception trampoline in .fixup section is not needed, the exception
handling code can jump directly to the label in the .text section.

Changes since v1:
- Fix commit message.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
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

