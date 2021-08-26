Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8614C3F8FFC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243600AbhHZVGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 17:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHZVGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 17:06:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A66C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:05:30 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d6so6651602edt.7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 14:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GOTxgGT3bdI7Aw3giv7AT9nqs/Ik9Sg2d946xn5/c0=;
        b=s59PHo9wRrXquNHTf4p26OSlDrBkdKB79ZU/QdWGQlMJANL7x0h1i+v1vBcL/J1fjs
         W1qGxYanTVzj0SLN8K0kXmAmoxfcueg4Xq0m6x6FU3stvNeTn+q8Ff1F3xmCg/TXNAqM
         QgQ+V6cU2SOfLY02740Fb0Ws8CeCytD1+Am+WaEGPymkYSZn9STUO2aNqc7PU/GHWjOx
         y++p4jvOvsaYS9qWZjX98n/+CHsZqGR6nTTndkjmZvh9grjvTQo3N4xe/ltytVQ/nx/i
         7ms7QcJVxOUXW9MtLdTU/6bbj6SB5XdBeW5URebO3RTTTOJkgNW5Kf2XuDwAy8fkbulo
         vy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GOTxgGT3bdI7Aw3giv7AT9nqs/Ik9Sg2d946xn5/c0=;
        b=rGtvDuuo7yWfl7xtbTijnDhxbrwlgpuOx13/vYmeDcrni+cdhWuPXPr7hwgCSQ+dOD
         iCY4kyG6IXqaidwAvOhtljjQaun4ZCXHr5h0Vuobke2zaBesP7sC0gCMz+x+qjPqBoeo
         V/KHkfI4MiQzHDtUplaiiYPT39Plb4QzSrqG6m/kwyYzc8UR9wQvrfkyQL57hFpDwL3I
         U5Y872xz4hrvWIo8N5AQUXjZMhi/1sO61w2trQIIREFhY+oigmmLC8QIT4kwQ/swPsG6
         3H8XrJKZCg9DJSmLTXdx7wPXB2owsSx4KZ2H/SF2WIT3lXv98Jgwob8EJgqtERCqFPdt
         /KkA==
X-Gm-Message-State: AOAM531EMdPD0p4d0SameR34cgzsbuIxU05gZWj+ekEbR2qgO/355ZZw
        EArvuu+1B9LX/wOpshCSvfRIKGnATp4BI4T7eR5Q
X-Google-Smtp-Source: ABdhPJyR2MWpSEOHgkXLeDcLV9zA6VF1cgXBca7yry4a7EmJi3RbdRUBpjIPKvxP31si1Y4fjvyaaLBLA/2XYzv3s6c=
X-Received: by 2002:aa7:d319:: with SMTP id p25mr6342220edq.197.1630011928605;
 Thu, 26 Aug 2021 14:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <YSfbmPmlGcCM1TPL@google.com>
In-Reply-To: <YSfbmPmlGcCM1TPL@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 26 Aug 2021 14:05:17 -0700
Message-ID: <CAGG=3QVX2xFNOz59h_FkQ_g+uHfZr_MqwzSEXKLgPcWVmC8-wA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Prevent inlining for asm blocks with labels
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 11:21 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 25, 2021, Bill Wendling wrote:
> > Clang may decide to inline some functions that have inline asm with labels.
>
> For all changlogs, it's probably worth clarifying that they have _global_ labels,
> e.g. local labels within an asm block are perfectly ok for inlining, as are local
> labels in the function (but outside of the block) used by asm goto.
>
> And maybe add a "#define noinline ..." to match the kernel and convert the two
> existing uses in pmu_lbr.c as a prep patch?
>
I sent out a patch for this. Thanks!

As for the changelogs, I'll send an updated patch series once the
noinline patch is resolved.

-bw

> > Doing this duplicates the labels, causing the assembler to be complain. These
> > patches add the "noinline" attribute to the functions to prevent this.
> >
> > Bill Wendling (4):
> >   x86: realmode: mark exec_in_big_real_mode as noinline
> >   x86: svm: mark test_run as noinline
> >   x86: umip: mark do_ring3 as noinline
> >   x86: vmx: mark some test_* functions as noinline
> >
> >  x86/realmode.c | 2 +-
> >  x86/svm.c      | 2 +-
> >  x86/umip.c     | 2 +-
> >  x86/vmx.c      | 6 +++---
> >  4 files changed, 6 insertions(+), 6 deletions(-)
> >
> > --
> > 2.33.0.rc2.250.ged5fa647cd-goog
> >
