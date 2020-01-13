Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA688138940
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 02:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgAMBcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 20:32:18 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43839 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMBcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 20:32:18 -0500
Received: by mail-oi1-f195.google.com with SMTP id p125so6821638oif.10;
        Sun, 12 Jan 2020 17:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MMBytJUvPgAu+zMfgqDgk/AfX9Yfe5/T6E8UlbQLhRg=;
        b=bavqG7BbIXENsNo9UOozQb1Br1Q21nNEU7hk7Iyb1e5fPuCq659TKTxQcBnyLyK8iN
         VnFlSKggY1A4gcBuyqEQf1AsRpw9Z6DefQnra9k9TSquQQLmdnFuz3SYnA5sqq7kiJC9
         rIfAZQXUmG3LNRog65z5m1zZyAjNyuD3ccecWyRVh7XWsCyeU0S0gH6c5CFkrn3citxc
         VjfBCYx2f1Bb9sSqaUQwSnmCEg+9dhle+WZAiHosYYH/E7g7wvT8BvwDURbEAEcusB4u
         E/SXBAGwI+00vIHETPisSrbgOqpxvmIUiUo2pL1R4A8lykgG64v0wXEPiR0yCdrBQTmZ
         JXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MMBytJUvPgAu+zMfgqDgk/AfX9Yfe5/T6E8UlbQLhRg=;
        b=T3vYBf4dqyhd7l8zEfKqY9RFEYjuWfQFSDKu3XjqPSQBDa5bg6c8Ziq/+WFqEdgZLg
         bmlYJeS90Vc/kPFFCQeGRhfxU705NuOg0H/6jWjzPxLNeiLl7Kjif3T2mOZcdvLlm+pi
         kLttqLQ6u2TLzApuHKydJJEdkUWXg9BrJe7qp8ocjGXRX930dTfqdHe2fVbOfwyo2oQg
         rA2N7JCYv8SrQR7sWVGQZ/8hx9WeNfbJVLR4CE2UvqmG0PQ4BiOHLXZiaw6FXHjpjeoW
         pUSJqXuJBIQq9Ik/l2h9U2qj45fSrCNegyHCGL6/eKZdRsgMt4cRUFg5SLwGOEaD20R+
         z2Xg==
X-Gm-Message-State: APjAAAW2KmImYKQFI7Pn/y5WjZvD6gUUKMKVA49hfWirt50q32iaJSYd
        X/cp+F+NOn/iLNCpEgMf//JKvsuxS9Bd7hqCI6k=
X-Google-Smtp-Source: APXvYqwCPuqbYAG95luf4ZYYWjcaCVybJvsz8csO3YSbyw59b9EkPjN9oGmKDDBpKx1Q1quoOXGu4QhIj6WTgo+7q7g=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr10286701oii.141.1578879137785;
 Sun, 12 Jan 2020 17:32:17 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+Cw1eTNgB1r79J7U__ynio7pMSR4Xa35XuQuj-JKAQGxmg@mail.gmail.com>
 <87a76v8knv.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87a76v8knv.fsf@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 13 Jan 2020 09:32:06 +0800
Message-ID: <CANRm+CyGWvY767ER14EqWAZakZu3S0KL=X5PT7Pyu=ezVZZoag@mail.gmail.com>
Subject: Re: [PATCH v2] sched/nohz: Optimize get_nohz_timer_target()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, kvm <kvm@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jan 2020 at 22:12, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Wanpeng,
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > Hi Thomas,
> > On Wed, 23 Oct 2019 at 16:29, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> On Wed, 23 Oct 2019, Wanpeng Li wrote:
> >> > I didn't see your refactor to get_nohz_timer_target() which you
> >> > mentioned in IRC after four months, I can observe cyclictest drop from
> >> > 4~5us to 8us in kvm guest(we offload the lapic timer emulation to
> >> > housekeeping cpu to avoid timer fire external interrupt on the pCPU
> >> > which vCPU resident incur a vCPU vmexit) w/o this patch in the case of
> >> > there is no busy housekeeping cpu. The score can be recovered after I
> >> > give stress to create a busy housekeeping cpu.
> >> >
> >> > Could you consider applying this patch for temporary since I'm not
> >> > sure when the refactor can be ready.
> >>
> >> Yeah. It's delayed (again).... Will pick that up.
> >
> > I didn't find WIP tag for this work after ~half year since v4 was
> > posted https://lkml.org/lkml/2019/6/28/231 Could you apply this patch
> > for temporary because the completion time of refactor is not
> > deterministic.
>
> Could you please repost it?

Just repost, thanks Thomas.

    Wanpeng
