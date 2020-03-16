Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD11873D8
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgCPULs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:11:48 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44059 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPULs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:11:48 -0400
Received: by mail-oi1-f196.google.com with SMTP id d62so19179399oia.11
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ijs2BAIZQngYJr60lDXDIztUajpq/leFmXIdziG2LkM=;
        b=sv5GzYNwiSh3FeS0FRD8JM9TyIwu42PNDUBqb2XRpr7JWlyBhsNwNdpjQBWBU+l1bR
         WN6v2XTv991YfA+F1LJE3nqARuovbsoRT3n4bJouPNyhgwsi6Fl2xAIdDG+rNfRWzw9N
         BeyPq/wVWSA56Wg5t/+hJhUDQuLoL92VYEEyb76M2cFYJjW/MPndakK64X7XPFlhMDcc
         MnKhzJo21aBHp9XNHOLp4MHAGgi6uP28iPP2tAmsbd4osuHZ1UQKD6YU81yz+a8mt1wv
         KExbnv7HV333vv/xrvNbN6VMES9N3EELGs5ODy6fE7X+/Obh6Cw/X+6S1RJdf6t6o3H8
         OnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ijs2BAIZQngYJr60lDXDIztUajpq/leFmXIdziG2LkM=;
        b=ZkNmb4i4qQDoR3HuTmlWSEJVgOkWtx6W3GUqobof3zUsWF9hJNx+wzqTXN7aE2oVCZ
         EjxHPz0GOQEPG6qrC9rLHsLEJXwpyyKY/Jk3NL6yYiPrHqZNZthoBZSObg+oE55cFOwJ
         Gi7vvCyDB3D486jDjyioFj4VsmPNUZDq3RV4H7zx61PGzUVqi0YiqjPj/ndGTht/Gdvh
         HFs+pVsOonah7kvdlbxXx/WNItIJGrqg8/0ZLxIgdg3DNOK2aPHnIwg3/J2L5NqaF+Pm
         JlwAS5sdguc1dJg4TKi/RroM6kH71SmjFNCAxzESUjquejNvxW0v8Bc0+ms+9bX+zdQM
         AMzg==
X-Gm-Message-State: ANhLgQ2Nv/IAh4DeAPhQx80oQeHtn0Hj/rRI14IjAQxArnVVMzohAj/7
        jUZqM7umbwVmhzadQAgD8pyfA7qLI4W0vPQgPNUrMQ==
X-Google-Smtp-Source: ADFU+vuNAGWfTNfTG7BCG62IAVcWTMGcJnSdFo65qjGsPUVKe0hQPlhhs0R7X5BcJqT9yHK67QFaPQIXmPb88pVygO4=
X-Received: by 2002:aca:190f:: with SMTP id l15mr937814oii.48.1584389505745;
 Mon, 16 Mar 2020 13:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-4-philmd@redhat.com>
 <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org>
In-Reply-To: <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 16 Mar 2020 20:11:34 +0000
Message-ID: <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG accel
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Mar 2020 at 19:36, Richard Henderson
<richard.henderson@linaro.org> wrote:
> I'm not 100% sure how the system regs function under kvm.
>
> If they are not used at all, then we should avoid them all en masse an not
> piecemeal like this.
>
> If they are used for something, then we should keep them registered and change
> the writefn like so:
>
> #ifdef CONFIG_TCG
>     /* existing stuff */
> #else
>     /* Handled by hardware accelerator. */
>     g_assert_not_reached();
> #endif

(1) for those registers where we need to know the value within
QEMU code (notably anything involved in VA-to-PA translation,
as this is used by gdbstub accesses, etc, but sometimes we
want other register values too): the sysreg struct is
what lets us map from the KVM register to the field in the
CPU struct when we do a sync of data to/from the kernel.

(2) for other registers, the sync lets us make the register
visible as an r/o register in the gdbstub. (this is not
very important, but it's nice)

(3) Either way, the sync works via the raw_read/raw_write
accessors (this is a big part of what they're for), which are
supposed to just stuff the data into/out of the underlying
CPU struct field. (But watch out because we fall back to
using the non-raw read/writefn if there's no raw version
provided for a particular register.) If a regdef is marked
as NO_RAW then it means there is no raw access and we don't
sync the value.

(4) I think that in KVM mode we won't deliberately do
non-raw accesses, and a quick grep through of the places
that do 'readfn' accesses supports that.

thanks
-- PMM
