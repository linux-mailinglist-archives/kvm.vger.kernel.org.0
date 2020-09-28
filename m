Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6EF27B116
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 17:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1PlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 11:41:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgI1PlV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 11:41:21 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601307678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pn8lOEOUIOpTEOepzxqWcrUmnDNkzY2Axg51GzweM4Y=;
        b=e6ULXYeXD4gsa9ymq91P8XeUOrl3L3B6alqaegS1qQL9Xq+mOVS3HlIETgCvz6Hem+AP0o
        AuvuwzUH4SjhrighzBCYF+ArsXaA6yJkC+Nb9Th/O3K/Y4GP/3w62dbYbTfqMzY7vs/gn1
        3h29HuUgwqg0m9/TjRcFcPo31UXUlqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-qNpy43wYM8u8sBpSYcUyig-1; Mon, 28 Sep 2020 11:41:13 -0400
X-MC-Unique: qNpy43wYM8u8sBpSYcUyig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F146185A0D2;
        Mon, 28 Sep 2020 15:41:12 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9648C5C1BB;
        Mon, 28 Sep 2020 15:41:08 +0000 (UTC)
Date:   Mon, 28 Sep 2020 11:41:07 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Subject: Re: [PATCH] target/i386: add -cpu,lbr=true support to enable guest
 LBR
Message-ID: <20200928154107.GX3717385@habkost.net>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
 <20200726153229.27149-3-like.xu@linux.intel.com>
 <20200924220523.GL3717385@habkost.net>
 <958128c6-39e8-96fe-34d8-7be1888f4144@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <958128c6-39e8-96fe-34d8-7be1888f4144@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 10:51:03PM +0800, Xu, Like wrote:
