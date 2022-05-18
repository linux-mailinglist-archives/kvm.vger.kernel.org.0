Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D452C585
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbiERV0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 17:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbiERV0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 17:26:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DF753E34
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 14:26:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so6890773pjb.0
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 14:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d5zQAVg+pCP5xr+gb20wzk8ITDtEbXWhs8tpb8ZFvG0=;
        b=OI0OyBGCgCP3atlEDcc13QF/hTnokSsiAVUMyiypln4J2tCmts8DAOCELIfpxf8H/J
         y12WHIlDl7+bpl1pKvSM9S45YfEx2ccccVE9XynNZlxFcmdk6jrqcCjuGYyQFLjoeOIH
         0yvRDtwvR92lh9pZv3l3NE+6SeMaNsmXh72/PLqDvbZkLhy5/w5aGfb5pb+vT03LBCev
         6PSGFhOpcKwMWr+7z9dZmNE8pP1TGMrAJd58q3C7pxMe5XrUyK9x+zOb3PgzapfkdMoa
         X4qiA/ub6Onxjn6aunwbz8shS4Xtu8w9/omjN8rns7CmLa7RltY821LW3p+KE3Rka5nn
         dPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d5zQAVg+pCP5xr+gb20wzk8ITDtEbXWhs8tpb8ZFvG0=;
        b=X93oxEMRtoJeNGAyIaHgmOEYeEPO2Hny2I14Y302xE8QTWBaqlgkj+nUWlJhGQxr+O
         4FzG3f5VWU+IXpBTOMOTrYHAXe4FTIFUEeXb3eKFvhC3C0KoayrcKOLBBZBvb4wfM8VR
         QPLJMmGOoWkI0EuxoHPRfBFndbKc6k72Z+QKKezBsJqM94Sdo+mkp9xGwA3cLNhYCi/M
         qaCRlfVO8B5XNZ04koHAAgQEvAMKp4L3dWtZ/RJnqgc8pf4yg137UfPGWjnBarXQ0HmV
         hvTy1Ueto8SO7nOhMIeginp9L+0Hbv8rvuNC4AUWH6ocp+/JQ65D90BSTVxwsY7D6GaG
         frMQ==
X-Gm-Message-State: AOAM531OuAQVd2Gg66fvgt10lsMUmoeemgYEvyAF0V4awW6zlfkGb+5k
        fx7tP180I4hg7hlZdO0iQyPVigeIMJ0dlQ==
X-Google-Smtp-Source: ABdhPJxwywYhZKlVnPBoYtzEwRifsl1M3itovqi6o7aV4kRdxOX9ucApw8wPNmc+oZGP8SmLb5uUeQ==
X-Received: by 2002:a17:902:c944:b0:161:7b60:e707 with SMTP id i4-20020a170902c94400b001617b60e707mr1308278pla.70.1652909207430;
        Wed, 18 May 2022 14:26:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ij9-20020a170902ab4900b0015e8d4eb1c0sm2195453plb.10.2022.05.18.14.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 14:26:47 -0700 (PDT)
Date:   Wed, 18 May 2022 21:26:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brian Cowan <brcowan@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY
 on 6th gen+ Intel Core CPU's
Message-ID: <YoVkkrXbGFz3PmVY@google.com>
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
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

On Wed, May 18, 2022, Brian Cowan wrote:
> Hi all, looking for hints on a wild crash.
> 
> The company I work for has a kernel driver used to literally make a db
> query result look like a filesystem… The “database” in question being
> a proprietary SCM repository… (ClearCase, for those who have been
> around forever… Like me…)
> 
> We have a crash on mounting the remote repository ONE way (ClearCase
> “Automatic views”) but not another (ClearCase “Dynamic views”) where
> both use the same kernel driver… The guest OS is RHEL 7.8, not
> registered with RH (since the VM is only supposed to last a couple of
> days.) The host OS is Ubuntu 20.04.2 LTS, though that does not seem to
> matter.
> 
> The wild part is that this only happens when the ClearCase host is a
> KVM guest, and only on 6th-generation or newer . It does NOT happen
> on:
> * VMWare Virtual machines configured identically
> * VirtualBox Virtual machines Configured identically
> * 2nd generation intel core hosts running the same KVM release.
> (because OF COURSE my office "secondary desktop" host is ancient...

Heh, Sandy Bridge isn't ancient, we still get bug reports for Core2 :-)

> * A 4th generation I7 host running Ubuntu 22.04 and that version’s
> default KVM. (Because I am a laptop packrat. That laptop had been
> sitting on a bookshelf for 3+ years and I went "what if...")

What kernel version is the 6th gen (Skylake) 20.04.2 running?  Same question for
the 4th gen (Haswell) 22.04.  And if it's not too much trouble, can you try running
the Skylake with 22.04 kernel, or vice versa?  Not super high priority if it's a
pain, the fact that the bug goes away based on what's advertised to the guest
suggests this might be a guest bug.  But, it could also be a KVM bug that's
specific to a feature that's only supported in Skylake+.

> If I edit the KVM configuration and change the “mirror host CPU”
> option to use the 2nd or 4th generation CPU options, the crash stops
> happening… If this was happening on physical machines, the VM crash
> would make sense, but it's literally a hypervisor-specific crash.
> 
> Any hints, tips, or comments would be most appreciated... Never
> thought I'd be trying to debug kernel/hypervisor interactions, but
> here I am...

It might be that there's a guest bug.  And even if it's not a guest bug, you can
likely identify exactly what feature is problematic, though it might require
invoking QEMU directly (I don't know exactly what level of vCPU customization
libvirt allows).

First thing to try: does it repro by explicitly specifying "Skylake-Client" as the
vCPU model?  No idea what libvirt calls that.  If that works, then I think XSAVES
would be to blame; AFAICT that's the only thing that might be exposed by "mirror
host CPU" and not the explicit "Skylake-Client".  XSAVE being to blame seems unlikely
though.

Assuming "Skylake-Client" fails, the next step would be to disable features that
are in "Skylake-Client" but not "Haswell", one by one, to figure out what's to
blame.

In QEMU, the featuers I see being in Skylake but not Haswell are:

  3dnowprefetch, rdseed, adx, smap, xsavec, xgetbv1

Again, no idea if/how libvirt exposes that level of granularity.  For running
QEMU directly, removing all those features would be:

  -cpu Skylake-Client,-3dnowprefetch,-rdseed,-adx,-smap,-xsavec,-xgetbv1

My money is on SMAP :-)
