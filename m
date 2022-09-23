Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638965E828B
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 21:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiIWTZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 15:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiIWTZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 15:25:13 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1446A3D64
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 12:25:12 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id r125so1000255oia.8
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 12:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=Fmt9MN5NfVGezrHnd/u5tnrRyL7gHvPLtsOh+992pbU=;
        b=WEl6sZEBc/er/wrMM35U7lFP3w+PTJQFGCbt1lZDTIetLI4Rm63YyLyS/WM+R6Ofyf
         Mstp0lkuGo9MJ6Euwn5DZjScS7cfV4aXTa24myZmIw1qdlt/1TLQDW9dzYEYgX0oiU77
         URtbyL2i6E2NkMPqPYNXQ3xIfeYgcxpMBbG4D3HPoCWB6ZBFDkwXFqs4CQrqDApyzAvF
         tOeg++TqPTTqnZaerFv95l7KaK4ix+rDlKNrJQkgvPqPwhfYGP9djaj96kC/1JC85VEn
         ZH8r+XDoeQZwmw/MWp3HKLjJ+/mZ4TV7pIDuLeV75bRaXXjjNuP/N27spJWuM9KJ04HV
         Ehdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Fmt9MN5NfVGezrHnd/u5tnrRyL7gHvPLtsOh+992pbU=;
        b=kp3cPjA3mNYgkgWtm4OAJgedxvuB7AT9Q/FJnruLIMt6Mm5whvK9MFqFdn3MLKCpiE
         ugaEYXYcSNdui1qP0gLwL8qAioPZ+7oq9XkEERLdffMFSgAybauPOb4nUP2SjRmDS6UW
         phNz7rObSRR1rKcEWrKUCMNYEeldhAIBn98d8FGZLuCA6fsNImMjC5E+zl3LctehO6Ru
         LltTVzi2BaIAulZvHhfEksUOJCNPkqILJ+YCbhtjW6Myvn24ANb7vXCc134q0MBVj0JJ
         a1Pgaw1QaewFsTtUd29gur4FISUR9+wgvJ7Wozg0jdW+fKUHwZIFBck4ElcC+0Q7FF/N
         MqrQ==
X-Gm-Message-State: ACrzQf2LGidE0kdyEYtE3TlbGTLu7uDilVqePx3yQlyCXT2oY0MeEWFk
        S9z6niMcUzUFK7jA0hCifiN0PF5+0loH3rsxv1Y2xDy8Ddkq7Q==
X-Google-Smtp-Source: AMsMyM6opd6tAaE8wRmRyYEbDHJ63Wicor8tHC/tbYo2If3Cb3Kt7nmAFS/JTZ22c/dYX0G0TUIRiAiMBO0/qrhGl8A=
X-Received: by 2002:a05:6808:f8e:b0:351:a39:e7ca with SMTP id
 o14-20020a0568080f8e00b003510a39e7camr3317295oiw.269.1663961111771; Fri, 23
 Sep 2022 12:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
In-Reply-To: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Sep 2022 12:25:00 -0700
Message-ID: <CALMp9eSJbb6sSmv4c8c3ebCtfgdAARgryq5jHXdRmhxm6fYQsw@mail.gmail.com>
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
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

On Fri, Sep 23, 2022 at 3:16 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> Hi!
>
> Me and Emanuele Giuseppe Esposito were working on trying to understand wh=
y the access_tracking_perf_test
> fails when run in a nested guest on Intel, and I finally was able to find=
 the root casue.
>
> So the access_tracking_perf_test tests the following:
>
> - It opens /sys/kernel/mm/page_idle/bitmap which is a special root read/w=
ritiable
> file which allows a process to set/clear the accessed bit in its page tab=
les.
> the interface of this file is inverted, it is a bitmap of 'idle' bits
> Idle bit set =3D=3D=3D dirty bit is clear.
>
> - It then runs a KVM guest, and checks that when the guest accesses its m=
emory
> (through EPT/NPT), the accessed bits are still updated normally as seen f=
rom /sys/kernel/mm/page_idle/bitmap.
>
> In particular it first clears the accesssed bit using /sys/kernel/mm/page=
_idle/bitmap,
> and then runs a guest which reads/writes all its memory, and then
> it checks that the accessed bit is set again by reading the /sys/kernel/m=
m/page_idle/bitmap.
>
>
>
> Now since KVM uses its own paging (aka secondary MMU), mmu notifiers are =
used, and in particular
> - kvm_mmu_notifier_clear_flush_young
> - kvm_mmu_notifier_clear_young
> - kvm_mmu_notifier_test_young
>
> First two clear the accessed bit from NPT/EPT, and the 3rd only checks it=
s value.
>
> The difference between the first two notifiers is that the first one flus=
hes EPT/NPT,
> and the second one doesn't, and apparently the /sys/kernel/mm/page_idle/b=
itmap uses the second one.
>
> This means that on the bare metal, the tlb might still have the accessed =
bit set, and thus
> it might not set it again in the PTE when a memory access is done through=
 it.
>
> There is a comment in kvm_mmu_notifier_clear_young about this inaccuracy,=
 so this seems to be
> done on purpose.
>
> I would like to hear your opinion on why it was done this way, and if the=
 original reasons for
> not doing the tlb flush are still valid.
>
> Now why the access_tracking_perf_test fails in a nested guest?
> It is because kvm shadow paging which is used to shadow the nested EPT, a=
nd it has a "TLB" which
> is not bounded by size, because it is stored in the unsync sptes in memor=
y.
>
> Because of this, when the guest clears the accessed bit in its nested EPT=
 entries, KVM doesn't
> notice/intercept it and corresponding EPT sptes remain the same, thus lat=
er the guest access to
> the memory is not intercepted and because of this doesn't turn back
> the accessed bit in the guest EPT tables.

Does the guest execute an INVEPT after clearing the accessed bit?

From volume 3 of the SDM, section 28.3.5 Accessed and Dirty Flags for EPT:

> A processor may cache information from the EPT paging-structure entries i=
n TLBs and paging-structure caches (see Section 28.4). This fact implies th=
at, if software changes an accessed flag or a dirty flag from 1 to 0, the p=
rocessor might not set the corresponding bit in memory on a subsequent acce=
ss using an affected guest-physical address.

> (If TLB flush were to happen, we would 'sync' the unsync sptes, by zappin=
g them because we don't
> keep sptes for gptes with no accessed bit)
>
>
> Any comments are welcome!
>
> If you think that the lack of the EPT flush is still the right thing to d=
o,
> I vote again to have at least some form of a blacklist of selftests which
> are expected to fail, when run under KVM (fix_hypercall_test is the other=
 test
> I already know that fails in a KVM guest, also without a practical way to=
 fix it).
>
>
> Best regards,
>         Maxim Levitsky
>
>
> PS: the test doesn't fail on AMD because we sync the nested NPT on each n=
ested VM entry, which
> means that L0 syncs all the page tables.
>
> Also the test sometimes passes on Intel when an unrelated TLB flush syncs=
 the nested EPT.
>
> Not using the new tdp_mmu also 'helps' by letting the test pass much more=
 often but it still
> fails once in a while, likely because of timing and/or different implemen=
tation.
>
>
>
