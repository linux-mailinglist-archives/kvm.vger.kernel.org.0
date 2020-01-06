Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1928E130D7D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 07:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAFGVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 01:21:24 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34371 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgAFGVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 01:21:24 -0500
Received: by mail-ot1-f67.google.com with SMTP id a15so70264532otf.1;
        Sun, 05 Jan 2020 22:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uwZ2SiPflAo2gMhAO1B+oTaVC9KrM+PVnRjYk/ratMc=;
        b=KuCFY6D6VJ9hn4OiaxJtMwWEQG8NmA3MxjnNQOZSc5mR7A88m+caskdq7A/waITkGQ
         MnElD30Zann/cg+8HjO1QoHyN8so6ptaAT4JfOJTb3K/vMokV4Q+jHRJUA2Qhv/7kwMN
         FfJYiURQuGfoYLO+5yUoFi3UjJhAVW2Gikk7BtJsoMgZ+3MqAyIG9dMcu5QMIKsqg1kl
         ukRgts8sLgL3CkRnMYG2ijI8k+U328q0UxMy+Sko9DC3SSUN2JA6a5OpFZMUOAcXJpD8
         ZbxzkZ6r3rauCCgMgfQGtsdoJADm7lB6kG/HQt3ZGEPcztnBluuxw4t/CX+Cm8RtDFsI
         3zQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwZ2SiPflAo2gMhAO1B+oTaVC9KrM+PVnRjYk/ratMc=;
        b=EjW6c9aLJsmwDhOrH4xYykR5mLFkHczc8wz4HX35OU4bB89kDpiX0vCdqAkM5D7yaP
         9RA2t+cyYuxIPBp3xOXabjIOR+fsd9NW8Q+B9d5/CBmJR+Mk7E3HX8zJOiNyE4e7oKZP
         LMFM+KIFeilhSwFuONFdlx5RjBeC4aACiAI1IMq6Ypf6unwa0yuU5CV68GZLJlLTfKHG
         lml/NvnuQr/qKqqoFc398IMxCaPaabqfhhGpW11fpfeDhoCYJs6HNOxfq/NYi1WXLRIT
         C68fxjyHORFGpwURfT7ItimSeDlhRtEGVL4IbcSn/XMZqTq0TrVkvLi9U3cMX1ogAW3i
         v7Pw==
X-Gm-Message-State: APjAAAXTPI8mULf7sFS4UlN3YnvjakL6hHV2aX1VgvaDeqERPOpryKSM
        pKGJscx54NcU3EzcdGZUA1GhYkcdtrY3tZLk2HA=
X-Google-Smtp-Source: APXvYqxSz+b6F8LCIGIB5VIaGn6Cwvvmn5NGtc/3Mr2o8u1nlt15cKuWTr4XZ0S6VEX/2BCSmmay9uuguOVl8IfS0YQ=
X-Received: by 2002:a05:6830:120b:: with SMTP id r11mr13747016otp.254.1578291683382;
 Sun, 05 Jan 2020 22:21:23 -0800 (PST)
MIME-Version: 1.0
References: <1561682593-12071-1-git-send-email-wanpengli@tencent.com>
 <20190628011012.GA19488@lerouge> <CANRm+CxUpwZ9KwOcQp=Ok64giyjjcJOGb2=zU6vayQzLqYvpXQ@mail.gmail.com>
 <alpine.DEB.2.21.1910231028250.2308@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1910231028250.2308@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 6 Jan 2020 14:21:13 +0800
Message-ID: <CANRm+Cw1eTNgB1r79J7U__ynio7pMSR4Xa35XuQuj-JKAQGxmg@mail.gmail.com>
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

Hi Thomas,
On Wed, 23 Oct 2019 at 16:29, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, 23 Oct 2019, Wanpeng Li wrote:
> > I didn't see your refactor to get_nohz_timer_target() which you
> > mentioned in IRC after four months, I can observe cyclictest drop from
> > 4~5us to 8us in kvm guest(we offload the lapic timer emulation to
> > housekeeping cpu to avoid timer fire external interrupt on the pCPU
> > which vCPU resident incur a vCPU vmexit) w/o this patch in the case of
> > there is no busy housekeeping cpu. The score can be recovered after I
> > give stress to create a busy housekeeping cpu.
> >
> > Could you consider applying this patch for temporary since I'm not
> > sure when the refactor can be ready.
>
> Yeah. It's delayed (again).... Will pick that up.

I didn't find WIP tag for this work after ~half year since v4 was
posted https://lkml.org/lkml/2019/6/28/231 Could you apply this patch
for temporary because the completion time of refactor is not
deterministic.

    Wanpeng
