Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80532780E11
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377557AbjHROeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 10:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377775AbjHROdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 10:33:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E1F3C3E
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 07:33:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589cc9f7506so11842327b3.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692369224; x=1692974024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2hR3F9A9KOcTbP3o+tlS60V9swMZl+xpMhWZXxpVpo=;
        b=20rO6kqKpld40lag2DuHHGzVlGErNSkWpMdpllJcHJi3BUxnvJxcQx4XEURhQfDzSv
         HcARGpCVmUmIGeJKZO+IOjBPhkUXuGBrPH5kT5xw+YFPumcvFP27BdO3Ds5TfhXGUTYI
         bOiVtCyETC81L3nDmtQvH2LW0mhYyXg8zzZLMTWXttFUmZSLU92TWdBtuxohcua5i1Bl
         HILUSWgScMU/V6Zom/c9etRG1Qz6HDKFZ2RKMhtTqaGElgq+0iKa6k5IGYp97H36TNsx
         vXZJQhXaHEt7fiuaN5u2+ffvBRJZ+VffwDO6h3oaN1MB4NJC3lUAKUSChip2pkhGZCdi
         fbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692369224; x=1692974024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E2hR3F9A9KOcTbP3o+tlS60V9swMZl+xpMhWZXxpVpo=;
        b=VhbUshPGBJMG+67NZFiCdLAv/LSi5BevXxamz90siPcO4Y3HXlFTiOk8PHDi4MnUH2
         eu4rO7RuNP1TxkhA9op23fPdIDd5zhBtPCF3VxUcTv+qdgl2s2R7Q7YjbgfImMEwehn0
         DDf4vBePO+m/ZLBk9/0ylevlVcY+4CJiEmExDzxigKBfDjminWAKXpQqpJk/nFAXNliT
         r98rbUhxbLXEli9XqNiApcOMK2LAV83WF7XSRhGj6FHkGDqacWzHseMUlrpYck7C2hmy
         zGsVcRM4u9odo84oyO8z8Xa8JZRUwS/BxHvxr5voS9rJJbXfaRmtW8AkmNgZeWmL4HY4
         FPAA==
X-Gm-Message-State: AOJu0YyF0BWaiGgRhoxPE94sCtexZpBSWSF6SSOnvyQpKw1dI/2fz1co
        8gJGSc6YOzX5HLcV4f+Hj/4/kgybSq0=
X-Google-Smtp-Source: AGHT+IFp+LTH9npXEjs/1d2uWaJ2Iby3f5ds3ITjQw3ui5uG7WO/lw9pU/ntkNGzNgHnvRB4LmRqE+3SzG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:727:b0:583:5039:d4a0 with SMTP id
 bt7-20020a05690c072700b005835039d4a0mr37589ywb.0.1692369224191; Fri, 18 Aug
 2023 07:33:44 -0700 (PDT)
Date:   Fri, 18 Aug 2023 07:33:42 -0700
In-Reply-To: <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
Mime-Version: 1.0
References: <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
Message-ID: <ZN+BRjUxouKiDSbx@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
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

On Thu, Aug 17, 2023, Eric Wheeler wrote:
> On Thu, 17 Aug 2023, Sean Christopherson wrote:
> > > > kprobe:handle_ept_violation
> > > > {
> > > > 	printf("vcpu =3D %lx pid =3D %u MMU seq =3D %lx, in-prog =3D %lx, =
start =3D %lx, end =3D %lx\n",
> > > > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > > > }
> > > >=20
> > > > If you don't have BTF info, we can still use a bpf program, but to =
get at the
> > > > fields of interested, I think we'd have to resort to pointer arithm=
etic with struct
> > > > offsets grab from your build.
> > >=20
> > > We have BTF, so hurray for not needing struct offsets!
>=20
> Well, I was part right: not all hosts have BTF.
>=20
> What is involved in doing this with struct offsets for Linux v6.1.x?

Unless you are up for a challenge, I'd drop the PID entirely, getting that =
will
be ugly.

For the KVM info, you need the offset of "kvm" within struct kvm_vcpu (more=
 than
likely it's '0'), and then the offset of each of the mmu_invaliate_* fields=
 within
struct kvm.  These need to come from the exact kernel you're running, thoug=
h unless
a field is added/removed to/from struct kvm between kernel versions, the of=
fsets
should be stable.

A cheesy/easy way to get the offsets is to feed offsetof() into __aligned a=
nd
then compile.  So long as the offset doesn't happen to be a power-of-2, the
compiler will yell.  E.g. with this

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92c50dc159e8..04ec37f7374a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -543,7 +543,13 @@ struct kvm_hva_range {
  */
 static void kvm_null_fn(void)
 {
+       int v __aligned(offsetof(struct kvm_vcpu, kvm));
+       int w __aligned(offsetof(struct kvm, mmu_invalidate_seq));
+       int x __aligned(offsetof(struct kvm, mmu_invalidate_in_progress));
+       int y __aligned(offsetof(struct kvm, mmu_invalidate_range_start));
+       int z __aligned(offsetof(struct kvm, mmu_invalidate_range_end));
=20
+       v =3D w =3D x =3D y =3D z =3D 0;
 }
 #define IS_KVM_NULL_FN(fn) ((fn) =3D=3D (void *)kvm_null_fn)

I get yelled at with (trimmed):

arch/x86/kvm/../../../virt/kvm/kvm_main.c:546:34: error: requested alignmen=
t =E2=80=980=E2=80=99 is not a positive power of 2 [-Werror=3Dattributes]
arch/x86/kvm/../../../virt/kvm/kvm_main.c:547:20: error: requested alignmen=
t =E2=80=9836960=E2=80=99 is not a positive power of 2
arch/x86/kvm/../../../virt/kvm/kvm_main.c:549:20: error: requested alignmen=
t =E2=80=9836968=E2=80=99 is not a positive power of 2
arch/x86/kvm/../../../virt/kvm/kvm_main.c:551:20: error: requested alignmen=
t =E2=80=9836976=E2=80=99 is not a positive power of 2
arch/x86/kvm/../../../virt/kvm/kvm_main.c:553:20: error: requested alignmen=
t =E2=80=9836984=E2=80=99 is not a positive power of 2

Then take those offsets and do math.  For me, this provides the same output=
 as
the above pretty version.  Just use common sense and verify you're getting =
sane
data.

kprobe:handle_ept_violation
{
	$kvm =3D *((uint64 *)((uint64)arg0 + 0));

	printf("vcpu =3D %lx MMU seq =3D %lx, in-prog =3D %lx, start =3D %lx, end =
=3D %lx\n",
	       arg0,
               *((uint64 *)($kvm + 36960)),
               *((uint64 *)($kvm + 36968)),
               *((uint64 *)($kvm + 36976)),
               *((uint64 *)($kvm + 36984)));
}

