Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179E81C618A
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgEEUAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 16:00:17 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:52878 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbgEEUAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 16:00:16 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 3FBF52E1532;
        Tue,  5 May 2020 23:00:13 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id Qm5jRXdL5Z-0CXqKnbj;
        Tue, 05 May 2020 23:00:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588708813; bh=wVJjUCQO65pUKMCr00MxsE7pI76wxuX6raO7OrWCLic=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=o212ezepm9nM5minm2wlsUjGGqfRsLHptq84HPW7J64PrhL2GZgtx2kPh4vYVxwox
         Do1IGe8OLOEi8Bbb3e14rN5UfauMeIctj3jpu6p7d0CbaQ22EoYxunBtME+m9r63WP
         ildpprIK5H5dknMm4mUYUbxr4eMtVED1DftqC02g=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:7013::1:1])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id X6UAKpLlyK-0BWqfIPo;
        Tue, 05 May 2020 23:00:12 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Tue, 5 May 2020 23:00:10 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200505200010.GB400685@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505103821.GB2862@jondnuc>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 01:38:21PM +0300, Jon Doron wrote:
> On 05/05/2020, Roman Kagan wrote:
> > On Mon, May 04, 2020 at 05:55:10PM +0200, Vitaly Kuznetsov wrote:
> > > and it seems the default state of HV_X64_MSR_SCONTROL is '1', we should
> > > probably do the same.
> > 
> > This is the state the OS sees, after the firmware.  You'd see the same
> > with QEMU/KVM if you used Hyper-V-aware SeaBIOS or OVMF.
> > 
> > > Is there any reason to *not* do this in KVM when
> > > KVM_CAP_HYPERV_SYNIC[,2] is enabled?
> > 
> > Yes there is: quoting Hyper-V TLFS v6.0 11.8.1:
> > 
> >  At virtual processor creation time and upon processor reset, the value
> >  of this SCONTROL (SynIC control register) is 0x0000000000000000. Thus,
> >  message queuing and event flag notifications will be disabled.
> > 
> > And, even if we decide to violate the spec it's better done in
> > userspace, loading the initial value and adjusting the synic state at
> > vcpu reset.
> > 
> > However leaving it up to the guest (firmware or OS) looks more natural
> > to me.
> 
> I under where you are coming from in the idea of leaving it to the OS

I'm coming from the HyperV spec, see the quote above.

> but I think in this specific case it does not make much sense, after
> all HyperV has it's own proprietary BIOS which Windows assumes has
> setup some of the MSRs, since we dont have that BIOS we need to
> "emulate" it's behaviour.

We don't have that BIOS, but we have another BIOS which does the same
and is not proprietary.  Using it allows to do synic message posting
even with a non-compliant guest OS which doesn't properly enable
SCONTROL on its own.  (Note that there used to be no problem with this
so far, this must be specific to your use case.)

I'm failing to see why this is a stumbling block for the work you're
doing.

And I'm not convinced we need to work around a non-compliant guest with
kludges to KVM or QEMU (including back-compat stuff as that would change
the existing behavior), when the desired effect can be achieved with the
existing code.

Thanks,
Roman.
