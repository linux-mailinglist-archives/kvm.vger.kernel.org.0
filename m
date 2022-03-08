Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF594D205F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349204AbiCHSpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbiCHSpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:45:51 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E504FC7A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:44:53 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id s42so185507pfg.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F9iW0OVbthqHVjxJAxEXlEyGZtYeqKxwSIaWo5GZTas=;
        b=Q3cQnIc3ElpP/gss4isBnkT5tvfJ3hTwiROMAEWXzVNHtn7vH5rTDwbrOteD8UaeRk
         NKMKiJB0UDv0RkR5hVLcsB66LS3g2CsFZrZRpQbTEencmQWRTTSmKjL09M0srYleG5k+
         VgLKi/RFKKSBZwBtdfN2SmS4DGCqGUCRa0le+spniEFp4QKUwoKOI7pmrQlWqtqfYrkp
         jayz4RWUnq3lMz9WFrWHpZx65NczM2L9UbGLSS6axF1tiSbvzMB07LTuigbwobeINlD7
         pkCDFMGFDU3QSm0PTYrB5Tb00AqWmftitCtIhxhTKapgESQrGgaEdqHnosObJlPS1Jjj
         OE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F9iW0OVbthqHVjxJAxEXlEyGZtYeqKxwSIaWo5GZTas=;
        b=imWoRCNeLROGTJ2GOIFEWEnL9wd/Zr4mkuS5ND2A656iopdYkcmgbs7fXJ6uuH8coc
         a0Hmyj5vCtAdsc8TDN6IB58j6TGhnOlhRDZNH0RnPYhCWoPudRpO2SSYv7Tfuckahfwe
         kiE91qCxSVf8cHCBzX+Tt9E+Vxd2abhQn56YzChLaTYYKrcH7CfV+b6E14km7SS6TDCH
         jgOp/9GjrPVfXsxiowFPzqOLs2B5VL3Gf40TYPLzYcz77PRhQuqziS6TVk06+NRO3gTH
         WAUe4cbVktogites0a61JpEjmJcjMjDE+iJiIYN+qkXU5lxVs/uAa3kg3vM3Yvj/P5nE
         MziA==
X-Gm-Message-State: AOAM5318EORqs1pCbi3k4iQnTyPb6W9LNkokUGqpoqOcB0sfQlsbaela
        0YQ9beVkq9iPfM08X+IgRpalqw==
X-Google-Smtp-Source: ABdhPJwqZg/ojI0iBDzhfukakkpXarGU5usTmUXLDTEA9mCTtIohCGSu3Rrew29iVrh/UUrA0h9aFg==
X-Received: by 2002:a62:8389:0:b0:4f7:2b72:3589 with SMTP id h131-20020a628389000000b004f72b723589mr5100912pfe.57.1646765093267;
        Tue, 08 Mar 2022 10:44:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a0002c500b004f6dbd217c9sm12807965pft.108.2022.03.08.10.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 10:44:52 -0800 (PST)
Date:   Tue, 8 Mar 2022 18:44:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 12/25] KVM: x86/mmu: cleanup computation of MMU roles
 for two-dimensional paging
Message-ID: <YiekIeAfGpPnqHT0@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-13-pbonzini@redhat.com>
 <YiecYxd/YreGFWpB@google.com>
 <2e6c4c58-d4d2-69e2-f8ed-c93d9c13365b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e6c4c58-d4d2-69e2-f8ed-c93d9c13365b@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Paolo Bonzini wrote:
> On 3/8/22 19:11, Sean Christopherson wrote:
> > On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> > > Extended bits are unnecessary because page walking uses the CPU mode,
> > > and EFER.NX/CR0.WP can be set to one unconditionally---matching the
> > > format of shadow pages rather than the format of guest pages.
> > 
> > But they don't match the format of shadow pages.  EPT has an equivalent to NX in
> > that KVM can always clear X, but KVM explicitly supports running with EPT and
> > EFER.NX=0 in the host (32-bit non-PAE kernels).
> 
> In which case bit 2 of EPTs doesn't change meaning, does it?
> 
> > CR0.WP equally confusing.  Yes, both EPT and NPT enforce write protection at all
> > times, but EPT has no concept of user vs. supervisor in the EPT tables themselves,
> > at least with respect to writes (thanks mode-based execution for the qualifier...).
> > NPT is even worse as the APM explicitly states:
> > 
> >    The host hCR0.WP bit is ignored under nested paging.
> > 
> > Unless there's some hidden dependency I'm missing, I'd prefer we arbitrarily leave
> > them zero.
> 
> Setting EFER.NX=0 might be okay for EPT/NPT, but I'd prefer to set it
> respectively to 1 (X bit always present) and host EFER.NX (NX bit present
> depending on host EFER).
> 
> For CR0.WP it should really be 1 in my opinion, because CR0.WP=0 implies
> having a concept of user vs. supervisor access: CR0.WP=1 is the "default",
> while CR0.WP=0 is "always allow *supervisor* writes".

Yeah, I think we generally agree, just came to different conclusions :-)  I'm
totally fine setting them to '1', especially given the patch I just "posted",
but please add comments (suggested NX comment below).  The explicit "WP is ignored"
blurb for hCR0 on NPT will be especially confusing at some point.

With efer_nx forced to '1', we can do this somewhere in this series.  I really,
really despise "context" :-).

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9c79a0927a48..657df7fd74bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4461,25 +4461,15 @@ static inline bool boot_cpu_is_amd(void)
        return shadow_x_mask == 0;
 }
 
-static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
+static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *mmu)
 {
-       /*
-        * KVM doesn't honor execute-protection from the host page tables, but
-        * NX is required and potentially used at any time by KVM for NPT, as
-        * the NX hugepages iTLB multi-hit mitigation is supported for any CPU
-        * despite no known AMD (and derivative) CPUs being affected by erratum.
-        */
-       bool efer_nx = true;
-
-       struct rsvd_bits_validate *shadow_zero_check;
        int i;
 
-       shadow_zero_check = &context->shadow_zero_check;
+       shadow_zero_check = &mmu->shadow_zero_check;
 
        if (boot_cpu_is_amd())
                __reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-                                       context->shadow_root_level, efer_nx,
+                                       mmu->shadow_root_level, is_efer_nx(mmu),
                                        boot_cpu_has(X86_FEATURE_GBPAGES),
                                        false, true);
        else
@@ -4490,7 +4480,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
        if (!shadow_me_mask)
                return;
 
-       for (i = context->shadow_root_level; --i >= 0;) {
+       for (i = mmu->shadow_root_level; --i >= 0;) {
                shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
                shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
        }
@@ -4751,6 +4741,16 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 
        role.base.access = ACC_ALL;
        role.base.cr0_wp = true;
+
+       /*
+        * KVM doesn't honor execute-protection from the host page tables, but
+        * NX is required and potentially used at any time by KVM for NPT, as
+        * the NX hugepages iTLB multi-hit mitigation is supported for any CPU
+        * despite no known AMD (and derivative) CPUs being affected by erratum.
+        *
+        * This is functionally accurate for EPT, if technically wrong, as KVM
+        * can always clear the X bit on EPT,
+        */
        role.base.efer_nx = true;
        role.base.smm = cpu_mode.base.smm;
        role.base.guest_mode = cpu_mode.base.guest_mode;
