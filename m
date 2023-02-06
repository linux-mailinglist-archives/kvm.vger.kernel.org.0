Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5088568C905
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 22:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBFV4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 16:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBFV4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 16:56:21 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6675C2CFFA
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 13:56:19 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id i2so265199ple.13
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 13:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oA+FxdNbik0My0S0w1KEYLj8BIpspP5MVk4vSgrFZDY=;
        b=BHbtL49V7eD3chaeBphkHxjpsci87f5SE3/zKPIc0AfJm1XseNAUVc+uNHO2CcsQGo
         2kEa2f2Q3aM1JIewTxThJzhiP6NUNxp1Lq3BCR9o2etRJAUPzd6qDCA6ZvO8jPgz0wWt
         sAPc26FbOdMaQB8ODAiCsA4fcfh9A2+XI8pOHwemq7bBL2dUOHYlbxUWA61iPfP/Zicu
         zgUa39pMvhabrRgj145XkMYKGZrnENNj4bl/dZe9vR9qA9XiJHNyf5pFns+zrflmlbyM
         kIACW0t8VnUjTNUP3VfqPgBYM11+C8vU4qwjGffr1JCBBxWaNgn7aN4IrCh0mHlCHXkE
         K3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oA+FxdNbik0My0S0w1KEYLj8BIpspP5MVk4vSgrFZDY=;
        b=NCHM6Mgp1oRqxCXoGzKuN+dnfM9UOsArmlkF0ySQgqPb2z86JB9clhw62gFJdN6GqW
         y6tzkgDuJ3uwyyaAttwu6Krpx+b5XMKnX8B5DzMKCDWS/1LpuvAgyssYqZtuzZVHcXxA
         Rzn1LdBoAwASjeX/gHkLDW+aK7yHGHCqGTWoeThJqIoNM+341Fm9ub7xJ8KNT0AyxpF8
         3zXac31T58n2BWIhRyWmaV/QURvw04ska/b/T9ZVCuwnPV2aFnf//y9Cw1ihoVojGsVn
         rMM00trmtxcHaRISn3+1PazIoxrRTqeQfV2ZVqSvdcXO1w+CEzI8Auh+QxHCn6Xy10av
         OOvg==
X-Gm-Message-State: AO0yUKVDeMwCNTvyzHc16dtZUjy1My/G7YOBERtJ+Sg+qdt2LLYbhfAC
        hvsSri33Tx+mx0zb4r8xpSrjzg==
X-Google-Smtp-Source: AK7set+nfKw5e0Hzkmy44AwvwG2vbmauGBb7aCLDo77wtcxyHHae1qJWSLm6Ix2gG/rReAwpEbgehQ==
X-Received: by 2002:a17:902:c111:b0:198:af50:e4e3 with SMTP id 17-20020a170902c11100b00198af50e4e3mr37973pli.9.1675720578672;
        Mon, 06 Feb 2023 13:56:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b0019678eb963fsm2781851pln.145.2023.02.06.13.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 13:56:17 -0800 (PST)
Date:   Mon, 6 Feb 2023 21:56:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alejandro.j.jimenez@oracle.com, mlevitsk@redhat.com,
        pbonzini@redhat.com, jon.grimm@amd.com, vasant.hegde@amd.com,
        kishon.vijayabraham@amd.com
Subject: Re: [PATCH] KVM: SVM: Modify AVIC GATag to support max number of 512
 vCPUs
Message-ID: <Y+F3fr1HfC+pmmnF@google.com>
References: <20230117100821.10116-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117100821.10116-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TL;DR: I'm going to post v2 of this along with some other fixes+hardening.

On Tue, Jan 17, 2023, Suravee Suthikulpanit wrote:
> AVIC GATag is managed by the SVM driver, and is used by the IOMMU driver

s/SVM driver/KVM

> to program the AMD IOMMU IRTE to provide reference back to SVM in case

s/SVM/KVM

We do sometimes use "VMX" and "SVM" to refer to KVM, but usually only when
differentiating betwen "KVM x86" and "KVM <vendor>".  In most cases I don't think
it would matter, but in this particular case, since the GATag is kinda sorta
consumed by hardware, but IIUC is purely software-defined, knowing whether "SVM"
means "KVM" or "SVM the architecture" is an important distinction.

> the IOMMU cannot inject interrupt to the non-running vCPU. In such case,
> the IOMMU hardware notify the IOMMU driver by creating GALog entry with

Definitely a nit, but I would probably omit the info about the IOMMU driver.  That
information matters if someone is trying to understand _all_ of the pieces, but
for this specific bug I think it just ends up introducing noise.

> the corresponded GATag. The IOMMU driver processes the GALog entry and
> notifies SVM to schedule in the target vCPU.
> 
> Currently, SVM uses 8-bit vCPU ID and 24-bit VM ID to encode 32-bit GATag.
> Since x2AVIC supports upto 512 vCPUs, it requires to use at least 9-bit

"up to"

Nit, x2AVIC doesn't "require" anything.  What matters is what KVM allows.  I get
what you're saying, but I want to cleanly separate "what's allowed by the spec"
and "what does KVM actually do".

