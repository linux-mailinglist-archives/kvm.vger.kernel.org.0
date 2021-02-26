Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF9326109
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhBZKM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:12:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231151AbhBZKKZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 05:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614334139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G43y8SBbvkYh1R+y/15Z6f9RmEMjkgNDToKDDC5hPAE=;
        b=Q/m6eU1raym/Sgyr0O+42fgD7itP8gT7mXrC2R816T7GGL1s+htEbR4OVtLany0fdlDx42
        GbdZ58Jr4b88tdOGYyAU2hhD97vMNmCgwyBaKFaC40M/mqBww1iAk4u75HucNMn1snF2jf
        steAiv974pN13GWTnocwWnd0kBQ+7rU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-gZGwslxfNUesa8OLxzqTqQ-1; Fri, 26 Feb 2021 05:08:55 -0500
X-MC-Unique: gZGwslxfNUesa8OLxzqTqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6F5980196C;
        Fri, 26 Feb 2021 10:08:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FC6F18A77;
        Fri, 26 Feb 2021 10:08:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: flush deferred static key before checking it
Date:   Fri, 26 Feb 2021 05:08:53 -0500
Message-Id: <20210226100853.75344-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A missing flush would cause the static branch to trigger incorrectly.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d2bc89431a2..bfc928495bd4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8039,6 +8039,7 @@ void kvm_arch_exit(void)
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_fpu_cache);
+	static_key_deferred_flush(&kvm_xen_enabled);
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 }
 
-- 
2.26.2

