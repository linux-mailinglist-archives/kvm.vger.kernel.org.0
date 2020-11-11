Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CD82AE55D
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgKKBNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 20:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732209AbgKKBNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 20:13:35 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155F2C0613D1
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 17:13:33 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e17so467334ili.5
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 17:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8aqAhNt9hNU+Zv61azJhzWGFkODldV4KV7123K3jE6E=;
        b=tkabmCrfLHtxowF7PEJ/2/ur0EPEwniM1qthOJjQLfFvAi3I59Ueha9TjR3SS5bKk0
         zSOMs4QoS7Xd5UR9ncwCuFc4y/Alcb+m+LYTc3ceORZT2tEAeW1hYOXQZ6i/90VYfDt8
         MrAngzz/Ybw3wBjRbgiwJvqUMJpASRepIxAol/TvuUi+R4A5io6xpNq21yzOfAJPKzhv
         mObTxm5DESLJeXapUxXrarTcRhfYSofLFurX6HDaJTVV81DOitSMGoF16jB3DSt0RFGd
         XFy7HxT5ZAFdeMWe8r4Cg/Pb0FM/Okj9Gg1tbAIkBXzeFBq2GMAoSlI0UVBqrxAHMdcD
         vN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8aqAhNt9hNU+Zv61azJhzWGFkODldV4KV7123K3jE6E=;
        b=Wd7E2fPn/rMwePrwS9vHc9pVHTmBfDo7EVPgg98tYYNR81IO182a+UQBcAhZaHFZoN
         /CSMHqoFx+kfnaGbOsqAbmHbJ4PUOUZksfXVgeOhj1CWSYrMO7cpcDgM8GgThRsq8W+H
         Nh8ORJYWLSzT4gYw40oiqoT6FbEmBEFFV09jm9mxo8dW3JIB7vMlhrpdraqKS8wj6i0r
         Nkf5dPbIBedwIGyOCTDMJSm4cHQsxbMKWw0IH9ghzK3ansXzi98jPRHGw+Z+qa9xDTxj
         dnPxO7cuTZkvKDrRTHvIyusR7Qxswm2Q+ipept0nGeHne/HGcMveu9hf9t4tS+b07ziZ
         SFBg==
X-Gm-Message-State: AOAM530WsYioUt0SbxCu7hw1N1BHpGm2Xh+JAIfxwOsgAmNIqYQGesL2
        E3cM3C/xjWQTUxf6+fBIDeo2L445aqxSpSHzXl/jXA==
X-Google-Smtp-Source: ABdhPJyYFFqXz7LHNUxqt/obO4IZceZuCZhBIj9ty6VWJP8C6nUwc/dkvtKZieZftjYU2iDBveS7p3RJ3Ohfo9Qwdu4=
X-Received: by 2002:a92:d5c4:: with SMTP id d4mr15001227ilq.154.1605057212072;
 Tue, 10 Nov 2020 17:13:32 -0800 (PST)
MIME-Version: 1.0
References: <20201110162344.152663d5.zkaspar82@gmail.com>
In-Reply-To: <20201110162344.152663d5.zkaspar82@gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 10 Nov 2020 17:13:21 -0800
Message-ID: <CANgfPd-gaDhmwPm5CC=cAFn8mBczbUjs7u3KucAGdKmU81Vbeg@mail.gmail.com>
Subject: Re: Unable to start VM with 5.10-rc3
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zdenek,

That crash is most likely the result of a missing check for an invalid
root HPA or NULL shadow page in is_tdp_mmu_root, which could have
prevented the NULL pointer dereference.
However, I'm not sure how a vCPU got to that point in the page fault
handler with a bad EPT root page.

I see VMX in your list of flags, is your machine 64 bit with EPT or
some other configuration?

I'm surprised you are finding your machine unable to boot for
bisecting. Do you know if it's crashing in the same spot or somewhere
else? I wouldn't expect the KVM page fault handler to run as part of
boot.

I will send out a patch first thing tomorrow morning (PST) to WARN
instead of crashing with a NULL pointer dereference. Are you able to
reproduce the issue with any KVM selftest?

Ben


On Tue, Nov 10, 2020 at 7:24 AM Zdenek Kaspar <zkaspar82@gmail.com> wrote:
>
> Hi,
>
> attached file is result from today's linux-master (with fixes
> for 5.10-rc4) when I try to start VM on older machine:
>
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mc=
a cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx lm=
 constant_tsc arch_perfmon pebs bts rep_good nopl cpuid aperfmperf pni dtes=
64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm pti tpr_shadow d=
therm
> vmx flags       : tsc_offset vtpr
>
> I did quick check with 5.9 (distro kernel) and it works,
> but VM performance seems extremely impacted. 5.8 works fine.
>
> Back to 5.10 issue: it's problematic since 5.10-rc1 and I have no luck
> with bisecting (machine doesn't boot).
>
> TIA, Z.
