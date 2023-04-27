Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA16F0A09
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244226AbjD0Qja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243926AbjD0Qj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 12:39:27 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B410CA
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 09:39:26 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f0a2f8216fso762471cf.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 09:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682613566; x=1685205566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIjXX7phm/HXUkE/zAWUTn8Cyp5rxQP8GDd/KT6AjjQ=;
        b=O6ogRyE2jPxadE8InkvTZplrQG/GOX4wn01RqD4zTUQN+Ze7jkq3FtjfUpCC8w6ng2
         JblunMd6qvE1Jq5FJWuDDYQmchRtn9ExyJCN6w9j3uJKpIW/Zx5iuLBPTE3gijPJk5FA
         PpaElGxfeoDfzrRIIZBX15Rz78eI2RflyuEBngmpLk+MKZGWm4W82vlxmGZ0DZbc767m
         56FhhMPDOZJA9LW1XGNdM/r4Ix4NpEXwmkGafPoT8H+HlALCN+W8ggPBR3a5M6EddRHF
         8YO1NMA2pO/hNN3OSXgxzBLGPFzL3oBYARsH/0TKw3QK4gUZj2HR+rc+JzD/rvzuTNpR
         Dz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682613566; x=1685205566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIjXX7phm/HXUkE/zAWUTn8Cyp5rxQP8GDd/KT6AjjQ=;
        b=hsl8Q3WuEmjOa0les887aY+KLsTWDjVBLqH2GUrhtHmSTgGDTKdAV/Bw/z3UQym4Rp
         PpvmbfmVSRH+MLactHvpQoqCsDZPemTpUd3tCxuXmrcONI2PUnaDiZnax/vO8x5XlosF
         CJiTolIDdwDzX6WZPwlYw3RviBemxt/8lh/bKzD/1PgebfliR1T/82CHAGgwS1Z6TJC4
         kL1hEf28r6F/WtkKTCF8995WhHuWIRwRx1tL3PIymIZOP4vQVE+6ZSmqAWuI4h2/FWo/
         JS/QFn5eXWC/zXctH2mh57ZpUX9FmAf6RRgSRI+AEAoiCbXOt27VsyrR6Qe/81MLoIZm
         h7DQ==
X-Gm-Message-State: AC+VfDzRleTyjqysyBpkffa88g7ukPBi5lS/uTxKkao6s+QstXwpFfD4
        Uvh80Lw4sXXWpX4H9W9BqpH76OVO1j0IE+XsaSuioA==
X-Google-Smtp-Source: ACHHUZ43E6iZJPmnsIMcKxLsuhRauRHzD9LUvAIf3Sl6KN2Xz/BGP7o2e5Zx0pG5rQ7NBL221LCp+fxroCkpyuZW/Fc=
X-Received: by 2002:ac8:4e4c:0:b0:3ef:343b:fe7e with SMTP id
 e12-20020ac84e4c000000b003ef343bfe7emr371547qtw.2.1682613565812; Thu, 27 Apr
 2023 09:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <307D798E-9135-41F7-80C7-1E0758259F95@gmail.com>
In-Reply-To: <307D798E-9135-41F7-80C7-1E0758259F95@gmail.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 27 Apr 2023 09:38:49 -0700
Message-ID: <CADrL8HVtbfe2OwsELmrrG8eKEQRPfYD1muj4qM2bOHyRU5AgjQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Anish Moorthy <amoorthy@google.com>, Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
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

On Mon, Apr 24, 2023 at 5:54=E2=80=AFPM Nadav Amit <nadav.amit@gmail.com> w=
rote:
>
>
>
> > On Apr 24, 2023, at 5:15 PM, Anish Moorthy <amoorthy@google.com> wrote:
> >
> > On Mon, Apr 24, 2023 at 12:44=E2=80=AFPM Nadav Amit <nadav.amit@gmail.c=
om> wrote:
> >>
> >>
> >>
> >>> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wro=
te:
> >>>
> >>> On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit <nadav.amit@gmail=
.com> wrote:
> >>>>
> >>>> If I understand the problem correctly, it sounds as if the proper so=
lution
> >>>> should be some kind of a range-locks. If it is too heavy or the inte=
rface can
> >>>> be changed/extended to wake a single address (instead of a range),
> >>>> simpler hashed-locks can be used.
> >>>
> >>> Some sort of range-based locking system does seem relevant, although =
I
> >>> don't see how that would necessarily speed up the delivery of faults
> >>> to UFFD readers: I'll have to think about it more.
> >>
> >> Perhaps I misread your issue. Based on the scalability issues you rais=
ed,
> >> I assumed that the problem you encountered is related to lock contenti=
on.
> >> I do not know whether your profiled it, but some information would be
> >> useful.
> >
> > No, you had it right: the issue at hand is contention on the uffd wait
> > queues. I'm just not sure what the range-based locking would really be
> > doing. Events would still have to be delivered to userspace in an
> > ordered manner, so it seems to me that each uffd would still need to
> > maintain a queue (and the associated contention).
>
> There are 2 queues. One for the pending faults that were still not report=
ed
> to userspace, and one for the faults that we might need to wake up. The s=
econd
> one can have range locks.
>
> Perhaps some hybrid approach would be best: do not block on page-faults t=
hat
> KVM runs into, which would prevent you from the need to enqueue on fault_=
wqh.

