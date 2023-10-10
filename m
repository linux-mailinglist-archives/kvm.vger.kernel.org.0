Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1737C43A8
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 00:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjJJWWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 18:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjJJWWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 18:22:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38B98
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:22:08 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3226b8de467so5801039f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696976527; x=1697581327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJR3kzvdFAtjI4futU9HjQ8SFStLu7+FAsB2B+oCyxc=;
        b=P1497PtIUYMhMuqDYt+f1fy/SAiX1+io2/GSEU5Lpw1nRHbz3jOpH9m3TbB0pDGVr0
         Kxh2iaJSFJDG1MqBwDWS4bgO+GyFlFq3Wmz6xGwpRTOM7ZYYFIMl2hz6fGk8sbiSda9i
         LW84lpMhZLvalYnRXNeXgenIRcmyyy08xe62YwDC/nfksb5L/yVD0LvRPEDuqYtfGDg5
         dC1mBrVb108UKdlUK4XWkzOs77qLDiLPfnts8jm/mve4u40oUgZ1PjDUlIdL18LEazsW
         QUShs7mbCQa37y0WpO5TMgxCPhfVYaKfkrk3hqmW+mJY1C4IKjVD7VtPKu36sxanFROd
         IsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696976527; x=1697581327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJR3kzvdFAtjI4futU9HjQ8SFStLu7+FAsB2B+oCyxc=;
        b=BvaP2zg7P0gPioAmbRI98QNq/xOpm8Lq/ldXRKX+DTxc/pG10r1jb6KFtATis01a7Q
         VEs3xVtTfZhlVr5KVMnjkTOhR4f/BBknGnUIYQ3l2AM1lu4QC8X00z1QhEQeNyQUEab1
         fGHgWuD0y0CkMVU1lwQRQo6SnYvJ/ppTZGybvDMrnd9uHFVkaYEnHQDIcZY9DOJTpyHq
         epWW0WV3fVkBEjEbGbnR3ZUEXBp1c9AD9YvkpOcQd6vru26CSWuOskLRxr56hSiNm7SG
         MN+TE1KAmU/MTLvFfQ0WH1NlhZgMAI6+mQwS6jyq7IMZbsM6L6czHv8Jvo3D0QkFSP3E
         WY5g==
X-Gm-Message-State: AOJu0Yx/7cuOLIyjcnDQyC2U59abW3GNnP5JtvejqErl4qfMGLS5x3T2
        gcNVaRMcp4M2y8xAlVXmYsBbJw9k3Z9Z4iuumQOOSg==
X-Google-Smtp-Source: AGHT+IE6wUAcmy5tCDBI++Cod8BpbZvHkWf4nr2c4NaKC7jYGq++eFgXeJn8k5isETu4e/PYxkU5T6JY0G5SV14gtk0=
X-Received: by 2002:a5d:56d0:0:b0:31c:5c77:48ec with SMTP id
 m16-20020a5d56d0000000b0031c5c7748ecmr15648255wrw.62.1696976526640; Tue, 10
 Oct 2023 15:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com> <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
 <ZR88w9W62qsZDro-@google.com>
In-Reply-To: <ZR88w9W62qsZDro-@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 10 Oct 2023 15:21:37 -0700
Message-ID: <CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 3:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Oct 05, 2023, Anish Moorthy wrote:
> > On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace =
could be
> > > "unreliable" is if something other than a memory_fault exit clobbered=
 the union,
> > > but didn't signal its KVM_EXIT_* reason.  And that would be an egregi=
ous bug that
> > > isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption =
would affect
> > > each and every other KVM_EXIT_* reason.
> >
> > Keep in mind the case where an "unreliable" annotation sets up a
> > KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
> > unrelated comes up and causes KVM_RUN to EFAULT. Although this at
> > least is a case of "outdated" information rather than blatant
> > corruption.
>
> Drat, I managed to forget about that.
>
> > IIRC the last time this came up we said that there's minimal harm in
> > userspace acting on the outdated info, but it seems like another good
> > argument for just restricting the annotations to paths we know are
> > reliable. What if the second EFAULT above is fatal (as I understand
> > all are today) and sets up subsequent KVM_RUNs to crash and burn
> > somehow? Seems like that'd be a safety issue.
>
> For your series, let's omit
>
>   KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page
>
> and just fill memory_fault for the page fault paths.  That will be easier=
 to
> document too since we can simply say that if the exit reason is KVM_EXIT_=
MEMORY_FAULT,
> then run->memory_fault is valid and fresh.

+1

And from a performance perspective, I don't think we care about
kvm_vcpu_read/write_guest_page(). Our (Google) KVM Demand Paging
implementation just sends any kvm_vcpu_read/write_guest_page()
requests through the netlink socket, which is just a poor man's
userfaultfd. So I think we'll be fine sending these callsites through
uffd instead of exiting out to userspace.

And with that out of the way, is there any reason to keep tying
KVM_EXIT_MEMORY_FAULT to -EFAULT? As mentioned in the patch at the top
of this thread, -EFAULT is just a hack to allow the emulator paths to
return out to userspace. But that's no longer necessary. I just find
it odd that some KVM_EXIT_* correspond with KVM_RUN returning an error
and others don't. The exit_reason is sufficient to tell userspace
what's going on and has a firm contract, unlike -EFAULT which anything
KVM calls into can return.

>
> Adding a flag or whatever to mark the data as trustworthy would be the al=
ternative,
> but that's effectively adding ABI that says "KVM is buggy, sorry".
>
> My dream of having KVM always return useful information for -EFAULT will =
have to
> wait for another day.
