Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342131B1842
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 23:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDTVUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 17:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgDTVUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 17:20:49 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676EC061A0E
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 14:20:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f82so11371253ilh.8
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 14:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMEo8IzhJo5r/g49jS9dMArCoyOrINpa+pWa++ryG9Y=;
        b=Ae7uMN5F5HzPJjZt/wpRzu64bJAInmuWePBtwGqdOSrvTqVuQpFpkHrX62DMUsctvD
         ICQm9swQ9rOIUD1QUSUpMrGuL9EZzs1qJdfht7Mo1u0pq0jMn7Mf6Er2aJc/Qqox5V+z
         ca3ZQp7epoHA/l4Qp3QVn/2Ud7L3o7WwnfXqr+w3EJgQTy1HE4JfxJTQNFscexXCzRyO
         duWNhUaj6nkzSC11XBsz0uK9W67Kjg4P8RW2hEf+PfBxjWvgTDh7MMxVAPzwlGkoC+c6
         1QkjD6gQXxIBbZiKuIsD15Je9m0BKCplmMjDtb5PAc25xIZSyfHtsDekOCzasCQ+671s
         69zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMEo8IzhJo5r/g49jS9dMArCoyOrINpa+pWa++ryG9Y=;
        b=V6b0kgR9Nm8r+xZ+l/Lm+vTk+kHPIsjiPod1UWzdP+ZHrnbS//dBUdWeAODErvcng5
         F8qa8Pl+MivA5htt86E6WxXa596HQOf4ikFMLsAnhJsEcod411irLPmys52StDI/53hZ
         Pc+AExxgNSSMKtNmnXFGBSb9eXfdvCq38vNYn3C5JZrM3q0yINCh2js4P6AL2nbcymTf
         5f8iEOcVXqcFMfUchgWUgMdL/s8pBZ6g0OY9+yTl5cLvF0ZBUCXSRjSnxonu+LipNWkw
         e18A2UB5klVQve80KexnirCd2oqkdAC3MuCe2L24Dj5xYzwvSBXOQcqnX76sPqzykA/3
         XRHQ==
X-Gm-Message-State: AGi0PuauXYYncfX6BS+Ho/TO9qiOHIkmMzL95+xECOXH1m85SykTzYCf
        XVZjEbbPrLWxEdpm3kalCcIZU/+aBftMK9/+64EvGA==
X-Google-Smtp-Source: APiQypJNjV1AJ+b0wwmMaphTOkR07VuJG4QnVLK3VJ7HIknTzJNSqo4lCzDfgH6mdfsDZLZ2yBhTZvi/yJqDuxa5By4=
X-Received: by 2002:a05:6e02:c65:: with SMTP id f5mr8205254ilj.44.1587417646632;
 Mon, 20 Apr 2020 14:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200417221446.108733-1-jcargill@google.com> <87d083td9f.fsf@vitty.brq.redhat.com>
 <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com> <02039a7b-01b4-ea5c-bd73-100ea753bf5e@redhat.com>
In-Reply-To: <02039a7b-01b4-ea5c-bd73-100ea753bf5e@redhat.com>
From:   Jon Cargille <jcargill@google.com>
Date:   Mon, 20 Apr 2020 14:20:34 -0700
Message-ID: <CANxmayh3A1CaLqKdf=GknOmOQ-ww0npg9ikUTGRyDbbRge+yHQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: add capability for halt polling
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 2:10 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/04/20 20:47, Jon Cargille wrote:
> >> Is it safe to allow any value from userspace here or would it maybe make
> >> sense to only allow [0, global halt_poll_ns]?
> > I believe that any value is safe; a very large value effectively disables
> > halt-polling, which is equivalent to setting a value of zero to explicitly
> > disable it, which is legal.
>
> Doesn't a large value make KVM poll all the time?  But you could do that
> just by running "for (;;)" so there's no reason to limit the parameter.

Yes, I mis-spoke; apologies. A large number will cause KVM to poll for a
long time; as long as the thread can be preempted, we don't see any
problem with that.

Thanks,

Jon

>
> Paolo
>
