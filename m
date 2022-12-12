Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05A64A539
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 17:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiLLQq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 11:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiLLQqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 11:46:06 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2D61085
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 08:46:04 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so457734pjm.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 08:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUEBGmviRgfCUTu8AFIRurdUTjbgGsbSM8qAkaRDFAU=;
        b=Zk4gC6LJ3V3Eo3KI9dA9Qf1bLIrN5dskTv26kgCq4/kggY0finzDXusQIkbFd6GQRc
         odGE6MW2vwy1pd1kXyug3h4RPGwud1WaVHq0i8anJOFszq8545/ymhsqhfdngolAGmUr
         0spT0aBldX5Ea/da4mwSnhAlkPTlrOifuPfjmYYQCjCR21+jrSaBkTGaV3RrIpCejKYK
         +naSreZEH0mjISGfiPCx+pT2xA6hVg7w+bbBQwqOE9hcKK443UnhvP2tbEliqIX0xuuK
         nLKMO9A/aMCmXoALgGujgYoP9Dgl5aVvpVyAlJ0kTfxsB/Becn84xrjnUaj7eHV9MJN+
         7qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUEBGmviRgfCUTu8AFIRurdUTjbgGsbSM8qAkaRDFAU=;
        b=fBv0ZSRCMmQ7ynyUqln2GkjKn1mJs9zbFTD0IvN4gjmq1pLBrssxeau8giH5py/UxI
         LqOZxVEkyFuX6pr4culGFWRmBwCggHfsJgTj81Ji3y+yRlCq2Qvw1sRe3g0NQnjFm1H/
         xybnTgVLtjMEDt607cIAV5MkuhNeDlQCA74S5APUmRO9surWzXgGaGK0U/tgRn/SU1rF
         58/dqdlw422KQMT2/Ig0lYGQYNdnp9f8Bktca3aSjecM3uSe+618AB5ChkF0NRbZrRFm
         wh7GY2CFeM0YHzbcNYuKmv9UVzsYndnFR9CaQS1eZj9LKC+SEksEAvuWXAwiEVEEWqS3
         +5Dg==
X-Gm-Message-State: ANoB5pk6wwHlX2SJ03SRuDt9y2I+j7bKNS8aKJ+ijPTBMDCHT40W0pnE
        zvTwwmvuvlf/ofUHYaQPdVfDLA==
X-Google-Smtp-Source: AA0mqf6cUTk1Hbz/ffbTZc/J9yZcB8zRYzBA02fnmcFnN9k2BYlXBMoQDQcibQiP3Z6HW1PA62WJfw==
X-Received: by 2002:a17:902:ebcd:b0:189:6624:58c0 with SMTP id p13-20020a170902ebcd00b00189662458c0mr807246plg.3.1670863563671;
        Mon, 12 Dec 2022 08:46:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902db0400b001891a17bd93sm6644081plx.43.2022.12.12.08.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 08:46:03 -0800 (PST)
Date:   Mon, 12 Dec 2022 16:45:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH v4 0/2] Deprecate BUG() in pte_list_remove() in
 shadow mmu
Message-ID: <Y5dax8XJV0F5adUw@google.com>
References: <20221129191237.31447-1-mizhang@google.com>
 <Y5Oob6mSJKGoDBnt@google.com>
 <Y5avm5VXpRt263wQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5avm5VXpRt263wQ@google.com>
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

On Mon, Dec 12, 2022, Mingwei Zhang wrote:
> On Fri, Dec 09, 2022, David Matlack wrote:
> > On Tue, Nov 29, 2022 at 07:12:35PM +0000, Mingwei Zhang wrote:
> > > Deprecate BUG() in pte_list_remove() in shadow mmu to avoid crashing a
> > > physical machine. There are several reasons and motivations to do so:
> > > 
> > > MMU bug is difficult to discover due to various racing conditions and
> > > corner cases and thus it extremely hard to debug. The situation gets much
> > > worse when it triggers the shutdown of a host. Host machine crash might
> > > eliminates everything including the potential clues for debugging.
> > > 
> > > From cloud computing service perspective, BUG() or BUG_ON() is probably no
> > > longer appropriate as the host reliability is top priority. Crashing the
> > > physical machine is almost never a good option as it eliminates innocent
> > > VMs and cause service outage in a larger scope. Even worse, if attacker can
> > > reliably triggers this code by diverting the control flow or corrupting the
> > > memory, then this becomes vm-of-death attack. This is a huge attack vector
> > > to cloud providers, as the death of one single host machine is not the end
> > > of the story. Without manual interferences, a failed cloud job may be
> > > dispatched to other hosts and continue host crashes until all of them are
> > > dead.
> > 
> > My only concern with using KVM_BUG() is whether the machine can keep
> > running correctly after this warning has been hit. In other words, are
> > we sure the damage is contained to just this VM?

Hmm, good point.  The counter-argument is that KVM doesn't BUG() in get_mmio_spte()
when a non-MMIO SPTE has reserved bits set, and as we've seen internally in multiple
splats where the reserved bits appear to be set by stack overflow, that has a much,
much higher probability of being a symptom of data corruption.

That said, that's more of a reason to change get_mmio_spte() than it is to ignore
potential data corruption in this case.  KVM arguably should kill the VM if
get_mmio_spte() fails too.

What about explicitly treating both get_mmio_spte() and this as potential data
corruption?  E.g. something like this, and then use the DATA_CORRUPTION variant
in pte_list_remove()?

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2055e04b8f89..1cb69c6d186b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4075,6 +4075,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
                        pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
                               sptes[level], level,
                               get_rsvd_bits(rsvd_check, sptes[level], level));
+               KVM_BUG_ON_DATA_CORRUPTION(reserved, vcpu->kvm);
        }
 
        return reserved;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f16c4689322b..5c4a06f66f46 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -863,6 +863,17 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
        unlikely(__ret);                                        \
 })
 
+#define KVM_BUG_ON_DATA_CORRUPTION(cond, kvm)                  \
+({                                                             \
+       int __ret = (cond);                                     \
+                                                               \
+       if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION))          \
+               BUG_ON(__ret);                                  \
+       else if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))      \
+               kvm_vm_bugged(kvm);                             \
+       unlikely(__ret);                                        \
+})
+
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_PROVE_RCU


> > If, for example, the KVM_BUG() was triggered by a use-after-free, then
> > there might be corrupted memory floating around in the machine.
> > 
> 
> David,
> 
> Your concern is quite reasonable. But given that both rmap and spte are
> pointers/data structures managed by individual VMs, i.e., none of them
> are global pointers, use-after-free is unlikely happening on cross-VM
> cases.

Being per-VM allocations doesn't change the behavior/impact of use-after-free.
E.g. if there is no rmap found for a SPTE then there's a non-zero chance KVM has
previously zapped the SPTE and freed the memory the SPTE pointed at, and thus KVM
might be reading/writing memory that is now owned by something else in the kernel.

> Even if there is, then shuting down those corrupted VMs is feasible
> here, since pte_list_remove() basically does the checking.

But the damage may already be done.  And the KVM_REQ_VM_DEAD request wont't be
recognized until the next vcpu_enter_enter_guest(), e.g. it won't prevent vCPUs
(or even this vCPU) from processing more 
