Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4059FD64
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1Ip4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 28 Aug 2019 04:45:56 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35245 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfH1Ip4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:45:56 -0400
Received: by mail-ot1-f65.google.com with SMTP id 100so2011748otn.2;
        Wed, 28 Aug 2019 01:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jCxOMA9aKz6SC3UYzcS/O/Ome5CiEdeSa8P16zSjLyw=;
        b=mtVHIfLz2MYDqKv0z90pu/NAxxsgLVfBebaj1h8GhPpQgKlrIlsg8u8mUkghB++9fI
         oLpjzcJRRMJoVtnSGMP/RPDDBfgNOvBeFjshTz5xysC07a4jM+ar64+qL296DyRNRixz
         VZ/jstryf8mbnGy6rTiR95G4PylRZmca3c8dC9Mp8cqs3xg7Yf9gXSgX5j7xINpRPe0G
         rrmHviLz1RW/VgsOVOExvP/CZcdMgFChLEkLlxTSC1/uQ4giWB3cDCMfKAWPkGTHP8xa
         eyGP7GwdjfLiBYfTa/tRkcI/bSUj8wAGAxkjb9/6tBks6NzWM7Wf9NW2Qu+GHMz16yMa
         1hhw==
X-Gm-Message-State: APjAAAUeU1eWcnyuWHx4caEqL9izF/CcxyzK13zSVq2qdwv24nYzyRkN
        HoNKcGSDkK1TaZzZe8av1ufPhVukX0zYYIctdlI=
X-Google-Smtp-Source: APXvYqwC2lZkwr9YxZ3bcwcAf22d6yK/9b2s9wjSflhVJcF8c3Hu86klsU+hStpBZP/K4omckicJLzQ8jSi7GQLdnp8=
X-Received: by 2002:a05:6830:154:: with SMTP id j20mr2381058otp.266.1566981954882;
 Wed, 28 Aug 2019 01:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet> <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet> <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
In-Reply-To: <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 28 Aug 2019 10:45:44 +0200
Message-ID: <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
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

On Wed, Aug 28, 2019 at 10:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > Cc Michael S. Tsirkin,
> > On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > >
> > > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > >
> > > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > >>
> > > > > > >> The downside of guest side polling is that polling is performed even
> > > > > > >> with other runnable tasks in the host. However, even if poll in kvm
> > > > > > >> can aware whether or not other runnable tasks in the same pCPU, it
> > > > > > >> can still incur extra overhead in over-subscribe scenario. Now we can
> > > > > > >> just enable guest polling when dedicated pCPUs are available.
> > > > > > >>
> > > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > >> Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > >
> > > > > > > Paolo, Marcelo, any comments?
> > > > > >
> > > > > > Yes, it's a good idea.
> > > > > >
> > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>
> Hi Marcelo,
>
> If you don't have more concern, I guess Rafael can apply this patch
> now since the merge window is not too far.

I will likely queue it up later today and it will go to linux-next
early next week.

Thanks!
