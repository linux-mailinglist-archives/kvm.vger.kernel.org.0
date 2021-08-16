Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF463ED862
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhHPOBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:01:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhHPN6t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=86AjNMQBBI/biMMBre0wJEFayw5cohkZhTxP/vuqbGY=;
        b=O8axeF+QRx13KAf6bBNV9n/cEkEeynGcjZquzab6Drg0m/7b0Q6ZLomNix7MQVg+4I+U/X
        gqJ8ZAVg1d9yQtiN8DtuvEHj+itl+nflOi795Y2HMS8ENeOPdYVqrhcxSr6A2OMxpRoeBj
        0lZgQpwwFxcDorVexeim8kaqUuNUrWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-bQJOFIbOOeWklPz6X80c1g-1; Mon, 16 Aug 2021 09:57:34 -0400
X-MC-Unique: bQJOFIbOOeWklPz6X80c1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4EDD18C9F53;
        Mon, 16 Aug 2021 13:57:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8533560939;
        Mon, 16 Aug 2021 13:57:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [FYI PATCH] KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
Date:   Mon, 16 Aug 2021 09:57:32 -0400
Message-Id: <20210816135732.3836586-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

If L1 disables VMLOAD/VMSAVE intercepts, and doesn't enable
Virtual VMLOAD/VMSAVE (currently not supported for the nested hypervisor),
then VMLOAD/VMSAVE must operate on the L1 physical memory, which is only
possible by making L0 intercept these instructions.

Failure to do so allowed the nested guest to run VMLOAD/VMSAVE unintercepted,
and thus read/write portions of the host physical memory.

Fixes: 89c8a4984fc9 ("KVM: SVM: Enable Virtual VMLOAD VMSAVE feature")

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 28381ca5221c..e5515477c30a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -158,6 +158,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
 	if (!intercept_smi)
 		vmcb_clr_intercept(c, INTERCEPT_SMI);
+
+	vmcb_set_intercept(c, INTERCEPT_VMLOAD);
+	vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
-- 
2.27.0

