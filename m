Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B609274A04
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIVUTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 16:19:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbgIVUTl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 16:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600805980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYUw7on53U22xygxI96tyg7A07dVivNHpOasjcBU6xE=;
        b=KK3CueDHnDmi1ASk9v5HnzGDDQRORg2sXQktK+g+b7nB8/2S9CgVIj7C12j/CCO9FCYhrq
        vTvzWHAMRMepVflcWhYILB7C4ggaG38QS/1N1qqXoiFxVA16jENmhjm1HMVsdgeRutUDEK
        qnyuPIifKKvmvGriUpGDCA8VyU/OpLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-qWR7WA25Mr63xgyCP0dkpg-1; Tue, 22 Sep 2020 16:19:38 -0400
X-MC-Unique: qWR7WA25Mr63xgyCP0dkpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0283C8B124D;
        Tue, 22 Sep 2020 20:19:37 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E406F5DD99;
        Tue, 22 Sep 2020 20:19:30 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/3] i386/kvm: Require KVM_CAP_IRQ_ROUTING
Date:   Tue, 22 Sep 2020 16:19:20 -0400
Message-Id: <20200922201922.2153598-2-ehabkost@redhat.com>
In-Reply-To: <20200922201922.2153598-1-ehabkost@redhat.com>
References: <20200922201922.2153598-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_IRQ_ROUTING is available since 2009 (Linux v2.6.30), so
it's safe to just make it a requirement on x86.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 9efb07e7c83..d884ff1b071 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2129,6 +2129,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
 
+    if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
+        error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
+        return -ENOTSUP;
+    }
+
     has_xsave = kvm_check_extension(s, KVM_CAP_XSAVE);
     has_xcrs = kvm_check_extension(s, KVM_CAP_XCRS);
     has_pit_state2 = kvm_check_extension(s, KVM_CAP_PIT_STATE2);
-- 
2.26.2

