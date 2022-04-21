Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214D650A7AB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391115AbiDUSFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391131AbiDUSFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:05:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623E64B1E1
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:02:22 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h11so6733189ljb.2
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ak6QqPmm4AQbpNhOQu87q9LEr9+mQ3asTsa/QbWlBQU=;
        b=ootSWzXFAwsBY7jD1xTnFCZHZtZEjwkBUZp8yzJvhEwIf1usqNgy3MW3YXnTFyInRl
         pgFLlTuvlZwFwfmwQMvQVVzOIV/9rUmprEtVY+6MgcilOQPIpyMbYES7Jyq/LVZSNAB0
         ErOb4YXRYVh3GI2aGEtVAHn66KBvwvGG2gVW0TJTDtKDvSWEtgZHwIw7OI78Aoj8k6qe
         00U0aoQKCBcIg33r0tKrH5dWA7v702Pdv70LF5HkPDjVolF2ANqHBBXVr4Q/t+4nIXsw
         zdcH5nwNiRcAYGOqPjB7Ne1CM92SzA+I+SqtgHgl+1vhFj2AsLfvCD39bkfyOuHZbrUZ
         uBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ak6QqPmm4AQbpNhOQu87q9LEr9+mQ3asTsa/QbWlBQU=;
        b=7dREJwKV0G0mezCjHGOJV96+CPpN0kn+ItH92WMW30nWNq+0g57wWuveSlFlUDh0r1
         Va30i/Z+bARnEzcRX1E0FMSzHk2W1Ijv4+mYLXPdc0xNgN9vVwHpfHKZU/cE0v8VQw70
         ZWdZ3BqM5Kr0eUcU6+Rwn2QeGsIqAP8Vdl5HEc9IIBet76GlDQEvciS/qRCwptPjroGS
         pzW6fTMi9HQNpmweI5kvUpXbNBVXQ+Ni6IOywyg3/5+KVRM4Aa1474+mP6ir8E8ToyDF
         6POEapLifBuhsSaHABUGwALN2lAi/SQHYFZV02Ty27qbM3Dw/3WHIH6XVbkG8S5SMq8H
         +rag==
X-Gm-Message-State: AOAM531VqCA5SW3wai646LDia3u6D89kbAbhDxA/IwTJGA4J8eu+eOR4
        iAPCBp6dy1W70dXN36D5ErrFfoEm8PZzcwReX0v+gg==
X-Google-Smtp-Source: ABdhPJzUI1h3NotonH2SjnObM5v+rR0GgHD0HFAj+ft7o7CvhswV6yU9RmjDy5j1AbIBljPX4izK26oRhqyVO7/cvF0=
X-Received: by 2002:a2e:bf27:0:b0:246:7ed6:33b0 with SMTP id
 c39-20020a2ebf27000000b002467ed633b0mr513433ljr.167.1650564140447; Thu, 21
 Apr 2022 11:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220421165137.306101-1-posk@google.com> <b1b04160-1604-8281-4c82-09b1f84ba86c@redhat.com>
In-Reply-To: <b1b04160-1604-8281-4c82-09b1f84ba86c@redhat.com>
From:   Peter Oskolkov <posk@google.com>
Date:   Thu, 21 Apr 2022 11:02:09 -0700
Message-ID: <CAPNVh5cQ6HhVqfuM7rhyK5RH6YYczkjAAgMwn7qHt8cbJneG_g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: add HC_VMM_CUSTOM hypercall
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Peter Oskolkov <posk@posk.io>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 10:14 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/21/22 18:51, Peter Oskolkov wrote:
> > Allow kvm-based VMMs to request KVM to pass a custom vmcall
> > from the guest to the VMM in the host.
> >
> > Quite often, operating systems research projects and/or specialized
> > paravirtualized workloads would benefit from a extra-low-overhead,
> > extra-low-latency guest-host communication channel.
>
> You can use a memory page and an I/O port.  It should be as fast as a
> hypercall.  You can even change it to use ioeventfd if an asynchronous
> channel is enough, and then it's going to be less than 1 us latency.

Thank you for the suggestion. Let me try that.

Thanks,
Peter

[...]
