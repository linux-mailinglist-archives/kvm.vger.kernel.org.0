Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2340745995D
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhKWAyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:54:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232493AbhKWAxv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CcDTjMD3SEGcymVAD99+j16SruUIo4hZm4EwqVGhwmk=;
        b=C1udUpX2sZ8NCO+8RH3p3mPDseX0on15nVTPk7jg1nWQppJ8bjU27kkqcQz+G/NhUyjPrT
        AcJFmpTyIis7Uqc/1wE65ZFBXeRFbTh1VpGQcxd7++jZTMHpuyu7JENO05uIZh73UFvJaS
        aDEETY3SRaEO5C4Ont3My1BY6BtCJ8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-305-UHzDGJsCMo2fsNJ5t3-PkA-1; Mon, 22 Nov 2021 19:50:40 -0500
X-MC-Unique: UHzDGJsCMo2fsNJ5t3-PkA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C441F8030D2;
        Tue, 23 Nov 2021 00:50:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75AB717567;
        Tue, 23 Nov 2021 00:50:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH 07/12] KVM: SEV: move mirror status to destination of KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Date:   Mon, 22 Nov 2021 19:50:31 -0500
Message-Id: <20211123005036.2954379-8-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow intra-host migration of a mirror VM; the destination VM will be
a mirror of the same ASID as the source.

Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc974c1728b6..c1eb1c83401d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1616,11 +1616,13 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
+	dst->enc_context_owner = src->enc_context_owner;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
+	src->enc_context_owner = NULL;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 }
-- 
2.27.0


