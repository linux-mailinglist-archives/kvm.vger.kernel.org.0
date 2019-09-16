Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8539FB3632
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 10:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbfIPIKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 04:10:08 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46933 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfIPIKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 04:10:07 -0400
Received: by mail-ot1-f66.google.com with SMTP id g19so34740640otg.13;
        Mon, 16 Sep 2019 01:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6c0nZaBPyfxRJBP1x7CxvAJ/ZjmFhBQPaFGw/S18y7Q=;
        b=PdN+yvh+WkL6iTNeSqdLkEMFCZuiZNphjnxqHzIDG1WPT6d+7zDv5reX301C2lGIt9
         yk9R1E+caTso+dcazIzGIBL7KBjoY+5UPkQC8tTJgIL41qrJxTHIvj78+yUfiUwZjPVR
         sUZ/lhzI5IB72qOAexg+ij1CHYmnRHiwRFCtGheXfb9HYwWbWjjFHN6tqHGKX6fwylIM
         A1QjtFgIhufwSpa2X6MjxZj80eM2BzRZ1AypvIF+Qdxk61/cMJjjeD3jkP8JZjq5Drfm
         xFg9sc68AVSQWQNakBToufjyZnAjDuCiFVtCCQX6WBxQCb/yFdoeLFr4WCjxAWyHMD59
         y7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6c0nZaBPyfxRJBP1x7CxvAJ/ZjmFhBQPaFGw/S18y7Q=;
        b=UkKM97CCpQkmU014ydr0n2A3gBA3fhle50cDALd+SgEQlVc7p04yMiL619sQLAApwk
         Pg8OFrLFKAVqz53pc+SRNDC/nNE/ZevZxyG+4EkEiX+c4b6oqxBjfhHp+3fgKUpdPFVt
         NSLLX/1g2toE9ZqQJZJcXbtWWapWp7UO2JWgrIV03NlUZjz4vVsk/ZVq6h6yG0HbxuR3
         Pt5ICuWyCqTZrj0ztH0XgXCcmLLLIa7ky2XknkzKdnVols5374IV0RX62y0V405Lsc+s
         0vU1/ishNFGDLPypP6600FYqjr4OcodMiVGDA6RtVritR+UqxcUMqpi6v1sxpxCpl4MX
         aSEw==
X-Gm-Message-State: APjAAAXXREyo1sM3tjCuw2GJKuDo/3AQRDydcNS6M8dSsuMycg+Qqjlk
        jLvlPAFJICVvaB/9VogxJM7BU0TMIrm0ASgaoWU=
X-Google-Smtp-Source: APXvYqy9uPAQ+ah6hl8UQV8HIUOFzGAJ/eOzn3CuAklH/Il+pYsf10+uIVot1+nZYu9GJs4tc46uzXj0xA/JzCik1mk=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr49055047otq.56.1568621406942;
 Mon, 16 Sep 2019 01:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
 <a1c6c974-a6f2-aa71-aa2e-4c987447f419@redhat.com> <TY2PR02MB4160421A8C88D96C8BCB971180B00@TY2PR02MB4160.apcprd02.prod.outlook.com>
 <8054e73d-1e09-0f98-4beb-3caa501f2ac7@redhat.com> <CANRm+Cy+5pompcDDS2C9YnxvE_-87i24gbBfc53Qa1tcWNck2Q@mail.gmail.com>
 <82ff90b6-f518-e2a8-c4f5-ef4b294af15e@redhat.com>
In-Reply-To: <82ff90b6-f518-e2a8-c4f5-ef4b294af15e@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 16 Sep 2019 16:09:55 +0800
Message-ID: <CANRm+Cy-u4AJ8kBMy44JAv-7er9YmwgY0gbq1QR=Pt4MV9JvJA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpeng.li@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Sep 2019 at 15:49, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/09/19 06:02, Wanpeng Li wrote:
> > Hi Paolo,
> >
> > Something like below? It still fluctuate when running complex guest os
> > like linux. Removing timer_advance_adjust_done will hinder introduce
> > patch v3 2/2 since there is no adjust done flag in each round
> > evaluation.
>
> That's not important, since the adjustment would be continuous.
>
> How much fluctuation can you see?

After I add a trace_printk to observe more closely, the adjustment is
continuous as expected.

>
> > I have two questions here, best-effort tune always as
> > below or periodically revaluate to get conservative value and get
> > best-effort value in each round evaluation as patch v3 2/2, which one
> > do you prefer? The former one can wast time to wait sometimes and the
> > later one can not get the best latency. In addition, can the adaptive
> > tune algorithm be using in all the scenarios contain
> > RT/over-subscribe?
>
> I prefer the former, like the patch below, mostly because of the extra
> complexity of the periodic reevaluation.

How about question two?

    Wanpeng
