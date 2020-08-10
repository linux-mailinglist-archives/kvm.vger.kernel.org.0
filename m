Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8B2412AB
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgHJV7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 17:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgHJV7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 17:59:18 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE63C061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 14:59:18 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id o21so10324818oie.12
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 14:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vlEq2Dpha15y0ydLscbk8ovts5dUH9uys7Vvw2mMr1U=;
        b=CQdU0Zj3KV4YFfYLuNp2l0iGi/XCf1EB3qgvYjBRajbbDv1b/6CfLGKGP/v2RPGOw9
         FJbM6Kuz3rbx8chfTXiQeM4dfr4IdX7J4PnTFUVc0vDgH6m2inCY5hhsESUKG+rsid+D
         BiVgujInT4P4N8Im2b3QnoeQL//flLZ1O/xr3ir4+Bn4yXSvPLwUeBqcF5LoR7IXG+T+
         r5/cWeSQBAo/FX0LcRC3+MZ2zy+dyCE4lNsjNKsD/D/7JpElMIh8kRkoE5/5yQvLBSg/
         VxjSPrwqMvH5QYS0TsWozDgC8SOiTPWCMTIp87Uq9HMbQp5XzxY3YY3ojd1IRngkC9pQ
         Z5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vlEq2Dpha15y0ydLscbk8ovts5dUH9uys7Vvw2mMr1U=;
        b=I4XOvKn/qqHGpUeRMFmPr59DkQTeb7j0zSvlUxhiAowVuRTB0rDZiUALJ3RihN8it0
         B10ib/9gg5i2rjLdSHhWFMkdx/KnVi+wAXJ8+OhFfJflq+fJCZh8TX3R1mjwN1uz+t12
         2Y8Uvdw6UcQqEy+bLU09umWoqWJm/iKr4JEIRtrQlEwRcsu3jp5V2ehdtflS/+KnKqY9
         j7hW4V4zuJKxh5MYm2x0FBoroP8qw0TU6EqEeeX5bCuerMTJB+ZobOZcHx3ApaXOobC6
         p3LDxxz/f44NUAfYGWKrvLCvrxUKm4r+nqjwAHrvK2QUlAVPvgoG80zXK7YFJw2WNPap
         i2Gw==
X-Gm-Message-State: AOAM533abnKld1x0evLnRedSOeGMOV21gHs0t+lHEvPx9nVljRbdRGuZ
        Yjag2kXO6JgEdChwD8lF/rPoQGt/eqmKJKExEy7kWw==
X-Google-Smtp-Source: ABdhPJy0vpqdRLdZh/x8lBYNreooVNRhS2sxNdUzPpyKoDlQfzP2uwM8DDVmt67XNtHjMgNRlUh5dKt1mgJM/sH70KE=
X-Received: by 2002:a54:4795:: with SMTP id o21mr1141052oic.13.1597096757767;
 Mon, 10 Aug 2020 14:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu> <159676126090.12805.5961438692882905158.stgit@bmoger-ubuntu>
In-Reply-To: <159676126090.12805.5961438692882905158.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Aug 2020 14:59:06 -0700
Message-ID: <CALMp9eTa4TWVJj=i12WwyGCju_or-xnLpjxmJTu=KC9fq-XZJg@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] KVM:SVM: Enable INVPCID feature on AMD
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 6, 2020 at 5:47 PM Babu Moger <babu.moger@amd.com> wrote:
>
> The following intercept bit has been added to support VMEXIT
> for INVPCID instruction:
> Code    Name            Cause
> A2h     VMEXIT_INVPCID  INVPCID instruction
>
> The following bit has been added to the VMCB layout control area
> to control intercept of INVPCID:
> Byte Offset     Bit(s)    Function
> 14h             2         intercept INVPCID
>
> Enable the interceptions when the the guest is running with shadow
> page table enabled and handle the tlbflush based on the invpcid
> instruction type.
>
> For the guests with nested page table (NPT) support, the INVPCID
> feature works as running it natively. KVM does not need to do any
> special handling in this case.
>
> AMD documentation for INVPCID feature is available at "AMD64
> Architecture Programmer=E2=80=99s Manual Volume 2: System Programming,
> Pub. 24593 Rev. 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
