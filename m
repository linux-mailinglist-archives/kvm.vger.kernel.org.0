Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4333F4210C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408836AbfFLJiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:38:03 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42026 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408773AbfFLJiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:38:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id l15so14761009otn.9;
        Wed, 12 Jun 2019 02:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uho8KQeGL4zvCiWfgtRd1WVA8bccWLCM5Olh/mEH/V0=;
        b=OOwmIY2ri3gcT6Pn+fQxfeU643IzNCgpBtnRsglxxb2zPUAual001NiYqq/PxS14Mc
         VyTziLa+0CSKtERPDlbeOg06mcYorg002XRe8tnfyg/NA2MJisNk8exLFcgFWDrjKt+6
         /fK6XrJcD1yRTwCDZSScrRr/3GGZuYW+702rI3lYUYDFLmWpwtnfgy2QDWoaGS+gF+w8
         cPyNi+22wC2rTiDqOqVOmVtc3N0HHOSKDNrEFvSrSofxkfJSsS4geeZz13fvkz/PT6K4
         d/2NIHDSW11AnMZ6dLSo9ZG3Mfl/f/fpsM4D0CmWCx7QhKReApTWg8gYlHqa8o6osrNi
         nIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uho8KQeGL4zvCiWfgtRd1WVA8bccWLCM5Olh/mEH/V0=;
        b=S9a38cjwPobNPRzLRwapOsMOfdQYNadFlY+ovquRe5tcA7ImWGPmG+D074SvUXBKjv
         bn4JpKO/EAQyHkI4WeOmqTLB/f9TEkYkkgBszRas/3wiKiFTv5OB80H8aJlw6DC760EM
         hS8+qOXWGivvV7lkemcXTNAuEAH8AfCpEfrZBeHbAtxyDUkFMys6ZPqMNLm1XssCgmhN
         bWFVZ0Rtl435hcdxZ13eiBcv9u5I4Li/tdmXqSDHnvexj5fl1lHC73MLg8qFobvMwqqD
         FYJ99JdjQSDA6x/IQBKrqhf1I9Vb9EbDEN9QP+PH9Ag0lEHRSMD6dxqhwuL64dGNE94n
         LY5w==
X-Gm-Message-State: APjAAAVyU21c1wKTWbrd0/wH/upcYx/lOEz6o2+ekYrQUlQGid2Kex6K
        swo+qM4FOUr6pJaPU8ipZmpX3Anx4D7imRuygsY=
X-Google-Smtp-Source: APXvYqxS6QKBxt7vLOAsARJg20qqX12U2VOEM9zQ24quttGdwmW1DulmY3Xq3y4pTVI85hKXWEgARZZlxuJmjXjSmP8=
X-Received: by 2002:a9d:7601:: with SMTP id k1mr1632240otl.254.1560332282293;
 Wed, 12 Jun 2019 02:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
 <20190530193653.GA27551@linux.intel.com> <754c46dd-3ead-2c27-1bcc-52db26418390@redhat.com>
In-Reply-To: <754c46dd-3ead-2c27-1bcc-52db26418390@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 17:38:45 +0800
Message-ID: <CANRm+Czg+5qe3eHrOo-=EbOJM5929Xge+rSwyQoksdkk6PcGzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 May 2019 at 17:01, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/05/19 21:36, Sean Christopherson wrote:
> >> +u32 __read_mostly vmentry_lapic_timer_advance_ns = 0;
> >> +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
> > Hmm, an interesting idea would be to have some way to "lock" this param,
> > e.g. setting bit 0 locks the param.  That would allow KVM to calculate the
> > cycles value to avoid the function call and the MUL+DIV.  If I'm not
> > mistaken, vcpu->arch.virtual_tsc_khz is set only in kvm_set_tsc_khz().
>
> I would just make it read-only.  But I'm afraid we're entering somewhat
> dangerous territory.  There is a risk that the guest ends up entering
> the interrupt handler before the TSC deadline has actually expired, and
> there would be no way to know what would happen; even guest hangs are
> possible.

Agreed, do it in v3.

Regards,
Wanpeng Li
