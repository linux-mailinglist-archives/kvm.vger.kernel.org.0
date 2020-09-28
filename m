Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDA27B15E
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgI1QGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 12:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgI1QGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 12:06:11 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07A2C0613CF
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 09:06:10 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e23so9343011eja.3
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 09:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o71LzbqX367JaJH9ttdwJUvGzrnJxktn3m8pbVRAwzw=;
        b=fvsDnXfKUBOAXccBDwFSPn5D6Csgk0G1mHyAUd74eUxAq5zR8163TbnodrFpDHFksK
         q2UiyDX8dhCNVWDabaAhGk6xzfG4SXk1cjcB+qzfJ7yDn1xhigkN52Szo+wj1QDppJZy
         SQIg1zSkc4EsBC+GeqRxR6kysSFmHW8aanRGoDDPzu+9MkTBuf1hXhNNXN+d3nIR/hOU
         1p+7sGA15/ttgAVlsAnYSh8fZUQuiNAtvq8tEXBc7wT+Dzt+eNRle4hU6ePzLCSiumPP
         94zV7qksW3cZEgcTnZWteH9J53JSPSP4z9MrIiYAh1NbGG9saHFBAmXyiozR7L2/MR6P
         ARaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o71LzbqX367JaJH9ttdwJUvGzrnJxktn3m8pbVRAwzw=;
        b=JPvG6nGMbkb0VVzY5mU6mfkm0lo9DhT+xiU2tIT9XW/Yb05HPJp5ZY17pbOLy19NtQ
         Iei9ZRLixWW6hqr12Fk6/iGfpQ7mxbGDRYrm3V/52uFAw69AL5lyD2xV176fuOr4ow6u
         7PmeZPO3ZfWCBzpuXM92apkfjA0yZsnu84QrTb0GzQFuoGJcpL//Jg2NegP88LK5oBbV
         sMFlbmKPyzWsuOB1zTn8kx/jZuCi2gFEmdYwwx6HK5U+MR3yQwrCarr6UqaKJobY+pku
         1CM0q+o8UKRqI49OCHHK0ZVNDomMk/1kD/CH2Q1dAqJK+c+5BkYZsPOOQX+/fNLwWTLv
         EGTA==
X-Gm-Message-State: AOAM5301D2Uz2G5tWarHwTfp6VSCxsm4GH+WjY3EdbDW2HQ3WtH/S5KN
        dvY9YoCKPNj3dfTkGxEdRe3BKk1gk/xXWw5m5UKsbg==
X-Google-Smtp-Source: ABdhPJwqh8E0xHjHa+dXhoJEb6VW08INWmr1q9wGgTppwWtMYPE+FmoLDTQjTf5DzUZYK4TAiqHPx/WYKmjPD/totDw=
X-Received: by 2002:a17:906:3e08:: with SMTP id k8mr2297800eji.480.1601309169232;
 Mon, 28 Sep 2020 09:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200925143422.21718-1-graf@amazon.com> <20200925143422.21718-3-graf@amazon.com>
In-Reply-To: <20200925143422.21718-3-graf@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 28 Sep 2020 09:05:58 -0700
Message-ID: <CAAAPnDGVKDvVRdDK8yUzqXHzWzFK_9tnbwdmHkwbgcVb2wU5aA@mail.gmail.com>
Subject: Re: [PATCH v8 2/8] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> This patch adds a generic interface to handle WRMSR and RDMSR from user
> space. With this, any future MSR that is part of the latter categories can
> be handled in user space.
>
> Furthermore, it allows us to replace the existing "ignore_msrs" logic with
> something that applies per-VM rather than on the full system. That way you
> can run productive VMs in parallel to experimental ones where you don't care
> about proper MSR handling.
>
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Aaron Lewis <aaronlewis@google.com>

>
> ---
>
> v1 -> v2:
