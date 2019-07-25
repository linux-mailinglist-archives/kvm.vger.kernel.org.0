Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53A474D7B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404342AbfGYLtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 07:49:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36995 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404314AbfGYLto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 07:49:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so44442773wme.2
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 04:49:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z59Fx3FchhtcYpGTAy6/0+pqXBGTFpbIQm7SLJs066s=;
        b=hPB+y1n3DGhqwTejfhuunmAh0if7stGpUKgZVwqDHxfa3apC6KOINiewBj7cUxVrHt
         +mikQR3U55aMPaxp1ZeucSZsvp6RcG2e8V8dcwrYnba7iRw8lMPIWeTPXmaZySHHL2HF
         QmwYkdNuHz2jpYzO3U4SQSKJ1Q23D2CyxF9VKCUXVvSfDd0tl0ufatjw/EJ/io+HyKd0
         bEfj5sw5E49jR8vejzv9u0jVhsOOTWnIMmVAz+65WnnuMpD8meZAST0MgzaTRWXs67Gj
         nMZoHr2d6WG3u4+MIjhQ1AwpwqLEfStWExG8q56pCiiOLOexT8CXR2F9UFr16ZbMZeMb
         cFAQ==
X-Gm-Message-State: APjAAAWZt84c+1mEKJJw4fxJZ58XA9cRdULMyDRGpt7b+uWDiIUSHeEW
        dVygOqd9p65G+Q6cRVto7nX/cg==
X-Google-Smtp-Source: APXvYqxRX1Odd/FqOub1CpfyIe42j8zssRTmGESC5RT9PX9QN36ChMZZssuNdKvI3JcnDGwivfGf1A==
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr3698651wmh.115.1564055382411;
        Thu, 25 Jul 2019 04:49:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 2/3] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
Date:   Thu, 25 Jul 2019 13:49:37 +0200
Message-Id: <20190725114938.3976-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725114938.3976-1-vkuznets@redhat.com>
References: <20190725114938.3976-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit cf64527bb33f6cec2ed50f89182fc4688d0056b6 ]

Letting this pend may cause nested_get_vmcs12_pages to run against an
invalid state, corrupting the effective vmcs of L1.

This was triggerable in QEMU after a guest corruption in L2, followed by
a L1 reset.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3f48006a43ec..f78975d4a7fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -212,6 +212,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	free_vpid(vmx->nested.vpid02);
-- 
2.20.1

