Return-Path: <kvm+bounces-65207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B81FC9F280
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 422B74E2331
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7722FB987;
	Wed,  3 Dec 2025 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/jLlF1E";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gverl2jn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA642ED846
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768999; cv=none; b=cjGS7vUXrk/BSRw37GtXv7fVczSoXdcXNzNn6BXUb4Ibb+dX2u0hYf1s4Es9lEXuj5L7b2dl/HloEQO+DXqrFFOeqTFI4HLKxEJCEpqLQx7TrRblIuX6GXlLfwSZ5u+i04FVQuCUg2X8I+N9TvS8VUcj3WoyPflYLNgWz/LUkqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768999; c=relaxed/simple;
	bh=6jCCBaNZJU5WxSb9K5Eund10EdCdaWra6lb6uoba4PA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q64Ny+fQh977RTuBgAgQjU8m6zk9q7DaaTQWE0+ZVzTg9voOFBzzKqvxbLgplGcZvMN8ibv2IQ68R2DMjS89eirYv6DF2Et6BFuSyipLnzUC6V4sMd7zl2k4KyZAemeXmsP19fXfImgNZV1WnFluZ4Ycd9Jb3xG5ZjrudHOPLVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/jLlF1E; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gverl2jn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764768996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jCCBaNZJU5WxSb9K5Eund10EdCdaWra6lb6uoba4PA=;
	b=V/jLlF1EutYnsXGaRnskAClmDYHsiw7ybuH2CajAIesVQ3eE4gF4AvYODfXyU3PLthdeJI
	zW3RDybEKBCCMKUgEsnwtS/vIz2Bf8j/sAihKNSLtTMOtmepjUltcVRzITQe2KC3K2JY53
	OQJkIFQJQEe/Ju4TW6MzBQRPwGcUIBA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-2J9MGz_5PtSqBcWWAKs8dg-1; Wed, 03 Dec 2025 08:36:35 -0500
X-MC-Unique: 2J9MGz_5PtSqBcWWAKs8dg-1
X-Mimecast-MFC-AGG-ID: 2J9MGz_5PtSqBcWWAKs8dg_1764768994
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso4014275f8f.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 05:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764768994; x=1765373794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jCCBaNZJU5WxSb9K5Eund10EdCdaWra6lb6uoba4PA=;
        b=Gverl2jn1ZYmTqzxT4Hy5t09TL+08ourBTKJspStC6/6c9BXLVWcBkDA8WcOTck+VS
         OPzF3LM3fu4eRhzRS88iK3GfvhW7CN/iNBThTXgzfEfvPqwsORhdHj5bb80pnRn/HXbm
         J2vOIyaA5onxo99DSCF2w3B0566NvIYhG80/Xwodi+jsJzT+gGSZt7z026d/ilrZzEEz
         2NPInZLU9pl3QXHv76VgTPdrz+E04kzZWcMEVXUI1PCKx2+RUG6r21CWGdXJhx9E7Jc8
         5Y52dpGQS3Jk5lPOYcldSA6GJiuvTFYjCqq/TauLc65HNnfe8rsbdUV0lW0dZ5NCz5Qe
         4h9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764768994; x=1765373794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jCCBaNZJU5WxSb9K5Eund10EdCdaWra6lb6uoba4PA=;
        b=mstmdHb0IuYzDy333B09gLve90EC9K0wgxfnUuHQvuSRu+6Gnc267yWf8BcK4W3yEa
         RaYo8Owh3189uJbe26lc/Uc9hoza7Ni0iOaLN4SafHFNWHmWX9OvRkE4vTa2twUsNi41
         y4h6C7yvyLv0ktxrDu/OVW0HZjbD8xf0uM23o86mAXskvmn1ZdzXJ6iyDvVdG6h3q1oE
         QbO0+jXm56EBZJWPuXgk/ZR0hffBPTHj7fZjEGODDpN7t/39KA69tsBD5eAHuVEGRd65
         i6RV7jaV6WZYs99Xq7mKAd8Tfj70kt+wE1lj27KRNrLsVR/j+8WHW3GioPlKhyZisi5u
         P/7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEhlV3pr8frEhznsNYUyUO0jdKi1M+kWN4vDHSI01M5tFab8AG3FudaO/aF8PfMLVpCOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyZ1431R32aFyr0xnz4mTDM2GbVbRNFAl/MnVxhwQd0wTCPCg+
	NTeuXnwB+GhWqb8Jhq5kGzbhpjVFCvxzsKtFdxhV4YzQ+fsRTPjUse4m/YZtzYTIgPOdDjwY3ma
	wYD5d0B/NPYHG9KBbEcW5DSZiCDD0lZaph4jzRNg2fMGnEAvmh6hSV69oObUg0SIQP6wlyfMC8q
	bwBNicKMM4HUX/+qaHigq2wrElO8D0
