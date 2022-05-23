Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF14531A88
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbiEWRjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242906AbiEWRhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:37:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1E62CE9
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:31:55 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c22so14280521pgu.2
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oCNJML7eA2j9L8f72NkyeKZiPIyN20wsxD5r9Tzx9cA=;
        b=VQuspDaagiDbr8zDGAJevmwHk6IYCwXe0OQNbOee7Tu2IHo33cYxokGiFfbrhTIFD6
         62hu7cw8t4yvx3aEBc40atCX/ZCXQYPABJD3A7WMv5dpWaPn1sujmMA8KBgCJG/jH4eb
         Smd147syr5WmIcn7pwELo2ONgSQiNPsmRFuoyQ1Iuk1z/gxUK17CLFKinM4+1W81nEFo
         hEWLTqC7ODI5yO9MfnJOT+geXR0KYCSJNoxov70DOAkLXuLYrQlTnAq0q3/2sT9qy69d
         B46Q3eeaiIlELv+ptqM+emBDuE/X1ivWqBecmrCvvRl7jwiPmbCsJ3mCYHkXRYTX9XnL
         9ZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oCNJML7eA2j9L8f72NkyeKZiPIyN20wsxD5r9Tzx9cA=;
        b=iljeF7lkpyAT6PZ4QMCGuI/dIfhEJEzqN4fX64xB526uhbC7pIGAerhADJ/UwU0t5K
         hK/9pcA2A9xYmq7Jtw5hvhDLaq2w/ubBu3xccVzLizwpuqqXwP1quEBxz7ZkjynGSqUR
         YehyKA3KSpxIZMSIcCjRFlkLL+qVshM4SXGdkC3lvWMmneoy1epqjFNnuJm4oGm5l+Is
         l4BGI77twpNmTcnH4ci761fca5iNshLjcFMKJeO2TYBIch3Kvb60BYL7cqsYsQO9BBqn
         O+TaS8r2Q0lEXm9Ckak8l6fJsHNBqROG6R+HpeLw3IHaKEY+iL/D4z7EEqufgu+4OxW6
         HaYQ==
X-Gm-Message-State: AOAM531NPV2f72Too5xQewn6lrujykeTZHQdyy7X5uj7wVDZ8FsFHsd5
        tzdk0quLh2gVV4V4Vq8+mEP2Yhk57tKvWQ==
X-Google-Smtp-Source: ABdhPJyVqMoEcjNxptyUgqa9Zdq5WQzejBZ0z6wMNkkE4awFtw8fhM9i8OBMVMolSAtdF+aG4aq6XQ==
X-Received: by 2002:a05:6a00:140a:b0:4e0:54d5:d01 with SMTP id l10-20020a056a00140a00b004e054d50d01mr24742544pfu.20.1653327068687;
        Mon, 23 May 2022 10:31:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ru13-20020a17090b2bcd00b001df4a0e9357sm7512221pjb.12.2022.05.23.10.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:31:08 -0700 (PDT)
Date:   Mon, 23 May 2022 17:31:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the guest
 and/or host changes apic id/base from the defaults.
Message-ID: <YovE2A67XobRyHc/@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-3-mlevitsk@redhat.com>
 <YoZrG3n5fgMp4LQl@google.com>
 <e32f6c904c92e9e9efabcc697917a232f5e88881.camel@redhat.com>
 <CALMp9eSVji2CPW1AjFoSbWZ_b-r3y67HyatgdqXEqSyUaD1_BQ@mail.gmail.com>
 <65991ac329a32cf4128400b643d5b5ccf3918cfe.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65991ac329a32cf4128400b643d5b5ccf3918cfe.camel@redhat.com>
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

On Mon, May 23, 2022, Maxim Levitsky wrote:
> On Sun, 2022-05-22 at 07:47 -0700, Jim Mattson wrote:
> > On Sun, May 22, 2022 at 2:03 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Thu, 2022-05-19 at 16:06 +0000, Sean Christopherson wrote:
> > > > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > > > Neither of these settings should be changed by the guest and it is
> > > > > a burden to support it in the acceleration code, so just inhibit
> > > > > it instead.
> > > > > 
> > > > > Also add a boolean 'apic_id_changed' to indicate if apic id ever changed.
> > > > > 
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > > +           return;
> > > > > +
> > > > > +   pr_warn_once("APIC ID change is unsupported by KVM");
> > > > 
> > > > It's supported (modulo x2APIC shenanigans), otherwise KVM wouldn't need to disable
> > > > APICv.
> > > 
> > > Here, as I said, it would be nice to see that warning if someone complains.
> > > Fact is that AVIC code was totally broken in this regard, and there are probably more,
> > > so it would be nice to see if anybody complains.
> > > 
> > > If you insist, I'll remove this warning.
> > 
> > This may be fine for a hobbyist, but it's a terrible API in an
> > enterprise environment. To be honest, I have no way of propagating
> > this warning from /var/log/messages on a particular host to a
> > potentially impacted customer. Worse, if they're not the first
> > impacted customer since the last host reboot, there's no warning to
> > propagate. I suppose I could just tell every later customer, "Your VM
> > was scheduled to run on a host that previously reported, 'APIC ID
> > change is unsupported by KVM.' If you notice any unusual behavior,
> > that might be the reason for it," but that isn't going to inspire
> > confidence. I could schedule a drain and reboot of the host, but that
> > defeats the whole point of the "_once" suffix.
> 
> Mostly agree, and I read alrady few discussions about exactly this,
> those warnings are mostly useless, but they are used in the
> cases where we don't have the courage to just exit with KVM_EXIT_INTERNAL_ERROR.
> 
> I do not thing though that the warning is completely useless, 
> as we often have the kernel log of the target machine when things go wrong, 
> so *we* can notice it.
> In other words a kernel warning is mostly useless but better that nothing.

IMO, it's worse than doing nothing.  Us developers become desensitized to the
kernel message due to running tests, the existence of these message propagates
the notion that they are a good thing (and we keep rehashing these discussions...),
users may not realize it's a _once() printk and so think they _aren't_ affected
when re-running a workload, etc...

And in this case, "APIC ID change is unsupported by KVM" is partly wrong.  KVM
fully models Intel's behavior where the ID change isn't carried across x2APIC
enabling, the only unsupported behavior is that the guest will lose APICv
acceleration.

> About KVM_EXIT_WARNING, this is IMHO a very good idea, probably combined
> with some form of taint flag, which could be read by qemu and then shown
> over hmp/qmp interfaces.
