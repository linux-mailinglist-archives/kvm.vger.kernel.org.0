Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9B038C62F
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhEUMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 08:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUMGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 08:06:10 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B0BC061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 05:04:47 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id g7-20020a9d12870000b0290328b1342b73so9946469otg.9
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 05:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=pTHrM6OdKKAKgYErYFMB9F+YhsejQ9b5uoqFgCJJLh8=;
        b=RkRYudnewz/jwj7Hgb5UxGuTf8mOabIHBPXzGA+ahNJM1G7fhCoG855rG6c9LR8yvP
         +DG82+tDemFeYVHI2MNkuX0vZj+LIrvL/cKQ2u31nJZFjXAuGRDqg9dIzAeGxaZHsL30
         vfU9WM+3OSDrJ8SJ7MWbD6GxIjeSHdovo4oVTLSh8bXuedfAF+LXWDCFVFsesxHHnITZ
         /OV6XHt25HVHrcHHi0mXGbfpq0BZt6nvHVbg65XewhaX4BkF5/CBoEsv85mor9u5rhR2
         9ErUmwUeRSorMCciUK0mDKWV/mM/zTVVCT8V26rHKPD9O4yqxIbrxvQkt988cv9gL0U5
         aASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=pTHrM6OdKKAKgYErYFMB9F+YhsejQ9b5uoqFgCJJLh8=;
        b=VeU94k24CGyf6YxgKe9zUWnJANiPwPJ+x34TWu/bvkzITwM8ZZgdb0NjV3IGbWO9fV
         TX3M7d4MuG5BC/jjLguoAnhPfBwh6lR6H8AMDnwfv3UbS3fQmw25hLouf7nxz5kz7spi
         lrePrJdSueHt/IG/b1bU7HDLqkxSZquV9KPRKwhGu2DThqjfHAXrKubQYMRsj2xDRFzk
         pD6HxoN6/kitFty+Z5KpiPK+pGjHkKD1NIiQFjJRGVgNR7yQCJvC9u//ei3BXJIWyoSj
         TJ9dh8kywVF6YrWys6/tTVEIGtirPE5/AmZlGjFkWk1XSmCX8LZBNlG6bEosTtxqb2xU
         j/Jw==
X-Gm-Message-State: AOAM533fbxd243pa3Kh0QT+fBhZz4w8ZD3mn8CMTquKR3arT/azbTJ70
        pvHPc2k1mWip6WP0LT4xHs6czKx8/CKgkMOHgsghJ6Ic4p2/WQ==
X-Google-Smtp-Source: ABdhPJz7zN9GUftiHRIo/ThxS6a1862vgZ0je/VFs+op9amxLBPCzrSpBinGxOPyvAQdNoI9VH8zjWKe5mJGfB/Ziw4=
X-Received: by 2002:a9d:131:: with SMTP id 46mr8168223otu.241.1621598686023;
 Fri, 21 May 2021 05:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 21 May 2021 05:04:35 -0700
Message-ID: <CALMp9eTSTCD3gjdFv3WtjLdFoKshq0+69xeoQkTGxhGmYn2-sA@mail.gmail.com>
Subject: Re: [PATCH 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 4:03 PM Jim Mattson <jmattson@google.com> wrote:
>
> When the VMCS12 posted interrupt descriptor isn't backed by an L1
> memslot, kvm will launch vmcs02 with a stale posted interrupt
> descriptor. Before commit 6beb7bd52e48 ("kvm: nVMX: Refactor
> nested_get_vmcs12_pages()"), kvm would have silently disabled the
> VMCS02 "process posted interrupts" VM-execution control. Both
> behaviors are wrong, though the use-after-free is more egregious.

Oops. Prior to the referenced commit, kvm would have forced a vmcs02
VM-entry failure by loading an illegal value into its posted interrupt
descriptor field. Though better than clearing the "process posted
interrupts" VM-execution control, that's still wrong.
