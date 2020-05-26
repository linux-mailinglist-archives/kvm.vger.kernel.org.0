Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5D41E2892
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbgEZRXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389283AbgEZRXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EwYDsYOfWkvOXdIZq6xeSGLtmViex0XfUmWf4Uu92a0=;
        b=OzVeXWYjmmWq2JzJhPRWSiON+Q49dcN7MpZ98+l014caIi/EJCqhlcLtUw0Mx29MUKe1sR
        GN/X2tsSh5QdPVZQaDZoKJv1/CLPbDtEveYhC9MYPQFDaR6ciAMeTq04ihp3m5I9VMgb4a
        kSQsYg5VCQ6bXDi8VBSO9zlC8ROLb10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-dtvZkIV5MA2C4u-ABP01mA-1; Tue, 26 May 2020 13:23:43 -0400
X-MC-Unique: dtvZkIV5MA2C4u-ABP01mA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6617318A0778;
        Tue, 26 May 2020 17:23:42 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA6685C1BB;
        Tue, 26 May 2020 17:23:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 18/28] KVM: nSVM: remove unnecessary if
Date:   Tue, 26 May 2020 13:22:58 -0400
Message-Id: <20200526172308.111575-19-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_apicv_active must be false when nested virtualization is enabled,
so there is no need to check it in clgi_interception.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 97dbd6f65831..0654c5672b1a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2015,8 +2015,7 @@ static int clgi_interception(struct vcpu_svm *svm)
 	disable_gif(svm);
 
 	/* After a CLGI no interrupts should come */
-	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		svm_clear_vintr(svm);
+	svm_clear_vintr(svm);
 
 	return ret;
 }
-- 
2.26.2