> Hi Eduardo,
> 
> Thanks for your detailed review.
> 
> On 2020/9/25 6:05, Eduardo Habkost wrote:
> > I've just noticed this on my review queue (apologies for the long
> > delay).  Comments below:
> > 
> > On Sun, Jul 26, 2020 at 11:32:20PM +0800, Like Xu wrote:
> > > The LBR feature would be enabled on the guest if:
> > > - the KVM is enabled and the PMU is enabled and,
> > > - the msr-based-feature IA32_PERF_CAPABILITIES is supporterd and,
> > > - the supported returned value for lbr_fmt from this msr is not zero.
> > > 
> > > The LBR feature would be disabled on the guest if:
> > > - the msr-based-feature IA32_PERF_CAPABILITIES is unsupporterd OR,
> > > - qemu set the IA32_PERF_CAPABILITIES msr feature without lbr_fmt values OR,
> > > - the requested guest vcpu model doesn't support PDCM.
> > > 
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Richard Henderson <rth@twiddle.net>
> > > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > Cc: qemu-devel@nongnu.org
> > > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > > ---
> > >   hw/i386/pc.c      |  1 +
> > >   target/i386/cpu.c | 24 ++++++++++++++++++++++--
> > >   target/i386/cpu.h |  2 ++
> > >   target/i386/kvm.c |  7 ++++++-
> > >   4 files changed, 31 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> > > index 3d419d5991..857aff75bb 100644
> > > --- a/hw/i386/pc.c
> > > +++ b/hw/i386/pc.c
> > > @@ -318,6 +318,7 @@ GlobalProperty pc_compat_1_5[] = {
> > >       { "Nehalem-" TYPE_X86_CPU, "min-level", "2" },
> > >       { "virtio-net-pci", "any_layout", "off" },
> > >       { TYPE_X86_CPU, "pmu", "on" },
> > > +    { TYPE_X86_CPU, "lbr", "on" },
> > Why is this line here?
> I'll remove it.
> > 
> > >       { "i440FX-pcihost", "short_root_bus", "0" },
> > >       { "q35-pcihost", "short_root_bus", "0" },
> > >   };
> > > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > > index 588f32e136..c803994887 100644
> > > --- a/target/i386/cpu.c
> > > +++ b/target/i386/cpu.c
> > > @@ -1142,8 +1142,8 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
> > >       [FEAT_PERF_CAPABILITIES] = {
> > >           .type = MSR_FEATURE_WORD,
> > >           .feat_names = {
> > > -            NULL, NULL, NULL, NULL,
> > > -            NULL, NULL, NULL, NULL,
> > > +            "lbr-fmt-bit-0", "lbr-fmt-bit-1", "lbr-fmt-bit-2", "lbr-fmt-bit-3",
> > > +            "lbr-fmt-bit-4", "lbr-fmt-bit-5", NULL, NULL,
> > What about a separate "lbr-fmt" int property instead of
> > individual bit properties?
> 
> I'm not sure if you mean adding a "separate lbr-fmt int property"
> like "uint64_t tcg_features" to 'struct FeatureWordInfo'.
> 
> Would you mind providing more implementation hints,
> considering the PEBS_FMT will be added later ?

You can add a regular uint8_t field to X86CPU, use
DEFINE_PROP_UINT8 at x86_cpu_properties[], and just validate/copy
the bits to cpu->features[FEAT_PERF_CAPABILITIES][bits 0:5] on
x86_cpu_realizefn().


> 
> > 
> > What happens if LBR_FMT on the host (returned by
> > kvm_arch_get_supported_msr_feature(MSR_IA32_PERF_CAPABILITIES) is
> > different than the one configured for the guest?
> To enable guest LBR, guest LBR_FMT must be the same as host LBR_FMT.
> > Can KVM emulate
> > a CPU with different LBR_FMT, or it must match the host?
> It must match the host since the LBR registers are model specified.

OK, this means the value set in cpu->features[] need to be
validated against the host in x86_cpu_filter_features().

It can be similar to what's done for intel-pt bits, but instead
of comparing to constants (the intel-pt bits in CPUID are
constant today), you can compare the host value with
cpu->features[FEAT_PERF_CAPABILITIES].

Maybe a FeatureWordInfo.validate_feature(X86CPU *, FeatureWord)
callback could be added, so we could just define separate
validation functions for each feature word, to be called
automatically by x86_cpu_filter_features().  This could be done
as a follow-up patch, though.


> > 
> > If LBR_FMT must always match the host, the feature needs to block
> > live migration.
> It's migrable enough of the perf cap LBR version matches,
> don't need full model number match.

As long as the requirements are validated inside
x86_cpu_filter_features(), it should be OK to make it migratable.

> 
> For example it's fine to migrate from SKY to CLX.
> > I guess this is already the case because PDCM is
> > cleared if !cpu->enable_pmu.  Adding PDCM to .unmigratable_flags
> > is probably a good idea, though.
> I'm trying to make LBR migration-friendly as much as possible w/ your help.
> 
> If Arch LBR is enabled for SPR guest, the situation will be different
> hence adding PDCM to .unmigratable_flags may not help it.

OK, in this case forget what I said about setting it on
.unmigratable_flags.  The constraints for making the feature
migratable should be same ones mentioned for intel-pt at:
https://lore.kernel.org/qemu-devel/20200923141502.GO2044576@habkost.net/


> > 
> > 
> > 
> > >               NULL, NULL, NULL, NULL,
> > >               NULL, "full-width-write", NULL, NULL,
> > >               NULL, NULL, NULL, NULL,
> > > @@ -4224,6 +4224,12 @@ static bool lmce_supported(void)
> > >       return !!(mce_cap & MCG_LMCE_P);
> > >   }
> > > +static inline bool lbr_supported(void)
> > > +{
> > > +    return kvm_enabled() && (kvm_arch_get_supported_msr_feature(kvm_state,
> > > +        MSR_IA32_PERF_CAPABILITIES) & PERF_CAP_LBR_FMT);
> > > +}
> > You can rewrite this is an accelerator-independent way as:
> >    (x86_cpu_get_supported_feature_word(FEAT_PERF_CAPABILITIES) & PERF_CAP_LBR_FMT)
> Thanks, I'll apply it.
> > 
> > However, is this really supposed to return false if LBR_FMT is 000000?
> I think it's fine to return false if LBR_FMT is 000000.

Don't we want to support hosts that have PDCM
(CPUID[1].ECX[bit 15]) = 1 and
IA32_PERF_CAPABILITIES.LBR_FMT[bits 5:0] = 000000 ?

> > 
> > > +
> > >   #define CPUID_MODEL_ID_SZ 48
> > >   /**
> > > @@ -4327,6 +4333,9 @@ static void max_x86_cpu_initfn(Object *obj)
> > >       }
> > >       object_property_set_bool(OBJECT(cpu), "pmu", true, &error_abort);
> > > +    if (lbr_supported()) {
> > > +        object_property_set_bool(OBJECT(cpu), "lbr", true, &error_abort);
> > Why is this necessary?
> > 
> > If kvm_arch_get_supported_msr_feature(MSR_IA32_PERF_CAPABILITIES)
> > return the PERF_CAP_LBR_FMT bits set,
> > x86_cpu_get_supported_feature_word() will return those bits, and
> > they will be automatically set at
> > env->features[FEAT_PERF_CAPABILITIES].
> Thanks, I'll remove it.
> > > +    }
> > >   }
> > >   static const TypeInfo max_x86_cpu_type_info = {
> > > @@ -5535,6 +5544,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> > >           }
> > >           if (!cpu->enable_pmu) {
> > >               *ecx &= ~CPUID_EXT_PDCM;
> > > +            if (cpu->enable_lbr) {
> > > +                warn_report("LBR is unsupported since guest PMU is disabled.");
> > > +                exit(1);
> > > +            }
> > >           }
> > >           break;
> > >       case 2:
> > > @@ -6553,6 +6566,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
> > >           }
> > >       }
> > > +    if (!cpu->max_features && cpu->enable_lbr &&
> > Why do we need to check for !cpu->max_features here?
> I'll remove it.
> > 
> > > +        !(env->features[FEAT_1_ECX] & CPUID_EXT_PDCM)) {
> > > +        warn_report("requested vcpu model doesn't support PDCM for LBR.");
> > > +        exit(1);
> > Please report errors using error_setg(errp, ...) instead.
> I'll apply it.
> > 
> > > +    }
> > > +
> > >       if (cpu->ucode_rev == 0) {
> > >           /* The default is the same as KVM's.  */
> > >           if (IS_AMD_CPU(env)) {
> > > @@ -7187,6 +7206,7 @@ static Property x86_cpu_properties[] = {
> > >   #endif
> > >       DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
> > >       DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
> > > +    DEFINE_PROP_BOOL("lbr", X86CPU, enable_lbr, false),
> > When exactly do we want to set lbr=off explicitly?  What's the
> > expected outcome when lbr=off?
> We set pmu=off explicitly, so does lbr=off.
> 
> When set lbr=off, the LBR-related registers accesses from guest bring #GP
> and expected outcome is just like pmu=off.

How are those registers enumerated?  Maybe I'm looking at an
outdated version of the Intel SDM or I couldn't find the right
section.

> > 
> > >       DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
> > >                          HYPERV_SPINLOCK_NEVER_RETRY),
> > > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > > index e1a5c174dc..a059913e26 100644
> > > --- a/target/i386/cpu.h
> > > +++ b/target/i386/cpu.h
> > > @@ -357,6 +357,7 @@ typedef enum X86Seg {
> > >   #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
> > >   #define MSR_IA32_PERF_CAPABILITIES      0x345
> > > +#define PERF_CAP_LBR_FMT      0x3f
> > >   #define MSR_IA32_TSX_CTRL		0x122
> > >   #define MSR_IA32_TSCDEADLINE            0x6e0
> > > @@ -1702,6 +1703,7 @@ struct X86CPU {
> > >        * capabilities) directly to the guest.
> > >        */
> > >       bool enable_pmu;
> > > +    bool enable_lbr;
> > This is a good place to document what enable_lbr=true|false
> > means (see questions above).
> > 
> I'll document it here.
> > >       /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
> > >        * disabled by default to avoid breaking migration between QEMU with
> > > diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> > > index b8455c89ed..feb33d5472 100644
> > > --- a/target/i386/kvm.c
> > > +++ b/target/i386/kvm.c
> > > @@ -2690,8 +2690,10 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
> > >       uint64_t kvm_perf_cap =
> > >           kvm_arch_get_supported_msr_feature(kvm_state,
> > >                                              MSR_IA32_PERF_CAPABILITIES);
> > > -
> > >       if (kvm_perf_cap) {
> > > +        if (!cpu->enable_lbr) {
> > > +            kvm_perf_cap &= ~PERF_CAP_LBR_FMT;
> > > +        }
> > Why is this necessary?  If enable_lbr is false,
> > f[FEAT_PERF_CAPABILITIES] should not have those bits set at all.
> I'll remove it.
> > 
> > >           kvm_msr_entry_add(cpu, MSR_IA32_PERF_CAPABILITIES,
> > >                           kvm_perf_cap & f[FEAT_PERF_CAPABILITIES]);
> > >       }
> > > @@ -2731,6 +2733,9 @@ static void kvm_init_msrs(X86CPU *cpu)
> > >       if (has_msr_perf_capabs && cpu->enable_pmu) {
> > >           kvm_msr_entry_add_perf(cpu, env->features);
> > > +    } else if (!has_msr_perf_capabs && cpu->enable_lbr) {
> > > +        warn_report("KVM doesn't support MSR_IA32_PERF_CAPABILITIES for LBR.");
> > > +        exit(1);
> > This is not the appropriate place to check for unsupported
> > features.  x86_cpu_realizefn() and/or x86_cpu_filter_features()
> > is.
> Thanks, I'll apply it in the x86_cpu_filter_features().
> 
> Please let me if you have more comments.
> 
> Thanks,
> Like Xu
> > >       }
> > >       if (has_msr_ucode_rev) {
> > > -- 
> > > 2.21.3
> > > 
> 

-- 
Eduardo

