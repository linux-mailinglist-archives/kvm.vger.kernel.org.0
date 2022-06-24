Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F44C559F7D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiFXRS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiFXRSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B0E349C96
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFkbFE9Pn4FMqfM3ZOYs/tb5dPTZApHuXMpgEvAcvYo=;
        b=VpGKbtAI9Ae10ZUrX7OtWEn7XO5KhqoBPCzYxcnzImyZI4RJqN61+jUiKtbsjDM90F/2yD
        HJh4NBHt4TJFYk4sudQLLgnx7Z46/lVqXxF6fKgPhrCzTNtP9v3NKii1Iva8xxl92MjtDd
        4XQWGwhd4JjwN88fEazv0VrD6bQqVqw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-cj6eGGT4O7Otfs5tffU3Fw-1; Fri, 24 Jun 2022 13:18:49 -0400
X-MC-Unique: cj6eGGT4O7Otfs5tffU3Fw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72E7085A589;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BD6E492C3B;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 3/8] KVM: x86: drop PIO from unregistered devices
Date:   Fri, 24 Jun 2022 13:18:43 -0400
Message-Id: <20220624171848.2801602-4-pbonzini@redhat.com>
In-Reply-To: <20220624171848.2801602-1-pbonzini@redhat.com>
References: <20220624171848.2801602-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM protects the device list with SRCU, and therefore different calls
to kvm_io_bus_read()/kvm_io_bus_write() can very well see different
incarnations of kvm->buses.  If userspace unregisters a device while
vCPUs are running there is no well-defined result.  This patch applies
a safe fallback by returning early from emulator_pio_in_out().  This
corresponds to returning zeroes from IN, and dropping the writes on
the floor for OUT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 524a96d26399..5a56d39bd81f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7593,8 +7593,19 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
 		else
 			r = kvm_io_bus_write(vcpu, KVM_PIO_BUS, port, size, data);
-		if (r)
-			goto userspace_io;
+
+		if (r) {
+			if (i == 0)
+				goto userspace_io;
+
+			/*
+			 * Userspace must have unregistered the device while PIO
+			 * was running.  Drop writes / read as 0 (the buffer
+			 * was zeroed in __emulator_pio_in).
+			 */
+			break;
+		}
+
 		data += size;
 	}
 	return 1;
@@ -7606,7 +7617,6 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->run->io.data_offset = KVM_PIO_PAGE_OFFSET * PAGE_SIZE;
 	vcpu->run->io.count = count;
 	vcpu->run->io.port = port;
-
 	return 0;
 }
 
-- 
2.31.1


