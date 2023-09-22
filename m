Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3FC7AB911
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjIVSW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 14:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjIVSWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 14:22:24 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DBD192
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:22:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59bdb9fe821so36249587b3.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695406936; x=1696011736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vptbo8W/PDe0HJnv3CPs5HLi3LMVUvHQdqhEcX5IZeI=;
        b=MSZ65TJfM4RW4sUwaR5OnxdQIYXvryoX1aEpqXX7FxvOwdt7JwgJaczUvt3hR/JDad
         KyAd2upmBmocsLNz13ncVncbj09kuA+wBbByp4Rbfnvw0df/RQP5V7YukNU1ROZI1w8G
         B0H5s5DIfyEmxO7Iz5eUElrPAL9JuGnic9kRfh7rfyg1bkMQc/k37pD0gVjL7IWova+m
         tCoWsvj7jRaKqVggL3QQE2DO4D9m+BobwDUv1luYZKfjURRL26CU/OlMfABUrpo95/Op
         Nj5qCMNK2t4ZlaaVREXFr1Qxk2O7coohHOGKtSPZvqg1iTBmuQ2shdxSEAhKCwIHEpQA
         q3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695406936; x=1696011736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vptbo8W/PDe0HJnv3CPs5HLi3LMVUvHQdqhEcX5IZeI=;
        b=X8QPJkw3dnJAZNIl46l1G1rhxZV5waiQJb5GRuYPzln1eJUV4elHNjEkQ9uS8KoHSt
         7lvp+BW5zroy0YFIn5shmIbyl/ReoERDNKaHh1v5wb7Cgq0IX9mQEsM1QHSP4BOW3PyL
         sE/En72/+cLFoRHotESWw6JgLd+Bl/+Y5clRUQIHwl8xiyOXnLLQfPBmZpnY3cIj3fgL
         lO5ORc4A8aArJZ5NWybtwbSQf4+vNvJ03vILDrJa6Mg+EBsXUVtjQXyRhw4eS7EDt5AG
         rUE0QtvTZlOR5e6CIuGnhszq5povPUEg47Y3PXpD6HfZqNVYbvoChJZfId9OPV3EEuK0
         y7UA==
X-Gm-Message-State: AOJu0Yzh1ASzFWgHZsT/Y6hmKrhH5/svdA5/VOdhVtUtPmuK57QkiHJD
        onw4WFLnJm2pr7er4qhcmT7EyYmlrZ8=
X-Google-Smtp-Source: AGHT+IHMwf9584/wxxb8c7vkF3Qkp3sRcIoHW7TrmvVAdqNtYC6HxHCCDSqIU1pPdQo3VbudmM+LXouKywE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac57:0:b0:d86:5716:b462 with SMTP id
 r23-20020a25ac57000000b00d865716b462mr834ybd.13.1695406935945; Fri, 22 Sep
 2023 11:22:15 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:22:14 -0700
In-Reply-To: <20230901185646.2823254-2-jmattson@google.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <20230901185646.2823254-2-jmattson@google.com>
Message-ID: <ZQ3bVkWoUerGufo9@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023, Jim Mattson wrote:
> Per the SDM, "When the local APIC handles a performance-monitoring
> counters interrupt, it automatically sets the mask flag in the LVT
> performance counter register."
> 
> Add this behavior to KVM's local APIC emulation, to reduce the
> incidence of "dazed and confused" spurious NMI warnings in Linux
> guests (at least, those that use a PMI handler with "late_ack").

Hmm, I don't like the "to reduce the incidence" language as that suggests that
this isn't a hard requirement.  That makes it sound like KVM is doing the guest
a favor.  This?

    Per the SDM, "When the local APIC handles a performance-monitoring
    counters interrupt, it automatically sets the mask flag in the LVT
    performance counter register."  Add this behavior to KVM's local APIC
    emulation.
    
    Failure to mask the LVTPC entry results in spurious PMIs, e.g. when
    running Linux as a guest, PMI handlers that do a "late_ack" spew a large
    number of "dazed and confused" spurious NMI warnings.

> Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT source")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/lapic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a983a16163b1..1a79ec54ae1e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2743,6 +2743,8 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
>  		vector = reg & APIC_VECTOR_MASK;
>  		mode = reg & APIC_MODE_MASK;
>  		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
> +		if (lvt_type == APIC_LVTPC)
> +			kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);

IMO, unconditionally setting the masked bit is wrong.  I'm 99% certain KVM should
only set the mask bit if an interrupt is actually delivered somehwere.

__apic_accept_irq() "fails" as follows:

  APIC_DM_LOWEST and APIC_DM_FIXED
	1. Trigger Mode is "level" triggered and level is deasserted.  This can't
           happen because this code hardcodes the level to '1'.

        2. APIC is disabled (H/W or S/W).  This is a non-issue because the H/W
           disabled case ignores it entirely, and all masks are defined to be set
           if the APIC is S/W disabled (per the SDM):

           The mask bits for all the LVT entries are set. Attempts to reset these
           bits will be ignored.


  APIC_DM_SMI
        1. If SMI injection fails because CONFIG_KVM_SMM=n.

  APIC_DM_INIT
        1. Trigger Mode is "level" triggered and level is deasserted.  As above,
           this can't happen.

  APIC_DM_EXTINT
        1. Unconditionally ignored by KVM.  This is architecturally correct for
           the LVTPC as the SDM says:

           Not supported for the LVT CMCI register, the LVT thermal monitor
           register, or the LVT performance counter register.

So basically, failure happens if and only if the guest attempts to send an SMI or
ExtINT that KVM ignores.  The SDM doesn't explicitly state that mask bit is left
unset in these cases, but my reading of

  When the local APIC handles a performance-monitoring counters interrupt, it
  automatically sets the mask flag in the LVT performance counter register.

is that there has to be an actual interrupt.

I highly doubt any software will ever care, e.g. the guest is going to be unhappy
in CONFIG_KVM_SMM=n case no matter what, but setting the mask bit without actually
triggering an interrupt seems odd.

This as fixup?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 71d87b0db0d9..ebfc3d92a266 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2759,15 +2759,17 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 {
        u32 reg = kvm_lapic_get_reg(apic, lvt_type);
        int vector, mode, trig_mode;
+       int r;
 
        if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
                vector = reg & APIC_VECTOR_MASK;
                mode = reg & APIC_MODE_MASK;
                trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
-               if (lvt_type == APIC_LVTPC)
+
+               r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
+               if (r && lvt_type == APIC_LVTPC)
                        kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);
-               return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
-                                       NULL);
+               return r;
        }
        return 0;
 }

