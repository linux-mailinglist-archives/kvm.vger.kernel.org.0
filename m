Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D669529618
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiEQAfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 20:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiEQAfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 20:35:51 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD17DEEE
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:35:50 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id v65so20605668oig.10
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4PVGGuxc9ZyUOJ1tHjoyl2dymltFthy0B+E7Sw+J42M=;
        b=nfqtFXnTGOPZxAFd1Lz+1d12jCgsAih4qDV1EY6Tvbl+0akZYChQ5Edmn9Uy0ZuML2
         /Yr2uYhf+wPUsW+RhlPj0jnrgI6xQnFnDJXSdsS2bB2o2rEq8kT5IQzy30s3KZT90pj3
         UHgi++aGzhoNWQSG7KMtVVGVzZ8lXDP3PxyzHRe/cj2CsiK8ysEKX+N/C/JCofnhP6Zy
         ysHoSuNHqM8uW8oykrmhadP4GJgmD8QVWKo1rTWmFdO3T0RLNLOU8o5Y2if5frE7OzBe
         tqgcEGsK8+XiuMXFj87N0IFHRR1P/0s3glsmvAukolmHIqsHn647aZrbjw9qXweuOLeg
         q85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4PVGGuxc9ZyUOJ1tHjoyl2dymltFthy0B+E7Sw+J42M=;
        b=7Lr5TtO7kmKAfloR8Er3Tv8BsHiAw/RFsgmuPk588y0sUo37l6qyQMKxtgAxRHKWNC
         SZPx3od6dSz+mbv0yPRkHXM3jgYlcfaA0iWrIH2WcV0d6KI6wzz1IK918imfjAyezWjH
         8f5RwOCXnkSQl7uZqW/dfn1TywmoTdDYkIFu5iuEzSiUkVEhPU3QEak7fi+gHWIetEQ9
         aoVxIC7N2ARI5GKbGfjdqT8JVQzfle/fBH4mwrP7ApQYdxTOVlHxf4oJ9psY1Nx0gCiC
         rcx9tZeP/EOGA87mGXP/tjOc+Gkf5TL62GKDPDJyfoY9Hau/Q50jR6+B8gYGGPWsCUSX
         /ptQ==
X-Gm-Message-State: AOAM5336D6hJ6x9kZaL55OAMEFsJfjsHcmxIkzlafNZqHFJycKovQNPR
        i12m7OPTu2a8Yd4bPLLo7gOJuUZngWi7NVRUJBz4cA==
X-Google-Smtp-Source: ABdhPJw5B1NweHHaLVC4lRIhd+qyP/8JLgQyMfz7YK8nShVG08v7sqngNhnkN1GmZyWt//h2whVvG0TuH3ANoPCzPGs=
X-Received: by 2002:a05:6808:2125:b0:326:b51f:bbc2 with SMTP id
 r37-20020a056808212500b00326b51fbbc2mr15101655oiw.13.1652747749600; Mon, 16
 May 2022 17:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20181205191956.31480-1-ehabkost@redhat.com> <66796b4a-f5be-baeb-07ea-db95764e4bab@redhat.com>
In-Reply-To: <66796b4a-f5be-baeb-07ea-db95764e4bab@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 May 2022 17:35:38 -0700
Message-ID: <CALMp9eT2+299s3DE=q8AnDnMXj+H249dzytmHw6EqnRqCaqsVw@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Report STIBP on GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw2@infradead.org>
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

On Fri, Dec 14, 2018 at 2:55 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/12/18 20:19, Eduardo Habkost wrote:
> > Months ago, we have added code to allow direct access to MSR_IA32_SPEC_CTRL
> > to the guest, which makes STIBP available to guests.  This was implemented
> > by commits d28b387fb74d ("KVM/VMX: Allow direct access to
> > MSR_IA32_SPEC_CTRL") and b2ac58f90540 ("KVM/SVM: Allow direct access to
> > MSR_IA32_SPEC_CTRL").
> >
> > However, we never updated GET_SUPPORTED_CPUID to let userspace know that
> > STIBP can be enabled in CPUID.  Fix that by updating
> > kvm_cpuid_8000_0008_ebx_x86_features and kvm_cpuid_7_0_edx_x86_features.
> >
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> > ...
> Queued, thanks.
>
> Paolo


On second thought, I believe this is premature. KVM does not currently
support Intel's STIBP.

From volume 4 of the SDM, "Prevents indirect branch predictions on
*all* logical processors on the core from being controlled by any
sibling logical processor in the same core." (emphasis mine)

In particular, if two virtual HT siblings are running on different
physical cores, and one of them sets IA32_SPEC_CTRL.STIBP, KVM must
intercept the MSR write, track down the sibling vCPU thread, and
ensure that IA32_SPEC_CTRL.STIBP is set on its logical processor.
Moreover, whenever a vCPU thread migrates to a new logical processor,
IA32_SPEC_CTRL.STIBP on the logical processor must be set to the
logical or of the vCPU thread's own IA32_SPEC_CTRL.STIBP value and its
sibling vCPU thread's IA32_SPEC_CTRL.STIBP value. Note that this
implies that IA32_SPEC_CTRL cannot be a pass-through MSR.
