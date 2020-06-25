Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DFA20A337
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406453AbgFYQmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404106AbgFYQmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 12:42:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64A8C08C5C1
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 09:42:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k6so5896383ili.6
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 09:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2xefmCOp3hfbq8lDKeuEAE/g7mMYksADR1isYIodu0=;
        b=hlZdGmeTsHxeAl0pu/duTc+6j2phkjl9lcR4YzkqgZzycCm2TZqME1OTdFzcibZ/Qf
         NVM3KL5VYdkr9UVBmVfHuQs4762qi3vyQCEf55BCg5z/9+H47Stlxqhtz1375f8n/n5L
         ZX3cdU3Al0rjLOYJFuYFCtMK06SfwqrTTqfHzIXDW2WVKZIV29Q7nkS7q5duJy8WOLjE
         mCB6bW9IqM8vRH/KTBp4lgceRPkvvT6LLwBxqxCffxAcGRstggGmfMXxUpbAypdg+rpI
         2VTFhY4KCWOGyvP6SRTdoMTDY/P1+84L4iloUvE36zW8Z0Z6DEGnzv9N4kr3AJezE6Ay
         IB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2xefmCOp3hfbq8lDKeuEAE/g7mMYksADR1isYIodu0=;
        b=q8V8uhV7zdBaSL998OLWw/1PR9YmfNeYb0OuhQW7+t3eBRzVZBQgys3aGk3SXxTSca
         TY840KBrapr46SlY6ouBAGm/1fEWxJPTI5lMNH3oEInNskvxf6d1B62BtpNC4cf/sQ8m
         2/AgvyDch8W6CaxywXqmSWKnGLORSG6vcMfNbZLBxBiiJBOEi2ZkSgpkr93jVkcYmlT5
         CrTNBzoHzlr1Y97NCsWITlrQv2XhNde1nbB9YTMXSm7aNJNSwfAqnL0aAVfLcVavT9hr
         n0AKGghhx9K57+hqyx7XG3pZMSQvva+zAo2OSJswSj0XVzMDe1rGr6LFVIz9nGQxZqH4
         eaQg==
X-Gm-Message-State: AOAM530yBsj57me9uInoGwbVU2JbZmWDVd26TY0ylEjDJiNNBlecZxqS
        AOkwBy7dQW4LH6skIs/RjYMwzYyKcWdcbppoZGbt8ZZi
X-Google-Smtp-Source: ABdhPJxYjF/1d/N5qli6vwZvmzZji1xJEu0EPBV1ZoRf06ZHqJY2sNCGY34c61j5hGybi/I18aWjiuRb0M+Jm8K4yeI=
X-Received: by 2002:a92:b685:: with SMTP id m5mr24089995ill.118.1593103327753;
 Thu, 25 Jun 2020 09:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200619193909.18949-1-namit@vmware.com>
In-Reply-To: <20200619193909.18949-1-namit@vmware.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 25 Jun 2020 09:41:56 -0700
Message-ID: <CALMp9eTSPURV5NohpxhoMMisuHSxbz8NMKL8hvtw8BOC7WLEBQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: fix failures on 32-bit due to
 wrong masks
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 12:41 PM Nadav Amit <namit@vmware.com> wrote:
>
> Some mask computation are using long constants instead of long long
> constants, which causes test failures on x86-32.
>
> Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
