Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BDD5A50C4
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 17:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiH2Pyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 11:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiH2Pye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 11:54:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE597D40
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:54:31 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bh13so8063614pgb.4
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aNO39xJ8xdio2OuaoErgkoRxIrRFci537wH93e0AFV8=;
        b=J3AMYeGxXd2rNi66wQQ5K95gvJkHS42lSR3oHxN3eDj504T4ol8ucqRqq719ouWf6N
         VyNtjdm4+ZVxlfYlhFoZ4jDq2YK7BoYFoWbcL2oZXB+/GeOQwjjUGfEMzgL2pSfm+o3s
         COQQz9S5Pf4b9s8ALW4FAbGPXET3TTKMP8Ocm/Ov9nn2efSwUeEXGuvZ2UTxYDLSmZ5W
         loezkHTG26czgfbJwcxHpCdt9sLN8UM3iiAdclKj4Qbh86HvFZbkQQmJAGYpSuGmWHgD
         GpmAQt/xPPfUtSlxvgs+sBOBV70wsdbOPSmEiamh5p5OFU0MmnK6NG3ZkUXSTeSUtTE9
         UQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aNO39xJ8xdio2OuaoErgkoRxIrRFci537wH93e0AFV8=;
        b=7OXlefqJKLT25fEJCHXAyJrQRNRx2tkrOflrkDw+RLiqo+uBV3XOf3mh1WMnXCs+0n
         niHgSdMutnNJYysBtgGlv6/sryi6dgpimfhCPQPzOyGja3muEcWnQUNKIZxGQ7S/Hd14
         NLomDHNGEYgMDrx6yjzUO89u9rpDgCpEzuTLWqF85WyAfcQ+EX39RiyCfSBAlbBNttj+
         LnoCNKXKe9dffQ8z9e9GiuL3mgLft3yGV58DvlCQ0rGK9sfljOSn+VolhP1G/2CxY1Q4
         3LH+I+3FCgwOawvUTiyIdzUPGbhC41L1nZLHckOPdC/1w42CW0V7FgWQpNDWYsO1Rgnd
         8ehw==
X-Gm-Message-State: ACgBeo3VDcUw2fYTu7gZcaUARGWunqOkYM3+tLirdo4GrF8Mmm2S25BZ
        KY0/O8FrFzGPqbKeyyf8ZEtTTw==
X-Google-Smtp-Source: AA6agR4VJT3oZXs0Szge8tkquk9sXmgeZ1cspVhxlcjDsCauyzWSIu4FIhbLzuneMrllWlwq+u7PlA==
X-Received: by 2002:a62:168a:0:b0:532:478f:535e with SMTP id 132-20020a62168a000000b00532478f535emr17253523pfw.75.1661788470464;
        Mon, 29 Aug 2022 08:54:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709029a0b00b00172bd7505e6sm7666024plp.12.2022.08.29.08.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 08:54:29 -0700 (PDT)
Date:   Mon, 29 Aug 2022 15:54:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
Message-ID: <YwzhMTnMJpoCNRpT@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <87fshkw5zo.fsf@redhat.com>
 <Ywe/j3fqfj9qJgEV@google.com>
 <87v8qevs6k.fsf@redhat.com>
 <87h71xvl5j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h71xvl5j.fsf@redhat.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 27, 2022, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> ...
> 
> >
> > Honestly I'm starting to think the 'evmcs revisions' idea (to keep
> > the exact list of features in KVM and update them every couple years
> > when new Hyper-V releases) is easier. It's just a list, it doesn't
> > require much. The main downside, as was already named, is that userspace
> > VMM doesn't see which VMX features are actually passed to the guest
> > unless it is also taught about these "evmcs revisions" (more than what's
> > the latest number available). This, to certain extent, can probably be
> > solved by VMM itself by doing KVM_GET_MSRS after vCPU is created (this
> > won't help much with feature discovery by upper layers, tough). This,
> > however, is a new use-case, unsupported with the current
> > KVM_CAP_HYPERV_ENLIGHTENED_VMCS implementation.
> 
> ...
> 
> Thinking more about the above, if we invert the filtering logic (to
> explicitly list what's supported), KVM's code which we will have to add
> for every new revision can be very compact as it will only have to list
> the newly added features.

But that point KVM would effectively be implementing a less flexible version of
VMX MSRs.

> I can't imagine fields *disappearing* from eVMCS definition but oh well..

It's unlikely that features will truly disappear, but it is relatively likely that
userspace will want to hide a feature.  It's also likely that hardware won't
support all "previous" features, e.g. Intel has a habit of making features like
TSC scaling and APICv available only on Xeon SKUs.

Handling arbitrary configurations via version numbers gets kludgy because it's
impossible for userspace to communicate its exact desires to KVM.  All userspace
can do is state that it's aware of features up through version X; hiding individual
features requires maniuplating the VMX MSRs.

And if userspace needs to set VMX MSRs, then userspace also needs to get VMX MSRs,
and so why not simply have userspace do exactly that?  The only missing piece is a
way for userspace to opt-in to activating the "feature is available if supported in
hardware _and_ eVMCS" logic so as not to break backwards compatibility.  A per-VM
capability works very well for that.

> Anyway, I think this series is already getting too big and has many
> important fixes but some parts are still controversial. What if I split
> off everything-but-Hyper-V-on-KVM (where no controversy is currenly
> observed) and send it out so we can continue discussing the issue at
> hand more conveniently?

Yes, let's do that.
