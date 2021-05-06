Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146A537590D
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbhEFRRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:17:38 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BCBC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 10:16:38 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o16so1018050oiw.3
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MeGz27M2JZPeAMz8xYk+hc3HllROx4rp6RGSZKTTGH8=;
        b=G0CKCYd6JpbMkNPiqAaeCobFhxrYu6Tp1KeRCsKKdLpxth9AcksIAXkTNTJwLcYC8c
         z4G7N2ZlibHCVamiD/9sdqcq4FoV8d5iRtwBosvQRISKDRJ8mMfNMaLCVzvIZ8znETxL
         SfoDHsZnSJx5uOj1uz4yIx+0hvuhjGqIGqrwLX+6R7lyWilsT7GfYFOyRR8c43wBDN8g
         RcvdTLcCkSAzNqh0UzA3UbEPdNpBZl6DfVcd9+RtA0Ku7bydmGo61lFREf/+1jROtgN7
         bmPl2ISx9bboGrR8a15GdvNdrfkEvu7HGdiMprJKc74laU2ULiplWqzx4HVCSDcl3IOw
         G2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MeGz27M2JZPeAMz8xYk+hc3HllROx4rp6RGSZKTTGH8=;
        b=c9ddii+ofO8FgAogTvvtaokDTXTVD5tifKI9RxVi9Rn6eGdqVg/m3moDFfN7bxNVmy
         tYNv20xCzXuk2cwaEcdeTG9qPg3pcia+0zM1QYja5rMPNoXHvZ3JNL5wQ2gNLHy4owmP
         bxZlRb5yC1+1Xj8TjtiMmwo0eHGsEfvBQfL8tUP9KTQfSxSenl78SdkrQdKhyQ9yNx6j
         TMbm1eg5ab4y9LQSnelzhQss25xHDmxJ7xvKOAez+DtSkNSb2aHQImluaiSOS021nA5L
         exPOVc8P9kGLclZAMjQx1B0zOXAVOPNbd9/4D0BEo8H+gU5OKdWSYbcs4ydMTq1/QzSH
         P/NQ==
X-Gm-Message-State: AOAM5311ydbbDw5Fu985FgycvOS0osYqXFmNRYSI1o4IPaV370lxafvI
        h4ZPavWhgOQqUpnfdImVekH53DlAwUJO34k1DeGhMQ==
X-Google-Smtp-Source: ABdhPJxcY3oK9+95sUPzcXlU7GF2cXXtCWnuaridy0REMUjVASFKTZ4jOKl0NW+a49JW691R/7d3wZjrEpttN4RGRWs=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr3969616oia.28.1620321397879;
 Thu, 06 May 2021 10:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210506103228.67864-1-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 May 2021 10:16:26 -0700
Message-ID: <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
To:     ilstam@mailbox.org
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, ilstam@amazon.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haozhong Zhang <haozhong.zhang@intel.com>, zamsden@gmail.com,
        mtosatti@redhat.com, Denis Plotnikov <dplotnikov@virtuozzo.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 3:34 AM <ilstam@mailbox.org> wrote:
>
> From: Ilias Stamatis <ilstam@amazon.com>
>
> KVM currently supports hardware-assisted TSC scaling but only for L1 and it
> doesn't expose the feature to nested guests. This patch series adds support for
> nested TSC scaling and allows both L1 and L2 to be scaled with different
> scaling factors.
>
> When scaling and offsetting is applied, the TSC for the guest is calculated as:
>
> (TSC * multiplier >> 48) + offset
>
> With nested scaling the values in VMCS01 and VMCS12 need to be merged
> together and stored in VMCS02.
>
> The VMCS02 values are calculated as follows:
>
> offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
> mult_02 = (mult_01 * mult_12) >> 48
>
> The last patch of the series adds a KVM selftest.

Will you be doing the same for SVM? The last time I tried to add a
nested virtualization feature for Intel only, Paolo rapped my knuckles
with a ruler.
