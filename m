Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95EE3732B4
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhEDXZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhEDXZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 19:25:09 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B84C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 16:24:13 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so374401pga.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCjpzDhrttWsw5MJ/p42z/oli5HL0EZ4CCcwCVvuAoc=;
        b=Jsjd0wfSASc35JMy8OFI+WGWdedhSmWjdc9/8egrIrj/OAUw1r3z0rbzxov+fJMCdB
         8LCoDvmG6EHJ0veMHcaOO2y7esjJsxDR02u80b6HuYIjk01mdo+M80bFI99KNvDTT2o4
         C50gnrXKnC5OkpOvBU75vnQxbhNksQ5ThdJ853VWIGHmBzge/oFgeNt568JWwqhlYhB9
         IKt15CCP7c08U+Q0LG907KjvgkJnGsCgY0ZWrp+yrxSDIWSLEDuXul0XFnx0ULpszY58
         JtCOAM3G2shxJVixfcKgUnxCsuGrToUGIFC8UvSHym/6qJ5Q9bO9KLESGkA/1Zf4uY5G
         m61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCjpzDhrttWsw5MJ/p42z/oli5HL0EZ4CCcwCVvuAoc=;
        b=YXACuxch37DX8osTmfcl/4Eg/Mh8MJyprvsd5YZ6VD7K+NPXS4tExDeXhVKXnswjIc
         4T3jVOjb+u2qbWZOTmxQist0Xqe/SAb8tP2+oZHcwVT83SG8QdgyQBuhR+uo9pZBQvrL
         s4oYKRQyYIdwjFKqpeG/bMHkTPKaJXKeSJPL96JuDj8JNrfKzhO2vK+fgWabmPuh6wlh
         sTBp/IASUt/G01SKAK6G/gasooVDiuVJ3eGR2p/GwaM/v6bRzJkuWYi93BDd2cbAFajV
         7jGQ5bMgF7ZFiJC1el910TijxQxSwQwXV/Y78/9CVHtctl5ZaMKDsZ2H7rC2tcAogRd3
         nK/Q==
X-Gm-Message-State: AOAM531LiEVlU23CRT20kD3ZIk1Vlzb7gEcObD0FPC57Bj4n5xje245K
        u4YtfvVcvJZ/5TbdseETd723JAqUJG2BR+3n+c1QDw==
X-Google-Smtp-Source: ABdhPJy/jLwkYb2DIgxmx6j08hXvs0Rg7hT+i/eMkXx+ku0j6lxB7XK8qoX13mi1aZrW9aon251R0axwu5gMzqpW2tE=
X-Received: by 2002:a63:ff25:: with SMTP id k37mr5373178pgi.360.1620170652347;
 Tue, 04 May 2021 16:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-5-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-5-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 16:24:01 -0700
Message-ID: <CALMp9eTh6JMdeAW9JAP7L6CciBQYgOPgogcQzcfKf=quY0k_2w@mail.gmail.com>
Subject: Re: [PATCH 04/15] KVM: x86: Move RDPID emulation intercept to its own enum
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
> Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.
>
> Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
