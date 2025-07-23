Return-Path: <kvm+bounces-53312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBEDB0FA85
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 156834E2267
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29832264B9;
	Wed, 23 Jul 2025 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BC4zVDUT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763DB1A255C
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753296957; cv=none; b=N/kfjmxk2grRb+NhaeJJ7ht1iAC6/XvN+uL6bO26b9ZKeeqZ2W9EcttMp7xAtmK0mwr4hGwYRjeUtY1k9qfpx9wgCMBF5bDQnJ0gb7kMnwpZtinOq276Dws0ZT6M141I9fwXbUwre1ehRaKadFmbtDe9DdxjOdeDImHP1rhpVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753296957; c=relaxed/simple;
	bh=Vh2bpELVG2CxMoGWIIyObo3qKcF89FKVkUbdh7gGHCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oa/rVb8MDi3Eyy+Jm1ynvbAwGErFRTuFcsffdWnb2o58J5D1ofDLMlmPUCRAQdJpiAeGVYWEql1M0CXl1OZe+6WMOpyDpfyAj2BMlyJrLHno9qPMqnHVj64ta3ETVSTn1ZQnk4QCHsRYAGxw+Dmj/fDlgm4SD1hRZeCeGmj1+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BC4zVDUT; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74913385dd8so327158b3a.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753296955; x=1753901755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEql4lCCTW1Ifr0adVTaMkUoVb1pJx1jzjwjCrergC8=;
        b=BC4zVDUTiXYfuFiTY2dkVUXd630VdRJyvL8VuM78dJU/RjyWi8w7fJRFVqs3RG+dNc
         ueY02WUNw0ivfbJ1pz7yECAlZhX+w5sbXMhu4Ku9f/UniFuQopxckWMklDcwd7ggHKrE
         IYYOyE/0rA49C94zcbrOO9FMG+/27WWp/xGNmcGpZ/6WhM/91eZG34glofVrrVpLvgwy
         Bczo06U7sM/1Gglwv9q/t2Rc36x3/gl2hagIIrIc4slv6Ydvhs+PnOTWg318yVm8afuX
         xBomyrP7nZeG8TydDFnvXsISodVslhyfhrA2frLHXWc+Ebn0/2xnk7lsxn2WHyLbLLHs
         Qlvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753296955; x=1753901755;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rEql4lCCTW1Ifr0adVTaMkUoVb1pJx1jzjwjCrergC8=;
        b=RSrTSayoB7BfQPdcY7CLPayVYzsy6j+6JTiFo9zSLhRBYc/PMrc5gty2Evy81AhocO
         dvjyQHw/8/gQE63g2JSPc20TaP7ACI/dqx4xcBK5NsFGL8aJvWKutbfNA0tVt8sZpSgr
         ldECs6ig8++DnF4j8d6ReVPVS9hd9SxaPrdxupLoDJnTYAKuCBctPyjykeNG5EbXxFH3
         FiJ1MGVnFbbI8DjzFWDQP2rRbst4pn9siEZy2QGKma0bvKc74S4dT0o+dB2Z3rFcw3m0
         B4RBSy9LRsl+9RHCnsYsR4BxdISeBDGibEpsnms9zMnso1+nUl53xsPUHGelZxo3dPbr
         Uvrg==
X-Forwarded-Encrypted: i=1; AJvYcCUH+0ldZS7VXULxwOAuwurQBibLOM+SiO4H6fs9AVo0K/Xavu4b8pNIQq7J1fmta/V2dks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1mclNfaJMXc5ACL3FEUlEzEravfUu94Td/dMYG3KgVFoDv/t8
	4hylB2+XzZZwVNeIT4PlMEiDm0S5GicMP7Ucv5arXf6kFzcGT/Gwo615vpTjCP2q25C6Wbx8EMQ
	bdK/BoQ==
