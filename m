Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679341E8226
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgE2PlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:41:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21462 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727937AbgE2Pjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YC3OJcl/1YFr/W5Rzm84rCa+C/la6QzSmr9rBY2bGNU=;
        b=KVUxSvPIQX1d0zCd9zaXhOSJrmnZjDIX9a6DkGk8HRYwrOTWUwekDX+yQZ/txJIPStJISI
        sOtPXjS7n4E+YWMGPFMz0mBhl2I8Tf+4M2tMRVFirUGtHM/Wfvm+7PTYgNwpV6liNKiGRy
        cchMDliFojM2zFE5tGieZCdQO3EqH/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-cr1rTtkSN9KZupoZ7pDv8w-1; Fri, 29 May 2020 11:39:46 -0400
X-MC-Unique: cr1rTtkSN9KZupoZ7pDv8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60D68460;
        Fri, 29 May 2020 15:39:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08068A09A5;
        Fri, 29 May 2020 15:39:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 18/30] KVM: nSVM: remove unnecessary if
Date:   Fri, 29 May 2020 11:39:22 -0400
Message-Id: <20200529153934.11694-19-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index b710e62ace16..7383f821eb3b 100644
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