X-Gm-Gg: ASbGncv4xUzfA3a7+Md2DXILRGn/7K0Hu49/TuxLVOvvZvovk4S9S2hY/AO4GLsv/u0
	7Tqy7lsm2RKHXZ5ihvcSY+ue/htyumRpS6BPU3inskq/8pcP3hDGoY4eKPMHIUqdumNUGnKgK19
	3AkasnzWTP/vn9dLRumcVC8dsJrPc0hQpoldaywb4acxAhxwocJ7gCZL6XByte88BTHvSUUu/5V
	mzi76ORdmKDqfzDaQcHD15VMZ1SijdfMJNonUj1tes2WSuZUbRZjLoeUHa8QRG/EiRYDhA=
X-Received: by 2002:a5d:5d0a:0:b0:429:d350:8012 with SMTP id ffacd0b85a97d-42f73169a67mr2814259f8f.8.1764768993646;
        Wed, 03 Dec 2025 05:36:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8ul8k/QcqGB6AdGCUOW+7jMqU4BwLqiakTBoBLT38ncgaRO04/ix8YjYWh8dhqvS4idTCs8JS4yFlZQecDrg=
X-Received: by 2002:a5d:5d0a:0:b0:429:d350:8012 with SMTP id
 ffacd0b85a97d-42f73169a67mr2814237f8f.8.1764768993244; Wed, 03 Dec 2025
 05:36:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com> <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
 <aS8I6T3WtM1pvPNl@google.com> <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
 <aS8Vhb66UViQmY_Q@google.com> <352e189ec40fae044206b48ca6e68d77df7dced1.camel@intel.com>
 <d3b8fd036f05e9819f654c18853ff79a255c919d.camel@infradead.org>
 <CABgObfa3wNsQBjAwWuBhWQbw4FuO7TGePuNzfqAYS1CzRFP6DQ@mail.gmail.com> <176b8e96123231baf0f18009d27e82688eac1ead.camel@infradead.org>
In-Reply-To: <176b8e96123231baf0f18009d27e82688eac1ead.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 3 Dec 2025 14:36:20 +0100
X-Gm-Features: AWmQ_bmtt9FZ_Em_B7VTNu8aJ2Uz-w6j7YUQER24ocYeyFkXtE--_jdNiDzPFZ8
Message-ID: <CABgObfbSWZUMS8cMvYQE9FpeWjk=Lam+A_ysQvaJqL5LQ4fYag@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, 
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Kohler, Jon" <jon@nutanix.com>, "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 2:32=E2=80=AFPM David Woodhouse <dwmw2@infradead.org=
> wrote:
> > That would make it impossible to use the fixed implementation on the
> > local APIC side, without changing the way the IOAPIC appears to the
> > guest.
>
> Yes, but remember that "the fixed implementation on the local APIC
> side" means precisely that it's fixed to *not* broadcast the EOI. Which
> means you absolutely *need* to have an I/O APIC capable of receiving
> the explicit directed EOI, or the EOI will never happen at all.
>
> Which is why it probably makes sense to drop the 'version_id' field
> from the struct where I'd added it, and just make the code report a
> hard-coded version based on suppress_eoi_broadcast being enabled:
>
> (kvm->arch.suppress_eoi_broadcast =3D=3D KVM_SUPPRESS_EOI_ENABLED) ? 0x20=
: 0x11
>
> So yes, it's a guest-visible change, but only if the VMM explicitly
> *asks* for the broadcast suppression feature to work, in which case
> it's *necessary* anyway.

I see what you mean and I guess you're right... "Setting X will cause
the in-kernel IOAPIC to report version 0x20" is as obscure as it gets,
but then so is "Setting X will break guests unless you tell in-kernel
IOAPIC to report version 0x20".

So this is good, but the docs need to say clearly that this should
only be set if either full in-kernel irqchip is in use or, for split
irqchip, if the userspace IOAPIC implements directed EOI correctly.

Paolo


