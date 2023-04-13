Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD66E1697
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDMVoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 17:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDMVoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 17:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718E40E8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 14:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681422210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UGV46tTXLuSEtXlr2vZMnQqFx30ubOAGjT0umvFcQjc=;
        b=jCF4D7cioro5tbM22pBQb5ZFLWYIXj3aEMLhqLyb5EmVPu7x5cYkr28vWwXGTYG7yJBg4B
        f0fFbhV1QDfWNliAHw36FzxTxO5jA+mc5wROZtBIQJd7u6WbatJ7fa0Vb0DrLr4zx4Ub29
        8TxDCaRQwWOT+pDJTPgM+sICmzA0msg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-IqFOvbocP_WC4I7ObTLn0g-1; Thu, 13 Apr 2023 17:43:29 -0400
X-MC-Unique: IqFOvbocP_WC4I7ObTLn0g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE6571C0432C;
        Thu, 13 Apr 2023 21:43:28 +0000 (UTC)
Received: from scv.redhat.com (unknown [10.22.16.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C650E492C13;
        Thu, 13 Apr 2023 21:43:27 +0000 (UTC)
From:   John Snow <jsnow@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH] tests/avocado: require netdev 'user' for kvm_xen_guest
Date:   Thu, 13 Apr 2023 17:43:27 -0400
Message-Id: <20230413214327.3971247-1-jsnow@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tests will fail mysteriously with EOFError otherwise, because the VM
fails to boot and quickly disconnects from the QMP socket. Skip these
tests when we didn't compile with slirp.

Fixes: c8cb603293fd (tests/avocado: Test Xen guest support under KVM)
Signed-off-by: John Snow <jsnow@redhat.com>
---
 tests/avocado/kvm_xen_guest.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 5391283113..171274bc4c 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -45,6 +45,7 @@ def get_asset(self, name, sha1):
     def common_vm_setup(self):
         # We also catch lack of KVM_XEN support if we fail to launch
         self.require_accelerator("kvm")
+        self.require_netdev('user')
 
         self.vm.set_console()
 
-- 
2.39.2

