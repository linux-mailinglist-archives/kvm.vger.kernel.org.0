Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6023D5A9F2B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 20:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiIASgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 14:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiIASgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 14:36:15 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EE14B0FC
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 11:35:22 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-11ee4649dfcso27269166fac.1
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 11:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=w9vPoGxnJYPTBcVB8zWc3jTUh0cKyDSyhYoSlFQ2Ztg=;
        b=lPf/ZQzvFLJn+86t48Rtx7KerpZuccQnHyyL4Y86OqyN9zJdRueytUhs8WYKwenF3v
         TPJp425E9l/yr63NX+NJ0yX6YJSvQuGQnpWy9jtPZoJE1DMG2vRiBg6GyBDUdab/E9uJ
         cTOc28KB7TacctpgldRWxTTIFLO6OxJVoXJpdnc8g4/69ICpFElBLReYIBwemxixxTGR
         F6cW8G+KBEGv8EC48qB/oSbKbveGCiEpdD+cSl2NupcF8S/y/xeCuJb++lfN4vwjVA5O
         SIU9dmP5phSsXUMS+DKoBTEVAmkD2fsmuwRmjmiGixFFrd/NyljVqywmKAeBy3lmXz8r
         mPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=w9vPoGxnJYPTBcVB8zWc3jTUh0cKyDSyhYoSlFQ2Ztg=;
        b=FiyuWdpa6DzWC4JUiLF3WMYNgM0QAh7zD/zqJnZrA5X84rRHO+prldai77KcIkLTLd
         fEQZS6I6mQPa417M3x1COWark2VJKHj5In8dUr/YBv4DNX695nyIFTFcQl3suTBB2R9/
         H0KpNLCNzz6p95S+YbOrukamQoYb9knKNd9pAlgcrK5QSq+0uxOE3i9QOOc/D2NQgdkh
         +zfyncHkOJ9xfXTlPJWqrOIZDKBTKoG2cEZ2+AaT+SmVhyhrctJZYGsD2TvvAx92KRJA
         wxR510WbgSkUCuas8C9ALsl6Tu/b5R8Nu385BvaJibjoBeluoVzfOVqH6cfg2fWFxxV0
         IYBQ==
X-Gm-Message-State: ACgBeo02I3kP/Vgu4KGfM4qTYk481TUVmG9sYGp/zmYP3pqDn6y/8R97
        nxoXg1j6YW07BYuj/FNeycU73cQWH0nkorR9iAbAOu3J3gNrEw==
X-Google-Smtp-Source: AA6agR6yhYQNndo3DP8E+MpfL0hMQbKpX7h1KPHS3Zo5ZhQ3eWfpCHqLQs5I9sHt6/nN/b7GBGRn3NTelxHmixtDwt4=
X-Received: by 2002:a05:6870:5a5:b0:122:5662:bee6 with SMTP id
 m37-20020a05687005a500b001225662bee6mr248617oap.181.1662057321503; Thu, 01
 Sep 2022 11:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
 <Yw8aK9O2C+38ShCC@gao-cwp> <20220901174606.x2ml5tve266or5ap@desk>
In-Reply-To: <20220901174606.x2ml5tve266or5ap@desk>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 1 Sep 2022 11:35:10 -0700
Message-ID: <CALMp9eRaq_p2PusavHy8a4YEx2fQrxESdpPQ_8bySqrv61ub=Q@mail.gmail.com>
Subject: Re: BHB-clearing on VM-exit
To:     Pawan Gupta <pawan.kumar.gupta@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, chen.zhang@intel.com,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 1, 2022 at 10:46 AM Pawan Gupta <pawan.kumar.gupta@intel.com> wrote:
>
> On Wed, Aug 31, 2022 at 04:22:03PM +0800, Chao Gao wrote:
> > On Tue, Aug 30, 2022 at 04:42:19PM -0700, Jim Mattson wrote:
> > >Don't we need a software BHB-clearing sequence on VM-exit for Intel
> > >parts that don't report IA32_ARCH_CAPABILITIES.BHI_NO? What am I
> > >missing?
> >
> > I think we need the software mitigation on parts that don't support/enable
> > BHI_DIS_S of IA32_SPEC_CTRL MSR and don't enumerate BHI_NO.
> >
> > Pawan, any idea?
>
> Intel doesn't recommend any BHI mitigation on VM exit. The guest can't
> make risky system calls (e.g. unprivileged eBPF) in the host, so the
> previously proposed attacks aren't viable, and in general the exposed
> attack surface to a guest is much smaller (with no syscalls). If
> defense-in-depth paranoia is desired, the BHB-clearing sequence could be
> an alternative in the absence of BHI_DIS_S/BHI_NO.

Just for clarity, are you saying that it is not possible for a guest
to use the shared BHB to mount a successful attack on the host when
eIBRS is enabled or IBRS is applied after VM-exit?
