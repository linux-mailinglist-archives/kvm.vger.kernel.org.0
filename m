Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9CA23169D
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 02:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgG2AJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 20:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2AJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 20:09:58 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C531EC061794
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:09:57 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s21so17836362ilk.5
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NIt8V+0Ly8zCDHiK1shQ9ILtxkb0CmTmo030ThJYXRc=;
        b=At1MN+FzIe1tFpSFrYfVBPnrEMgocxF1GxQ6l661JXfQUSL09B22WGVDFknoRIDEIf
         tRG+xOoU3FZZZMnJGjfuPFPl8E3+qbBa1Vlm4WmIsAbjoTRHML/YfD3T/yXLluhZFamt
         03u7pLSnNw9w6hrsyoPycGKgrdJ8a0GfGb+EJqEpgT61mXDlTtQoyLi6YAldXQP6hk2d
         BEHoVxL9MInXNDCyKtRve/qoG6kRFZAXukmBRrpkKEederyrHc1E92VdClFR/zAuOXzL
         H82qr89vU69GvNOybrP5Hr/3yHj9zyTZjsAPIr9a735oJjC5eCGbhb+/saHV//RnJXPj
         cvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NIt8V+0Ly8zCDHiK1shQ9ILtxkb0CmTmo030ThJYXRc=;
        b=TJBiQB8rkm5gtlVf8BROmeXvZeHr7VrK+M9Ssw2uzNiGBQ3zy67jMfVeX/esfxEtg2
         XJuwZcXfLZuDQQ5A7bBFWBAzDWpgmFv5fxYqH8SG6nF6XiiEJ1jgguYMjgLvLlwq14bm
         4LzjroReS1uSBtZXOS1Vi7ycXGYw0GsXA+oXFsD/zvNR+x+Yj1O8FZRK1SBkvoSkoP1c
         JKtZg7Bpkc2V0AaEW/V0qUKVWg4OGFxesf9orrTtHLDjsy8x2GsRwEoZScVTsm4seMar
         /iskVMpldSrR1IqfXdEuZTf17ELar2NdZ3O5UkXsrxbcImp9N7XCMNJ3HBLjFy+w2cvr
         fV9g==
X-Gm-Message-State: AOAM533+g0WsLJXd8XHiIjMCSzEldtt1FOSZMzt6dWEysvwMYdaTwhVz
        3bmgC2/M47/9LJSweBVDoXaK0wu1vxaobH05wUNi8g==
X-Google-Smtp-Source: ABdhPJxyhD76VhGtYfRPQiK8bjnt1QDL1vQFerPzksCcZjDbHKglJfD/550b3SdXVkkWhSkJmPrnLJQ0xSN4XUuyCTk=
X-Received: by 2002:a92:790d:: with SMTP id u13mr25673361ilc.26.1595981396870;
 Tue, 28 Jul 2020 17:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jul 2020 17:09:46 -0700
Message-ID: <CALMp9eTkGtk=baceQs7ATY6FU55+ubSfO9e71fzwiqO8oTH2vA@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] SVM cleanup and INVPCID support for the AMD guests
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

On Tue, Jul 28, 2020 at 4:37 PM Babu Moger <babu.moger@amd.com> wrote:
>
> The following series adds the support for PCID/INVPCID on AMD guests.
> While doing it re-structured the vmcb_control_area data structure to
> combine all the intercept vectors into one 32 bit array. Makes it easy
> for future additions.
>
> INVPCID interceptions are added only when the guest is running with
> shadow page table enabled. In this case the hypervisor needs to handle
> the tlbflush based on the type of invpcid instruction.
>
> For the guests with nested page table (NPT) support, the INVPCID feature
> works as running it natively. KVM does not need to do any special handlin=
g.
>
> AMD documentation for INVPCID feature is available at "AMD64 Architecture
> Programmer=E2=80=99s Manual Volume 2: System Programming, Pub. 24593 Rev.=
 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537

Very nice cleanup. Thanks for doing this!
