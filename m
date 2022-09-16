Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E97F5BA62C
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 06:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIPE7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 00:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIPE7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 00:59:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB8577550
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n10-20020a170902e54a00b001782663dcaeso11238815plf.18
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=7tZtbYb4b1WkABBBL7k03zVW6CHmPIA8CRpYxtt3dU4=;
        b=iB5PxJYEAA0x/1haaI/7S9TwcOIBOOzjGR31ZHeCB55hkaUE9xPGs6EoFssfP+Xy0n
         s3W7PfvEnr/zQ9kWhOfk03Ye3Uls2qrOXPDKxUQInX5UoeRZw6hytIPjdHgDSC6QRGy8
         7daxj6hjkqbkdZTLGteg4l29iVNwINa70vUjYh083Rh0/RrUQOXz8MG2dnZSQ8r+XQ0D
         Mvyz6BetTRtXAXCogRWOO29Oq4r73POIonZAJC2kr6AeOclnPhiK3rP5oNXnvKDPy5uC
         qNQtLaJrpojQ80eZ0YAdlulDnMeOINrmqMgCINGR2SzXZzUzO/qxck61VwnJdfViL17m
         Xtnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=7tZtbYb4b1WkABBBL7k03zVW6CHmPIA8CRpYxtt3dU4=;
        b=2L7dLBmnr+vESFQW4yroVBeXY5BmGPfyt6Efnt/7ZxDYf8NfuTNf6e+34RcUkN++WS
         /iDp/dRje/4OVvo85m9cQ5DoHpyWukhXAY/i454iL6CUTlqv5naF+ej4KR+VPBb6OwTX
         k3dvqrFTD/QO1amiFGG2nITiXBNUYZ4Kwru6p0V4gJFkOyefR6o5FulWV+1Pik6jXSoe
         wVCSRTKb4eRKWqU8qtD77eof1IFH8IkIIeBkxEj5CnVbiW3Xn+4usCE2MHDa/K0eCI3H
         YUQfueNuCEynelf0X46wpI+CLhogiNvwvSlq3p/Q37uIPg5lZDUUdpGzR/LpeBfHjMRh
         EFGg==
X-Gm-Message-State: ACrzQf27rXwJ0czH0NTY4tV9rWhkAwMp2oORhg10VpjijzCWdgeZoD80
        C3mxKt7La3JiJwXX+wkJEQ7e9Sh059vVmg==
X-Google-Smtp-Source: AMsMyM4wo0CzzhLsz2BITZ7VZo82qOIK7eXiC+AwYqy4ZpaKh07ByJS2/cGX7S5FHQJxNgCEIm9aBIQq8sGnKg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1d9b:b0:541:1894:d5db with SMTP
 id z27-20020a056a001d9b00b005411894d5dbmr3278996pfw.78.1663304337274; Thu, 15
 Sep 2022 21:58:57 -0700 (PDT)
Date:   Thu, 15 Sep 2022 21:58:30 -0700
In-Reply-To: <20220916045832.461395-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220916045832.461395-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220916045832.461395-4-jmattson@google.com>
Subject: [PATCH 3/5] KVM: x86: Report host's X86_FEATURE_NO_LMSLE in KVM_GET_SUPPORTED_CPUID
From:   Jim Mattson <jmattson@google.com>
To:     Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFER.LMSLE is not supported in a KVM guest if it is not supported on
the underlying hardware. Inform the guest by exposing the host's value
of X86_FEATURE_NO_LMSLE in KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..b4975467d686 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -670,7 +670,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
-		F(CLZERO) | F(XSAVEERPTR) |
+		F(CLZERO) | F(XSAVEERPTR) | F(NO_LMSLE) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
 		__feature_bit(KVM_X86_FEATURE_PSFD)
-- 
2.37.3.968.ga6b4b080e4-goog

