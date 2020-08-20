Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E550824C80D
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 00:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgHTWzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 18:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgHTWzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 18:55:31 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D8FC061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:55:31 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id x1so793617oox.6
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 15:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bj0PKpGgUmQGWPUPqN0076m6UbmCJtO39tU2kyD22Os=;
        b=qGdVMu4b3v6jbmtK5DLhZBrYe3U2DShvjHrNwjGgXeMvth7qycHPzskSayLHPuntOD
         M+77WaicTfNh2XOlMgjzT7VdrutC9U6FX36r18S+RU+MhZRbNGK4WT9zStf0fxWMY9pX
         7M4Ngsy0msEcuRKb6R1QBI0GxTwxOmaUG9P5dvjMjy0t17i2CjV4tZ7y0cuzHHEyc7xU
         Z3yOL1bUbYhVoDT9kQ/y/xTsYxrYddV5UIotcH2BGKOx4ekEMDyVfFQw2O8Z5sqzcOQ/
         5OgGE//6xfKOznGMQsI45NiyD48bQxVomUM/I63grV2G9zV4BRBKkYPLmEPg+28YsOFb
         YEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bj0PKpGgUmQGWPUPqN0076m6UbmCJtO39tU2kyD22Os=;
        b=J5+OcTJcRUUoclAg0nzpHtChmHZZT8P40T9VvEJzlNFtvCkK2F2mDfLRroIYP/hjJL
         dLaFiaZA97qmKImcBG5qKG82R8YMYMtPtl8U/WJwl6qTwPZ2Il32igdIDyKePUQyDRO6
         IFSgDMeCjL0GPKoSemsBLK2p+S3XKjUJcWaMe2geaVgELxR9GzkT/+RJWshsNba6Mt55
         TpJAPt4j2MBd/zAfI4NDCLubzhPs0sXcGmF73KfwvZlgbYZu3WTEsVouvifq7iCCEA4s
         10OkJZjB4OWxU6rrbHE1toHtiGXQsd7WbWOJmbzEv90IxtdxO8LSUC+rm2rykqrnTRRG
         u82w==
X-Gm-Message-State: AOAM532UgPjxJP9XxCJ+8UFi68py9Ws7Eh8s72yi3gbQfuU6QO88LJIn
        lBc6IOipN8xgJpVIQIHvbWvwTUen8rnbVUFzUICjeA==
X-Google-Smtp-Source: ABdhPJwqoNl0Cp8rh7ZiqBZCE1QmmlsDg9PILSHumswoE2XN4MJG4Tzi9WEuF7aJxn0WOogK7mSRyh48WMVr4Z3P9ww=
X-Received: by 2002:a4a:d2d8:: with SMTP id j24mr31762oos.82.1597964130508;
 Thu, 20 Aug 2020 15:55:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com> <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
 <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com>
In-Reply-To: <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 15:55:19 -0700
Message-ID: <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 2:59 PM Alexander Graf <graf@amazon.com> wrote:

> Do we really need to do all of this dance of differentiating in kernel
> space between an exit that's there because user space asked for the exit
> and an MSR access that would just generate a #GP?
>
> At the end of the day, user space *knows* which MSRs it asked to
> receive. It can filter for them super easily.

If no one else has an opinion, I can let this go. :-)

However, to make the right decision in kvm_emulate_{rdmsr,wrmsr}
(without the unfortunate before and after checks that Aaron added),
kvm_{get,set}_msr should at least distinguish between "permission
denied" and "raise #GP," so I can provide a deny list without asking
for userspace exits on #GP.
