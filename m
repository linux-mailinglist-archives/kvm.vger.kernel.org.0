Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87376ED942
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 02:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjDYAQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 20:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDYAQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 20:16:27 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4737A5585
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:16:26 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-763c3429a8cso38666039f.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 17:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682381785; x=1684973785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYjYx2JYgMep7ykgw713/kJqG1zOdgowgQyCGeaWEOM=;
        b=bZ7x0Fqh8VqcZJLI6uXAMdtjih4a9KY2QUtSsDn+zJ2CTbuOXb7e0pmC1b5jhmV0SZ
         IDgLLrUZIqa5oLlUmfSKgvFAU0eMBM0H126E4An+dCZylUjH9oDa+ahtknCQmUt4dxF2
         64vjWcDBs5i6n+7jmAVdtecXmDmS2LyIJZWeOy3vcK4GW1WqoSzwiVMwcqbZVJ42DKuI
         cJqQgIwYYgZmmLoFhFfEH7LWNRFr3CwQssFfh1nXEdx9WyCcHI5KmSLdAhEvWJD4WGhb
         9CEWXZ2CRX94CGNyWNUyAzB4zKD1ewfAhxYjLCTiB5VOyRHfCyZbyuvSE6fOrrcQCQ2x
         PXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682381785; x=1684973785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYjYx2JYgMep7ykgw713/kJqG1zOdgowgQyCGeaWEOM=;
        b=EhUMENpsBBoJtPpVUKsAUXXhhQhkMKzymW4/414MwjM8zZytzUImD7G5ZlxPnM2a02
         hP8vyVYOZZW79DjoNdBPLXhcwONr2DumASxNNjXURazhOkAL6f/cCWT4D1cox+fUIWOm
         fwyHTvU5fhFyEv/U5eurjdBOuEQw0+HGr4HZUmFSZMgmvf6rEUkHOSl9Ni6JFFkCDGE7
         9SNP22WD9iMHnpHcS6wpbJzBUxmXECbj9c+9+cJbK7J0/jwCiUC+Vn30ohADBJAnuKZc
         oBTtv89r8f3XtleF4jffb14KtAw9LDhfgEZpmjmP8HA62Uwn9bApAdwr3yNrD9ZKysvp
         3SPQ==
X-Gm-Message-State: AAQBX9fHDtJBQA7tra1StFhAwlJINLuOnHO4uwZKcpwexK5gD2Nhvuzm
        s203yz/aCrzTEgGBJKAylqjP/jMU2ZigaHowrKlYeQ==
X-Google-Smtp-Source: AKy350bdbln+TZ4ZAJiXukmbIMgAC1nNj9fC3Dd5rUTgy9CejdNoJYq1YW1y5ahwdGbFPHNWwmcqADgcC4DOQfykySo=
X-Received: by 2002:a5e:8c09:0:b0:763:570c:3a97 with SMTP id
 n9-20020a5e8c09000000b00763570c3a97mr5943427ioj.15.1682381785539; Mon, 24 Apr
 2023 17:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com> <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
In-Reply-To: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 24 Apr 2023 17:15:49 -0700
Message-ID: <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 12:44=E2=80=AFPM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>
>
>
> > On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wrote=
:
> >
> > On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit <nadav.amit@gmail.c=
om> wrote:
> >>
> >> If I understand the problem correctly, it sounds as if the proper solu=
tion
> >> should be some kind of a range-locks. If it is too heavy or the interf=
ace can
> >> be changed/extended to wake a single address (instead of a range),
> >> simpler hashed-locks can be used.
> >
> > Some sort of range-based locking system does seem relevant, although I
> > don't see how that would necessarily speed up the delivery of faults
> > to UFFD readers: I'll have to think about it more.
>
> Perhaps I misread your issue. Based on the scalability issues you raised,
> I assumed that the problem you encountered is related to lock contention.
> I do not know whether your profiled it, but some information would be
> useful.

No, you had it right: the issue at hand is contention on the uffd wait
queues. I'm just not sure what the range-based locking would really be
doing. Events would still have to be delivered to userspace in an
ordered manner, so it seems to me that each uffd would still need to
maintain a queue (and the associated contention).

With respect to the "sharding" idea, I collected some more runs of the
self test (full command in [1]). This time I omitted the "-a" flag, so
that every vCPU accesses a different range of guest memory with its
own UFFD, and set the number of reader threads per UFFD to 1.

vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps=
)
1      180     307
2       85      220
4       80      206
8       39     163
16     18     104
32      8      73
64      4      57
128    1      37
256    1      16

I'm reporting paging rate on a per-vcpu rather than total basis, which
is why the numbers look so different than the ones in the cover
letter. I'm actually not sure why the demand paging rate falls off
with the number of vCPUs (maybe a prioritization issue on my side?),
but even when UFFDs aren't being contended for it's clear that demand
paging via memory fault exits is significantly faster.

I'll try to get some perf traces as well: that will take a little bit
of time though, as to do it for cycler will involve patching our VMM
first.

[1] ./demand_paging_test -b 64M -u MINOR -s shmem -v <n> -r 1 [-w]

> It certainly not my call. But if you ask me, introducing a solution for
> a concrete use-case that requires API changes/enhancements is not
> guaranteed to be the best solution. It may be better first to fully
> understand the existing overheads and agree that there is no alternative
> cleaner and more general solution with similar performance.
>
> Considering the mess that KVM async-PF introduced, I
> would be very careful before introducing such API changes. I did not look
> too much on the details, but some things anyhow look slightly strange
> (which might be since I am out-of-touch with KVM). For instance, returnin=
g
> -EFAULT on from KVM_RUN? I would have assumed -EAGAIN would be more
> appropriate since the invocation did succeed.

I'm not quite sure whether you're focusing on
KVM_CAP_MEMORY_FAULT_INFO or KVM_CAP_ABSENT_MAPPING_FAULT here. But to
my knowledge, none of the KVM folks have objections to either:
hopefully it stays that way, but we'll have to see :)