> vCPU ID.
> 
> Therefore, modify the GATag enconding to use the number of bits required

s/enconding/encoding

> to support the maximum vCPUs.

Thank you for the explanation of how this all works!  IIUC, this is missing one
key point though: the GATag is 100% software-defined and never interpreted by
hardware.  I.e. KVM can shove whatever it wants into the tag.

And while I'm nitpicking, please lead with the "what".  For the changelog as a whole,
some maintainers/subsystems prefer leading with the "why", but I strongly prefer that
changelogs state what the patch actually does and then provide the background/justification.

Copy-pasting a prior copy-paste (I really need to save this as a Vim macro formletter)

 : To some extent, it's a personal preference, e.g. I
 : find it easier to understand the details (why something is a problem) if I have
 : the extra context of how a problem is fixed (or: what code was broken).
 :
 : But beyond personal preference, there are less subjective reasons for stating
 : what a patch does before diving into details.  First and foremost, what code is
 : actually being changed is the most important information, and so that information
 : should be easy to find.  Changelogs that bury the "what's actually changing" in a
 : one-liner after 3+ paragraphs of background make it very hard to find that information.
 :
 : Maybe for initial review one could argue that "what's the bug" is more important,
 : but for skimming logs and git archeology, the gory details matter less and less.
 : E.g. when doing a series of "git blame", the details of each change along the way
 : are useless, the details only matter for the culprit; I just want to quickly
 : determine whether or not a commit might be of interest.
 :
 : Another argument for stating "what's changing" first is that it's almost always
 : possible to state "what's changing" in a single sentence.  Conversely, all but the
 : most simple bugs require multiple sentences or paragraphs to fully describe the
 : problem.  If both the "what's changing" and "what's the bug" are super short then
 : the order doesn't matter.  But if one is shorter (almost always the "what's changing),
 : then covering the shorter one first is advantageous because it's less of an
 : inconvenience for readers/reviewers that have a strict ordering preference.  E.g.
 : having to skip one sentence to get to the stuff you care about is less painful than
 : me having to skip three paragraphs to get to the stuff that I care about.

[*] https://lore.kernel.org/all/YurKx+gFAWPvj35L@google.com

> Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 3 ++-
>  arch/x86/kvm/svm/avic.c    | 9 ++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 0361626841bc..6738faf155e4 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -256,7 +256,8 @@ enum avic_ipi_failure_cause {
>  	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
>  };
>  
> -#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)

Isn't the existing mask wrong?  The high bit is inclusive, i.e. this is defining
a mask of 10 bits, not 9.

Actually, neither 10 nor 9 bits is correct if we are going by the most recent APM,
i.e. the mask should be 8:0 if we want to tie this to what is actually defined in
the architecture.

  All the addresses point to 4-Kbyte aligned data structures. Bits 11:0 are reserved
  (except for offset 0F8h) and should be set to zero. The lower 8 bits of offset 0F8h
  are used for the field AVIC_PHYSICAL_MAX_INDEX. VMRUN fails with #VMEXIT(VMEXIT_INVALID)
  if AVIC_PHYSICAL_MAX_INDEX is greater than 255 in xAVIC mode or greater than 511 in
  x2AVIC mode.

Looking through the discussion history of the x2AVIC enabling, this appears to be
an off-by-one goof, i.e. not a deliberate speculation on how bits 11:9 will be
used.

> +#define AVIC_PHYSICAL_MAX_INDEX_BITS	9

This name is misleading/wrong.  As above, the high bit is inclusive.  If we wanted
to specify the high bit, it would be something like MAX_INDEX_MAX_BIT, which is pretty
awful.

Ha!  We don't need a separate define.  const_hweight.h provides compile-time
hweight, a.k.a. popcount, macros.  We can use that to compute the shift of the
VM ID portion of the GATag, then we don't need to come up with a name.

I'll post the below as v2 on top of the AVIC_PHYSICAL_MAX_INDEX_MASK fix.

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ca684979e90d..326341a22153 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,19 +27,29 @@
 #include "irq.h"
 #include "svm.h"
 
-/* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS              8
-#define AVIC_VCPU_ID_MASK              ((1 << AVIC_VCPU_ID_BITS) - 1)
+/*
+ * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
+ * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
+ * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ *
+ * For the vCPU ID, use however many bits are currently allowed for the max
+ * guest physical APIC ID (limited by the size of the physical ID table), and
+ * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
+ * size of the GATag is defined by hardware (32 bits), but is an opaque value
+ * as far as hardware is concerned.
+ */
+#define AVIC_VCPU_ID_MASK              AVIC_PHYSICAL_MAX_INDEX_MASK
 
-#define AVIC_VM_ID_BITS                        24
-#define AVIC_VM_ID_NR                  (1 << AVIC_VM_ID_BITS)
-#define AVIC_VM_ID_MASK                        ((1 << AVIC_VM_ID_BITS) - 1)
+#define AVIC_VM_ID_SHIFT               HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_MASK                        (GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
-#define AVIC_GATAG(x, y)               (((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+#define AVIC_GATAG(x, y)               (((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
                                                (y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)          ((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VMID(x)          ((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)                (x & AVIC_VCPU_ID_MASK)
 
+static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 

