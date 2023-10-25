Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6606D7D70FE
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbjJYPcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjJYPca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1860A196
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtoXj1GYNMFSHttaFfxD/jjrlz6bvckSpFZTkJXcl/4=;
        b=deWhkqSWEWiljA48IAWLX09BgvM8mGX432dQf66d0x0QDU1QLaFtaf7mdGCWYfPTM5MyUO
        lHxVYG5D0CoTl7lSSfUcdRZ95hQsPG8WjxSTAHx7tkqJqbitQXH8TyxDFfd+PoAWNjJFAD
        ZFAW+sGF321XDejY6iR349KfUlsDqd8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-q9cDIzN4Ni-QF5cC8qpvKQ-1; Wed,
 25 Oct 2023 11:30:17 -0400
X-MC-Unique: q9cDIzN4Ni-QF5cC8qpvKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3981C1C0783D;
        Wed, 25 Oct 2023 15:29:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 666E32166B27;
        Wed, 25 Oct 2023 15:29:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH kvm-unit-tests 3/4] x86: hyper-v:  Use 'goto' instead of putting the whole test in an 'if' branch in hyperv_synic
Date:   Wed, 25 Oct 2023 17:29:14 +0200
Message-ID: <20231025152915.1879661-4-vkuznets@redhat.com>
In-Reply-To: <20231025152915.1879661-1-vkuznets@redhat.com>
References: <20231025152915.1879661-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unify 'hyperv_synic' test with other Hyper-V tests by using the:

 if (required-features-missing) {
    report_skip();
    goto done;
 }
 ...

 done:
     return report_summary();

pattern.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_synic.c | 61 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index 9d61d8362ebd..ae57f1c5faac 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -141,45 +141,46 @@ static void synic_test_cleanup(void *ctx)
 
 int main(int ac, char **av)
 {
+    int ncpus, i;
+    bool ok;
 
-    if (synic_supported()) {
-        int ncpus, i;
-        bool ok;
-
-        setup_vm();
-        enable_apic();
+    if (!synic_supported()) {
+	report_skip("Hyper-V SynIC is not supported");
+	goto done;
+    }
 
-        ncpus = cpu_count();
-        if (ncpus > MAX_CPUS)
-            report_abort("number cpus exceeds %d", MAX_CPUS);
-        printf("ncpus = %d\n", ncpus);
+    setup_vm();
+    enable_apic();
 
-        synic_prepare_sint_vecs();
+    ncpus = cpu_count();
+    if (ncpus > MAX_CPUS)
+	report_abort("number cpus exceeds %d", MAX_CPUS);
+    printf("ncpus = %d\n", ncpus);
 
-        printf("prepare\n");
-        on_cpus(synic_test_prepare, (void *)read_cr3());
+    synic_prepare_sint_vecs();
 
-        for (i = 0; i < ncpus; i++) {
-            printf("test %d -> %d\n", i, ncpus - 1 - i);
-            on_cpu_async(i, synic_test, (void *)(ulong)(ncpus - 1 - i));
-        }
-        while (cpus_active() > 1)
-            pause();
+    printf("prepare\n");
+    on_cpus(synic_test_prepare, (void *)read_cr3());
 
-        printf("cleanup\n");
-        on_cpus(synic_test_cleanup, NULL);
+    for (i = 0; i < ncpus; i++) {
+	printf("test %d -> %d\n", i, ncpus - 1 - i);
+	on_cpu_async(i, synic_test, (void *)(ulong)(ncpus - 1 - i));
+    }
+    while (cpus_active() > 1)
+	pause();
 
-        ok = true;
-        for (i = 0; i < ncpus; ++i) {
-            printf("isr_enter_count[%d] = %d\n",
-                   i, atomic_read(&isr_enter_count[i]));
-            ok &= atomic_read(&isr_enter_count[i]) == 16;
-        }
+    printf("cleanup\n");
+    on_cpus(synic_test_cleanup, NULL);
 
-        report(ok, "Hyper-V SynIC test");
-    } else {
-        printf("Hyper-V SynIC is not supported");
+    ok = true;
+    for (i = 0; i < ncpus; ++i) {
+	printf("isr_enter_count[%d] = %d\n",
+	       i, atomic_read(&isr_enter_count[i]));
+	ok &= atomic_read(&isr_enter_count[i]) == 16;
     }
 
+    report(ok, "Hyper-V SynIC test");
+
+done:
     return report_summary();
 }
-- 
2.41.0

