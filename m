Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB217CB107
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjJPRGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbjJPRGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:06:18 -0400
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF03D60;
        Mon, 16 Oct 2023 10:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697475868; x=1729011868;
  h=mime-version:content-transfer-encoding:date:message-id:
   subject:from:to:cc:references:in-reply-to;
  bh=W+ZgtLRLZp9tFB/6xJaTS6rzYwR2W/IqBEpak7Hkkp4=;
  b=eyNmY55GlUS1HpBJhkXa/KYeqMfx54pJ18er+V9CN+kO2VD6YZ7DyRrz
   CnjWXrWQohq1EUrZ0ALfH98tJIKG3io9ztZP+SPqaDBdsh7OLm12YQy3/
   qkzG8PYB6174W87uv0NzL99jAzamlw+aPXgwqATuuBGVuTS/6CVXp0zo1
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,229,1694736000"; 
   d="scan'208";a="589284223"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 17:04:25 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
        by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id DB7E287A20;
        Mon, 16 Oct 2023 17:04:23 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:37033]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.2.76:2525] with esmtp (Farcaster)
 id aa7b6734-43cd-490b-9074-3d36053d0fd1; Mon, 16 Oct 2023 17:04:22 +0000 (UTC)
X-Farcaster-Flow-ID: aa7b6734-43cd-490b-9074-3d36053d0fd1
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 16 Oct 2023 17:04:22 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Mon, 16 Oct
 2023 17:04:18 +0000
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 16 Oct 2023 17:04:15 +0000
Message-ID: <CWA0YYN7MFBQ.3VOJQRP2X7BY8@amazon.com>
Subject: Re: [PATCH] KVM: x86: hyper-v: Don't auto-enable stimer during
 deserialization
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <graf@amazon.de>, <rkagan@amazon.de>,
        <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231016095217.37574-1-nsaenz@amazon.com>
 <87sf6a9335.fsf@redhat.com> <CW9VEIPFLJJA.3OI6RJQVQU7ZN@amazon.com>
 <ZS1kcXuGqO3O7yAq@google.com>
In-Reply-To: <ZS1kcXuGqO3O7yAq@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,
On Mon Oct 16, 2023 at 4:27 PM UTC, Sean Christopherson wrote:
> I'd prefer the shortlog be more explicit about the write coming from user=
space, e.g.
>
>   KVM: x86: hyper-v: Don't auto-enable stimer on write from userspace
>
> A non-zero number of KVM's "deserialization" ioctls are used to stuff sta=
te
> without a paired "serialization".  I doubt anyone is doing that with the =
Hyper-V
> ioctls, but keeping things consistent is helpful for readers.
>
> On Mon, Oct 16, 2023, Nicolas Saenz Julienne wrote:
> > Hi Vitaly,
> >
> > On Mon Oct 16, 2023 at 12:14 PM UTC, Vitaly Kuznetsov wrote:
> > > Nicolas Saenz Julienne <nsaenz@amazon.com> writes:
> > >
> > > > By not honoring the 'stimer->config.enable' state during stimer
> > > > deserialization we might introduce spurious timer interrupts. For
>
> Avoid pronouns please.
>
> > > > example through the following events:
> > > >  - The stimer is configured in auto-enable mode.
> > > >  - The stimer's count is set and the timer enabled.
> > > >  - The stimer expires, an interrupt is injected.
> > > >  - We live migrate the VM.
>
> Same here.  "We" is already ambiguous, because the first usage is largely=
 about
> KVM, and the second usage here is much more about userspace and/or the ac=
tual
> user.
>
> > > >  - The stimer config and count are deserialized, auto-enable is ON,=
 the
> > > >    stimer is re-enabled.
> > > >  - The stimer expires right away, and injects an unwarranted interr=
upt.
> > > >
> > > > So let's not change the stimer's enable state if the MSR write come=
s
> > > > from user-space.
>
> Don't hedge, firmly state what the patch does and why the change is neces=
sary
> and correct.  If it turns out the change is wrong, then the follow-up pat=
ch can
> explain the situation.  But in the happy case where the change is correct=
, using
> language that isn't assertive can result in
>
> > > > Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
>
> Does this need a?
>
>   Cc: stable@vger.kernel


Your reply raced with my v2. I'll rework the commit message, and send a
third revision.

Nicolas
