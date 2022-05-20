Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB10352F576
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 00:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353818AbiETWDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 18:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351380AbiETWDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 18:03:22 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB22E13F90
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:03:21 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id d137so16238384ybc.13
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 15:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F8C0jBvTNyk69tm2DyakaXuJSFETgotiRsBksa+PJEU=;
        b=SddXt7ZKYF+k9Q0IgrPT04wbXx+jwB/U1F1qicH8+4m7W0z6N/LFZz2VXcQvLBf3V7
         HWiacBuhJNipIiX/4xu4M7SWOIyC+7Dm8C+Etc6Mrd2QnValCC0XCf8fFu5G0GmWXhST
         xEkz0LH47BMSDDpV1MQPYvW5MrNlazJWptoZfhdFPLOEnSXzxmblLGrVu6m5S0UiP4bY
         QFIVMQQcjDRAWs85TxjgISTlq05WzmBrghG4oDGq2atATfyEUSqT4akgcQJHCAFv/Oz7
         wplHjRW3IKmErJfrR/hMQ7aEF6z9ZmlYWjDXGNIyFD6K3V4LJcMF+D3XpZ3P8AQha6Rf
         f8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8C0jBvTNyk69tm2DyakaXuJSFETgotiRsBksa+PJEU=;
        b=6UnzFw1L/PrAS0g5bJLmNE5YTxmVqoidQlg245CBPX4ZZCU67psMzVPJNLIY1rUMVN
         hZEDBov88F0sVy0a9d/INhKrRbPR31BvceJ/dWfHVjSe42ST/67zf9+URrvdn5sH6cGt
         PA9aZPpDO8ZlcujSD0e0/0imNn8Ye8TqtrbT75qqnNs0kknK6MChUiLFf6W6Qf+bA/uu
         vJG+lraRfX7is5xzt0Qmojii52iLB1c20Lzlew/P8YD4eVpqbMdyYYOH0Z1+56jr+c9P
         x5113F3BDDeqi/Ww/QxqsNs/rn7iRhKtYGrQTlyKiN0Qiy1jIZhzy4LwOml16+Xo7AVp
         +XNQ==
X-Gm-Message-State: AOAM53363jwVQOl3uo/lqQl8soAFrpRj0M4xZ468lm/e2yIHsWJIsXOK
        3GtXzLFZT+FvXHiD2XY5qjNIx7FVjeqDknrtPi3KyX4y
X-Google-Smtp-Source: ABdhPJyimShGf6dE3KGCr1DWgukPajLKyF9o4D73PqtFtY0Z4nLQtdYaBcGJ4Xhl9R4mRSbScd/sFeTUPelCbpGSwpo=
X-Received: by 2002:a05:6902:124d:b0:649:2a55:18a with SMTP id
 t13-20020a056902124d00b006492a55018amr11982053ybu.155.1653084201104; Fri, 20
 May 2022 15:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com> <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
 <YoeyRibqS3dzvku6@google.com>
In-Reply-To: <YoeyRibqS3dzvku6@google.com>
From:   Brian Cowan <brcowan@gmail.com>
Date:   Fri, 20 May 2022 18:03:10 -0400
Message-ID: <CAPUGS=rLcHQWpdjSaEMNTthR5EH8opZoOvW1OSs0zPJezBPbYg@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Well, the weird thing is that this is hypervisor-specific. KVM=kaboom.
VirtualBox is happy, and we can't make this happen on
roughly-analogous ESX hosts. I can't directly test on my (ubuntu)
laptop because the driver won't build on the too-new ubuntu 20.04.2
"Hardware enablement" kernel as it's too new. But either all the other
hypervisors are doing this wrong and allowing this access, or KVM is.

Not being a kernel expert makes this interesting. I'm passing the
possibility list over the wall to the kernel folks, but most of the
evidence we're seeing **seems** to point to KVM...

On Fri, May 20, 2022 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 20, 2022, Brian Cowan wrote:
> > Disabling smap seems to fix the problem...
>
> Mwhahaha, I should have found someone to bet me real money :-)
>
> > Now for the hard question: WHY?
>
> The most likely scenario it that there's a SMAP violation (#PF due to a kernel
> access to user data without an override to tell the CPU that the access is intentional)
> somewhere in the guest that crashes/panics the guest kernel.  Assuming that's the
> case, there are three-ish possibilities:
>
>   1. There's a bug your company's custom kernel driver.
>   2. There's a SMAP violation somewhere else in RHEL 7.8, which is an 8+ year old
>      frankenkernel...
>   3. There's a bug in your version of KVM related to SMAP virtualization
>
> #3 begs the question, does this fail on bare metal that supports SMAP?  If so,
> then that rules out #3.
>
> If the crash occurs only when doing stuff related to your custom driver, #1 is
> most likely the culprit.
>
> One way to try and debug further would be to disable EPT in KVM (load kvm_intel with
> ept=0) and then use KVM tracepoints to see when the guest dies.  If it's a SMAP
> violation, there should be an injected SMAP #PF shortly before the guest dies.
