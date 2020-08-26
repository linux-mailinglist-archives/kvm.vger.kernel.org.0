Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE1253927
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 22:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHZUif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 16:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgHZUie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 16:38:34 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC58C061756
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:38:33 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id z195so2722913oia.6
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RDmTeskOQgqjH7Bwa9ilUHRa8YVRzYGClEJYJQLJEs=;
        b=Ncib95Z0vslOOUIyFxuviDs0j+tBfe5FDoorlEI4kUHJBZv+l7A+C1TbJPzR25/WjW
         AVFG/Ml7nQJFKgucAJce4V7Yd/QfZZI3tKY9DdcDLrvUQxBHXTAExIg5vRU36ClMmfQv
         UiDSu5XzVvJFOjf4XmcYqS5uf185wpBop6AjhfzUtSl7XKHDK8/f+OlFhtik6whAojDK
         3xYlxMTP/2aMJ05MjhL8C5iU4SfPsbZGZ5aRnNwnNLsRxD81hi+tFe7vjbpbEKJ6bPrs
         Y1UCLVyOj6NK9naOKWU+opF0FdOBrQSlQ8rG2jJEqn945yuYMOw6ZANhCMGmHAQbMCMD
         GsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RDmTeskOQgqjH7Bwa9ilUHRa8YVRzYGClEJYJQLJEs=;
        b=p4NiTPHvNCfApx3gVl4JrWC6sBLHQozhv7sjF2mI9jmXsDdhWtpoRf4Ld/pWXjT3Jk
         EDnZhHz5epKRsOd2ksNZKPKnJW/1hvPBMILh1gUNpEWkxEOsce/36+tqTkPrzxw9smf/
         jGrhpCKIrOPtWEGEiIqy0xHECzZ/UlwOQq68xt984kYwU+/ZUUK1+SQ1EyK3GBAUC1xy
         uv4tTPnWQM3rzDocBYsvIEdiCGszYRwxjyz42b28YNQ19J9OEQmyGFdtMXSiMUaTvc9D
         5LrszGkDGtN26ILwDL5lGO4HGotzuBFUWezbRktCWEeNhxvu3lDnMB67reWEMpk+xxPC
         VgxA==
X-Gm-Message-State: AOAM5301HPX74eDfSoSda74EKoGrttyXDEQ10orsTq8teNHM/ifATwd4
        EhlF1k9mhnjvpVkWeyR0ZKNDzw51e/S2dnx8kFjieQ==
X-Google-Smtp-Source: ABdhPJy6hwY95r78yIoeS5ram8XOf7QjXY5PDWluJU3+L70Px0lQMsNtKZKlaCwQW/hQeMV41R65lk9NEeH70RX44Vc=
X-Received: by 2002:a54:4795:: with SMTP id o21mr5056157oic.13.1598474312866;
 Wed, 26 Aug 2020 13:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu> <159846923918.18873.8521340533771523718.stgit@bmoger-ubuntu>
In-Reply-To: <159846923918.18873.8521340533771523718.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 26 Aug 2020 13:38:21 -0700
Message-ID: <CALMp9eSM6joAKAHPeJWZB8srCxJPJyTxgpwjAzpJuCLm0LmvyA@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] KVM: SVM: Change intercept_cr to generic intercepts
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 12:14 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Change intercept_cr to generic intercepts in vmcb_control_area.
> Use the new vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
> where applicable.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
