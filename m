Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F172360BC32
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 23:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiJXVbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 17:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiJXVbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 17:31:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129942DCB08
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 12:37:53 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso8304853pjz.4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 12:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4R18gWw/NyoA4yOCOs9gzOiiPzbgm4s4hgI5dEXU5E=;
        b=BHhNWHxiLYRRxn2eEv1Y4eL+d54HNily+HajG8G28PIYrAruN9T50GK1FaIOAt3zSW
         n5y8w9mU/wbNZrI2roXWmte8p//RntSifApJgIl2rmMOCFdYZN6e7QB3KzNasrmniMeu
         J+ztLxuK0nnMq/U96KAf2mpDV/1cYo35ROWZ+KTqYMkNEo5v4F38kaVwP7Zvo2Me5Dio
         tN/01b7AU5kkW+ZwmsRwhg/o7s0+IMTjSaIdktV5CGvbJom8jLAq8L8kwnEBjL1er09C
         SdX34x/+rqaHgbuEBNsWrnvInQB7cyzQdxuI1OysCKqxJuYI6oo2EEhyGbulgWT58L1F
         l8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4R18gWw/NyoA4yOCOs9gzOiiPzbgm4s4hgI5dEXU5E=;
        b=2gHHOHwgDXHmTCDL2ibWJdwo2ctI9UlFuIusrXu6m1o7TTpQ9dMRm7u/Da0Ibe948p
         4cGHmbL3owagLRFDoQvAAVGAh24edNHH+gDKBnJP3yNTlKDG2CrHa8Vmr1SurFKD4T0S
         1+xfj6QarlQOB5gdhtBrIPG+Q6MrAwYUQuixsGrzg7292m6f5Tm7zVoIXVNdSB/2mEK5
         rxEeVXqo6g/+4LF6G+h6zQwAH4nElegiQzG7ohcip3pHzw4j+Qc+4+rm3/IX0XZdbrlj
         pfyWG88LG1FZrB5vtnES7ts4c8HgkPsjZefetUCHmjIYBa4b8bcuKQ03dtu1G9WLlPQB
         4aKQ==
X-Gm-Message-State: ACrzQf2XEpJIgMoqbJXZFm3TCWgPrc9GnhaMxoQiTmbSsNEWb5mfwvWz
        ELB9DwkfyLKgO1LCaR++vwfb0w==
X-Google-Smtp-Source: AMsMyM7In0jAw/pPqnOgZ6bFpbRpbK+BszDf6oq9ay48JxN4rT3G+A4b0LMshpTxQEgyg/C77Pyf8Q==
X-Received: by 2002:a17:902:ff0a:b0:185:293d:dbe3 with SMTP id f10-20020a170902ff0a00b00185293ddbe3mr35024715plj.28.1666640206449;
        Mon, 24 Oct 2022 12:36:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r10-20020a63d90a000000b00458a0649474sm106756pgg.11.2022.10.24.12.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 12:36:46 -0700 (PDT)
Date:   Mon, 24 Oct 2022 19:36:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org, shujunxue@google.com,
        terrytaehyun@google.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Hyperv extended hypercall support in KVM
Message-ID: <Y1bpSlNGeVkqRYxI@google.com>
References: <20221021185916.1494314-1-vipinsh@google.com>
 <Y1L9Z8RgIs8yrU6o@google.com>
 <CAHVum0eoA5j7EPmmuuUb2y7XOU1jRpFwJO90tc+QBy0JNUtBsQ@mail.gmail.com>
 <Y1MXgjtPT9U6Cukk@google.com>
 <87k04pbfqd.fsf@ovpn-193-3.brq.redhat.com>
 <Y1atxgq2SDkHbP9I@google.com>
 <CAHVum0f=gRgrP=rTySn1zwPz65g6jm_3f-=qusmS7jOkKyUMSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0f=gRgrP=rTySn1zwPz65g6jm_3f-=qusmS7jOkKyUMSw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Vipin Sharma wrote:
