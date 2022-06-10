Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47295546696
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 14:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348715AbiFJM0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 08:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245330AbiFJM0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 08:26:41 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9FA2D252E
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 05:26:39 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d13so6998189plh.13
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 05:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JQd3cZZglBGuv+koPRhcabLewHLT00jyRGFi+QsDi+s=;
        b=j4p+Wn5VFiG1u8/FOoebn+HCQVFrBmjRKQ4DgRdq39k0j7rFQHxmSm2A6/OyAIeoLD
         ACC6ItbMasygaaHlolFNFGeS6r2KzwoFZpRdROqghoT7AUtSnQwtrxeSWxMAb9xn3/mC
         fpXb9WWCHwD7Nesl2Jve9oZroDP33S4p6jNlavWmbxzAPguGrAL5Qq93KAlHLY1QxbjX
         aKb10839GkMx0Fkx2t7UN5LpcwD21GWhFITvThcWMEYTpRCpqYHW81V22M8IJBp7dCES
         AKf9lbw5GV8KLQdW4vD4pr7JF1mbM26xNJvN1kXn3x8uF31tGs4qsqd7EQtjoVeNcYc4
         H32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JQd3cZZglBGuv+koPRhcabLewHLT00jyRGFi+QsDi+s=;
        b=ZEWeCeHkOlvx7xRIliFd3YGpk8CjzfNMIo2/jMPF5VhQpiMX153YNZiyjy2QvXvhMY
         Phl4DJ3m6L3T29cAOZa3T1nIlmm9udEziZpWdswlLN+AuyqTboXr0eFMzJI3Hu6AnwvW
         WJpQ2wcp674R1idEeNm31kCH9/R9sRcMd+7Qm91hiWYvFCvkpIvHDARheQ8P0O0kYFkT
         5V6RN4xYj/On1l7cHTk269sHxZbU/U3NX6F2kh6xwFzu180F/IgHZmdm6KlQ5EusGmxO
         dR2pbxUY6pC7qoladIOSwj+6bkymih0K9zApf/UzcB53tdJgo8/9+XBGee5gAepb1bjK
         YHVw==
X-Gm-Message-State: AOAM5333pkCiwKaiX85HIm2KQftmj+b2pMlA0YNJcpjW5haT+2N5S/hc
        v8ujxT5ie97cyw+d+0PD4SuNWKtktmctFNOKwB6taw==
X-Google-Smtp-Source: ABdhPJyI9XVeJog1tDRqARKViAnhr2jYHe7tzCoLd5OlCRiC8TcP67f8q9Pd04BcpPjCWInDE8Y5Cv08WUeUZ68ySyg=
X-Received: by 2002:a17:903:2303:b0:166:313f:a85f with SMTP id
 d3-20020a170903230300b00166313fa85fmr45260497plh.57.1654863998845; Fri, 10
 Jun 2022 05:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <YqIJ8HtdqnoVzfQD@google.com>
In-Reply-To: <YqIJ8HtdqnoVzfQD@google.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Fri, 10 Jun 2022 14:26:27 +0200
Message-ID: <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle state
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
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
        <linux-pm@vger.kernel.org>, dbehr@google.com, dtor@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

czw., 9 cze 2022 o 16:55 Sean Christopherson <seanjc@google.com> napisa=C5=
=82(a):
>
> On Thu, Jun 09, 2022, Grzegorz Jaszczyk wrote:
> > +9. KVM_HC_SYSTEM_S2IDLE
> > +------------------------
> > +
> > +:Architecture: x86
> > +:Status: active
> > +:Purpose: Notify the hypervisor that the guest is entering s2idle stat=
e.
>
> What about exiting s2idle?  E.g.
>
>   1. VM0 enters s2idle
>   2. host notes that VM0 is in s2idle
>   3. VM0 exits s2idle
>   4. host still thinks VM0 is in s2idle
>   5. VM1 enters s2idle
>   6. host thinks all VMs are in s2idle, suspends the system

I think that this problem couldn't be solved by adding notification
about exiting s2idle. Please consider (even after simplifying your
example to one VM):
1. VM0 enters s2idle
2. host notes about VM0 is in s2idle
3. host continues with system suspension but in the meantime VM0 exits
s2idle and sends notification but it is already too late (VM could not
even send notification on time).

Above could be actually prevented if the VMM had control over the
guest resumption. E.g. after VMM receives notification about guest
entering s2idle state, it would park the vCPU actually preventing it
from exiting s2idle without VMM intervention.

>
> > +static void s2idle_hypervisor_notify(void)
> > +{
> > +     if (static_cpu_has(X86_FEATURE_HYPERVISOR))
> > +             kvm_hypercall0(KVM_HC_SYSTEM_S2IDLE);
>
> Checking the HYPERVISOR flag is not remotely sufficient.  The hypervisor =
may not
> be KVM, and if it is KVM, it may be an older version of KVM that doesn't =
support
> the hypercall.  The latter scenario won't be fatal unless KVM has been mo=
dified,
> but blindly doing a hypercall for a different hypervisor could have disas=
trous
> results, e.g. the registers ABIs are different, so the above will make a =
random
> request depending on what is in other GPRs.

Good point: we've actually thought about not confusing/breaking VMMs
so I've introduced KVM_CAP_X86_SYSTEM_S2IDLE VM capability in the
second patch, but not breaking different hypervisors is another story.
Would hiding it under new 's2idle_notify_kvm' module parameter work
for upstream?:

+static bool s2idle_notify_kvm __read_mostly;
+module_param(s2idle_notify_kvm, bool, 0644);
+MODULE_PARM_DESC(s2idle_notify_kvm, "Notify hypervisor about guest
entering s2idle state");
+
..
+static void s2idle_hypervisor_notify(void)
+{
+       if (static_cpu_has(X86_FEATURE_HYPERVISOR) &&
s2idle_notify_kvm)
+               kvm_hypercall0(KVM_HC_SYSTEM_S2IDLE);
+}
+

>
> The bigger question is, why is KVM involved at all?  KVM is just a dumb p=
ipe out
> to userspace, and not a very good one at that.  There are multiple well e=
stablished
> ways to communicate with the VMM without custom hypercalls.

Could you please kindly advise about the recommended way of
communication with VMM, taking into account that we want to send this
notification just before entering s2idle state (please see also answer
to next comment), which is at a very late stage of the suspend process
with a lot of functionality already suspended?

>
>
> I bet if you're clever this can even be done without any guest changes, e=
.g. I
> gotta imagine acpi_sleep_run_lps0_dsm() triggers MMIO/PIO with the right =
ACPI
> configuration.

The problem is that between acpi_sleep_run_lps0_dsm and the place
where we introduced hypercall there are several places where we can
actually cancel and not enter the suspend state. So trapping on
acpi_sleep_run_lps0_dsm which triggers MMIO/PIO would be premature.

The other reason for doing it in this place is the fact that
s2idle_enter is called from an infinite loop inside s2idle_loop, which
could be interrupted by e.g. ACPI EC GPE (not aim for waking-up the
system) so s2idle_ops->wake() would return false and s2idle_enter will
be triggered again. In this case we would want to get notification
about guests actually entering s2idle state again, which wouldn't be
possible if we would rely on acpi_sleep_run_lps0_dsm.

Best regards,
Grzegorz
