Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16493143E89
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgAUNsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:48:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44590 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAUNsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 08:48:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so3227055wrm.11;
        Tue, 21 Jan 2020 05:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=V4U+PI2PAOqbzfWZBcXXcxH5L3R8mP6ogQR4djjn9y4=;
        b=R1pRTr7a3ZtUe266qoFQlXBnmPdzSwJGCjQTmfGzEKfE2pUSq7003XYG07n+q/gyOk
         tdnvbMcO6KAQW6c+JrcQipTqeTYd+P2aj/sfxq/om1SBktNzJ/cTgidhl/aC7wnBaqBs
         oALXS3IJBUX5of3MbyqvUY4hdGKwl6VxFv3wRCIZ25OccOIZBvSaFYFUH4AP+6eGGdGl
         E8hPi8mPpHPrU5ESpf4Lw0gC/1qKv36CekvAnMk3IERAFgyz+X34qr6zFOZ7YkEXSpC5
         EdAP4ZGBZPdQUNSCMZYxf9Kwk51j1nokpmrLG2BmmuF0OjeeOcRaxlGLgUEw+w4IRlQx
         lLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=V4U+PI2PAOqbzfWZBcXXcxH5L3R8mP6ogQR4djjn9y4=;
        b=MKKBorZASEYbLtNrrrIlXTrzXTdCHo/Arw48W1sp5T9gaSNRgy5wag47z5/Lr7PQ9L
         2QeTcrh9L1WLDhrwYRlr9jEcy+M0T5wxs9A6VLGVxU+CGSg6c36WuFc75NOQMQQOtJh9
         i+lFU7i2fhNyyJyi6LT34KyDCvZ2JgHpAlfRnvhH7vMMVuzXwPU3rKETDmKrUy/dJdzI
         jUz63jqrqLkKKHeFCKqrcPV67uT1/opSwZS9feYLJdi98HvOP6XCyZYjTStF9MaD9+kZ
         szBkK9CoCzAopzTXDE3mPKmPeFJm+sGAlr8fXxDPHwV1OOLz8Fk5hudspNjNaMH4xydt
         3RCQ==
X-Gm-Message-State: APjAAAVioxxc/1aMLLxuXURcZWSuxnppcdZPuV1zrthioaJmuaPGfLSj
        FOp3dSQtKl16slgN+vRmijwxSvIV
X-Google-Smtp-Source: APXvYqzmp8LbMs7hHnOYiuZmZpxV40ascEfcwEQqdeSNbfwYvK8vXWWwErHsLEe7Tcw+zDLv45iTUQ==
X-Received: by 2002:adf:a746:: with SMTP id e6mr5340508wrd.329.1579614489944;
        Tue, 21 Jan 2020 05:48:09 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b17sm51975006wrp.49.2020.01.21.05.48.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 05:48:09 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] KVM: async_pf: drop kvm_arch_async_page_present wrappers
Date:   Tue, 21 Jan 2020 14:48:06 +0100
Message-Id: <1579614487-44583-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The wrappers make it less clear that the position of the call
to kvm_arch_async_page_present depends on the architecture, and
that only one of the two call sites will actually be active.
Remove them.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/async_pf.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d8ef708a2ef6..15e5b037f92d 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -17,21 +17,6 @@
 #include "async_pf.h"
 #include <trace/events/kvm.h>
 
-static inline void kvm_async_page_present_sync(struct kvm_vcpu *vcpu,
-					       struct kvm_async_pf *work)
-{
-#ifdef CONFIG_KVM_ASYNC_PF_SYNC
-	kvm_arch_async_page_present(vcpu, work);
-#endif
-}
-static inline void kvm_async_page_present_async(struct kvm_vcpu *vcpu,
-						struct kvm_async_pf *work)
-{
-#ifndef CONFIG_KVM_ASYNC_PF_SYNC
-	kvm_arch_async_page_present(vcpu, work);
-#endif
-}
-
 static struct kmem_cache *async_pf_cache;
 
 int kvm_async_pf_init(void)
@@ -80,7 +65,8 @@ static void async_pf_execute(struct work_struct *work)
 	if (locked)
 		up_read(&mm->mmap_sem);
 
-	kvm_async_page_present_sync(vcpu, apf);
+	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
+		kvm_arch_async_page_present(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
@@ -157,7 +143,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 		spin_unlock(&vcpu->async_pf.lock);
 
 		kvm_arch_async_page_ready(vcpu, work);
-		kvm_async_page_present_async(vcpu, work);
+		if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
+			kvm_arch_async_page_present(vcpu, work);
 
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
-- 
1.8.3.1

