Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB597209CB
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 21:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbjFBTab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 15:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbjFBTa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 15:30:29 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B876CE
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 12:30:28 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-33bf12b5fb5so19785ab.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685734228; x=1688326228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2UeLHRfYzRLFdZL2qEZ6XzD7paeBHNdpikCSpYNgvzo=;
        b=tEARi5O1UxtL2NOwRx1hLOwVe808SRH0VsyhOBd1O811kanjXaAZdhpJFP7R3Hxsxf
         ZZukRIek14FKiMnd2UJrDbV2a3YNK4WhzFBTXxCMd+nu/ABsMcFOTEkgHa0QJcxKNQDb
         nBNpD4i3VlJCoaFl6gZFBxSxIYuX6oSebCiOjzeSElK+lWCLzz+bEBOKRexUVksQYuDX
         YvG9FVFqT+GmPrAzC4n9ex91Mj8iLgKzCKJ3+K6cjXOj+gWJj6maHfbtsMLWM20ISyXj
         SbXb1lv/qUIHDNItQurVd0bzKf4f6z2BELdPb7wb82OGS0u6D03I98qF6E/8fG/b/+C7
         cgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685734228; x=1688326228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2UeLHRfYzRLFdZL2qEZ6XzD7paeBHNdpikCSpYNgvzo=;
        b=HsiDvVbs2h9eVdhS+snEVuF0oKydWlJp9nylr/IVnYgecYf0PWWphjCNy3JKSR1fVc
         nUiI+/9vK4SAaTs24c+kATt+4GyOT6Zer7In+bCMoup6OV/5t5MuX3W8FdI+DKFZlBZ/
         A0lNNiAy2yzH4uRVEg1WvfqZEJqUd6eVxEq+iMAf9CT0oV/2XgpSH+2DcsLZAYIYMbrm
         yPILsTfGMPvFI2hpd/CfgQkGsPnfzZZXu72VYBCnR/mwgBiVLcrhu7xD0wnR9bZcYB5E
         Tduuz9m8BUHAUEFKKfbvIDGV/PPk1biEbBzyv3rk5hi0JEykOiubR6dHc92RNr4mSPeO
         A3hA==
X-Gm-Message-State: AC+VfDyd23GzhjPYeybMXFpsBh7VclohKPBq4IGfJ+OEot33lOOqTK7o
        3UcrtSjk3zsP0Yp/3cr9sC2nbUp6PevF2cz38O9rRg==
X-Google-Smtp-Source: ACHHUZ5kE7Z2gO6iPFP7mnwbD7stGYUIm0Ymn7hTvXMkULg/2ghyxb+dOqeKUdIILouhQfs5mLgKXKudGGVWr0kGH0s=
X-Received: by 2002:a05:6e02:1baa:b0:32f:7715:4482 with SMTP id
 n10-20020a056e021baa00b0032f77154482mr306912ili.4.1685734227741; Fri, 02 Jun
 2023 12:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com>
In-Reply-To: <ZHpAFOw/RW/ZRpi2@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Jun 2023 12:30:16 -0700
Message-ID: <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gao Shiyuan <gaoshiyuan@baidu.com>, pbonzini@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, likexu@tencent.com
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

On Fri, Jun 2, 2023 at 12:16=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jun 02, 2023, Jim Mattson wrote:
> > On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@baidu.c=
om> wrote:
> > >
> > > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> > >
> > > When live-migrate VM on icelake microarchitecture, if the source
> > > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
> > > number of vPMU fixed counters to 3") and the dest host kernel after t=
his
> > > commit, the migration will fail.
> > >
> > > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM and
> > > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM's
> > > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x700000=
0ff.
> > > This inconsistency leads to migration failure.
>
> IMO, this is a userspace bug.  KVM provided userspace all the information=
 it needed
> to know that the target is incompatible (3 counters instead of 4), it's u=
serspace's
> fault for not sanity checking that the target is compatible.
>
> I agree that KVM isn't blame free, but hacking KVM to cover up userspace =
mistakes
> everytime a feature appears or disappears across kernel versions or confi=
gs isn't
> maintainable.

Um...

"You may never migrate this VM to a newer kernel. Sucks to be you."

That's not very user-friendly.
