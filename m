Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C452617901
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 09:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiKCIpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 04:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiKCIpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 04:45:34 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4819BD2C3;
        Thu,  3 Nov 2022 01:45:31 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7e7329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7e7:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8F6C01EC0430;
        Thu,  3 Nov 2022 09:45:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1667465129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=c898KIGelhJvkdpvAe824zz9JVE4JsvxtNQOJVhneDk=;
        b=coiU0KV+DNLXrhEPzsEaDFDApoUM1klnQ/Yw/kOXj+uuNXyVis3In4kkvY4kQT7wXbfF6U
        QqMvaxzEaWcLWs6708tq3XKB312LUqDG8/WQ6BMi7vigpa+JRfdKTbO0N+W2Hy14F4Tsuj
        3mOHw5Ndb/nqd6Wmrjv3LwI7OAabl0Q=
Date:   Thu, 3 Nov 2022 09:45:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
Message-ID: <Y2N/peaVRIjTMyrw@zn.tnic>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
 <20221103025030.78371-2-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221103025030.78371-2-jiaxi.chen@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 10:50:23AM +0800, Jiaxi Chen wrote:
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 1a85e1fb0922..fbb4e7bd2288 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -24,7 +24,7 @@ enum cpuid_leafs
>  	CPUID_7_0_EBX,
>  	CPUID_D_1_EAX,
>  	CPUID_LNX_4,
> -	CPUID_7_1_EAX,
> +	CPUID_DUMMY,
>  	CPUID_8000_0008_EBX,
>  	CPUID_6_EAX,
>  	CPUID_8000_000A_EDX,

No, do this (diff ontop):

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index fbb4e7bd2288..b2905ddd7ab4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -24,7 +24,7 @@ enum cpuid_leafs
 	CPUID_7_0_EBX,
 	CPUID_D_1_EAX,
 	CPUID_LNX_4,
-	CPUID_DUMMY,
+	CPUID_LNX_5,
 	CPUID_8000_0008_EBX,
 	CPUID_6_EAX,
 	CPUID_8000_000A_EDX,
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 91acf8b8e493..5c9023438e57 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -306,6 +306,8 @@
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 #define X86_FEATURE_CALL_DEPTH		(11*32+18) /* "" Call depth tracking for RSB stuffing */
 
+/* Linux-defined mapping, word 12 */
+
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
 #define X86_FEATURE_IRPERF		(13*32+ 1) /* Instructions Retired Count */

---

I'm pretty sure we'll need new bits soon so let's reuse that one for
Linux-defined flags.

Then you can drop patch 2.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
