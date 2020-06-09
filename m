Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB04E1F4410
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbgFISAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 14:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733148AbgFIRyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3D8C03E97C
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 10:54:47 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id g3so21154760ilq.10
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 10:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=05NTV0Dt6UYVXxwfdhrIdCqnO3jxBBJw4IueZ8RD+7w=;
        b=QagLW0xhYVivrf+fT0GpfqIhULa+0BoIReJgWQ4UG4ZnoG+XMKy/w7HGYpVd67BdQA
         yBrBxfFd4gZ3bKvEvkij5lW0bvtA7HABVCtLvz5nYmO7FoyKuoA4UALm77fOcp0DgJDh
         GT6D558y+9Vyh6JMT9pBNlGYzU3aqGEI8wrJRJiE/+SxPSLUca6UPuX/0UMUwAHd2RF0
         eiL1BdCGSiys15bIZBBJ3qWfhlZ9NkzUYzkHXtQgrTgpHUCs66vTlQHZbcxYaoR41Za/
         7rekPAtwrixokrF9yg29B6rsKatExgDUZTIHjdBFYAHPrW4Ssarnogl/b7ib3LkjMlG/
         Pu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=05NTV0Dt6UYVXxwfdhrIdCqnO3jxBBJw4IueZ8RD+7w=;
        b=jF0a6fMQU0b3vgX6RXm12Bbu/bkVT8mdLY3Lk/USqdICry/b1Up09o83kSUClqlvrr
         iaFVVxwKeYZHPud/0WC1rW95Lp44SFcrBq4c/WdsexglFDAB9TjiMjtkGj/i/6DvT9vy
         fyFOSaScTSpVlUxqee2Y7cxEQaPXnuni0QudUN8U4ZdplOUEShHbaSuyv4WEDRaKwaTv
         IEqgfX6rbT2bn7cztAUNGJjDhr7EUPxHQG/SShCAZX2oMVPrZrgbgL9IE+V3c75Y7dEE
         ovW7fbc8hxaFRwDqqdcQHA7FV4j0ska99pDj63CKJOVOkg7j8o0j93HYyRrPuN03isof
         lEgQ==
X-Gm-Message-State: AOAM530+O6SOjw3S7CD+xfcSraRFc3kBlHXkdyIAFIFxhBz2GUN14hrl
        3saXpM0g52wcvwM3C1H2rl9jRAVfFv9/ll9rD+3Q9Q==
X-Google-Smtp-Source: ABdhPJwuLfNie5HIlzjHaWphh6RtDbAg/FDCzpuDHUKyY1vJHWGYnA2ygsohkISwy6QnC524BI5sknCPNIg+7WLksdE=
X-Received: by 2002:a05:6e02:1208:: with SMTP id a8mr27882705ilq.118.1591725286609;
 Tue, 09 Jun 2020 10:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200609015607.6994-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200609015607.6994-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 9 Jun 2020 10:54:34 -0700
Message-ID: <CALMp9eQNF0b8q3naibxtKxo=pym554hRoMJ5ro5febzOUBU-=A@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Wrap VM-Fail valid path in generic VM-Fail helper
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 8, 2020 at 6:56 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add nested_vmx_fail() to wrap VM-Fail paths that _may_ result in VM-Fail
> Valid to make it clear at the call sites that the Valid flavor isn't
> guaranteed.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
