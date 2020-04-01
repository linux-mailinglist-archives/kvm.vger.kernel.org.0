Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE419A960
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 12:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbgDAKSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 06:18:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42598 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732214AbgDAKRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 06:17:48 -0400
Received: by mail-ot1-f65.google.com with SMTP id z5so25088922oth.9;
        Wed, 01 Apr 2020 03:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBqh6Ypzy/m7vLTiZswTsYxCopoXAki18qhKtEVtcHw=;
        b=j9VTKm54KKKt/Dc89MScCIynRAjGob+IOpTDusREKFmLssJHtzxUaQ0vJSpk2LkbQo
         RoqogApLn002HQYkwOI+8MUNkHJoQLfuUgrQX8mzCHVgOIgvb41wFLKX6npdhu2Ej9W7
         DsFRUxac8MBHPv74ccBLZLc8L5zF8mz9Dtpy+V1+j7wG4agEjEx6gD7NN/k5T70cz5tx
         LdPLY59MiE2TNown13V2+moLjaFSwCGzLL4QLtoB9nGJn1vYuan+pTfh0vIdMP8lWCMO
         id68Pu7eaCgp93Y/2w/jJjRECg83F/sueLAuH5PNppYp6kQBNJsokNF1zd/oe9BabCb/
         vdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBqh6Ypzy/m7vLTiZswTsYxCopoXAki18qhKtEVtcHw=;
        b=Geq9KhjYGCbazteZ6TTUBE/VxZNP28C6GbLUUs9Dh6eP1ALO62gV45TRWjH2r6HMNd
         4qeIWmDJRLYhEK2h30cdUs820v+7/Ys8gev5kjaHFPScjvnNpJm4qEdVZ5iN6IMwK7AM
         XuCP54SfLC/MLbTgYTDI08gl0Fv62cYFmdpTiCg7goJyQQyjp4klaAAHSeG9iI7P3Jm1
         FzsOHkSpKjRRjgF1eJbPfYtr6ydFLFDzKmEK27yDOwWeQvL6yuuEz57wyYNfJFobyJFj
         lUM6QPOJ4KrUVVvcKyBrMS6z163Ax40zThT2tp/SKD6FXaGkziK9zGVpC8iesZfgT158
         Thyg==
X-Gm-Message-State: ANhLgQ1huu68aOiLskPl222vce30sY9YXzdhpEg5qcWUs2RRs9IutT2/
        alCZvDyIpiQMEISIorQuYqwZfT2pOq9f1Rs1HXk=
X-Google-Smtp-Source: ADFU+vsqokJDJD0H6ZgmPXKH4DSiupsaCXOmvU2g/iHPni24FR6vnMyN5PaMcdlJ5f2LTgZ7CQNC8SwxSjEdppzlg38=
X-Received: by 2002:a9d:306:: with SMTP id 6mr17124994otv.185.1585736267610;
 Wed, 01 Apr 2020 03:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
 <1585700362-11892-2-git-send-email-wanpengli@tencent.com> <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
In-Reply-To: <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 1 Apr 2020 18:17:35 +0800
Message-ID: <CANRm+CwkdO0dh2cio_dJjs=8XZMz0JFeT=fw-6sUQH9_3jxsYQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Apr 2020 at 08:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/04/20 02:19, Wanpeng Li wrote:
> > -             /* No delay here, so we always clear the pending bit */
> > -             val &= ~(1 << 12);
> > +             /* Immediately clear Delivery Status in xAPIC mode */
> > +             if (!apic_x2apic_mode(apic))
> > +                     val &= ~(1 << 12);
>
> This adds a conditional, and the old behavior was valid according to the
> SDM: "software should not assume the value returned by reading the ICR
> is the last written value".

We can queue patch 1/2 separately to catch the merge window. :)

    Wanpeng
