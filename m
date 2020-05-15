Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E907F1D5831
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgEORmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:42:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726585AbgEORl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 13:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Q9NYEIPN4sY5xLXHC6u/MLKHvdmibx5ZlJo97Gfa99w=;
        b=GNpCPjOuzBmEEi7L4B9SxU7uRA/j9AyKD/IqQTQP0M/CED/3VaKmFMSPtIZGSZ98Zgbcec
        f+LiRIhVo9mosByKrFhFv7BnFK3GbhLjTd3VWZTxDgNRrQRuOlwHY84Q/RBKXLzZ0CZHvq
        6m5pA6WznjEw0KYjuYqRF6RhNXvwR4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-j53BVrV-O3icE3cS__9I7A-1; Fri, 15 May 2020 13:41:52 -0400
X-MC-Unique: j53BVrV-O3icE3cS__9I7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C61B8014D7;
        Fri, 15 May 2020 17:41:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9488F10002CD;
        Fri, 15 May 2020 17:41:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 6/7] KVM: nSVM: do not reload pause filter fields from VMCB
Date:   Fri, 15 May 2020 13:41:43 -0400
Message-Id: <20200515174144.1727-7-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields do not change from VMRUN to VMEXIT; there is no need
to reload them on nested VMEXIT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e3338aa8b0a3..ba7dedbcc985 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -544,11 +544,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.event_inj         = 0;
 	nested_vmcb->control.event_inj_err     = 0;
 
-	nested_vmcb->control.pause_filter_count =
-		svm->vmcb->control.pause_filter_count;
-	nested_vmcb->control.pause_filter_thresh =
-		svm->vmcb->control.pause_filter_thresh;
-
 	/* We always set V_INTR_MASKING and remember the old value in svm->nested */
 	if (!(svm->nested.int_ctl & V_INTR_MASKING_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-- 
2.18.2


