Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC52A0E41
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfH1Xht convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 28 Aug 2019 19:37:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42044 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfH1Xhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:37:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id j7so1575123ota.9;
        Wed, 28 Aug 2019 16:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0WiNNlZ19WAx+O8CTTiGYwNeR0ZDw2Ysbv/e1WoYV9o=;
        b=NzkWW2rEUGn2hm/+Q47nfXQgS+iditfvHFjoCGWPnNViisDyUh6UvUmPOb65gsI/lF
         zuaC7Xxrb5ctQXyRUOOyy/h1IwuZvE+zN4e3+oNsKirgxmXjvDpQQXuozaSvDkdVg9Cp
         yqPjw/dg3dbI5/Ygmw+SLiOVx47+r9hQ2+sKrFCE54kekC0uAUDSjJmNq6a5x6LsTtsu
         t12qTTd4XdWTL3BcYPeHfY0uNf3s5O6GBh3ASBHgNsaucY/E2wgXzYBjfv4zt9AfAxZN
         4SVn5aoXJzcyXIZnLGEEcgVqdSk4nwYWL5ekaqJR/FcezLmm0qPxIUvNLOvGGgnXydFk
         38Lw==
X-Gm-Message-State: APjAAAXVjpTOUYRSE1sEn6DzPM323ZmQx3fqTW7nN/MexHDcm2EkcxuP
        D9oo/0mzQclC1WrxeqBTfNX2zuOryNHIvMGHkkM=
X-Google-Smtp-Source: APXvYqxk5XxurJ7D0mvitMxzIf9FQRgo2vpruN5+wj43N/LYuGLxqqtW3SsJxC+VaDntTllf2UOHc/U87dV9dPOR7W8=
X-Received: by 2002:a9d:12d1:: with SMTP id g75mr5311313otg.189.1567035467967;
 Wed, 28 Aug 2019 16:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet> <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet> <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
 <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com> <20190828143916.GA13725@amt.cnet>
In-Reply-To: <20190828143916.GA13725@amt.cnet>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 29 Aug 2019 01:37:35 +0200
Message-ID: <CAJZ5v0jiBprGrwLAhmLbZKpKUvmKwG9w4_R7+dQVqswptis5Qg@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 4:39 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Wed, Aug 28, 2019 at 10:45:44AM +0200, Rafael J. Wysocki wrote:
> > On Wed, Aug 28, 2019 at 10:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wrote:
> > > >
> > > > Cc Michael S. Tsirkin,
> > > > On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > >
> > > > > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > > > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > > > >
> > > > > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > >>
> > > > > > > > >> The downside of guest side polling is that polling is performed even
> > > > > > > > >> with other runnable tasks in the host. However, even if poll in kvm
> > > > > > > > >> can aware whether or not other runnable tasks in the same pCPU, it
> > > > > > > > >> can still incur extra overhead in over-subscribe scenario. Now we can
> > > > > > > > >> just enable guest polling when dedicated pCPUs are available.
> > > > > > > > >>
> > > > > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > > >> Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > > > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > >
> > > > > > > > > Paolo, Marcelo, any comments?
> > > > > > > >
> > > > > > > > Yes, it's a good idea.
> > > > > > > >
> > > > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > >
> > > Hi Marcelo,
> > >
> > > If you don't have more concern, I guess Rafael can apply this patch
> > > now since the merge window is not too far.
> >
> > I will likely queue it up later today and it will go to linux-next
> > early next week.
> >
> > Thanks!
>
> NACK patch.

I got an ACK from Paolo on it, though.  Convince Paolo to withdraw his
ACK if you want it to not be applied.

> Just don't load the haltpoll driver.

And why would that be better?
