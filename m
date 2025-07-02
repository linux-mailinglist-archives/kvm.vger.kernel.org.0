Return-Path: <kvm+bounces-51289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9F5AF13C1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C93701C407ED
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767BF267B12;
	Wed,  2 Jul 2025 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RtLo8O63"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD10267713
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 11:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751455395; cv=none; b=cuPH/mHMFqNPRTPQQqL09E7PR0FtfeoUf5kOcoLt2FCHEaIc+aMeoGgyogI8mpHeD1aThV/Yd9fJZ6xjdY8nNvC7i/HycD16qmCFCuppX8LLcKL5w5/BitEE/vVkgtw+BOTkGMy9LeUO45nrPHL+5YKTtthoZ+wMbK0rStAVASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751455395; c=relaxed/simple;
	bh=fjRlJ4DzFF+9vFIv5QBTW8zXtpAOf3fpL7VwXdFMW/c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cK2HBGWz/fXdP4ErYYDHLwHL3L5ZBxTYfU/xSddPDo4sjSHa4f5wcIfBM7h4bYDr12574wrazELrXB83/74xWVCMPXgZMyCrtWcIE06EKRpn0mWQRK+Do5NsZ9X/XFTljw5KK/lvn1DlmWDFgTjY6e3GS7puZ/OnXfRw5nUtJmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RtLo8O63; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751455392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8yqFJS7T2pzVp8H2HNUpAV0xUHAdmoZbS+ig8L+N38=;
	b=RtLo8O63XhY2Q6GYNVTNYETJNQcF5G+/bvoZKlVFK8A47hPCTL/PoQc0sgK4moLTTEio0w
	deTRWOamHOJtmA5HJV4mR8AQkiFBJ/b4hwtyMHDrsweMzyn6tZKXathD7yxU7Vz9MtJzSJ
	S8B7ahEcHPWALLCxo+Y948KgsI7izb8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-k1T-d8v1N-KM3fqGus0nlg-1; Wed, 02 Jul 2025 07:23:11 -0400
X-MC-Unique: k1T-d8v1N-KM3fqGus0nlg-1
X-Mimecast-MFC-AGG-ID: k1T-d8v1N-KM3fqGus0nlg_1751455390
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-453a5d50b81so19312085e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 04:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751455390; x=1752060190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8yqFJS7T2pzVp8H2HNUpAV0xUHAdmoZbS+ig8L+N38=;
        b=PjhmBBti9qab2D0VHI7jpI7LN3yN3rl8GTRpSmiogshznnMAsAZNUt4PC2A2Fmz5JF
         WkF2lok6mJ1clvID4c0A0zwNaJ05BKdNgdRojpHCr2rm3j6sRCr7LyVSQA3MN2GbqGZm
         UZFkYovilHQ7SiHD9XuDc4877NtknI7Mt8TE3qEeqJKwCf1ivnnJWfV/VqSJorngHrRz
         0wUu65vr4eSk7KluD0xEKawdeF1uLjdsEtcJxxRgZA7s+9N3H68hnUU4xVUihIf8sVOv
         ha1tGVZrTHrdw2/d4hyEjlzHFRrqzpMCvWhgN2HYY2yW5o719O25M5dA724fLfnX0oWY
         PuBA==
X-Forwarded-Encrypted: i=1; AJvYcCUJSb3c+ANbtbplVsdeUezXe4jOjgNEy7PQB8dqLGxEgcOWHUarOYvZgP1pucH/0UV6sEs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlMww0LqOFC5+7OcmdnW4Ng3Yxd98JlpNefXMTnVQYH8viJ1kS
	atW7MmDUPyuatj/oM9xKMn0j5pvMZgdXp4O2Bz7BvP+DWgpdPE8+RGSHzvlUeRcva9ipUaOLBAu
	vFMN+n+7IKPnyVTY+A4udCt4XCr0CLxmUs34DmfZS1FM9KAWHv4MYuQ==
X-Gm-Gg: ASbGncsjRmgCTrv3tvHQK9FY1p3comOtl0eDMVaCvsX99EBu4jypXCKoNDzxDGlBzwc
	pG8zGwtbb4A9g9h+U4l/m67pphtoLITKYP9yYcFhWsRbhjzxQ3aNwWvzD3guJ44TzJ6JqTWT87b
	TJ2brK/YEjv3TPGg0+y2Fjp0/N/fwgLQN0h5Q7cv8cI9h+1RxwU2CcQDvR5o8Zg7e4GqNGyhGof
	Rd4W3M5Q7fasQCHsixlSLvmtNaZiq8ggv6p+NQjqu6AnGOklVkDUem9NYTH1C02XnRO4Gj4HaOb
	nKpGSsdoB73w
