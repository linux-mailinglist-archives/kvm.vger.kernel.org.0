Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D025F056
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfGDAh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 20:37:57 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40445 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfGDAhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 20:37:52 -0400
Received: by mail-ot1-f68.google.com with SMTP id e8so4296136otl.7;
        Wed, 03 Jul 2019 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxKadiwStil9way1kU8jzMyzFN0LuSwbCGE20CmySOI=;
        b=jjed64kf8UigzT5xPFuCz/Amv7WWAE+6rjJhQtW2VDYH4cmOmzA1vr44kYsoBJTpaz
         dJmiqSYb2ZTRxwDk5JuHdcjKJ1tt72V4tLsn/8xmWsM/qHhCw/Cr1Qs+zLIW2q8s5iuC
         MQSfIJ+VsVcLXWy+RUH9ED/MSwMEMEBjK/KP6ffPBTB6e6uWXWZI1ifhvzW58Qyx7Vvr
         ZN22H0p7boLb9J44FTlPFArT0f5wu4yteSCNHHpkeNr7RTHwux9vATkCmlo8CEGbSew4
         kx97el09vrfVjyi0FZbZgiXfUR+fVhTswAljsD+iQn2erhsvaOybMBJU1fF8SS6VWd8c
         arOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxKadiwStil9way1kU8jzMyzFN0LuSwbCGE20CmySOI=;
        b=GZNbAhG8AcZHCLBvgKQYZPJTL++tg0X+IJIBWg3JPvxf6pRS0J5DkaFxt1RJdWAcv6
         UINOVLTMl0NrN3dtjKglmu56T1jV5gd8KLdFIKbBJ8d6hmc5mvep9tqS20oWznIWbWQT
         y3LAa5GNeTiP76NcRYmBI3GNLgF7IpVciMp91Qxy2D+FWixTupvVGZTJxyhwzlnhFJ4/
         1sA/8MEvEhDqDgF1i26BQh70rbt4wOxk2EWkSgcj6OsTjKFN7ncFKZQUeVwbx+EKx5UP
         u5UaxhjcG6aC0vzR6bhNBbhGzMKGW2GuPX+gaDb2ZSQCGIHDih5whw0qau5UbKYo+7MJ
         a4Ww==
X-Gm-Message-State: APjAAAWJSl1JNPLnJs4jTfBYbLh3WkFAN8CJsixLDzAPJMalVETjrhs3
        gpCQwV61xjAp0c26Iwy9z+oY1GDaslJvqIUL1YQ=
X-Google-Smtp-Source: APXvYqzeYi0PDoaiISTn2M9/7d/KVcBfQ7O2/IKHGPqh7tH9DMLVPheOsLoY4L/bml6SlwrjRhF2NNyFcfJgV6g/VzA=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr12145726oto.118.1562200672188;
 Wed, 03 Jul 2019 17:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
 <1560474949-20497-2-git-send-email-wanpengli@tencent.com> <CANRm+CzUvTTOuYhsGErSDxdNSmxVr7o8d66DF0KOk4v3Meajmg@mail.gmail.com>
 <CANRm+Cw0vmqi4s4HhnMqs=hZZixHmU87CGO_ujTGoN_Osjx76g@mail.gmail.com>
 <CANRm+Cz9Lc5rA7-2yLLX7wiemM-gdvWvQQdGVrvkYanYO9TwgA@mail.gmail.com> <18fd2372-45d8-0bff-79e7-373a8b7d129c@redhat.com>
In-Reply-To: <18fd2372-45d8-0bff-79e7-373a8b7d129c@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 4 Jul 2019 08:37:44 +0800
Message-ID: <CANRm+CyykkkvCP0sS6SBOMO_XFYVviOGNcQOMuudGZ3y0y1YQg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Jul 2019 at 22:13, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/07/19 02:48, Wanpeng Li wrote:
> > Hi Paolo, how about this patchset? Patch 2/2 is easy to take, do you
> > have more concern about patch 1/2?
>
> I don't know.  It seems somewhat hard to tune and in cyclictest it only
> happens for preemption_timer=N.  Are you using preemption_timer=N
> together with the LAPIC-timer-on-service-CPU patches?

A 25ns conservative value makes no benefit for cyclictest any more
even when preemption_timer=N. Btw, maybe it is the time to merge the
LAPIC-timer-on-service-CPU patches now. :)

Regards,
Wanpeng Li
