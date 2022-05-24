Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911AC532D8A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiEXPan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiEXPam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:30:42 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738805F8F1
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:30:41 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id i187so29290916ybg.6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDWotKcjK0r7Cp+U+x5EjbUVrhtTGnyRmRrkF6CSh8I=;
        b=Rq8HDNFeW8UThJYa3ywlqvcKzNqTg7P6S/JW28N7hxFOT6cQdakGEJQLuogdbItbgm
         N4bL1j2bhL9KfbxrrB7OAmNI0Z8DOesTlg6HPbZKyWdjAPhmc2mAs/VvYN2mMtNDGkIA
         rkaG6Ccd82UsiJT6nEz2gZHfzQz/cIhzs06lSqUhBJOp5yb5elPW+Rtw1QGIYp1j2GEr
         wwD6+Keidab/v6xysB5pW23Pr+ywACb8GovWnZgV2UcTT75SHvrPHHKF6eySiucwAJ/Y
         byRTdaywIF2yLKGfgrOkuuSu7zm9hav5+acNQtRJgA/uqSda1N/tzB0uBruVtRZeOO5G
         REAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDWotKcjK0r7Cp+U+x5EjbUVrhtTGnyRmRrkF6CSh8I=;
        b=RkRi0VKutsTFG63VsjhXTkW0JDkAmixehvQ9quKGWzXuheGdPxFPhrtJr9gVsharkO
         DZOtJZiLH3Fer2nCTsASzhbk+5CQYhojgEglrgTWPs8WDFul2SphnZsknz4T1XLUq4cX
         Q9lKtrdJr+5u/jN5TVuT0Fcyw7zdPeI1uVOK4fncqBQPYWXoCwycYhyhj+JgdCuU9+1W
         cFsERnyC0boLBmei1JjNI27rMxaOtafjdec1QUMt+QhmZrQkxZj0cKzbaq7chx32qXzB
         8i/l+93FPV1JTXTErU4LhuW8GWcgiCexxGfey4PuNHfGmxMBiEeHptgbYjvNs/qvFjNf
         /ZfQ==
X-Gm-Message-State: AOAM532bHtSEf8g7UG0/V0mjyh1vMMlCy/tpXRFdjtLXhAyHgFAMJVGu
        wmi3fwOfKEBlyoGOT5Dos3dleAQEC5rJ6bog41nwtBIT
X-Google-Smtp-Source: ABdhPJzybUXNEBnDaipoIICdLr7+HFLJ2ABJYnS6b96QR3YBc8MR+32h2aAWj3q3WJdKDQpk2auvCTAJwaKY+agfcgg=
X-Received: by 2002:a25:7c05:0:b0:64b:9b64:4217 with SMTP id
 x5-20020a257c05000000b0064b9b644217mr26507219ybc.179.1653406240603; Tue, 24
 May 2022 08:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com> <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
 <YoeyRibqS3dzvku6@google.com> <CAPUGS=rLcHQWpdjSaEMNTthR5EH8opZoOvW1OSs0zPJezBPbYg@mail.gmail.com>
 <CALMp9eRP7gSMB+-CyxtnTniyfuzJdP3qy9G=5f8rMbfDNGZFeg@mail.gmail.com>
In-Reply-To: <CALMp9eRP7gSMB+-CyxtnTniyfuzJdP3qy9G=5f8rMbfDNGZFeg@mail.gmail.com>
From:   Brian Cowan <brcowan@gmail.com>
Date:   Tue, 24 May 2022 11:30:29 -0400
Message-ID: <CAPUGS=r+eTgBjusPT-7aNL8GdhBmgVMdWYrhSK3boiDdOxFvRA@mail.gmail.com>
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

Virtualbox 6.1.34: Nope, smap not there for the guest even though it
is there for the host (Ubuntu 20.04, but with a too-new kernel I can't
test the driver against. Now... Where did I put that spare SSD....)
VMWare Player: Have to check to see if SMAP is allowed there shortly...

On Fri, May 20, 2022 at 7:09 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, May 20, 2022 at 3:03 PM Brian Cowan <brcowan@gmail.com> wrote:
> >
> > Well, the weird thing is that this is hypervisor-specific. KVM=kaboom.
> > VirtualBox is happy, and we can't make this happen on
> > roughly-analogous ESX hosts. I can't directly test on my (ubuntu)
> > laptop because the driver won't build on the too-new ubuntu 20.04.2
> > "Hardware enablement" kernel as it's too new. But either all the other
> > hypervisors are doing this wrong and allowing this access, or KVM is.
> >
> > Not being a kernel expert makes this interesting. I'm passing the
> > possibility list over the wall to the kernel folks, but most of the
> > evidence we're seeing **seems** to point to KVM...
>
> Which version of kvm? Any unusual kvm module parameters?
>
> Does the guest under the happy hypervisors report that it has smap (in
> /proc/cpuidinfo)?
