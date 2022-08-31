Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4415A7DF2
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 14:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiHaMvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 08:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiHaMvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 08:51:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E06C2D1D2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 05:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661950264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CE4fA7BUGFAjvQkmvSK15esjX/ggaaSavOfVyHFuI1A=;
        b=bJvBMhzXbc5d9uKZB4szkuyex404e4N4BX03MX1YK0uU/GHuLVBw+KzFteDx4HXuJ/QPXB
        h5tqAiXPqXVUN9aS7nil4ZA767qyVLAtbv53XN7v4t1AsYVFJDxkNcVeJlb8JcJW1VajX+
        M5bZVXHR/01TU5m4lFs6gm+XhJjZT6U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-EiYwpVoVO_SVC0RJADLPsg-1; Wed, 31 Aug 2022 08:51:01 -0400
X-MC-Unique: EiYwpVoVO_SVC0RJADLPsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD5623825787;
        Wed, 31 Aug 2022 12:51:00 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C8B44010D43;
        Wed, 31 Aug 2022 12:51:00 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 2F7D11800623; Wed, 31 Aug 2022 14:50:59 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 1/2] [hack] reserve bit KVM_HINTS_HOST_PHYS_BITS
Date:   Wed, 31 Aug 2022 14:50:58 +0200
Message-Id: <20220831125059.170032-2-kraxel@redhat.com>
In-Reply-To: <20220831125059.170032-1-kraxel@redhat.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_HINTS_HOST_PHYS_BITS bit indicates that qemu has host-phys-bits
turned on.  This implies the guest can actually work with the full
available physical address space as advertised by CPUID(0x80000008).

Temporary hack for RfC patch and testing.  This change must actually be
done in the linux kernel, then picked up by qemu via header file sync.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/standard-headers/asm-x86/kvm_para.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index f0235e58a1d3..105b958c0f56 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -37,7 +37,8 @@
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
 
-#define KVM_HINTS_REALTIME      0
+#define KVM_HINTS_REALTIME              0
+#define KVM_HINTS_HOST_PHYS_BITS        1
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
-- 
2.37.2

