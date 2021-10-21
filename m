Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0F6436918
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhJURfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhJURfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:35:18 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE75C0613B9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:33:02 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so1305279otr.7
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kvYcqlsDZVFRQNQI1c9X3eJYnsZcG9jtWbow6imt78=;
        b=dw55ti12SIJyKmryST8ORpjtgrtUtfPsVXQw/pMBi9Fm8DUq9ffCXFX186IGeoWlh6
         7XicZh+gfmBz22PNDamnVz1EssLHFmyFO767MD39932nJ2km/fRO0qBK/mpjXNW06A7R
         /+4E7qQh4THnfGTGhtY7fxfEul4KSsfROoBUR4rNFN2J3beelDCl+jJuMyU/5n1oqh7z
         NP2+dLVZQSyLH/eazkKuDpNUGQQxYDUq67OxoVcIOa3kTK51mupjQ1V+vrknN1jqcPUG
         oqy8oPWbNKjAo2NcEt2ajXvzu5DuQwG0zgeVB/fWT2fg2bDFfA8PBfYQK1fDGrLLjN0m
         y/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kvYcqlsDZVFRQNQI1c9X3eJYnsZcG9jtWbow6imt78=;
        b=fS/sSxkX3M2r/gGo1spAWFzHf9l9KGuQUxb6g3+K0n4rdKFUWRulT3rCoE2GIgTWzK
         BZY9PM1p7nL9XKYJMydfboEiAbKMzOSETKLKHS+zVEyEmxIGOIjgsQTM8DD0a7Q/g3lZ
         gJPZdf2yR1qDdy2W8nqI4r1Eobau0ACp/RHkLmKHgEs37nMTkLNA6SqO1UzYuxHpjqHV
         ykSNigkPyUz2/bhp6U5HbAZXNXXkJ1ausOZfhOlpLAYr/F58m7ZdAh7nanh3c5+gq0G/
         6mJzAQbVUr1EEPyVqgIOxpSvTJogxwua6eOuIoUkW6+y7uJVfSg5LpJgD8PvHPN7jJg1
         eR9A==
X-Gm-Message-State: AOAM5304QgSp2mJ0LMAUiMhy9swqTcGQyM/O1L25fiNvNH1dhfXt5hIj
        t9slXew5GKKdZFXaf4JWLWWl/1tx3vCFEfQxJb3cKw==
X-Google-Smtp-Source: ABdhPJzZHKI75ndHkrEXROc31KdhFm/vBoEKnBqtqCRjj3lsn9ni2oAVIhgf5P4CJhxK1AwQgLJwO5nNejwA4egzLNk=
X-Received: by 2002:a9d:458a:: with SMTP id x10mr5997128ote.267.1634837581215;
 Thu, 21 Oct 2021 10:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211019110154.4091-1-jiangshanlai@gmail.com> <20211019110154.4091-2-jiangshanlai@gmail.com>
 <YW7jfIMduQti8Zqk@google.com> <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
 <YXBfaqenOhf+M3eA@google.com> <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
 <YXF+pG0yGA0TQZww@google.com> <945500f6-27e1-ed81-2b7d-c709cb1d4b33@redhat.com>
In-Reply-To: <945500f6-27e1-ed81-2b7d-c709cb1d4b33@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Oct 2021 10:32:49 -0700
Message-ID: <CALMp9eSAYYL2T_H5b3Kv+OE2KgDz_iC32yQfpiqhwspRUezQ2w@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 10:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/10/21 16:52, Sean Christopherson wrote:
> >> I think the EPT violation happens*after*  the cr3 write.  So the instruction to be
> >> emulated is not "cr3 write".  The emulation will queue fault into guest though,
> >> recursive EPT violation happens since the cr3 exceeds maxphyaddr limit.
> > Doh, you're correct.  I think my mind wandered into thinking about what would
> > happen with PDPTRs and forgot to get back to normal MOV CR3.
> >
> > So yeah, the only way to correctly handle this would be to intercept CR3 loads.
> > I'm guessing that would have a noticeable impact on guest performance.
>
> Ouch... yeah, allow_smaller_maxphyaddr already has bad performance, but
> intercepting CR3 loads would be another kind of slow.

Can we kill it? It's only half-baked as it is. Or are we committed to it now?
