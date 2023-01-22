Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AC676BCD
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 10:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjAVJJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 04:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVJJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 04:09:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF9D1E9F1
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 01:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674378530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xw2MXfkPPnLQlnAfeTOxuXROIA//nwHqLwtbd7CXgk8=;
        b=Ud10sJyxsNL4xHkYVMsZ2To/UV0Sq40eucPGSD1Fg2lbxAKaTOG3i1eqcFPKzkApxAAy9n
        Zw36MVfbl5vsz36mLhQ2zn0YjM6cVGD0+1k9AQbsYRZPVZ53pxx8t5S4ycyhkTh+DdW0oo
        nxHctb711elqOaKnU+Wu0WoyHEspYPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-UsGxYsLSOFmvS_Mef9Nucw-1; Sun, 22 Jan 2023 04:08:44 -0500
X-MC-Unique: UsGxYsLSOFmvS_Mef9Nucw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9B0B1875041;
        Sun, 22 Jan 2023 09:08:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A44172026D68;
        Sun, 22 Jan 2023 09:08:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] selftests: kvm: move declaration at the beginning of main()
Date:   Sun, 22 Jan 2023 04:08:43 -0500
Message-Id: <20230122090843.3743704-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Placing a declaration of evt_reset is pedantically invalid
according to the C standard.  While GCC does not really care
and only warns with -Wpedantic, clang ignores the declaration
altogether with an error:

x86_64/xen_shinfo_test.c:965:2: error: expected expression
        struct kvm_xen_hvm_attr evt_reset = {
        ^
x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier evt_reset
        vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
                                            ^

Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Reported-by: Sean Christopherson <seanjc@google.com>
Fixes: a79b53aaaab5 ("KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET", 2022-12-28)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index dae510c263b4..13c75dc18c10 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -434,6 +434,7 @@ static void *juggle_shinfo_state(void *arg)
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
+	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
 	pthread_t thread;
 	bool verbose;
@@ -962,10 +963,8 @@ int main(int argc, char *argv[])
 	}
 
  done:
-	struct kvm_xen_hvm_attr evt_reset = {
-		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
-		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
-	};
+	evt_reset.type = KVM_XEN_ATTR_TYPE_EVTCHN;
+	evt_reset.u.evtchn.flags = KVM_XEN_EVTCHN_RESET;
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
 
 	alarm(0);
-- 
2.39.0

