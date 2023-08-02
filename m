Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0219476D21E
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbjHBPgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbjHBPft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 11:35:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2613C00
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 08:35:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bba7a32a40so53661245ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 08:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690990513; x=1691595313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eXA1T7JmGWAKlz5WKva9qUA0PJ5k+FcRMYlr91yxr48=;
        b=ol/qMSivwT1iENMFxDjh2B4/2i95/AvHO1rUnkjEW/0fGNMo/re/cW2NcTSCSErt5W
         hwZfNL0ZL9FIqji9/cSg0jWD4ON9pJrh+xFXl2E6C+so9LaU9gIpAb9eJGWg07Djw4oe
         sG8+BfwtbI2QsZeVLieqrkGRxHSISsrqgpVAwbLbU35r6H5Vc+pdAfKL1KCO59mRIW/s
         IU7B3oZxnCbiZV0GbNjnjMktXCQLMdKTrG5cydYCsttNocDlbqxSAinPbehQ+qHSEJSf
         3KFUxTMN2eV/a1nzwqlOx4XdLhwPVWUL22lAYKh0j9pavCY+hC+HvAaz48CbRxx1PaJw
         rIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690990513; x=1691595313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eXA1T7JmGWAKlz5WKva9qUA0PJ5k+FcRMYlr91yxr48=;
        b=ExD1ocwCAa0D0pknfmxbc9aKgGJNtiCuQSLn3MyNNU4yZWsHfPExgv/v+tUTTim5/8
         tSS6seS+3IkmSMdSiQVjiid8tf0GCbAtR3UMzIqge+L2GMzhYzmhqCaYE+vB/Fds6okK
         CVJNcb5Xhe0n32siHgddztkxNDL9F6U7yQNCZtHa9s3e4tTDm79uFsMm66qVGAakRwPo
         tlidGkR4KOHNPkJ4W2SZiWFo5sfIITqCou1zY1hw8vJjBV7fzTooIVAvlVbPQVG8q8Er
         0eVnGXajbzyHYviyPFbf8BDU7TiVXkr9sBqp32OX8D01srzd9kUJUdM1p4siuIQ1qEBG
         yvMA==
X-Gm-Message-State: ABy/qLZNI5DUAf8qHdE4aC+leYQLyRAxD20sOSrtjs7CrYk01d0p2BMV
        YqYhVm1THXDaWf+MG4W684+u4RPiito=
X-Google-Smtp-Source: APBJJlHn97JVmgEHjSZ1QCk6ntpQDQXEI5zlONaDToQeNFXiL+XQaOZdDpcXDxYBkRUEAvZ20MDyrhoHRZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea08:b0:1bb:c7c5:3eb6 with SMTP id
 s8-20020a170902ea0800b001bbc7c53eb6mr90737plg.7.1690990513727; Wed, 02 Aug
 2023 08:35:13 -0700 (PDT)
Date:   Wed, 2 Aug 2023 08:35:12 -0700
In-Reply-To: <7b4d5df0-f554-2fc0-5c19-021f8eb3f6aa@amd.com>
Mime-Version: 1.0
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn> <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
 <ZMphvF+0H9wHQr5B@google.com> <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com> <ZMpwiSw9CBZh9xcc@google.com> <7b4d5df0-f554-2fc0-5c19-021f8eb3f6aa@amd.com>
Message-ID: <ZMp3sAQqRlNYqfwr@google.com>
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Tom Lendacky wrote:
> On 8/2/23 10:04, Sean Christopherson wrote:
> > Side topic, KVM should require nrips for SEV and beyond, I don't see how SEV can
> > possibly work if KVM doesn't utilize nrips.  E.g. this
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 2eace114a934..43e500503d48 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5111,9 +5111,11 @@ static __init int svm_hardware_setup(void)
> >          svm_adjust_mmio_mask();
> > +       nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
> > +
> >          /*
> >           * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
> > -        * may be modified by svm_adjust_mmio_mask()).
> > +        * may be modified by svm_adjust_mmio_mask()), as well as nrips.
> >           */
> >          sev_hardware_setup();
> 
> You moved the setting of nrips up, I'm assuming you then want to add a check
> in sev_hardware_setup() for nrips?

Doh.  I like to think I would have noticed that I forgot to add that check before
postinga patch, but I give myself 50/50 odds at best.
