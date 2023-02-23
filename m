Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE46A129B
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBWWK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBWWK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:10:26 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3DB1A978
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:10:25 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id bd41-20020a056a0027a900b005a9b2e7702dso5376336pfb.8
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yypR5SWr5fAuROcOSsEI5X6eT6hSchBRQPrL8thWA1U=;
        b=Jwv6kgov7x4dkPOvT37pVWQMD8Sxulc331jV+U+RIv1e1GNNNH3O2x/Z2djCWe0h7A
         Vu2hLZhFLTSCCY7aLleOLB7viUmS+j1BnXMWTUgMoKo3Hc71KYI4ULXXgTG8yPmpVNLL
         +6DO7D628eoUBDXU9Yus+s7IgPoJjWTxUXAIFbDU+7Tj64sGbYuOWSe1d5Xz+Yn9r65X
         nWN65qOi3vwmEmFmwmWGAdDdUvSAn200wpPrRJhtXfNIn/XujWRvK8y/21gWqdsf1zWk
         G+kuE/NWbz29bKhFsL0N2NoAtAsxmpDb0Z5E9MDs0LnP60S/oYkNCO+by4+ftUNWmYME
         yAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yypR5SWr5fAuROcOSsEI5X6eT6hSchBRQPrL8thWA1U=;
        b=vngjI1S0ZDE3mQtOFeeK+rdbHNA9DZhpCQcVey4haZapx28nzv6CMxcO2nUnBA9Vw2
         NpptOoj9cNUUZhUyWn5UuOXzjsIx/E6XgnGECZ/GsMx69s9SNaNitjxvpajDnMAX6Z4U
         LJQNiP1b3OmH01+f5UCCNpK57DxFil9GVhQZPbfIRvlfPDrUoJDuWAEMKubcKxKRPESX
         k7VsZ3E7Kr9TSRQ13IqbhgEcghdpaqwvppdZPrwsSfbUHB1rYdN+P3HS2J1BB7CiJ3H0
         0pV6+LNtGYG09pfP6zEZj8nZ72EOOiiu8jYnQFeEeZ1zYAbTeYYQ+84vbGEvQz7qfMKv
         kvYA==
X-Gm-Message-State: AO0yUKUnvE2Ol6pif22aa8AnkPRJQq462rr2wl+hXAKlDdQ517TR72ED
        ON4aDlQAUCwIkJSOXL4JZc1vzZcd1c0=
X-Google-Smtp-Source: AK7set/mTkvRAH6S3QvmwPwwMO1+qJXpKcN7A7wBH4UY6Rz/dgjxv7hA4d9WaGpDXpcjxAn6zfGPBHiU4R4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284b:b0:233:d613:a9ae with SMTP id
 p11-20020a17090a284b00b00233d613a9aemr868033pjf.3.1677190224408; Thu, 23 Feb
 2023 14:10:24 -0800 (PST)
Date:   Thu, 23 Feb 2023 14:10:22 -0800
In-Reply-To: <092591cbcc40fbbcc42abd3f603b6d782f411770.camel@redhat.com>
Mime-Version: 1.0
References: <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
 <YzRycXDnWgMDgbD7@google.com> <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
 <YzSKhUEg3L1eMKOR@google.com> <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
 <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
 <06d04f32-8403-4d7f-76a1-11a7fac3078e@redhat.com> <Y/aWx4EiDzKW6RHe@google.com>
 <05144c6d-922c-e70d-e625-c60952b60f3c@redhat.com> <092591cbcc40fbbcc42abd3f603b6d782f411770.camel@redhat.com>
Message-ID: <Y/fkTs5ajFy0hP1U@google.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Maxim Levitsky wrote:
> On Thu, 2023-02-23 at 08:01 +0100, Thomas Huth wrote:
> > On 22/02/2023 23.27, Sean Christopherson wrote:
> > > On Fri, Feb 17, 2023, Thomas Huth wrote:
> > > > On 29/09/2022 15.52, Maxim Levitsky wrote:
> > > > > On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
> > > > > > On 9/28/22 19:55, Sean Christopherson wrote:
> > > > > > > > As far as my opinion goes I do volunteer to test this code more often,
> > > > > > > > and I do not want to see the 32 bit KVM support be removed*yet*.
> > > > > > > 
> > > > > > > Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
> > > > > > > coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
> > > > > > > BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
> > > > > > 
> > > > > > Yeah, maybe EXPERT is better but I'm not sure of the equivalent test
> > > > > > coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but
> > > > > > what's wrong with booting an older guest?
> > > > > >  From my point of view, using the same kernel source for host and the guest
> > > > > is easier because you know that both kernels behave the same.
> > > > > 
> > > > > About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
> > > > > one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
> > > > > these days compiles a 32 bit kernel, knows what they are doing.
> > > > > 
> > > > > I personally would wait few more releases when there is a pressing reason to remove
> > > > > this support.
> > > > 
> > > > FWIW, from the QEMU perspective, it would be very helpful to remove 32-bit
> > > > KVM support from the kernel. The QEMU project currently struggles badly with
> > > > keeping everything tested in the CI in a reasonable amount of time. The
> > > > 32-bit KVM kernel support is the only reason to keep the qemu-system-i386
> > > > binary around - everything else can be covered with the qemu-system-x86_64
> > > > binary that is a superset of the -i386 variant (except for the KVM part as
> > > > far as I know).
> > > > Sure, we could also drop qemu-system-i386 from the CI without dropping the
> > > > 32-bit KVM code in the kernel, but I guess things will rather bitrot there
> > > > even faster in that case, so I'd appreciate if the kernel could drop the
> > > > 32-bit in the near future, too.
> > > 
> > > Ya, I would happily drop support for 32-bit kernels today, the only sticking point
> > > is the lack of 32-bit shadow paging test coverage, which unfortunately is a rather
> > > large point.  :-(
> > 
> >  From your point of view, would it be OK if QEMU dropped qemu-system-i386? 
> > I.e. would it be fine to use older versions of QEMU only for that test 
> > coverage (or do you even use a different userspace for testing that)?

For me personally, I have no objection to dropping qemu-system-i386 support in
future QEMU releases.  I update my 32-bit images very, very infrequently, so I
probably wouldn't even notice for like 5 years :-)

> From my point of view qemu-system-x86_64 does run 32 bit guests just fine.

Right, but unless I seriously misunderstand what qemu-system-x86_64 ecompasses,
it can't be used to run guests of 32-bit _hosts_, which is what we need to test
shadowing of 32-bit NPT.
