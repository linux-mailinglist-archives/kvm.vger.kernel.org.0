Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1964AFCC
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiLMGXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiLMGXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:23:14 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9361EC52
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:10 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j21-20020a63fc15000000b00476d6932baeso9159886pgi.23
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1fJyVuk5cBWctfFgX8J0LHaIGn/Pz35XRlBWLsFAwFo=;
        b=pWIRAVY8qUMINrhedsB2/PmbsrFnyh4TisMaaC9CPQ20xkuuDOaUte7f+XRNNJFMTe
         MBMhU0mCMZSRGJH1Nyb6yw2jHYjWeiAfvWTeqm7sdpHGhOZlnoR4/4Fc/mG4BgLY5R6H
         YZ5JxUAyNCfuTt6n4myOLQuWm/qS/NnFle12WWCC68IcJ3dWPfcw9aWGjS4ZQdCKu2bF
         U0wl3rOTx2NoYkUQ++L3NjBgr/FdcRoW7q0pa/iqOerMgE+1TtzpMkRSYqfN971TujwR
         pf/sRZxcShIQk+eF10np3I6DvSwCtpIzaUSOM0Z8BHFHbom/finCGFHxxOQEZ0Ab4e3U
         6iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1fJyVuk5cBWctfFgX8J0LHaIGn/Pz35XRlBWLsFAwFo=;
        b=VsyOYuvMf7KC3cPr9jysMl4fEtgaHBC8hJU0mbm81Z4C9sakcSi5olCGKU/iYmhiYY
         S1N1oU9FpUDF21a60Ce/8I470sRns4uF8K+U5qaKqe8RqMiQqsZfxtugSfo2KsImOvRn
         57SLopReffFzYiwk4bglXEMYtsMHeAiDr33s42hE5XVDa9deem79wnrhCMoH1+0yy6dh
         9Dtd59U5oeDKGRGs8pZ8sRTIHH8D90OelnaZLhU4BLOT05xDNWp2PtZTLyMIzjrQ0dwG
         51zcUOTUvwzKJm0ZL/xU2+FCunV5hQDA0UNZgRRUlZcQpZkOHUhARH6ixhq/9NyvOQKy
         6sTw==
X-Gm-Message-State: ANoB5pnz8O0pxLjhk7/xawGJS/IX5NjO85xfL2VjpHk67Fuvr37am+jW
        oq8+GYGktmyAJYZ8WZ5rM/pLLtJV8/8=
X-Google-Smtp-Source: AA0mqf5b83aG+l8yLOFu227Fo8RPeZte9M61NCK2BSLmg0boTPRNhsLAsovwoLax16pFG/CEiFdjrreD840=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:be08:0:b0:574:26df:aac2 with SMTP id
 l8-20020a62be08000000b0057426dfaac2mr75812545pff.46.1670912590322; Mon, 12
 Dec 2022 22:23:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:23:03 +0000
In-Reply-To: <20221213062306.667649-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213062306.667649-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213062306.667649-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE
 control to L1
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set ENABLE_USR_WAIT_PAUSE in KVM's supported VMX MSR configuration if the
feature is supported in hardware and enabled in KVM's base, non-nested
configuration, i.e. expose ENABLE_USR_WAIT_PAUSE to L1 if it's supported.
This fixes a bug where saving/restoring, i.e. migrating, a vCPU will fail
if WAITPKG (the associated CPUID feature) is enabled for the vCPU, and
obviously allows L1 to enable the feature for L2.

KVM already effectively exposes ENABLE_USR_WAIT_PAUSE to L1 by stuffing
the allowed-1 control ina vCPU's virtual MSR_IA32_VMX_PROCBASED_CTLS2 when
updating secondary controls in response to KVM_SET_CPUID(2), but (a) that
depends on flawed code (KVM shouldn't touch VMX MSRs in response to CPUID
updates) and (b) runs afoul of vmx_restore_control_msr()'s restriction
that the guest value must be a strict subset of the supported host value.

Although no past commit explicitly enabled nested support for WAITPKG,
doing so is safe and functionally correct from an architectural
perspective as no additional KVM support is needed to virtualize TPAUSE,
UMONITOR, and UMWAIT for L2 relative to L1, and KVM already forwards
VM-Exits to L1 as necessary (commit bf653b78f960, "KVM: vmx: Introduce
handle_unexpected_vmexit and handle WAITPKG vmexit").

Note, KVM always keeps the hosts MSR_IA32_UMWAIT_CONTROL resident in
hardware, i.e. always runs both L1 and L2 with the host's power management
settings for TPAUSE and UMWAIT.  See commit bf09fb6cba4f ("KVM: VMX: Stop
context switching MSR_IA32_UMWAIT_CONTROL") for more details.

Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
Cc: stable@vger.kernel.org
Reported-by: Aaron Lewis <aaronlewis@google.com>
Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..d131375f347a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6873,7 +6873,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_TSC_SCALING;
+		SECONDARY_EXEC_TSC_SCALING |
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.39.0.rc1.256.g54fd8350bd-goog

