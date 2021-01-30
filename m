Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858463097B2
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhA3Szc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 13:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhA3Sza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 13:55:30 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88230C061573
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 10:54:49 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ke15so17943640ejc.12
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 10:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oXtPVE2IbtRRYCpvUtiVFQgbW5mh8YjoQMknIuSaeAc=;
        b=b1rE5reO+/ylwUvWHDQ6gFBD1ZMLvjmBVj7z6iHZEtOIrt85KafbIsrJiUTFMjgkMv
         EO239Ch7/2vVc0sITyLPdJw79Y+DCrMrThTp86B/tp4yto0D8J7B2oagD+F+VrSA1ciu
         I5poKTCsVbT2lrqibfeCp+VtxN5qYq2t6UgtTQzNfWSNTueccgRu9w7NSq60zrXpqF00
         E+yG6zYuZ31QrSrfccmyDg4uryatxiI+pF7o1OOGRbojYu5vd9czNJSN+4ROCzG5yfv6
         OGKU/10X2cC0Qells3y39Jm9YWDAtsEjcdG3fj0bTfhFF3WPV5yrPTu2+mgt4gwFPh4s
         n7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oXtPVE2IbtRRYCpvUtiVFQgbW5mh8YjoQMknIuSaeAc=;
        b=SM2ifTe/Y4J/27WKMu0+dgt/uOHbpZeLgo2jAEG+dm9+MBXBHjb6pfzPrF7fKYbz6i
         zYosBfrL1JreSzlB7Bfmf5MC3qYWrdgvwpi7psfXLJ3Gin9Kqx1ZZWly/eOBG/vATeFA
         Qvmpr6pYlB8lq6kqDrI9KkXC+TGRe7iis8ewRX0qCjU6+kW8BrI+DGf5EiIE+KQlEjgl
         FHAsYsk2H0YtoqqBmogywSpFrk+drR++TPr6ONq8xiU6vMqx4p4i4sqPTa/FuQQ9+0Hl
         70xBcACIsGY8/YY7Mu/q7mbcga6Y7lKKfOQ2M0jrWJna9xDytmp7MvT254LqgHkmjY1Z
         5dWg==
X-Gm-Message-State: AOAM533buazKmhe6Rb+izyeKIuyRJ5K7Pub4F2iyhFVqSaCLyW8iEPuu
        ErtG3q+KeyJwWqHY+NtoMR23nrxk1Y8ViK+/TFl8nA==
X-Google-Smtp-Source: ABdhPJwo7gvPhPJtvirAJL3BBx+tVDxaTzL7yXGFz6XeyRrStm+3laD7Nmfgez99qF2/kAXH8/BrkdUPl35U/QOjqxg=
X-Received: by 2002:a17:906:b215:: with SMTP id p21mr10088000ejz.407.1612032888158;
 Sat, 30 Jan 2021 10:54:48 -0800 (PST)
MIME-Version: 1.0
References: <20210130015227.4071332-1-f4bug@amsat.org> <20210130015227.4071332-4-f4bug@amsat.org>
 <CAFEAcA8UCFghGDb4oMujek_W_wsyYz+duiQ-d8JyN09NYoff-g@mail.gmail.com> <2871f7db-fe0a-51d6-312d-6d05ffa281a3@amsat.org>
In-Reply-To: <2871f7db-fe0a-51d6-312d-6d05ffa281a3@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sat, 30 Jan 2021 18:54:37 +0000
Message-ID: <CAFEAcA-W1tcRREaPTfMw98cNsHs7JHk4gjaJWaJNLpxZoVnKaw@mail.gmail.com>
Subject: Re: [PATCH v5 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Fam Zheng <fam@euphon.net>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        qemu-arm <qemu-arm@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 at 18:36, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>=
 wrote:
>
> Hi Peter,
>
> On 1/30/21 4:37 PM, Peter Maydell wrote:
> > On Sat, 30 Jan 2021 at 01:52, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.=
org> wrote:
> >>
> >> KVM requires a cpu based on (at least) the ARMv7 architecture.
> >
> > These days it requires ARMv8, because we dropped 32-bit host
> > support, and all 64-bit host CPUs are v8.
>
> Oh, this comment is about the target, to justify it is pointless to
> include pre-v7 target cpus/machines in a KVM-only binary.
>
> I'll update as:
>
> "KVM requires the target cpu based on (at least) the ARMv7
> architecture."

KVM requires the target CPU to be at least ARMv8, because
we only support the "host" cpu type, and all KVM host CPUs
are v8, which means you can't pass a v7 CPU as the target CPU.
(This used to not be true when we still supported running
KVM on a v7 CPU like the Cortex-A15, in which case you could
pass it to the guest.)

thanks
-- PMM
