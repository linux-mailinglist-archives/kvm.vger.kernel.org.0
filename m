Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54A05465DB
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245415AbiFJLiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 07:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345060AbiFJLhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 07:37:33 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53D37893F
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 04:36:53 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id m25so25962168lji.11
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 04:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2bt8jTYVrowhc1gg8uINAlbLKdSaOnKBxI1tejzJnw0=;
        b=VytV+NMseeOv5ay6lpQ90w3nH/J9TkSL7TDekYgqNJ6A5QUx0JjdEV0LQWDwhoNvvm
         Rz8hppK3LV/Zx32rXRUnaGgGsmX5wt3+Wmt5lTiuSxzOy65Y0u8rI5JHIib+7RFuxjoR
         K4FMqtzyophRWwfQGCU0kfhqOEQ94XiFDzl6um4dsmiYHUWa3LfOkaMwdF1Qku7lIBoX
         +J4huc80z4RkwDz+5pqpvmsCfTSDrhJkZa4kFfpu1icagXacVx0PxFd+2xgKHpaVRf2K
         OAx2EknOTp0kRe54ep30g5Aq3K5hi4ofIym1NY+KaQ9x9OaGRMBB+UILcxymGGjOJClP
         HyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2bt8jTYVrowhc1gg8uINAlbLKdSaOnKBxI1tejzJnw0=;
        b=UrN2TKxucHqt4EYLi42uNFryVQV3XBUbD/BMkFyw4NZAptTAQGAnoAzYuQN30bP9W4
         X20PmxfamGnRXNeiJhj8mi7TfRicmNmCkTcv1BDAw1AQAcbePZ7bK2sKw7Mb7SpOq/dP
         cfSjkzfVQVskc3mqeNpZMP9+Zb6MnpCVXN2Ao1SqfMoXGKbUn9HZZsJzk6p/lX/eGBeZ
         ch/YwHc290FeG+2M0UPY6ynZLib22QBrdTqkTiVgAdZuowwh6vQWSiadbINkwNdtZ2N4
         qmfRLLdmf5kHYYTyfCdMgYFgHX41KIJkVctoBnLVs8XZ0TUZVDGs5l/mn4wwp078AF2Y
         aREw==
X-Gm-Message-State: AOAM530/k1gMBDErxGKObXYFWIb59eABKBhqceZ9uAGGEm8+UmISF90+
        kvallrlSsQDi/VhQijw5zNHhMDz/JIM/4MyZcCvJNg==
X-Google-Smtp-Source: ABdhPJz8nMlzBjn3iuzofJua8K4CiElzoan8JfpHCRGcxYs+YT4rOc7inWwuPW0xOg+L4p23ZR9tOj3oZXYetl1y8Z0=
X-Received: by 2002:a2e:9a82:0:b0:255:77fd:1c2c with SMTP id
 p2-20020a2e9a82000000b0025577fd1c2cmr21978710lji.357.1654861012161; Fri, 10
 Jun 2022 04:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com>
In-Reply-To: <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Fri, 10 Jun 2022 13:36:41 +0200
Message-ID: <CAH76GKPo6VL33tBaZyszL8wvjpzJ7hjOg3o1JddaEnuGbwk=dQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle state
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

czw., 9 cze 2022 o 16:27 Dave Hansen <dave.hansen@intel.com> napisa=C5=82(a=
):
>
> On 6/9/22 04:03, Grzegorz Jaszczyk wrote:
> > Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
> > Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
> > Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
> > Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
> > Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
> > Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > ---
> >  Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
> >  arch/x86/kvm/x86.c                        | 3 +++
> >  drivers/acpi/x86/s2idle.c                 | 8 ++++++++
> >  include/linux/suspend.h                   | 1 +
> >  include/uapi/linux/kvm_para.h             | 1 +
> >  kernel/power/suspend.c                    | 4 ++++
> >  6 files changed, 24 insertions(+)
>
> What's the deal with these emails?
>
>         zide.chen@intel.corp-partner.google.com
>
> I see a smattering of those in the git logs, but never for Intel folks.

I've kept emails as they were in the original patch and I do not think
I should change them. This is what Zide and Peter originally used.

>
> I'll also say that I'm a bit suspicious of a patch that includes 5
> authors for 24 lines of code.  Did it really take five of you to write
> 24 lines of code?

This patch was built iteratively: original patch comes from Zide and
Peter, I've squashed it with Tomasz later changes and reworked by
myself for upstream. I didn't want to take credentials from any of the
above so ended up with Zide as an author and 3 co-developers. Please
let me know if that's an issue.

Best regards,
Grzegorz
