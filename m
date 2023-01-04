Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9514C65E0E7
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 00:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbjADXZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 18:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjADXZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 18:25:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3154435A
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 15:18:36 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so218914pjd.0
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 15:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gRcfEeBUiKP91OsdArHb6simzQ/tXUisez8hBc+MWKo=;
        b=YeU28UUL4inyRR7K5g/5Trnb8sZ76lyOBb8OTfdfkx6AUmJMIiQlH+49+Bx4uNuoZ1
         vEH1jJt49B+55yNcwU8pcBuxnU5H+niZCLDOT74HhOcrGXi/b3iUFJf6oQ3H2hAwk8Cv
         qV/caibJO6eCkxt9m/vnTZSwMMvugUGv/DCsV76q1HKtg8CtSlwa1qMBoB5K87kFD7Rc
         jUNXzcbJOFxtniFBeSIjzUvUH0UQwWSdGVWYkRR2sqxFVUc+ovakE6SFIFI8aDfyqg/M
         MHSMOx4t9dqPYWD2v/2peV6yfGXbq+aq2msDKuTegR7aE7AHA9YTjyHt5woOqX8OMir1
         adEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRcfEeBUiKP91OsdArHb6simzQ/tXUisez8hBc+MWKo=;
        b=au6BP/j+xyhjXoh37w5UuffWTbW+g9eUyqZPfNPCpBle7Bok304jdFDOLMW1b9urWq
         1kPHLhrzls1khNAA/t4p+BbXaiNKrZG42i6HKik3Gd6oWsfvo94bIv7xxkBhmARMtzsF
         m8oDcQ115qSdaG/ZbEZPlwK6ejqGuiINJsbvOycL5Ksn3jIQ/6ep8ftAPQb7btQD1hG8
         IvSIseIVfFd6jo6vuJwG67K1oD6o9lbOZWnfTzXoUcs7HRKI6Mnbc7KmLgIstnR30aIO
         Y79dOpVHHaaQvKE500T/vBgTcaibxac6GDVMmD7+r72FegKwvZrCXFMwyIcBbtjpFcI8
         LvAQ==
X-Gm-Message-State: AFqh2kqOP2JWF3dViJWUq6ROojaPn9uaQG+fABGc+WsVJG6dH6XlErM5
        CiMfSxH8uQzGHF78hWl1MXMC5g==
X-Google-Smtp-Source: AMrXdXsDjg+cB5XnlPEkPebRkiYzNI867eG9HsWV7lTjWcL2caaY5Z5/HSEP85Wc/JySwN/fQSfHrA==
X-Received: by 2002:a17:903:2481:b0:191:1543:6b2f with SMTP id p1-20020a170903248100b0019115436b2fmr3952plw.3.1672874315439;
        Wed, 04 Jan 2023 15:18:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ec8200b0017f72a430adsm24909082plg.71.2023.01.04.15.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 15:18:34 -0800 (PST)
Date:   Wed, 4 Jan 2023 23:18:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y7YJRwlWVqt3uY9/@google.com>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
 <Y5IQNY/fZw2JFA0B@google.com>
 <Y5IUsB83PzHCJ+EY@zn.tnic>
 <Y7XpTAFV6BLT8KgB@google.com>
 <Y7YDz/8lsVigmeXF@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7YDz/8lsVigmeXF@zn.tnic>
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

On Wed, Jan 04, 2023, Borislav Petkov wrote:
> On Wed, Jan 04, 2023 at 09:02:04PM +0000, Sean Christopherson wrote:
> > And there's a non-zero chance we'd end up with a kernel param to allow booting
> > unknown CPUs, e.g. for people doing weird things with VMs or running old, esoteric
> > hardware.  At that point we'd end up with a more complex implementation than
> > processing dependencies on synthetic flags, especially if there's ever a more
> > legitimate need to process such dependencies.
> 
> I'm sorry but I'm still unclear on what actual use care are we even fixing here?

There's no fix.  What I was trying to say is that modifying the kernel to refuse
to boot on unknown CPUs is opening a can of worms for very little benefit.

> If it is about people who'd like to tinker with old hw or doing weird VM things,
> they can just as well adjust their kernel .configs and rebuild.
> 
> Peeking around your patchset, if all this is about dropping the
> X86_FEATURE_MSR_IA32_FEAT_CTL check and checking only X86_FEATURE_VMX and in
> order to do that, you want to cover those obscure cases where
> init_ia32_feat_ctl() won't get run, then sure, I guess - changes look simple
> enough. :)

Yes, this is purely to drop the explicit X86_FEATURE_MSR_IA32_FEAT_CTL checks.

Alternatively, we could just drop the checks without processing the dependency,
i.e. take the stance that running KVM with a funky .config is a user error, but
that feels unnecessarily hostile since it's quite easy to play nice.

Or I guess do nothing and carry the explicit checks.
