Return-Path: <kvm+bounces-3149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 312378010B8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1516E1C20D42
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D8B4D59D;
	Fri,  1 Dec 2023 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="srJMT7xc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6CC1;
	Fri,  1 Dec 2023 09:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1701450520; x=1732986520;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=LWxdWq/DOS+9khhxJvYujS6PdOihOZyDd4a2PGV9kvA=;
  b=srJMT7xc+Fvc62twit9fGUpSKTXlJnvtKFcvzhoGFTHfxL6a8gN2sAsG
   TVySOIPUzxqA5u4sfWdreiQvanPkMLnXiZHsxlUW6CELrmTPSR21XJlLE
   RklBfKPLkpg2zlZpf6bMqDpwaJG0Zi2rk1TslbDDqhZW6GFxYtn17yoYL
   0=;
X-IronPort-AV: E=Sophos;i="6.04,242,1695686400"; 
   d="scan'208";a="366070872"
Subject: RE: [PATCH 0/2] KVM: xen: update shared_info when long_mode is set
Thread-Topic: [PATCH 0/2] KVM: xen: update shared_info when long_mode is set
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 17:08:37 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id C88C24964F;
	Fri,  1 Dec 2023 17:08:33 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:28276]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.35:2525] with esmtp (Farcaster)
 id caf748da-6362-4926-9a93-c13b544c9c90; Fri, 1 Dec 2023 17:08:33 +0000 (UTC)
X-Farcaster-Flow-ID: caf748da-6362-4926-9a93-c13b544c9c90
Received: from EX19D032EUC003.ant.amazon.com (10.252.61.137) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 17:08:32 +0000
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19D032EUC003.ant.amazon.com (10.252.61.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 17:08:32 +0000
Received: from EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174]) by
 EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174%3]) with mapi id
 15.02.1118.040; Fri, 1 Dec 2023 17:08:32 +0000
From: "Durrant, Paul" <pdurrant@amazon.co.uk>
To: Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
CC: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHaJEOuWnzn0NGSpk+GH7VJCEKIN7CUozuAgAAF5dA=
Date: Fri, 1 Dec 2023 17:08:32 +0000
Message-ID: <a0c99edd584b47ce8f9f8aff86b2a568@amazon.co.uk>
References: <20231201104536.947-1-paul@xen.org> <ZWoNzzYiZtloNQiv@google.com>
In-Reply-To: <ZWoNzzYiZtloNQiv@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 01 December 2023 16:46
> To: Paul Durrant <paul@xen.org>
> Cc: David Woodhouse <dwmw2@infradead.org>; Paolo Bonzini <pbonzini@redhat=
.com>; Thomas Gleixner
> <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov <bp=
@alien8.de>; Dave Hansen
> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin <hpa@zytor.=
com>; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [EXTERNAL] [PATCH 0/2] KVM: xen: update shared_info when lon=
g_mode is set
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open
> attachments unless you can confirm the sender and know the content is saf=
e.
>=20
>=20
>=20
> On Fri, Dec 01, 2023, Paul Durrant wrote:
> > From: Paul Durrant <pdurrant@amazon.com>
> >
> > This series is based on my v9 of my "update shared_info and vcpu_info
> > handling" series [1] and fixes an issue that was latent before the
> > "allow shared_info to be mapped by fixed HVA" patch of that series allo=
wed
> > a VMM to set up shared_info before the VM booted and then leave it alon=
e.
>=20
> Uh, what?   If this is fixing an existing bug then it really shouldn't ta=
ke a
> dependency on a rather large and non-trivial series.  If the bug can only=
 manifest
> as a result of said series, then the fix absolutely belongs in that serie=
s.
>=20

There's been radio silence on that series for a while so I was unsure of th=
e status.

> This change from patch 1 in particular:
>=20
>  -static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool add=
r_is_gfn)
>  +static int kvm_xen_shared_info_init(struct kvm *kvm)
>=20
> practically screams for inclusion in that series which does:
>=20
>  -static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>  +static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool add=
r_is_gfn)
>=20
> Why not get the code right the first time instead of fixing it up in a co=
mpletely
> different series?

Sure, I can fold it in.

  Paul


