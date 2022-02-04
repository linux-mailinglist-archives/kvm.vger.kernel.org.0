Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F394A98A5
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358591AbiBDL5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358517AbiBDL5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpMro66VpU3af97OW3y5FG1bjk0vC2VXc8qIJQfmWX8=;
        b=NRGnvSWtL+XnsIhuswn58tULCE072IXHz9j2GzUtfBoVg/iAtWNnw9xTXD3kW7lBzk8hsb
        EOE+1raZ33cQ2iGFz6dcj71KXNSxvxrppIEmVHsUzOBUzMIUgeOCOBRaxwIPYWrat93tGb
        xXQYPfwLbA5wZDLTTzz9pgEJvJate7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-XnIDk1q2M3KMRAyCv3C8qQ-1; Fri, 04 Feb 2022 06:57:21 -0500
X-MC-Unique: XnIDk1q2M3KMRAyCv3C8qQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C687190B2AD;
        Fri,  4 Feb 2022 11:57:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 112B71084186;
        Fri,  4 Feb 2022 11:57:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 02/23] KVM: MMU: nested EPT cannot be used in SMM
Date:   Fri,  4 Feb 2022 06:56:57 -0500
Message-Id: <20220204115718.14934-3-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The role.base.smm flag is always zero, do not bother copying it over
from vcpu->arch.root_mmu.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9424ae90f1ef..b0065ae3cea8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4881,9 +4881,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 {
 	union kvm_mmu_role role = {0};
 
-	/* SMM flag is inherited from root_mmu */
-	role.base.smm = vcpu->arch.root_mmu.mmu_role.base.smm;
-
 	role.base.level = level;
 	role.base.has_4_byte_gpte = false;
 	role.base.direct = false;
-- 
2.31.1