> On Mon, Oct 24, 2022 at 8:22 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Oct 24, 2022, Vitaly Kuznetsov wrote:
> > > While some 'extended' hypercalls may indeed need to be handled in KVM,
> > > there's no harm done in forwarding all unknown-to-KVM hypercalls to
> > > userspace. The only issue I envision is how would userspace discover
> > > which extended hypercalls are supported by KVM in case it (userspace) is
> > > responsible for handling HvExtCallQueryCapabilities call which returns
> > > the list of supported hypercalls. E.g. in case we decide to implement
> > > HvExtCallMemoryHeatHint in KVM, how are we going to communicate this to
> > > userspace?
> > >
> > > Normally, VMM discovers the availability of Hyper-V features through
> > > KVM_GET_SUPPORTED_HV_CPUID but extended hypercalls are not listed in
> > > CPUID. This can be always be solved by adding new KVM CAPs of
> > > course. Alternatively, we can add a single
> > > "KVM_CAP_HYPERV_EXT_CALL_QUERY" which will just return the list of
> > > extended hypercalls supported by KVM (which Vipin's patch adds anyway to
> > > *set* the list instead).
> >
> > AIUI, the TLFS uses a 64-bit mask to enumerate which extended hypercalls are
> > supported, so a single CAP should be a perfect fit.  And KVM can use the capability
> > to enumerate support for _and_ to allow userspace to enable in-kernel handling.  E.g.
> >
> > check():
> >         case KVM_CAP_HYPERV_EXT_CALL:
> >                 return KVM_SUPPORTED_HYPERV_EXT_CALL;
> >
> >
> > enable():
> >
> >         case KVM_CAP_HYPERV_EXT_CALL:
> >                 r = -EINVAL;
> >                 if (mask & ~KVM_SUPPORTED_HYPERV_EXT_CALL)
> >                         break;
> >
> >                 mutex_lock(&kvm->lock);
> >                 if (!kvm->created_vcpus) {
> 
> Any reason for setting capability only after vcpus are created?

This only allows setting the capability _before_ vCPUs are created.  Attempting
to set the cap after vCPUs are created gets rejected with -EINVAL.  This
requirement means vCPUs don't need to take a lock to consume per-VM state, as KVM
prevents the state from changing once vCPUs are created.

> Also, in my patch I wrote the ioctl at kvm_vcpu_ioctl_enable_cap() as
> all of the hyperv related code was there but since this capability is
> a vm setting not a per vcpu setting, should this be at  kvm_vm_ioctl()
> as a better choice?

Yep!

> >                         to_kvm_hv(kvm)->ext_call = cap->args[0];
> >                         r = 0;
> >                 }
> >                 mutex_unlock(&kvm->lock);
> >
> > kvm_hv_hypercall()
> >
> >
> >         case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> >                 if (unlikely(hc.fast)) {
> >                         ret = HV_STATUS_INVALID_PARAMETER;
> >                         break;
> >                 }
> >                 if (!(hc.code & to_kvm_hv(vcpu->kvm)->ext_call))
> 
> It won't be directly this. There will be a mapping of hc.code to the
> corresponding bit and then "&" with ext_call.
> 
> 
> >                         goto hypercall_userspace_exit;
> >
> >                 ret = kvm_hv_ext_hypercall(...)
> >                 break;
> >
> >
> > That maintains backwards compatibility with "exit on everything" as userspace
> > still needs to opt-in to having KVM handle specific hypercalls in-kernel, and it
> > provides the necessary knob for userspace to tell KVM which hypercalls should be
> > allowed, i.e. ensures KVM doesn't violate HV_EXT_CALL_QUERY_CAPABILITIES.
> 
> So, should I send a version with KVM capability similar to above

No, the above was just a sketch of how we can extend support if necessary.  In
general, we try to avoid creating _any_ APIs before they are strictly required.
For uAPIs, that's pretty much a hard rule.

> or for now just send the version which by default exit to userspace and later
> whenever the need arises KVM capability can be added then?

This one please :-)
