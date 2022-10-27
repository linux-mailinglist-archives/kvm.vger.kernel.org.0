Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60460FCEF
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiJ0QUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiJ0QTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B072118E701
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkzKsdsqzO0BIwMIdmac25pTJyVcLWN5ODcskpn+bp4=;
        b=UdozvJpRqgGXi99I2lR1OJp7oWnCI7Tl81tv7mwZfsPf1ORu+dFBzgW59qNoOvhMvdR2FF
        N5EzWMKCl9ODsghWxmT8tEYfh0N9bF8XFfj47t3EDmQm0x+dCIu0I8HU0V3eK0qiJZowg8
        owphDW+Un667buT8emx6qo+kwpF39bU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-hecbMnxFOY2Oz2srGaoKUw-1; Thu, 27 Oct 2022 12:18:55 -0400
X-MC-Unique: hecbMnxFOY2Oz2srGaoKUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4816D29AA2FF;
        Thu, 27 Oct 2022 16:18:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2718A17593;
        Thu, 27 Oct 2022 16:18:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 16/16] KVM: selftests: Mark "guest_saw_irq" as volatile in xen_shinfo_test
Date:   Thu, 27 Oct 2022 12:18:49 -0400
Message-Id: <20221027161849.2989332-17-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Tag "guest_saw_irq" as "volatile" to ensure that the compiler will never
optimize away lookups.  Relying on the compiler thinking that the flag
is global and thus might change also works, but it's subtle, less robust,
and looks like a bug at first glance, e.g. risks being "fixed" and
breaking the test.

Make the flag "static" as well since convincing the compiler it's global
is no longer necessary.

Alternatively, the flag could be accessed with {READ,WRITE}_ONCE(), but
literally every access would need the wrappers, and eking out performance
isn't exactly top priority for selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-17-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index caa3f5ab9e10..2a5727188c8d 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -132,7 +132,7 @@ struct {
 	struct kvm_irq_routing_entry entries[2];
 } irq_routes;
 
-bool guest_saw_irq;
+static volatile bool guest_saw_irq;
 
 static void evtchn_handler(struct ex_regs *regs)
 {
-- 
2.31.1

