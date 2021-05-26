Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A8B3918B0
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhEZNXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233482AbhEZNXk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d99aGCoF6uSJVgij0eLUvqWD/8Yji00xXrXe1sVq/4Y=;
        b=MAjopSt66IToQ7MI/CD9+rOvoqoBRNsCyzdj1UplNjaSR2/yiFFUeECoc66CgjZGuDDLJc
        H7B2azWZ2AV6429pZlSSxgV3Asmd8qjKjTuAog1vRkxy49u8BkfevbycPHTUZ/QpmxzWzH
        +29R4VZhNDMND4jwOQWXMd60i+Gs0ZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-WWiLy8kMPfmAZLDyuKqenw-1; Wed, 26 May 2021 09:21:15 -0400
X-MC-Unique: WWiLy8kMPfmAZLDyuKqenw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 756C5108BD07;
        Wed, 26 May 2021 13:21:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7B85D9C6;
        Wed, 26 May 2021 13:20:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/11] KVM: nVMX: Make copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12() return 'void'
Date:   Wed, 26 May 2021 15:20:19 +0200
Message-Id: <20210526132026.270394-5-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12() don't return any result,
make them return 'void'.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ea2c52aad8f0..3640a86f1ce3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1587,7 +1587,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 }
 
-static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
+static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
@@ -1800,10 +1800,10 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 	 * vmcs12->exit_io_instruction_eip = evmcs->exit_io_instruction_eip;
 	 */
 
-	return 0;
+	return;
 }
 
-static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
+static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
@@ -1963,7 +1963,7 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 
 	evmcs->guest_bndcfgs = vmcs12->guest_bndcfgs;
 
-	return 0;
+	return;
 }
 
 /*
-- 
2.31.1

