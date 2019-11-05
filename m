Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207C4F0966
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfKEW1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:27:39 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40832 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbfKEW1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:27:25 -0500
Received: by mail-io1-f67.google.com with SMTP id p6so24601250iod.7
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 14:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1L5hejAwelBSI6ftPQGE8SHNcJP1/ApWbURo1gX+OY=;
        b=DgpQ33kNaYbORqi/+Bnvaur9WFdvkj58cHtsUyH2UNC89wce0xXJxYpYoKEcxn08tX
         Ym09MNBnnSIMmqV5OHjos0qc0O04z/1IPaHZcrfKIhAqso1sYti/SWGAdDbqFYo3Tc15
         ysFyDkTKZbOZGvS1dfwSuj4u0sd8NVbxOwy/+c8anMezJqO/Q6AjovxWUPRZk2h2LRCh
         ynBUL3oqU8W8ukHUueg1HDlAQu0MCVDKKkydB+kal1wWF2cwarnGN8sMf3eW/C/9hjyA
         a3qhqCYdBGdhDSjto5KcDqkwIWwau5+mTLQXwosRo3L5A8l0Th4hzdikr+T5Eno0Yvd2
         mxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1L5hejAwelBSI6ftPQGE8SHNcJP1/ApWbURo1gX+OY=;
        b=Q4wGLHHDUj+c+BrKT1FWmkQ37femNd7rH2AtzT2d/lwkkMhZoyK0SVd3mvk+/aPxcO
         XcL6EPRTL7VOCl3ilEoE8orb9WNiloEY7P6ByGk9AuLnpCi9YfVidYfBmQ/crdppO98g
         c/fsqc5eD4M9ZtKYWYEU2Et0MJ3mSaY7I4krtHbhGqGmw8Wl+Gxz15cB3xWxxMHupMq4
         ODN/nfQiDUBpl9KZZbqo9CDqAdblS+4ODSJ+2KO8o/NPeKoV4s1H1Wnc5PWpeobXaMaq
         3lhjEyB6LpfM7q2rqJ/+eweCjTMkn4l6Qudb5OLZZ4gB+Thu7nnTz0GAqjDZdj5/pOue
         kAFw==
X-Gm-Message-State: APjAAAUehLjk78o2btmxjLIjrIFebnEYzwz21wPYaihF4csN93SV9AXK
        vskngoBREpUr0WV3Ob3D/Xr0hYuCGmybTBg40z95Dw==
X-Google-Smtp-Source: APXvYqwfJik91G8T1Zw6oWcsrV2+ViP9skh2XqVaPWIh1V+/j/uuCpPvgPL3QpH+ZWnsRdtkbgO35o8VnExGbhfmE3w=
X-Received: by 2002:a6b:908a:: with SMTP id s132mr30981149iod.118.1572992844385;
 Tue, 05 Nov 2019 14:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com> <20191105191910.56505-5-aaronlewis@google.com>
 <E7BEE4C5-F129-43B2-A70C-F7143E8665C9@oracle.com>
In-Reply-To: <E7BEE4C5-F129-43B2-A70C-F7143E8665C9@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Nov 2019 14:27:13 -0800
Message-ID: <CALMp9eQ7Z7oVADx+f+2H38=-EDYw-fRqdvOUudRpPXP7ziHCUg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 5, 2019 at 1:58 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
> > vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
> > TSC value that might have been observed by L2 prior to VM-exit. The
> > current implementation does not capture a very tight bound on this
> > value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
> > vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
> > MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
> > during the emulation of an L2->L1 VM-exit, special-case the
> > IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
> > VM-exit MSR-store area to derive the value to be stored in the vmcs12
> > VM-exit MSR-store area.
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> The patch looks correct to me and I had only some minor style comments below.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> I think you may also consider to separate this patch into two:
> First patch add all framework code without still using it specifically for MSR_IA32_TSC
> and a second patch to use the framework for MSR_IA32_TSC case.
>
> Just out of curiosity, may I ask which L1 hypervisor use this technique that you encountered this issue?

It's a proprietary type 2 hypervisor that runs on Linux.

> -Liran
