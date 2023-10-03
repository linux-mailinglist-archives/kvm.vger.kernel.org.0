Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653487B7571
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbjJCXqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237474AbjJCXqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:46:31 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6229EAF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:46:28 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27731a63481so1297493a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 16:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696376788; x=1696981588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gaHRh+iyoB6/OttqFX2Q86pGvl0bhGVCVyqFTvtoGcw=;
        b=zeSJ/jk87sZLLQE3qHWB5Onl/GnOQfZiDOraNhrrCtssbqZAA1MS1ukg7TKv596X2v
         r9dBnSAFnEYzXw1YhYt+pLvoCa0omHCo/CDL9PWdgws7U+/nf6DLhti/pVo6DBZisBJq
         6pAtIkBTtcSU4yGLlSew038ojTMHlLqRqzPj6wzUoO1WJvYJlWDQ2/x4Mm8CUAUYD6k9
         6yOdRPNNieeXwa2j8xrRZUw1YvmPYXilCWLgoMQ497c7mVsWMp7f9rPgHAc/OBm47B3g
         YAmu8QrG9A2PvbfMF94kbzWWt2mpHDgC5yMHMnSxYTb+gReZXWk51QzfPLS9JefE8ZcU
         Zvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696376788; x=1696981588;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gaHRh+iyoB6/OttqFX2Q86pGvl0bhGVCVyqFTvtoGcw=;
        b=mxhwuBfWyyTTQjqO6dd7aeJHgPb+UOFjEo/FvubSEXyTlauqMaS4o9OWne2vlXZkOk
         xZhtdjVibxZhEcKBfHMRg1qaX14urakaM7Wfwj4yR7TiRN8X4sGPajCs2bSKrv2Vx67n
         kEF5Ne8YaRivUD2MpONEHW9A3PkskKRY4eHQ5mZGvoM4zuP3RcorzrTMrfmC2MxvwIZi
         1YmKtRIz01jdswVXrU5ffc0Q9Rk583kA6bgvjkzsPpu2yCF2x28RaB1+XFbGm8+q0qaY
         fXQmb0FsehgJsdvP4QhXfMITo7RVAENNRRE0+iI4BCN8DZciGm+kEh6BvfAhLq8Cx7P4
         IzgQ==
X-Gm-Message-State: AOJu0Yxf8LryzxEEHY+1w4L/ZZicLa6nj9hzOILRu7SvQWqzwMjWazlv
        Y4sPd3cGqmlhmnuD3Zkq06RKezDkKWU=
X-Google-Smtp-Source: AGHT+IE1XHpyO3fF4751nYD6L1cufL1XUM2b3xSCMQMb58rp5yQSCvcWy8YfsNAskAty/E/22t80Ux7giMw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8186:b0:274:6af0:d75b with SMTP id
 e6-20020a17090a818600b002746af0d75bmr12051pjn.7.1696376787828; Tue, 03 Oct
 2023 16:46:27 -0700 (PDT)
Date:   Tue, 3 Oct 2023 16:46:26 -0700
In-Reply-To: <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
Message-ID: <ZRyn0nPQpbVpz8ah@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023, Anish Moorthy wrote:
> On Mon, Oct 2, 2023 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > > - I should go drop the patches annotating kvm_vcpu_read/write_page
> > > from my series
> >
> > Hold up on that.  I'd prefer to keep them as there's still value in giv=
ing userspace
> > debug information.  All I'm proposing is that we would firmly state in =
the
> > documentation that those paths must be treated as informational-only.
>=20
> Userspace would then need to know whether annotations were performed
> from reliable/unreliable paths though, right? That'd imply another
> flag bit beyond the current R/W/E bits.

No, what's missing is a guarantee in KVM that every attempt to exit will ac=
tually
make it to userspace.  E.g. if a different exit, including another memory_f=
ault
exit, clobbers an attempt to exit, the "unreliable" annotation will never b=
e seen
by userspace.

The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace could =
be
"unreliable" is if something other than a memory_fault exit clobbered the u=
nion,
but didn't signal its KVM_EXIT_* reason.  And that would be an egregious bu=
g that
isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption would =
affect
each and every other KVM_EXIT_* reason.

The "informational only" part is that userspace can't develop features that
*require* KVM to exit.

> > > - The helper function [a] for filling the memory_fault field
> > > (downgraded back into the current union) can drop the "has the field
> > > already been filled?" check/WARN.
> >
> > That would need to be dropped regardless because it's user-triggered (s=
adly).
>=20
> Well the current v5 of the series uses a non-userspace visible canary-
> it seems like there'd still be value in that if we were to keep the
> annotations in potentially unreliable spots. Although perhaps that
> test failure you noticed [1] is a good counter-argument, since it
> shows a known case where a current flow does multiple writes to the
> memory_fault member.

The problem is that anything but a WARN will go unnoticed, and we can't hav=
e any
WARNs that are user-triggerable, at least not in upstream.  Internally, we =
can
and probably should add a canary, and an aggressive one at that, but I can'=
t think
of a sane way to add a canary in upstream while avoiding the known offender=
s. :-(

> [1] https://lore.kernel.org/all/202309141107.30863e9d-oliver.sang@intel.c=
om
>=20
> > Anyways, don't do anything just yet.
>=20
> :salutes:

LOL
