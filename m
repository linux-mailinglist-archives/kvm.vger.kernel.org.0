Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC04CAC51
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiCBRoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244110AbiCBRoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2E4AC7EB5
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646243007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vcyMploRmI5e6q7GMWaNDxko2AIloAHvg72NerFccOw=;
        b=BhAXWncH3LO/WUIdP1UDEUyDyvxnCqvv4+wwBpDOWkZ8b2Bo42e7+5wDcVDSobpHBjrrKE
        PRxg8B06G7KtPZ+mzVA+mmVb2TlBTZIA8i6m6VexB5atL9zaYNbkQIGwvU9isN+b1dpymS
        jaqVtCZL4f9N7zBEx02DrvDMZT6v0w0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-2EbYghR7PDOg3nFu_-wxoQ-1; Wed, 02 Mar 2022 12:43:23 -0500
X-MC-Unique: 2EbYghR7PDOg3nFu_-wxoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B82621854E21;
        Wed,  2 Mar 2022 17:43:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 356ED34664;
        Wed,  2 Mar 2022 17:43:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH] KVM: allow struct kvm to outlive the file descriptors
Date:   Wed,  2 Mar 2022 12:43:21 -0500
Message-Id: <20220302174321.326189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, the kvm module is kept alive by VFS via fops_get/fops_put, but there
may be cases in which a kvm_get_kvm's matching kvm_put_kvm happens after
the file descriptor is closed.  One case that will be introduced soon is
when work is delegated to the system work queue; the worker might be
a bit late and the file descriptor can be closed in the meantime.  Ensure
that the module has not gone away by tying a module reference explicitly
to the lifetime of the struct kvm.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64eb99444688..e3f37fc2ebf1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1131,6 +1131,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
+	/* This is safe, since we have a reference from open(). */
+	__module_get(THIS_MODULE);
+
 	return kvm;
 
 out_err:
@@ -1220,6 +1223,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	module_put(THIS_MODULE);
 }
 
 void kvm_get_kvm(struct kvm *kvm)
-- 
2.31.1

