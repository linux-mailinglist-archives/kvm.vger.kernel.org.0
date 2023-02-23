Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6536A1187
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 21:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBWUzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 15:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBWUzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 15:55:48 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC79311E5
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:55:47 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i7-20020a626d07000000b005d29737db06so3741275pfc.15
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vtKxLOTXMPagT2gk71/UgHlBFryS+YgJvqgLcrPGUYU=;
        b=gb5TllJufQrujZZJFv3Fi1/bDB2FiTSuLKOcWqg1o4hYG/wBYkBAbX/8YUs2zMizk4
         zFBcphvKp9zv+PiIJkB2MzGudkf8HW3T2TcGCR5xtmd0K1DZmrV9Ty00MktQNnbn4I9B
         LLWeHMeHSkhSSN/IU0zRWPTWGRMn1cODoteRQOApnM9GS49koZpTRz3VZn5cySfSAi8y
         0MGUFVFCFEPXTY25NCyxP4O8M/+gmIhTjswzHsc3eSX56jbHQPtrfq5Y3pgL94jz9VA4
         iY8M9y2xJsAPCQmlH2No+GRoEmn40A6cU6UUmebMKU5fHyHkqlHxpC02Q89A4e0Ysizp
         E1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vtKxLOTXMPagT2gk71/UgHlBFryS+YgJvqgLcrPGUYU=;
        b=w7cF+sQwalZx6nFOQ3ARbMuOOHPrGP13queA6pmcS36dNl0DfZ/TUCx8j+zo7ThfZm
         VT4B3DcbxiDsmFNdIi+LLERJt6Lf1Bnq2np4HKhep5muteB8GVDD1P7Orjry0Eq9Io3j
         zit1Pl09nxZJhsm0rEwGDScVdZwAXNLK++OK3Z6PiocQUy15ELOrHmIlAOO1SefhO2r/
         DCqwpmG7xP9DWZ/mnp0q/RFs3aWs+kHSJmIgqXAbJ9x+81/Dswzt0vkTOGtDOuwqSPep
         /TnjDN7dyyaJ4fNOcnxjPzwYtbFn2M2R5BOre5ZQjzrePdvbLcyk0Y8Ms/VxX0mUWj/r
         DBVg==
X-Gm-Message-State: AO0yUKWdkbtRlE+NwQbjqC++YycS0XoJXI+uItTUE8NRx4EDaYDc7CPo
        e5NDVBZ25br8U5Sl/64Ez+pU79B04Ls=
X-Google-Smtp-Source: AK7set8Z+tRJCca6EIlkoIzgKHYXmlfKlsmpDyclRerxVneTs0hvNc+Jt4RsXPvRvFU/9THPJr7Dvuqtp5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:ce0c:0:b0:5aa:72b4:2fe1 with SMTP id
 y12-20020a62ce0c000000b005aa72b42fe1mr2238863pfg.1.1677185746691; Thu, 23 Feb
 2023 12:55:46 -0800 (PST)
Date:   Thu, 23 Feb 2023 12:55:45 -0800
In-Reply-To: <CAF7b7mpMiw=6o6vTsqFR6HUUCJL+1MSTDUsMaKLnS1NqyVf-9A@mail.gmail.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
 <Y+/kgMxQPOswAz/2@google.com> <CAF7b7mpMiw=6o6vTsqFR6HUUCJL+1MSTDUsMaKLnS1NqyVf-9A@mail.gmail.com>
Message-ID: <Y/fS0eab7GG0NVKS@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023, Anish Moorthy wrote:
> On Fri, Feb 17, 2023 at 12:33=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote
> > > > > I don't think flags are a good idea for this, as it comes with th=
e
> > > > > illusion that both events can happen on a single exit. In reality=
, these
> > > > > are mutually exclusive.
> >
> > They aren't mutually exclusive.  Obviously KVM will only detect one oth=
er the
> > other, but it's entirely possible that a guest could be accessing the "=
wrong"
> > flavor of a page _and_ for that flavor to not be faulted in.  A smart u=
serspace
> > should see that (a) it needs to change the memory attributes and (b) th=
at it
> > needs to demand the to-be-installed page from the source.
> >
> > > > > A fault type/code would be better here, with the option to add fl=
ags at
> > > > > a later date that could be used to further describe the exit (if
> > > > > needed).
> > > >
> > > > Agreed.
> >
> > Not agreed :-)
> > ...
> > Hard "no" on a separate exit reason unless someone comes up with a very=
 compelling
