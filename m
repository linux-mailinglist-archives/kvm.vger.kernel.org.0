Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017D95B1B6F
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiIHLbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHLbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:31:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474BC7B80
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 04:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662636674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RF2faMneXzqobhEsCwu+oy5DQq8D0oDaTvzYKiQawIo=;
        b=LtklRuaoL5FgfoJoyWwKT9KvYq0c9u/1961qxBlSvZIIBNMPL0IoE1+iv4AtAAcwOhBBQc
        x1AY6qZTyUvtQoRipyiZ4pJ9MF11ntgK1OsBIiT1m7VAcNovLB1ps1URpJMTIaCHCMLnf+
        GsMwZ74rIWpovLSRg1VXnLFw4nE78cM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558--Lbjh36KMamjRAr5yw3gPQ-1; Thu, 08 Sep 2022 07:31:12 -0400
X-MC-Unique: -Lbjh36KMamjRAr5yw3gPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82FF63814945;
        Thu,  8 Sep 2022 11:31:11 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FCB52166B29;
        Thu,  8 Sep 2022 11:31:11 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B455118009E8; Thu,  8 Sep 2022 13:31:09 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 1/2] [temporary] reserve bit KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Date:   Thu,  8 Sep 2022 13:31:08 +0200
Message-Id: <20220908113109.470792-2-kraxel@redhat.com>
In-Reply-To: <20220908113109.470792-1-kraxel@redhat.com>
References: <20220908113109.470792-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID bit hints to the guest
that the size of the physical address space as advertised by CPUID
leaf 0x80000008 is actually valid and can be used.

Unfortunately this is not the case today with qemu.  Default behavior is
to advertise 40 address bits (which I think comes from the very first x64
opteron processors).  There are lots of intel desktop processors around
which support less than that (36 or 39 depending on age), and when trying
to use the full 40 bit address space on those things go south quickly.

This renders the physical address size information effectively useless
for guests.  This patch paves the way to fix that by adding a hint for
the guest so it knows whenever the physical address size is usable or
not.

The plan for qemu is to set the bit when the physical address size is
valid.  That is the case when qemu is started with the host-phys-bits=on
option set for the cpu.  Eventually qemu can also flip the default for
that option from off to on, unfortunately that isn't easy for backward
compatibility reasons.

The plan for the firmware is to check that bit and when it is set just
query and use the available physical address space.  When the bit is not
set be conservative and try not exceed 36 bits (aka 64G) address space.
The latter is what the firmware does today unconditionally.

[ Temporary qemu patch for RfC patch and testing.  This change must
  actually be done in the linux kernel, then picked up by qemu via
  header file sync ].

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/standard-headers/asm-x86/kvm_para.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index f0235e58a1d3..962dabcfdb68 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -37,7 +37,8 @@
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
 
-#define KVM_HINTS_REALTIME      0
+#define KVM_HINTS_REALTIME                      0
+#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
-- 
2.37.3

