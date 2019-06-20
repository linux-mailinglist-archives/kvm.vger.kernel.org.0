Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F994D9A7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfFTSpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:45:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42904 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFTSpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:45:07 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so407555ior.9
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOXxm2t3OxvRhCzI51nS1CEzvfBrrobpsZUrEz8AOHs=;
        b=vrEiqVPUFYgbkaMwO2Uc2YyLCB7Dp1hkeXflE4KqJcJ8zZ5egfPJsXtegjBuuirrZG
         KkM4e0oz/lJwl6pPmOw9rO6CBuwccsXFy9AOZR0o5mAnn8BPMqj6i+fz+vc3X+4ebQiT
         eYX54kKrn7LvU4nJddNoUCVBsmWdSTxDnFPcaPNCUfwh3wKiMgC4gV7AstQ2pwkVs531
         TrCeW8ia1QmUXgTRsDc4IISczah2I8bYlVWh6T/NKSo0P4L8a6qWZABdCVQBYxVGo98D
         Or2hz1/Jw4sGDepzMhX6W9JwdKWRxJ974GJj/yIQh9xWjUw8awMUBgKpf/QBvgGFQgX7
         m58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOXxm2t3OxvRhCzI51nS1CEzvfBrrobpsZUrEz8AOHs=;
        b=tNPEOOm3vE9aO6e1jh1DYyRGbu9ODv+6JmpYPx3UyfpAlDUh3shLpUzWsba3vUQ408
         Evy2elex5PakAclBSL7yPDJnVcoUJL9mHNIUOaaGF2Q0oiUYhzdmP+j6qKAbKI+oGHEQ
         BRnhWXVW6Wmoh5ZOVdpYhbkvDdegXJ/9xAdpUutKjeeXUoO6T+2/1E8/zcYb3aY7O6FC
         hb/MNNHM3I8jpJ6kk6VKVayLvlxUO/qjWcPI1YhoIrq4ReNNs6EnfdYGjYSYsQgd8wFq
         RHAtFNP9ASnzorzBixX7smGG4iVwZsCGf355CQFhr7i86oT8v7+sUaAoiqJHTbykhc7u
         VKbg==
X-Gm-Message-State: APjAAAVrzvCgi7qjuTljq+F4K68wIA2l/xXskxycUZkt/pqUC6yW1yVS
        ixYBM1Rw226bUioycnxuDMF1aPob/AwGJRUPG9jDAju15PFKJw==
X-Google-Smtp-Source: APXvYqzFRYVCHjk35X1ouKmAUdulBO2FCgBJB35wx0KM985uS4o6OakZ4zYr+o/iHc7sTtL+9Zh4/4nvJu1AtsfQo/A=
X-Received: by 2002:a6b:6310:: with SMTP id p16mr20938246iog.118.1561056306188;
 Thu, 20 Jun 2019 11:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com>
In-Reply-To: <20190620110240.25799-4-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Jun 2019 11:44:55 -0700
Message-ID: <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Regardless of the way how we skip instruction, interrupt shadow needs to be
> cleared.

This change is definitely an improvement, but the existing code seems
to assume that we never call skip_emulated_instruction on a
POP-SS/MOV-to-SS/STI. Is that enforced anywhere?

Reviewed-by: Jim Mattson <jmattson@google.com>
