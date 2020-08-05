Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9223CCD3
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgHERI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgHERF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:05:58 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A9DC061757
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 10:05:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s189so39433285iod.2
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 10:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBJV0XruchpYgDI1qMU6kXVYMvuaojqcy/VM/BfhHS4=;
        b=DDlDKTDb/0WHPHlQszr8T/dicZ3JvB4fFR88fjW3PYNXn4Bd1sOBHkO14IfBQN8Kzh
         wW8hvZGObDj1LUEztpmRYNVUjkSGbX9qyi02lldsKk72wxUXVKWu5CWFbhAWtfQn4TMN
         63WibHCjsj6FWC078lkCBf7/E3a8z4dWQFw1y8Cugeyb89wnvH4FYd4FiEQDGXaUQZ5R
         hAx8fkejSXcWdQJTeHgHVzIFmTdNLFra23jvNnZDA8dVXvtPgm0wPyE8T5NteTKpHUnp
         7Vh0NuAPJbKmXEVGBtIJWc/WQ0DOUBfE5Wi4IsL0+v86q4+xHk7bbof7HBChNKrE0TEi
         BUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBJV0XruchpYgDI1qMU6kXVYMvuaojqcy/VM/BfhHS4=;
        b=PT+aLp2wLp6AXqOFbvoKn0fkoGjI6gOH5XmTKEs2FZbsioQ+yCLjnnkL0d7m3EoRGS
         Ckv8+ref/ojJoR9iH/S5JbQreWpRPVUWLg+GyfOikUGfO+09bhIjaIE4TC3iMDFHMDTK
         mum89i1qDV1R8dqvBiBsznEE7CzWXgKmk0ztjSfZ+1o9quj9X1Bh4lCsU85YetWnugEL
         33vzvNE5wKvL3te2+XbJFvlvU/FqX+SXYU6Q3jCT6B7qowKYTkWwBCF3o0aGIuChI/Td
         zeLjumUmfWQawRHJlGwv04/HzXn0HUOnNDYhj6h2lRen0kGfCV5M/XqXf1XrATXKQJqV
         ujvg==
X-Gm-Message-State: AOAM533mX97RKo7R/2ZR+42L+tdcoqKNTiwpcf7XEl7cu6MrZlmofgak
        C65L6g5ON6iq3Izy0QsSsfbXofOB29BnJuxsU/UeZA==
X-Google-Smtp-Source: ABdhPJytYzCJbS45tauBAiUZxFGUgBBjr+Uns//aaQKG0bhrMyRYe2msAgYn/W/ZmBM7UHzdKHfygm67zRHOOqVWsNE=
X-Received: by 2002:a6b:c3cf:: with SMTP id t198mr4294638iof.164.1596647152347;
 Wed, 05 Aug 2020 10:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200728143741.2718593-1-vkuznets@redhat.com> <20200728143741.2718593-3-vkuznets@redhat.com>
In-Reply-To: <20200728143741.2718593-3-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 5 Aug 2020 10:05:40 -0700
Message-ID: <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 7:38 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> PCIe config space can (depending on the configuration) be quite big but
> usually is sparsely populated. Guest may scan it by accessing individual
> device's page which, when device is missing, is supposed to have 'pci
> hole' semantics: reads return '0xff' and writes get discarded. Compared
> to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
> real memory and stuff it with '0xff'.

Note that the bus error semantics described should apply to *any*
unbacked guest physical addresses, not just addresses in the PCI hole.
(Typically, this also applies to the standard local APIC page
(0xfee00xxx) when the local APIC is either disabled or in x2APIC mode,
which is an area that kvm has had trouble with in the past.)
