Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801422FAE08
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 01:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732040AbhASA3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 19:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730466AbhASA3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 19:29:06 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3026CC061574;
        Mon, 18 Jan 2021 16:28:26 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e70so2710023ote.11;
        Mon, 18 Jan 2021 16:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wJjJQpv3zQqcv3uCU8536qf6Iw47RHtSffUOvoVprw=;
        b=XWpGnsaOojqGEyi+7+wWAeM+3rE7JCj0Ahc+EMas1/fVPIRTMSP3u5Qq34o5L5ek+J
         AzgBltYF9/pOWQqjWKKs2VA9dAmaiI6fxyUP9piwZ9qasgiJzWE582agKsEhMN9f60ir
         z+ZU9WI3FKLi+I9jY65mi3mgqqphK9tiuwpnfGfUQSTOmsVOM54dBC74bcPXGBbmWw1U
         O6jKB/ztHAhkwIW1faqT8yczrNjewFnoaH3gTyYaGmSDYZ9qQ+B/m82aPk9UTQAoucNJ
         S0qM+FjwM9CdSIXv77OZX9rzPOF504EDbTvfeEf0Z1g0354A0nV1mGzjuGTS8lHWODG3
         dXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wJjJQpv3zQqcv3uCU8536qf6Iw47RHtSffUOvoVprw=;
        b=QP+ct3IEX3Rv1LGtsHKECwuoyxz5/jfdQyEL9mFM4xfwEHho9zNEKs7pBMmGrVCGWn
         PKfg2DGMCKcKTaktDlBCyGC1QtfgsD4Jp/rRzQtvsF52+nGMAP2de/Nwo+y7nVBoNxe4
         wek0mKQS/q8/x/L9d6LZYJejVLHk53Tj7JoDC2QIFAMVRFCOvEBL8JfgPbqoFO0zd0CC
         cyXHwthHwNXzAXWg6CM/KpHLdKhfzVN09jlnvX0BuNWlBzAtceBoNmaDn9ZoyYguK5tD
         Fbjhi/E0siaDx2utFvTrRtjVhxawhzDAxb/LzsMfKjTveriQjtTE67miTMQKpQSBIK30
         LHqA==
X-Gm-Message-State: AOAM530I8O7a6zERJLd3IISG7rFTEXAN3px8yQHxJFB6Pmbst+B2oeMF
        F0kPZrxzIDVIS33smJpxQ4T9nBvU5+I44qLrGeA=
X-Google-Smtp-Source: ABdhPJzf2Mb3bZJqnNfYiSxy/MgzylI2hblgvSlVksHTBsCwNBn4XrOwd5vQxuATI8qdqAKXWx3uV3zWSxaFkLa4ReQ=
X-Received: by 2002:a05:6830:15c5:: with SMTP id j5mr806012otr.185.1611016105677;
 Mon, 18 Jan 2021 16:28:25 -0800 (PST)
MIME-Version: 1.0
References: <1610623624-18697-1-git-send-email-wanpengli@tencent.com>
 <87pn277huh.fsf@vitty.brq.redhat.com> <CANRm+Cz01Xva0_OjTpq3Wbyppa=FZzxBwZJCWJNicV3eCrzpdQ@mail.gmail.com>
 <67171a65-f87d-8b60-22c6-449ed727f6e0@redhat.com>
In-Reply-To: <67171a65-f87d-8b60-22c6-449ed727f6e0@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Jan 2021 08:28:14 +0800
Message-ID: <CANRm+CxTOP3m+7LFjNgVUqSSXuvAtBANX_a0tqA-wY+8fMfndQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 at 02:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/01/21 02:15, Wanpeng Li wrote:
> >> The comment above should probably be updated as it is not clear why we
> >> check kvm_clock.vdso_clock_mode here. Actually, I would even suggest we
> >> introduce a 'kvmclock_tsc_stable' global instead to avoid this indirect
> >> check.
> > I prefer to update the comment above, assign vsyscall pvclock data
> > pointer iff kvmclock vsyscall is enabled.
>
> Are you going to send v2?

Yes. :) https://lore.kernel.org/kvm/1610960877-3110-1-git-send-email-wanpengli@tencent.com/

    Wanpeng
