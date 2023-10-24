Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DFE7D5963
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343984AbjJXRHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjJXRHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:07:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E6AC2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:07:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9caf486775so5491699276.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698167234; x=1698772034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOKT7eBtwEJ4k1HBPZS+t7LF5MXiuApZ3Dql347Aiik=;
        b=TbJx3tTnHx1lOsRXBSI25Lo8rtv7TOptkH2xDqRnE9aR3mt9CbNbHYDOEUgQXr8HH2
         6HigF7jv/EJ5wnsqfoDpSJQ01VW2FP7kfZhU5J+WpfwCQq6EGlKOfYktmj7m2fas5HWu
         rxLbxTqA7M6EkG6hVtk6+KuHfZ/Ej1Dmtw2T9ueZASqYjvhgDl/cPoy1YhLRNS3k8Tnt
         bhPrR0BLLKlDWDvpmgUIp6m0VDp8bgiGeB1gXAKt79ekXzfBJ7P/kdtHRQGPqd80K8XE
         MEaHr2h9/0Ugur0pHlNpNk3KPZ5JHM4CwJw+bBykWZSHT+UMqgn3NbXqGj9H3exAG5yG
         oTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698167234; x=1698772034;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GOKT7eBtwEJ4k1HBPZS+t7LF5MXiuApZ3Dql347Aiik=;
        b=D6J0A+7PqUlgscKuhfW4DO8KQxe935v84J7fh9gR4PruAVr+UhUo+f8g8WhfNQHcx4
         KXYJUoDLIB0XHjzeUORCo5NFp83IS51AA8sptL8GXvvfTy6UMjyinUEw+MDQoVoTvsHc
         1QACe4oWyjIEkrkKa1gtZ9/ta0rOo2ZqobRwImoVddIFbhkQEpNjUTAX+eYQmhO8iznw
         FGUyO0s8WIPemCxFpSnMrvDIxcRqfN1ExYNcnrO0lLrDGIdhY2UD2C+a+jCpAq2y7JX9
         BHsSUZ4AQv2ZWrEtafBkD2estwXpGGVNnp8VlZ2drTLitKC5NYF2RPYWXjjRdfmBdG41
         tFaw==
X-Gm-Message-State: AOJu0Yy9RjgLT9HkyWBOGeXuoX5pjUR39q2LH0W4m6U8ags6cNfmT5S5
        aitZJa0sfgNDXSXTHZ8PIJ7TE5vSHsY=
X-Google-Smtp-Source: AGHT+IFrvhm6CQzoWfCnOT8xnCe29kvGqRLP3KCWFWsXgigZgrlixJQBNXS+VkjIM6Ajz24QhucNgzwaUVM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8e05:0:b0:d74:93a1:70a2 with SMTP id
 p5-20020a258e05000000b00d7493a170a2mr258000ybl.5.1698167234230; Tue, 24 Oct
 2023 10:07:14 -0700 (PDT)
Date:   Tue, 24 Oct 2023 10:07:12 -0700
In-Reply-To: <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com> <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
Message-ID: <ZTf5wPKXuHBQk0AN@google.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
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

On Fri, Sep 15, 2023, Weijiang Yang wrote:
> On 9/15/2023 1:40 AM, Dave Hansen wrote:
> > On 9/13/23 23:33, Yang Weijiang wrote:
> > > --- a/arch/x86/kernel/fpu/xstate.c
> > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > @@ -1636,9 +1636,17 @@ static int __xstate_request_perm(u64 permitted=
, u64 requested, bool guest)
> > >   	/* Calculate the resulting kernel state size */
> > >   	mask =3D permitted | requested;
> > > -	/* Take supervisor states into account on the host */
> > > +	/*
> > > +	 * Take supervisor states into account on the host. And add
> > > +	 * kernel dynamic xfeatures to guest since guest kernel may
> > > +	 * enable corresponding CPU feaures and the xstate registers
> > > +	 * need to be saved/restored properly.
> > > +	 */
> > >   	if (!guest)
> > >   		mask |=3D xfeatures_mask_supervisor();
> > > +	else
> > > +		mask |=3D fpu_kernel_dynamic_xfeatures;

This looks wrong.  Per commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervi=
sor
states in XSTATE permissions"), mask at this point only contains user featu=
res,
which somewhat unintuitively doesn't include CET_USER (I get that they're M=
SRs
and thus supervisor state, it's just the name that's odd).

IIUC, the "dynamic" features contains CET_KERNEL, whereas xfeatures_mask_su=
pervisor()
conatins PASID, CET_USER, and CET_KERNEL.  PASID isn't virtualized by KVM, =
but
doesn't that mean CET_USER will get dropped/lost if userspace requests AMX/=
XTILE
enabling?

The existing code also seems odd, but I might be missing something.  Won't =
the
kernel drop PASID if the guest request AMX/XTILE?  I'm not at all familiar =
with
what PASID state is managed via XSAVE, so I've no idea if that's an actual =
problem
or just an oddity.

> > >   	ksize =3D xstate_calculate_size(mask, compacted);
> > Heh, you changed the "guest" naming in "fpu_kernel_dynamic_xfeatures"
> > but didn't change the logic.
> >=20
> > As it's coded at the moment *ALL* "fpu_kernel_dynamic_xfeatures" are
> > guest xfeatures.  So, they're different in name only.

...

> > Would there ever be any reason for KVM to be on a system which supports=
 a
> > dynamic kernel feature but where it doesn't get enabled for guest use, =
or
> > at least shouldn't have the FPU space allocated?
>=20
> I haven't heard of that kind of usage for other features so far, CET
> supervisor xstate is the only dynamic kernel feature now,=C2=A0 not sure =
whether
> other CPU features having supervisor xstate would share the handling logi=
c
> like CET does one day.

There are definitely scenarios where CET will not be exposed to KVM guests,=
 but
I don't see any reason to make the guest FPU space dynamically sized for CE=
T.
It's what, 40 bytes?

I would much prefer to avoid the whole "dynamic" thing and instead make CET
explicitly guest-only.  E.g. fpu_kernel_guest_only_xfeatures?  Or even bett=
er
if it doesn't cause weirdness elsewhere, a dedicated fpu_guest_cfg.  For me=
 at
least, a fpu_guest_cfg would make it easier to understand what all is going=
 on.=20
