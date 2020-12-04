Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E002CF43D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgLDSmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgLDSmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:42:09 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA60FC0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 10:41:28 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id ck29so6856090edb.8
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 10:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fpe0QzFR+pipwwlQ6a2MzDyp0bYD7DIdzQkuuRLNsTo=;
        b=N1pWv4MVTu8h54c3GOs5Ue8aeY0is8BFjfmOMVaj0XxCqhP/03svogCo1dlFWT63Eh
         A/rDBsUlceBfglZkzb0UDw3oaUnu8NMJ0KwRzihvA93AMxzYDYmejDM5IozeJKtEvICW
         4AS2VR4VaWa5kMmpNSJgBndJQDyANHJuQFll+uqcq+nHn9V0tG6dhm8BGNofHDaz4kUC
         7hPXvKaCtfvVorLMoY/CUnGi97CynEeSKpQDbux6DxSCoN2hA1MLAv56Pkx4rcmFkunL
         qKzjKZemdJ4CeXh2fseFX/E4pvjtaRkM28xypluQoaDZhzEZRObj0nun1tT2Mr8m+r+7
         uxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fpe0QzFR+pipwwlQ6a2MzDyp0bYD7DIdzQkuuRLNsTo=;
        b=tpvYIzh5I4ZNexdzyYAkUPdQQ6ZN/r1zDa1tGX7gwWGR2GSArd2GeF6/Tpb0lqXEXh
         Kkp3MmnL70zBZbqDx84NHnaV1HhRneH6NADtSLGpQ44BG/Lbc1prfL15BeKxMYVpAs/V
         F9/QEsLC9nw0DC6nsJDbxmAtMM4wEDYlH9ODtRmSUsjsfFAHMifNpTlyo8887SYzML3I
         x//5Y381D6yuNKv92ompr9Q5qKWUOAnzsHG+iZqGg4s4Y1/GjmM79dCj/sTfqD3mNceA
         1vbddoiOczm8mwhtkGjYGLLPBtRqG4S3HcKqVKEhNaD9KO7fcumi7Lb0dLlRzcx3nt/y
         U4yw==
X-Gm-Message-State: AOAM531SLml1Xfo/vZnobyLO9Tl/M08BiMndZeoQjuIi94zhK5pHVlG3
        hj94k5TvUkkUxNLuWMMoImquIKuudGD7RX5E49ddqg==
X-Google-Smtp-Source: ABdhPJz+JmjtP/rNpS01qPn31jBKjhcmz0scPpZbGA0wOOkM/QXJpxUIqwxfVRzPugL1FZDgtzhWYyvOBl24MWLcZ0M=
X-Received: by 2002:a50:f089:: with SMTP id v9mr9080510edl.353.1607107287403;
 Fri, 04 Dec 2020 10:41:27 -0800 (PST)
MIME-Version: 1.0
References: <X8pocPZzn6C5rtSC@google.com> <20201204180645.1228-1-Ashish.Kalra@amd.com>
In-Reply-To: <20201204180645.1228-1-Ashish.Kalra@amd.com>
From:   Sean Christopherson <seanjc@google.com>
Date:   Fri, 4 Dec 2020 10:41:15 -0800
Message-ID: <CAMS+r+XBhFHnXrepzMq+hkaP3yHOUELjyc65JQipKCN+7zubVw@mail.gmail.com>
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>, bp@suse.de,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        venu.busireddy@oracle.com, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 4, 2020 at 10:07 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> Yes i will post a fresh version of the live migration patches.
>
> Also, can you please check your email settings, we are only able to see your response on the
> mailing list but we are not getting your direct responses.

Hrm, as in you don't get the email?

Is this email any different?  Sending via gmail instead of mutt...
