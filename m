Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360484C2F0D
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiBXPND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiBXPM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:12:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EA11F7699
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:12:26 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id c1so1953958pgk.11
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MPmk5KxbdTyLl2UOtBv0K2TT60UGLai+WyetM7cSHdE=;
        b=WOXPXXRwad6MRtCR89eqmXu17buZRHgSq9aJcAA2j2ep/SVjKE7l22cX7g8Ruf49J1
         G6qRVt7PsNaqJbAERpGqn/kAnhhxd/MAOlcVwx3eg5pgFV3BalyQST8ARS2BXX03oybO
         RLEwEofHUUGS7G02aYGv+vrhE3a+pt8GLC2aZlzt5jv7q1KSdA8R4H94qpCCJuSkr2gx
         TOES/kihmUQZAjM923kKTzy6jI3a47hdePvFh4Ppjvymv7k6DpBeaFKGGsQXyoKeBFIn
         jME+e/Y8bE3iHkaZxVHRcp5Yc9RCW5naUzUtmy1yBvTRA/irc6GqW9xlgWyBeCItxmUj
         j46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MPmk5KxbdTyLl2UOtBv0K2TT60UGLai+WyetM7cSHdE=;
        b=TacYNeQLI3vSGDRekh/+bqjNYoMVXdE1wIPP9nnnUsInmwD1TrZRlJbuMCbm0v9kr9
         0yZmUp0jctS3GX2z7Vb0N9E+2iJAyjqxRtUl/xpxBBnAmaqDNjtYiIpqM03yT0z/44EO
         ikE0kot9xZrx5O0MKa3Vch+6G7gxUVqeC73z1DPqaTEgAQF0E04l23ZtpDL3hbBUnz0R
         3nkJHK6EAtYEb9LK4a8mSK+iildI6lS09XOUsi4Vzx+E2t6RnoHLHt2jB/rASUL6pf4W
         +0ZSZh+L2re2fotKLMrKebSNfW8MZidC5LdGm1DwfGS/DAi/9kTdgCLSRbtKrhmMTsyP
         x51Q==
X-Gm-Message-State: AOAM533dB9vItFLno7vkbIotT7uot/Tll26v4Cz5r5IDkhV1N29M3WIC
        SFPFm2tHr/f2ckJxR0WzMfiKBw==
X-Google-Smtp-Source: ABdhPJxtMSEELMyDanJ2hCQse2E6y1F+1N+TFCxeHsggbNcfjN1ETsfMwGyAM8ovT0cQA9V/GuvUIw==
X-Received: by 2002:aa7:982d:0:b0:4e1:56d4:1e78 with SMTP id q13-20020aa7982d000000b004e156d41e78mr3423963pfl.24.1645715545443;
        Thu, 24 Feb 2022 07:12:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p2sm3038771pjo.38.2022.02.24.07.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 07:12:24 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:12:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 14/18] KVM: x86/mmu: avoid indirect call for get_cr3
Message-ID: <YhegVBUzv+qnKATS@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-15-pbonzini@redhat.com>
 <207674f05d63a8b1a0edd1a35f6453aa8532200e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <207674f05d63a8b1a0edd1a35f6453aa8532200e.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Maxim Levitsky wrote:
> Not sure though if that is worth it though. IMHO it would be better to
> convert mmu callbacks (and nested ops callbacks, etc) to static calls.

nested_ops can utilize static_call(), mmu hooks cannot.  static_call() patches
the code, which means there cannot be multiple targets at any given time.  The
"static" part refers to the target not changing, generally for the lifetime of
the kernel/module in question.  Even with TDP that doesn't hold true due to
nested virtualization.

We could selectively use INDIRECT_CALL_*() for some of the MMU calls, but given
how few cases and targets we really care about, I prefer our homebrewed manual
checks as theres less macro maze to navigate.

E.g. to convert the TDP fault case

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1d0c1904d69a..940ec6a9d284 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -3,6 +3,8 @@
 #define __KVM_X86_MMU_H

 #include <linux/kvm_host.h>
+#include <linux/indirect_call_wrapper.h>
+
 #include "kvm_cache_regs.h"
 #include "cpuid.h"

@@ -169,7 +171,8 @@ struct kvm_page_fault {
        bool map_writable;
 };

-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+INDIRECT_CALLABLE_DECLARE(int kvm_tdp_page_fault(struct kvm_vcpu *vcpu,
+                                                struct kvm_page_fault *fault));

 extern int nx_huge_pages;
 static inline bool is_nx_huge_page_enabled(void)
@@ -196,11 +199,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                .req_level = PG_LEVEL_4K,
                .goal_level = PG_LEVEL_4K,
        };
-#ifdef CONFIG_RETPOLINE
-       if (fault.is_tdp)
-               return kvm_tdp_page_fault(vcpu, &fault);
-#endif
-       return vcpu->arch.mmu->page_fault(vcpu, &fault);
+       struct kvm_mmu *mmu = vcpu->arch.mmu;
+
+       return INDIRECT_CALL_1(mmu->page_fault, kvm_tdp_page_fault, vcpu, &fault);
 }

 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c1deaec795c2..a3ad1bc58859 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4055,7 +4055,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);

-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+INDIRECT_CALLABLE_SCOPE int kvm_tdp_page_fault(struct kvm_vcpu *vcpu,
+                                              struct kvm_page_fault *fault)
 {
        while (fault->max_level > PG_LEVEL_4K) {
                int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);

