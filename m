Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C25B3EAA3E
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHLS36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhHLS36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:29:58 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182C7C061756
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:29:32 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id n17so15042398lft.13
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZPuOYKnJThm5DnalRt4UXLQlArDT4aG/PAjKUg0HeVw=;
        b=GX++fEO8J9HwQl5+UMZcrBWAkh9EvZscWTqeybbmY3/6R4cC9VGrfwpatbe9AHMTW1
         m42nKZyes+ZRqs0i817fF3vvDzp9fD6/hhkcdsGoSS3PfHYT96Pq5BfYgxFQ1GuUQmIC
         k7CbB6iG5hD5/pU6JDv7MUo4HehopFEffLPMy1KeV9eHrc6bTRmb7jJQsemnQ67UNLI4
         0dr4GSUQEybfqghvjC07A5nzS+veTLiIb10v4B0+mhU4aDeX1FsKNetAlZos9xraRsPJ
         iP/I0MPsc2DjTZRvWp+suaZ6y2/naJCEk75lGCKnmPksTxVHj2CnU7vz20s7yYnXenTC
         AUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZPuOYKnJThm5DnalRt4UXLQlArDT4aG/PAjKUg0HeVw=;
        b=txUAQZpHnn4foMHHO1UpdeVyBhjXd2H4QFZezjYGmnh/wq7D7X4g139EupuJKfzfPJ
         5hKd/oek/sQxu8L6QyRiyX0wu5vO1JEMVjLY7S2OfkAa5JB5ONNgn5Cd6oN8CasuE132
         JlE3zLFr8VdNSOxRL3fK4W/rjdlXsCenMbwsI3Vu3pu6s5TNP57jLaMWOTFdwEQ5zjwF
         EsDv4vYukn588A2Uu28zg95ropD0pysAd4qDGVQmL2aBtqnlselSP9pqz2whafwRf/14
         V9cqli6ugbR933uBP3uZ0efCk8s9o3EXKKKJ4zSKJDi9OX4DmZuHsHSI2Pj1rDw42/gY
         R4UQ==
X-Gm-Message-State: AOAM532M8mBEoOIoI2qv0Dyt5/S444in+Jo6UUne9irBCGb7gwtk3HTC
        lS/U2NHvjzVo0VCAQKTjL5zHrGcKOmdb+JTgiZyzpQ==
X-Google-Smtp-Source: ABdhPJwN5OkbvwtSfxbYBdgMU1en7V1uJ3/kTaDUBt6caukn/Xg6eh44cjYswsOyhQRlGX/oo0jLqfvjMcLHjjdlO1s=
X-Received: by 2002:ac2:46ef:: with SMTP id q15mr3554923lfo.407.1628792970213;
 Thu, 12 Aug 2021 11:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210811233744.1450962-1-jingzhangos@google.com> <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
In-Reply-To: <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 12 Aug 2021 11:29:19 -0700
Message-ID: <CAAdAUtiq5v2TMYVEUYWRqn5Bor64NffiR2bEuu9GEt2hd8PZjA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 9:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/08/21 01:37, Jing Zhang wrote:
> > A per VM stat dirty_pages is added to record the number of dirtied pages
> > in the life cycle of a VM.
> > The growth rate of this stat is a good indicator during the process of
> > live migrations. The exact number of dirty pages at the moment doesn't
> > matter. That's why we define dirty_pages as a cumulative counter instead
> > of an instantaneous one.
>
> Why not make it a per-CPU stat?  mark_page_dirty_in_slot can use
> kvm_get_running_vcpu() and skip the logging in the rare case it's NULL.
>
> Paolo
>
Sure, I will make it a per-CPU one in the next version.

Thanks,
Jing
