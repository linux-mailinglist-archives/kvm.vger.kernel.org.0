Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F063EB46C
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbhHMLM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239980AbhHMLM4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628853149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWdStXIJRAZUn89ySAVq1oGCWEMCV5Lj22U/4x5LZTA=;
        b=URPMfmJ0u955CI7nklK0pMkegYn7ordwMvZCHEaVyUgZenTJDuOOPQroVe1FOpvOdecxw2
        VQV/CR4zfkVtH1R4eTVDUfuYXwUXEHhIPL0HO6Zca1bSeVkqgncvdmpgC66CjOtHx4Lq6B
        PI/jAL9MA02izsbEYl7AOUEr+NNOopw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-BcBvb5P9MH6iQpLSE_BbSQ-1; Fri, 13 Aug 2021 07:12:28 -0400
X-MC-Unique: BcBvb5P9MH6iQpLSE_BbSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A1087D544;
        Fri, 13 Aug 2021 11:12:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C848560C05;
        Fri, 13 Aug 2021 11:12:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     babu.moger@amd.com
Subject: [PATCH kvm-unit-tests 2/2] access: treat NX as reserved if EFER.NXE=0
Date:   Fri, 13 Aug 2021 07:12:25 -0400
Message-Id: <20210813111225.3603660-3-pbonzini@redhat.com>
In-Reply-To: <20210813111225.3603660-1-pbonzini@redhat.com>
References: <20210813111225.3603660-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cull more tests if EFER.NXE=0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/access.c b/x86/access.c
index 6285c8c..4725bbd 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -324,6 +324,8 @@ static _Bool ac_test_legal(ac_test_t *at)
      */
     reserved = (AC_PDE_BIT51_MASK | AC_PDE_BIT36_MASK | AC_PDE_BIT13_MASK |
 	        AC_PTE_BIT51_MASK | AC_PTE_BIT36_MASK);
+    if (!F(AC_CPU_EFER_NX))
+        reserved |= AC_PDE_NX_MASK | AC_PTE_NX_MASK;
 
     /* Only test one reserved bit at a time.  */
     reserved &= flags;
-- 
2.27.0

