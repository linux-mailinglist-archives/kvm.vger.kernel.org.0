Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6B366E864
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 22:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjAQV07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 16:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjAQVZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 16:25:38 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F8577CA;
        Tue, 17 Jan 2023 11:44:49 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id a3so9984691ilp.6;
        Tue, 17 Jan 2023 11:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JIbNrskGEup5Zw9WnSDYstYuiQFrpRXeEKVLHFV3c0=;
        b=Un29ENV3PsO12mZsz1Cpw3Y/IMp3vk04r584klcjOGzNX+sa8IW8/Wuxt0OQ6D7Gw4
         C1MXZ9FLRoZd859hYPW5w9pEKpvOvMAonjV50zSROBh753cvTyMOWKuwnutfICmWlDFa
         3hiBekqoQ1z7Nk6DaEkOPb45ekRp5h0EMrb1L1ZgHJz2MmpHCVgInSbYQhjm0LUWZrtq
         7DcvhB4WaKTWwBD5dir6jWbXvc1WhNzZMuas7skehZH+PWR55EnoReTUMBeqekUK0zoP
         q+ecv690GH8Z1oRgQZhmdEsAyZD+d+y9gJ1qTgf7jILwnnIU+2gNXkW/s2Zoba8XckCm
         8cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JIbNrskGEup5Zw9WnSDYstYuiQFrpRXeEKVLHFV3c0=;
        b=l7rfoMpfFM6gMh8dARugXhGZskv2OGUwzdMB2rCY87dbrTOCkn7rEJlgkSC1dkk6pY
         GMW6fMaHsMBgvEsgxx8Qw0ikzMPee/91VDUcCy3SrGaJiUr46yz6Ev3ixaAs1NtYhcX/
         zlErW/LwD63NVYAqzUgIDE4ZS3IRXtyM7KI5NtDXVstU3I9pGwGq4cga8hFYPZ7rN2ya
         sPRPiK/TXqM+QgZA9vmoou0PfLyp9c3Nv5HuVPgBIlYAF4UBRKwp4g542q8A4nW1Tonp
         iJ9AxPVL/xBdmKGP339JwLAWj9hmtroRT932xQvqHBeGUhAlqMK1gPhkfmBWW94QAq7j
         0U2g==
X-Gm-Message-State: AFqh2krckBkMsd6JTUfClb0ZkWHQtnzW4Qz2p2Dgjjl3zCopUjDYjo+R
        jOO0bmNeJlsjqo8TBdA9jNA=
X-Google-Smtp-Source: AMrXdXtmzuxLQLKp1Cxoe2DdLdH+nQqgx5k4CpKJfmDeOkEgKxXNEHTIQcZD6PbeFLCzWIsJweqEpQ==
X-Received: by 2002:a92:9501:0:b0:30e:f03e:a76e with SMTP id y1-20020a929501000000b0030ef03ea76emr624301ilh.2.1673984660274;
        Tue, 17 Jan 2023 11:44:20 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b0030c332915aasm9428093ilq.49.2023.01.17.11.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 11:44:19 -0800 (PST)
Date:   Tue, 17 Jan 2023 21:44:14 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230117214414.00003229@gmail.com>
In-Reply-To: <Y8bFCb+rs25dKcMY@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
        <20230113151258.00006a6d@gmail.com>
        <Y8F1uPsW56fVdhmC@google.com>
        <20230114111621.00001840@gmail.com>
        <Y8bFCb+rs25dKcMY@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 15:55:53 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Sat, Jan 14, 2023, Zhi Wang wrote:
> > On Fri, 13 Jan 2023 15:16:08 +0000 > Sean Christopherson <seanjc@google=
.com> wrote:
> >=20
> > > On Fri, Jan 13, 2023, Zhi Wang wrote:
> > > > Better add a FIXME: here as this has to be fixed later.
> > >=20
> > > No, leaking the page is all KVM can reasonably do here.  An improved
> > > comment would be helpful, but no code change is required.
> > > tdx_reclaim_page() returns an error if and only if there's an
> > > unexpected, fatal error, e.g. a SEAMCALL with bad params, incorrect
> > > concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point=
 is
