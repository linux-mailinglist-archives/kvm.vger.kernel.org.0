Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFCC62387A
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 01:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiKJA5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 19:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiKJA5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 19:57:11 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11EA20F56
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 16:57:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x8-20020aa79568000000b0056dd717e051so171031pfq.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 16:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sfZqtehmJAKW3XdILp4Pa+j/G6SeiEXkrRjwBXbPNQ4=;
        b=R7MO5UZg7uZuGhIBEVZ0K4sBRl8uHVbSzpOR8CzrHMoASp/lJy34BFMEJHsE8QIqZ+
         sGptJIr7AgU4nzsg/w0iyGjWoaNtEPB3XPsCTmvjm0wVVuHpbtlG982CUVHn8CnDy5CA
         sjkyyVXgKgtz3Zttb/ukzdRtLTijU4LiFs7fGlnv+JSvcEbqHn0kmD1dAFd2X4kJPF+x
         jzF4z1P9e1xclKp9nHV5MLieEWO+nZ2pb9SH6c06g6yeVbTDqkJaXZdUIuW+bMpVbx1o
         tOAUda2uGLt459EygROZFC4+2hwWi0rjATlKT0xIuw8ScDvX5JeqNiBqNSTx3oEXA9FU
         4zqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfZqtehmJAKW3XdILp4Pa+j/G6SeiEXkrRjwBXbPNQ4=;
        b=RsabM9SKhT6j/u3nQB2+1tAST893mmOO3NOHcuKazMClz3H/a5n+T3Uda6lQKv856C
         kOZTEt5feNhsrIDGCrjXJnQjC3sAuAatFmRCPJxlHTN0XMmkJeLfLidCItEyV/ZrnWCv
         0EtvnDTxEvCySksf3QzoEAIEyv0TPlRPNupNQeAF2GZ8/NPPC89Ld8myO2y7n0XPEeof
         DmyAM1yJ6vIIjDORQifGShRlDkrXxQEMDsQLmQobs1lTLsAY7SPu6ZlSD9v0vh25a5Zh
         VwIZyK4Fv9lzN4DTAp5D51BtFTXsMKCWgFDtFy8bLlkI/nS6BDppalTwaCqm3iYK8X4z
         rbng==
X-Gm-Message-State: ACrzQf0Ax9g8Q9iEBmOIWWwK8cUTzK6R4F7h7Mb/d4lDNLm5OqECLRw5
        BimonJMie3/FqNAJA1y4/ZqAaUjr+a8=
X-Google-Smtp-Source: AMsMyM4WRNtIl3Riz4W8+eM2I9MeCMHVFp7PazBTAuTfgJdkEPJzdC5uVayhgT5JdlqoyKb/XWxH/+oQuv8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce88:b0:186:b345:97c0 with SMTP id
 f8-20020a170902ce8800b00186b34597c0mr64227380plg.13.1668041830237; Wed, 09
 Nov 2022 16:57:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 00:57:05 +0000
In-Reply-To: <20221110005706.1064832-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221110005706.1064832-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110005706.1064832-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: nVMX: Don't muck with allowed sec exec controls on
 CPUID changes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Don't modify the set of allowed secondary execution controls, i.e. the
virtual MSR_IA32_VMX_PROCBASED_CTLS2, in response to guest CPUID changes.
To avoid breaking old userspace that never sets the VMX MSRs, i.e. relies
on KVM to provide a consistent vCPU model, keep the existing behavior if
userspace has never written MSR_IA32_VMX_PROCBASED_CTLS2.

KVM should not modify the VMX capabilities presented to L1 based on CPUID
as doing so may discard explicit settings provided by userspace.  E.g. if
userspace does KVM_SET_MSRS => KVM_SET_CPUID and disables a feature in
the VMX MSRs but not CPUID (to prevent exposing the feature to L2), then
stuffing the VMX MSRs during KVM_SET_CPUID will expose the feature to L2
against userspace's wishes.

Alternatively, KVM could add a quirk, but that's less than ideal as a VMM
that is affected by the bug would need to be updated in order to opt out
of the buggy behavior.  The "has the MSR ever been written" logic handles
both the case where an enlightened userspace sets the MSR during setup,
and the case where userspace blindly migrates the MSR, as the migrated
value will already have been sanitized by the source KVM or explicitly
set by the source VMM.

Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..7b08d6006f52 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -51,6 +51,7 @@ struct nested_vmx_msrs {
 	u64 cr4_fixed1;
 	u64 vmcs_enum;
 	u64 vmfunc_controls;
+	bool secondary_set_by_userspace;
 };
 
 struct vmcs_config {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a..e537526d996c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1256,6 +1256,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
+	if (msr_index == MSR_IA32_VMX_PROCBASED_CTLS2)
+		vmx->nested.msrs.secondary_set_by_userspace = true;
+
 	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca88524fd1e..e5eec41bc1d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4428,7 +4428,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 	 * Update the nested MSR settings so that a nested VMM can/can't set
 	 * controls for features that are/aren't exposed to the guest.
 	 */
-	if (nested) {
+	if (nested && !vmx->nested.msrs.secondary_set_by_userspace) {
 		if (enabled)
 			vmx->nested.msrs.secondary_ctls_high |= control;
 		else
-- 
2.38.1.431.g37b22c650d-goog

