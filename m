Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD44A8A30
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352884AbiBCReE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiBCReD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:34:03 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947FEC06173B
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:34:02 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u15so6473896wrt.3
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c53te4gb4gbQ2BA9zEe7ibUShf/XoqZxMo0RjmKCsS4=;
        b=PR/a8+x78qbvbyaHDAU3p5hE/7/RoI+gQzvv1o2U09FLV+kWLGCNNZ2fVy4y4j+qnX
         Q+y8lLK3rZxA3bMRX+y/XjfwazG4/ulNOMg/rZqoNRJV2UAfn7K1skGS4YVhXrIaBUdJ
         zaCBmsbQARI910hgblR2GJkNV6y/yimrKnjp+pAZuzkXx9J9JsF15eFxGjzIHvSJ5k4G
         WZ9U2Hhtvz7mgodvtg1ir5vdp7jt7pinWUDqN+RpCiaKCwMSVjqIBYLUKXK4r+KXKoFB
         8enYxo0LoQr+p3anbqvtABuh9EydkrwzM/lB6fuwd326H3xgiaKnTfomOAdYrUI6OK5q
         jaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c53te4gb4gbQ2BA9zEe7ibUShf/XoqZxMo0RjmKCsS4=;
        b=TcpOgkqvD2lSKa/oWi6qbsNs9q9XRPkYJSmtjUc/cUg8XUBAUywjVtSrM8UxBsWvcb
         1XqDJ4fpXGvqwj5fY68FyaGJDdwL7sY9hwhhfZNwE3cs6wmNpMOgNUFqbWZMPmTSM0la
         ad2J+2k/gYIFpuAhq9+1laLybtn25TcQwHqEwEmBg0xHzvi3pbIeyn6GvrXgqJKnE/dN
         LzF9k1GtVMliUtmfDQU1FWFFHgEwB8o9apEGts7r2AXIJEhBS5W8uJJMaVXKKu2c+2uW
         YQfqRjgdkZ2DGNtFSd+0gNWPUFDfIdHcKO5gubdiO2IxEtUnKg4Ji0mIcvXzbl8T++pi
         mtLg==
X-Gm-Message-State: AOAM532SiwE/NeEnnj14Ps12MayNSAUEbkUVfNbGB0urNCTfQNQCU7gf
        B7W4DGcVsTODSA6kmbXFXQ6/3bw//gBFM/7LY3d0Bg==
X-Google-Smtp-Source: ABdhPJwGA56QJvpioobn/jD2H7dobA3RBTnANrtOSRHF6t4f20TsPoSgNhxAwWkp2B5F9XVj9iHWYdx5ogNKVw2WGhk=
X-Received: by 2002:a5d:550f:: with SMTP id b15mr19836625wrv.384.1643909641056;
 Thu, 03 Feb 2022 09:34:01 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net> <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
In-Reply-To: <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
From:   David Dunn <daviddunn@google.com>
Date:   Thu, 3 Feb 2022 09:33:49 -0800
Message-ID: <CABOYuvZJrBkcr5MCosVtq0+om5=kwcXWcFRNGxDyX_JPwpKubw@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim,

I agree.

It seems inevitable that the demands on the vPMU will continue to
grow.  On the current path, we will keep adding complexity to perf
until it essentially has a raw MSR interface used by KVM.

Your proposal gives a clean separation where KVM notifies perf when
the PMC will stop counting.  That handles both vPMU and TDX.  And it
allows KVM to provide the full expressiveness to guests.

Dave Dunn

On Wed, Feb 2, 2022 at 2:35 PM Jim Mattson <jmattson@google.com> wrote:

> Given what's coming with TDX, I wonder if we should just bite the
> bullet and cede the PMU to the guest while it's running, even for
> non-TDX guests. That would solve (1) and (2) as well.
