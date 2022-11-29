Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8139B63C8A8
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbiK2Tlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiK2Tk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4502E1ADB0
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3C0J4b/Iq2TqSFgmT2zDR52z47EVntTEYZ6+rgtU/8=;
        b=aG2l1cO/IgswxACI3gVfOgBUtg7an+dgwgHn7/XK4Il7kaHAWUCgBdAWfQBs5VGOk7IE2P
        vU/aZ9dhR2aS0cH8u/dQl8aeQD6izDmG3AbFEQlyCoXywrJpgUcDgnog8+uJyzqSC69032
        ls0k0gfJRPoP1yi8lge6U4KPRGffkBU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-s4zjxzx_Nja3jk2eWklLvQ-1; Tue, 29 Nov 2022 14:37:57 -0500
X-MC-Unique: s4zjxzx_Nja3jk2eWklLvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F25E73817A62;
        Tue, 29 Nov 2022 19:37:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00B312028CE4;
        Tue, 29 Nov 2022 19:37:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH v2 08/11] x86/cpu: Add CPUID feature bit for VNMI
Date:   Tue, 29 Nov 2022 21:37:14 +0200
Message-Id: <20221129193717.513824-9-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

VNMI feature allows the hypervisor to inject NMI into the guest w/o
using Event injection mechanism, The benefit of using VNMI over the
event Injection that does not require tracking the Guest's NMI state and
intercepting the IRET for the NMI completion. VNMI achieves that by
exposing 3 capability bits in VMCB intr_cntrl which helps with
virtualizing NMI injection and NMI_Masking.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1419c4e04d45f3..ed50f28bdf235b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -359,6 +359,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_AMD_VNMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.26.3

