Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6CB6F86
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 01:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfIRXFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 19:05:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41991 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbfIRXFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 19:05:44 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so3135658iod.9
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 16:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eF+REpTpCjglDVMgyiLSFYwO1lg/DlrXW5WPA84s23s=;
        b=TAkMcUTaLxokO1BknnherWydyasqsV8s0HhaP8r2RC05i93S04AaZXD5LS/MWUL1YB
         thujpTSPm7euBkvKGO6f7L55CAB7FUAEE5amULQCX55BE/1H4RWjs1nMcckIQCTDKTEk
         NH/BY299iSLjL3EaRrBl78nWAFk+mNuLPltLwDMxtDP8Rkt9v6kpkrsoygTdqaZw0fAg
         nNP34OwgnqLEVrNfi+T5lLZ/lyuac48tDHfweawIAw2apb7aENv7iyJ8vTzhM246eJFI
         j6Roa6TxyHPNbQ0WF+YZvBKabI05K6X4M21DeXsbce3cG2Tgtet7vOQ1nVzoUj4AlZdm
         4Xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eF+REpTpCjglDVMgyiLSFYwO1lg/DlrXW5WPA84s23s=;
        b=h9i6Y+cOKeouoC88VkCkkfYm2la6pqlB0D9SQPYqOXYFdJwiqDtBFO9qIRVw0AO9oG
         Qo8E1teXBdFHdOZm9W2LluG0DiPOGf0CM/fmBfPPNdC3tuMm+HFNt3QJJhDu4qIGZUBZ
         a/67H9Pd2CdNju5JiJesy5NE2cSY9Uqpikz+3wabcbX12wyEg653eJQhMD2txaBzZBB3
         7ps1nlNS7rxXFOrjMjqgwsRt6VKrGPgsNp1qsqt/y/RT7UUOCHANWyKjfqQzwiNPudiM
         bmCSKooyEmwnVOIQIXpzA8RZ2L2CcVVIrQiz+8haSqEhbvJiwRfYX+8XmEptKPjKjHkP
         kZbQ==
X-Gm-Message-State: APjAAAVM4UFDquPcRBK/GX13LdNYmqwi1zjOB8HeV3EZcGghMvYKyduF
        jv4SO0UMLsDNFMQpRKro1esdGb92VCIrHVg+qTC3dQ==
X-Google-Smtp-Source: APXvYqzQHKvYIZv2mL597Nx+4gHFypeiqPfjwwmN79kQBpVjvrAQysqzm661M4axgQwYjSJoLyTDSMK1JSKppBKgqG4=
X-Received: by 2002:a05:6638:777:: with SMTP id y23mr8198769jad.111.1568847941567;
 Wed, 18 Sep 2019 16:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190912165503.190905-1-jmattson@google.com> <900bfd96-f9da-0660-4746-6605c0ae06c4@oracle.com>
In-Reply-To: <900bfd96-f9da-0660-4746-6605c0ae06c4@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Sep 2019 16:05:30 -0700
Message-ID: <CALMp9eRBqPhcCgNbPLskvwGiV=vAJPx8TxqjOp8NApq8JV5V2Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add "significant index" flag to a few CPUID leaves
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 10:41 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 9/12/19 9:55 AM, Jim Mattson wrote:
> > According to the Intel SDM, volume 2, "CPUID," the index is
> > significant (or partially significant) for CPUID leaves 0FH, 10H, 12H,
> > 17H, 18H, and 1FH.
> >
> > Add the corresponding flag to these CPUID leaves in do_host_cpuid().
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> > ---
> >   arch/x86/kvm/cpuid.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 22c2720cd948e..e7d25f4364664 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -304,7 +304,13 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
> >       case 7:
> >       case 0xb:
> >       case 0xd:
> > +     case 0xf:
> > +     case 0x10:
> > +     case 0x12:
> >       case 0x14:
> > +     case 0x17:
> > +     case 0x18:
> > +     case 0x1f:
> >       case 0x8000001d:
> >               entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> >               break;
>
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>


Ping.
