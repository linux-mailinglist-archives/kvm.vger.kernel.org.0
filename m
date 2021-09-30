Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF93B41E332
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 23:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349331AbhI3VWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 17:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349281AbhI3VWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 17:22:39 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782BCC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:20:52 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q125so7215336qkd.12
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/TBKn03dF9IntMFcuDE9WlvX4rnNMcxTnYaxfj4f3M=;
        b=BlxMYaM/OWq2QOg73mmSIuZReJqS9WDVJwYpygBxYlCdpjQvMPkG8JUUJuWMEfe7VW
         Kc4xJOkMskHk8O+awxj6C0zYig/iRuEgT85zngr4j5VHau1O2THU+xT3x/AlUo4/mD7V
         wX52wLkXcsoyoK8aKbnCd70Ljj6pEqXvKGjjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/TBKn03dF9IntMFcuDE9WlvX4rnNMcxTnYaxfj4f3M=;
        b=tAATY81iwITw5YvlBniJh/68tMx3cxWqtYgyq/4lfOjzC+scMZcIToZkC/IvRYhPb4
         +4ARYOZNM3liTwBDjIY1Va72utDW9lFLlYWr1W3zZva0kU+5DKWwfnB/R/vz6697Hrwg
         0fCrfAe1SPHXMpA87gbZHGeI+ZjW3lyZpWGa3Tl7Gg1hsee2NcWwRu/GAJPLjd0GNg+k
         GqsgNj6eHteoI4kjW+LMmLYGSLfluBQJo5XdKfPYsUCMNdX3pkQe7cKxosxoQblwgjCz
         g91/WeRIBquNjs/E+LMXFE/K00oq1iFgji81PYvUlVxrWmdTo4IdEZZqxVSMdqR7ou0V
         YMZQ==
X-Gm-Message-State: AOAM530tNkOfRQ6tnvVFHtpYGXRQo5ChyjdvQD7T2jX8jAlJs/7zx2pz
        VMg7gIFC98uX7706dbVgBDALRTS0B3uH/f57daQ=
X-Google-Smtp-Source: ABdhPJygn2uSDrIp6E6sSnZYJ3WX1JgjKzjIkYXdjEMYX9BBq8GU0YAy0GiNxLRW9WDuRZav4yCqUg==
X-Received: by 2002:a37:951:: with SMTP id 78mr6966699qkj.244.1633036851210;
        Thu, 30 Sep 2021 14:20:51 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id y15sm2189005qko.78.2021.09.30.14.20.50
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 14:20:50 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id q81so8003202ybq.5
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:20:50 -0700 (PDT)
X-Received: by 2002:a25:df06:: with SMTP id w6mr1562849ybg.459.1633036849801;
 Thu, 30 Sep 2021 14:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210930185031.18648-1-rppt@kernel.org>
In-Reply-To: <20210930185031.18648-1-rppt@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Sep 2021 14:20:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjS76My8aJLWJAHd-5GnMEVC1D+kV7DgtV9GjcbtqZdig@mail.gmail.com>
Message-ID: <CAHk-=wjS76My8aJLWJAHd-5GnMEVC1D+kV7DgtV9GjcbtqZdig@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] memblock: cleanup memblock_free interface
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Juergen Gross <jgross@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        devicetree <devicetree@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        KVM list <kvm@vger.kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "open list:SYNOPSYS ARC ARCHITECTURE" 
        <linux-snps-arc@lists.infradead.org>,
        linux-um <linux-um@lists.infradead.org>,
        linux-usb@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 11:50 AM Mike Rapoport <rppt@kernel.org> wrote:
>
> The first patch is a cleanup of numa_distance allocation in arch_numa I've
> spotted during the conversion.
> The second patch is a fix for Xen memory freeing on some of the error
> paths.

Well, at least patch 2 looks like something that should go into 5.15
and be marked for stable.

Patch 1 looks like a trivial local cleanup, and could go in
immediately. Patch 4 might be in that same category.

The rest look like "next merge window" to me, since they are spread
out and neither bugfixes nor tiny localized cleanups (iow renaming
functions, global resulting search-and-replace things).

So my gut feel is that two (maybe three) of these patches should go in
asap, with three (maybe four) be left for 5.16.

IOW, not trat this as a single series.

Hmm?

             Linus
