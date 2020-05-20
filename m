Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BC71DBB45
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgETRX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53366 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728097AbgETRWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Juz3RPZ1E1zRyR+zIZIUrmPTzlSyrk4ogMhENNPsAtc=;
        b=MIIm97Nw/ELgFWEMIaKZl0HdTSRUPwT8o5s+iUmSoxz2JAIZ49sFhMNmCxuHVhPuYq54yS
        /QqGf6RHiOBHgB2Ncz/LCn4y75Vrs7gxtPNVhMo8yItl84VNPNLpIEYPUPS4Ls7NdiQvHM
        56BiEwdfWx6ThAzLnAvD8tMxX6M4Jro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-GvKraeOsPRqgU6IBSguXNQ-1; Wed, 20 May 2020 13:22:10 -0400
X-MC-Unique: GvKraeOsPRqgU6IBSguXNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E1F28B785F;
        Wed, 20 May 2020 17:22:01 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC7E270461;
        Wed, 20 May 2020 17:22:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 13/24] KVM: nSVM: do not reload pause filter fields from VMCB
Date:   Wed, 20 May 2020 13:21:34 -0400
Message-Id: <20200520172145.23284-14-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 9999bce9adcf..b6a1e1ff271e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -533,11 +533,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.event_inj         = 0;
 	nested_vmcb->control.event_inj_err     = 0;
 
-	nested_vmcb->control.pause_filter_count =
-		svm->vmcb->control.pause_filter_count;
-	nested_vmcb->control.pause_filter_thresh =
-		svm->vmcb->control.pause_filter_thresh;
-
 	/* We always set V_INTR_MASKING and remember the old value in hflags */
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-- 
2.18.2


