Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C74C2EB7
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiBXOyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiBXOyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:54:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 238FE254553
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645714449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nEhdWtMkHDnA/KPqof56Qj8ElfqWI75Bl68T1Q+UmUY=;
        b=EMMx0Oiw1i0sTVNzuBKlwcGfDGtpQsJKVlTsGo8m4FUPWoqUx4i7KYTd85r9+JQQ+qxW6Z
        SqgCfimcCTpW7/0A7ouJtdGIpDapt/WpLewHrR3gxz8v6rx/pOzKJcuBzUfivZrv13UFZr
        /Ic+5hCGMS2v0qqDTHf6a7UerMADRfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-EOlyh7jnMRGHILKnPRr2-w-1; Thu, 24 Feb 2022 09:54:05 -0500
X-MC-Unique: EOlyh7jnMRGHILKnPRr2-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A84DB801AAD;
        Thu, 24 Feb 2022 14:54:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 585937F0DD;
        Thu, 24 Feb 2022 14:54:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Chao Gao <chao.gao@intel.com>
Subject: [PATCH] KVM: x86: Do not change ICR on write to APIC_SELF_IPI
Date:   Thu, 24 Feb 2022 09:54:03 -0500
Message-Id: <20220224145403.2254840-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulating writes to SELF_IPI with a write to ICR has an unwanted side effect:
the value of ICR in vAPIC page gets changed.  The lists SELF_IPI as write-only,
with no associated MMIO offset, so any write should have no visible side
effect in the vAPIC page.

Reported-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ad8857359ad6..d5a33b6be7d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2120,10 +2120,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
-			kvm_lapic_reg_write(apic, APIC_ICR,
-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
-		} else
+		if (apic_x2apic_mode(apic))
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
+		else
 			ret = 1;
 		break;
 	default:
-- 
2.31.1

