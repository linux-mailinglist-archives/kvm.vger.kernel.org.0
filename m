Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CFB463490
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 13:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbhK3Ml1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 07:41:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241786AbhK3MlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 07:41:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638275872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DYBPaw09dsxTzcX0XlGoikC3Bax4b+azuiiGb7GE7BA=;
        b=U1M61i7ozXM+RubMhKP20a6akjD3jD2rINv+1+jIhbUR+xXsx9U1HqaXWCcPIOs98tJXr9
        OaORxptMowI6dJnLVkREd3+XxS1jZcU6pwUQE2+lTadKwiaOL49M+fklkZQ23SsGyotkpH
        qbPlDRfkcoGX66fNFnTzT6ygLGAoFIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-AdZ-0Zg5NqubD06LHAr0gw-1; Tue, 30 Nov 2021 07:37:48 -0500
X-MC-Unique: AdZ-0Zg5NqubD06LHAr0gw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 998F4102CB73;
        Tue, 30 Nov 2021 12:37:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 591A410013D6;
        Tue, 30 Nov 2021 12:37:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Date:   Tue, 30 Nov 2021 07:37:46 -0500
Message-Id: <20211130123746.293379-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is nothing to synchronize if APICv is disabled, since neither
other vCPUs nor assigned devices can set PIR.ON.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ca1fd93c1dc9..9453743ce0c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7778,10 +7778,10 @@ static __init int hardware_setup(void)
 		ple_window_shrink = 0;
 	}
 
-	if (!cpu_has_vmx_apicv()) {
+	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
+	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
-	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
-- 
2.31.1

