Return-Path: <kvm+bounces-1205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D51C7E5861
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB34928162A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85C3199B1;
	Wed,  8 Nov 2023 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="J1PLexps"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C7D171CF;
	Wed,  8 Nov 2023 14:10:31 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EC81BF9;
	Wed,  8 Nov 2023 06:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699452630; x=1730988630;
  h=mime-version:content-transfer-encoding:date:message-id:
   subject:from:to:cc:references:in-reply-to;
  bh=MFQWqbJrx3q4UkY+AjnTnmXALeaOK7/a+F2/vcRtMtA=;
  b=J1PLexpsx/77udTFv1760Z8EnhF07k3kqFn99pRsOHD9/GvqdSGc8zZF
   QxKLUASBnr1Qt8u7Dd3mMDo1TsQ2jpGut9fwHNUFTZTxY+Rt0zOcSaFMi
   z+QAEv89k5D1aHNHlDwkSrC4LyjZ0nsb0gtbR97IsuImkNqFu96TRjEOm
   g=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366846401"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 14:10:27 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 06AFE40BB6;
	Wed,  8 Nov 2023 14:10:25 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:25152]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.247:2525] with esmtp (Farcaster)
 id f28800e5-7aba-421e-8c7f-cbf093c0af36; Wed, 8 Nov 2023 14:10:24 +0000 (UTC)
X-Farcaster-Flow-ID: f28800e5-7aba-421e-8c7f-cbf093c0af36
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 14:10:24 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 14:10:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 8 Nov 2023 14:10:16 +0000
Message-ID: <CWTHOA1Z96FB.16IGGD2MN12OS@amazon.com>
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Alexander Graf <graf@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-6-nsaenz@amazon.com>
 <5fcefdf3-d1ff-4244-8b58-1da0cd7e4a4f@amazon.com>
In-Reply-To: <5fcefdf3-d1ff-4244-8b58-1da0cd7e4a4f@amazon.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 11:53 AM UTC, Alexander Graf wrote:

[...]

> > @@ -285,6 +286,81 @@ static int patch_hypercall_page(struct kvm_vcpu *v=
cpu, u64 data)
> >   	/* ret */
> >   	((unsigned char *)instructions)[i++] =3D 0xc3;
> >  =20
> > +	/* VTL call/return entries */
> > +	if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
>
>
> You don't introduce kvm_hv_vsm_enabled() before. Please do a quick test=
=20
> build of all individual commits of your patch set for v1 :).

Yes, sorry for that. This happens for a couple of helpers, I'll fix it.

> Why do you need the ifdef here? is_long_mode() already has an ifdef that=
=20
> will always return false for is_64_bit_mode() on 32bit hosts.

Noted, will remove.

> > +		if (is_64_bit_mode(vcpu)) {
> > +			/*
> > +			 * VTL call 64-bit entry prologue:
> > +			 * 	mov %rcx, %rax
> > +			 * 	mov $0x11, %ecx
> > +			 * 	jmp 0:
> > +			 */
> > +			hv->vsm_code_page_offsets.vtl_call_offset =3D i;
> > +			instructions[i++] =3D 0x48;
> > +			instructions[i++] =3D 0x89;
> > +			instructions[i++] =3D 0xc8;
> > +			instructions[i++] =3D 0xb9;
> > +			instructions[i++] =3D 0x11;
> > +			instructions[i++] =3D 0x00;
> > +			instructions[i++] =3D 0x00;
> > +			instructions[i++] =3D 0x00;
> > +			instructions[i++] =3D 0xeb;
> > +			instructions[i++] =3D 0xe0;
>
>
> I think it would be a lot easier to read (because it's denser) if you=20
> move the opcodes into a character array:
>
> char vtl_entry[] =3D { 0x48, 0x89, 0xc8, 0xb9, 0x11, 0x00, 0x00, 0x00.=20
> 0xeb, 0xe0 };
>
> and then just memcpy().

Works for me, I'll rework it.

Nicolas

