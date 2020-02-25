Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147E916BBE0
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgBYIbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:31:17 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43523 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgBYIbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:31:16 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so11305783oth.10;
        Tue, 25 Feb 2020 00:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T1n3ktw5bPHodKuJWkYqa7LcyNgwBKRduxXfO03KSgk=;
        b=PPtF6e4g3S/sEpHTe6yWznV3pLLYn4jvkZbGYyT1LHamFseFQCg8aHGs+syAQn4Aob
         Jp/0iz1n5tZPJA/5IgQuGt3N7bLiUJu3Z2f4/Ris/HNhsLyhhwJj2FrAiYf4I7NPik1H
         8L8rblY9IPH4PCf2m7g3P+nz8hgRIF4mVCqFLe4y2NKoRItTH/FfKV+MnAGzNzICM2pG
         o3cyqKEdTSqBbE83IiBv9W4bvAhNOHaWnmYq1gzjBjvecwlPl4PXypHPdpW1A8JWPD3P
         e8GFfxR5Be8JyXtDUq9rmisQfNyeZvaUvAd97/3q+AoazVyESRbYztISKWjfHprhhJAz
         b9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T1n3ktw5bPHodKuJWkYqa7LcyNgwBKRduxXfO03KSgk=;
        b=V6WcyjC3umXuqSCikxx3T32ZJ6Ce2ruR6+MlsxG7aCi3zi384CxMehZAgY2G5rQtSV
         mrh591uOQ0q5z4eY6+LX9yA0BsaWbY5xUkJMWJsh7MEZ3DlKEpOba6f7OFc8vvvjX+O1
         8TFf7HwPeIcVh3NwaoIHYI+0tVWlXBgyf1Ef2EVkjZNB74puIOjLL0uVQCxD0/9sXXh9
         tlBa78/D+aSDQ2B3nNPmCsjhTcfgfBuCcv6Bf0T8Sd4OAVB1hDzqgpHpYZjCOI6p0Spv
         8kiw0i/Se18YRhHd0rvlBcO9cnlOt8Z2/4lMmY0yInTHIopHm6aGkBeI/RUhrVJE0s46
         O/fA==
X-Gm-Message-State: APjAAAVYn+ClDfUBiWCVWt/GsvYSuioZxrcmzGwr7n/IvYlX1UnW0Ntk
        dwOx/2Ti9OOhPNtAa9q9yksW7zTyA/TCTZF5onZbsTJh
X-Google-Smtp-Source: APXvYqwf4tYE7xMxbpSLRtRLqsNTEz9tmoizRdcTISzmz8MO4Eb3Ofc4QxUWwhDN9FZG8XrYsxeYa9tB/Itt2Wv2G4s=
X-Received: by 2002:a05:6830:1011:: with SMTP id a17mr41220600otp.45.1582619475111;
 Tue, 25 Feb 2020 00:31:15 -0800 (PST)
MIME-Version: 1.0
References: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
 <87zhdg84n6.fsf@vitty.brq.redhat.com> <CANRm+Cyx+J+YK8FzFBV8LRNPeCaXPc93vjFdpA0D_hA+wrpywQ@mail.gmail.com>
 <f433ff7e-72de-e2fd-5b71-a9ac92769c03@redhat.com>
In-Reply-To: <f433ff7e-72de-e2fd-5b71-a9ac92769c03@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 16:31:03 +0800
Message-ID: <CANRm+CwfaZHHPyxC1qz_uq6ayw6vg2n0apLPoPH5dKXyy4FLeg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Recalculate apic map in batch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 16:07, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/02/20 01:47, Wanpeng Li wrote:
> >> An alternative idea: instead of making every caller return bool and
> >> every call site handle the result (once) just add a
> >> KVM_REQ_APIC_MAP_RECALC flag or a boolean flag to struct kvm. I
> >> understand it may not be that easy as it sounds as we may be conunting
> >> on valid mapping somewhere before we actually get to handiling
> > Yes.
> >
> >> KVM_REQ_APIC_MAP_RECALC but we may preserve *some*
> >> recalculate_apic_map() calls (and make it reset KVM_REQ_APIC_MAP_RECALC).
> > Paolo, keep the caller return bool or add a booleen flag to struct
> > kvm, what do you think?
>
> A third possibility: add an apic_map field to struct kvm_lapic, so that
> you don't have to add bool return values everywhere.

This apic_map field is boolean, right?

    Wanpeng
