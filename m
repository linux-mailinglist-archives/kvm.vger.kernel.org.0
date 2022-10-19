Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8081A604A71
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiJSPFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiJSPEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:04:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A283192BAB
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:58:38 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y191so17495711pfb.2
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9s0rzFSy14ksG7NNdNRlqlEq20etJaJC/FAX/Yq5BNY=;
        b=afBPkpHRRvLWtBKufifpN2Wl9C6FeT9ZTYPsEWcnM3BeXZjd0U04i4IP6l6Ua+RhdI
         yjyN0ox7KkxLOJ1BGF6OZvd3yg1zMpKban444BBDmmzaHUlW7+3SpeP/P4ScK9nujoX+
         /eO62ftDvrLmBHJXYa2HEVR/1TnTiGQTAdFbNsRt28OkIZVNZRiNDLAPDSD/khRS85/l
         cEnEmvT9OjxhdfpbwPIDUWOkMFFMKB5IP3bP0t80LhgsPqqih+eqjBshEV0RBw9+TBT8
         qqG9JF5mBxjghVwqs4b2XuHmAyel7lE82+frHCxxp8VnV+4G75Q2kYim9muanS3Xkcav
         WGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9s0rzFSy14ksG7NNdNRlqlEq20etJaJC/FAX/Yq5BNY=;
        b=omCg4gjw+oX4QONGgpwhSOvMJTXmPmpx+ymiTpRVr8+TnrW7LhCwMVhEFo80WCcLp5
         48puD23LSqhyfL/qpS/tU5iMuk/dB4YGSibxI5Fk947vcTTqb0BXnxd+q3S/Fs+fFo1U
         kDrI5Xl+ojcagqirppscTmzEGEhCtKxuWYJAvTp8HnViOMGD8dl953nWYlyzn8N2WLYu
         m6QC2wHIrFKEwI+GAMAQNL7MSL9N0XMHaj2XPzV6phf5imvkrlo/4YyU0r9uda3h5HpU
         lWaIsuPkSCuDnriQHCMsRh+zpB/J7p38EQrIDpzHpFa0u0Qi1VtbBO1DU8o0YaCeGLTN
         AMrg==
X-Gm-Message-State: ACrzQf27vnksV2tvIIdFGLrAvlyihw90GFbR01n4XzWiF5Yo1aHFllYy
        I3ljZOZ34b2HQz0D+p/ceSZQVg==
X-Google-Smtp-Source: AMsMyM4qXn1XlEdmAJaEAbseNMZXl2PQJfCmqQGJRqdVfUjd0ddXT6IpMqxx/KzWC/+YDx+OnKq7PQ==
X-Received: by 2002:a05:6a00:150e:b0:563:b133:2932 with SMTP id q14-20020a056a00150e00b00563b1332932mr8687743pfu.37.1666191458992;
        Wed, 19 Oct 2022 07:57:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a22-20020aa795b6000000b005639a80af7bsm11460201pfk.75.2022.10.19.07.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 07:57:38 -0700 (PDT)
Date:   Wed, 19 Oct 2022 14:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org,
        jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: KVM: Enable AVX-VNNI-INT8 CPUID and expose it
 to guest
Message-ID: <Y1AQX3RfM+awULlE@google.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-5-jiaxi.chen@linux.intel.com>
 <Y0+6tJ7MiZWbYK5l@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0+6tJ7MiZWbYK5l@zn.tnic>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022, Borislav Petkov wrote:
> On Wed, Oct 19, 2022 at 04:47:32PM +0800, Jiaxi Chen wrote:
> > AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
> > Sierra Forest. It multiplies the individual bytes of two unsigned or
> > unsigned source operands, then add and accumulate the results into the
> > destination dword element size operand. This instruction allows for the
> > platform to have superior AI capabilities.
> > 
> > The bit definition:
> > CPUID.(EAX=7,ECX=1):EDX[bit 4]
>
> For this particular one, use scattered.c instead of adding a new leaf.

Unless the kernel wants to use X86_FEATURE_AVX_VNNI_INT8, which seems unlikely,
there's no need to create a scattered entry.  This can be handled in KVM by adding
a KVM-only leaf entry (which will be needed no matter what), plus a #define for
X86_FEATURE_AVX_VNNI_INT8 to direct it to the KVM entry.

E.g. 

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..25e7bfc61607 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
        CPUID_12_EAX     = NCAPINTS,
+       CPUID_7_1_EDX,
        NR_KVM_CPU_CAPS,
 
        NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -24,6 +25,16 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1           KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2           KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+#define KVM_X86_FEATURE_AVX_VNNI_INT8  KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
+
+/*
+ * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
+ * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
+ * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
+ * features in __feature_translate().
+ */
+#define X86_FEATURE_AVX_VNNI_INT8      KVM_X86_FEATURE_AVX_VNNI_INT8
+
 struct cpuid_reg {
        u32 function;
        u32 index;
@@ -48,6 +59,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
        [CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
        [CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
        [CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+       [CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 };
 
 /*

