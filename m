Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EEA5B1BBC
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiIHLl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIHLl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:41:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9770E11CD6B
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 04:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662637314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T398WtTFF5zSugQOFGipjBY5PyVjRUglaOoWYsHIwQE=;
        b=Pv+f2sZtK0erJJQyVmiAY18uVHO1jDIC0OViSBCDrFP/mP2vf6l9BFrAuVlNxDBCXzplXA
        ee3iADt2/R///hTMQVLx1lIX6iOWjAoEGsU8L7ftATLlfOORI803zlXtOvADcixD9ZeJvn
        RkYyZpp3v1AkvgZPYmDRD/9uN7LZr/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-_SKpC-DeMy2C31IH3WUUCA-1; Thu, 08 Sep 2022 07:41:49 -0400
X-MC-Unique: _SKpC-DeMy2C31IH3WUUCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD83018A01AF;
        Thu,  8 Sep 2022 11:41:48 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56730C15BB3;
        Thu,  8 Sep 2022 11:41:48 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id BE2DB18009BE; Thu,  8 Sep 2022 13:41:46 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] kvm/x86: reserve bit KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Date:   Thu,  8 Sep 2022 13:41:46 +0200
Message-Id: <20220908114146.473630-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/include/uapi/asm/kvm_para.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..115bb34413cf 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
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

