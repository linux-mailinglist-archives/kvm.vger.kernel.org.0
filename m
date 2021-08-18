Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2653F0D1C
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhHRVIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbhHRVH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:07:58 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63575C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:07:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x16so3465765pfh.2
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwOBCn06TMZp9/KiQNhcPCCoJYBDD2eVjvlRxAvYXb4=;
        b=FHcs1Em0hv3sy2oL9DRDduqIWHymNzWWGDKUh1cGcBpzbwOAgQ2qV+pCau8hiiLRog
         ThoUyrgJMBA8bC5BP2v2Lu7MKhhJW3tNa5J2i6OTqExsFKf7jEekYrXlGi82ZeYih3mU
         247c1eSFpDfFvs2hzHvF5owMPlvNNsopEXIz3w9kVz2o8c/zp3bhiuANwvAKTy1SjKbc
         Ji9oRIzoraO6THCTblL6xWiAvrvRpwvZ3lJShrVcEkzkA7xnJ21FHoPQkRhU87nkqHQC
         u1Dp1ggIcZUgKErF4/AtcHNBxhQLaPVORGDAuJd9j52MZJ3OJcKBW+7O7U77YKgaI0uz
         /8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwOBCn06TMZp9/KiQNhcPCCoJYBDD2eVjvlRxAvYXb4=;
        b=VfqC5E0D6fCRZfaE283OuLpiTI9Za1h0Du2hUK1EjqDKuz6OOWK2vVU7M+FMb+TNdW
         KZ3hGEUYbm0L52p1htldMYc/p+APUmY0ypInZymjSL56XC9HhPNldR6qsUs9lO6h792H
         4CCJi8uc19Mgfwv5Rrf9RkbNDBr6qYc5/Pn7Xz2Gt3KUkWoucDquTp6hGUXafeZIQorh
         p/YAEmMhSsy8QTdzUITButYeQ15qVqVtBu5EOQBllno/SfVLoC11peGcQn0Fd83vhU7G
         WZmC0sRUGZPmoMOalGgRjtIQq05/cDLLPvl5ITrozoDdpXWxMThbJtp2VW5E9PYB893Q
         n1QA==
X-Gm-Message-State: AOAM530QK815VKbkB5uMmYzj6jgZP/VA7KROK+dJpOHls3g/blrK/+7l
        opUzyfUIozd6r2cOCiTCboTDv1AY73IFcsAmPMmt8O4Iq2I=
X-Google-Smtp-Source: ABdhPJwQbo1qSO1Kt2SFCjnh3NIe4RjXa4w0iy58aJZ1cKvE55oAi7V3ty3Wx1h1jK7kzqd/XOYiU/phs+5SpGbInag=
X-Received: by 2002:a63:ce57:: with SMTP id r23mr10716345pgi.271.1629320842594;
 Wed, 18 Aug 2021 14:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <1297c0dd3f1bb47a6d089f850b629c7aa0247040.1629257115.git.houwenlong93@linux.alibaba.com>
In-Reply-To: <1297c0dd3f1bb47a6d089f850b629c7aa0247040.1629257115.git.houwenlong93@linux.alibaba.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Aug 2021 14:07:11 -0700
Message-ID: <CALMp9eRy-ck4hkW8ZqE2NW1s5rq_dWEr3ZL03At=h19SrhCXmA@mail.gmail.com>
Subject: Re: [PATCH] kvm: fix wrong exception emulation in check_rdtsc
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 8:36 PM Hou Wenlong
<houwenlong93@linux.alibaba.com> wrote:
>
> According to Intel's SDM Vol2 and AMD's APM Vol3, when
> CR4.TSD is set, use rdtsc/rdtscp instruction above privilege
> level 0 should trigger a #GP.
>
> Fixes: d7eb82030699e ("KVM: SVM: Add intercept checks for remaining group7 instructions")
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
