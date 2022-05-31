Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1621538C50
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiEaHzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 03:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244666AbiEaHzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 03:55:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4AFE6BFC4
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 00:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653983745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tvCRh6wMybfz1jQ+oOGAFWgP9hwbhrbOUgkVnS4S7M0=;
        b=D+EWKXZbvAvWfQW95JmvvOkTpT4Jtfl8+LP+RzhfzDJzhmCQLsYZCNMbdk+JwbH1HmyhUr
        5pUj+kOtx6+vszQiD8v/pb+MxreKnjQwQDd/t9knBiX0nSvMQJCVnxRz7EqfB1MIO/wIiH
        n0ptCN7SnqUFZbJhJn6b1UT2bSHesAE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-sXXc57MwP_GSPXQrM3jxFw-1; Tue, 31 May 2022 03:55:44 -0400
X-MC-Unique: sXXc57MwP_GSPXQrM3jxFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C82ED101AA45;
        Tue, 31 May 2022 07:55:43 +0000 (UTC)
Received: from thuth.com (unknown [10.39.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66302026D64;
        Tue, 31 May 2022 07:55:42 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Adjust the return type of kvm_vm_ioctl_check_extension_generic()
Date:   Tue, 31 May 2022 09:55:40 +0200
Message-Id: <20220531075540.14242-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vm_ioctl_check_extension_generic() either returns small constant
numbers or the result of kvm_vm_ioctl_check_extension() which is of type
"int". Looking at the callers of kvm_vm_ioctl_check_extension_generic(),
one stores the result in "int r", the other one in "long r", so the
result has to fit in the smaller "int" in any case. Thus let's adjust
the return value to "int" here so we have one less transition from
"int" -> "long" -> "int" in case of the kvm_vm_ioctl() ->
kvm_vm_ioctl_check_extension_generic() -> kvm_vm_ioctl_check_extension()
call chain.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 This patch is of very low importance - if you don't like it, please just
 ignore. I just came across this nit while looking through the code and
 thought that it might be somewhat nicer this way.

 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64ec2222a196..e911331fc620 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4309,7 +4309,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	return 0;
 }
 
-static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
+static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
 	case KVM_CAP_USER_MEMORY:
-- 
2.31.1