Hi Nadav,

If we don't block on the page faults that KVM runs into, what are you
suggesting that these threads do?

1. If you're saying that we should kick the threads out to userspace
and then read the page fault event, then I would say that it's just
unnecessary complexity. (Seems like this is what you mean from what
you said below.)
2. If you're saying they should busy-wait, then unfortunately we can't
afford that.
3. If it's neither of those, could you clarify?

>
> But I do not know whether the reporting through KVM instead of
> userfaultfd-based mechanism is very clean. I think that an IO-uring based
> solution, such as the one I proposed before, would be more generic. Actua=
lly,
> now that I understand better your use-case, you do not need a core to pol=
l
> and you would just be able to read the page-fault information from the IO=
-uring.
>
> Then, you can report whether the page-fault blocked or not in a flag.

This is a fine idea, but I don't think the required complexity is
worth it. The memory fault info reporting piece of this series is
relatively uncontentious, so let's assume we have it at our disposal.

Now, the complexity to make KVM only attempt fast GUP (and EFAULT if
it fails) is really minimal. We automatically know that we don't need
to WAKE and which address to make ready.  Userspace is also able to
resolve the fault: UFFDIO_CONTINUE if we haven't already, then
MADV_POPULATE_WRITE if we have (forces userspace page tables to be
populated if they haven't been, potentially going through userfaultfd
to do so, i.e., if UFFDIO_CONTINUE wasn't already done).

It sounds like what you're suggesting is something like:
1. KVM attempts fast GUP then slow GUP.
2. In slow GUP, queue a "non-blocking" userfault, but don't go to
sleep (return with VM_FAULT_SIGBUS or something).
3. The vCPU thread gets kicked out to userspace with EFAULT (+ fault
info if we've enabled it).
4. Read a fault from the userfaultfd or io_uring.
5. Make the page ready, and if it were non-blocking, then don't WAKE.

I have some questions/thoughts with this approach:
1. Is io_uring the only way to make reading from a userfaultfd scale?
Maybe it's possible to avoid using a wait_queue for "non-blocking"
faults, but then we'd need a special read() API specifically to
*avoid* the standard fault_pending_wqh queue. Either approach will be
quite complex.
2. We'll still need to annotate KVM in the same-ish place to tell
userfaultfd that the fault should be non-blocking, but we'll probably
*also* need like GUP_USERFAULT_NONBLOCK and/or
FAULT_FLAG_USERFAULT_NOBLOCK or something. (UFFD_FEATURE_SIGBUS does
not exactly solve this problem either.)
3. If the vCPU thread is getting kicked out to userspace, it seems
like there is no way for it to find/read the #pf it generated. This
seems problematic.

>
> >
> > With respect to the "sharding" idea, I collected some more runs of the
> > self test (full command in [1]). This time I omitted the "-a" flag, so
> > that every vCPU accesses a different range of guest memory with its
> > own UFFD, and set the number of reader threads per UFFD to 1.
>
> Just wondering, did you run the benchmark with DONTWAKE? Sounds as if the
> wake is not needed.
>

Anish's selftest only WAKEs when it's necessary[1]. IOW, we only WAKE
when we actually read the #pf from the userfaultfd. If we were to WAKE
for each fault, we wouldn't get much of a scalability improvement at
all (we would still be contending on the wait_queue locks, just not
quite as much as before).

[1]: https://lore.kernel.org/kvm/20230412213510.1220557-23-amoorthy@google.=
com/

Thanks for your insights/suggestions, Nadav.

- James
