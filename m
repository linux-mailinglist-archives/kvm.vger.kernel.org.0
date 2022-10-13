Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14B25FD77A
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJMJ7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJMJ7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:59:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07AAF9847
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665655140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HwsXYYG8kR6dOA4gfCT2K1dWA8ovO4ni9T56gaC1L68=;
        b=gy4ty7d3i1Rx1d6AaLRqsSBzwN8ZPhtivJiWgrUbztBTkihgfSzmcrlqApkhwxfBB+J7co
        KAfcNnI1ReQ0cL+mx9+b2KgXd8asGe/Phz7k4qPhxFgWV8cpwa/iHeTgnB3ODmM/L+1Q9L
        silPF20Ix+LlisgMb4YRrulyFReZwbc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-5v4_ZQznPa6bLI7iMl32Tg-1; Thu, 13 Oct 2022 05:58:56 -0400
X-MC-Unique: 5v4_ZQznPa6bLI7iMl32Tg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 962733C0E203;
        Thu, 13 Oct 2022 09:58:55 +0000 (UTC)
Received: from ovpn-194-196.brq.redhat.com (ovpn-194-196.brq.redhat.com [10.40.194.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8607047505F;
        Thu, 13 Oct 2022 09:58:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/7] x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
Date:   Thu, 13 Oct 2022 11:58:43 +0200
Message-Id: <20221013095849.705943-2-vkuznets@redhat.com>
In-Reply-To: <20221013095849.705943-1-vkuznets@redhat.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid open coding BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL by adding
a dedicated define. While there's only one user at this moment, the
upcoming KVM implementation of Hyper-V Invariant TSC feature will need
to use it as well.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 3 +++
 arch/x86/kernel/cpu/mshyperv.c     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 3089ec352743..196a8945bcd7 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -253,6 +253,9 @@ enum hv_isolation_type {
 /* TSC invariant control */
 #define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
 
+/* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
+#define HV_EXPOSE_INVARIANT_TSC		BIT_ULL(0)
+
 /* Register name aliases for temporary compatibility */
 #define HV_X64_MSR_STIMER0_COUNT	HV_REGISTER_STIMER0_COUNT
 #define HV_X64_MSR_STIMER0_CONFIG	HV_REGISTER_STIMER0_CONFIG
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 831613959a92..e402923800d7 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -388,7 +388,7 @@ static void __init ms_hyperv_init_platform(void)
 		 * setting of this MSR bit should happen before init_intel()
 		 * is called.
 		 */
-		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
+		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, HV_EXPOSE_INVARIANT_TSC);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 	}
 
-- 
2.37.3

