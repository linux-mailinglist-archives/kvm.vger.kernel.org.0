Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D899FD34
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfH1Iez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:34:55 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38477 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1Iey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:34:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id q8so1460302oij.5;
        Wed, 28 Aug 2019 01:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U8FH7AFxalfo9kXqgzeqBM8w1kp/vA0EX4/dnehxzF8=;
        b=TP06DYbD3V6ERHTB3g0KbjtgqWL9TuvRo0wmUzXGiDGjXKb3S3L4Mb2a/jtVlf2VmP
         wioNJCGVxlZITAL0k7PPNPIdAr/7KSa7wvD2FvKUEaPfPJ4gFF46ZnXi49F+MOwodDHE
         odc7xsPY51gjFc+ghK+35ZpYlu5JymD7y5dT9LxeZQJPCr5D45k+sUBfS7tgfeTCuuB5
         b4BfOVEE7RxQAv/GGMsa3dRqzx8EaBvDD9rQ6Sw6rTuB9kj/+Dr+G8ORrBzRHG0ZMoWB
         EEHYTIAdYESfcYmwuq272GcfrQmwEIxFkYSDbrQsqGTXXjdimdbmA8emXt+v76vaDsTN
         hdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U8FH7AFxalfo9kXqgzeqBM8w1kp/vA0EX4/dnehxzF8=;
        b=Ri9P7KNua3Xts6sgt7uNghB3hrfmn3j/UrWKi5potBso8GTK4IJdl+HNU8L5wYu4l2
         FNX9PpDjxocl12w5yy3zWfleFWtsi/I3n0rIVPtroEbUFmEzhaw1+nJyBpcb616azkbu
         LSIinBNAjqs84D2dLMDnkMc0x3Ufa51S2BnELjVp7uwCEXnPrcGhyfcI5reoRNmw42bY
         NzVGOpoaM5H/QkEDUctX++NlgxuYRzXJzuCV0xI8oSTDdagBkCxgb6w6vRTR+ClN80ei
         4PxVqfLmbtPIl/6e90qPBwZnvHHea521b+4VlXK2EUTMM5mElxgdjtPs+7uMlzi4EFe4
         p7zw==
X-Gm-Message-State: APjAAAXGjZwYLsUnwk2dS9wap9z/W7DlRBR5WWt/lyzZ5DkBlIdiXKbf
        GaaA8VQvKbisl5gyx/fkMGLkjSGo0sDBcJJcU5E=
X-Google-Smtp-Source: APXvYqzmD3lOi71p/BZRzvw9jM1MKLJ3Zwe/887SQPAbbvl+RMdE0RaTkaVm1kIc+BH0REmOSCceeJdskb95k+RqEqI=
X-Received: by 2002:a54:488e:: with SMTP id r14mr1922852oic.174.1566981293845;
 Wed, 28 Aug 2019 01:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet> <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet> <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
In-Reply-To: <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 28 Aug 2019 16:35:30 +0800
Message-ID: <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Cc Michael S. Tsirkin,
> On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> wrote=
:
> >
> > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wr=
ote:
> > > >
> > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > >>
> > > > > >> The downside of guest side polling is that polling is performe=
d even
> > > > > >> with other runnable tasks in the host. However, even if poll i=
n kvm
> > > > > >> can aware whether or not other runnable tasks in the same pCPU=
, it
> > > > > >> can still incur extra overhead in over-subscribe scenario. Now=
 we can
> > > > > >> just enable guest polling when dedicated pCPUs are available.
> > > > > >>
> > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > >
> > > > > > Paolo, Marcelo, any comments?
> > > > >
> > > > > Yes, it's a good idea.
> > > > >
> > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Hi Marcelo,

If you don't have more concern, I guess Rafael can apply this patch
now since the merge window is not too far.

Regards,
Wanpeng Li
