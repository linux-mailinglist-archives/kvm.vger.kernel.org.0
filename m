Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB766FF88A
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbjEKRep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 13:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbjEKRel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 13:34:41 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C14D4EDE
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 10:34:04 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-619ca08c166so41756306d6.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 10:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683826441; x=1686418441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njZjRlZanOe9JxkaaGMcvp70MS1np9W6KpKyiZVcv2M=;
        b=XE3NX3VGLjB4V6Ldj9kT6I3bTEb8H5agCp72h28M2VC4ys6UC7JNufrQl0ufVJWdFs
         D7gloz90mAumfLdqv8f/C0lkfdp2lSjRb8zchAwGxSij9eB/M08scbTi9Tq79TJBvW0o
         zM5QjaCcEMVRVRPPC6xS6TLaGTZSmk0pQ06T7ArXdUrLksP/hBF4LmK5s1iXktMudJrs
         IO/Qgk7DkhgzRlFpSzQs6aSkkVdaFyDbZ4Qld5r3ZvjRLXEq3e0b6YHxn9DkgQBxmVQq
         iJq7ocUVGc3+4RomjXtLhSWjzhyGxrjuOokI/ibXJjLdKlwcZeXA6h1LOQqp6rmDW0BZ
         W26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683826441; x=1686418441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njZjRlZanOe9JxkaaGMcvp70MS1np9W6KpKyiZVcv2M=;
        b=Vn6pxbLb0forcxvFHMXDUGrIIfq/dlF35vXSNp42SnRMAqKnE/91XrkRu6sGL2bmBO
         Vl5a7w0D2lOOQ8OjIiXm3dmbdxdRdpJhvZNEG8rmtIk5NFVwUgT/bV8vsQCxi8sxlQvI
         DZ9KQok8DWPwFO+B3gneKVYSLLZbwHJueXyFqfuj1URA9lRA8IA+qoiHHeA7kst0mDNi
         4wfqvsygHsvLF0zqjSpSrTu+ZKp+uMPSKqaZTllpP6M2c15ofYOxLCY11srOHIpid6g7
         gRNxanrVK6rfQ1C8kG8Y1pNYWg1GYdaOnBAv/XA0+VIzuFYrRFmynrC0GZq7IH9++NNN
         Mpdg==
X-Gm-Message-State: AC+VfDzqdATeykuiUP5eRhqiUyJuFByec3bXFJyMODEcfHrRUDCL0pOO
        kIS6T7QUrV0IJZeuT7XUl5xInxr/TYYAXVUxMYXN4A==
X-Google-Smtp-Source: ACHHUZ47WT8nMWKZMuTJuDef1x+Bt34kZ+00zECHRddyeptzTMSS8LINilvQvcTpfM5HyWBZLz+yISlQt+3xQxRoP5g=
X-Received: by 2002:ad4:4ee3:0:b0:5f0:f0c3:59a8 with SMTP id
 dv3-20020ad44ee3000000b005f0f0c359a8mr35507713qvb.22.1683826440952; Thu, 11
 May 2023 10:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n> <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
In-Reply-To: <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 11 May 2023 10:33:24 -0700
Message-ID: <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
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

On Thu, May 11, 2023 at 10:18=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On Wed, May 10, 2023 at 2:50=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.com> w=
rote:
> >
> > What I wanted to do is to understand whether there's still chance to
> > provide a generic solution.  I don't know why you have had a bunch of p=
mu
> > stack showing in the graph, perhaps you forgot to disable some of the p=
erf
> > events when doing the test?  Let me know if you figure out why it happe=
ned
> > like that (so far I didn't see), but I feel guilty to keep overloading =
you
> > with such questions.
> >
> > The major problem I had with this series is it's definitely not a clean
> > approach.  Say, even if you'll all rely on userapp you'll still need to
> > rely on userfaultfd for kernel traps on corner cases or it just won't w=
ork.
> > IIUC that's also the concern from Nadav.
>
> This is a long thread, so apologies if the following has already been dis=
cussed.
>
> Would per-tid userfaultfd support be a generic solution? i.e. Allow
> userspace to create a userfaultfd that is tied to a specific task. Any
> userfaults encountered by that task use that fd, rather than the
> process-wide fd. I'm making the assumption here that each of these fds
> would have independent signaling mechanisms/queues and so this would
> solve the scaling problem.
>
> A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
> vCPU for handling userfault requests. This seems like it'd have
> roughly the same scalability characteristics as the KVM -EFAULT
> approach.

I think this would work in principle, but it's significantly different
from what exists today.

The splitting of userfaultfds Peter is describing is splitting up the
HVA address space, not splitting per-thread.

I think for this design, we'd need to change UFFD registration so
multiple UFFDs can register the same VMA, but can be filtered so they
only receive fault events caused by some particular tid(s).

This might also incur some (small?) overhead, because in the fault
path we now need to maintain some data structure so we can lookup
which UFFD to notify based on a combination of the address and our
tid. Today, since VMAs and UFFDs are 1:1 this lookup is trivial.

I think it's worth keeping in mind that a selling point of Anish's
approach is that it's a very small change. It's plausible we can come
up with some alternative way to scale, but it seems to me everything
suggested so far is likely to require a lot more code, complexity, and
effort vs. Anish's approach.
