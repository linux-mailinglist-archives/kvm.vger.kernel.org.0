Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AE06BBCFF
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCOTLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjCOTLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:11:33 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9416570B7
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:11:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q68-20020a632a47000000b004f74bc0c71fso4747296pgq.18
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678907492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MPGBQpB/QOW3rOyiIDpJ1ssFrkSwrzaQZYPEXWdODjE=;
        b=DmIV0/goxFG7244B78LovLy06QrlSgu8/f40cOxIKKIBWcFXMdLj2/R/SlxpjVI4Xs
         FyUfyY6rHLpQIRLKr5KEahhvus39lwLLwwb1AQLRk8kAWyYQvyWEI54fGCL0uZ0DnT5p
         1ohtmXtfIfH+AiU7mEHey888ZlDpXgbLWl0bfugYDjapKaQ2Rvv7ZdqM/hiYsJTp137H
         xD1vW+VMReaaLTBGQXU2bY9+JSK17d/EKiYyKK9udwboPopfApz3zvvdmC4KSdaOyM0T
         47Dg2Eri745skE5XoFMII7S7y7R5XBt80sAHmZFd5xoRoRq/FwdnQcqQESDxIsSUmSut
         3MhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678907492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPGBQpB/QOW3rOyiIDpJ1ssFrkSwrzaQZYPEXWdODjE=;
        b=EMl1NZOv2Jo4mXzD19WOY2I2n3WXh9ZDhKsmYqSgzDu5mqYwfXAmhvsHdey+2/brb+
         lJOch1vuF825OWmcBDGN2pRK3QaMpX0/zWewF+WiK3ZthOWye2VhDmpv5/s1uJu7kvJc
         VH3wnu4uqa5syq7+1xp/aIknMn0b5FUpGyGHVXXcE4A3flG5gT5FU3KHFWCNDYSNaDGm
         /hDh6gSSgeGU8xAORGylC9wNu/ABDcSjHAnE2ZFx32wApAS/xretJMclqV8/F/5asG15
         FOfCkbOrVl1juVgKUnNoNb8u+ZQOKHtwsZmXSGLOME/UEyypfNUmbzdcISm3HSQ4GUPS
         FHHw==
X-Gm-Message-State: AO0yUKUifszIBVCCohCbRvq9qOGOn8tjqu2VqUfax/AdsNtSCCf6Q7wd
        1WC0VlcUhr1fh828eXz8z+M4jxXq8IY=
X-Google-Smtp-Source: AK7set920HmFpb4MlEzZ8bRlGcqLIXXvrzrExQHAfTr81kPsDnjFnKwpGVaRsLPcCVKmLXRheMOgnHuI+sY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:452:b0:19e:f660:81ee with SMTP id
 iw18-20020a170903045200b0019ef66081eemr303110plb.2.1678907492254; Wed, 15 Mar
 2023 12:11:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Mar 2023 12:11:27 -0700
In-Reply-To: <20230315191128.1407655-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230315191128.1407655-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315191128.1407655-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: VMX: Drop unprotected-by-braces variable declaration
 in case-statement
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
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

Remove the intermediate "guest_flush_l1d" boolean to fix a build error on
clang due to the variable being declared inside a case-statement without
curly braces to create a proper code block.

Fixes: c7ed946b95cb ("kvm: vmx: Add IA32_FLUSH_CMD guest support")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303151912.oZ6SGd90-lkp@intel.com
Cc: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c63f6c786eb1..d7bf14abdba1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2325,10 +2325,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					   X86_FEATURE_IBPB);
 		break;
 	case MSR_IA32_FLUSH_CMD:
-		bool guest_flush_l1d = guest_cpuid_has(vcpu,
-						       X86_FEATURE_FLUSH_L1D);
 		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
-					   guest_flush_l1d,
+					   guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D),
 					   L1D_FLUSH,
 					   X86_FEATURE_FLUSH_L1D);
 		break;
-- 
2.40.0.rc2.332.ga46443480c-goog

