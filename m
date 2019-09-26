Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE754BF4DD
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfIZOP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 10:15:26 -0400
Received: from mail.codelabs.ch ([109.202.192.35]:57710 "EHLO mail.codelabs.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfIZOPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 10:15:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 49E7CA0167;
        Thu, 26 Sep 2019 16:05:52 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h7q0wHkKej5w; Thu, 26 Sep 2019 16:05:50 +0200 (CEST)
Received: from skyhawk.codelabs.ch (unknown [192.168.10.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.codelabs.ch (Postfix) with ESMTPSA id 38CC8A0166;
        Thu, 26 Sep 2019 16:05:50 +0200 (CEST)
From:   Reto Buerki <reet@codelabs.ch>
To:     kvm@vger.kernel.org
Subject: [RFC PATCH] KVM: VMX: Always sync CR3 to VMCS in nested_vmx_load_cr3
Date:   Thu, 26 Sep 2019 16:05:41 +0200
Message-Id: <20190926140541.15453-2-reet@codelabs.ch>
In-Reply-To: <20190926140541.15453-1-reet@codelabs.ch>
References: <20190926140541.15453-1-reet@codelabs.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Required to make a Muen system work on KVM nested.

Signed-off-by: Reto Buerki <reet@codelabs.ch>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41abc62c9a8a..101b2c0c8480 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1008,6 +1008,8 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		}
 	}
 
+	vmcs_writel(GUEST_CR3, cr3);
+
 	if (!nested_ept)
 		kvm_mmu_new_cr3(vcpu, cr3, false);
 
-- 
2.20.1

