Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7274D2054
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349163AbiCHSji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245605AbiCHSjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:39:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C942B4D61A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:38:40 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso146593pjq.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=up5SOqkS1c2YxufJMitUtCe/F041I0eBoqVuvFaIi14=;
        b=Yu+OEkPEBS8oeTtsT+vohVPQVY0eJugguC8PVRzsIdtoUrjakTG2ZwN5nBUCG8Y5cs
         OIxPqxLfDiVt+SLmjC7EYWZKCbAyJLesSFAwV83jOS37DekiTEKNoKdHffJclwiTn/9o
         mTCOkVpCZ8qH0dqDIyV/VWgKEzJnbB4zNvxnz+2GcO1bGj735ahjfYAGHSpmBKau4DjO
         DJV92sPKVbPbLWk96poS+Gh+YApIguYBUndckk58uMq4l3OKGZsOlSe+x3kT/PBgDofC
         pLcq9FjkQ5Mq7NuLC77yLfxgLN3d1N2M4Hhzs3Y2eZXbDvhxi0hjKQPbRj1MJwCU8Y3p
         3Jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=up5SOqkS1c2YxufJMitUtCe/F041I0eBoqVuvFaIi14=;
        b=xrj5ocHTw357ZVgsfX3KaEYV9oHddzpSxGgLksnMRW8H6w1gq5ED/YbNoHa9UkPnJ4
         R9+sbO7poAqqTjFeLSMBrPuEI55stlnsKja+DjqtcAVdDNYfmJbr7pd0qcSIFJYigSO0
         dUNQIIlr31gqB/NPosUTV7Q5cdIiV63XMieAcHKu/m1upw8JAlmgIpm+q6WGWBANItKO
         K3x1fI7bbDI2jWhNFeZd03ki3hibnEvWNmOqx7i0ev24WklHlUeBy1VOo/ofwmNaNHM+
         XF6RP7qFxaw/k4H4qc5wUmf3RzFtiwygajzMnc03Css9/KxLLHTO5f1jAueaaN5ZdKbw
         tASQ==
X-Gm-Message-State: AOAM532v2Q99fgY3lKGBAzelIWt/74KJ05/Wu/fdViGQbFCitr3tpW83
        EUTJFMHE0Tjz2MAYnikAZWvR9Q==
X-Google-Smtp-Source: ABdhPJysNWcyyQtHfaWhBht4VOiyJfISxakl1SxR9PkH4FPhQ6OEMqTAFTp3KYnN0nBW81eeadBhUQ==
X-Received: by 2002:a17:902:e852:b0:151:f805:30fc with SMTP id t18-20020a170902e85200b00151f80530fcmr7749014plg.87.1646764719847;
        Tue, 08 Mar 2022 10:38:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm20472715pfu.120.2022.03.08.10.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 10:38:39 -0800 (PST)
Date:   Tue, 8 Mar 2022 18:38:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 12/25] KVM: x86/mmu: cleanup computation of MMU roles
 for two-dimensional paging
Message-ID: <YieirBSr1FfELXXH@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-13-pbonzini@redhat.com>
 <YiecYxd/YreGFWpB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiecYxd/YreGFWpB@google.com>
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

On Tue, Mar 08, 2022, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> > Inline kvm_calc_mmu_role_common into its sole caller, and simplify it
> > by removing the computation of unnecessary bits.
> > 
> > Extended bits are unnecessary because page walking uses the CPU mode,
> > and EFER.NX/CR0.WP can be set to one unconditionally---matching the
> > format of shadow pages rather than the format of guest pages.
> 
> But they don't match the format of shadow pages.  EPT has an equivalent to NX in
> that KVM can always clear X, but KVM explicitly supports running with EPT and
> EFER.NX=0 in the host (32-bit non-PAE kernels).

Oof, digging into this made me realize we probably have yet another bug in the
handling of the NX hugepages workaround.  Unless I'm overlooking something, NX is
treated as reserved for NPT shadow pages and would cause WARN spam if someone
enabled the mitigation on AMD CPUs.

Untested...  If this is needed, it also means I didn't properly test commit
b26a71a1a5b9 ("KVM: SVM: Refuse to load kvm_amd if NX support is not available").

:-(

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 8 Mar 2022 10:31:27 -0800
Subject: [PATCH] KVM: x86/mmu: Don't treat NX as reserved for NPT MMUs

Mark the NX bit as allowed for NPT shadow pages.  KVM doesn't use NX in
"normal" operation as KVM doesn't honor userspace execute-protection
settings, but KVM allows userspace to enable the NX hugepages mitigation
on AMD CPUs, despite no known AMD CPUs being affected by the iTLB
multi-hit erratum.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47a2c5f3044d..9c79a0927a48 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4461,13 +4461,17 @@ static inline bool boot_cpu_is_amd(void)
 	return shadow_x_mask == 0;
 }

-/*
- * the direct page table on host, use as much mmu features as
- * possible, however, kvm currently does not do execution-protection.
- */
 static void
 reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 {
+	/*
+	 * KVM doesn't honor execute-protection from the host page tables, but
+	 * NX is required and potentially used at any time by KVM for NPT, as
+	 * the NX hugepages iTLB multi-hit mitigation is supported for any CPU
+	 * despite no known AMD (and derivative) CPUs being affected by erratum.
+	 */
+	bool efer_nx = true;
+
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;

@@ -4475,7 +4479,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)

 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					context->shadow_root_level, efer_nx,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else

base-commit: 2a809a65d88e7e071dc6ef4a6be8416d25885efe
--

