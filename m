Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5538C38F53D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhEXV7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhEXV7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:59:11 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5350C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:57:41 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id t24so12913875oiw.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QOd1KfRYOgHgN+WbksAwHnKrFOkuvhhmy1/CWBQTUM=;
        b=KhP+msE1sBjTgPeZHuqohUHYU8q1MCHlCmd7BM0DG/QQPq0BVCAhBRoWQAvvPWXC3B
         dzIdRw0drYiWC6puPbIgYlYpn/RgzymNyAilhIgJHplegheMKxhJbEiyiZoetKiLi/mn
         ykAJ174khzSSndRTgw6U9AFmHJqWdsxK8JkbtQEwXXdc36S/CA52VJhna92gSZPmwv5R
         nA3R24Fgi6zEBCNS9WMqIu2SUly94l6303+0NMmlDms+eHSHwj63TutGiZcfguZfweaS
         orQsAc7kJ9A+u8KBtS9xkbgxtn6aqY6RxeQWOQi93tbqG6KQcnrL00+D/o/+n3fp0k32
         0EVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QOd1KfRYOgHgN+WbksAwHnKrFOkuvhhmy1/CWBQTUM=;
        b=g1XNMv+XvS044FjM5KvfVaQjbQxm3hRGNb3wswt2Cv+puYrpBDKkVqey7l525l2I0L
         cqQn0s7Dsha9vDymI0q0dTxpH2Tso0L0HMVGAzGdMpbtv7jYk5teQhgXH6WczFs4eot0
         11vvj8RI6/mfT6SoomVvwq89TP6dBd09UaFmL/74HhQTgA9ldv0A2ROaYGAAaeI4aduv
         EUeaSH16lkVcPYjhBo83uwzUXRuntf7xrR7FMqUyo3sKp2ZbpT19QaIqoU4x7ArqrYKj
         LXshcXXiMAYrP4C3SIhb/1LWkVCIMKkH8MLB6RxgVt/1iOQTKHdQmCS5W2PKHmKtudWh
         vZVQ==
X-Gm-Message-State: AOAM531gTqgU7mevh2TDJfV46xbdrlyMC7RHmJbP+yrpcCRftQHTBduT
        2LNI2Yg8p87Zgla2fRmcS/d0isbIFkIIv3iN9jIzgA==
X-Google-Smtp-Source: ABdhPJy0YshGVdkHTmCXqcoHfIQ+x4WlPzk0E5xPuG+DSS7cOf2zkUjT30pxzPVVIfEn2OfQJJKGqrgDGo1sw/qbKs8=
X-Received: by 2002:aca:280a:: with SMTP id 10mr813875oix.13.1621893460868;
 Mon, 24 May 2021 14:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-3-jing2.liu@linux.intel.com> <YKwd5OTXr97Fxfok@google.com>
In-Reply-To: <YKwd5OTXr97Fxfok@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 14:57:29 -0700
Message-ID: <CALMp9eTjgMDG2rKqKkb3WAsQXqfss1QEHWo5CJZHdd8r_XHRqg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/7] kvm: x86: Introduce XFD MSRs as passthrough to guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, jing2.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 2:44 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Feb 07, 2021, Jing Liu wrote:
> > Passthrough both MSRs to let guest access and write without vmexit.
>
> Why?  Except for read-only MSRs, e.g. MSR_CORE_C1_RES, passthrough MSRs are
> costly to support because KVM must context switch the MSR (which, by the by, is
> completely missing from the patch).
>
> In other words, if these MSRs are full RW passthrough, guests with XFD enabled
> will need to load the guest value on entry, save the guest value on exit, and
> load the host value on exit.  That's in the neighborhood of a 40% increase in
> latency for a single VM-Enter/VM-Exit roundtrip (~1500 cycles => >2000 cycles).
>
> I'm not saying these can't be passhthrough, but there needs to be strong
> justification for letting the guest read/write them directly.

If we virtualize XFD, we have to context switch the guest/host values
on VM-entry/VM-exit, don't we? If we don't, we're forced to synthesize
the #NM on any instruction that would access a disabled state
component, and I don't think we have any way of doing that. We could
intercept a guest WRMSR to these MSRs, but it sounds like the guest
can still implicitly write to IA32_XFD_ERR, if we allow it to have a
non-zero IA32_XFD.

Perhaps the answer is "don't virtualize XFD."
