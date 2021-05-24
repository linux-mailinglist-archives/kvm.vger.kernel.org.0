Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F138F637
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhEXXZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhEXXY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:24:59 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F60C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:23:30 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id e27-20020a056820061bb029020da48eed5cso6734571oow.10
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a1hKEG5nX57zkvDyn5+AMDW8vwLMUVldJvey3PYyA7w=;
        b=bGY+q9kDcIqbvbXnDsfaXLHI2ZfQ0uV2nTCnZZipcYhRdt79KdWZgro7SGtqLBL4sc
         uknlrkvdk+MZCm2KMjGiAbC+O6URenLl3Zb5ax+yDprDBclinGQhG120e4xLnsk1IxEc
         +PlnpEkfAVewwJEuJ47e2x5oqirWaXmRMlrQMDElfZ0JnaKYFIWuFDApGnLz47jLUnAf
         qrU+0n1H8UunB0IHmPgc/G2Koz7GbiQOfevzlZmK9CaNdOxxBGIXFc4wm8yxUDnhwnMv
         VmXXZGhCIwkaBYKno7hRrvAXAZuGy0xnBC7S8J3vMO5mKSyK+xRLk23vjWr/G33v2zxc
         F1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a1hKEG5nX57zkvDyn5+AMDW8vwLMUVldJvey3PYyA7w=;
        b=d8DGIjMSYAhZiq9ltGIn9IpleyYVW5wNmuLP3zvBHsR4pAIx1gEMkqLSUyuCz4KIQx
         hrK1W1/M8IQPonxqqceDKjWHispDe1Fzym5bMgRSUJhOW+cSmmo4jowsjJtUIN1hTrTP
         9r3nHxiDEYHz5vVOMw3qsPwvz8cWnzBKs+ItROknrwzxHpn9Hln1ZdcUuYcuqS8ZndKv
         5GF3453g+XYL+iEBsmVm2NgXBk39cBB+KKxBZSxdGCpqCxa8ZFDHQ3Px1qaEUxPxPf3X
         +yg2kG2nsftuCIZ1fQHdpqxzqMSisFBl3klNf9AJrl74nkUdE4+SxzT/mZ3cqgA7WVyG
         xTvw==
X-Gm-Message-State: AOAM533LE0qoVNKbzD9+2cAJQCEsGuVD/FdmJ5M2YLZkhiNoLOA4pCBZ
        3e85L21WDSkT85728A6g+rNjfltiuAhWS0N2GDXe0Q==
X-Google-Smtp-Source: ABdhPJz+/QHAHxn4LjcaXZVe41KTFE76HIejsVSAwoe6wnDmiLGrZ/L7rj1vGS+kQIf713cnQZ7vkwqEAJjm3Mhx9FM=
X-Received: by 2002:a05:6820:100a:: with SMTP id v10mr19732951oor.55.1621898609695;
 Mon, 24 May 2021 16:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com> <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com> <YKwydQlAXHeockLx@google.com>
In-Reply-To: <YKwydQlAXHeockLx@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 16:23:18 -0700
Message-ID: <CALMp9eRQXwpM8N6BzrY+gt0cPCCxYuf2UVgdgxjEN6=SrgTkjg@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when kvm_check_nested_events
 fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 4:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Paolo Bonzini wrote:
> > On 24/05/21 18:39, Jim Mattson wrote:
> > > Without this patch, the accompanying selftest never wakes up from HLT
> > > in L2. If you can get the selftest to work without this patch, feel
> > > free to drop it.
> >
> > Ok, that's a pretty good reason.  I'll try to debug it.
>
> I don't think there's any debug necessary, the hack of unconditionally calling
> kvm_check_nested_events() in kvm_vcpu_running() ...

We don't unconditionally call kvm_check_nested_events() in
kvm_vcpu_running(). We still call kvm_check_nested_events() only when
is_guest_mode(vcpu). The only change introduced in this patch is that
we stop ignoring the result.
