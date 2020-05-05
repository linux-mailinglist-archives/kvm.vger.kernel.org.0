Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872BC1C4FCB
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgEEICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:02:04 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:45756 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbgEEICD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 04:02:03 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 980322E152E;
        Tue,  5 May 2020 11:02:00 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 1uP1N2AxLk-1xbu0oLA;
        Tue, 05 May 2020 11:02:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588665720; bh=M6FIiLV7jSLfXNrCrNok4CWJZSeN7a/htiSx6vThNRQ=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=gt36QSU5AVIrTwOl1DjSrzrZxVCEL+gZKnWoRBqclxY9ntLUOkgYAGe4iPXpiS5Iu
         srgo4Dn+OLvoShn+oNyi8nVNjDTBNkH+/bXkH91lMVh27E8pFHQeKaXWTYjviMiZ2u
         WvrNLgGlypNkH7nIn0ziO4eabSla5mYVZwT9Yux0=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:7013::1:1])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id yw9eFxp7nr-1xWSXHHR;
        Tue, 05 May 2020 11:01:59 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Tue, 5 May 2020 11:01:58 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200505080158.GA400685@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a72nelup.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 05:55:10PM +0200, Vitaly Kuznetsov wrote:
> Roman Kagan <rvkagan@yandex-team.ru> writes:
> 
> > On Sat, Apr 25, 2020 at 09:16:37AM +0300, Jon Doron wrote:
> >
> >> If that's indeed the case then probably the only thing needs fixing in my
> >> scenario is in QEMU where it should not really care for the SCONTROL if it's
> >> enabled or not.
> >
> > Right.  However, even this shouldn't be necessary as SeaBIOS from that
> > branch would enable SCONTROL and leave it that way when passing the
> > control over to the bootloader, so, unless something explicitly clears
> > SCONTROL, it should remain set thereafter.  I'd rather try going ahead
> > with that scheme first, because making QEMU ignore SCONTROL appears to
> > violate the spec.
> 
> FWIW, I just checked 'genuine' Hyper-V 2016 with
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index fd51bac11b46..c5ea759728d9 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -314,10 +314,14 @@ void __init hyperv_init(void)
>         u64 guest_id, required_msrs;
>         union hv_x64_msr_hypercall_contents hypercall_msr;
>         int cpuhp, i;
> +       u64 val;
>  
>         if (x86_hyper_type != X86_HYPER_MS_HYPERV)
>                 return;
>  
> +       hv_get_synic_state(val);
> +       printk("Hyper-V: SCONTROL state: %llx\n", val);
> +
>         /* Absolutely required MSRs */
>         required_msrs = HV_X64_MSR_HYPERCALL_AVAILABLE |
>                 HV_X64_MSR_VP_INDEX_AVAILABLE;

Thanks for having done this check!

> and it seems the default state of HV_X64_MSR_SCONTROL is '1', we should
> probably do the same.

This is the state the OS sees, after the firmware.  You'd see the same
with QEMU/KVM if you used Hyper-V-aware SeaBIOS or OVMF.

> Is there any reason to *not* do this in KVM when
> KVM_CAP_HYPERV_SYNIC[,2] is enabled?

Yes there is: quoting Hyper-V TLFS v6.0 11.8.1:

  At virtual processor creation time and upon processor reset, the value
  of this SCONTROL (SynIC control register) is 0x0000000000000000. Thus,
  message queuing and event flag notifications will be disabled.

And, even if we decide to violate the spec it's better done in
userspace, loading the initial value and adjusting the synic state at
vcpu reset.

However leaving it up to the guest (firmware or OS) looks more natural
to me.

Thanks,
Roman.
