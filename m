Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22A4373224
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhEDV7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhEDV7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 17:59:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7B4C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 14:58:54 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id n184so273285oia.12
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 14:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dkzqzuqzIzyGMXhkNhZPDVIt0dLOFYeZCI/9RFkmSpw=;
        b=A6aH728ocHdU2NrXsY8xPLDqJ7siBrQdSFqWFsUTPhsTODpJ+hC/taJAGFixgeCRBB
         vMKpX+AKBQwztDRW+0GskmoASe9dHtX/eGp40ezB/OdWGva0wCEYxb+06LAwCcyBSQpf
         xEbjjQsfvzyVcBQIhy8IA3WALH20I2O2XtNlQYIAEpDbW9ObOE6/ViRgFIXthqxHx/ZY
         c27J7S7GYyHrzNXnEL4F3jq+272FZT6AojDU3c+4W+xM2QitbHthPEFPqhRr0Fs4iRlQ
         72LxfQ0PIsyaK+uX/lG+IzyxYOwnBTkIaUTCISm/AGZwRZFbzxoUYfjpAYYxSvzvPWL/
         dlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dkzqzuqzIzyGMXhkNhZPDVIt0dLOFYeZCI/9RFkmSpw=;
        b=WVhhm4KtSMcZa61FX6WyfMCWkagrfAAwMinD+DXpK11oyVRLuMXJ3s1Qto3Xb7bsFx
         pES+7Qv40wmPx1WcTnm5lDQALLWCMSaoGP/tAdVsljTmkwDei93JhJbCgMChHEW4zPMX
         IcalTiwPe8UUxTUILi8fAJ54PavEiAB2DRpIsaMVDEXL22RRyGAd5gqdIZgYUWtv4e4Q
         4clZlV3e2UlanHXnxfJYNRgtA5PaS66yiU28fAn3R7e8hFyU5bLQKE/3+hOeaiN305G2
         nZ7Ntb3InRRsUwrzJ6NFMmH4bEVH1R4uCZw2Da2xEDuc57s05M5mhAR2zA5dGTBpr0DJ
         CHWQ==
X-Gm-Message-State: AOAM53225i8sczj/gQ5ePspq6vT9Q1cTDsPfpDRtkKYWR3AWDRN0Wlgx
        YnnjPkIQbpsPWNP/k/Cg0DQAfRI/Ii1Pf/iVX0vR9w==
X-Google-Smtp-Source: ABdhPJxT1qz3jzzAnW1j1e9JePjLWPHTdjX7Y6PdLKY9V0JUcegzDyfzvNxBwOXqVCC2jd60hRdIumf+rld7nLeYDxQ=
X-Received: by 2002:aca:408b:: with SMTP id n133mr4711322oia.13.1620165533296;
 Tue, 04 May 2021 14:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com> <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
In-Reply-To: <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 14:58:42 -0700
Message-ID: <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 2:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/05/21 23:53, Sean Christopherson wrote:
> >> Does the right thing happen here if the vCPU is in guest mode when
> >> userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> >> off?
> > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > you specifically mean running in L2?
> >
>
> Guest mode should mean L2.
>
> (I wonder if we should have a capability that says "KVM_SET_CPUID2 can
> only be called prior to KVM_RUN").

It would certainly make it easier to reason about potential security issues.
