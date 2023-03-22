Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC366C5485
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 20:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCVTHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 15:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVTHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 15:07:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EB72C668
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 12:07:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54476ef9caeso196439687b3.6
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 12:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679512033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vE+oNa+TksmDQ+JifPl+V3NSuDwc6jEU0q0uXD5y0Js=;
        b=U8vTl4F0Pv5crWpZpIdMmw9yo7ULFKtq+xDh6q35E51XOpeQlHBIQLKm9rSY3wl/+c
         TNGxdCX0MVdgggOwTWynU0eZymHzs9ecEAJ2TuFBQsgJjTWs68teiCu3gbPDwQQaLNVr
         mHNrUJGlyNIn/b0/Jqck3T7GhcN7fErL40Wo19MoLTsE6riqxNQb0+75cxNvgSjVRxC4
         PkW9+gkaOKDNtYdjJMvB/LNJqtHXjW1hmKaRg1fLY6ukbHNAL+pVGQQl/EmNFR1AkcOd
         dUWsO3xlZOHtdeo1Y3fdBmTKKBZxzXqCCyH9THDKooC9TkkmfGu5lk0KcWSZahJjj6Dd
         AtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679512033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vE+oNa+TksmDQ+JifPl+V3NSuDwc6jEU0q0uXD5y0Js=;
        b=LBd/NbJ+phtZmzxrlkgtoiBJpJO3yTwUUDfi3xYfz2pg3hDFJw2aMzCe0bGzs/YK+Z
         NRdktU4hKfz+r/owjsywUMiEiO0YgqPtgmuDrg6jmmZsJoGLCJYMoUG8eNCxT0Hmu/I5
         J6Q3PVX363tmsVI96psDNGZoWKUufcHzGpn88sBYOhyC/D+XRH7QqQpHU9eD76U9lyWs
         jzyYvcBOonU7tCizpJ0GVkn638vvJyFMm21438PMcFzen9Znqj+HljK3vo+/77Yxfse1
         ecvdryox1unv9kz8tfs4Nr8QSGyvH89x/BiB+XIZJM/cAuWKE82nwp7YUG1B5gyMCLXS
         qsKA==
X-Gm-Message-State: AAQBX9cfeBAcGEByiRXJsuI+s9+aQ2aAeHxbMFARYA4VyKyVuEjjrQea
        HixvQFzyj1N9zixFSObgE8v4ne6KFqM=
X-Google-Smtp-Source: AKy350bg7050Eg0NMHpU+BZNbxdIe1GVPBxZ/D+eJNy0YM+8UvAbQaYspLxSJZOrtre3CHCliJV1W/ULMUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:b4a:e062:3576 with SMTP id
 w5-20020a056902100500b00b4ae0623576mr459229ybt.13.1679512033734; Wed, 22 Mar
 2023 12:07:13 -0700 (PDT)
Date:   Wed, 22 Mar 2023 12:07:12 -0700
In-Reply-To: <20230227084016.3368-9-santosh.shukla@amd.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com> <20230227084016.3368-9-santosh.shukla@amd.com>
Message-ID: <ZBtR4C2Dic4i2JRJ@google.com>
Subject: Re: [PATCHv4 08/11] x86/cpu: Add CPUID feature bit for VNMI
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Santosh Shukla wrote:
> VNMI feature allows the hypervisor to inject NMI into the guest w/o
> using Event injection mechanism, The benefit of using VNMI over the
> event Injection that does not require tracking the Guest's NMI state and
> intercepting the IRET for the NMI completion. VNMI achieves that by
> exposing 3 capability bits in VMCB intr_cntrl which helps with
> virtualizing NMI injection and NMI_Masking.
> 
> The presence of this feature is indicated via the CPUID function
> 0x8000000A_EDX[25].
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index cdb7e1492311..b3ae49f36008 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -365,6 +365,7 @@
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
>  #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
> +#define X86_FEATURE_AMD_VNMI		(15*32+25) /* Virtual NMI */

Rather than carry VNMI and AMD_VNMI, what if we redefine VNMI to use AMD's real
CPUID bit?  The synthetic flag exists purely so that the converion to VMX feature
flags didn't break /proc/cpuinfo.  X86_FEATURE_VNMI isn't consumed by the kernel,
and if that changes, having a common flag might actually be a good thing, e.g.
would allow common KVM code to query vNMI support without needing VMX vs. SVM
hooks.

I.e. drop this in

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 22 Mar 2023 11:33:08 -0700
Subject: [PATCH] x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's
 "real" vNMI

The existing X86_FEATURE_VNMI is a synthetic feature flag that exists
purely to maintain /proc/cpuinfo's ABI, the "real" Intel vNMI feature flag
is tracked as VMX_FEATURE_VIRTUAL_NMIS, as the feature is enumerated
through VMX MSRs, not CPUID.

AMD is also gaining virtual NMI support, but in true VMX vs. SVM form,
enumerates support through CPUID, i.e. wants to add real feature flag for
vNMI.

Redefine the syntheic X86_FEATURE_VNMI to AMD's real CPUID bit to avoid
having both X86_FEATURE_VNMI and e.g. X86_FEATURE_AMD_VNMI.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 73c9672c123b..ced9e1832589 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -226,10 +226,9 @@
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
-#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 1) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+ 2) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+ 3) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
@@ -369,6 +368,7 @@
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
 #define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
+#define X86_FEATURE_VNMI		(15*32+25) /* Virtual NMI */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */

base-commit: a3af52e7c9d801f5d7c1fcf5679aaf48c33b6e88
-- 
