Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31DA7CA841
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjJPMmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbjJPMmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:42:43 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B94F2;
        Mon, 16 Oct 2023 05:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697460160; x=1728996160;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=AX2dGxHO00To3yTFYpB06Q546FFoBTZw+b6c2hmiXeg=;
  b=ialDdEc6l2fCDPDkn0emK1a66EqgvCZHCJlnY+/orVjq1m4LDL4No+Ej
   dkVvfgn83tSq7Ps1vK4oRcTHd09Ky3entLMvRzaoT5B0aYrSPz3UUiedW
   Siygv2rTpyxhQPTMBQVj2VA6TmSBk0/MR6T+iGxYvgMGDtebOKlhyL4/7
   4=;
X-IronPort-AV: E=Sophos;i="6.03,229,1694736000"; 
   d="scan'208";a="245801188"
Subject: Re: [PATCH] KVM: x86: hyper-v: Don't auto-enable stimer during
 deserialization
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 12:42:37 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 75AF040D4A;
        Mon, 16 Oct 2023 12:42:36 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:31351]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.162:2525] with esmtp (Farcaster)
 id 8de00d02-2952-4321-91ae-556badb48840; Mon, 16 Oct 2023 12:42:35 +0000 (UTC)
X-Farcaster-Flow-ID: 8de00d02-2952-4321-91ae-556badb48840
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 16 Oct 2023 12:42:35 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Mon, 16 Oct
 2023 12:42:31 +0000
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 16 Oct 2023 12:42:28 +0000
Message-ID: <CW9VEIPFLJJA.3OI6RJQVQU7ZN@amazon.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <hpa@zytor.com>, <graf@amazon.de>,
        <rkagan@amazon.de>, <linux-kernel@vger.kernel.org>
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231016095217.37574-1-nsaenz@amazon.com>
 <87sf6a9335.fsf@redhat.com>
In-Reply-To: <87sf6a9335.fsf@redhat.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On Mon Oct 16, 2023 at 12:14 PM UTC, Vitaly Kuznetsov wrote:
> Nicolas Saenz Julienne <nsaenz@amazon.com> writes:
>
> > By not honoring the 'stimer->config.enable' state during stimer
> > deserialization we might introduce spurious timer interrupts. For
> > example through the following events:
> >  - The stimer is configured in auto-enable mode.
> >  - The stimer's count is set and the timer enabled.
> >  - The stimer expires, an interrupt is injected.
> >  - We live migrate the VM.
> >  - The stimer config and count are deserialized, auto-enable is ON, the
> >    stimer is re-enabled.
> >  - The stimer expires right away, and injects an unwarranted interrupt.
> >
> > So let's not change the stimer's enable state if the MSR write comes
> > from user-space.
> >
> > Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 7c2dac6824e2..9f1deb6aa131 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -729,7 +729,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stim=
er *stimer, u64 count,
> >       stimer->count =3D count;
> >       if (stimer->count =3D=3D 0)
> >               stimer->config.enable =3D 0;
>
> Can this branch be problematic too? E.g. if STIMER[X]_CONFIG is
> deserialized after STIMER[X]_COUNT we may erroneously reset 'enable' to
> 0, right? In fact, when MSRs are ordered like this:
>
> #define HV_X64_MSR_STIMER0_CONFIG               0x400000B0
> #define HV_X64_MSR_STIMER0_COUNT                0x400000B1
>
> I would guess that we always de-serialize 'config' first. With
> auto-enable, the timer will get enabled when writing 'count' but what
> happens in other cases?
>
> Maybe the whole block needs to go under 'if (!host)' instead?

In either case, with 'enable =3D=3D 1' && 'count =3D=3D 0' we'll reset the =
timer
in 'kvm_hv_process_stimers()'. So it's unlikely to cause any weirdness.
That said, I think covering both cases is more correct. Will send a v2.

Nicolas
