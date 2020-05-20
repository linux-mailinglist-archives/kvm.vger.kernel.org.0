Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A691DBB26
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgETRWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51725 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727964AbgETRWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8SK9YQtue71WyQs46tC99v9KZ5RewVoWZvvkNYRnCm4=;
        b=bPpms5zMvj68NgiM9D0VWHyNo8+xqJEYl0+YQWDFwSGSMkBzPqv5Uz5UV1lj7/LQsHKOU+
        sFQEV8m1cVX9Off4J8IcgC1UnnDjTTq6QdGFpvSmsmWSkSEqXxi9AYGIJCXtP+3xTWM0/E
        G/GVNNkVqAyytpTVRqNowYBMwpn25UM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-VyH9usssMAayu-jCYhDgqQ-1; Wed, 20 May 2020 13:22:01 -0400
X-MC-Unique: VyH9usssMAayu-jCYhDgqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED63C57093;
        Wed, 20 May 2020 17:21:59 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 538DA797EE;
        Wed, 20 May 2020 17:21:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 11/24] KVM: nSVM: remove trailing padding for struct vmcb_control_area
Date:   Wed, 20 May 2020 13:21:32 -0400
Message-Id: <20200520172145.23284-12-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
2.18.2