> > > highly unlikely to be successful.
> >=20
> > Hi:
> >=20
> > The word "leaking" sounds like a situation left unhandled temporarily.
> >=20
> > I checked the source code of the TDX module[1] for the possible reason =
to
> > fail when reviewing this patch:
> >=20
> > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_=
reclaim.c
> > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_=
wbinvd.c
> >=20
> > a. Invalid parameters. For example, page is not aligned, PA HKID is not=
 zero...
> >=20
> > For invalid parameters, a WARN_ON_ONCE() + return value is good enough =
as
> > that is how kernel handles similar situations. The caller takes the
> > responsibility.
> > =20
> > b. Locks has been taken in TDX module. TDR page has been locked due to =
another
> > SEAMCALL, another SEAMCALL is doing PAMT walk and holding PAMT lock...=
=20
> >=20
> > This needs to be improved later either by retry or taking tdx_lock to a=
void
> > TDX module fails on this.
>=20
> No, tdx_reclaim_page() already retries TDH.PHYMEM.PAGE.RECLAIM if the tar=
get page
> is contended (though I'd question the validity of even that), and TDH.PHY=
MEM.PAGE.WBINVD
> is performed only when reclaiming the TDR.  If there's contention when re=
claiming
> the TDR, then KVM effectively has a use-after-free bug, i.e. leaking the =
page is
> the least of our worries.
>=20

Hi:

Thanks for the reply. "Leaking" is the consquence of even failing in retry.=
 I
agree with this. But I was questioning if "retry" is really a correct and o=
nly
solution when encountering lock contention in the TDX module as I saw that =
there
are quite some magic numbers are going to be introduced because of "retry" =
and
there were discussions about times of retry should be 3 or 1000 in TDX guest
on hyper-V patches. It doesn't sound right.

Compare to an typical *kernel lock* case, an execution path can wait on a
waitqueue and later will be woken up. We usually do contention-wait-and-ret=
ry
and we rarely just do contention and retry X times. In TDX case, I understa=
nd
that it is hard for the TDX module to provide similar solutions as an execu=
tion
path can't stay long in the TDX module.

1) We can always take tdx_lock (linux kernel lock) when calling a SEAMCALL
that touch the TDX internal locks. But the downside is we might lose some
concurrency.

2) As TDX module doesn't provide contention-and-wait, I guess the following
approach might have been discussed when designing this "retry".

KERNEL                          TDX MODULE

SEAMCALL A   ->                 PATH A: Taking locks

SEAMCALL B   ->                 PATH B: Contention on a lock

             <-                 Return "operand busy"

SEAMCALL B   -|
              |  <- Wait on a kernel waitqueue
SEAMCALL B  <-|

SEAMCALL A   <-                 PATH A: Return

SEAMCALL A   -|
              |  <- Wake up the waitqueue
SEMACALL A  <-|=20

SEAMCALL B  ->                  PATH B: Taking the locks
...

Why not this scheme wasn't chosen?

>=20
> On Thu, Jan 12, 2023 at 8:34 AM <isaku.yamahata@intel.com> wrote:
> > +static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
> > +{
> > + =A0 =A0 =A0 struct tdx_module_output out;
> > + =A0 =A0 =A0 u64 err;
> > +
> > + =A0 =A0 =A0 do {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D tdh_phymem_page_reclaim(pa, &out);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* TDH.PHYMEM.PAGE.RECLAIM is allowed o=
nly when TD is shutdown.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* state. =A0i.e. destructing TD.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* TDH.PHYMEM.PAGE.RECLAIM =A0requires =
TDR and target page.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Because we're destructing TD, it's r=
are to contend with TDR.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 } while (err =3D=3D (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RC=
X));
> > + =A0 =A0 =A0 if (WARN_ON_ONCE(err)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err=
, &out);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> > + =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 if (do_wb) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Only TDR page gets into this path. =
=A0No contention is expected
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* because of the last page of TD.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D tdh_phymem_page_wbinvd(set_hkid_t=
o_hpa(pa, hkid));
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (WARN_ON_ONCE(err)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_tdx_error(TDH_PHYMEM_P=
AGE_WBINVD, err, NULL);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 }
> > +
> > + =A0 =A0 =A0 tdx_clear_page(pa);
> > + =A0 =A0 =A0 return 0;
> > +}

