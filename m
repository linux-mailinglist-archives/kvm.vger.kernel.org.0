Return-Path: <kvm+bounces-11530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4AD877E70
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A494282A8A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25859374CF;
	Mon, 11 Mar 2024 10:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icAeRD0J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97302207A
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710154541; cv=none; b=tV5lST94FhjYZKaLyC4G4TXMSH5MbXnN3c43XntV9ZcL8hgGF1byTQ2RX1YATL8yANrXGUrqDuyCn00yqQm8ODKYHmOxhL0oc17MfWHslFw3axzkV3TjVjOB+dMVrg30NytLb4bGTJoIcIQgNHDNSyPTcFoRfOR8ETJy3OIWY+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710154541; c=relaxed/simple;
	bh=2DJCeIreCtc/HbnhYe65l6hWq88M5YgdSQ4XKm2m0zY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZMlaXz7/+NNZCY5cBPiwBnZ1eRMwgUfkyV/Lq+F0qQJUVn9jq41EcDvVgWZBE5DjTjGaXXOMG4VZ/Ot2sVrxiOyOrtKKYDB91l1JvRz9Lyuz8SSueXOWZZtyeDmZ1mEBy/MLmp/pWe7BPR49PHJNAxr+a3z1QIfKfq79MGA0ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icAeRD0J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710154538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EKLfNinsugPgo1c9nFFEWQfwl4qtOWnF6NPRgJPm0tE=;
	b=icAeRD0JKyEqu79UhLE9tS+Yuk+e+d6MxjrxXRj2pTaGDXUbgf0EFHtrE5ApP3pATBrzU2
	Kb14pgltXNH7GCpFBXjDnIJcSs8i9aWlLu14R6EHXVQGFrUiCy+cT9F880VR7WMgxswNlx
	y2HmHKPzfTZzSe7cM+2hYT9arYojj9g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-U08qDnJhOxyl15Of1-kMQw-1; Mon, 11 Mar 2024 06:55:37 -0400
X-MC-Unique: U08qDnJhOxyl15Of1-kMQw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d8d208be9so1831372f8f.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 03:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710154536; x=1710759336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EKLfNinsugPgo1c9nFFEWQfwl4qtOWnF6NPRgJPm0tE=;
        b=Fi+zp08EFmxL9jyv/oRbKCdMeQhgsfXOaqMUT324vlVFY9btlNsD6adscxiwAEveqk
         H2pmB4KLwaSAz+3tEyCHCNjGM+FOaUgOYVwSh4k1V+AlEunErdqFM+j1sE/QwN7NmdAq
         9CNoJmVk0REJOrhZ6vy/jwwHIP4O+ekcqlS0aVZYH3JHHaVTEzJ6hUrMu9RbljiTnmxh
         hyktXmsBq3NSZR/7leuYYYEGW0pvD7C3fKW/BcJ4KrVbepZiHodvMgdC9x8G7LpPgQYS
         0NIeKVUVDfyw/9GjbNLpd16WD4TfiQV1DhEUiosWEae/6n7Ds5zweHxL+skHhmICuEeX
         Wbkg==
X-Forwarded-Encrypted: i=1; AJvYcCUSbz8H85NFHzmolhoCommoAof1eQuqO7Rvt4sNox4jaT+aQk45q/M3f0iscte8EDKgb9l8EKiMHWQYe4FY40gvghKl
X-Gm-Message-State: AOJu0YwLyPdd0LJ4tMoeGqsH2G3RSGQdUx1wIMqzpZu84ET2URPgJgBJ
	fvcWGrouklNcLzbA9E9GfwSw8++QPeX8OMAwwoA9cAScemja4nFUeueet4MY0q16q0fbNkjq0+0
	WMg2UEYxJlbBiHclbRowC+UPA/uoPX903KBduF3qHbhWalGz12YiPvlMb+Rme+LaT+n9LiXSVWa
	M6sXUsQiTvAvhsxrWsuLkfyzE6
X-Received: by 2002:a5d:4561:0:b0:33e:78d2:7f7 with SMTP id a1-20020a5d4561000000b0033e78d207f7mr4004274wrc.55.1710154536316;
        Mon, 11 Mar 2024 03:55:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELvTkNiWzZC7Zkz0N4AKIUHVo/Xeko8sEFJTK5TnsT3SHw1+nxSrBrSR/dQ6A7wyj0Hnlad5BFyTNR/YlN+o0=
X-Received: by 2002:a5d:4561:0:b0:33e:78d2:7f7 with SMTP id
 a1-20020a5d4561000000b0033e78d207f7mr4004260wrc.55.1710154536013; Mon, 11 Mar
 2024 03:55:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305105233.617131-1-kraxel@redhat.com> <20240305105233.617131-3-kraxel@redhat.com>
In-Reply-To: <20240305105233.617131-3-kraxel@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 11 Mar 2024 11:55:23 +0100
Message-ID: <CABgObfZ13WEHaGNzjy0GVE2EAZ=MHOSNHS_1iTOuBduOt5q_3g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 11:52=E2=80=AFAM Gerd Hoffmann <kraxel@redhat.com> w=
rote:
>
> Query kvm for supported guest physical address bits, in cpuid
> function 80000008, eax[23:16].  Usually this is identical to host
> physical address bits.  With NPT or EPT being used this might be
> restricted to 48 (max 4-level paging address space size) even if
> the host cpu supports more physical address bits.
>
> When set pass this to the guest, using cpuid too.  Guest firmware
> can use this to figure how big the usable guest physical address
> space is, so PCI bar mapping are actually reachable.
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/cpu.h     |  1 +
>  target/i386/cpu.c     |  1 +
>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>  3 files changed, 19 insertions(+)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..d427218827f6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> +    guest_phys_bits =3D kvm_get_guest_phys_bits(cs->kvm_state);
> +    if (guest_phys_bits &&
> +        (cpu->guest_phys_bits =3D=3D 0 ||
> +         cpu->guest_phys_bits > guest_phys_bits)) {
> +        cpu->guest_phys_bits =3D guest_phys_bits;
> +    }

Like Xiaoyao mentioned, the right place for this is kvm_cpu_realizefn,
after host_cpu_realizefn returns. It should also be conditional on
cpu->host_phys_bits. It also makes sense to:

- make kvm_get_guest_phys_bits() return bits 7:0 if bits 23:16 are zero

- here, set cpu->guest_phys_bits only if it is not equal to
cpu->phys_bits (this undoes the previous suggestion, but I think it's
cleaner)

- add a property in x86_cpu_properties[] to allow configuration with TCG.

Paolo

> +
>      /*
>       * kvm_hyperv_expand_features() is called here for the second time i=
n case
>       * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibl=
y handle
> --
> 2.44.0
>


