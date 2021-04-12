Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C661B35D06B
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 20:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbhDLSfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDLSfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 14:35:04 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDFAC061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:34:46 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i81so14399239oif.6
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B0snQNysZJ+eshswUbAATX3408PkT3sHTGisEmQRaBI=;
        b=IsdBy7Y/xmB8myrYlMcMiSwKQpCyqozNO016+uuiDGDNmjEQMQMtKQT1O+LeOkXvse
         J5dsvtTfRBQmpe1/98/Xr8lUlqaVQmFb3UTBov6DVfgEzz/Q+K5SscVQ0eYGManVVXz6
         7sa1XVPKwXBqF3rrdjoM68UcJ2BRZhds2SSqmeN1EZqjs9JHC6hCQ8dYalP9U5U0CDAo
         OdAZAi3C5IdcRVzjPg1oVHfDbUXyvNlPUYb4QbD036RCNftz6pTpjwGtQYag1mkJuniH
         5Pc4tjVgYjo6C7XSFUbsv/wm+clXa5+a8uXiKTOvSgRj5uY6jvHvcXD31msbwYm+a1ZU
         r1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0snQNysZJ+eshswUbAATX3408PkT3sHTGisEmQRaBI=;
        b=I/lS/h2duYFLWID6N8xppWO3g0lVLxJF0L0yTY8ixhnLBe9f5b8XVCgk8athq5rwm2
         cui0PcEJUBlO8g6HWDwd0Ovby3ROGg46QMSxaR7LrCVH4V3stlBI90fBeXrDKbydvNr6
         vHXQy9S+o62Y7apKxEORbGGNK11qT1hfOOYgCdCohVNAX9V0u+s8oPjocteHk4mI3Xir
         I4lu18/lhsBvy+RC93dSE/EPs3AlTF6AXlT/Yal8FXj/3AvrBYjjCThTTCwo9SlpfJ8d
         X237Q1OVBnat62YB2f7xENm4egFxbzyNblltP3BL4pGC2x0TgbX1TB689qjSRfQkV0xe
         YR4w==
X-Gm-Message-State: AOAM531rYwDTpcTpmEnYEs662wn1g9EP1HqKEQfnFqxrLhWBPwBdsP2g
        sQZu1XEwed476WaNxHYxm5kSsZX4wmuFuR6MEzkVcQ==
X-Google-Smtp-Source: ABdhPJzbTsNFNsgJCq0R6sPG/+Uw4Bcv0ply156WXPYUJEkjjlz7V73QxyWbH2frTyfzaD1/yzUR9lYn2tuwb237SyU=
X-Received: by 2002:a05:6808:f14:: with SMTP id m20mr397142oiw.13.1618252485403;
 Mon, 12 Apr 2021 11:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210412130938.68178-1-david.edmondson@oracle.com>
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Apr 2021 11:34:33 -0700
Message-ID: <CALMp9eRTy-m6DkXRSGNU=r7xmrzFFQU60DB2asUDZLCgw93wRQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: x86: Make the cause of instruction emulation
 available to user-space
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 6:09 AM David Edmondson
<david.edmondson@oracle.com> wrote:
>
> Instruction emulation happens for a variety of reasons, yet on error
> we have no idea exactly what triggered it. Add a cause of emulation to
> the various originators and pass it upstream when emulation fails.

What is userspace going to do with this information? It's hard to say
whether or not this is the right ABI without more context.
