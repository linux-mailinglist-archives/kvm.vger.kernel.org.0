Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC513E4F22
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 00:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhHIW0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 18:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhHIW0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 18:26:50 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB596C0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 15:26:29 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id v10-20020a9d604a0000b02904fa9613b53dso8788734otj.6
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 15:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3JoNLp62vjdo8vXgCaNPLV3QzIpcaToJ9w4A3X9RTHE=;
        b=AvYt2iQCQGY3JpTOzHAyRVfLMoOjI8SPsoCc/rpfH5PRPdqKuZ1N+nVtucnojRqP+T
         h+Iy33OhZcOUSyyiHiri6Ng3XEuBmxwh9oYnFOvOBsvn0l88LUQDjOqu8vgRr3iRctLS
         ckPujtdR1JoIFP8nnhaKIDkBm/8fB3eQN1jFtIIO4rCp/qT5MBN/20Yr/9Eml2SFtve6
         rs//Mh+gjscJ/CBeL3HpcJMQ5fQ9tJwJlQa28+gZHq9iwbRhsWMm8ct6g/oxl2tTbeKH
         MocM+qYJ1wnvcHrLEptSwuPNeM5pjVf4s6sKmIOe1iXzNyVI2yxxHaayxX5kNCEnQUak
         Iv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3JoNLp62vjdo8vXgCaNPLV3QzIpcaToJ9w4A3X9RTHE=;
        b=K6aAYJG9r13rVFRaJ1WnyK/zXZejZXCXo5fEDRma+JgZSoX8kVtySDc44GRafrHZuJ
         C7hwF2dUtZ+MtDAi4HiNUaWx9tt1P3flUcSUHXsabrwjIKONbdUQusB6QuPMJMe2GHpY
         GXOhWNXatLBnMY+VWmROv9htkR/uxqc+8mto3iK9P/VLe3kkCRm/YZCb9iqeI4qZPvAi
         bB0bKd8TZhzDDHZ2UQwhs/RAMhUQDJFSruhQ5RJis9o6VBTrH9YOV+L0rqEDjs5VdYKZ
         iP3I36otuNDk0hdMjMxGR+LW9oaczYqJqnm/tmiavHL/8Fd43vmfTLRg8sZ6piLNUHEq
         6FRA==
X-Gm-Message-State: AOAM53124lrEvg0T7v1XkeY+Lsm4QYIDlXJ4x4Cl5o+8jARU+xqzKk1f
        aRGpQkiTDxDjh4yylB9UJlrPckjTfUXQBWOZTEujJA==
X-Google-Smtp-Source: ABdhPJxshTPGXJiS7SSrGMYcvTnzn9WLMl310xx8BEBrnszTcAbaSm7F+gpU3hHYXD0ur78TSHekwvO19h9+kAZAW6I=
X-Received: by 2002:a9d:76d0:: with SMTP id p16mr18471577otl.241.1628547988711;
 Mon, 09 Aug 2021 15:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com> <20210803044607.599629-4-mizhang@google.com>
In-Reply-To: <20210803044607.599629-4-mizhang@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Aug 2021 15:26:17 -0700
Message-ID: <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 2, 2021 at 9:46 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Existing KVM code tracks the number of large pages regardless of their
> sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> information becomes less useful because lpages counts a mix of 1G and 2M
> pages.
>
> So remove the lpages since it is easy for user space to aggregate the info.
> Instead, provide a comprehensive page stats of all sizes from 4K to 512G.

There is no such thing as a 512GiB page, is there? If this is an
attempt at future-proofing, why not go to 256TiB?
