Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844D6393CFF
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 08:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbhE1GOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 02:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhE1GOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 02:14:21 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED3FC061574;
        Thu, 27 May 2021 23:12:46 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id y76so3232819oia.6;
        Thu, 27 May 2021 23:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nVGCI4tB2+oIhmV2fVTxziePT0APhThyZtPmzEtaXKc=;
        b=Rav1evEBiAikixCNNCjD96VnbkColMfPbR6z5UQhJPsCgFQaNVqPk5sNKa7gxwJaoy
         z6P1Dg0TDn78Jss4t04KGv5lSKCwLaU1hQ9AmYpoAhLFXQv1BFs88+8pOIznmmcIqiVW
         qBBVW8xKcb8ixcRqCbc/V1JHfR9xdN0zTy6GrnS2atbgzv2q25IGno8K4ZWEAtQwKUAJ
         ZYmnZygDxEXI8XcCoHm/Xi8H9+5yKqA0ViN0WrbsEnk3M9IJIrezHqKyhi3RV0Z70U99
         IqxzAVHat35jBSjBRgG6Qa5g5YIYiEkCpc8KiZoa3avZVjEWmQgs4a3BNh+okFGbYe4K
         tqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nVGCI4tB2+oIhmV2fVTxziePT0APhThyZtPmzEtaXKc=;
        b=E5iFThJgfguMiyNfP8wXKoiIL0M5SbyWIRkCzwe+U0mAIzgBnexfUTfqUmJLhDp9+5
         E67aFRZD9k74+qeeA6F/Ykb6h1p95iyBFnXws0YW3u0lbUuCJId1pcTiWomtLFCpddWh
         slYS1hWJQ2Sv71HApl8IAA5ZdaK18vO2vTISryu2Pc/ZJWz/V1ti+zQWVJUKvceYG8BC
         aUVjT4jGx6DqWxWe57Es5a3LvIBkpNE7MjzTCb2f48oI1L2fGlDqRqyFMXxg5UL8OXeM
         v8knJxFKQJuN2oKVskX12WGi1Pc4WjM5wo0CAogjTNO8cIrA21oOnioez+uXVq8A6HmF
         CXVA==
X-Gm-Message-State: AOAM532eYdu+RnUy8EXoGwwgnYpNWMkk0Ml/F+sD5aLsh958MnB48xEa
        w1G9NSn1ekfs1D6Dxmn1RK8Q9VpcKUU7A/xRe5c=
X-Google-Smtp-Source: ABdhPJwmJI3mf+Tm5OXHX7Fryo62o4IkMKGoCX2cYWoHwEg1bGw0O3F3jYyi5Cr0lU5ujgwiB16HZvMxOzHuTUESkgk=
X-Received: by 2002:aca:4343:: with SMTP id q64mr4865314oia.33.1622182365818;
 Thu, 27 May 2021 23:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210527173358.49427-1-jiangshanlai@gmail.com>
In-Reply-To: <20210527173358.49427-1-jiangshanlai@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 May 2021 14:12:34 +0800
Message-ID: <CANRm+CypKbrhwFR-jLCuUruXwApq4Tb62U_KP_4H-_=7yX1VQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: always reset st->preempted in record_steal_time()
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Peter Shier <pshier@google.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 May 2021 at 14:11, Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> st->preempted needs to be reset in record_steal_time() to clear the
> KVM_VCPU_PREEMPTED bit.
>
> But the commit 66570e966dd9 ("kvm: x86: only provide PV features if
> enabled in guest's CPUID") made it cleared conditionally and
> KVM_VCPU_PREEMPTED might not be cleared when entering into the guest.
>
> Also make st->preempted be only read once, so that trace_kvm_pv_tlb_flush()
> and kvm_vcpu_flush_tlb_guest() is consistent with same value of st->preempted.
>
> Cc: Oliver Upton <oupton@google.com>
> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")

It has already been fixed by commit 1eff0ada88b48 (KVM: X86: Fix vCPU
preempted state from guest's point of view) in kvm/master.

    Wanpeng
