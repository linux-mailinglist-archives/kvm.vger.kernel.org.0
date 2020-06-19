Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5FD201ABB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388181AbgFSSuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgFSSuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 14:50:11 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B16CC06174E
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 11:50:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x18so10280723ilp.1
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 11:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ha6V0MaUZXDLydsHZip0ENIDdXPoAfIo+yczgpsUnss=;
        b=nQQ+h/TXqp0KXxUHT9CNHGKUfKS/fIWD/UjV5EN/ZdSZ7oHE+yQIPCx4+VSJ9ABmHu
         cqMCADqtST6j5QEYELq3UzljoZ2tlQo1s59fTVdzkCVyN2KKs0aQSD+tjoNrrzoa5XgQ
         +TNIuUZ3dqFdAocX3NSQJBfygk6+BboSa+ScwnpO13jn1st/t9R36LI1Dyjk5yU1ww0u
         Xzp9JzV3DwhHHJZCfFq28No8YWQMhZbGVyen/029xfNSVFuwxBR0A14lRn8dJ+DYEoac
         DlY1D2SzNEEJIEIeJCEO8oOWShcGsh83uIb46Dq+sge/4lzmjiYJ3dZ+H/X8e/3gl2wP
         6uRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ha6V0MaUZXDLydsHZip0ENIDdXPoAfIo+yczgpsUnss=;
        b=TLFylnPlw1QTPld+nUZaobNlp64HnU5CosU1S4S3pM27ER/xZenQhgsH0b02dxYQOR
         sxqe2F9fjMecp4sIpe2ZhK2WwU3uFP4TsVl8KlxzzW+tyGwtlEgK0zx4/Qxy2hagZ/MH
         fyCfR6CxCR9skGUFwo9egspREseZUpdvCtUWvUWMivQAnB9nM/nWk4scr5pJi53LGBju
         LpWeqIVBPSicnfxp8YoxjiSNHa8QGFa3xeI6LixeDw3SVzMSGx5Vu/72a0MowRLwUoHo
         2fTHFEq5oFUf0smOdbQSecnDcw4PxhSyFGjXPxu//Pfh1/bLtfNNhGmO5al7V0k3uhkz
         9TxQ==
X-Gm-Message-State: AOAM533vwxUpPBjx0o4pb61VrPwsaZPIyIyRWzytneNINBLfhhQymVot
        MqoXR7hMVeV+1sEV2XL9c3IYILDXEEwiFCIfrC6oVK0D
X-Google-Smtp-Source: ABdhPJyRP/aDFiH9VlPXl/u6xV285YzCNLFZ56nP5I4Pim2GKgESRLd6r9bB5LBG9HuUr39G9Xfxv2us4FdFTswQrv4=
X-Received: by 2002:a05:6e02:11a5:: with SMTP id 5mr5149930ilj.108.1592592610012;
 Fri, 19 Jun 2020 11:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200508203643.85477-1-jmattson@google.com>
In-Reply-To: <20200508203643.85477-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 19 Jun 2020 11:49:59 -0700
Message-ID: <CALMp9eRS3FT9QSjTYihBZaZjzMVRx1bYrRaY+jsiOqthyMyv6Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Pin the hrtimer used for VMX-preemption timer emulation
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 8, 2020 at 1:36 PM Jim Mattson <jmattson@google.com> wrote:
>
> I'm still not entirely convinced that the Linux hrtimer can be used to
> accurately emulate the VMX-preemption timer...

It can't, for several reasons:

1) The conversion between wall-clock time and TSC frequency, based on
tsc_khz, isn't precise enough.
2) The base clock for the hrtimer, CLOCK_MONOTONIC, can be slewed,
whereas the TSC cannot.
3) The VMX-preemption timer is suspended during MWAIT; the hrtimer is not.

Is there any reason that VMX-preemption timer emulation shouldn't just
be a second client of the hv_timer, along with lapic timer emulation?
