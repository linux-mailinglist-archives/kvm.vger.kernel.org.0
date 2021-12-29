Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD0480E07
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 01:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhL2AF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 19:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhL2AF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 19:05:29 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC7C06173E
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 16:05:28 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id w7so11552347oiw.0
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 16:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32Wtn2BBTzP1usnosTui06khYl1Qc21PEMfBrdcRzyk=;
        b=dk+9D/MZ0F3L58c3D7sl5G0TDcKk2kyODgSQE6Qvd88/pdkSSMRIsWek7Mdm9nYF4A
         ZXwPfOALKh5/RFYFij2MObePiya0oSEuaPos+VCe1y+EI8rw5DF9Njfmw8WROqSwXTnK
         ehicUSFk2c8C+PGrRARTKfGTkPHt4DWVX+LB4HdbHxjUpya9sDW0PTT9q0WDrP+w6538
         nctKAC2T7X1CWIsnJquobR+xJ+YMF/MA4hsm/nV8eHe8Ym7NOvpryp+Wey04+nb69CQr
         U77OTK8git8kumIg04Rwa8sSt6bCnvB0n87wt4MIrK8uLScEL0LOYPLkXbgjuSJGxQzt
         vLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32Wtn2BBTzP1usnosTui06khYl1Qc21PEMfBrdcRzyk=;
        b=CAsQMAf9+dSVTTzPh0W3zMnw+ES/rL8yj2R9RltbKTAHouuFmfzFNcqYH+6Ch6QIkF
         eij6vMi0Ub8hC53StTxo0COH7cuymQDZ7TXAcCPuP8b7JBcWto5Xak/DpSKykbAdcxbd
         9wA0P94Q0ETuYePP3qXt5W5WkG5fa8sDwLN5qIPYbfPBh6ZaxSn9wXLIChrir1GNEDqY
         Xoc1rJd5cupEKM1X9qW3Jb2cWZCYX8QXKcBKdQoTj8wrwVQd0vk82y9xOTnKsHTyaEL9
         8nwB76hzSB1uyWCx2nQuLiQUcIMaa7ut+oiv5lnHKZv/lXIVzJM/LSKcE+eCBI7Jt2L2
         B8ZA==
X-Gm-Message-State: AOAM533WI0//tBKMll1SIr3yM3JDs0VHl5hm1sJEmcPbHTAEKhrzsvpq
        Z/wZX9R6Z+PWKQdBrZh51BLqjzXusGrxm6BaXMp23HPVMCg=
X-Google-Smtp-Source: ABdhPJzymNPJ55EvbPXBgesiSVDvllFDNyFrBK40MXAcllMHAML9lzUsz95whgyN4iy6OpD3Pca21Tj1hbra9rOI8+k=
X-Received: by 2002:a54:4819:: with SMTP id j25mr18392614oij.66.1640736327959;
 Tue, 28 Dec 2021 16:05:27 -0800 (PST)
MIME-Version: 1.0
References: <20211222133428.59977-1-likexu@tencent.com> <CALMp9eRNsKMB6onhc-nhW-aMb14gK1PCtQ_CxOoyZ5RvLHfvEQ@mail.gmail.com>
 <d80f6161-e327-f374-4caf-016de1a77cc3@gmail.com>
In-Reply-To: <d80f6161-e327-f374-4caf-016de1a77cc3@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Dec 2021 16:05:17 -0800
Message-ID: <CALMp9eTy-8CgoV1TJBQ=RON=k8bQ8SYR7xj00qipUEetR4Xofg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU frequency
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 11:11 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> Hi Jim,
>
> On 28/12/2021 2:33 am, Jim Mattson wrote:
> > On Wed, Dec 22, 2021 at 5:34 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> The aperf/mperf are used to report current CPU frequency after 7d5905dc14a.
> >> But guest kernel always reports a fixed vCPU frequency in the /proc/cpuinfo,
> >> which may confuse users especially when turbo is enabled on the host or
> >> when the vCPU has a noisy high power consumption neighbour task.
> >>
> >> Most guests such as Linux will only read accesses to AMPERF msrs, where
> >> we can passthrough registers to the vcpu as the fast-path (a performance win)
> >> and once any write accesses are trapped, the emulation will be switched to
> >> slow-path, which emulates guest APERF/MPERF values based on host values.
> >> In emulation mode, the returned MPERF msr value will be scaled according
> >> to the TSCRatio value.
> >>
> >> As a minimum effort, KVM exposes the AMPERF feature when the host TSC
> >> has CONSTANT and NONSTOP features, to avoid the need for more code
> >> to cover various coner cases coming from host power throttling transitions.
> >>
> >> The slow path code reveals an opportunity to refactor update_vcpu_amperf()
> >> and get_host_amperf() to be more flexible and generic, to cover more
> >> power-related msrs.
> >>
> >> Requested-by: Dongli Cao <caodongli@kingsoft.com>
> >> Requested-by: Li RongQing <lirongqing@baidu.com>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >
> > I am not sure that it is necessary for kvm to get involved in the
> > virtualization of APERF and MPERF at all, and I am highly skeptical of
> > the need for passing through the hardware MSRs to a guest. Due to
>
> The AMPERF is pass-through for read-only guest use cases.
>
> > concerns over potential side-channel exploits a la Platypus
>
> I agree that the enabling of AMPERF features increases the attack surface,
> like any other upstreamed features (SGX), and they're not design flaw, are they?
>
> As we know, KVM doesn't expose sufficient RAPL interface for Platypus. At least
> the vendors has patched Platypus while the cat and mouse game will not end.
>
> User space needs to choose whether to enable features based on the
> guest's level of trust, rather than trying to prevent it from enablement.
>
> > (https://platypusattack.com/), we are planning to provide only low
> > fidelity APERF/MPERF virtualization from userspace, using the
> > userspace MSR exiting mechanism. Of course, we should be able to do
>
> It works for other non time-sensitive MSRs.
>
> We have a long delay to walk the userspace MSR exiting mechanism
> for both APERF msr and MPERF msr, which is almost intolerable for
> frequent access guest reads. IMO, the low fidelity is not what the guest
> user wants and it defeats the motivation for introducing amperf on host.
>
> > that whether or not this change goes in, but I was wondering if you
> > could provide some more details regarding your use case(s).
>
> In addition to the advantages amperf brings in the kernel context
> (e.g. smarter scheduler policies based on different power conditions),
>
> Guest workload analysts are often curious about anomalous benchmark
> scores under predictive CPU isolation guaranteed by service providers,
> and they ask to look at actual vCPU frequencies to determine if the source
> of performance noise is coming from neighboring hardware threads
> particularly AVX or future AMX or other high power consumption neighbors.
>
> This AMPERF data helps the customers to decide whether the back-end pCPU
> is to be multiplexed or exclusive shared, or to upgrade to a faster HW model,
> without being tricked by the guest CPUID.
>
> IMO, this feature will be of value to most performance users. Any other comments?

If it's worth doing, it's worth doing well.

Let me go back and look in detail at the code, now that the question
of whether or not this is worth doing has been answered.

> Thanks,
> Like Xu