> > argument.
> >
> > Chao's UPM series is not yet merged, i.e. is not set in stone.  If the =
proposed
> > functionality in Chao's series is lacking and/or will conflict with thi=
s UFFD,
> > then we can and should address those issues _before_ it gets merged.
>=20
> Ok so I have a v2 of the series basically ready to go, but I realized
> that I should
> probably have brought up my modified API here to make sure it was
> sane: so, I'll do
> that first
>=20
> In v2, I've
> (1)  renamed the kvm cap from KVM_CAP_MEM_FAULT_NOWAIT to
> KVM_CAP_MEMORY_FAULT_EXIT due to Sean's earlier comment
>=20
> > gup_fast() failing in itself isn't interesting.  The _intended_ behavio=
r is that
> > KVM will exit if and only if the guest accesses a valid page that hasn'=
t yet been
> > transfered from the source, but the _actual_ behavior is that KVM will =
exit if
> > the page isn't faulted in for _any_ reason.  Even tagging the access NO=
WAIT is
> > speculative to some degree, as that suggests the access may have succee=
ded if
> > KVM "waited", which may or may not be true.
>=20
> (2) kept the definition of kvm_run.memory_fault as
> struct {
>     __u64 flags;
>     __u64 gpa;
>     __ u64 len;
> } memory_fault;
> which, apart from the name of the "len" field, is exactly what Chao
> has in their series.

Off-topic, please adjust whatever email client you're using to not wrap so
agressively and at seeming random times.

As written, this makes my eyes bleed, whereas formatting like so does not :=
-)

  Ok so I have a v2 of the series basically ready to go, but I realized tha=
t I
  should probably have brought up my modified API here to make sure it was =
sane:
  so, I'll do that first

  ...

  which, apart from the name of the "len" field, is exactly what Chao
  has in their series.

  Flags remains a bitfield describing the reason for the memory fault:
  in the two places this series generates this fault, it sets a bit in flag=
s.
  Userspace is meant to check whether a memory_fault was generated due to
  KVM_CAP_MEMORY_FAULT_EXIT using the KVM_MEMORY_FAULT_EXIT_REASON_ABSENT m=
ask.

> flags remains a bitfield describing the reason for the memory fault:
> in the two places
> this series generates this fault, it sets a bit in flags. Userspace is
> meant to check whether
> a memory_fault was generated due to KVM_CAP_MEMORY_FAULT_EXIT using the
> KVM_MEMORY_FAULT_EXIT_REASON_ABSENT mask.

Before sending a new version, let's bottom out on whether or not a
KVM_MEMORY_FAULT_EXIT_REASON_ABSENT flag is necessary.  I'm not dead set ag=
ainst
a flag, but as I called out earlier[*], it can have false positives.  I.e. =
userspace
needs to be able to suss out the real problem anyways.  And if userspace ne=
eds to
be that smart, what's the point of the flag?

[*] https://lore.kernel.org/all/Y+%2FkgMxQPOswAz%2F2@google.com

>=20
> (3) switched over to a memslot flag: KVM_CAP_MEMORY_FAULT_EXIT simply
> indicates whether this flag is supported.

The new memslot flag should depend on KVM_CAP_MEMORY_FAULT_EXIT, but
KVM_CAP_MEMORY_FAULT_EXIT should be a standalone thing, i.e. should convert=
 "all"
guest-memory -EFAULTS to KVM_CAP_MEMORY_FAULT_EXIT.  All in quotes because =
I would
likely be ok with a partial conversion for the initial implementation if th=
ere
are paths that would require an absurd amount of work to convert.

> As such, trying to enable the new capability directly generates an EINVAL=
,
> which is meant to make the incorrect usage clear.
>=20
> Hopefully this all appears sane?

