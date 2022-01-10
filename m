Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1B489E8B
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 18:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbiAJRla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 12:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238382AbiAJRl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 12:41:29 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453F6C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:41:29 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r131so19659029oig.1
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5U6zYiu8WdU+2/OHOZjLKW+EUazL53zgXfam3/JNFaI=;
        b=jzxSv3mH59n66PWmFNJxlzLCUdi7BjxYCpuzbiiGkIxP25h8xDjQEeTIGO8NBUq7A4
         Mwc8W6gznCxS6tV9wxQ6Dqp5JM/qzlXFnBKf3wZVi9XwOKMOTttfH3B1W/73FXe758Mk
         UZunBKxHdEMJE+eULpMipORGkH4trtehjNOC9LhQcay2P95Yij6p9NY42UJZaRthN/hP
         8xmam50Y706VIPyEj+Ef4K4po8+UVufuUn8g92Wl+8cg1oSry7NSprifnHhzmaPVsfjz
         OEqO/HiOB0J/mZ/ykru4EVTV37kYLVeOo4sVDKsgYxHOM+jy049q6e7+WJlQK1vXbqHN
         fTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5U6zYiu8WdU+2/OHOZjLKW+EUazL53zgXfam3/JNFaI=;
        b=Xh7hy0hxMcN3bi4KG+u743zEtIIU1F88LRaTKiUpcWWF71f9nZ6s21aFYkzRE+6acV
         9s0IssF4ZcLPHNqE0TpUhFgiWfsH0Iq+3EPeC4foVLw7V4ucvLV6v+WnoIhe6s0ho48Z
         /jk1HFzWdm2T0Oo/Ntkh4NBYvN+Dkm/aext95STiKWaIaNcyNwVVYeuAaJjz5IDqU1Ny
         P8DZdqs3IotsS76iyaRRjD3823sMw8eq8K18rhfpeX/u+iFLGgNQuXdBxhtHpAMT4N4/
         83GZ79GbnOs/PnmlITevibcFs/Wq+h9hqCWMCPGwIeQ6R7Vf6UKTfr5km1OdLiGvzt9N
         fODA==
X-Gm-Message-State: AOAM5300Fhdc5elmSDsKO9TwgfdFePfspNPRvji12/dEonyTAbqHs7Kk
        DnIBrq3qPVdFdyaH0S09FQmA8wt8JMZLUOCikr6sgQ==
X-Google-Smtp-Source: ABdhPJzjv8ez/bqvzHW8a6tCCPFVi9ikAqu4XZfZRmwhIk29uunKHyLWgoQQ2BLXupNcSVrU04A9cWp7HV5anAW0GMA=
X-Received: by 2002:a05:6808:ddd:: with SMTP id g29mr15256166oic.66.1641836488263;
 Mon, 10 Jan 2022 09:41:28 -0800 (PST)
MIME-Version: 1.0
References: <Ydw52mvd3SQH/5CY@movementarian.org>
In-Reply-To: <Ydw52mvd3SQH/5CY@movementarian.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Jan 2022 09:41:17 -0800
Message-ID: <CALMp9eROOAF5fMZge2aPj2BFiMTnYJJJtKBj9ZMERpFs0v3anQ@mail.gmail.com>
Subject: Re: X86_FEATURE_AMD_IBRS getting set for Intel guests
To:     John Levon <levon@movementarian.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 6:20 AM John Levon <levon@movementarian.org> wrote:
>
>
> ```
> arch/x86/kernel/cpu/common.c:
>
>  863         /*
>  864          * The Intel SPEC_CTRL CPUID bit implies IBRS and IBPB support,
>  865          * and they also have a different bit for STIBP support. Also,
>  866          * a hypervisor might have set the individual AMD bits even on
>  867          * Intel CPUs, for finer-grained selection of what's available.
>  868          */
>  869         if (cpu_has(c, X86_FEATURE_SPEC_CTRL)) {
>  870                 set_cpu_cap(c, X86_FEATURE_IBRS);
>  871                 set_cpu_cap(c, X86_FEATURE_IBPB);
>  872                 set_cpu_cap(c, X86_FEATURE_MSR_SPEC_CTRL);
>  873         }
>
> arch/x86/kvm/cpuid.c:
>
>  550         /*
>  551          * AMD has separate bits for each SPEC_CTRL bit.
>  552          * arch/x86/kernel/cpu/bugs.c is kind enough to
>  553          * record that in cpufeatures so use them.
>  554          */
>  555         if (boot_cpu_has(X86_FEATURE_IBPB))
>  556                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
>  557         if (boot_cpu_has(X86_FEATURE_IBRS))
>  558                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
> ```
>
> As a result, we're setting AMD-specific bits in the relevant CPUID leaf. They're
> reserved, but it appears, somewhat unfortunately, that libvirt happily reports
> them regardless of vendor - with the knock-on effect that anything using `virsh
> capabilities` to decide which flags to pass to qemu inside the guest VM
> breaks[1].
>
> Curious if other people have hit this, and if there's specific reason why we're
> setting AMD-specific flags on Intel like this.
See the discussion at
https://patchwork.kernel.org/project/kvm/patch/1565854883-27019-2-git-send-email-pbonzini@redhat.com/.
