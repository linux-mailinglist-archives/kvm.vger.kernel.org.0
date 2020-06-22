Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB93E2043B8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgFVWgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731012AbgFVWgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:36:20 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72B1C061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:36:19 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x9so3712651ila.3
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTZs7mzVzZVgFAWfMkwW3XTu2W9gF6QVlRtShyncOCg=;
        b=iCSfFI7e8KA4meqcOm1uNhL8mS9RRe1krFjAARG115why0YPFLdGqcFYMHcBHrFB3+
         ax9cuNGSYbAVg6pQJXSZhH5q2YI8gzwT8cY4gzRrdjFAYIMMA/MJVV4uXcT2992Kk/kf
         VVLqO3ZJqMBZJu/k5lkKdneVc+zGZgD69lAXa266lSswVVzIqF7mQuHOI1+tLw7mXQOw
         +DtHsPalLpvRaq89e8Hd3V4mS42ZszCi06gGjHSGD/YtGg+ttECn3qA3FKSrsrEgI1+n
         jOxNNnF281+3eTgKxKi/W8/adHSSBxa+PYnAjcuamViq0j35GpRuC/glpYhc3W7IOTUv
         GXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTZs7mzVzZVgFAWfMkwW3XTu2W9gF6QVlRtShyncOCg=;
        b=HCX1ifiJfE4p3ZPAL7i1YFpw38GFW2oSxY1NvFKFpXw1wBl3xMAB25eklfpR/sbn91
         FCvQiASOPYocNuZcM2msJFpltuggp8UXikuZfWY/vQ6+QpFdofFLqpFYpCIlhiOcrREE
         kYFyERFXYdMU9jgAWrqK2mcaPO7sRjMCdxmryUGOgQGdyML0gbwbnVKja/ZiCQDl/B9t
         dluX8D5G4oD1ti6aXVndng3tEXsmo8pPgjiqAsPCX2nyw3rCTjftxE0O5Jo2+ayhho1d
         EsyZfzfGuVGjxL2USEt0rcIHr+QrWfCzXyjyvUwVsCknBlVL2rbMw4WU/25HrqLG9QhC
         aWmw==
X-Gm-Message-State: AOAM533r2gNnzyr6HVk/SYg1KQrlVGKi3LbLUmkIEyoJk4jDDI1IECPZ
        FJSxrm/12f68/hkF/yCNaOzklQP4BScOiEj/ULzkMg==
X-Google-Smtp-Source: ABdhPJzre813Rv3tNnncpTHkmdJJKqlJGFZi5sMvOBFyt7Yk0vXZpruCn/KT9U42OIgqmgwayP3eQxom6SlDqtb21EY=
X-Received: by 2002:a92:aac8:: with SMTP id p69mr341869ill.26.1592865379073;
 Mon, 22 Jun 2020 15:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200615230750.105008-1-jmattson@google.com> <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
In-Reply-To: <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 22 Jun 2020 15:36:08 -0700
Message-ID: <CALMp9eR4Ny1uaXmOFGTr2JoGqwTw1SUeY34OyEoLpD8oe2n=6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization generations
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/06/20 01:07, Jim Mattson wrote:
> > +             } else if (vcpu->arch.this_tsc_generation !=
> > +                        kvm->arch.cur_tsc_generation) {
> >                       u64 tsc_exp = kvm->arch.last_tsc_write +
> >                                               nsec_to_cycles(vcpu, elapsed);
> >                       u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>
> Can this cause the same vCPU to be counted multiple times in
> nr_vcpus_matched_tsc?  I think you need to keep already_matched (see
> also the commit message for 0d3da0d26e3c, "KVM: x86: fix TSC matching",
> 2014-07-09, which introduced that variable).

No. In the case where we previously might have counted the vCPU a
second time, we now start a brand-new generation, and the vCPU is the
first to be counted for the new generation.
