Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B1255CC97
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbiF0PwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238620AbiF0Pv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:51:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8F19C15
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:51:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m2so8552464plx.3
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6LxmU+WQXLNtw6pgWpGmr460o0vfQZB4+u6bJ7WRLy4=;
        b=EwZlSkhOodz7ts1b+UrLbL7DVdG12pJYBSYGIg4fFW+/BFe12jf3UJ3H7IqQrDkBlP
         ZIOuK1AUqUso6wbaEB82ecZGEqy/UPrnOrVJSXlrYZhy48wChjam2QrHugv2jp5WKQ5F
         aC1+kB9uaAUZlUsPcqxpFxCVoqxUNXPAUwBj+r5oQZoHsXvF3pG/u5HTL2z0Yfx7IQKz
         g6UVUanS24JpxpZj/8rUSqBoC1OHk9YuOTra1fZotCgI6oIWvJ6L84Twp33YjqnZyvv2
         fgViXczymN9nlKkO53gGkmSL9LsgVHVuu+5zmpNpEuvdMT6JQegryhpO9CYVgFfhNnVp
         K3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6LxmU+WQXLNtw6pgWpGmr460o0vfQZB4+u6bJ7WRLy4=;
        b=wmzf9Zb9vr44tPXWPCCGz52fU3CTmdFJOaKN09Qk2P9X59kAXdI5bNdimArScuLNZN
         EEkdbfR2a/5saONg/2rhEgDrqOJI0tPpIscVL53agpibjovBRRjUhH0lEkYAg6TD7Pzk
         nGayw7unTmteGHqSR0yDmcRo9S3EDZVlLDFLzlzGqRXgcy2nyyxyvvfVBebvLbECFCTR
         C+yMuR6HjmCJIqB+eRY9++wo67a1aKf3EqqgahWmaep2KZVlILoXHFmg1yAuCxDdOsJE
         oSxvullis+JiyMg5ndk3ynyFgoZs7Ko28Qel4ugLWUTWb13NnOkMuuE4Ca5O5quUcAfA
         tYQA==
X-Gm-Message-State: AJIora+3Wxg7PZTYkfFpnQZN6P2JpUQChs7Xj2oxRJqubfWPcLtT4Brw
        126dEEh3z/ubm+wtznxt2e1P8bno1tDt9Q==
X-Google-Smtp-Source: AGRyM1tB1UPKeH3bo/MQZJWlxo8K/y4GHIXTynLBgDx6mxTSBunPFcmHvShjiguzG92o5sJ7nFVPDQ==
X-Received: by 2002:a17:902:ea04:b0:16a:1f33:cb0d with SMTP id s4-20020a170902ea0400b0016a1f33cb0dmr111885plg.103.1656345112028;
        Mon, 27 Jun 2022 08:51:52 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902650800b00168a651316csm7391374plk.270.2022.06.27.08.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:51:51 -0700 (PDT)
Date:   Mon, 27 Jun 2022 15:51:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
Message-ID: <YrnSFGURsmxV2Qmu@google.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
 <YrMqtHzNSean+qkh@google.com>
 <834f41a88e9f49b6b72d9d3672d702e5@EX13D32EUC003.ant.amazon.com>
 <0abf9f5de09e45ef9eb06b56bf16e3e6@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0abf9f5de09e45ef9eb06b56bf16e3e6@EX13D32EUC003.ant.amazon.com>
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

On Mon, Jun 27, 2022, Durrant, Paul wrote:
> > -----Original Message-----
> [snip]
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 00e23dc518e0..8b45f9975e45 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> > > >       if (vcpu->xen.vcpu_time_info_cache.active)
> > > >               kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
> > > >       kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> > > > +     kvm_xen_setup_tsc_info(v);
> > >
> > > This can be called inside this if statement, no?
> > >
> > >         if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
> > >
> > >         }
> > >
> 
> I think it ought to be done whenever the shared copy of Xen's vcpu_info is
> updated (it will always match on real Xen) so unconditionally calling it here
> seems reasonable.

But isn't the call pointless if the vCPU's hw_tsc_khz is unchanged?  E.g if the
params were explicitly passed in, then it would look like:

	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
				   &vcpu->hv_clock.tsc_shift,
				   &vcpu->hv_clock.tsc_to_system_mul);
		vcpu->hw_tsc_khz = tgt_tsc_khz;

		kvm_xen_setup_tsc_info(vcpu, tgt_tsc_khz,
				       vcpu->hv_clock.tsc_shift,
				       vcpu->hv_clock.tsc_to_system_mul);
	}

Explicitly passing in the arguments probably isn't necessary, just use a more
precise name, e.g. kvm_xen_update_tsc_khz(), to make it clear that the update is
limited to TSC frequency changes.

> > > > +{
> > > > +     u32 base = 0;
> > > > +     u32 function;
> > > > +
> > > > +     for_each_possible_hypervisor_cpuid_base(function) {
> > > > +             struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
> > > > +
> > > > +             if (entry &&
> > > > +                 entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
> > > > +                 entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
> > > > +                 entry->edx == XEN_CPUID_SIGNATURE_EDX) {
> > > > +                     base = function;
> > > > +                     break;
> > > > +             }
> > > > +     }
> > > > +     if (!base)
> > > > +             return;
> > > > +
> > > > +     function = base | XEN_CPUID_LEAF(3);
> > > > +     vcpu->arch.xen.tsc_info_1 = kvm_find_cpuid_entry(vcpu, function, 1);
> > > > +     vcpu->arch.xen.tsc_info_2 = kvm_find_cpuid_entry(vcpu, function, 2);
> > >
> > > Is it really necessary to cache the leave?  Guest CPUID isn't optimized, but it's
> > > not _that_ slow, and unless I'm missing something updating the TSC frequency and
> > > scaling info should be uncommon, i.e. not performance critical.
> 
> If we're updating the values in the leaves on every entry into the guest (as
> with calls to kvm_setup_guest_pvclock()) then I think the cached pointers are
> worthwhile.

But why would you update on every entry to the guest?   Isn't this a rare operation
if the update is limited to changes in the host CPU's TSC frequency?  Or am I
missing something?
