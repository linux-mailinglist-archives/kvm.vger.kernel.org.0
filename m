Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF35574DB7
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 14:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404479AbfGYMEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 08:04:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42950 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfGYMEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 08:04:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so579354wrr.9
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 05:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATZLcaR/HIow2boROv7fCJVEaRNc/1d0DL3a+Phooao=;
        b=XJKdexeUifEpsDgpdmmmWLxbCItm2C7kX5SYeEQ+O39zbuASSzxXgM7lCLpn17Pcmb
         yTD6a3n8qJm7H7OsNzdxUd1Pe6SHBqjRSsgbt6lLX0pzXWx3D2xMkTJ+yvI9+CSwBrQs
         WruB+YpBktp9eYaeQ7p+/q3FCDuET472orwHgNH77mFHvKK5ZYs2Zq59mvwkENylh+dk
         NmDfID2UaD4pXTo62Y8f4sTo0MC4CHw+puob8PfrsT+gF/4kBJzMmA1gqlQunoGnHXrt
         q1reTNJJQfDTs8/CUndVWy8seBCqnGxw3Yzgl7Q8BHNqspQqWVY+cBSR7MU/0E3iIZmH
         5dRw==
X-Gm-Message-State: APjAAAXtOZdK0KztA4J1nelVlmZubIO0UxUZnx+pOX4dA+lOInc0qKrM
        xj+P3pS3HTs6qDpiZuA/VK1Xgg==
X-Google-Smtp-Source: APXvYqxtPp1xiigUHF5IAWdhvDJjoUGWQcNlA5s+H6uYrJtpLmI8AduvNTKlhwxemRJWDcAFVTnyDA==
X-Received: by 2002:adf:df8b:: with SMTP id z11mr38719748wrl.62.1564056280351;
        Thu, 25 Jul 2019 05:04:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j6sm73793424wrx.46.2019.07.25.05.04.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 05:04:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.2 2/3] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
Date:   Thu, 25 Jul 2019 14:04:35 +0200
Message-Id: <20190725120436.5432-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725120436.5432-1-vkuznets@redhat.com>
References: <20190725120436.5432-1-vkuznets@redhat.com>
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
index b72d6aec4e90..df6e26894e25 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -210,6 +210,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	free_vpid(vmx->nested.vpid02);
-- 
2.20.1

