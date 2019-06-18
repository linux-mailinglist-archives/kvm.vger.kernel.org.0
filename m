Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D3849C82
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfFRI7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 04:59:21 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34619 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbfFRI7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 04:59:20 -0400
Received: by mail-ot1-f65.google.com with SMTP id n5so13318388otk.1;
        Tue, 18 Jun 2019 01:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hIYswHQWRvAKNZqbn4aJZ16s+Ip2WBsvtLErDYbrWjo=;
        b=nI+7vDq8KmgYzdN/88QoJEwpLDu7c9wN0Z9oFTjLx3fiKXZGL1MNGSlRw+LXS0+zJD
         Q8kHby70w2ZUmsnYt8v/Oxc6LoDhUUIhgzexW+2+Q73WxbmDaNfl34d7qsd2fCmcWyaY
         64nWptg+ucSZNY+zN4h9CYyv59TMitcrjv8CQJZRQ+nLDT+K/VmmNf8ljzYqA4EM2Vxh
         dkdadBRES7VXSvJHzTIHn2/TAHaEpQ59Ja6wT1J4LBTkSQuR6mWPFe1HfRAyNgVy3nxJ
         vUk9sPmYEqblaU8Pw+wXK6AkqvSPcsKpeVajUFUeMfDVY8D4YQL0Lutr8xwrbJnjobxj
         r7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIYswHQWRvAKNZqbn4aJZ16s+Ip2WBsvtLErDYbrWjo=;
        b=nGDnOFyJGRCn4wlIW1CYybeVjQUNm5Q22qdkD+/piK71fFxi9L/XdnVviOfMuEq5+T
         M+/uxzqDUrMHOOHIOrXeSLa4z0UxbfSerEx1FA79RUzYcdM+zJgrZAAOqqG7tlClc9Vz
         HrykLq34Q9ujXjgMUrMIX9srbm+fx1FbMnxGkb9hFWWcLLSIktNf/srTuQ8AtRDEdyvZ
         ii6uFGHC0YIF/0OuOHxqkPdGO2fipas4qAV0yF0YXxCx8HAiLjFixdrd1POszCJk71m4
         4YNNSRgPcC+9tnQ9KWTL6HD1wY+5KVcvEF9rJ3+pgWOwrBK8uSodouyqvNf4oTrWgDSk
         o59A==
X-Gm-Message-State: APjAAAW2HKl/oen3dll8XW3dnNNcS2FM5N/JoOiEtbF5FqrjkKxorJ0I
        bx4EKw07WybfhmbYrbiOaExshSGcrOVilaoj7hym2w==
X-Google-Smtp-Source: APXvYqzrVcFMt4Rsnpy0uddKn8mLlndrPPAnVmG02HEEf79JtuDS9uaEfXH6YYyvvYr501Pft2FSJ8MgbA9s9tt/szo=
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr45214796oto.337.1560848360040;
 Tue, 18 Jun 2019 01:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 Jun 2019 17:00:36 +0800
Message-ID: <CANRm+CwfXViF34eLma5ZnqjT96Sq=XehpBiTZTj1TfJnkevVMA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] KVM: Yield to IPI target if necessary
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, :)
On Tue, 11 Jun 2019 at 20:23, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> yield if any of the IPI target vCPUs was preempted. 17% performance
> increasement of ebizzy benchmark can be observed in an over-subscribe
> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> IPI-many since call-function is not easy to be trigged by userspace
> workload).
>
> v3 -> v4:
>  * check map->phys_map[dest_id]
>  * more cleaner kvm_sched_yield()
>
> v2 -> v3:
>  * add bounds-check on dest_id
>
> v1 -> v2:
>  * check map is not NULL
>  * check map->phys_map[dest_id] is not NULL
>  * make kvm_sched_yield static
>  * change dest_id to unsinged long
>
> Wanpeng Li (3):
>   KVM: X86: Yield to IPI target if necessary
>   KVM: X86: Implement PV sched yield hypercall
>   KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
>
>  Documentation/virtual/kvm/cpuid.txt      |  4 ++++
>  Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h     |  1 +
>  arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
>  arch/x86/kvm/cpuid.c                     |  3 ++-
>  arch/x86/kvm/x86.c                       | 21 +++++++++++++++++++++
>  include/uapi/linux/kvm_para.h            |  1 +
>  7 files changed, 61 insertions(+), 1 deletion(-)
>
> --
> 2.7.4
>
