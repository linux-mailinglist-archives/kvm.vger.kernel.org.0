Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8B5425EA
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442782AbiFHBA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574465AbiFGXZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:25:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9411EDD2D
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so9885457pjb.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cSKpn6SMwTsMUj7CoeqNmjfQf5su6IS+82GqcaqnP00=;
        b=JWGXT7GEWj3pb9eTehi/Y90hNRe2r2nD3GODPRsCFGFIO94KMlBrx7c8XB4DkoWFap
         tI4niM/3ed3SzDY3NNkzOSRYzSLkiLqPjkk3As2ovRFbd7pmVxZt+sXbTl9x8LiAAORi
         3Vr9LYTZi42R/BwxBDnt3jkpFPN+FupD/o/vIOY+4xjMON2gHl0fqkFDS8Yg5YKrTe/c
         ciWQpj/Mlx/ZoNQ6xdJFdhWaJnLFxmXQSqomzM0qnlnJZqYtX4teaqf2dzyoJ1KIMKVG
         rln0JOiOQl42ONjEwe3TmRLV8G0Jb3/5MmIy3TScrZlJTjBvqimcF2h1BdxYiVVdv7sE
         hOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cSKpn6SMwTsMUj7CoeqNmjfQf5su6IS+82GqcaqnP00=;
        b=QWcsuFct1QotMxDDIYfVGefMZQoy4FQn2ebYyYIve7gw7YVymirXK17EXk+OdLlJ21
         uBGTkxWXF2RqFDoPhdgKv0Huzr76yriD1i0q4YpwQfM0QMlsZkWV4o/ZHeS2IFwD30ml
         m3PItntJocaIJq7lUVdaQvI/iV/4GaP5MURkiCk0VZg+/rxgk/b+h99ib4Hcq1G+NpD6
         pObwM3D3JDjDscT9g9BE1XsKxFS+Ai1tWc4kcQxb4gAjTCI9PkT5R5iylzhjwoiK5x+y
         UNzHc5YR/tNgEb6QcoPc8d1TlMV/jXJuAQUM+KKVRZ6gaAHLV4Nh0t8Z3ZLWi8SFKyuo
         M1eA==
X-Gm-Message-State: AOAM531TeRuVj3p8grv2Bw/afQP98w9ClRm+CHvDSMQn9xQmcxftctko
        z3mbnKfoUkq1sJWmRnbzLAWoHaoUvGI=
X-Google-Smtp-Source: ABdhPJwE2W93MwTTHTpFoshK51Bw9wW68F1SgoKDpJfNb8EAazUid7gT93Su7z8/oN2Qp2FKn/9dCM2Yy7E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7594:b0:15e:bbac:8d49 with SMTP id
 j20-20020a170902759400b0015ebbac8d49mr30533387pll.124.1654637783148; Tue, 07
 Jun 2022 14:36:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:52 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 03/15] KVM: nVMX: Inject #UD if VMXON is attempted with
 incompatible CR0/CR4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject a #UD if L1 attempts VMXON with a CR0 or CR4 that is disallowed
per the associated nested VMX MSRs' fixed0/1 settings.  KVM cannot rely
on hardware to perform the checks, even for the few checks that have
higher priority than VM-Exit, as (a) KVM may have forced CR0/CR4 bits in
hardware while running the guest, (b) there may incompatible CR0/CR4 bits
that have lower priority than VM-Exit, e.g. CR0.NE, and (c) userspace may
have further restricted the allowed CR0/CR4 values by manipulating the
guest's nested VMX MSRs.

Note, despite a very strong desire to throw shade at Jim, commit
70f3aac964ae ("kvm: nVMX: Remove superfluous VMX instruction fault checks")
is not to blame for the buggy behavior (though the comment...).  That
commit only removed the CR0.PE, EFLAGS.VM, and COMPATIBILITY mode checks
(though it did erroneously drop the CPL check, but that has already been
remedied).  KVM may force CR0.PE=1, but will do so only when also
forcing EFLAGS.VM=1 to emulate Real Mode, i.e. hardware will still #UD.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216033
Fixes: ec378aeef9df ("KVM: nVMX: Implement VMXON and VMXOFF")
Reported-by: Eric Li <ercli@ucdavis.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8cd0ebcc75..9a5b6ef16c1c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4968,20 +4968,25 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * The Intel VMX Instruction Reference lists a bunch of bits that are
-	 * prerequisite to running VMXON, most notably cr4.VMXE must be set to
-	 * 1 (see vmx_is_valid_cr4() for when we allow the guest to set this).
-	 * Otherwise, we should fail with #UD.  But most faulting conditions
-	 * have already been checked by hardware, prior to the VM-exit for
-	 * VMXON.  We do test guest cr4.VMXE because processor CR4 always has
-	 * that bit set to 1 in non-root mode.
+	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
+	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
+	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 *
+	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
+	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
+	 * Mode, but KVM will never take the guest out of those modes.
 	 */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	/* CPL=0 must be checked manually. */
+	/*
+	 * CPL=0 and all other checks that are lower priority than VM-Exit must
+	 * be checked manually.
+	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-- 
2.36.1.255.ge46751e96f-goog

