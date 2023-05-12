Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A91701288
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbjELXgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjELXgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:36:10 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42EDDF
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:36:09 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-780bb3b96e0so5089479241.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683934569; x=1686526569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WIgooIs+6it1jk2AdDHVBSXEOC4xZCqG+lqKHqRIqwo=;
        b=7gRD7XXq9aZfCMMcnF10YJf/BAGouK4NtW7KY0vfyjNsZza9+n26Wu35s8Mb/3B6h3
         hG4OhErCYm5NDmiUgyaYLj4ZIR+HAl/DIZ7LqD5efIYpVVxA32+dQzTac5GMfZIcx3/G
         6sev1LPIvWIU1ib/gWr29g9sytgW2pVSQw+jhuh3SXxsG+zyG9KsH2AUsXflrDwi3eU9
         Ja4P6JfGV/vLXZjJtQqFc+IF2hiAULG2on4kDv7mzEwHYxKzTHCnJgegh/hIH4NwHgDp
         Ab+8YB8KacaefeULEL91grQ8EMEFeBWrGqu/LmfNgENyKINmXdc7+q2S3AwjoEBFhFhA
         0aGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683934569; x=1686526569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WIgooIs+6it1jk2AdDHVBSXEOC4xZCqG+lqKHqRIqwo=;
        b=LUleC5mzbWjgg+u4mIgUAShmRpzu0uVdZW1p0CpMXHNDDCb+GiR/ozglWgeUqUt6wk
         uA9x1kYgB68DyLSamnQAI/dNnlYxUebs+zePoFZ2beFBGlBzmAMDH1ZDkY+2Nj0q/aUe
         pDYSHvMakT8OjbUBbicJJU1dlzv5bATJne0DPo9tXQHGR/x2yNHiKGOEKj7Ws4a0qHcw
         v5Skz3KRZO26GwacbbWkxJmtBjm6QgBazUMYr9NV+544P2WBQtPm3KSMuk9KrgPtvadp
         X4VXzpVMFmsoZ0SviOYJXvFsLdoUVjGPdGNmbpYt0zeA6vNV3PZsVznArjsNrvGF2srg
         tUMw==
X-Gm-Message-State: AC+VfDzKY0ZLgXOAcNs/cLTWN307aLeeRgXzbbs9VN4crubVJDuVFA4U
        Fios6ByTEqPXN6SbQimfO+WclGEKeaoGYBTudC5jC4Mt1U4WaDO0rj0=
X-Google-Smtp-Source: ACHHUZ43+gfo250bYfTwugnM6ZyzBDBkTn3li6SfB4WXiX9uD5y66Knen+h1QCPU/ugFCWS2A5NexK27W8W8VJjIDJc=
X-Received: by 2002:a67:f9c7:0:b0:434:3acf:3241 with SMTP id
 c7-20020a67f9c7000000b004343acf3241mr10774708vsq.30.1683934568837; Fri, 12
 May 2023 16:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com> <20230511235917.639770-5-seanjc@google.com>
 <ZF7KbsCXBQHnOv7g@google.com> <ZF7MES4qEKd8T6OW@google.com>
In-Reply-To: <ZF7MES4qEKd8T6OW@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 12 May 2023 16:35:42 -0700
Message-ID: <CALzav=cNJSqhbYhoNLTXJ4Kc=ZmgRPOo9U5bqqFTxhdSatnUag@mail.gmail.com>
Subject: Re: [PATCH 4/9] KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
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

On Fri, May 12, 2023 at 4:30=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, May 12, 2023, David Matlack wrote:
> > On Thu, May 11, 2023 at 04:59:12PM -0700, Sean Christopherson wrote:
> > > Rename MMU_WARN_ON() to make it super obvious that the assertions are
> > > all about KVM's MMU, not the primary MMU.
> >
> > I think adding KVM is a step in the right direction but I have 2
> > remaining problems with KVM_MMU_WARN_ON():
> >
> >  - Reminds me of VM_WARN_ON(), which toggles between WARN_ON() and
> >    BUG_ON(), whereas KVM_MMU_WARN_ON() toggles between no-op and
> >    WARN_ON().
>
> No, VM_WARN_ON() bounces between WARN_ON() and nop, just like KVM_MMU_WAR=
N_ON().
> There's an extra bit of magic that adds a static assert that the code is =
valid
> (which I can/should/will add), but the runtime behavior is a nop.

Ah, you're right, I misread VM_WARN_ON().
