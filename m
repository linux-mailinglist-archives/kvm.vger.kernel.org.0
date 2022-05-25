Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B7053449F
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 21:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiEYT6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 15:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242787AbiEYT6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 15:58:08 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A35928718
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 12:58:08 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-30007f11f88so94491937b3.7
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 12:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmDxsJ6i0l3yZxw4603pf8sLMl0BpZe4/c+3ywawfzA=;
        b=aA6k5RfRigvUJ6/9geUUkOFrJpG2nHRWalXtO9jby6ndzACwBJ7XXXzdwS+1s9uq6s
         xWs7qmUsdl2U+ZVBgBztAhQulyeg3keZ9+y9luvuENw/OxGFcQmfAvKmeXWBTpmwqKPV
         +rcnB5GHaNyAxB3zVFk1tf6WKvyp0BxamAymZrS5Vct0YOR8S6pw+qJgh1g5pqO8rF8Q
         c5/qbWXzm9HD4SAXYqYPQXZQVPyEFNKPQfagkdN2f23o9O1QDGwbljsIECVUY1HM1AoJ
         Nj6QhZ+ZuxxSHjMGxpwAlIvZpuNzkSLfR8jvpYItZgQDcGhiJWqKNsVAflsNsWrTFTQv
         EF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmDxsJ6i0l3yZxw4603pf8sLMl0BpZe4/c+3ywawfzA=;
        b=2R0rhjGgfA8aHF8bFf66ys7bmA/BO/O4URxSgmpraaF8LUimsw9TtPuwLRPSkgTbxm
         ECESs9WgGYNKF1YzrDgEIGAs4qNzvyf1xIJnrdXaYQAfd/TC/W5Oi9jSLr6gwbA58vAT
         pBgzdky2SaqW3UJTn5+JbOhdAIozzuVE5vrn8iZMjwne+W/b70trnGLYTf82C64NJKhC
         3s1Ad0IQ+kpdGUKz6Ilkl+KWC89dE105j8X0mnYv1jOs32RvnhDlbdXIkLYstWMrLevj
         FZ6sCb0Fb5p1TM3jjDf4TdNCZnsrCVbZRtTQxRcQ+x2ObTY/gYiMUEaO8gWyA6Cb6WXR
         oZYg==
X-Gm-Message-State: AOAM5317NN491xdAEX7SfAv/E0qeKEWamXXC8MHY93P4Jfu2vyQK1hP/
        jSeqB/CCuZZKljwPX3+w6WFjSvdsenbAERoQh+5b0WhK
X-Google-Smtp-Source: ABdhPJwQ04QAEg/yjlB0xh1XAEsUY+nP0h48rAuh5LQZxNDfyjOhmFB0PtUODvXxTzHiD89B3LnPuDbEjeUC2qIxf3Q=
X-Received: by 2002:a81:3a4e:0:b0:2fe:c95a:c705 with SMTP id
 h75-20020a813a4e000000b002fec95ac705mr35178988ywa.45.1653508687162; Wed, 25
 May 2022 12:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com> <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
 <YoeyRibqS3dzvku6@google.com> <CAPUGS=rLcHQWpdjSaEMNTthR5EH8opZoOvW1OSs0zPJezBPbYg@mail.gmail.com>
 <CALMp9eRP7gSMB+-CyxtnTniyfuzJdP3qy9G=5f8rMbfDNGZFeg@mail.gmail.com> <CAPUGS=r+eTgBjusPT-7aNL8GdhBmgVMdWYrhSK3boiDdOxFvRA@mail.gmail.com>
In-Reply-To: <CAPUGS=r+eTgBjusPT-7aNL8GdhBmgVMdWYrhSK3boiDdOxFvRA@mail.gmail.com>
From:   Brian Cowan <brcowan@gmail.com>
Date:   Wed, 25 May 2022 15:57:56 -0400
Message-ID: <CAPUGS=p7OTZ3uLoA3WGPb=xq8pBvzQKb1P-6jgZnx6jXJnDAXQ@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
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

Welp, I had to reinstall VMWare Player on this host, and after finding
out that the only way to get past the "join the customer experience
improvement program" prompt was to run the blasted thing as root ONCE,
I was able to build a new VM... SMAP is enabled there... Annnnd.
Kaboom. I looked at the ESX servers that I have my Linux test VM's on,
and no SMAP. So *of course* there's no crash.

So, in the immortal words of Emily Latella: Oh... Never Mind!

At least I now know.

On Tue, May 24, 2022 at 11:30 AM Brian Cowan <brcowan@gmail.com> wrote:
>
> Virtualbox 6.1.34: Nope, smap not there for the guest even though it
> is there for the host (Ubuntu 20.04, but with a too-new kernel I can't
> test the driver against. Now... Where did I put that spare SSD....)
> VMWare Player: Have to check to see if SMAP is allowed there shortly...
>
> On Fri, May 20, 2022 at 7:09 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, May 20, 2022 at 3:03 PM Brian Cowan <brcowan@gmail.com> wrote:
> > >
> > > Well, the weird thing is that this is hypervisor-specific. KVM=kaboom.
> > > VirtualBox is happy, and we can't make this happen on
> > > roughly-analogous ESX hosts. I can't directly test on my (ubuntu)
> > > laptop because the driver won't build on the too-new ubuntu 20.04.2
> > > "Hardware enablement" kernel as it's too new. But either all the other
> > > hypervisors are doing this wrong and allowing this access, or KVM is.
> > >
> > > Not being a kernel expert makes this interesting. I'm passing the
> > > possibility list over the wall to the kernel folks, but most of the
> > > evidence we're seeing **seems** to point to KVM...
> >
> > Which version of kvm? Any unusual kvm module parameters?
> >
> > Does the guest under the happy hypervisors report that it has smap (in
> > /proc/cpuidinfo)?
