Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B156049C8
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiJSOwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJSOv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 10:51:58 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851213FDDC
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:42:29 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 128so16453890pga.1
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5OVUDZU1XsNkGq6YBOokd70bXwqta2LzCMha4S1CMlc=;
        b=a0xG4jYFrerAn25dxCU/C/OGI0Puv9XMGadP0q4bCBlcqTPJBi9aQoruM7nomfeEmR
         +NRJBOJfJSQAPnaPxjRZti4bj8xMxQiIenx/423qfo/QsreRA4iz2rUkQ2oEgjWEBAMK
         l5yvHgpX3yTT7LdUjprJNoALAWGj4t7DEZ1ev+oh6ivTjfR1gMhjsv4M9cI6+EzOlZJJ
         SlwtxNNQ1lID1kq9iN6P+ECZ3y2UMwPqwSzCLKm7hMM6ZAhpbdoCBLJGgkNY74d5RCKS
         agnJ5gpSksK3MMREl5gmFchj+PyDnDYgBbY5G54CVcR5mo0jBTO/xABKMsrH/+8dGMAu
         ZJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OVUDZU1XsNkGq6YBOokd70bXwqta2LzCMha4S1CMlc=;
        b=7NyTmY8UV08sdg/MkmIG1ayJ6Nm20jQxs3rjpcpe3cGJuj40SJC8ZvMxM8Vt2q7EDk
         /V+Dwd5hNt3gouPIwSEI+ESiwqrMYioC0BLhkLBTmu3p0q0Io1ghjpGIub57MIbRsezV
         Y6T82K7huc/WZI3wIdIhkxRNWXfcjO6buSdVlF3gIzOuNLCkESHDWGhq8OW0YWMeu1Sl
         /ucv4+zHNSgZ9lpdFYBbWc7RsQhuJiuaPdGgU5U9en/5Z48vRqhQxA6k7x7+AHUMYyHb
         mTW9cbL+EccU1kGbCohbmqZpmq6XjPZcLAGPue3GX03ogRFSNHRGNdYYJHu76NSnlAU/
         1oRg==
X-Gm-Message-State: ACrzQf0r02lpREcuNl+38QCKMvoCMWas9Q8EwwuoocaGTew1Ompb6/xX
        uPZ/4/YlcCrvfQfgwyYJHtyXog==
X-Google-Smtp-Source: AMsMyM6YaV2gi5aTzWiyK7eAPwuHYlRpXlMiL4DOi/f/qjoKQI5OZH+CzzccMwMSkPyPXR6nfI6B6w==
X-Received: by 2002:aa7:8741:0:b0:562:bacb:136a with SMTP id g1-20020aa78741000000b00562bacb136amr8957282pfo.46.1666190547619;
        Wed, 19 Oct 2022 07:42:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d204-20020a621dd5000000b0056238741ba0sm11337278pfd.79.2022.10.19.07.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 07:42:27 -0700 (PDT)
Date:   Wed, 19 Oct 2022 14:42:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2 2/2] KVM: x86: Expose Predictive Store Forwarding
 Disable on Intel parts
Message-ID: <Y1AMz6sUceNmjm3r@google.com>
References: <20220830225210.2381310-1-jmattson@google.com>
 <20220830225210.2381310-2-jmattson@google.com>
 <Yw6fkyJrsu/i+Byy@google.com>
 <CALMp9eRfq9jtC20an2brOL=+LpFFReqz0-BvOE_6p-461C8vaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRfq9jtC20an2brOL=+LpFFReqz0-BvOE_6p-461C8vaw@mail.gmail.com>
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

On Tue, Aug 30, 2022, Jim Mattson wrote:
> On Tue, Aug 30, 2022 at 4:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Aug 30, 2022, Jim Mattson wrote:
> > > Intel enumerates support for PSFD in CPUID.(EAX=7,ECX=2):EDX.PSFD[bit
> > > 0]. Report support for this feature in KVM if it is available on the
> > > host.
> > >
> > > Presumably, this feature bit, like its AMD counterpart, is not welcome
> > > in cpufeatures.h, so add a local definition of this feature in KVM.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 23 +++++++++++++++++------
> > >  1 file changed, 17 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 07be45c5bb93..b5af9e451bef 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -62,6 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> > >   * This one is tied to SSB in the user API, and not
> > >   * visible in /proc/cpuinfo.
> > >   */
> > > +#define KVM_X86_FEATURE_PSFD         0          /* Predictive Store Forwarding Disable */
> >
> > I believe we can use "enum kvm_only_cpuid_leafs" to handle this.  E.g.
> >
> >         enum kvm_only_cpuid_leafs {
> >                 CPUID_12_EAX     = NCAPINTS,
> >                 CPUID_7_2_EDX,
> >                 NR_KVM_CPU_CAPS,
> >
> >                 NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> >         };
> >
> > then the intended use of KVM_X86_FEATURE_*
> >
> >         #define KVM_X86_FEATURE_PSFD    KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
> >
> > I _think_ we can then define an arbitrary word for X86_FEATURE_PSFD, e.g.
> >
> >         #define X86_FEATURE_PSFD        (NKVMCAPINTS*32+0)
> 
> We may run afoul of reverse_cpuid_check(), depending on usage.

Oh, yeah, an entry in reverse_cpuid[] would also be needed.  For posterity since
PSFD doesn't need a KVM-only entry[*]...

[*] https://lore.kernel.org/all/Y0CrER%2FyiHheWiZw@google.com