X-Received: by 2002:a05:600c:8b22:b0:453:1e14:6387 with SMTP id 5b1f17b1804b1-454a4e1c2d0mr13588635e9.32.1751455390101;
        Wed, 02 Jul 2025 04:23:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJF3cGjOKUfJ0j9WgQHOufxJLqjKaO2THVF2AcMDHMH0fjo5rJxkwGemPPZ4hLXqnX52gyWg==
X-Received: by 2002:a05:600c:8b22:b0:453:1e14:6387 with SMTP id 5b1f17b1804b1-454a4e1c2d0mr13588315e9.32.1751455389619;
        Wed, 02 Jul 2025 04:23:09 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a3a57c2sm195024455e9.12.2025.07.02.04.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 04:23:09 -0700 (PDT)
Date: Wed, 2 Jul 2025 13:23:07 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>, qemu-devel@nongnu.org,
 pbonzini@redhat.com, qemu-stable@nongnu.org, boris.ostrovsky@oracle.com,
 maciej.szmigiero@oracle.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <20250702132307.71e3b783@fedora>
In-Reply-To: <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
	<aGO3vOfHUfjgvBQ9@intel.com>
	<c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
	<aGPWW/joFfohy05y@intel.com>
	<20250701150500.3a4001e9@fedora>
	<aGQ-ke-pZhzLnr8t@char.us.oracle.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Jul 2025 16:01:21 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Tue, Jul 01, 2025 at 03:05:00PM +0200, Igor Mammedov wrote:
> > On Tue, 1 Jul 2025 20:36:43 +0800
> > Zhao Liu <zhao1.liu@intel.com> wrote:
> >  =20
> > > On Tue, Jul 01, 2025 at 07:12:44PM +0800, Xiaoyao Li wrote: =20
> > > > Date: Tue, 1 Jul 2025 19:12:44 +0800
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be adve=
rtised
> > > >  on AMD
> > > >=20
> > > > On 7/1/2025 6:26 PM, Zhao Liu wrote:   =20
> > > > > > unless it was explicitly requested by the user.   =20
> > > > > But this could still break Windows, just like issue #3001, which =
enables
> > > > > arch-capabilities for EPYC-Genoa. This fact shows that even expli=
citly
> > > > > turning on arch-capabilities in AMD Guest and utilizing KVM's emu=
lated
> > > > > value would even break something.
> > > > >=20
> > > > > So even for named CPUs, arch-capabilities=3Don doesn't reflect th=
e fact
> > > > > that it is purely emulated, and is (maybe?) harmful.   =20
> > > >=20
> > > > It is because Windows adds wrong code. So it breaks itself and it's=
 just the
> > > > regression of Windows.   =20
> > >=20
> > > Could you please tell me what the Windows's wrong code is? And what's
> > > wrong when someone is following the hardware spec? =20
> >=20
> > the reason is that it's reserved on AMD hence software shouldn't even t=
ry
> > to use it or make any decisions based on that.
> >=20
> >=20
> > PS:
> > on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
> > guest would actually complicate QEMU for no big reason. =20
>=20
> The guest is not misbehaving. It is following the spec.

that's not how I read spec:

"
AMD64 Architecture Programmer=E2=80=99s Manual Volume 3: General-Purpose an=
d System Instructions
24594=E2=80=94Rev. 3.36=E2=80=94March 2024
...
Appendix E Obtaining Processor Information Via the CPUID Instruction
...
All bit positions that are not defined as fields are
reserved. The value of bits within reserved ranges cannot be relied upon to=
 be zero.
Software must mask off all reserved bits in the return value prior to makin=
g any value comparisons of represented
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
information.
...
E.3.6 Function 7h=E2=80=94Structured Extended Feature Identifiers
...
The value returned in EDX is undefined and is reserved.
"

what actually happens is guest side being lazy and blindly following CPUID.


> > Also
> > KVM does do have plenty of such code, and it's not actively preventing =
guests from using it.
> > Given that KVM is not welcoming such change, I think QEMU shouldn't do =
that either. =20
>=20
> Because KVM maintainer does not want to touch the guest ABI. He agrees
> this is a bug.
one can say both guest and hypervisor are to blame,
  1st is not masking reserved bits
  2nd provides 'hybrid' cpu that doesn't exists in real world,
  but then 'host' cpu model has never been the exact match for physical cpu.

what I dislike is ad-hoc fixups in generic code,=20
if consensus were to implement _out of spec_ fixup for already fixed issue =
in Windows,
it should be better be done in host cpumodel code.

Or even better a single KVM optin feature 'do_not_advertise_features_not_su=
pported_by_host_cpu',
and then QEMU could use that for disabling all nonsense in one go.
Plus all of that won't be breaking KVM ABI nor qemu had to add fixups for t=
his and that feature.

After some time when old machine types are deprecated/gone, KVM could make =
it default and eventually
remove advertising 'fake' features.

PS:
On QEMU side we usually tolerant to such fixups if it's not fixable on gues=
t side.
but that's not the case here.


