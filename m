Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2229B48AF01
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 14:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiAKN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 08:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiAKN7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 08:59:02 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF10BC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 05:59:01 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id e9so31643984wra.2
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 05:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0S24GbNlH/zMOK0Dq8vzMLE3BUZEfsOBAPd3kCGXLI=;
        b=xJIUuFglseW+loQm20MX0XfMvDv5bNtf6k5I/FwW4t8tvtjIN9Ko5fHkO0aHRyxbqj
         V8eOPXN3uoDJv4Mr69nuTUZOekiSNDrksGA8izGa1Qmqhspbi8mc7jRR1ELddP4+sLty
         PygolyxT5VLR0E0ie+2KsEomPgM68WLk5+H2U054Qfg9Ro6N4oHMkwJmjaf1RNwlI5aL
         FfthQ+9l2w6nKq7Ha8/C5KclTC2Tfud/iK2vNpT/4E1GelkhHoahcbL6V3kFrv6MytyR
         tnc7nYZ2f3fba9+Y2ix6C8g3MuvvBrUcH9n3WmFHLP+YBsWhtWVpCuSyvXYdx2ZrdglE
         yC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0S24GbNlH/zMOK0Dq8vzMLE3BUZEfsOBAPd3kCGXLI=;
        b=UUsrSN82gUAUXMS37WziQGtDAGJWRqah7mIOYhsTO7cwy1uPu4bo8KgrdNax2utfXx
         3RHmObbEa6vI//0nZ63O2LbmHuP06VOt3lg2EnlY7SIz5Hfp0SysMl2R/Yo7111wYeQP
         mQIJPC2SHgHAe8tgbW5mVGuxj8+M9f5fuGNBElWAK5XXZT+vjO4Sbdt9zhgkxLC15grh
         xq3lu/lGADbXRmp8TglAMNxNRct+vBBz0YHngxCHNlNAT7zp+mz4oVUqGGzPfgpLH+SE
         0od1JHoKXgUC7nU+uLhqzaXqjqsqPYHcHKFG3bu17gWR7sCFFTqN5nuq5TvBNjVNNNjm
         HKig==
X-Gm-Message-State: AOAM530oLsj5VlE0D7ujWgaBTD1rSvf9yw8CnaEGOASozyU6H87VuTzK
        5hwwmnrHLSdjXwVuKNbESIznl2fQ2O8cNuA52DvuHA==
X-Google-Smtp-Source: ABdhPJxSa/pjNGlZajE5AGDkqsOOzhaiVdqBzYlyttImUrEV5HxX+Ns0FRy1giAxhN66dwG5IAen+GYN7Aw3khMJMMA=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr4051250wrv.521.1641909540226;
 Tue, 11 Jan 2022 05:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20220107150154.2490308-1-maz@kernel.org> <a3d32f18-dbbb-e462-82ce-722f424707f9@linaro.org>
 <c9a3552aa067ba691055841b5e3fb7b7@kernel.org>
In-Reply-To: <c9a3552aa067ba691055841b5e3fb7b7@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Jan 2022 13:58:49 +0000
Message-ID: <CAFEAcA8L5pH41cQ6srk9-JbMKNjdhCD7YpWcw4P06t83Jp11vw@mail.gmail.com>
Subject: Re: [PATCH v3] hw/arm/virt: KVM: Enable PAuth when supported by the host
To:     Marc Zyngier <maz@kernel.org>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 8 Jan 2022 at 13:42, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2022-01-07 20:23, Richard Henderson wrote:
> > On 1/7/22 7:01 AM, Marc Zyngier wrote:
> >> @@ -1380,17 +1380,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu,
> >> Error **errp)
> >>               return;
> >>           }
> >>   -        /*
> >> -         * KVM does not support modifications to this feature.
> >> -         * We have not registered the cpu properties when KVM
> >> -         * is in use, so the user will not be able to set them.
> >> -         */
> >> -        if (!kvm_enabled()) {
> >> -            arm_cpu_pauth_finalize(cpu, &local_err);
> >> -            if (local_err != NULL) {
> >> +        arm_cpu_pauth_finalize(cpu, &local_err);
> >> +        if (local_err != NULL) {
> >>                   error_propagate(errp, local_err);
> >>                   return;
> >> -            }
> >>           }
> >
> > Indentation is still off -- error + return should be out-dented one
> > level.
> >
>
> Duh. Clearly, my brain can't spot these. Apologies for the extra noise.
>
> > Otherwise,
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>
> Thanks. I'll repost a version shortly, unless someone shouts.

Don't worry about it -- I've applied this to target-arm.next and
fixed the indent there.

-- PMM
