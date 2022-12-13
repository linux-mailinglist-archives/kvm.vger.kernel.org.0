Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1471164AFCF
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiLMGXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiLMGXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:23:15 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FA31EC78
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:13 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso1341394pjb.6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zBUvBTND7Qb+8AkTIHs8rpB4FKmhZMCK3qWfQPPeOpc=;
        b=e6C6OFLOb8WPWhN4v2ULSzWrbjXx56ED4i5lMniYzFZp7iU3GKnhN/XE9SJhra6oAu
         4M6IVE6RT6irQ3FusAwo03VBo8RoBsEhfrG/JVYMjeMh4cRWTLI0MeGa60/EL9J1a6WI
         H9VjDdo11T3r9/r19L1LpaRIQy7Rqli6DwWd8P+ey0p6Xj3ykK8hGAGIWDqN/0DqTUpv
         qLZe1+yrvhEYd/D/lrAq0auvklLbq9H443bCbmTaRU0iWp7tZqDiB84bctRqvvJv86xU
         J3rIlUEdsPBlx5Rg9jUArb7oZMNgi3YAy9X2YQyfWZtxIITo+NpSTbt1kkWCv0MiaCJt
         vk4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zBUvBTND7Qb+8AkTIHs8rpB4FKmhZMCK3qWfQPPeOpc=;
        b=cG4uZockIkBi6h8Tz0EbQ3D7kkXYIewpLaDFp/Za+vNq19GYrf4FXFzS+DH1c08S1m
         WknqVad9wdCUWUJSDyZDJnEICdlWKgzDyUtg4ZOJg3jX9G2QTN57Y/eKLZDpMRErIb8V
         jPf8/LQAjgq/DCawoiyky4poQjX+HIfUq3VqVF40/l3LT9pYbZJaohePKxCqZi6i2yev
         B7q6prUgjfg4+xAdJdf8gomuh3sB4rNSlU9MgcDtACgwVEfeloip2JJ8X85V3v1/LcBF
         /SKMz3MBd3gZDjBHeKj7CAGxgXHUQ+Yob5jHWEJFTg6pipXqwYV62FN8PbiY25rb5S5v
         ENQg==
X-Gm-Message-State: ANoB5pmQz9j5E9lbBPaWLkjkgwEdd4ZMpb8Kp13ZZ/Le+b8lc759SkCf
        keUdVn55OfXj7+PgNh3qZJoDXQVYYCw=
X-Google-Smtp-Source: AA0mqf4SuzqmDC9HxYCljIPHY7lqOjyZWKkQ5OIg960LQYXlJqCwWq2x/Fi/fxSO59IbwE3uO2iCQGKO9aw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:2785:0:b0:576:bb84:7b50 with SMTP id
 n127-20020a622785000000b00576bb847b50mr22811996pfn.71.1670912593481; Mon, 12
 Dec 2022 22:23:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:23:05 +0000
In-Reply-To: <20221213062306.667649-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213062306.667649-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213062306.667649-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: nVMX: Don't muck with allowed sec exec controls
 on CPUID changes
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
both the care where an enlightened userspace sets the MSR during setup,
and the case where userspace blindly migrates the MSR, as the migrated
value will already have been sanitized by the source KVM.

Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 7 +++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

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
index d131375f347a..0140893412b7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1271,6 +1271,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
+	if (msr_index == MSR_IA32_VMX_PROCBASED_CTLS2)
+		vmx->nested.msrs.secondary_set_by_userspace = true;
+
 	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13d3f5eb4c32..dd0247bc7193 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4456,9 +4456,12 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 
 	/*
 	 * Update the nested MSR settings so that a nested VMM can/can't set
-	 * controls for features that are/aren't exposed to the guest.
+	 * controls for features that are/aren't exposed to the guest.  Stuff
+	 * the MSR if and only if userspace hasn't explicitly set the MSR, i.e.
+	 * to avoid ABI breakage if userspace might be relying on KVM's flawed
+	 * behavior to expose features to L1.
 	 */
-	if (nested) {
+	if (nested && !vmx->nested.msrs.secondary_set_by_userspace) {
 		/*
 		 * All features that got grandfathered into KVM's flawed CPUID-
 		 * induced manipulation of VMX MSRs are unconditionally exposed
-- 
2.39.0.rc1.256.g54fd8350bd-goog

