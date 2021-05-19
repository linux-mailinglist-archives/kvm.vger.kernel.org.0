Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C28388685
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbhESFb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhESFby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:31:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47743C061760
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:30:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2922285pjx.1
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CgnXGca0Sj0Q6Z+AnySOLxHV/ucQfpgB5ZEXSsAu5Q8=;
        b=bRC23/Mld4+4uILCqIPUnHY2jHl3CZi3T7iD0gSmsxCdlKa05Ao/B/UgkGOeuoQmhp
         UOnTn2IOAPVgXeV/H+pczFQeylg5HouR+ULoN6jgZbwfNVMRVqdMcUZP5E9QE7gSwRzn
         8CsDFHcCPl7Y/Ntt8X9xFJxRDFYZQIP72O7S4Qa1xJC33t60nkpdulyRsOT+vhZO+WWa
         r85DllRRgfaoVrB3lppKzk65uLwvKBRSRaiimxmxOSiN5lyKU0u3PKJhfjBvweEKYt+V
         Nhq7jkRTaaUO/De4e1eAxoM5GMcK40CiK0mjpRX7n+jSsEgF2OJYLR9N8gW5liz5qSR9
         o98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CgnXGca0Sj0Q6Z+AnySOLxHV/ucQfpgB5ZEXSsAu5Q8=;
        b=VrthnemS2+qw6uV/X5vxuP5T9q63qxusuwdycVJAC9yAIEsL3ac8eTn6sJtVW0dz6M
         N/AlSjDP3uebqmHaZrOscaweeaopmugk7JNmFmmpROSy31es8koMYKg0xW6dxQWDCe1c
         i/8Fp+HgBrBAomOoAIEXdcFYIaR18EZXa4dUZVZjK84D4X7vYeADAhqTGVRzBL+lFXrc
         PkkrYriwgJikMTlDYJhPmjpARzj5+wGnlx0e/zJLFO0EIA+CgSySrqyBWYi/FVgdT/AH
         YDukb+TAXcoWEKkc6qrcZ8pslKdeZ8jY98Hn1Xy2ovRHf58rakKcIsSB7zQwE/HiBB/d
         WFTw==
X-Gm-Message-State: AOAM530d/VUwwYgkt1lG3lOH7FCNj5X07OT2JF24SaB7ODTVs3m2xtL3
        /OI3GQdkYdgLceC4CVAG9dtGxGHoXTQauW7kOPNEmQ==
X-Google-Smtp-Source: ABdhPJxhtMPkfKErvsjTiGyK8JketB+r2z2FH+qqg9oXaQ6PmUAru4AZI1A9bFUDH0sBGcYWdWJLONefMzBmQySvzhQ=
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id
 m12-20020a170902f20cb02900f0af3dc5d8mr8741262plc.23.1621402234545; Tue, 18
 May 2021 22:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-2-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-2-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:30:18 -0700
Message-ID: <CAAeT=FzRbCLT1AKE4QYbG6LwUhgtRfgjRDPVqsu0Y8QU+USHeA@mail.gmail.com>
Subject: Re: [PATCH 01/43] KVM: nVMX: Set LDTR to its architecturally defined
 value on nested VM-Exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Set L1's LDTR on VM-Exit per the Intel SDM:
>
>   The host-state area does not contain a selector field for LDTR. LDTR is
>   established as follows on all VM exits: the selector is cleared to
>   0000H, the segment is marked unusable and is otherwise undefined
>   (although the base address is always canonical).
>
> This is likely a benign bug since the LDTR is unusable, as it means the
> L1 VMM is conditioned to reload its LDTR in order to function properly on
> bare metal.
>
> Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
