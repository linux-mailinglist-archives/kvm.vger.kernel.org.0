Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4179C5AB56C
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiIBPjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237356AbiIBPiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:38:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6153511238D
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:26:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso5804742pjh.5
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CNM2Kc0rkiJR2fnCBtaCrcHt9jogd9i5ZxoTIR9J7J8=;
        b=CsvqrF3hD0RlOT0IG002u/UveYL+OUUQgpkSum+7TxOJO8rvj+B6/yIbqktniiv3bB
         u/RbKh8tLs5/6JvFN61HcuU4JFizOWu0Jn207fP2c68qy9Ub58IWWro9n6cJK2JNx0qe
         DcUV6Z/3wJeOCYrocrLJ7BGS9nozezLg+dD1UWq6jgfdms5HAf61yOuScwMFDc/SXzPD
         5iwzhXRaqHszqkVWAdOL+vvTulL2CciGB4KMy9fxduuqa29kriLHMGxBow94qQP7/Hvx
         18+fHJMgMDPgXV9Fm9XsMpxIMpDw43Tm5900oPCZ1zraiodHmnjYmOKuNhz8s0ZLm/HJ
         3MPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CNM2Kc0rkiJR2fnCBtaCrcHt9jogd9i5ZxoTIR9J7J8=;
        b=CYv20HGytjuybMONmlDV8/V+DMXgycRlW1s1N1dVIXvXe4ktwVpt2/rWDdZc3TZNOU
         3UiaS7mRj6frf6yTMnmbOl1NTCP86B+jYFbGdd77/Gdgb/AyrVVl6saHk6DOqH4E5FQ6
         dY26SIjfwFo45Rmemwm3rSi1Lf1rMu5NZfNTqtz9a4LeS1Ol8fHLHzIQr7WKEaUcF+NE
         ZRBDnPISMBRv9ET9AdFHE2Tu0jy4s2clomMlzQk1TbCC52YuHg8hEeH/V9p77T6Co3sK
         TNRgdFHTcM7+UShEQpwF/C03P1OwIBIWkobb/umSP9t9UXf5VmS/VTAi/6kMFwW2Z4G+
         LD6A==
X-Gm-Message-State: ACgBeo3SdoaYPFLZqS8uGaDd8a8Om0kSXVzyFgkLa2Hxoue6sgADancU
        Nd3yW2jmnMPe5DhPjUa3ZrIk7A==
X-Google-Smtp-Source: AA6agR5t6TSNwXdO1UMxLYzzek/WFA5OdDcNrqd1N+XN06I0E5C6gNHcLm+vM+Tt3WAQXWXw/dVRMg==
X-Received: by 2002:a17:903:11d0:b0:171:2cbc:3d06 with SMTP id q16-20020a17090311d000b001712cbc3d06mr34739685plh.142.1662132399113;
        Fri, 02 Sep 2022 08:26:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d13-20020a17090ac24d00b001fad1f975casm1645893pjx.12.2022.09.02.08.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 08:26:38 -0700 (PDT)
Date:   Fri, 2 Sep 2022 15:26:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v1 15/40] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <YxIgq9flJehbEngQ@google.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
 <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
 <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
 <YxFv6RglTOY3Pevj@google.com>
 <20220902054621.yyffxn2vnm74r2b3@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902054621.yyffxn2vnm74r2b3@sirius.home.kraxel.org>
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

On Fri, Sep 02, 2022, Gerd Hoffmann wrote:
> On Fri, Sep 02, 2022 at 02:52:25AM +0000, Sean Christopherson wrote:
> > On Fri, Sep 02, 2022, Xiaoyao Li wrote:
> > > On 8/26/2022 1:57 PM, Gerd Hoffmann wrote:
> > > >    Hi,
> > > > > For TD guest kernel, it has its own reason to turn SEPT_VE on or off. E.g.,
> > > > > linux TD guest requires SEPT_VE to be disabled to avoid #VE on syscall gap
> > > > > [1].
> > > > 
> > > > Why is that a problem for a TD guest kernel?  Installing exception
> > > > handlers is done quite early in the boot process, certainly before any
> > > > userspace code runs.  So I think we should never see a syscall without
> > > > a #VE handler being installed.  /me is confused.
> > > > 
> > > > Or do you want tell me linux has no #VE handler?
> > > 
> > > The problem is not "no #VE handler" and Linux does have #VE handler. The
> > > problem is Linux doesn't want any (or certain) exception occurrence in
> > > syscall gap, it's not specific to #VE. Frankly, I don't understand the
> > > reason clearly, it's something related to IST used in x86 Linux kernel.
> > 
> > The SYSCALL gap issue is that because SYSCALL doesn't load RSP, the first instruction
> > at the SYSCALL entry point runs with a userspaced-controlled RSP.  With TDX, a
> > malicious hypervisor can induce a #VE on the SYSCALL page and thus get the kernel
> > to run the #VE handler with a userspace stack.
> > 
> > The "fix" is to use an IST for #VE so that a kernel-controlled RSP is loaded on #VE,
> > but ISTs are terrible because they don't play nice with re-entrancy (among other
> > reasons).  The RSP used for IST-based handlers is hardcoded, and so if a #VE
> > handler triggers another #VE at any point before IRET, the second #VE will clobber
> > the stack and hose the kernel.
> > v
> > It's possible to workaround this, e.g. change the IST entry at the very beginning
> > of the handler, but it's a maintenance burden.  Since the only reason to use an IST
> > is to guard against a malicious hypervisor, Linux decided it would be just as easy
> > and more beneficial to avoid unexpected #VEs due to unaccepted private pages entirely.
> 
> Hmm, ok, but shouldn't the SEPT_VE bit *really* controlled by the guest then?
> 
> Having a hypervisor-controlled config bit to protect against a malicious
> hypervisor looks pointless to me ...

IIRC, all (most?) of the attributes are included in the attestation report, so a
guest/customer can refuse to provision secrets to the guest if the hypervisor is
misbehaving.

I'm guessing Intel made it an attribute and not a dynamic control knob to simplify
the TDX module implementation.
