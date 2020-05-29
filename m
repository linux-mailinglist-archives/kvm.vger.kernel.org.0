Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7C71E822F
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgE2Pld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:41:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727902AbgE2Pjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWMuLu+D+5hDBHITPYz9gQFGs3iVcOHE/1FDulotv2A=;
        b=ImgMkJqVQuI5vGUcXBsEK/ei/lxdAju0sgsFo5x47iz0qjKYaAiOoHhOt4GLCbnFLjsDJ1
        +lb7AhiU8PLEWnD9U6PrPYKomtfXHWq3LQtY0H29SeuAzmNx4rwFnGp8su7or1xAqAvOoR
        Uj4eV+7UlXMaebQhYBCvJJnY7yx+Fa0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-_dTK_4D_P_KRiRryCAd7jQ-1; Fri, 29 May 2020 11:39:44 -0400
X-MC-Unique: _dTK_4D_P_KRiRryCAd7jQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48E90107ACCD;
        Fri, 29 May 2020 15:39:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E483E78366;
        Fri, 29 May 2020 15:39:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 14/30] KVM: nSVM: remove trailing padding for struct vmcb_control_area
Date:   Fri, 29 May 2020 11:39:18 -0400
Message-Id: <20200529153934.11694-15-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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


