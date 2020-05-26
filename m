Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56A1E28AD
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389486AbgEZRZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389195AbgEZRX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWMuLu+D+5hDBHITPYz9gQFGs3iVcOHE/1FDulotv2A=;
        b=TRgNf435B4D0n7eDZsuJ3zdupWdjH1fsB25/HqrExxzy7jamns4SRB0rwfeplW3ojCUyin
        QvnHMGzaJG1Ujw+U3YUqcVPIxXazZkzry8cuBg7NAj6K1TDv8ZJXKX46ZccB1P49Pe3GqL
        x00GRAD6FxBX1EmMGpufwRxY9FOHYPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-GjesUvQwNiOUcKPoOOjLMw-1; Tue, 26 May 2020 13:23:23 -0400
X-MC-Unique: GjesUvQwNiOUcKPoOOjLMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68617107ACF3;
        Tue, 26 May 2020 17:23:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3A055C1D6;
        Tue, 26 May 2020 17:23:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 14/28] KVM: nSVM: remove trailing padding for struct vmcb_control_area
Date:   Tue, 26 May 2020 13:22:54 -0400
Message-Id: <20200526172308.111575-15-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow placing the VMCB structs on the stack or in other structs without
wasting too much space.  Add BUILD_BUG_ON as a quick safeguard against typos.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/svm.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 6ece8561ba66..8a1f5382a4ea 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -96,7 +96,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_6[8];	/* Offset 0xe8 */
 	u64 avic_logical_id;	/* Offset 0xf0 */
 	u64 avic_physical_id;	/* Offset 0xf8 */
-	u8 reserved_7[768];
 };
 
 
@@ -203,8 +202,16 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 last_excp_to;
 };
 
+
+static inline void __unused_size_checks(void)
+{
+	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 0x298);
+	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != 256);
+}
+
 struct __attribute__ ((__packed__)) vmcb {
 	struct vmcb_control_area control;
+	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
 	struct vmcb_save_area save;
 };
 
-- 
2.26.2


