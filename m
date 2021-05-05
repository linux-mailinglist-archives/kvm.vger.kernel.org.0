Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9213733D2
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 05:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhEEDFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 23:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhEEDFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 23:05:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E09BC06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 20:04:54 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d29so826326pgd.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 20:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnt665vgiL2qf1EJoHUsRCoeU5QOH0HDsCXvJJOoGE0=;
        b=P9TMJuT38F74L0PYovB9Xl2c3QeVAyOfq7OAAVkUg04WJIX5pgFE8c6RP1aly3OTqz
         njltVvhnKWyGlyoSo7n1Am0dOVn5JYUwM+JyLEgsY6eWCXpW2qoITx0xngAvYSYSXSy5
         s2Wfm/xwToL+YTusxDF97EwARR+utxhmfKrz2C8kEkgsxqCtHwLAutF6DEQ5LvLp/Hei
         sLBe395Xtjd+lyiaUJRfmhjj/g0iUKceJLMrqO76DY5+fqwVNxmqCeIHlmh+RfxgVM5c
         GkdPck4fNTvXRU5K1ZB6rpsfs7D1qb+VKqfrHNJZcPfiiwNmU0ni+KOjw0+3ersjprKR
         LsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnt665vgiL2qf1EJoHUsRCoeU5QOH0HDsCXvJJOoGE0=;
        b=Om2EXBrfWgNkNXv5KiUJSbpXcT4+cs7sU1izxzOtjnDThQma1Gr9sCtmByoLd4pG7v
         zn8qzFbRm2WHdfkbl7JI3T5DuXfI/nzENDMA3oCRCDwbHhh0NW2JhKfo+8fgkQtztpEF
         uBjxuxtMVo7w6znMzbvyHtbfuhFvuUSoSY7+7MQN4M+T5mNS0yprV7Ib5A3SoTM0RSCW
         nf1XlhkdjX/Gm86HTNo9EJwQK/xUPyiYMZFq+yrOkxZzh6ufzqB3s80iNik3+oIunOSv
         twkcQtRwrJ2LPLnJ41NW51WQWMtyZlSPLUryY56+jQ64dDBgbKD3uJ1toXMpiYvmv1A2
         NoAg==
X-Gm-Message-State: AOAM532Mhw+i0BOBo0kSpmz7r4G/WRDVsEZ6/7JTXCmcjZpHA7UWNfO+
        Xx7ivN86d5PE5cU3KfcZXbfWDOxPnDSbRGYgYKromg==
X-Google-Smtp-Source: ABdhPJxbe749qrF5GVXDVwxQvqccIdvbA+blsXEK19Zn0Gdrvd/zoYR5q2XrJUAcd3rzGoCB05VdS+W34/lD8JCSPws=
X-Received: by 2002:aa7:8c59:0:b029:28e:9093:cd4d with SMTP id
 e25-20020aa78c590000b029028e9093cd4dmr13659040pfd.25.1620183893345; Tue, 04
 May 2021 20:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-2-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-2-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 4 May 2021 20:04:36 -0700
Message-ID: <CAAeT=FzLn_RJuVSqEVPeFQg1VYHS4N7715XZbUA4MTUXSS5EvA@mail.gmail.com>
Subject: Re: [PATCH 01/15] KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP
 control is unsupported
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
> unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
> bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
> if ENABLE_RDTSCP is not enabled.
>
> Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
