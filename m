Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8986899FC
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 14:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjBCNpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 08:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjBCNpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 08:45:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37128DAC8
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 05:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675431887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3O8Hu2Eff4RtUTfyebeMbncBmuF855AAStNr0xiY9Dk=;
        b=IZ7sI51UcGYI3AdxTWoX4zZGbQhFl+6h38nUO/ev5rGDH9ZH4T5dKTr7zcF//Sn1aTvAJ0
        4KJcJ3oImxn+LCACrRuNO07RpaYdQze6gVW3t8CHyZ8jJY25XLOtkDhfQe4zvBmTBtCf9V
        1VqXfHqZcO0X4egUX/JtvvP2+bT3cGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-2I4wLs87PpOfqkIBVRLcmQ-1; Fri, 03 Feb 2023 08:44:46 -0500
X-MC-Unique: 2I4wLs87PpOfqkIBVRLcmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13C9B811E6E;
        Fri,  3 Feb 2023 13:44:46 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.192.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23E22408573E;
        Fri,  3 Feb 2023 13:44:44 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v5 1/3] arm/virt: don't try to spell out the accelerator
Date:   Fri,  3 Feb 2023 14:44:31 +0100
Message-Id: <20230203134433.31513-2-cohuck@redhat.com>
In-Reply-To: <20230203134433.31513-1-cohuck@redhat.com>
References: <20230203134433.31513-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just use current_accel_name() directly.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/arm/virt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ea2413a0bad7..bdc297a4570c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2123,21 +2123,21 @@ static void machvirt_init(MachineState *machine)
     if (vms->secure && (kvm_enabled() || hvf_enabled())) {
         error_report("mach-virt: %s does not support providing "
                      "Security extensions (TrustZone) to the guest CPU",
-                     kvm_enabled() ? "KVM" : "HVF");
+                     current_accel_name());
         exit(1);
     }
 
     if (vms->virt && (kvm_enabled() || hvf_enabled())) {
         error_report("mach-virt: %s does not support providing "
                      "Virtualization extensions to the guest CPU",
-                     kvm_enabled() ? "KVM" : "HVF");
+                     current_accel_name());
         exit(1);
     }
 
     if (vms->mte && (kvm_enabled() || hvf_enabled())) {
         error_report("mach-virt: %s does not support providing "
                      "MTE to the guest CPU",
-                     kvm_enabled() ? "KVM" : "HVF");
+                     current_accel_name());
         exit(1);
     }
 
-- 
2.39.1