X-Google-Smtp-Source: AGHT+IEI7undIZBUtGTMoVAFM+LMhz9On3SXFHelwKZQgX+SCthgAL+5iCIY2PzLdGdyEqEpZcJ7vqeNCUQ=
X-Received: from pfbhr20-n2.prod.google.com ([2002:a05:6a00:6b94:20b0:747:abae:78e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:339b:b0:232:1f25:7965
 with SMTP id adf61e73a8af0-23d48fe74c4mr5803785637.5.1753296954851; Wed, 23
 Jul 2025 11:55:54 -0700 (PDT)
Date: Wed, 23 Jul 2025 18:55:53 +0000
In-Reply-To: <CABQX2QMj=7HnTqCsKHpcypyfNsMYumYM7NH_jpUvMbgbTH=ZXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-2-zack.rusin@broadcom.com> <aIEgVpjXDR0BXgHq@google.com>
 <CABQX2QMj=7HnTqCsKHpcypyfNsMYumYM7NH_jpUvMbgbTH=ZXg@mail.gmail.com>
Message-ID: <aIEwOToiAkKfQA-4@google.com>
Subject: Re: [PATCH v2 1/5] KVM: x86: Centralize KVM's VMware code
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+lists

Please keep all replies on-list, no matter how trivial the question/comment=
.
Pretty much the only time it's ok to take something off-list is if the conv=
ersation
is something that can't/shouldn't be had in public.

On Wed, Jul 23, 2025, Zack Rusin wrote:
> On Wed, Jul 23, 2025 at 1:48=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index 60986f67c35a..b42988ce8043 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -26,6 +26,7 @@
> > >  #include <asm/debugreg.h>
> > >  #include <asm/nospec-branch.h>
> > >  #include <asm/ibt.h>
> > > +#include "kvm_vmware.h"
> >
> > Please sort includes as best as possible.  KVM's loose rule is to organ=
ize by
> > linux =3D> asm =3D> local, and sort alphabetically within each section,=
 e.g.
> >
> > #include <linux/aaaa.h>
> > #include <linux/blah.h>
> >
> > #include <asm/aaaa.h>
> > #include <asm/blah.h>
> >
> > #include "aaaa.h"
> > #include "blah.h"
>=20
> Yea, that's what I do in my code but in this case I had no idea where
> to put it because none of the sections in that file are sorted, where
> would you like the include among:
> ```
> #include <linux/kvm_host.h>
> #include "kvm_cache_regs.h"
> #include "kvm_emulate.h"
> #include <linux/stringify.h>
> #include <asm/debugreg.h>
> #include <asm/nospec-branch.h>
> #include <asm/ibt.h>
>=20
> #include "x86.h"
> #include "tss.h"
> #include "mmu.h"
> #include "pmu.h"
> ```
> below kvm_emulate or would you like me to resort all the includes?

Nah, don't bother sorting them all (though that might happen anyways[*]).  =
Just
do your best to not make things worse.  Luckily, 'v' is quite near the end,=
 so I
think the least-awful option will be fairly obvious in all/most cases, e.g.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 78e0064dd73e..9b7e71f4e26f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -26,12 +26,12 @@
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 #include <asm/ibt.h>
-#include "kvm_vmware.h"
=20
 #include "x86.h"
 #include "tss.h"
 #include "mmu.h"
 #include "pmu.h"
+#include "vmware.h"
=20
 /*
  * Operand types
---

[*] https://lore.kernel.org/lkml/aH-dqcMWj3cFDos2@google.com

> > > @@ -2565,8 +2563,8 @@ static bool emulator_io_port_access_allowed(str=
uct x86_emulate_ctxt *ctxt,
> > >        * VMware allows access to these ports even if denied
> > >        * by TSS I/O permission bitmap. Mimic behavior.
> > >        */
> > > -     if (enable_vmware_backdoor &&
> > > -         ((port =3D=3D VMWARE_PORT_VMPORT) || (port =3D=3D VMWARE_PO=
RT_VMRPC)))
> > > +     if (kvm_vmware_backdoor_enabled(ctxt->vcpu) &&
> >
> > Maybe kvm_is_vmware_backdoor_enabled()?  To make it super clear it's a =
predicate.
> >
> > Regarding namespacing, I think for the "is" predicates, the code reads =
better if
> > it's kvm_is_vmware_xxx versus kvm_vware_is_xxx.  E.g. is the VMware bac=
kdoor
> > enabled vs. VMware is the backdoor enabled.  Either way is fine for me =
if someone
> > has a strong preference though.
> >
> > > +         kvm_vmware_io_port_allowed(port))
> >
> > Please separate the addition of helpers from the code movement.  That w=
ay the
> > code movement patch can be acked/reviewed super easily, and then we can=
 focus on
> > the helpers (and it also makes it much easier to review the helpers cha=
nges).
>=20
> Sorry, I'm confused about this one. I find it a lot easier to review
> helpers if I know what code they're supposed to replace and that's
> harder to do if a change is just adding some code without any
> indication of where it's coming from but I'm happy to adjust this in
> whatever way is easiest for you.

All I'm saying is do the initial bulk, pure code movement in a single patch=
,
with no other changes whatsoever.  And then add and rename helpers in a sep=
arate
patch(es).  The add/renames can go before/after the code movement, what I c=
are
most about is isolating the pure code movement.

I'm guessing the cleanest approach would be to do pure code movement, then =
do
renames, and finally add helpers.  That'll require an ugly double move of t=
he
VMWARE_PORT_VMPORT and VMWARE_PORT_VMRPC #defines to vmware.h, and then aga=
in to
vmware.c.  But while annoying, that makes the individual patches super easy=
 to
review and apply.

Holler if it's still unclear, I can put together a quick comple of example =
patches.

