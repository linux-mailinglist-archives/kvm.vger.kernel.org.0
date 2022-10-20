Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B375660644E
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJTPYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiJTPY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5D71C19D1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DTA/VcOk33R5phQxQH82CCraNakgkfTTXm7Ga+i4nlY=;
        b=ALmaDNVWhXVgqXTXGRPk+Q236JRSxNW3piZYNyAJq437hxgLqpN0fZuVND4rw8jljmIolK
        yD1KihbX5JEVQmA1RMQp7D8iaVgQbRPk9kogDv+J9SsT9LQ5gZGFci7rsDlAG6YFT7Bh5j
        FyS7OsrorRckMpTBPYVRSAPkcqbeAco=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-nFqBpFRaPEOlo5NHWlA0dg-1; Thu, 20 Oct 2022 11:24:14 -0400
X-MC-Unique: nFqBpFRaPEOlo5NHWlA0dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CA192A59557
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BA542024CB7;
        Thu, 20 Oct 2022 15:24:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 04/16] svm: make svm_intr_intercept_mix_if/gif test a bit more robust
Date:   Thu, 20 Oct 2022 18:23:52 +0300
Message-Id: <20221020152404.283980-5-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When injecting self IPI the test assumes that initial EFLAGS.IF flag is
zero, but previous tests might have set it.

Explicitly disable interrupts to avoid this assumption.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a6b26e72..d734e5f7 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3155,6 +3155,7 @@ static void svm_intr_intercept_mix_if(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_if_guest);
+	irq_disable();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
@@ -3187,6 +3188,7 @@ static void svm_intr_intercept_mix_gif(void)
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_gif_guest);
+	irq_disable();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
 }
-- 
2.26.3

