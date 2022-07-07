Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C8A56AEDE
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 01:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiGGXNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 19:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiGGXM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 19:12:57 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7BC675AA
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 16:12:56 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10c0119dd16so16254974fac.6
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 16:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTPiCq6o5QBRMPOp6LpD2/BgeXHlU+wjUZU6A5lOqmI=;
        b=Kv4sBtlHcxjTqD2hQ8a0f+HjkdKVfueMchWfmNrAPSBbJ4NdfSZiCWV3gY6kjp/W2p
         lGt5A6E5qBpHPQ/bNOE5IXjUnuQQZFczt9RxXeUV7D5onvSNY1UWjlBDFtbHM0/Rf8V+
         abZtNfXtI2WXMx50jbKQjhbM628BYGInasWQITioCytDhEDC2RTKWWrfL198mOvkFSnO
         ZCcoMh3ZNyQoE49UC+mW+5w5v/swVZY9HCQbFuerUhaV1BhJr5kvWiiJv9ZTrO4RIXSO
         yyYhyUIOFULCq7hELMcAxda2Xr2UIieVxY8DExB4EK3VZdlaN5GI4b4Ks6XeYimwYO0V
         RTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTPiCq6o5QBRMPOp6LpD2/BgeXHlU+wjUZU6A5lOqmI=;
        b=NiVB3EiD9F1rVpwB8gPTHmkllax+xyO43uMcmwHsKJyfxDsLf3QiawajUX0vVqBRwr
         ks5gUovZPBNmpcOPaLUdyVeaFOI/F+FR3gyfp3Xogu/kuaO6/vdQwb76/uS9nKxEgH6f
         uVDZbDgvskyhaRHwueerWJhyXI59WjuJklrSl1emk+3oFz7Z9AC4f+LIqPTigOD4JXhU
         lGMgC78gV+QCG+k1uwFUA7DV/KRMlNRDE0suh9NPuq2PiFzjaI52lhw/x3ycgjZRtWWY
         Ipd2jAd4TTj8TFiF1mAUJeAvUgCPfYvtpsj0oyvIdgDr9ZMSQf14BVPtqGiTC1leOgvk
         dfJQ==
X-Gm-Message-State: AJIora/zauqbQZwLxcf2NJ04wjXmSzi/8tUQ3Vc5j6m5RXlrEkBhd9KO
        7ajiVwdwp1vUxsfFcoI/1No1AL9FQALv/hUMDUZysw==
X-Google-Smtp-Source: AGRyM1vXg3o7dInLHiP/tPHXi9ddVDLyNUgXK++7oeJvRgJ6rSyuJ9DQ3K4nevvDXVKMVECR6Yp0LWT9N80ZGyx2Ndc=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr4456421oab.112.1657235575730; Thu, 07
 Jul 2022 16:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-23-vkuznets@redhat.com>
 <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
 <87wncpotqv.fsf@redhat.com> <Ysc0TZaKxweEaelb@google.com> <CALMp9eTrtFd-pcEeWvyAs7eYe1R1FPvGr0pjQNP8o8F0YHhg8A@mail.gmail.com>
 <YsdSfP7xmMcLv8i9@google.com>
In-Reply-To: <YsdSfP7xmMcLv8i9@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 7 Jul 2022 16:12:44 -0700
Message-ID: <CALMp9eTjVksjTkOQ-=HNKB2oyuCcDw3mC=E+P8XAXafy2MmrPA@mail.gmail.com>
Subject: Re: [PATCH v2 22/28] KVM: VMX: Clear controls obsoleted by EPT at
 runtime, not setup
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Jul 7, 2022 at 2:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 07, 2022, Jim Mattson wrote:
> > On Thu, Jul 7, 2022 at 12:30 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Jul 07, 2022, Vitaly Kuznetsov wrote:
> > > > Jim Mattson <jmattson@google.com> writes:
> > > >
> > > > > On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > > >>
> > > > >> From: Sean Christopherson <seanjc@google.com>
> > > > >>
> > > > >> Clear the CR3 and INVLPG interception controls at runtime based on
> > > > >> whether or not EPT is being _used_, as opposed to clearing the bits at
> > > > >> setup if EPT is _supported_ in hardware, and then restoring them when EPT
> > > > >> is not used.  Not mucking with the base config will allow using the base
> > > > >> config as the starting point for emulating the VMX capability MSRs.
> > > > >>
> > > > >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > > Nit: These controls aren't "obsoleted" by EPT; they're just no longer
> > > > > required.
>
> Actually, they're still required if unrestricted guest isn't supported.
>
> > > Isn't that the definition of "obsolete"?  They're "no longer in use" when KVM
> > > enables EPT.
> >
> > There are still reasons to use them aside from shadow page table
> > maintenance. For example, malware analysis may be interested in
> > intercepting CR3 changes to track process context (and to
> > enable/disable costly monitoring). EPT doesn't render these events
> > "obsolete," because you can't intercept these events using EPT.
>
> Fair enough, I was using "EPT" in the "KVM is using EPT" sense.  But even that's
> wrong as KVM intercepts CR3 accesses when EPT is enabled, but unrestricted guest
> is disabled and the guest disables paging.

MOV-to-CR3 is also a required intercept for allow_smaller_maxphyaddr,
when the guest is in PAE mode. So, that one, at least, isn't anywhere
near obsolete. :-)

> Vitaly, since the CR3 fields are still technically "needed", maybe just be
> explicit?
>
>   KVM: VMX: Adjust CR3/INVPLG interception for EPT=y at runtime, not setup
